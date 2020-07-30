# Street View

Google Maps makes it easy to construct a URL to a street view. Example
```
http://maps.google.com/?cbll=38.905504413297976,-77.05442186093448&cbp=12,0,,0,5&layer=c
```

The `cbll` parameter is the lat/lon

The `cbp` parameter accepts 5 variables
(1) Street View/map arrangement, 11=upper half Street View and lower half map, 12=mostly Street View with corner map
(2) Rotation angle/bearing (in degrees)
(3) Tilt angle, -90 (straight up) to 90 (straight down)
(4) Zoom level, 0-2
(5) Pitch (in degrees) -90 (straight up) to 90 (straight down), default 5


Note that Google will redirect you to the nearest point (point nearest to the request lat/lon). 

If you want to use the url in an iframe, you will need to append a `&output=svembed` parameter to the url.


### References
http://asnsblues.blogspot.com/2011/11/google-maps-query-string-parameters.html