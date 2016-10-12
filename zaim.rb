require "oauth"
require "json"


class Zaim
  API_URL = 'https://api.zaim.net/v2/'
  def initialize
    val = File.open("pass.txt","r:utf-8").readlines()
    consumer_key = val[2].strip
    consumer_secret = val[3].strip
    token = val[4].strip
    token_secret = val[5].strip

    consumer = OAuth::Consumer.new(consumer_key, consumer_secret,
                                   site: 'https://api.zaim.net',
                                   request_token_path: '/v2/auth/request',
                                   authorize_url: 'https://auth.zaim.net/users/auth',
                                   access_token_path: '/v2/auth/access')
    @access_token = OAuth::AccessToken.new(consumer, token, token_secret)

    verify = @access_token.get("#{API_URL}home/user/verify")
  end

  # e.g.
  #{ :mapping => 1 , :category_id => 101 , :genre_id => 10104 , :amount => 12345
  # , :date => "2016-10-7" , :name="パン" , :place => "北部生協" }
  def create_payment( payment )
    res = @access_token.post("#{API_URL}home/money/payment",payment)
    p res
  end

end


za = Zaim::new
za.create_payment({ :mapping => 1 , :category_id => 101 , :genre_id => 10104 , :amount => 12345,
                    :date => "2016-10-7" , :name => "パン" , :place => "北部生協" })