class ManagerController < ApplicationController
helper :manager
def importmaterial
	respond_to do |format|
		format.js
	end
end

def outportmaterial
	respond_to do |format|
		format.js
	end
end

def importrecords
    situ=t('import')
    params[:keyname]=params[:keyname] || ''
    params[:begintime]=params[:begintime] || ''
    params[:endtime]=params[:endtime] || ''	
    if params[:keyname].empty? && params[:begintime].empty? && params[:endtime].empty?
		@componentRecords=Record.where(:situ=>situ).offset(params[:start].to_i).limit(params[:limit].to_i)
		totalCount=Record.where(:situ=>situ).count
	else if !params[:keyname].empty? && params[:begintime].empty? && params[:endtime].empty?
		@componentRecords=Record.where(:situ=>situ).where("people like ?  or situ like ? ","%#{params[:keyname]}%","%#{params[:keyname]}%") 
		totalCount=10
	else if params[:keyname].empty? && !params[:begintime].empty? && !params[:endtime].empty?
		begintime=Time.new(params[:begintime].split('T')[0].split('-')[0].to_i,params[:begintime].split('T')[0].split('-')[1].to_i,params[:begintime].split('T')[0].split('-')[2].to_i)
		endtime=Time.new(params[:endtime].split('T')[0].split('-')[0].to_i,params[:endtime].split('T')[0].split('-')[1].to_i,params[:endtime].split('T')[0].split('-')[2].to_i)
		@componentRecords=Record.where(:situ=>situ).where("?<=date and date<=?",begintime.to_s,endtime.to_s) 
		totalCount=10
	else
		begintime=Time.new(params[:begintime].split('T')[0].split('-')[0].to_i,params[:begintime].split('T')[0].split('-')[1].to_i,params[:begintime].split('T')[0].split('-')[2].to_i)
		endtime=Time.new(params[:endtime].split('T')[0].split('-')[0].to_i,params[:endtime].split('T')[0].split('-')[1].to_i,params[:endtime].split('T')[0].split('-')[2].to_i)
		@componentRecords=Record.where(:situ=>situ).where("people like ?  or situ like ? ","%#{params[:keyname]}%","%#{params[:keyname]}%").where("?<=date and date<=?",begintime.to_s,endtime.to_s) 
		totalCount=10
	end
	end 
	end
    respond_to do |format|
      format.json{render :json =>{ :totalCount=>totalCount, :gridData=> @componentRecords.collect{ |list|{ :id=>list.id, :people=>list.people, :situ=>list.situ, :date=>list.date.split(' ')[0], :rlocation=>list.rlocation}} }}
    end
end

def outportrecords
    situ=t('outport')
    params[:keyname]=params[:keyname] || ''
    params[:begintime]=params[:begintime] || ''
    params[:endtime]=params[:endtime] || ''	
    if params[:keyname].empty? && params[:begintime].empty? && params[:endtime].empty?
		@componentRecords=Record.where(:situ=>situ).offset(params[:start].to_i).limit(params[:limit].to_i)
		totalCount=Record.where(:situ=>situ).count
	else if !params[:keyname].empty? && params[:begintime].empty? && params[:endtime].empty?
		@componentRecords=Record.where(:situ=>situ).where("people like ?  or situ like ? ","%#{params[:keyname]}%","%#{params[:keyname]}%") 
		totalCount=20
	else if params[:keyname].empty? && !params[:begintime].empty? && !params[:endtime].empty?
		begintime=Time.new(params[:begintime].split('T')[0].split('-')[0].to_i,params[:begintime].split('T')[0].split('-')[1].to_i,params[:begintime].split('T')[0].split('-')[2].to_i)
		endtime=Time.new(params[:endtime].split('T')[0].split('-')[0].to_i,params[:endtime].split('T')[0].split('-')[1].to_i,params[:endtime].split('T')[0].split('-')[2].to_i)
		@componentRecords=Record.where(:situ=>situ).where("?<=date and date<=?",begintime.to_s,endtime.to_s) 
		totalCount=20
	else
		begintime=Time.new(params[:begintime].split('T')[0].split('-')[0].to_i,params[:begintime].split('T')[0].split('-')[1].to_i,params[:begintime].split('T')[0].split('-')[2].to_i)
		endtime=Time.new(params[:endtime].split('T')[0].split('-')[0].to_i,params[:endtime].split('T')[0].split('-')[1].to_i,params[:endtime].split('T')[0].split('-')[2].to_i)
		@componentRecords=Record.where(:situ=>situ).where("people like ?  or situ like ? ","%#{params[:keyname]}%","%#{params[:keyname]}%").where("?<=date and date<=?",begintime.to_s,endtime.to_s) 
		totalCount=20
	end
	end 
	end
    respond_to do |format|
        format.json{render :json =>{ :totalCount=>totalCount, :gridData=> @componentRecords.collect{ |list|{ :id=>list.id, :people=>list.people, :situ=>list.situ, :date=>list.date.split(' ')[0], :rlocation=>list.rlocation}} }}
    end
