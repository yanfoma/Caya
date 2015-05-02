require 'sinatra'
require 'sinatra/base'
require 'haml'
require_relative 'check_number'

class Caya < Sinatra::Base
  include CheckNumber

  get '/' do
    haml :index
  end

  get '/check' do
    @period = params[:period]
    @number = params[:number]
    if @period && @number
      @result = win?(@period, @number)
    end
    haml :index
  end

end
