#encoding: utf-8
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

def bom_update
	if params[:file]
		id=Bomfile.where(:project_id=>params[:id]).where(:filename=>params[:bom]).first.id
		Bom.updateBom(params[:file], id)
	end
		respond_to do |format|
			format.json { render json: { :success=>true, :message=>params[:file].original_filename }, :content_type => 'text/html' }
	end
end

def bom_delete
	@bom=Bomfile.where(:project_id=>params[:id].to_i).where(:filename=>params[:bom]).first
	Bom.where(:fileid=>@bom.id).each do |m|
		m.destroy
	end 
	@bom.destroy
	respond_to do |format|
		format.json { render :json=>{:success=>true, :message=>@bom.filename}}
	end
end

def value
	id=Bomfile.where(:project_id=>params[:project_id]).where(:filename=>params[:filename]).first.id
	@value=Bom.where(:fileid=>id).where("module is not null")
	respond_to do |format|
		format.json { render json: {:gridData=>@value.collect {|list| { :code=>list.code, :name=>list.name, :module=>list.module, :value=>Store.where(:code=>list.code).first.try(:unitprice).to_f} } }}
	end
end

def material_add
	Bom.create(:code=>params[:code], :partref=>params[:partref], :name=>params[:name], :footprint=>params[:footprint],:partnum=>params[:partnum], :fileid=>params[:bom_id], :manufacturer=>params[:manufacturer], :module=>params[:module], :comment=>params[:comment], :partparams=>params[:partparams]) 
	respond_to do |format|
		format.json { render json: { :success=>true} }
	end
end

def material_edit
	flag=true
	if flag
		Bom.where(:id=>params[:id]).first.update_attributes(:partref=>params[:partref], :name=>params[:name], :footprint=>params[:footprint], :partnum=>params[:partnum], :fileid=>params[:bom_id], :manufacturer=>params[:manufacturer], :module=>params[:module], :comment=>params[:comment], :partparams=>params[:partparams])
	end
	respond_to do |format|
		format.json { render json: { :success=>flag} }
	end
end

def material_delete
	Bom.where(:id=>params[:id]).first.destroy
	respond_to do |format|
		format.json { render json: { :success=>true} }
	end
end

def download
	if params[:code]=='000'
		code=[]
		Bom.where(:fileid=>params[:id]).each do |m|
			if !code.include? m.code && !m.code.nil?
				code<<m.code
			end
		end
		downloadlist=[]
		flag=true
		shortlist=[]
		code.each do |s|
			if !Code.where(:code=>s).first.try(:flocation).nil?
				downloadlist<<Code.where(:code=>s).first.flocation
			else
				flag=false
				shortlist<<s
			end
		end
		if flag==false
			file='public/data.h'
			short=shortlist.join(',')
		else
			filename=Bomfile.find(params[:id]).filename.split('.')[0]
			downloadlist.each do |na|
				cmd= "cd #{Rails.root}/public/data ; unzip -o "+na
				system(cmd)
			end
			downloadlist.each do |na|
				cmd="cd #{Rails.root}/public/data ; mkdir ./cadence_footprint ; /bin/cp -rf ./"+na.split('.')[0]+'/cadence_footprint'+ " ./"
			system(cmd)
			end
			cmd="cd #{Rails.root}/public/data ; tar -cf "+filename.split('B')[0]+Code.first.flocation+'.tar '+'./cadence_footprint'
			system(cmd)
			file='public/data/'+filename.split('B')[0]+Code.first.flocation+'.tar'
			#Code.first.flocation= PCB焊盘和封装 filename=MyFitDog项目BOM表（版式一）.xls
		end
	else
		if Code.where(:code=>params[:code]).empty? || Code.where(:code=>params[:code]).first.flocation.nil?
			file='public/data/DC-041.h'
		else
			file='public/data/'+Code.where(:code=>params[:code]).first.flocation
		end
	end
	if File.file? file
		send_file file,  :x_sendfile=>true
	else if file=='public/data.h'
		render :text=>"the footprint no all "+short
	else
		render :template => 'bom/download.js.erb'
	end
	end
end

def download1
    @boms = Bom.where(:fileid=>params[:id])
    response.headers['Content-Disposition'] = 'attachment; filename="' + Bomfile.find(@boms.first.fileid).filename + '"'
    respond_to do |format|
      format.xls
    end
  
end

def download2
    @boms = Bom.cals(params[:id])
    response.headers['Content-Disposition'] = 'attachment; filename="' + Bomfile.find(Bom.where(:fileid=>params[:id]).first.fileid).filename.split('（')[0] + '（版式二）.xls"'	  
    respond_to do |format|
      format.xls
    end
end

end
