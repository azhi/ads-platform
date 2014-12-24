echo '--- installing gems'
bundle install --without development
echo '--- updating configs from examples'
for file in $(ls config/*.example)
do
  cp $file ${file%.example}
done
echo '--- preparing test db'
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:test:prepare