window.UniversitiesMap =
	init: ->
    mapOptions = {
      center: new google.maps.LatLng(53.653,-0.986),
      mapTypeId: google.maps.MapTypeId.TERRAIN,
      streetViewControl: false,
      mapTypeControl: false,
      zoom: 7
    }
    
    UniversitiesMap.map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
    UniversitiesMap.infowindow = new google.maps.InfoWindow({maxWidth: 400})

    for university in UniversitiesMap.universities
      marker = new google.maps.Marker({
          position: new google.maps.LatLng(university.latitude, university.longitude),
          map: UniversitiesMap.map,
          title:university.title
      });
      marker.userId = university.id
      marker.contentString = "<div class='user-infowindow'><h4>#{university.title}</h4><a href='/#{university.permalink_path}'>View profile &rarr;</a></div>"
      google.maps.event.addListener marker, 'click', ->
        UniversitiesMap.infowindow.close()
        UniversitiesMap.infowindow.setContent(this.contentString)
        UniversitiesMap.infowindow.open(UniversitiesMap.map,this);