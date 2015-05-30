require 'yaml'

# Rubocop: Top-level module documentation missing
module CheckNumber
  def get_numbers_from_period(period)
    all_numbers = YAML.load(File.read('winning_numbers.yml'))
    numbers_of_period = {}
    all_numbers.each do |set_of_num|
      if set_of_num['Period'] == period
        numbers_of_period = set_of_num
        break
      end
    end
    numbers_of_period
  end

  def win_special_grand_prize?(period, number)
    numbers_period = get_numbers_from_period(period)
    win_sgp = 'special' if numbers_period['Special Prize'] == number
    win_sgp = 'grand' if numbers_period['Grand Prize'] == number
    win_sgp
  end

  def win_first_prize?(period, number)
    numbers_period = get_numbers_from_period(period)
    numbers_period['First Prize'][0..2].any? { |num| num == number }
  end

  def win_num_prize_worker?(period, number, x)
    # Given a number, returns an array of [true, false, ...] based on tests
    # for equality on position x to -1.
    numbers_period = get_numbers_from_period(period)
    numbers_period['First Prize'][0..2].map { |e| e[x..-1] == number[x..-1] }
  end

  def win_num_prize?(period, number, a = [])
    # b: Array of position to test from
    # => 2nd prize tests from 1, 5th prize tests from 4
    b = [1, 2, 3, 4]
    b.each { |x| a << win_num_prize_worker?(period, number, x) }
    # a: Array of arrays with results of test for prizes 2 to 5 in that order
    # => a.find_index returns index of first array that has a true within it
    a.find_index { |i| i.any? { |e| e == true } }
  end

  def win_sixth_prize?(period, number, a = 'First Prize')
    numbers_period = get_numbers_from_period(period)
    numbers_period[a][0..2].any? { |e| e[5..-1] == number[5..-1] } ||
      numbers_period['Additional Prizes'][0..2].any? { |e| e == number[5..-1] }
  end

  def win?(period, number)
    prize = ['40,000', '10,000', '4,000', '1,000']
    prize_sgp = { 'special' => '2 million', 'grand' => '10 million ' }
    result = 'I am sorry, you have no prize'
    b = win_num_prize?(period, number)
    c = win_special_grand_prize?(period, number)
    result = 'You win NT$200' if win_sixth_prize?(period, number)
    result = "You win NT$#{prize[b]}" if b
    result = 'You win NT$200,000' if win_first_prize?(period, number)
    result = "You win NT$#{prize_sgp[c]}" if c
    result
  end

  def all_win?(period, numbers)
    results = {}
    numbers.each do |number|
      if win?(period, number) != 'I am sorry, you have no prize'
        results[number] = win?(period, number)
      end
    end
    results
  end

  # def number_format(number)

  # end
end
