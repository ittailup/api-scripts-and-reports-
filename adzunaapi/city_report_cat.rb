require 'csv'
require_relative 'city_call_cat'

class CityReport < Array
  
  def initialize(csv)
    #@input = CSV.open(csv, 'r')
    @input = [['Canada']]
    @citylist = [['City', 
                "accounting-finance-jobs", 
                "it-jobs", 
                "sales-jobs", 
                "customer-services-jobs", 
                "engineering-jobs", 
                "hr-jobs", 
                "healthcare-nursing-jobs", 
                "hospitality-catering-jobs", 
                "pr-advertising-marketing-jobs", 
                "logistics-warehouse-jobs", 
                "teaching-jobs",
                "trade-construction-jobs", 
                "admin-jobs", 
                "legal-jobs", 
                "creative-design-jobs", 
                "graduate-jobs", 
                "retail-jobs", 
                "consultancy-jobs", 
                "manufacturing-jobs", 
                "scientific-qa-jobs", 
                "social-work-jobs", 
                "travel-jobs", 
                "energy-oil-gas-jobs", 
                "property-jobs", 
                "charity-voluntary-jobs", 
                "domestic-help-cleaning-jobs", 
                "maintenance-jobs", 
                "part-time-jobs", 
                "other-general-jobs"]]
    
    @input.each do |cityname|
      p cityname
      city = CityCallCat.new(cityname)
      export = [city.name]
      listings = city.listings_by_category
      listings.each do |category|
        export << [category[0],category[1]]
      end
      @citylist << export
    end
  end
  
  def export(file)
    outputfile = CSV.open(file, 'wb')
    
    @citylist.each do |citydata|
      outputfile << citydata      
    end
    outputfile.close
  end
end


CityReport.new('/Users/predius/code/adzuna/waatj/canadianprovinces.csv').export('test.csv')
