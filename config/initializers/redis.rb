require 'redis'
require 'redis/objects'

REDIS_CONFIG = YAML.load(File.open( Rails.root.join("config/redis.yml") )).symbolize_keys

default = REDIS_CONFIG[:default].symbolize_keys

$redis = Redis.new(default)
Redis::Objects.redis = $redis

$redis.flushdb if Rails.env = "test"

key = Rails.application.secrets[:cypher]["key"]
iv  = Rails.application.secrets[:cypher]["iv"]

Encryptor.default_options.merge!(algorithm: 'aes-256-cbc', key: key, iv: iv)
