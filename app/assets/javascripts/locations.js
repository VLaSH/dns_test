function drawMap(coordinates, ip) {
  $('#map').html('');
  var myMap = new ymaps.Map('map', {
      center: coordinates,
      zoom: 10
  }, {
      searchControlProvider: 'yandex#search'
  });
  var myGeoObject = new ymaps.GeoObject({
       geometry: {
           type: "Point",
           coordinates: coordinates
       },
       properties: {
         iconContent: ip
       }
   }, {
       preset: 'islands#blackStretchyIcon',
       draggable: false
   });
   myMap.geoObjects.add(myGeoObject);
}
