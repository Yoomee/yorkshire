require "sqlite3"

task :export_all do
  Rake::Task["sqlite"].invoke
  Rake::Task["download"].invoke
  Rake::Task["uploads"].invoke
  Rake::Task["export_photos"].invoke
end

task :export_photos => :environment do 
  Photo.all.each do |photo|
    # Get in and out paths
    puts photo.caption
    in_path = photo.image.path
    parts = in_path.split('/')
    filename = parts.pop
    out_path = parts.join('/').sub('data/dragonfly/development','ios_assets')
    system("mkdir -p #{out_path}")
    out_path += "/#{in_path.split('/').last.sub(/\.[^\.]*$/,'')}"
    # Copy/generate all images
    # iPad @2x
    system("cp #{in_path} #{out_path}~ipad@2x.jpg")
    # iPad
    system("convert #{in_path} -resize 1024x1024\\> #{out_path}~ipad.jpg")
    # iPhone @2x
    system("convert #{in_path} -resize 960x960\\> #{out_path}@2x.jpg")
    # iPhone
    system("convert #{in_path} -resize 480x480\\> #{out_path}.jpg")
    # Thumb
    system("convert #{in_path} -resize 185x185^ #{out_path}-thumb.jpg")
  end
  system("rm -rf ~/iOS/StudyInYorkshire/StudyInYorkshire/assets/2012")
  system("cp -r ~/Rails/yorkshire/ios_assets/2012 ~/iOS/StudyInYorkshire/StudyInYorkshire/assets")
end

task :uploads => :environment do
  system("mkdir -p #{Rails.root}/ios_assets/media")
  Page.all.each do |page|
    page.text.scan(/<img src=\"([^\"]*)/).flatten.each do |path|
      unless File.exists?("./ios_assets/#{path}")
        system("curl #{Settings.live_site_url}#{path} -o ios_assets/#{path}")
        system("convert ios_assets/#{path} -resize 2048x2048\\> ios_assets/#{path}")
      end
    end
  end
  system("rm -rf ~/iOS/StudyInYorkshire/StudyInYorkshire/assets/media")
  system("cp -r ~/Rails/yorkshire/ios_assets/media ~/iOS/StudyInYorkshire/StudyInYorkshire/assets")
end

task :download => :environment do
  puts "Downloading all missing images"
  User.all.each  {|u| YmCore::ImageDownloader::download_image_if_missing(u.image) if u.image_uid.present?}
  Page.all.each  {|p| YmCore::ImageDownloader::download_image_if_missing(p.image) if p.image_uid.present?}
  Page.all.each  {|p| YmCore::ImageDownloader::download_image_if_missing(p.header_image) if p.header_image_uid.present?}
  Photo.all.each {|p| YmCore::ImageDownloader::download_image_if_missing(p.image) if p.image_uid.present?}
  RedactorUpload.all.each {|p| YmCore::ImageDownloader::download_image_if_missing(p.file) if p.file_uid.present?}
end

task :sqlite => :environment do
  db = SQLite3::Database.new("lib/StudyInYorkshire.sqlite")
  puts "Exporting pages..."
  db.execute2("DELETE FROM ZPAGE;")
  Page.published.where("slug!='app-welcome'").each do |page|
     db.execute2("INSERT INTO ZPAGE (Z_PK,Z_ENT,Z_OPT,ZPARENT,ZSLUG,ZPOSITION,ZCOLORR,ZCOLORG,ZCOLORB,ZVIEWNAME,ZBACKGROUNDNUMBER,ZHEADERIMAGEUID,ZIMAGEUID,ZTEXT,ZTITLE,ZLATITUDE,ZLONGITUDE,ZFAVOURITE,ZPERMALINK) VALUES (#{page.id},1,1,#{page.parent_id.presence || 'null'},'#{quote_string(page.slug)}',#{page.position || 999},#{page.app_color.present? ? hex_to_rgb(page.app_color).join(','): 'null,null,null'},'#{quote_string(page.view_name.presence)}',#{page.app_background.presence || 'null'},'#{quote_string(page.image_uid)}','#{quote_string(page.image_uid)}',?,?,#{page.latitude.try(:strip).presence || 'null'},#{page.longitude.try(:strip).presence || 'null'},0,?);",page.text,page.title,page.permalink_path)
  end
  
  puts "Copying backgrounds..."
  system("rm -f ~/iOS/StudyInYorkshire/StudyInYorkshire/Images/Backgrounds/*")
  system("cp ~/Rails/yorkshire/app/assets/images/background_*.jpg ~/iOS/StudyInYorkshire/StudyInYorkshire/Images/Backgrounds")
  
 puts "Exporting photos."
 db.execute2("DELETE FROM ZPHOTO;")
 Photo.all.each_with_index do |photo, idx|
   db.execute2("INSERT INTO ZPHOTO (Z_PK,Z_ENT,Z_OPT,ZIMAGEUID,ZCAPTION,ZPOSITION) VALUES (#{photo.id},1,1,'#{quote_string(photo.image_uid.sub(/\.[^\.]*$/,''))}','#{quote_string(photo.caption)}',#{idx});")
 end
 system "cp ~/Rails/yorkshire/lib/StudyInYorkshire.sqlite ~/iOS/StudyInYorkshire/StudyInYorkshire"
end

def quote_string(s)
  return '' if s.blank?
  s.gsub(/\\/, '\&\&').gsub(/[']/, "''")
end

def timestamp(time)
  "%9.5f" % time.to_f
end

def hex_to_rgb(hexcolor)
  hexcolor = hexcolor.sub(/#/,"")
  hexcolor.scan(/../).collect{|str| "%.2f" % (str.hex.to_f/255)}
end
