class CodeController < ApplicationController
skip_before_filter :verify_authenticity_token, :only => [:code_all, :code_edit, :list, :code_add]
def list
    $global=Code.find(params[:id]).name
    p $global
	respond_to do |format|
		format.js 
	end
end

def node_add
	flag = true
	@codes=Code.where(:parent_id=>params[:id])
	@codes.each do |code|
		if code.code==params[:code]
			flag=false
		end
	end
	if flag
		Code.create(:name=>params[:name], :parent_id=>params[:id], :code=>params[:code]) 
	end
	respond_to do |format|
		format.json { render :json=>{:success=>flag} }
	end
end 

def node_edit
	flag = true
	@codes=Code.where(:parent_id=>params[:parent_id])
	@codes.each do |code|
		if code.code==params[:code] && code.id != params[:id].to_i
			flag=false
		end
	end
	if flag
		@code = Code.find(params[:id])
		@code.update_attributes(:name=>params[:name], :code=>params[:code]) 
	end
	respond_to do |format|
		format.json { render :json=>{:success=>flag} }
	end
end 

def node_delete
	@code = Code.find(params[:id])
	if @code.parent_id!=1
		Code.where(:parent_id=>@code.id).each do |c|
		  c.destroy
		end
	else
	Code.all.each do |c|
		if c.parent_id == params[:id].to_i
			Code.where(:parent_id=>c.id).each do |c|
			c.destroy
			end
			c.destroy
		end
	end
	end
	@code.destroy 
	respond_to do |format|
		format.json { render :json=>{:success=>true} }
	end
end

def all
	if Code.where(:id=>params[:parent_id]).first.parent_id==1 || Code.where(:id=>params[:parent_id]).first.parent_id==0
		@codes=Code.order("code ASC").where(:parent_id=>params[:parent_id])
	else
		@codes=[]
	end
	respond_to do |format|
		format.json { render json: @codes }
	end
end

def code_add
	@codeA=Code.find(params[:parent_id].to_i)
	@codeB=Code.find(@codeA.parent_id)
	@code=@codeB.code+@codeA.code+params[:code]
	flag = true
    params[:partparams]=params[:partparams] || params[:value]+' '+params[:precision]
	if flag
		params[:file] = params[:file] || ''
		if params[:file]!='' 
			@code=Code.create(:name=>params[:name], :parent_id=>params[:parent_id], :code=>@code, :footprint=>params[:footprint], :manufacturer=>params[:manufacturer], :partnum=>params[:partnum],  :flocation=>params[:file].original_filename, :partparams=>params[:partparams])
			cmd="cd #{Rails.root}/public ; mkdir ./data"
			flags = system(cmd)
			p flags
			Datafile.save(params[:file])
		else
			@code=Code.create(:name=>params[:name], :parent_id=>params[:parent_id], :code=>@code, :footprint=>params[:footprint], :manufacturer=>params[:manufacturer], :partparams=>params[:partparams],:partnum=>params[:partnum],:partparams=>params[:partparams])
		end
	end
	respond_to do |format|
	       format.json { render json: { :success=>flag  }, :content_type => 'text/html' }      
	end
end

def code_edit
  	flag = true
    params[:partparams]=params[:partparams] || params[:value]+' '+params[:precision]
	if flag
		@code = Code.find(params[:id])
		params[:file] = params[:file] || ''
		if params[:file]!='' 
		@code.update_attributes(:name=>params[:name], :code=>@code.code, :footprint=>params[:footprint], :manufacturer=>params[:manufacturer], :partnum=>params[:partnum], :partparams=>params[:partparams], :flocation=>params[:file].original_filename)
		cmd="cd #{Rails.root}/public ; mkdir ./data"
		flags = system(cmd)
	        Code.where(:footprint=>params[:footprint]).each do |s|
	          s.update_attributes(:flocation=>params[:file].original_filename)
	        end
		p flags
		Datafile.save(params[:file])
		else
		@code.update_attributes(:name=>params[:name], :code=>@code.code, :footprint=>params[:footprint], :manufacturer=>params[:manufacturer], :partparams=>params[:partparams], :partnum=>params[:partnum])
		end
	end
	 respond_to do |format|
		format.json { render :json=>{:success=>flag}, :content_type => 'text/html'}
	end
