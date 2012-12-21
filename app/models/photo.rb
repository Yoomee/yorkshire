class Photo < ActiveRecord::Base
  
  image_accessor :image
  
  validates :image, :presence => true
  validates_property :format, :of => :image, :in => [:jpeg, :jpg, :png, :gif], :message => "must be an image"
  
  def caption
    if image_uid =~ /_W2Y_/
      "#{read_attribute(:caption)} - With thanks to Welcome to Yorkshire for allowing us to use their image"
    else
      read_attribute(:caption)
    end
  end
  
  def next_photo
    Photo.where(['id > ?', id]).first
  end
  
end