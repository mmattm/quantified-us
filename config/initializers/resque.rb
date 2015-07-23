ENV["REDISTOGO_URL"] = 'redis://redistogo:033a462f5971e491b77848446d345375@carp.redistogo.com:9787/'

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:url => uri)

Dir["/app/app/jobs/*.rb"].each { |file| require file }

