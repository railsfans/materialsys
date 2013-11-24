class Stores < ActiveRecord::Base

def self.check(file) 
    arr=[]
	spreadsheet = open_spreadsheet(file)
	header = spreadsheet.row(4)
	(5..spreadsheet.last_row).each do |i|
	row = Hash[[header, spreadsheet.row(i)].transpose]
	if row.to_hash['code'].to_s!='' && Store.where(:partparams=>(row.to_hash['Value'].to_s+' '+row.to_hash['Voltage'].to_s), :footprint=>row.to_hash['PCB Footprint'].to_s).empty?
       arr<<(row.to_hash['Value'].to_s+' '+row.to_hash['PCB Footprint'].to_s+' '+row.to_hash['Voltage'].to_s)
    end
	end   
	return arr
end

def self.create(file) 
    mularr=[]
    rightarr=[]
    returnarr=[]
    quantity=[]
    partref=[]
	spreadsheet = open_spreadsheet(file)
	header = spreadsheet.row(4)
	(5..spreadsheet.last_row).each do |i|
	row = Hash[[header, spreadsheet.row(i)].transpose]
	if row.to_hash['code'].to_s!='' && !Store.where(:partparams=>(row.to_hash['Value'].to_s+' '+row.to_hash['Voltage'].to_s), :footprint=>row.to_hash['PCB Footprint'].to_s).empty? && Store.where(:partparams=>(row.to_hash['Value'].to_s+' '+row.to_hash['Voltage'].to_s), :footprint=>row.to_hash['PCB Footprint'].to_s).count>1
       mularr<<(row.to_hash['Value'].to_s+' '+row.to_hash['PCB Footprint'].to_s+' '+row.to_hash['Voltage'].to_s)
       partref<<row.to_hash['Part Reference']
       quantity<<row.to_hash['Quantity']
    else if row.to_hash['code'].to_s!=''
       rightarr<<Store.where(:partparams=>(row.to_hash['Value'].to_s+' '+row.to_hash['Voltage'].to_s), :footprint=>row.to_hash['PCB Footprint'].to_s).first.id
       partref<<row.to_hash['Part Reference']
       quantity<<row.to_hash['Quantity']
    end
    end
	end 
    returnarr<<mularr
    returnarr<<rightarr  
    returnarr<<partref
    returnarr<<quantity
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
