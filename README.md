Setup

 git clone https://github.com/luiggi-ff/aulas2.git

 cd am-api
 rbenv install 2.0.0-p481
 rbenv local  2.0.0-p481
 gem install bundle
 bundler install


 cd ..
 rbenv install 2.1.3                                                                                                       
 rbenv local  2.1.3
 gem install bundler
 bundle install
 gem install foreman


install redis       
 apt-get install redis-server
o
 yum install redis

Setup DB
 rake db:setup RAILS_ENV=test
 rake db:migrate RAILS_ENV=test
 rake db:fixtures:load  RAILS_ENV=test
                                                          

------------------------------------------------------
Start app (test env)
 cd am-api; RACK_ENV=test bundle exec rackup -p 9293
 foreman start

open in browser: localhost:3000

User   / Password
admin    password
regular  password


-----------------------------------------------------
Run tests
 redis: redis-server
 sidekiq: bundle exec sidekiq -e test
 rake test
