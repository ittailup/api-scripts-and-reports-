require 'net/http'
require 'json'
require 'open-uri'
require 'csv'

class CityCall < Array
  attr_reader :listings, :salary, :name
  
  def initialize(params)
    @name = params['city'].last
    #print @name
    @params = params
    @salary = self.salary
    #@listings = self.listings
  end

  def callapi(uri)
    response = Net::HTTP.get_response(uri);
    body = JSON.parse(response.body)
  end
  
  def builduri(call)
    #country = 'ca'
    baseURL = 'http://api.adzuna.com/v1/api/jobs/' 
    uriparams = @params['country'] + "/" + call
    uriparams =  uriparams + '?'
    #print uriparams
    @params.each do |key, param|
      unless key == 'country' or key == 'city'
       # print key
      # print @params[key]
        #print param
        uriparams = uriparams + key + '=' 
        print param
        uriparams = uriparams + param + '&'
      end
    end
    
    @params['city'].each do |location|
      location = location.gsub!(" ","%20")
    end
    uristring = String.new
    counter = 0   
    
    @params['city'].each do |location|
      uristring = baseURL + uriparams if counter == 0
      uristring = uristring + '&location' + counter.to_s + '=' + @params['city'][counter]
      counter += 1
    end
    uri = URI.parse(uristring)      
  end
      
  def listings
      data = self.get_data('search')
      #p data['count']
      return count = data['count']
  end
    
  def salary
    if @salary.nil? 
      data = self.get_data('geodata')
      return @salary = data['count']
    else
      return @salary
    end
  end
    

  def get_data(call) 
    uri = builduri(call)
    p uri
    return self.callapi(uri)
  end
  
  def Array
    return [@name, @salary, @listings]  
  end
  
end