class Photo < ActiveRecord::Base
  
  image_accessor :image
  
  validates :image, :presence => true
  validates_property :format, :of => :image, :in => [:jpeg, :jpg, :png, :gif], :message => "must be an image"
  
  def next_photo
    Photo.where(['id > ?', id]).first
  end
  
end