end

def code_delete
	ids = params[:id].split(/,/)
	ids.each do |id|
		@code = Code.find(id)
		@code.destroy
	end
	 respond_to do |format|
		format.json { render :json=>{:success=>true}}
	end
end

def lists
	if params[:start]=='-1'
	  params[:start]='0'
	end
	if params[:search_type]!='0'
		if params[:search_type] == '101100'
			if params[:value1].empty? && params[:value2].empty?
				@codes = Code.order("code ASC").where(:parent_id=>params[:parent_id]).offset(params[:start].to_i).limit(params[:limit].to_i)
				totalCount=10
			elsif params[:value1].empty? && !params[:value2].empty?
				@codes = Code.where(:parent_id=>params[:parent_id]).where("name like ? or code like ? or partnum like ? or footprint like ? or manufacturer like ? or partparams like ?","%#{params[:value2]}%","%#{params[:value2]}%","%#{params[:value2]}%","%#{params[:value2]}%","%#{params[:value2]}%","%#{params[:value2]}%").order("code ASC") 
				totalCount=10
			elsif !params[:value1].empty? && params[:value2].empty?
				@codes = Code.where(:parent_id=>params[:parent_id]).where("name like ? or code like ? or partnum like ? or footprint like ? or manufacturer like ? or partparams like ?","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value1]}%").order("code ASC") 
				totalCount=10
			else !params[:value1].empty? && !params[:value2].empty?
				@codes = Code.where(:parent_id=>params[:parent_id]).where("name like ? or code like ? or partnum like ? or footprint like ? or manufacturer like ? or partparams like ?","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value1]}%").where("name like ? or code like ? or partNum like ? or footprint like ? or manufacturer like ? or partparams like ?","%#{params[:value2]}%","%#{params[:value2]}%","%#{params[:value2]}%","%#{params[:value2]}%","%#{params[:value2]}%","%#{params[:value2]}%").order("code ASC")
				totalCount=10
			end
		elsif params[:search_type] == '100000'
			@codes = Code.where(:parent_id=>params[:parent_id]).where("name like ? or code like ? or partnum like ? or footprint like ? or manufacturer like ? or partparams like ? or name like ? or code like ? or partnum like ? or footprint like ? or manufacturer like ? or partparams like ?","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value2]}%","%#{params[:value2]}%","%#{params[:value2]}%","%#{params[:value2]}%","%#{params[:value2]}%","%#{params[:value2]}%").order("code ASC")
			totalCount=Code.where(:parent_id=>params[:parent_id]).where("name like ? or code like ? or partnum like ? or footprint like ? or manufacturer like ? or partparams like ? or name like ? or code like ? or partnum like ? or footprint like ? or manufacturer like ? or partparams like ?","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value1]}%","%#{params[:value2]}%","%#{params[:value2]}%","%#{params[:value2]}%","%#{params[:value2]}%","%#{params[:value2]}%","%#{params[:value2]}%").count
		end
	else
		@codes=Code.order("code ASC").where(:parent_id=>params[:parent_id]).limit(params[:limit].to_i).offset(params[:start].to_i)
		totalCount=Code.where(:parent_id=>params[:parent_id]).count
	end

	respond_to do |format|
		format.html  
		format.json { render json: { :totalCount=>totalCount, :gridData=> @codes.collect{ |list|{ :id=>list.id, :partparams=>list.partparams,:name=>list.name, :code=>list.code, :partnum=>list.partnum, :footprint=>list.footprint, :manufacturer=>list.manufacturer, :flocation=>list.flocation.nil? ? 'no' : 'yes'}} } }
		format.js 
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

def importcode
  	respond_to do |format|
    	format.js
  	end
end

def codein
  	if params[:file] 
      arr=Code.import(params[:file])
	end
	if arr==[]
		flag=true
	else
		flag=false
	end
	respond_to do |format|
		format.json { render json: { :success=>flag, :message=>params[:file].original_filename, :arr=>arr }, :content_type => 'text/html' }
     end
end

end
