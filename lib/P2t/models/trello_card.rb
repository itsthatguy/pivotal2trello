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
      desc = <<EOS
**URL**: #{pivotal_card.attributes[:url]}
**Owned By**: #{pivotal_card.attributes[:owned_by]}
**Story Type**: #{pivotal_card.attributes[:story_type]}
**Labels**: #{pivotal_card.attributes[:labels]}

### Description
#{pivotal_card.attributes[:desc]}

```
# DO NOT EDIT::START #{pivotal_card.attributes} # DO NOT EDIT::END
```
EOS

      @pivotal_attributes = {:desc => desc,
                             :name => pivotal_card.attributes[:name],
                             :list_id => ENV["STATE_#{pivotal_card.attributes[:current_state].upcase}"]}
    end

    def pivotal_attributes
      regex = /# DO NOT EDIT::START(?<attributes>.*)# DO NOT EDIT::END/m
      regex2 = /^`{1,3}\n# do not edit$\n(?<attributes>.*)\n`{1,3}$/m
      match = regex.match(card.desc) || regex2.match(card.desc)
      if match
        attributes = eval(match[:attributes])
        @pivotal_id = attributes[:id]
      end
      @pivotal_attributes = attributes || {}
    end

    # def card_id
    #   attributes = pivotal_attributes(card.desc)
    #   attributes[:id] if attributes && attributes[:id]
    # end

    def update_from_pivotal_card(pivotal_card)
      puts "=> #{pivotal_card.attributes[:name]}"
      puts "=> #{pivotal_card.attributes[:current_state].upcase}\n\n"
      set_pivotal_attributes(pivotal_card)
      @pivotal_attributes.map { |k, v| @card.send("#{k}=", v) }
      @card.save
    end
  end
end
