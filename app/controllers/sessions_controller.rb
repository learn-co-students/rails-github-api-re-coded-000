class SessionsController < ApplicationController
	skip_before_action :authenticate_user
  def create
  	  resp = Faraday.get("https://github.com/login/oauth/access_token") do |req|
       req.params['client_id'] = ENV['Client_ID']
       req.params['client_secret'] = ENV['Client_Secret']
       req.params['redirect_uri'] = "http://localhost:3000/auth"
       req.params['code'] = params[:code]
       req.headers['Accept'] = 'application/json'
     end

    body = JSON.parse(resp.body);#raise body.inspect
    session[:token] = body["access_token"]
    data = Faraday.get("https://api.github.com/user") do |req|

       req.headers['Authorization'] = "token #{session[:token]}"
       req.headers['Accept'] = 'application/json'
    end
    data = JSON.parse(data.body)
    session[:username] = data["login"]

    redirect_to root_path
  end

end