require 'trello'
require 'json'
require 'dotenv'
Dotenv.load

module P2t
  class Trello
    def initialize(key, token)
      @client = ::Trello::Client.new(developer_public_key: key, member_token: token)
    end

    def client
      @client
    end

    def board
      @client.find(:board, ENV["TRELLO_BOARD_ID"])
    end

    def cards
      @cards = board.cards.map do |card|
        TrelloCard.new(card.id, card)
      end
    end

    def lists
      board.lists
    end

    def find_with_id(id)
      @cards ||= cards
      @cards.find { |card| id == card_id(card).to_s }
    end

    def find_with_pivotal_id(id)
      @cards ||= cards
      @cards.find do |card|
        card.pivotal_attributes[:id].to_s == id.to_s
      end
    end

    def sync_with_pivotal_cards(pivotal_cards)
      pivotal_cards.map do |pivotal_card|
        card = find_with_pivotal_id(pivotal_card.id)
        if card
          card.pivotal_attributes = pivotal_card.attributes
        else
          raise "Could not find a card with the Pivotal ID: #{pivotal_card.id}"
        end
      end
    end
  end
end
