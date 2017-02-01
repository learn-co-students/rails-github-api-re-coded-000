class RepositoriesController < ApplicationController
  def index
    data = Faraday.get("https://api.github.com/user/repos") do |req|

       req.headers['Authorization'] = "token #{session[:token]}"
       req.headers['Accept'] = 'application/json'
    end
    @repos = JSON.parse(data.body)
  end

  def create
    response = Faraday.post("https://api.github.com/user/repos", {name: params[:name]}.to_json, 
    	{Authorization: "token #{session[:token]}", Accept: 'application/json'})
    redirect_to root_path
  end
end
