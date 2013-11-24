class Store < ActiveRecord::Base
  attr_accessible :code, :comment, :currentquantity, :footprint, :importtime, :manufacturer, :name, :originquantity, :partnum, :partparams, :record_id, :supplier, :unitprice

def self.totalcost
	@totalcost=0
	Store.all.each do |s|
	        @totalcost+=s.currentquantity.to_i*s.unitprice.to_i
	end
	return @totalcost
end

end
