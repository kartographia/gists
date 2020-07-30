# Street View

Google Maps makes it easy to construct a URL to a street view. Example
```url
http://maps.google.com/?cbll=38.905504413297976,-77.05442186093448&cbp=12,0,,0,5&layer=c
```

- The `cbll` parameter is the lat/lon
- The `cbp` parameter accepts 5 variables
  - Street View/map arrangement, 11=upper half Street View and lower half map, 12=mostly Street View with corner map
  - Rotation angle/bearing (in degrees)
  - Tilt angle, -90 (straight up) to 90 (straight down)
  - Zoom level, 0-2
  - Pitch (in degrees) -90 (straight up) to 90 (straight down), default 5

Note that Google will redirect you to the nearest point (point nearest to the request lat/lon). 

## iFrame

If you want to use the url in an iframe, you will need to append a `&output=svembed` parameter to the url.
```html
<iframe 
  src="http://maps.google.com/?cbll=38.905504413297976,-77.05442186093448&cbp=12,0,,0,5&layer=c&output=svembed" 
  width="100%" height="100%" frameborder="0" style="border:0;" allowfullscreen="" aria-hidden="false" tabindex="0">
</iframe>
```

### References
http://asnsblues.blogspot.com/2011/11/google-maps-query-string-parameters.html
https://stackoverflow.com/questions/2759639/link-to-google-streetview-using-lat-long
https://www.thedataschool.com.au/ivy-yin/how-to-embed-google-street-view-in-tableau/
