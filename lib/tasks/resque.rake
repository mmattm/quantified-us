require 'resque/tasks'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'resque/scheduler/tasks'

task "resque:setup" => :environment do
  ENV['QUEUE'] = '*'
end

