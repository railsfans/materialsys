#encoding: utf-8
class Supplier < ActiveRecord::Base
  attr_accessible :address, :comment, :company, :contactor, :email, :fax, :material, :number, :phone, :website
def self.import(file) 
  spreadsheet = open_spreadsheet(file)
  header = spreadsheet.row(4)
  (5..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]             
       Supplier.create(:company=>row.to_hash['公司名称'], :address=>row.to_hash['公司地址'], :website=>row.to_hash['网址'], :contactor=>row.to_hash['联系人'], :phone=>row.to_hash['联系电话'], :comment=>row.to_hash['备注'], :material=>row.to_hash['供应信息'], :email=>row.to_hash['邮箱'], :fax=>row.to_hash['传真'], :number=>row.to_hash['供应商编号'].to_i) 
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
