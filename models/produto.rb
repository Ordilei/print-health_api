class Produto
  include Mongoid::Document
  include Mongoid::Timestamps
  include BasicDomainApi::PrimitiveValidation
  include BasicDomainApi::ConteudosRelacionados
  include BasicDomainApi::Categorias
  include BasicDomainApi::Status

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

  # Responsável por buscar Eventos e retornar um Array "Paginado".
  # Opções disponíveis:
  # * <tt>:titulo</tt> - busca por titulo
  # * <tt>:rotulos_controlados</tt> - busca por um ou mais rotulos controlados. Ex. :rotulos_controlados => "rotulo 1, rotulo 2"
  # * <tt>:marca</tt> - busca por marca
  # * <tt>:status</tt> - Padrão "disponivel". Opções disponíveis: rascunho, disponivel, todos
  # * <tt>:order</tt> - Opcional. Ex: "data_inicio desc, nome asc"
  # * <tt>:page</tt> - página atual, padrão é 1
  # * <tt>:per_page</tt> - limite de items por página, padrão é 10

  # Busca Evento por slug.
  # Caso o evento não exista, retorna *nil*
  def self.find_by_slug(slug)
    where(:slug => slug).first
  end

  private

  def check_date(value)
    return value unless value.is_a?(String)
    return nil unless value.match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/)  #ex: 2011-11-01T00:00:00Z
    begin
      Time.parse(value)
      DateTime.parse(value)
    rescue ArgumentError => ex
      nil
    end
  end

end
