require 'nokogiri'
require 'open-uri'
require 'yaml'

# The urls and paths to data
WEBSITE = 'http://www.etax.nat.gov.tw/etwmain/front'
MAIN_PAGE = "#{WEBSITE}/ETW183W6?site=en"
NUMBERS_TABLE_PATH = "//div[@class='content']/table/tr"
WINNING_TABLE_PATH = "//div[@class='content']//form/table/tr/td/a"
LINKS = "#{WINNING_TABLE_PATH}/@href"

# Getting the links of the table for each period
mainpage = Nokogiri::HTML(open(MAIN_PAGE))
winning_table_texts = mainpage.xpath(WINNING_TABLE_PATH)
winning_table_links = mainpage.xpath(LINKS)

# Getting the periods listed in the table
periods = []
winning_table_texts.each do |a|
  months = /\d+-\d+/.match(a.text)
  year = /\d\d\d\d/.match(a.text)
  periods << "#{months}/#{year}"
end

# Scraping the data from each link (representing the period)
numbers_table = []
winning_table_links.each do |link|
    url = "#{WEBSITE}/#{link}"
    numberspage = Nokogiri::HTML(open(url))
    numbers_table << numberspage.xpath(NUMBERS_TABLE_PATH)
end

# Getting the winning numbers for each period
numbers = []
regulations = []
numbers_table.each do |num|
  numbers << num.xpath("//td/span").text
  regulations << num.xpath("//td")
end

# Getting the period to take the prize
first_regulation = []
from_until = []
regulations.each do |regulate|
  first_regulation << regulate[regulate.count - 1].xpath("//ol/li").text
end
first_regulation.each do |regulation|
  from = /from \d+\/\d+\/\d+/.match(regulation)
  to = /to \d+\/\d+\/\d+/.match(regulation)
  from_until << "#{from}:#{to}".sub(/from/, '').sub(/to/, '')
end

# Creating a array of hashes
etax_data = []
numbers.each_with_index do |item, index|
  special_prize = numbers[index][0..7]
  grand_prize = numbers[index][8..15]
  first_first_prize = numbers[index][16..23]
  second_first_prize = numbers[index][25..32]
  third_first_prize = numbers[index][34..41]
  additional_prizes = numbers[index][42..-1].split("、")
  take_from_until = from_until[index].split(":")
  etax_data << [["Period", periods[index]],
  ["Special Prize", special_prize],
  ["Grand Prize", grand_prize],
  ["First Prize", "#{first_first_prize}:#{second_first_prize}:#{third_first_prize}".split(":")],
  ["Additional Prizes", additional_prizes],
  ["Take_Prize_From", take_from_until[0]],
  ["Take_Prize_Until", take_from_until[1]]].to_h
end

# Serialize the data
File.open("winning_numbers.yml", 'w') do |file|
  file.puts etax_data.to_yaml
end
