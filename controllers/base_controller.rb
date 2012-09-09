class BaseController < Sinatra::Base

  helpers do
    def request_body_json_as_hash
      begin
        @request_body ||= MultiJson.decode(request.body, :symbolize_keys => true)
      rescue MultiJson::DecodeError => e
        status 400
        halt tokamak 'shared/bad_request'.to_sym
      end
    end
    
    def content_type_check
      unless request.content_type == "application/json"
        headers 'Content-Type' => 'application/json'
        status 415
        halt tokamak 'shared/unsupported_media_type'.to_sym
      end
    end
    
    def updating_current_version?(object)
      # ETag vindo da requisição tem aspas "a mais", ou seja, a string fica algo
      # como "\"de1f47efa8be71ef17feb"\" em Ruby, o que é um porre para fazer o
      # matching. Por isso o current_tag fica entre aspas. -- lsdr
      current_etag = '"%s"' % object.to_md5      
      if current_etag != if_match_or_halt
        headers 'ETag' => current_etag
        status 409
        halt
      end
    end
  end

  protected
  
  def if_match_or_halt
    if_match = env.fetch('HTTP_IF_MATCH', "")
    if_match.empty? ? halt(412) : if_match
  end

end