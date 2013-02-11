require 'rest-client'
require 'json'

class AstridClient
  attr_reader :app_id, :api_secret, :api_url
  attr_accessor :token

  def initialize(app_id, api_secret)
    @app_id     = app_id
    @api_secret = api_secret
    @api_url    = "https://astrid.com/api/7/"
    @token      = nil
  end

  def user_signin(email, password)
    method = "user_signin"
    params = default_params.merge(
      "email" => email, "secret" => password, "provider" =>  "password"
    )
    response = do_request(:user_signin, params)
    @token = response['token']
  end

  def do_request(method, params = {})
    params = params.merge("token" => token) # token from `user_signin`
    params = default_params.merge(params)
    params = sort_params(params)

    signature = signature(method, params, api_secret)

    response = RestClient.post "#{api_url}#{method}", params.merge(sig: signature)
    response = JSON.parse(response)
    raise response['message'] if response['status'].eql? "error"
    response
  end

  [:time, :list_list, :task_list, :task_save].each do |method_name|
    define_method method_name do |params = {}|
      do_request method_name, params
    end
  end

  private

  def default_params
    { "app_id" => app_id,
      "time"   => Time.now.to_i.to_s }
  end

  def to_query_key_value(hash)
    params = []
    hash.each_with_index do |(key, value), i|
      case value
        when Array
          value.map do |v|
            params << ["#{key}[]", v]
          end
        when Hash
          raise "not implemented"
        else
          params << [key, value]
      end
    end
    params
  end

  def sort_params(params)
    # sort by keys
    # sort inner arrays
    params = params.map do |k, v|
      v.sort! if v.is_a? Array
      [k,v]
    end.sort{|a,b| a[0].to_s <=> b[0].to_s}

    Hash[params]
  end

  def signature(method, params, api_secret)
    str = method.to_s + to_query_key_value(params).flatten.join + api_secret.to_s
    Digest::MD5.hexdigest str
  end
end
