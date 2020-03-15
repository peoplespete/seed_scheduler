require 'colorize'
require 'date'
require 'pry'
require 'rails'
require 'csv'

# 1.5-3 lbs  of fertilizer/ 100 sq ft
# 12*8 = 96 sq ft (my garden)

def print_veggies(veggies)
  CSV.open("csv/#{DateTime.now.to_i}.csv", 'wb') do |csv|
    csv << ['Subject', 'Start date', 'All Day Event']
    # Final exam  05/30/2020  true
    veggies.each do |veggie|
      method = veggie[:direct_seed] ? 'Outdoors' : 'Indoors'
      subject = "Sow #{veggie[:name]} #{method}"
      date = veggie[:sow_date]
      csv << [subject, date, true]
      if veggie[:transplant_date]
        subject = "Transplant #{veggie[:name]} Outdoors"
        date = veggie[:transplant_date]
        csv << [subject, date, true]
      end
    end
  end
  puts 'csv created'
end

def ask(question)
  puts question
  response = ''
  while response == ''
    response = STDIN.gets.chomp
  end
  response
end
begin
  frost_date = ask 'Enter Frost Date: (YYYY/MM/DD)'
  frost_date = Date.new(*frost_date.split('/').map(&:to_i))

  veggies = []
  loop do
    veggie = {}
    veggie[:name] = ask 'Enter Vegetable: (type exit to finish)'
    break if veggie[:name] == 'exit'
    week_ofset = ask 'Enter Weeks Before to Frost To Seed:'
    veggie[:sow_date] = frost_date - week_ofset.to_i.weeks
    response = ask 'Direct Seed?'
    veggie[:direct_seed] = response == 'y'

    unless veggie[:direct_seed]
      transplant_ofset = ask 'Enter Weeks Before to Frost To Transplant:'
      veggie[:transplant_date] = frost_date - transplant_ofset.to_i.weeks
    end

    veggies.push veggie
  end
rescue
  binding.pry
end
print_veggies(veggies)
