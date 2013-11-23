class SupplierController < ApplicationController
def lists
	params[:value]= params[:value] || ''
	params[:type]=params[:type] || ''
	p params[:id]
	if params[:id].to_i!=1
		if params[:value].empty?
			@suppliers=Supplier.limit(params[:limit]).offset(params[:start])
			totalcount=Supplier.count
		else if params[:type]=='100000'
			pa = "%" + params[:value] + "%"
			@suppliers=Supplier.where("company like ? or address like ?  or contactor like ? or material like ? ",pa,pa,pa,pa)
			totalcount=20
		else if params[:type]=='101100'
			pa = "%" + params[:value] + "%"
			@suppliers=Supplier.where("company like ? ",pa)
			totalcount=20
		else if params[:type]=='102200'
			pa = "%" + params[:value] + "%"
			@suppliers=Supplier.where(" material like ? ",pa)
			totalcount=20
		else if params[:type]=='103300'
			pa = "%" + params[:value] + "%"
			@suppliers=Supplier.where(" contactor like ? ",pa)
			totalcount=20
		else if params[:type]=='104400'
			pa = "%" + params[:value] + "%"
			@suppliers=Supplier.where(" material like ? ",pa)
			totalcount=20
		end
		end
		end
		end
		end
		end
	else
		@suppliers=Supplier.limit(params[:limit]).offset(params[:start])
		totalcount=Supplier.all.count
	end
	respond_to do |format|
		format.json { render json: {:totalCount=>totalcount, :gridData=>@suppliers } } 
	end
end

def importsupplier
  respond_to do |format|
    format.js
  end
end

def supplierin
	if params[:file]
		Supplier.import(params[:file])
	end
	flag=true
	respond_to do |format|
		format.json { render json: { :success=>flag, :message=>params[:file].original_filename }, :content_type => 'text/html' }
	end
end

def supplier_add
	flag = true
	@suppliers=Supplier.all
	@suppliers.each do |su|
		if su.company==params[:company]
			flag=false
		end
	end
	if flag
		@su=Supplier.create(:company=>params[:company], :address=>params[:address], :email=>params[:email], :comment=>params[:comment], :phone=>params[:phone], :fax=>params[:fax], :contactor=>params[:contactor], :website=>params[:website], :number=>params[:number], :material=>params[:material])
	end
	respond_to do |format|
		format.json { render :json=>{:success=>flag} }
	end
end

def supplier_edit
	@supplier = Supplier.find(params[:id])
	@supplier.update_attributes(:company=>params[:company], :address=>params[:address], :email=>params[:email], :comment=>params[:comment], :phone=>params[:phone], :fax=>params[:fax], :contactor=>params[:contactor], :website=>params[:website], :material=>params[:material], :number=>params[:number])
 	respond_to do |format|
		format.json { render :json=>{:success=>true}}
	end
end

def supplier_delete
	ids = params[:id].split(/,/)
	ids.each do |id|
		@su = Supplier.find(id)
		@su.destroy
	end
	respond_to do |format|
		format.json { render :json=>{:success=>true}}
	end
end

end
