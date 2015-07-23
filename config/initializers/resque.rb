uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:url => uri)


Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }
#Dir["/app/app/jobs/*.rb"].each { |file| require file }

