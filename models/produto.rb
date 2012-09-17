class Produto
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :ingrediente, :nome, :desc, :update_at
  
  field :ingrediente, :type => String
  field :nome, :type => String
  
  default_scope order_by([:update_at, :desc])

  def validate_data_e_hora
    if @data_inicio_before_type_cast.present?
      if check_date(@data_inicio_before_type_cast).nil?
        self.errors.add(:data_inicio, "formato inválido")
      end
    end

    if @data_fim_before_type_cast.present?
      if check_date(@data_fim_before_type_cast).nil?
        self.errors.add(:data_fim, "formato inválido")
      end
    end

    return if data_inicio.nil? || data_fim.nil?
    if data_inicio > data_fim
      self.errors.add(:data_inicio, "não pode ser maior que data final")
    end
  end

  def to_md5
    Digest::MD5.hexdigest("#{self.updated_at.try(:to_s)},#{self.to_param}")
  end

end
