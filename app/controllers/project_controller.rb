class ProjectController < ApplicationController
def list
	respond_to do |format|
		format.js
	end
end

def lists
	@projects=Project.all
	respond_to do |format|
		format.json { render :json =>{ :totalCount=>@projects.count, :gridData=>@projects }}
	end
end

def project_add
	flag=true
	Project.all.each do |p|
	if p.name==params[:name]
		flag=false
	end
	end
	if flag
		Project.create(:name=>params[:name], :manager=>params[:manager], :describes=>params[:describes], :menber=>params[:menber])
	end
	respond_to do |format|
		format.json { render :json=>{ :success=>flag} }
	end
end

def project_edit
	flag=true
	Project.where("id != ?", params[:id]).each do |p|
	if p.name==params[:name]  
		flag=false
	end
	end
	if flag
		@project=Project.find(params[:id])
		@project.update_attributes(:name=>params[:name], :manager=>params[:manager], :describes=>params[:describes], :menber=>params[:menber])
	end
	respond_to do |format|
		format.json { render :json=>{ :success=>flag}}
	end
end

def project_delete
	@project=Project.find(params[:id])
	@project.destroy
	respond_to do |format|
		format.json { render :json=>{ :success=>true}}
	end
end

def boms
	params[:filename]=params[:filename] || ""
	@con=params[:filename]
	@con="%"+@con+"%"
	if params[:filename]=="" 
		@boms=Bomfile.where(:project_id=>params[:id])
	else
		@boms=Bomfile.where(:project_id=>params[:id]).where("filename like ?",@con)
	end
	respond_to do |format|
		format.json { render :json=>{ :gridData=>@boms }}
	end
end

def samples
	params[:filename]=params[:filename] || ""
	@con=params[:filename]
	@con="%"+@con+"%"
	if params[:filename]=="" 
		@samples=Samplefile.where(:project_id=>params[:id])
	else
		@samples=Samplefile.where(:project_id=>params[:id]).where("filename like ?",@con)
	end
	respond_to do |format|
		format.json { render :json=>{ :gridData=>@samples }}
	end
end

end
