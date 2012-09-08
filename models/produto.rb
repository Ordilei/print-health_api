class Produto
  
  field :ingrediente, :type => String
  field :nome, :type => String
  
  default_scope order_by([:update_at, :desc])
end