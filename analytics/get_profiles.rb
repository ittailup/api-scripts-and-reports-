require 'gattica'

@ga = Gattica.new({
  :email => 'gabriel@adzuna.com',
  :password => ''
})

file = File.open('accounts.csv', 'w')

@ga.accounts.each do |line|
  file.puts line
end


file.close