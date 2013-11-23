#encoding: utf-8
class Record < ActiveRecord::Base
  attr_accessible :date, :people, :rlocation, :situ
  def self.import(file, people) 
		arr=[]
		arrs=[]
		spreadsheet = open_spreadsheet(file)
		header = spreadsheet.row(4)
		(5..spreadsheet.last_row).each do |i|
		row = Hash[[header, spreadsheet.row(i)].transpose]
		if !row.to_hash['物料号'].nil? && Code.where(:code=>row.to_hash['物料号']).empty? 
			arr<<'第'+i.to_s+'行'
			arr<<row.to_hash['物料号']
			arr<<'编码不存在'
		end
		if arr!=[]
			arrs<<arr
		end
			arr=[]
		end
		if arrs.length!=0
			arrs<<'请到物料编码管理中添加'
		return arrs
		end           
		@importstorelist=[]
		spreadsheet = open_spreadsheet(file)
		header = spreadsheet.row(4)
		(5..spreadsheet.last_row).each do |i|
		row = Hash[[header, spreadsheet.row(i)].transpose]             
		if i==5  
			@situ='入库'    
			directory = 'public/recorddata'
			@location=Time.now.strftime("%Y-%m-%d %H:%M:%S").split(' ').join('-')+'_'+file.original_filename
			path = File.join(directory,@location)
			File.open(path, "wb") { |f| f.write(file.read)}
			@b=Record.create(:people=>people, :situ=>@situ, :date=>Time.now.to_s, :rlocation=>Time.now.strftime("%Y-%m-%d %H:%M:%S").split(' ').join('-')+'_'+file.original_filename)
		end
		if !row.to_hash['物料号'].nil?	          
             @store=Store.create(:record_id=>@b.id, :name=>row.to_hash['元件名称'], :partnum=>row.to_hash['型号'], :importtime=>Time.now, :code=>row.to_hash['物料号'], :partparams=>row.to_hash['参数'], :currentquantity=>row.to_hash['库存数量'], :originquantity=>row.to_hash['库存数量'], :unitprice=>row.to_hash['单价/元'], :supplier=>row.to_hash['供应商'], :comment=>row.to_hash['备注'],:footprint=>row.to_hash['封装'],:manufacturer=>row.to_hash['制造商'] ) 
             
             @importstorelist<<@store.id
			if @store.originquantity.nil? || @store.currentquantity.nil?
               	@importstorelist.each do |m|
                    Store.find(m).destroy
               	end
               	@b.destroy
				arr<<'库存数量格式不正确或库存数量未填写'
				arrs<<arr
				return arrs
			end
		end
		end
		return arrs
	end

	def self.outport(file, people) 
    		arr=[]
        	arrs=[]
        	spreadsheet = open_spreadsheet(file)
  			header = spreadsheet.row(4)
  			(5..spreadsheet.last_row).each do |i|
    			row = Hash[[header, spreadsheet.row(i)].transpose]
        		if Store.where(:code=>row.to_hash['物料号'], :partnum=>row.to_hash['型号']).sum(:currentquantity).to_i < row.to_hash['出库数量'].to_i
        		arr<<'第'+i.to_s+'行'
    			arr<<row.to_hash['物料号']
        		arr<<'库存不够'
        		end
        		if arr!=[]
        			arrs<<arr
        		end
        		arr=[]
    		end
        	if arrs.length!=0
        		return arrs
        	end
        
  			spreadsheet = open_spreadsheet(file)
  			header = spreadsheet.row(4)
  			(5..spreadsheet.last_row).each do |i|
    			row = Hash[[header, spreadsheet.row(i)].transpose]             
            	if i==5  
            		@situ='出库' 
            		@b=Record.create(:people=>people, :situ=>@situ, :date=>Time.now.to_s, :rlocation=>Time.now.strftime("%Y-%m-%d %H:%M:%S").split(' ').join('-')+'_'+file.original_filename)
            		directory = 'public/recorddata'
        			path = File.join(directory,@b.rlocation)
        			File.open(path, "wb") { |f| f.write(file.read)}
            	end
                Outportrecord.create(:record_id=>@b.id, :name=>row.to_hash['元件名称'], :partnum=>row.to_hash['型号'], :date=>row.to_hash['日期'], :code=>row.to_hash['物料号'], :quantity=>row.to_hash['出库数量'].to_i, :comment=>row.to_hash['备注'],:footprint=>row.to_hash['封装']) 
            	sum=row.to_hash['出库数量'].to_i
            	Store.where(:code=>row.to_hash['物料号'], :partnum=>row.to_hash['型号']).each do |s|
            		if s.currentquantity.to_i<=sum
                		sum=sum-s.currentquantity.to_i
                        s.currentquantity=s.currentquantity.to_i-sum
                		s.save
                	else
                		s.currentquantity=s.currentquantity.to_i-sum
                		s.save
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
