require 'net/http'
require 'json'
require 'open-uri'
require 'csv'

class CityCallCat < Array
  attr_reader :listings, :salary, :name
  
  def initialize(citycode)
    @citycode = citycode
    @name = citycode.last
    @salary = self.salary
    @listings = self.listings_by_category
  end

  def callapi(uri)
    #p uri
    response = Net::HTTP.get_response(uri);

    body = JSON.parse(response.body)
  end
  
  def builduri(params)
    country = 'ca'
    call = String.new
    if params['call'] == 'category'
      call = 'search'
    end
      
    baseURL = 'http://api.adzuna.com/v1/api/jobs/' + country + "/" + call
    callparams = '?app_id=&app_key='
    callparams = callparams + '&months=6' if params['call'] == 'history'
    callparams = callparams + '&category=' + params['category'] if params['call'] == 'category'
    callparams = callparams + '&what_or=degree,graduate'
    citycode = @citycode
    citycode.each do |column|
      column = column.gsub!(" ","%20")
    end
      
    case citycode.length
     when 1
      uri = URI.parse(baseURL + callparams + "&location0=" + citycode[0])
      when 2
        uri = URI.parse(baseURL + callparams + "&location0=" + citycode[0] + "&location1=" + citycode[1])
      when 3
        uri = URI.parse(baseURL + callparams + "&location0=" + citycode[0] + "&location1=" + citycode[1] + "&location2=" + citycode[2])
      when 4
        uri = URI.parse(baseURL + callparams + "&location0=" + citycode[0] + "&location1=" + citycode[1] + "&location2=" + citycode[2]+ "&location3=" + citycode[3])
      when 5
        uri = URI.parse(baseURL + callparams + "&location0=" + citycode[0] + "&location1=" + citycode[1] + "&location2=" + citycode[2]+ "&location3=" + citycode[3] + "&location4=" + citycode[4])
      when 6
        uri = URI.parse(baseURL + callparams + "&location0=" + citycode[0] + "&location1=" + citycode[1] + "&location2=" + citycode[2]+ "&location3=" + citycode[3] + "&location4=" + citycode[4]+ "&location5=" + citycode[5])
      end
  end
      
  def listings
      data = self.get_data('search')
      #p data['count']
      return count = data['count']
  end
    
  def listings_by_category
    if @listings then
      return @listings
    else
      categories = ["accounting-finance-jobs", "it-jobs", "sales-jobs", "customer-services-jobs", "engineering-jobs", "hr-jobs", "healthcare-nursing-jobs", "hospitality-catering-jobs", "pr-advertising-marketing-jobs", "logistics-warehouse-jobs", "teaching-jobs", "trade-construction-jobs", "admin-jobs", "legal-jobs", "creative-design-jobs", "graduate-jobs", "retail-jobs", "consultancy-jobs", "manufacturing-jobs", "scientific-qa-jobs", "social-work-jobs", "travel-jobs", "energy-oil-gas-jobs", "property-jobs", "charity-voluntary-jobs", "domestic-help-cleaning-jobs", "maintenance-jobs", "part-time-jobs", "other-general-jobs"]
      params = {'call' => 'category'}
      data = []
      categories.each do |category|
        params['category'] = category
        results = self.get_data(params)
        data << results['count']
      end
      return data
    end
  end
    
  def get_data(params)
    uri = builduri(params)
    return self.callapi(uri)
  end
  
  def Array
    return [@name, @salary, @listings]  
  end
end

=begin

array = []
response = Net::HTTP.get_response(URI.parse('http://api.adzuna.com/v1/api/jobs/de/categories?app_id=28f6787e&app_key=4dzun4pi'))
body = JSON.parse(response.body)
body['results'].each do |category|
  array << category['tag']
end

p array 
=end