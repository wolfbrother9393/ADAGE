class AdaData
  include Mongoid::Document
  include Mongoid::Timestamps

  before_validation :set_collection

  field :game, type: String
  field :user_id, type: Integer

  index user_id: 1
  index gameName: 1
  index created_at: 1
  index name: 1
  index key: 1, schema: 1

  def user=(user)
    self.user_id = user.id
  end

  def user
    User.find(self.user_id)
  end

  def self.with_game(gameName = "ada_data")
    with(collection: gameName.to_s.gsub(' ', '_'))
  end

  def set_collection
    with(collection: self.gameName.to_s.gsub(' ', '_'))
  end
end