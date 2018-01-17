1) In order to activate and configure the WIFI, copy wifi.conf.dist to 
   wifi.conf and edit according your setup.
   
2) You may define multiple stations to connect to:
   ...
   mode = "station",
   station = {
      {
         config = { 
            ssid = "WLAN1",
            pwd = "1234",
         }
      },
      {
         config = { 
            ssid = "WLAN2",
            pwd = "5678"
         }
      }
   },
   ap = { 
   ...

   and it will start to try to connect the first, and if the access point is
   not found tries the next.
