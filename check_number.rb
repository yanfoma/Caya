require 'yaml'

module CheckNumber

  def get_numbers_from_period(period)
    all_numbers = YAML.load(File.read("winning_numbers.yml"))
    numbers_of_period = {}
    all_numbers.each do |set_of_num|
      if set_of_num["Period"] == period
        numbers_of_period = set_of_num
        break
      end
    end
    numbers_of_period
  end

  def win_special_prize?(period, number)
    numbers_period = get_numbers_from_period(period)
    numbers_period["Special Prize"] == number
  end

  def win_grand_prize?(period, number)
    numbers_period = get_numbers_from_period(period)
    numbers_period["Grand Prize"] == number
  end

  def win_first_prize?(period, number)
    numbers_period = get_numbers_from_period(period)
    numbers_period["First Prize"][0] == number || numbers_period["First Prize"][1] == number || numbers_period["First Prize"][2] == number
  end

  def win_second_prize?(period, number)
    numbers_period = get_numbers_from_period(period)
    numbers_period["First Prize"][0][1..-1] == number[1..-1] || numbers_period["First Prize"][1][1..-1] == number[1..-1] || numbers_period["First Prize"][2][1..-1] == number[1..-1]
  end

  def win_third_prize?(period, number)
    numbers_period = get_numbers_from_period(period)
    numbers_period["First Prize"][0][2..-1] == number[2..-1] || numbers_period["First Prize"][1][2..-1] == number[2..-1] || numbers_period["First Prize"][2][2..-1] == number[2..-1]
  end

  def win_fourth_prize?(period, number)
    numbers_period = get_numbers_from_period(period)
    numbers_period["First Prize"][0][3..-1] == number[3..-1] || numbers_period["First Prize"][1][3..-1] == number[3..-1] || numbers_period["First Prize"][2][3..-1] == number[3..-1]
  end

  def win_fifth_prize?(period, number)
    numbers_period = get_numbers_from_period(period)
    numbers_period["First Prize"][0][4..-1] == number[4..-1] || numbers_period["First Prize"][1][4..-1] == number[4..-1] || numbers_period["First Prize"][2][4..-1] == number[4..-1]
  end

  def win_sixth_prize?(period, number)
    numbers_period = get_numbers_from_period(period)
    numbers_period["First Prize"][0][5..-1] == number[5..-1] || numbers_period["First Prize"][1][5..-1] == number[5..-1] || numbers_period["First Prize"][1][5..-1] == number[5..-1] || numbers_period["First Prize"][2][5..-1] == number[5..-1] || numbers_period["First Prize"][1][5..-1] == number[5..-1] || numbers_period["First Prize"][2][5..-1] == number[5..-1] || numbers_period["Additional Prizes"][0] == number[5..-1] || numbers_period["Additional Prizes"][1] == number[5..-1] || numbers_period["Additional Prizes"][2] == number[5..-1]
  end

  def win?(period, number)
    result = 'I am sorry, you have no prize'
    if win_sixth_prize?(period, number)
      result = 'You win NT$200'
    end
    if win_fifth_prize?(period, number)
      result = 'You win NT$1,000'
    end
    if win_fourth_prize?(period, number)
      result = 'You win NT$4,000'
    end
    if win_third_prize?(period, number)
      result = 'You win NT$10,000'
    end
    if win_second_prize?(period, number)
      result = 'You win NT$40,000'
    end
    if win_first_prize?(period, number)
      result = 'You win NT$200,000'
    end
    if win_grand_prize?(period, number)
      result = 'You win NT$2 million'
    end
    if win_special_prize?(period, number)
      result = 'You win NT$10 million '
    end
    result
  end
  
end
