#encoding: utf-8
class Sample < ActiveRecord::Base
  attr_accessible :comment, :footprint, :manufacturer, :name, :partnum, :quantity, :samplefileid
	def self.importSample(file, id) 
		sample=Samplefile.create(:filename=>file.original_filename, :project_id=>id)
		@fileid=sample.id
		spreadsheet = open_spreadsheet(file)
		header = spreadsheet.row(4)
		(5..spreadsheet.last_row).each do |i|
			row = Hash[[header, spreadsheet.row(i)].transpose]
			Sample.create(:name=>row.to_hash['元件名称'],:footprint=>row.to_hash['封装'],:quantity=>row.to_hash['样片数量'],:partnum=>row.to_hash['型号'],:manufacturer=>row.to_hash['制造商'],:comment=>row.to_hash['备注'],:samplefileid=>@fileid)
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
end
