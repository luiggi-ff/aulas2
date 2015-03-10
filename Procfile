#api: RACK_ENV=test bundle exec rackup -p 9293
redis: redis-server
sidekiq: bundle exec sidekiq -e test
app: rails s -e test -p 3000