require 'colorize'
require 'date'
require 'pry'
require 'rails'

frost_date = Date.new(2016, 4, 15)

def print_veggies(veggies)
  lines = []
  veggies.each do |veggie|
    method = veggie[:direct_seed] ? 'Outdoors' : 'Indoors'
    lines.push ["Sow #{veggie[:name]} #{method} on #{veggie[:sow_date]}", veggie[:sow_date]]
    if veggie[:transplant_date]
      lines.push ["Transplant #{veggie[:name]} Outdoors on #{veggie[:transplant_date]}", veggie[:transplant_date]]
    end
  end
  lines.sort_by{ |l| l.last }.each do |line|
    puts line.first
  end
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
