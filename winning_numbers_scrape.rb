require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'
require 'yaml'

# Rubocop: Top-level module documentation missing
module WinningNumbersScrape
  # The urls and paths to data
  WEBSITE = 'http://www.etax.nat.gov.tw/etwmain/front'
  MAIN_PAGE = "#{WEBSITE}/ETW183W6?site=en"
  NUMBERS_TABLE_PATH = "//div[@class='content']/table/tr"
  WINNING_TABLE_PATH = "//div[@class='content']//form/table/tr/td/a"
  LINKS = "#{WINNING_TABLE_PATH}/@href"

  # Getting the links of the table for each period
  mainpage = Nokogiri::HTML(open(MAIN_PAGE, :allow_redirections => :safe))
  WINNING_TABLE_TEXTS = mainpage.xpath(WINNING_TABLE_PATH)
  WINNING_TABLE_LINKS = mainpage.xpath(LINKS)

  def get_period
    # Getting the periods listed in the table
    periods = []
    WINNING_TABLE_TEXTS.each do |a|
      months = /\d+-\d+/.match(a.text)
      year = /\d\d\d\d/.match(a.text)
      periods << "#{months}/#{year}"
    end
    periods
  end

  def data_from_link # for get_data
    # Scraping the data from each link (representing the period)
    numbers_table = []
    WINNING_TABLE_LINKS.each do |link|
      url = "#{WEBSITE}/#{link}"
      numberspage = Nokogiri::HTML(open(url, :allow_redirections => :safe))
      numbers_table << numberspage.xpath(NUMBERS_TABLE_PATH)
    end
    numbers_table
  end

  def winning_numbers_each_period(numbers_table) # for get_data
    # Getting the winning numbers for each period
    numbers = []
    regulations = []
    numbers_table.each do |num|
      numbers << num.xpath('//td/span').text
      regulations << num.xpath('//td')
    end
    [numbers, regulations]
  end

  def period_take_prize_regulation(regulations) # for get_data
    # Getting the period to take the prize
    first_regulation = []
    regulations.each do |regulate|
      first_regulation << regulate[regulate.count - 1].xpath('//ol/li').text
    end
    first_regulation
  end

  def period_take_prize_until(first_regulation) # for get_data
    # Getting the period to take the prize
    from_until = []
    first_regulation.each do |regulation|
      from = /from \d+\/\d+\/\d+/.match(regulation)
      to = /to \d+\/\d+\/\d+/.match(regulation)
      from_until << "#{from}:#{to}".sub(/from/, '').sub(/to/, '')
    end
    from_until
  end

  def assign_prize_groups(numbers, idx) # for make_etax
    # The three first prizes are sent as an array for concision
    a, b, c, d, e, f = *[0..7, 8..15, 16..23, 25..32, 34..41, 42..-1]
    [numbers[idx][a], numbers[idx][b],
     [numbers[idx][c], numbers[idx][d], numbers[idx][e]], # All first prizes
     numbers[idx][f].split('、')]
  end

  def make_etax(numbers, from_until, periods, index) # for array_of_hashes
    special_prize, grand_prize, first_prize,
    additional_prizes = assign_prize_groups(numbers, index)
    take_from_until = from_until[index].split(':')
    Hash['Period', periods[index], 'Special Prize', special_prize,
         'Grand Prize', grand_prize, 'First Prize', first_prize,
         'Additional Prizes', additional_prizes, 'Take_Prize_From',
         take_from_until[0], 'Take_Prize_Until', take_from_until[1]]
  end

  def array_of_hashes(numbers, from_until, periods, etax_data = [])
    # Creating a array of hashes
    numbers.each_index do |index|
      etax_data << make_etax(numbers, from_until, periods, index)
    end
    etax_data
  end

  def get_data
    periods = get_period
    numbers_table = data_from_link
    numbers, regulations = winning_numbers_each_period(numbers_table)
    first_regulation = period_take_prize_regulation(regulations)
    from_until = period_take_prize_until(first_regulation)
    array_of_hashes(numbers, from_until, periods)
  end
end
