require './lib/pivotal.rb'
require './lib/trello.rb'
require 'json'

class Application

  def initialize
    @pivotal = Pivotal.new
    @trello = TrelloFace.new
  end

  def pivotal
    @pivotal
  end

  def trello
    @trello
  end

  def pivotal_cards_not_in_trello
    trello_cards_ids = @trello.cards.map { |card|
      @trello.card_id(card).to_s
    }.compact

    pivotal_cards_ids = @pivotal.cards({label: 'front-end'}).map { |card|
      @pivotal.card_id(card).to_s
    }.compact

    pivotal_cards_ids - trello_cards_ids
  end

  def create_cards
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
end
