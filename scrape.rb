require_relative 'winning_numbers_scrape'

include WinningNumbersScrape

data = []
data = get_data

# Serialize the data
File.open('winning_numbers.yml', 'w') do |file|
  file.puts data.to_yaml
end