end


def storein
     if params[:photo]
      cmd="cd #{Rails.root}/public ; mkdir ./recorddata"
      system(cmd)
      arr=Record.import(params[:photo], current_user.username)
     end
      if arr==[]
      flag=true
     else
      flag=false
     end
     respond_to do |format|
		format.json { render json: { :success=>flag, :message=>params[:photo].original_filename, :arr=>arr }, :content_type => 'text/html' }
     end
end

def storeout
     arr=[]
     if params[:photo]
      	cmd="cd #{Rails.root}/public ; mkdir ./recorddata"
      	system(cmd)
      	arr=Record.outport(params[:photo], current_user.username)
     end
     if arr==[]
      	flag=true
     else
      	flag=false
     end
    
     respond_to do |format|
		format.json { render json: { :success=>flag, :message=>params[:photo].original_filename, :arr=>arr }, :content_type => 'text/html' }
     end
end

def importrecordlist
   params[:keyname]=params[:keyname] || ''
	if params[:keyname].empty?
		@componentRecords=Store.where(:record_id=>params[:record_id]).offset(params[:start].to_i).limit(params[:limit].to_i)
		totalCount=Store.where(:record_id=>params[:record_id]).count
	else if params[:type]=='100000'
		@componentRecords=Store.where(:record_id=>params[:record_id]).where("name like ?  or partnum like ? or code like ?","%#{params[:keyname]}%","%#{params[:keyname]}%","%#{params[:keyname]}%") 
		totalCount=20
	else if params[:type]=='101100'
		@componentRecords=Store.where(:record_id=>params[:record_id]).where("code like ?","%#{params[:keyname]}%") 
		totalCount=20
	else if params[:type]=='102200'
		@componentRecords=Store.where(:record_id=>params[:record_id]).where("name like ? ","%#{params[:keyname]}%") 
		totalCount=20
	else if params[:type]=='103300'
		@componentRecords=Store.where(:record_id=>params[:record_id]).where("partnum like ? ","%#{params[:keyname]}%") 
		totalCount=20
	end
	end
	end
	end
	end
	respond_to do |format|
	   format.json { render :json =>{ :totalCount=>totalCount, :gridData=> @componentRecords.collect { |list| { :partnum=>list.partnum, :date=>Record.find(list.record_id).date, :footprint=>list.footprint, :name=>list.name, :code=>list.code, :comment=>list.comment,
 :quantity=>list.originquantity }} }}
	end
end


def outportrecordlist
   params[:keyname]=params[:keyname] || ''
	if params[:keyname].empty?
		@componentRecords=Outportrecord.where(:record_id=>params[:record_id]).offset(params[:start].to_i).limit(params[:limit].to_i)
		totalCount=Outportrecord.where(:record_id=>params[:record_id]).count
	else if params[:type]=='100000'
		@componentRecords=Outportrecord.where(:record_id=>params[:record_id]).where("name like ?  or partnum like ? or code like ?","%#{params[:keyname]}%","%#{params[:keyname]}%","%#{params[:keyname]}%") 
		totalCount=20
	else if params[:type]=='101100'
		@componentRecords=Outportrecord.where(:record_id=>params[:record_id]).where("code like ?","%#{params[:keyname]}%") 
		totalCount=20
	else if params[:type]=='102200'
		@componentRecords=Outportrecord.where(:record_id=>params[:record_id]).where("name like ? ","%#{params[:keyname]}%") 
		totalCount=20
	else if params[:type]=='103300'
		@componentRecords=Outportrecord.where(:record_id=>params[:record_id]).where("partnum like ? ","%#{params[:keyname]}%") 
		totalCount=20
	end
	end
	end
	end
	end
	respond_to do |format|
	   format.json { render :json =>{ :totalCount=>totalCount, :gridData=> @componentRecords.collect { |list| { :partnum=>list.partnum, :date=>list.date, :footprint=>list.footprint, :name=>list.name, :code=>list.code, :comment=>list.comment,
 :quantity=>list.quantity }} }}
	end
end

def download
	file='public/recorddata/'+params[:filename]
	p params[:filename]
	if File.file? file
	    send_file file,  :x_sendfile=>true
	else
	  render :text => "the file does not exist"
	end
end

def all
	respond_to do |format|
    	format.js
  	end
end

