require 'sinatra'
require 'sinatra/base'
require 'haml'
require_relative 'check_number'

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
    if @period && !@number.empty?
      @result = win?(@period, @number)
    end
    haml :single_check
  end

  get '/multi_check' do
    haml :multi_check
  end

  post '/multi_check' do
    @period = params[:period]
    @numbers = params[:numbers].gsub(/\s+/, "").split(',')
    if @period && @numbers != []
      @results = all_win?(@period, @numbers)
    end
    if @results == {}
      @result = 'I am sorry, you have no prize'
    end
    haml :multi_check
  end


  not_found do
    'Oops you made a mistake ... right ?'
  end

end
