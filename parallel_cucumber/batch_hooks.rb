require 'parallel_cucumber/dsl'
require 'json'


ParallelCucumber::DSL.after_batch do |outcome, _batch_id, env|

end


def ran_twice?(scenario)
  redis.get('rerun').include?(scenario)
end

def redis
  @redis ||= Redis.new(url: ENV['REDIS'])
end

def requeue(scenario)
  puts "=#=#=#=#=#=#=#=# Requeue #{scenario} =#=#=#=#=#=#=#=#"
  redis.lpush('rerun', scenario)
  redis.rpush('tests', scenario)
end