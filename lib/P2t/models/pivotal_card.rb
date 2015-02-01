module P2t
  class PivotalCard < Card
    attr_accessor :attributes

    def initialize(card)
      super
      @attributes = {name: card.name,
                     desc: card.description,
                     current_state: card.current_state,
                     estimate: card.estimate,
                     owned_by: card.owned_by,
                     requested_by: card.requested_by,
                     story_type: card.story_type,
                     labels: card.labels,
                     current_state: card.current_state,
                     id: id,
                     url: card.url}
    end
  end
end
