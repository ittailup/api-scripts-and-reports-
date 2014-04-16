require 'rubygems'
require 'gattica'
require 'CSV'

#ga.profile_id = 78950613

class CountryReport
  
  def initialize(profile_id)
    @ga = Gattica.new({
      :email => 'gabriel@adzuna.com',
    })
    @ga.profile_id = profile_id
    @start = (Date.today - 8)
    @ending = Date.today.prev_day - 1
    
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
      
  def pages
    @ga.get_each({
      :start_date => '2014-02-01',
      :end_date => '2014-02-28',
      :dimensions => ['pagePath'],
      :metrics      => ['pageviews'],
      :filters      => ['pagePath =~ /jobs/'],
      :per_page => 10000,
      :total_results => 20000
    }).each do |page|
      
    end
  end 
end

file = File.open("urls2.csv", 'wb')

#accounts = CSV.open('myaccounts.csv', 'r')

accounts = ['55971092']

accounts.each_with_index do |account, index|
  p account
  report = CountryReport.new(account)
  

end  
  
file.close 
