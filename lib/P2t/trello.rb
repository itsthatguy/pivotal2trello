require 'trello'
require 'json'
require 'dotenv'
Dotenv.load

module P2t
  class Trello
    def initialize(key, token)
      @client = ::Trello::Client.new(developer_public_key: key, member_token: token)
      @defaults = {"name"    => "New Card",
                   "idList"  => ENV["STATE_UNSCHEDULED"],
                   "idBoard" => ENV["TRELLO_BOARD_ID"]}
    end

    def client
      @client
    end

    def board
      @client.find(:board, ENV["TRELLO_BOARD_ID"])
    end

    def cards
      @cards = board.cards.map do |card|
        TrelloCard.new(card)
      end
    end

    def lists
      board.lists
    end

    def pretty_lists
      board.lists.map { |l| puts "#{l.attributes[:id]}: #{l.attributes[:name]}" }
    end

    def find_with_id(id)
      @cards ||= cards
      @cards.find { |card| id == card_id(card).to_s }
    end

    def find_with_pivotal_id(id)
      @cards ||= cards
      @cards.find do |card|
        return unless card.pivotal_id
        card.pivotal_id == id.to_s
      end
    end

    def sync_with_pivotal_cards(pivotal_cards)
      pivotal_cards.map do |pivotal_card|
        card = find_with_pivotal_id(pivotal_card.id)
        if card
          puts "Upating card with Pivotal ID: #{pivotal_card.id}"
          card.update_from_pivotal_card(pivotal_card)
        elsif (card == false)
        else
          puts "Could not find a card with the Pivotal ID: #{pivotal_card.id}"
          card = TrelloCard.new(@client.create(:card, @defaults))
          card.update_from_pivotal_card(pivotal_card)
          cards << card
        end
      end
    end
  end
end
