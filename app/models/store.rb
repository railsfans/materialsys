class Store < ActiveRecord::Base
  attr_accessible :code, :comment, :currentquantity, :footprint, :importtime, :manufacturer, :name, :originquantity, :partnum, :partparams, :record_id, :supplier, :unitprice

def self.totalcost
	@totalcost=0
	Store.all.each do |s|
	        @totalcost+=s.currentquantity.to_i*s.unitprice.to_i
	end
	return @totalcost
end

def self.check(file) 
    arr=[]
	spreadsheet = open_spreadsheet(file)
	header = spreadsheet.row(4)
	(5..spreadsheet.last_row).each do |i|
	row = Hash[[header, spreadsheet.row(i)].transpose]
	if Store.where(:partparams=>(row.to_hash['Value']+' '+row.to_hash['Voltage']), :footprint=>row.to_hash['PCB Footprint']).empty?
       arr<<(row.to_hash['Value']+' '+row.to_hash['PCB Footprint']+' '+row.to_hash['Voltage'])
    end
	end   
	return arr
end

def self.create(file) 
    mularr=[]
    rightarr=[]
    returnarr=[]
	spreadsheet = open_spreadsheet(file)
	header = spreadsheet.row(4)
	(5..spreadsheet.last_row).each do |i|
	row = Hash[[header, spreadsheet.row(i)].transpose]
	if !Store.where(:partparams=>(row.to_hash['Value']+' '+row.to_hash['Voltage']), :footprint=>row.to_hash['PCB Footprint']).empty? && Store.where(:partparams=>(row.to_hash['Value']+' '+row.to_hash['Voltage']), :footprint=>row.to_hash['PCB Footprint']).count>1
       mularr<<(row.to_hash['Value']+' '+row.to_hash['PCB Footprint']+' '+row.to_hash['Voltage'])
    else
       rightarr<<Store.where(:partparams=>(row.to_hash['Value']+' '+row.to_hash['Voltage']), :footprint=>row.to_hash['PCB Footprint']).id
    end
	end 
    returnarr<<mularr
    returnarr<<rightarr  
	return returnarr
end

def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when '.csv' then Roo::Csv.new(file.path, nil, :ignore)
    when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
    when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
end


end
