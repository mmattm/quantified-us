Geocoder.configure(

  :timeout=>3,

  :lookup=>:yandex,

  :ip_lookup=>:telize,

  :language=>:en,

  :http_headers=>{},

  :use_https=>false,

  :http_proxy=>nil,

  :https_proxy=>nil,

  :api_key=>nil,

  :cache=>nil,

  :cache_prefix=>"geocoder:",

  :units=>:km,

  :distances=>:linear

)


# Geocoder.configure(

#   # geocoding service (see below for supported options):
#   :lookup => :yandex,

#   # IP address geocoding service (see below for supported options):
#   :ip_lookup => :maxmind,

#   # to use an API key:
#   :api_key => "...",

#   # geocoding service request timeout, in seconds (default 3):
#   :timeout => 10,

#   # set default units to kilometers:
#   :units => :km,

#   # caching (see below for details):
#   :cache => Redis.new,
#   :cache_prefix => "..."

# )