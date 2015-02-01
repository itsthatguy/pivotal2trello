module P2t
  class Card
    attr_accessor :id, :card

    def initialize(card)
      @card = card
      @id = card.id
    end
  end
end
