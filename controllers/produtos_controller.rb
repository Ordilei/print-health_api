class ProdutosController < ActionController
  
  before do 
    response["Content-Type"] = "application/json"
    expires 30, :public
  end
  
  helpers do
    def build_request_query_url(url, page, params)
      parameters = params.dup
      paramaters['pw'] = page
      parameters.delete('pw') if page.nil? || page <= 0
      if parameters.empty?
        parameters = ""
      else
        parameters = "?" << parameters.to_query
      end
      "#{url}#{parameters}"
    end
  end
  
  get '/produtos' do 
    tokamak 'produtos/index'.to_sym
  end
  
  get '/produtos/novo' do
    tokamak '/produtos/novo'.to_sym
  end
  
  get '/produtos/busca/descritor' do
    response["Content-Type"] = "application/opensearchdescription+xml"
    erb 'eventos/descritor'.to_sym
  end
  
  get 'produtos/busca' do 
    options = {}
    
    options[:titulo] = params[:q] if params[:q].present?
    [:ingrediente, :nome].each do |param|
      options[param] = params[param] if params[param].present?
    end
    
    page = params[:pw].try(:to_i)
    options[:page] = page if page.present? && page > 0
    per_page = params[:per_page].try(:to_i)
    options[:per_page] = per_page if per_page.present? && per_page > 0
    
    @produto = Produto.search(options)
    tokamak 'eventos/show'.to_sym
  end
  
  get '/produtos/:id' do
    content_type_check
    begin
      @produto = Produto.find(params[:id])
      cache_check(@produto)
      tokamak 'produto/show'.to_sym
    rescue BSON::InvalidObjectId, Mongoid::Errors::DocumentNotFound => e
      status 404 
    end
  end
  
  post '/produtos' do
    content_type_check
    @produto = Produto.new(request_body_json_as_hash[:produto])
    if @produto.save
      status 201
      headers 'Location' => url("/produtos/#{@produto.id}")
      tokamak 'produtos/show'.to_sym
    else
      status 422
      tokamak 'shared/error'.to_sym, {}, :object => @produto
    end
  end
  
  put '/produtos/:id' do
    content_type_check
    begin
      @produto = Produto.find(params[:id])
      updating_current_version?(@produto)
      produto = request_body_json_as_hash[:produto]
      if @produto.update_attributes(produto)
        status 200
        headers 'Location' => url("/produtos/#{@produto.id}")
        tokamak 'produtos/show'.to_sym
      else
        status 422
        tokamak 'shared/error'.to_sym, {}, :object => @produto
      end
      status 404
      rescue BSON::InvalidObjectId, Mongoid::Errors::DocumentNotFound
    end
  end
  
  delete '/produtos/:id' do
    begin
      if @produto = Produto.find(params[:id])
        @produto.destroy
        status 204
        return
      end
      
      status 422
      tokamak 'shared/error'.to_sym, {}, :object => @produto
      rescue BSON::InvalidObjectId, Mongoid::Errors::DocumentNotFound
        status 404
    end
  end
  
end