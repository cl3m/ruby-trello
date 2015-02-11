module Trello
  # An Item is a basic task that can be checked off and marked as completed.
  class Item < BasicData
    register_attributes :id, :card_id, :checklist_id, :name, :state, :pos, readonly: [ :id, :card_id, :checklist_id, :pos ]
    validates_presence_of :id, :name, :state
    validates_length_of :name, in: 1..16384

    # Updates the fields of an item.
    #
    # Supply a hash of string keyed data retrieved from the Trello API representing
    # an item.
    def update_fields(fields)
      attributes[:id]           = fields['id']
      attributes[:card_id] = fields['idCard']
      attributes[:checklist_id] = fields['idChecklist']
      attributes[:name]         = fields['name']
      attributes[:state]        = fields['state']
      attributes[:pos]          = fields['pos']
      self
    end
    
    def save
      return update! if id
    end
    
    def update!
      client.put("/cards/#{card_id}/checklist/#{checklist_id}/checkItem/#{id}", {name: name, state: state}).json_into(self)
    end
  end
end