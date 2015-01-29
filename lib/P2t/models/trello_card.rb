module Trello
  class Card
  end
end

module P2t
  class TrelloCard < Card

    def pivotal_attributes=(attributes)
      desc = "#{attributes[:desc]}\n\n```\n# do not edit\n#{attributes}\n```"
      @pivotal_attributes = {
        "name"   => attributes[:name],
        "idList" => "54c7ffcfd0fd1d79a34765ce",
        "desc"   => desc,
        "labels" => attributes[:labels]
      }
    end

    def pivotal_attributes
      regex = /^`{1,3}$\n(?<attributes>.*)^`{1,3}$/m
      match = regex.match(card.desc)
      @pivotal_attributes = eval(match[:attributes]) if match
    end

    def card_id
      attributes = self.pivotal_attributes(card.desc)
      attributes[:id] if attributes && attributes[:id]
    end

    def update(attributes)
      # options = set_attributes(attributes)

      current_card = card(id)
      puts current_card
      # current_card.update_fields(options).save
    end

  end
end
