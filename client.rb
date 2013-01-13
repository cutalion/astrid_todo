require 'rest-client'
require 'json'

class AstridClient
  attr_reader :app_id, :api_secret, :api_url, :token

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
    raise response['message'] if response['status'].eql? "error"
    @token = response['token']
  end

  def do_request(method, params = {})
    params = params.merge("token" => token) # token from `user_signin`
    params = default_params.merge(params)

    signature = signature(method, sorted_params(params), api_secret)

    response = RestClient.post "#{api_url}#{method}", params.merge(sig: signature)
    JSON.parse(response)
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

  def sorted_params(params)
    params.sort do |a,b|
      keys_comparison = a[0].to_s <=> b[0].to_s
      if keys_comparison == 0
        a[1].to_s <=> b[1].to_s
      else
        keys_comparison
      end
    end
  end

  def signature(method, params, api_secret)
    str = method.to_s + sorted_params(params).flatten.join + api_secret.to_s
    Digest::MD5.hexdigest(str)
  end
end
