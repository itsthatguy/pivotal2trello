require 'ruby-trello'
require 'json'
require 'dotenv'
Dotenv.load

class Trello

  def initialize
    Trello::Client.new(
      developer_public_key: ENV["TRELLO_DEVELOPER_PUBLIC_KEY"],
      member_token:         ENV["TRELLO_MEMBER_TOKEN"])
  end

  def cards(options = {})
  end
end
