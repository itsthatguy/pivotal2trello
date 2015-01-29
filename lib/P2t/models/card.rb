module P2t
  class Card
    attr_accessor :id, :card

    def initialize(id, card)
      @id = id
      @card = card
    end
  end
end