def allmaterial
	params[:value] = params[:value] || ''
	if params[:value].empty?
		@repository=Store.order("code ASC").offset(params[:start].to_i).limit(params[:limit].to_i)
		totalCount=Store.all.count
	else if params[:search_type]=='100000'
        pa = "%" + params[:value] + "%"
        storearr=[]
        supplierarr=[]
		Store.where("name like ? or code like ?  or partnum like ? or manufacturer like ? or supplier like ?",pa,pa,pa,pa,pa).each do |s|
        storearr<<s.id
        end
        Supplier.where("company like ?",pa).each do |s|
        supplierarr<<s.number
        end
        p supplierarr
        Store.all.each do |s|
        if supplierarr.include? s.supplier.to_i.to_s
        storearr<<s.id
        end
        end
		@repository=Store.find(storearr.uniq)
		totalCount=20
	else if params[:search_type]=='101100'
		pa = "%" + params[:value] + "%"
		@repository=Store.where("code like ?", pa)
		totalCount=20
	else if params[:search_type]=='102200'
		pa = "%" + params[:value] + "%"
		@repository=Store.where("name like ?", pa)
		totalCount=20
	else if params[:search_type]=='103300'
		pa = "%" + params[:value] + "%"
		@repository=Store.where("partnum like ?", pa)
		totalCount=20
	else if params[:search_type]=='104400'
		pa = "%" + params[:value] + "%"
		@repository=Store.where("manufacturer like ?", pa)
		totalCount=20
	else if params[:search_type]=='105500'
		pa = "%" + params[:value] + "%"
        storearr=[]
        supplierarr=[]
        Store.where("supplier like ?",pa).each do |s|
        storearr<<s.id
        end
        Supplier.where("company like ?",pa).each do |s|
        supplierarr<<s.number
        end
        p supplierarr
        Store.all.each do |s|
        if supplierarr.include? s.supplier.to_i.to_s
        storearr<<s.id
        end
        end
		@repository=Store.find(storearr.uniq)
		totalCount=20
	end
	end
	end
	end
	end
	end
	end
	i=0
	respond_to do |format|
      format.html 
      format.json { render json: { :totalCount=>totalCount, :gridData=> @repository.collect{ |list| i=i+1
 {:index=>i, :id=>list.id, :importtime=>list.importtime.to_s.split(' ')[0]+' '+list.importtime.to_s.split(' ')[1], :originquantity=>list.originquantity, :currentquantity=>list.currentquantity,:name=>list.name, :partnum=>list.partnum, :unitprice=>list.unitprice, :totalprice=>((list.currentquantity.to_i)*(list.unitprice.to_f)).round(2), :comment=>list.comment, :code=>list.code,  :manufacturer=>list.manufacturer, :footprint=>list.footprint, :supplier=>list.supplier.nil? ? '' : list.supplier.to_i==0 ? list.supplier : Supplier.where(:number=>list.supplier.to_i).first.try(:company), :partparams=>list.partparams} } } }
      format.js
    end
end

def supplierlist
	arr=[]
	params[:supplier]=params[:supplier] || ''
	if !params[:supplier].empty?
		params[:supplier].split(',').each do |s|
		 arr<<Supplier.where(:company=>s).first.id
		end
	end
	@supplier=Supplier.find(arr)
	totalCount=@supplier.count
	respond_to do |format|
	  	format.json { render :json=>{:totalCount=>totalCount, :gridData=>@supplier } }
	end
end

def fillvalue
flag = true
if Code.where(:code=>params[:id]).empty?
	flag=false
else
@code=Code.where(:code=>params[:id])
end
	respond_to do |format|
		format.json { render :json=>{:success=>flag, :data=> @code}}
	end
end

def material_add
	Store.create(:unitprice=>params[:unitprice], :currentquantity=>params[:currentquantity], :originquantity=>params[:originquantity],:comment=>params[:comment],:supplier=>params[:suppliers], :code=>params[:code], :importtime=>Time.now, :footprint=>params[:footprint], :partnum=>params[:partnum], :manufacturer=>params[:manufacturer], :name=>params[:name], :partparams=>params[:partparams])
	respond_to do |format|
		format.json { render :json=>{:success=>true} }
	end
end

def material_edit
	Store.find(params[:id]).update_attributes(:unitprice=>params[:unitprice], :currentquantity=>params[:currentquantity], :originquantity=>params[:originquantity],:comment=>params[:comment],:supplier=>params[:suppliers], :importtime=>Time.now, :footprint=>params[:footprint], :partnum=>params[:partnum], :manufacturer=>params[:manufacturer], :name=>params[:name], :partparams=>params[:partparams])
	respond_to do |format|
		format.json { render :json=>{:success=>true}}
	end
end

def material_delete
	Store.find(params[:id]).destroy
		respond_to do |format|
			format.json { render :json=>{:success=>true}}
		end
end

def bomupload
    flag=false
    arr=Store.check(params[:file])
    if arr==[]
    flag=true
    end
    p arr
	respond_to do |format|
		format.json { render :json=>{:success=>flag, :arr=>arr, :message=>params[:file].original_filename}, :content_type => 'text/html'}
	end
