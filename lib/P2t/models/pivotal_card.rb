module PivotalTracker
  class Story
  end
end

module P2t
  class PivotalCard < Card
    attr_accessor :attributes

    def initialize(id, card)
      super
      @attributes = {name: card.name,
                     desc: card.description,
                     current_state: card.current_state,
                     estimate: card.estimate,
                     owned_by: card.owned_by,
                     requested_by: card.requested_by,
                     story_type: card.story_type,
                     labels: card.labels,
                     id: id,
                     url: card.url}
    end
  end
end
