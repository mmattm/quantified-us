# uri = URI.parse(ENV["REDISTOGO_URL"])
# REDIS = Redis.new(:url => uri)

# class DataCache
#   def self.data
#     puts "DEBUG ——————— DATA"
#     #@data ||= Redis.new(host: 'localhost', port: 6379)
#     #uri = URI.parse(ENV["REDISTOGO_URL"])
#     #@data ||= Redis.new(:url => uri)
#   end

#   def self.set(key, value)
#     data.set(key, value)
#   end

#   def self.get(key)
#     data.get(key)
#   end

#   def self.get_i(key)
#     data.get(key).to_i
#   end
# end