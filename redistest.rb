redis = Redis.new(url: ENV['REDIS_URL'])
redis.ping
