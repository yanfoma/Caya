# 1. Be sure that the links to each winning numbers table exist
#   A get request should have status 200
# 2. Be sure the mainpage link still works ...
#  A open method works fine

require 'minitest/autorun'
require_relative '../winning_numbers_scrape'

include WinningNumbersScrape

describe 'Getting the eTax winning numbers' do
  # 3. Be sure the periods[] is not empty and has 10 elements
  it 'Should give a non empty periods array' do
    periods = get_period
    periods.wont_be_empty
    periods.length.must_equal 10
  end

  # 4. Be sure that etax_data[] is not empty
  it 'Should give a non empty etax_data array' do
    data = get_data
    data.wont_be_empty
  end
end
