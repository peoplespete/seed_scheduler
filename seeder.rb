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

veggies = []
loop do
  veggie = {}
  puts 'Enter Vegetable:'.green
  veggie[:name] = STDIN.gets.chomp
  break if veggie[:name].blank?
  puts 'Enter Weeks Before to Frost To Seed:'.green
  veggie[:sow_date] = frost_date - STDIN.gets.chomp.to_i.weeks
  puts 'Direct Seed?'
  veggie[:direct_seed] = STDIN.gets.chomp == 'y'

  unless veggie[:direct_seed]
    puts 'Enter Weeks Before to Frost To Transplant:'.green
    veggie[:transplant_date] = frost_date - STDIN.gets.chomp.to_i.weeks
  end

  veggies.push veggie
end

print_veggies(veggies)
