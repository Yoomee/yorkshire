require "sqlite3"

task :download => :environment do
  puts "Downloading all missing images"
  User.all.each  {|u| YmCore::ImageDownloader::download_image_if_missing(u.image) if u.image_uid.present?}
  Page.all.each  {|p| YmCore::ImageDownloader::download_image_if_missing(p.image) if p.image_uid.present?}
  Photo.all.each {|p| YmCore::ImageDownloader::download_image_if_missing(p.image) if p.image_uid.present?}
  RedactorUpload.all.each {|p| YmCore::ImageDownloader::download_image_if_missing(p.file) if p.file_uid.present?}
end

task :sqlite => :environment do
  db = SQLite3::Database.new("lib/StudyInYorkshire.sqlite")
  puts "Exporting pages."
  db.execute2("DELETE FROM ZPAGE;")
  Page.published.where("slug!='app-welcome'").each do |page|
    puts page.id
    db.execute2("INSERT INTO ZPAGE (Z_PK,Z_ENT,Z_OPT,ZPARENT,ZSLUG,ZPOSITION,ZCOLORR,ZCOLORG,ZCOLORB,ZVIEWNAME,ZBACKGROUNDNUMBER,ZHEADERNUMBER,ZIMAGEUID,ZTEXT,ZTITLE,ZLATITUDE,ZLONGITUDE,ZFAVOURITE) VALUES (#{page.id},1,1,#{page.parent_id.presence || 'null'},'#{quote_string(page.slug)}',#{page.position || 0},#{page.app_color.present? ? hex_to_rgb(page.app_color).join(','): 'null,null,null'},'#{quote_string(page.view_name.presence)}',#{page.app_background.presence || 'null'},#{page.app_header.presence || 'null'},'#{quote_string(page.image_uid)}','#{quote_string(page.text)}','#{quote_string(page.title)}',#{page.latitude.try(:strip) || 'null'},#{page.longitude.try(:strip) || 'null'},0);")
  end
  
  puts "Exporting photos."
  db.execute2("DELETE FROM ZPHOTO;")
  Photo.all.each_with_index do |photo, idx|
    puts photo.id
    db.execute2("INSERT INTO ZPHOTO (Z_PK,Z_ENT,Z_OPT,ZIMAGEUID,ZCAPTION,ZPOSITION) VALUES (#{photo.id},1,1,'#{quote_string(photo.image_uid)}','#{quote_string(photo.caption)}',#{idx});")
  end
  system "cp ~/Rails/yorkshire/lib/StudyInYorkshire.sqlite ~/iOS/StudyInYorkshire/StudyInYorkshire"
end

def quote_string(s)
  return '' if s.blank?
  s.gsub(/\\/, '\&\&').gsub(/'/, "''")
end

def timestamp(time)
  "%9.5f" % time.to_f
end

def hex_to_rgb(hexcolor)
  hexcolor = hexcolor.sub(/#/,"")
  hexcolor.scan(/../).collect{|str| "%.2f" % (str.hex.to_f/255)}
end
