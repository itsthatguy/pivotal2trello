module P2t
  class TrelloCard < Card
    def initialize(card)
      super
      @pivotal_attributes
    end

    def pivotal_id
      @pivotal_id ||= pivotal_attributes[:id].to_s
    end

    def set_pivotal_attributes(pivotal_card)
      @pivotal_attributes = {:desc => "#{pivotal_card.attributes[:desc]}\n\n```\n# do not edit\n#{pivotal_card.attributes}\n```",
                             :name => pivotal_card.attributes[:name],
                             :list_id => ENV["STATE_#{pivotal_card.attributes[:current_state].upcase}"]}
    end

    def pivotal_attributes
      regex = /^`{1,3}$\n(?<attributes>.*)^`{1,3}$/m
      match = regex.match(card.desc)
      if match
        puts "@@ MATCH => #{card.name}"
        attributes = eval(match[:attributes])
        @pivotal_id = attributes[:id]
        @pivotal_attributes = attributes
      end
    end

    def card_id
      attributes = pivotal_attributes(card.desc)
      attributes[:id] if attributes && attributes[:id]
    end

    def update_from_pivotal_card(pivotal_card)
      puts "=> #{pivotal_card.attributes[:current_state].upcase}"
      set_pivotal_attributes(pivotal_card)
      @pivotal_attributes.map { |k, v| @card.send("#{k}=", v) }
      @card.save
    end
  end
end
