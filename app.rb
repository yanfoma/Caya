require 'sinatra'
require 'sinatra/base'

class Caya < Sinatra::Base

  get '/' do
    'Habari ! Caya is alive'
  end


end
