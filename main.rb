# frozen_string_literal: true

require 'sinatra'
require 'httparty'
require 'dotenv'
require_relative 'client/github'
Dotenv.load

get '/' do
  erb :index
end

get '/repos' do
  response.headers['Content-Type'] = 'text/vnd.turbo-stream.html; charset=utf-8'
  @repos = GitHub.get_response(params[:search], logger)
  erb :repos
rescue StandardError => e
  logger.error "Error handling request: #{e}"
  erb :error
end
