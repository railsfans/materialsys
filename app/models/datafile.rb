class Datafile < ActiveRecord::Base
  attr_accessor :upload
  def self.save(upload)
    name = upload.original_filename
    directory = 'public/data'
    path = File.join(directory,name)
    File.open(path, "wb") { |f| f.write(upload.read)}
  end 
end
