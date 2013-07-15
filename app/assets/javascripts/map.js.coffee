$(document).ready ->
  if $("#mapPreview").length or $("#baiduMap").length
    if $("#mapPreview").length
      map = new BMap.Map("mapPreview")
    else
      map = new BMap.Map("baiduMap")
    map.addControl new BMap.NavigationControl()
    map.addControl new BMap.ScaleControl()
    myGeo = new BMap.Geocoder()

    updateMap = $.debounce(200, (location) ->
        markers = map.getOverlays()
        i = 0
        while i < markers.length
          map.removeOverlay markers[i]
          i++

        myGeo.getPoint location, ((point) ->
          if point
            map.centerAndZoom point, 17
            map.addOverlay new BMap.Marker(point)
        ), "中国")

    $("#event_location").keyup ->
      updateMap(@value)

    updateMap $("#event_location").val() unless $("#event_location").val() is ""
    updateMap $("#baiduMap").data("location") if $("#baiduMap").length

  mapImages = $("div.event-map img")
  if mapImages.length > 0
    mapImages.each (index) ->
      mapModalId = "mapModal#{index}"
      mapModal = $("<div id='#{mapModalId}' class='modal hide fade'><div class='modal-body'></div><div class='modal-footer'><button class='btn' data-dismiss='modal' aria-hidden='true'>Close</button></div></div>")
                    .appendTo('body')
      $(this).clone().appendTo(mapModal.find('.modal-body'))
      $(this).on 'click', ->
        $("\##{mapModalId}").modal('show')
