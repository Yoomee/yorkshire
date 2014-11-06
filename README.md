## Study in Yorkshire

### Updating the content of the iOS app

**NB** The rake task relies on the Rails and iOS projects being in specific directories.

Clone this repository to the `Rails` directory:
	
	git clone git@gitlab.yoomee.com:yoomee/yorkshire.git ~/Rails/yorkshire
	
Clone the iOS app repository to the `iOS` directory:

	git clone git@gitlab.yoomee.com:yoomee/yorkshire-ios.git ~/iOS/yorkshire-ios

Fetch the latest database from the website:
	
	cd ~/Rails/yorkshire && bundle exec ym db:fetch
	
Generate new SQLite database for app and export all assets:

	cd ~/Rails/yorkshire && bundle exec rake export_all
	
This export task does the following:

* Generate SQLite database of CMS text content and copy into iOS project
* Download all page and photo images, resize and convert to retina and non-retina sizes and copy into iOS project
* Download all inline images from CMS pages and copy into iOS project

