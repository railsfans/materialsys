#encoding: utf-8
class Bom < ActiveRecord::Base
  attr_accessible :code, :comment, :fileid, :footprint, :manufacturer, :module, :name, :partnum, :partparams, :partref

def self.importBom(file, id) 
	  bom=Bomfile.create(:filename=>file.original_filename, :project_id=>id)
	  @fileid=bom.id
	  spreadsheet = open_spreadsheet(file)
	  header = spreadsheet.row(4)
	  (5..spreadsheet.last_row).each do |i|
	    row = Hash[[header, spreadsheet.row(i)].transpose]
	    Bom.create(:code=>row.to_hash['物料号'], :partref=>row.to_hash['参考编号'],:name=>row.to_hash['元件名称'],:footprint=>row.to_hash['元件封装'],:partnum=>row.to_hash['元件型号'],:manufacturer=>row.to_hash['制造商'],:module=>row.to_hash['模块名称'],:comment=>row.to_hash['备注'],:fileid=>@fileid, :partparams=>row.to_hash['元件参数'])
  	 end
end

def self.open_spreadsheet(file)
  case File.extname(file.original_filename)
  when '.csv' then Roo::Csv.new(file.path, nil, :ignore)
  when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
  when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
  else raise "Unknown file type: #{file.original_filename}"
  end
end

def self.max(filename, id)
	code=[]
	arr=[]
	fileid=Bomfile.where(:project_id=>id).where(:filename=>filename).first.id
	Bom.where(:fileid=>fileid).each do |m|
	if !code.include? m.code
		code<<m.code
	end
	end
	code.each do |s|
	if !Store.where(:code=>s).empty?
		arr<<Store.where(:code=>s).sum(:currentquantity).to_i/Bom.where(:fileid=>fileid).where(:code=>s).count
	else
		arr<<0
	end
	end
	return arr.min
end

def self.cal(fileid,num)
	arrs=[]
	arr=[]
	code=[]
	Bom.where(:fileid=>fileid).each do |m|
		if !m.code.nil? 
			if  !code.include? m.code 
				code<<m.code
			end
		end
	end
	code.each do |s|
		if Store.where(:code=>s).sum(:currentquantity).to_i < Bom.where(:fileid=>fileid).where(:code=>s).count*num
			arr<<s.to_s
			arr<<Bom.where(:fileid=>fileid).where(:code=>s).count*num-Store.where(:code=>s).sum(:currentquantity).to_i
			arr<<Bom.where(:fileid=>fileid).where(:code=>s).first.name.to_s
			arr<<Bom.where(:fileid=>fileid).where(:code=>s).first.footprint.to_s
			arrs<<arr
		end
		arr=[]
	end
	return arrs
end

def self.totalcost(filename, id)
	sum=0
	fileid=Bomfile.where(:project_id=>id).where(:filename=>filename).first.id
	Bom.where(:fileid=>fileid).each do |m|
		sum=Store.where(:code=>m.code).first.try(:unitprice).to_f+sum
	end
	return sum
end

end

