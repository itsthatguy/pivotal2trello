require 'trello'
require 'json'
require 'dotenv'
Dotenv.load

class TrelloFace
  def initialize
    @client = Trello::Client.new(developer_public_key: ENV["TRELLO_DEVELOPER_PUBLIC_KEY"],
                                 member_token:         ENV["TRELLO_MEMBER_TOKEN"])
  end

  def client
    @client
  end

  def board
    @client.find(:board, ENV["TRELLO_BOARD_ID"])
  end

  def cards
    board.cards
  end

  def lists
    board.lists
  end

  def pivotal_attributes(desc)
    regex = /^`{1,3}$\n(?<attributes>.*)^`{1,3}$/m
    match = regex.match(desc)
    eval(match[:attributes]) if match
  end

  def card_id(card)
    attributes = pivotal_attributes(card.desc)
    attributes[:id] if attributes && attributes[:id]
  end

  def create_card(attributes)
    desc = "```\n# do not edit\n#{attributes}\n```"
    options = {
      "name"   => attributes[:name],
      "idList" => "54c7ffcfd0fd1d79a34765ce",
      "desc"   => desc,
      "labels" => attributes[:labels]
    }
    client.create(:card, options)
  end
end
