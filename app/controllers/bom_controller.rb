class BomController < ApplicationController
def upload
	if params[:file]
	        Bom.importBom(params[:file], params[:id])
	end
		respond_to do |format|
			format.json { render json: { :success=>true, :message=>params[:file].original_filename }, :content_type => 'text/html' }
	end
end

def bom_show
respond_to do |format|
	format.js
end
end

def show
params[:value]=params[:value] || ''
if params[:value].empty?
	@bomnil=Bom.where(:fileid=>params[:fileid]).where("code is null").order('code ASC')
        @bomnotnil=Bom.where(:fileid=>params[:fileid]).where("code is not null").order('code ASC')
        @bomorder=@bomnotnil+@bomnil
        @bom=[] 
        index=0
        flag=false
        @bomorder.each do  |i|
        if index==params[:start].to_i 
        flag=true
        end
        if index==(params[:start].to_i+20)
        flag=false
        end
        if flag==true
        @bom<<i
        end
        index=index+1
        end
	totalcount=Bom.where(:fileid=>params[:fileid]).count
else if params[:type] == '100000'
	@bom=Bom.where(:fileid=>params[:fileid]).where("name like ? or code like ? or partnum like ? or module like ? or  partref like ?","%#{params[:value]}%","%#{params[:value]}%","%#{params[:value]}%","%#{params[:value]}%","%#{params[:value]}%") 
	totalcount=20
else if params[:type]=='101100'
	@bom=Bom.where(:fileid=>params[:fileid]).where(" code like ? ","%#{params[:value]}%") 
	totalcount=20
else if params[:type]=='102200'
	@bom=Bom.where(:fileid=>params[:fileid]).where("partref like ?","%#{params[:value]}%") 
	totalcount=20
else if params[:type]=='103300'
	@bom=Bom.where(:fileid=>params[:fileid]).where("partname like ? ","%#{params[:value]}%") 
	totalcount=20
else if params[:type]=='104400'
	@bom=Bom.where(:fileid=>params[:fileid]).where(" partnum like ? ","%#{params[:value]}%") 
	totalcount=20
else if params[:type]=='105500'
	@bom=Bom.where(:fileid=>params[:fileid]).where("module like ? ","%#{params[:value]}%") 
	totalcount=20
end
end
end
end
end
end
end
respond_to do |format|
  format.json { render json: {:totalCount=>totalcount, :gridData=>@bom.collect{ |f|{ :id=>f.id, :footprint=>f.footprint, :flocation=>Code.where(:code=>f.code).first.try(:flocation).nil? ? 'no' : 'yes', :code=>f.code,:partparams=>f.partparams, :partref=>f.partref, :name=>f.name,
 :quantity=>1, :partnum=>f.partnum, :manufacturer=>f.manufacturer, :comment=>f.comment, :module=>f.module}} } }
end
end

def bom_help
	respond_to do |format|
	  format.js
	end
end

end