end

def createbom
    flag=false
    arr=Store.create(params[:file])
    if arr[0]==[]
    flag=true
    end
    $match=arr[1]
    p arr
	respond_to do |format|
		format.json { render :json=>{:success=>flag, :arr=>arr[0], :message=>params[:file].original_filename}, :content_type => 'text/html'}
	end
end

def searchmul
mularr=[]
storearr=[]
j=1
p params[:multmaterial]
for i in  params[:multmaterial].split('_') do
      Store.where(:partparams=>i.split(' ')[0]+' '+i.split(' ')[2], :footprint=>i.split(' ')[1]).each do |s|
      mularr<<s.id
      storearr<<j
      end
      j=j+1
end
num=0
    respond_to do |format|
   		format.json { render :json=>{:totalCount=>Store.find(mularr), :gridData=>Store.order('partparams ASC').find(mularr).collect { |list| num=num+1
 {:index=>storearr[num-1], :id=>list.id, :quantity=>list.currentquantity, :checked=>'false', :footprint=>list.footprint,
 :partparams=>list.partparams, :importtime=>list.importtime }} } }
 	end
end

def shortlist
totalCount=params[:shortid].split('_').length
p params[:shortid].split('_').length
	respond_to do |format|
   		format.json { render :json=>{:totalCount=>totalCount, :gridData=>params[:shortid].split('_').collect { |list| { :partparams=>list, :replacematerial=>''}} } }
 	end
end

def searchmaterial
	p params[:partparams]
	reg=/\d+[R|K|M]/
	arr=[]
    arrid=[]
	reqnum=params[:partparams].match(/\d+/)[0]
	requnit=params[:partparams].match(/[R|K|M]/)[0]
	if requnit=='K'
	    reqnum=reqnum.to_i*1000
    else if requnit=='M'
	    reqnum=reqnum.to_i*1000*1000
	end
    end
	Store.all.each do |s|
    	if params[:strict]=='true'
        condition=!s.try(:partparams).nil? && !s.partparams.match(reg).nil? && !(arr.include? s.partparams.match(reg)[0]) &&  s.footprint==params[:partparams].split(' ')[1]
        else
        condition=!s.try(:partparams).nil? && !s.partparams.match(reg).nil? && !(arr.include? s.partparams.match(reg)[0])
        end
		if condition
	    	num=s.partparams.match(reg)[0].match(/\d+/)[0].to_i
	    	unit=s.partparams.match(reg)[0].match(/[R|K|M]/)[0]
	    	if unit=='K'
	    		num=num*1000
            else if requnit=='M'
	    		reqnum=reqnum.to_i*1000*1000
			end
            end
	    arr<<num
	    arrid<<s.id
	    end
	end
    alist = arr.zip(arrid)
    ha=Hash[*alist.flatten]
    p ha
	arr<<reqnum
	p arr.sort
    p getscope(arr.sort, reqnum, 2)
    matcharr=[]
    getscope(arr.sort.uniq, reqnum, 2).each do |s|
    	matcharr<<ha[s]
	end
    p matcharr
	respond_to do |format|
        if params[:grid]=="left"
  		format.json { render :json=>{ :totalCount=>Store.find(matcharr).count, :gridData=>Store.order('partparams ASC').find(matcharr)} }
        else
        format.json { render :json=>{ :totalCount=>0, :gridData=>[]} }
        end
    end
end

helper_method :getposition, :getscope

def getposition(arr, target)
	num=0
	arr.each do |a|
    	if a==target
           break
		end
		num=num+1
	end
	return num
end

def getscope(arr, target, num)
	tar=getposition(arr, target).to_i
    request=[]
    requestup=[]
    requestdown=[]
    while tar+1<arr.length.to_i && requestup.length.to_i<num.to_i do 
    requestup<<arr[tar+1]
    tar=tar+1
    end
    tar=getposition(arr, target)
    while tar>0 && requestdown.length.to_i<num.to_i do 
    requestdown<<arr[tar-1]
    tar=tar-1
    end
    if requestup.length<num
    tar=getposition(arr, target)
    requestdown=[]
    while tar>0 && requestdown.length.to_i<2*num.to_i-requestup.length.to_i do 
    requestdown<<arr[tar-1]
    tar=tar-1
    end
    else if requestdown.length<num
    tar=getposition(arr, target)
   	requestup=[]
    while tar+1<arr.length.to_i && requestup.length.to_i<2*num.to_i-requestdown.length.to_i do 
    requestup<<arr[tar+1]
    tar=tar+1
    end
    end
    end
    return (requestup+requestdown).sort
end

def left
@supplier=[]
totalCount=0
	respond_to do |format|
   		format.json { render :json=>{:totalCount=>totalCount, :gridData=>@supplier } }
 	end
end

end
