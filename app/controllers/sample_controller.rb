class SampleController < ApplicationController
def upload
	if params[:file]
		Sample.importSample(params[:file], params[:id])
	end
	respond_to do |format|
		format.json { render json: { :success=>true, :message=>params[:file].original_filename }, :content_type => 'text/html' }
	end
end
def show
	@sample=Sample.where(:samplefileid=>params[:samplefile_id]).offset(params[:start].to_i).limit(params[:limit].to_i)
	totalcount=Sample.where(:samplefileid=>params[:samplefile_id]).count
	respond_to do |format|
		format.json { render json: {:totalCount=>totalcount, :gridData=>@sample} }
	end
end

def sample_delete
	@sample=Samplefile.where(:project_id=>params[:id].to_i).where(:filename=>params[:sample]).first
	Sample.where(:samplefileid=>@sample.id).each do |m|
		m.destroy
	end 
	@sample.destroy

	respond_to do |format|
		format.json { render :json=>{:success=>true, :message=>@sample.filename}}
	end
end

end
