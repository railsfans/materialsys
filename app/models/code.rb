#encoding: utf-8
class Code < ActiveRecord::Base
  attr_accessible :code, :flocation, :footprint, :name, :parent_id, :partnum, :partparams, :manufacturer

def self.import(file) 
	  arr=[]
	  arrs=[]
	  spreadsheet = open_spreadsheet(file)
	  header = spreadsheet.row(4)
	  (5..spreadsheet.last_row).each do |i|
    	row = Hash[[header, spreadsheet.row(i)].transpose] 
        if !row.to_hash['物料号'].nil? && row.to_hash['物料号'].length==8 
           if !Code.where(:parent_id=>1).where(:code=>row.to_hash['物料号'].slice(0,2)).first.try(:id).nil?  
          	 	codefirst=Code.where(:parent_id=>1).where(:code=>row.to_hash['物料号'].slice(0,2)).first
	           if !Code.where(:parent_id=>codefirst.id).where(:code=>row.to_hash['物料号'].slice(2,2)).first.try(:id).nil? 
	           	 	codesecond=Code.where(:parent_id=>codefirst.id).where(:code=>row.to_hash['物料号'].slice(2,2)).first
	          	 	parent_id=codesecond.id
		           if Code.where(:code=>row.to_hash['物料号'], :partnum=>row.to_hash['型号']).empty? 
			           Code.create(:code=>row.to_hash['物料号'], :name=>row.to_hash['元件名称'], :parent_id=>parent_id, :footprint=>row.to_hash['封装'], :manufacturer=>row.to_hash['制造商'], :partnum=>row.to_hash['型号'], :partparams=>row.to_hash['参数'])
		           end
	           else
		           arr<<'第'+i.to_s+'行'
		           arr<<row.to_hash['物料号']
		           arr<<'编码不存在'
		           arrs<<arr
		           arr=[]
	           end
           else
	           arr<<'第'+i.to_s+'行'
	           arr<<row.to_hash['物料号']
	           arr<<'编码不存在'
	           arrs<<arr
	           arr=[]
           end
        end
    end
    return arrs
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
