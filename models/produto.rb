class Produto
	include Mongoid::Document
	include Mongoid::Timestamps

  
  field :ingrediente, :type => String
  field :nome, :type => String
  
  default_scope order_by([:update_at, :desc])
end