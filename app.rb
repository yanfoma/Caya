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

  get '/multi_check' do
    haml :multi_check
  end

  get '/check' do
    @period = params[:period]
    @number = params[:number]
    if @period && @number
      @result = win?(@period, @number)
    end
    haml :single_check
  end

  not_found do
    'Oops you made a mistake ... right ?'
  end

end
