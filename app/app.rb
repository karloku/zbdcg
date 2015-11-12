require 'rack'
require 'uri'
require 'oj'
require 'date'
require 'digest'
require 'net/http'
require 'rest-client'

class Zbdcg
  def call(env)
    input = env['rack.input'].read
    params = Hash[input.each_line.flat_map { |l| URI.decode_www_form(l.strip) }]
    response_url = params["response_url"]
    RestClient.post response_url, create_zb(params["user_id"], params["text"]), content_type: 'application/json'
    [
      '200', 
      {}, 
      []
    ]
  end

  def create_zb(user_id, text)
    user_name = Digest::MD5.base64digest("#{user_id}#{Date.today.to_s}")
    response = {}
    response['response_type'] = 'in_channel'
    response['text'] = user_name
    response['attachments'] = [{'text' => text}]
    Oj.dump response
  end
end
