require 'sinatra'
require 'sinatra/base'
require 'haml'
require_relative 'check_number'

# Rubocop: Top-level class documentation missing
class Caya < Sinatra::Base
  include CheckNumber

  get '/' do
    haml :index
  end

  get '/single_check' do
    haml :single_check
  end

  post '/single_check' do
    @period = params[:period]
    @number = params[:number]
    @result = win?(@period, @number) if @period && !@number.empty?
    haml :single_check
  end

  get '/multi_check' do
    haml :multi_check
  end

  post '/multi_check' do
    @period = params[:period]
    @numbers = params[:numbers].gsub(/\s+/, '').split(',')
    @results = all_win?(@period, @numbers) if @period && @numbers != []
    @result = 'I am sorry, you have no prize' if @results == {}
    haml :multi_check
  end

  not_found do
    'Oops you made a mistake ... right ?'
  end
end
