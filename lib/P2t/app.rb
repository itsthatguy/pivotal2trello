require './lib/P2t/pivotal'
require './lib/P2t/trello'
require './lib/P2t/models/card'
require './lib/P2t/models/pivotal_card'
require './lib/P2t/models/trello_card'
require 'json'
require 'pry'

module P2t
  class Application
    attr_accessor :pivotal, :trello

    def initialize(console = false)
      @pivotal = Pivotal.new(ENV["PIVOTAL_API_TOKEN"], ENV["PIVOTAL_PROJECT_ID"])
      @trello = Trello.new(ENV["TRELLO_DEVELOPER_PUBLIC_KEY"], ENV["TRELLO_MEMBER_TOKEN"])
      binding.pry if console
    end

    def pivotal_cards
      @pivotal.cards({label: 'front-end'}).map { |card|
        PivotalCard.new(card)
      }.compact
    end

    def pivotal_cards_not_in_trello
      pivotal_cards - trello_cards
    end

    def create_trello_cards
      pivotal_cards_not_in_trello.each do |id|
        story = @pivotal.project.stories.find(id)
        attributes = {
          name: story.name,
          desc: story.description,
          current_state: story.current_state,
          estimate: story.estimate,
          owned_by: story.owned_by,
          requested_by: story.requested_by,
          story_type: story.story_type,
          labels: story.labels,
          id: id,
          url: story.url
        }

        puts @trello.create_card(attributes)
      end
    end

    def update_trello_cards
      trello.sync_with_pivotal_cards(pivotal_cards)
    end
  end
end
