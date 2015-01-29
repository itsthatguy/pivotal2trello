module P2t
  class TrelloCard < Card
    def initialize(card)
      super
      @pivotal_attributes = {}
      @SYMBOL_TO_STRING = {id: 'id',
                           short_id: 'idShort',
                           name: 'name',
                           desc: 'desc',
                           due: 'due',
                           closed: 'closed',
                           url: 'url',
                           short_url: 'shortUrl',
                           board_id: 'idBoard',
                           member_ids: 'idMembers',
                           cover_image_id: 'idAttachmentCover',
                           list_id: 'idList',
                           pos: 'pos',
                           last_activity_date: 'dateLastActivity',
                           card_labels: 'labels',
                           badges: 'badges',
                           card_members: 'members'}
    end

    def map_attributes(attributes)
      Hash[attributes.map do |k, v|
        [@SYMBOL_TO_STRING[k], v]
      end]
    end

    def pivotal_attributes
      return @pivotal_attributes if @pivotal_attributes
      regex = /^`{1,3}$\n(?<attributes>.*)^`{1,3}$/m
      match = regex.match(card.desc)
      @pivotal_attributes = eval(match[:attributes]) if match
    end

    def card_id
      attributes = pivotal_attributes(card.desc)
      attributes[:id] if attributes && attributes[:id]
    end

    def update_from_pivotal_card(pivotal_card)
      attr = {:desc => "#{pivotal_card.attributes[:desc]}\n\n```\n# do not edit\n#{pivotal_card.attributes}\n```",
              :name => pivotal_card.attributes[:name]}
      attr = map_attributes(@card.attributes.merge(attr))

      @card.update_fields(attr).save
    end

    def update(attributes)
      # options = set_attributes(attributes)

      current_card = card(id)
      puts current_card
      # current_card.update_fields(options).save
    end

  end
end
