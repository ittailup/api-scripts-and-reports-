require 'rubygems'
require 'gattica'
require 'CSV'

class CountryReport
  
  def initialize(profile_id, startdate, enddate)
    @ga = Gattica.new({
      :email => 'gabriel@adzuna.com',
      :password => ''
    })
    @ga.profile_id = profile_id
    @start = startdate#(Date.today - 8)
    @ending = enddate #Date.today.prev_day - 1
    
  end
  
  def alerts
    @alerts = @ga.get({
      :start_date   => @start.strftime("%Y-%m-%d"),
      :end_date     => @ending.strftime("%Y-%m-%d"),
      :dimensions   => ['sourceMedium'],
      :metrics      => ['visits'],
      :filters      => ['sourceMedium == alerts / email']
      })
  end
  
  def cpc
    @cpc = @ga.get({
        :start_date   => @start.strftime("%Y-%m-%d"),
        :end_date     => @ending.strftime("%Y-%m-%d"),
        :dimensions   => ['sourceMedium'],
        :metrics      => ['visits'],
        :filters      => ['sourceMedium == google / cpc']
    })
  end
  
  def visits 
    @visits = @ga.get({
        :start_date   => @start.strftime("%Y-%m-%d"),
        :end_date     => @ending.strftime("%Y-%m-%d"),
        :dimensions   => ['year'],
        :metrics      => ['visits'],
        })
  end
      
  def revenue
    @revenue = @ga.get({
      :start_date => @start.strftime("%Y-%m-%d"),
      :end_date => @ending.strftime("%Y-%m-%d"),
      :dimensions => ['productCategory'],
      :metrics      => ['itemRevenue'],
      :filters      => ['productCategory == jobs']
    })
  end 
end

file = File.open("febin.csv", 'wb')

accountnames = ['IN']
accounts = ['78950613']

accounts.each_with_index do |account, index|
  p account
  for i in 0..4
    startdate = (Date.today - (8 + (7*i)))
    enddate = Date.today.prev_day - (1 + (7*i))
    #dates.push([startdate, enddate])
    report = CountryReport.new(account, startdate, enddate)
    file.puts "#{accountnames[index]} #{startdate} #{enddate}\n" 
    file.puts report.cpc.to_csv(:short)
    file.puts report.alerts.to_csv(:short)
    file.puts report.visits.to_csv(:short)
    file.puts report.revenue.to_csv(:short)
    file.puts "\n"
  end
end  
  
file.close 

