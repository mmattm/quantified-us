uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:url => uri)


Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }

Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")
#Dir["/app/app/jobs/*.rb"].each { |file| require file }

