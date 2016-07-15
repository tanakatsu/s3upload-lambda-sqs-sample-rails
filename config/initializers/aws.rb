# encoding: utf-8

# ENV.fetch()だと rails consoleや rails runnerでエラーになる..
Aws.config = {
   :access_key_id => ENV['AWS_ACCESS_KEY_ID'], 
   :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
   :region => 'ap-northeast-1'
}
