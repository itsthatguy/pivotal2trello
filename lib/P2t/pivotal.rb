require 'pivotal-tracker'
require 'json'
require 'dotenv'
Dotenv.load

module P2t
  class Pivotal

    def initialize(token, project_id)
      ::PivotalTracker::Client.token = token
      @project = ::PivotalTracker::Project.find(project_id)

    end

    def project
      @project
    end

    def cards(options = {})
      @cards = @project.stories.all(options)
    end

    def states
      @cards ||= cards
      @cards.map { |card| card.current_state }.uniq
    end

    def find_with_id(id)
      @cards ||= cards
      @cards.find { |card| card.pivotal_id.to_s == id.to_s }
    end

    def find_with_state(state)
      @cards ||= cards
      @cards.select { |card| card.current_state == state }
    end
  end
end
