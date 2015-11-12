require 'date'
require 'digest'
require 'net/http'
require 'singleton'

require File.expand_path("../zb_generator.rb", __FILE__)

class Zbdcg
  include Singleton

  def call(env)
    input = env['rack.input'].read
    params = Hash[input.each_line.flat_map { |l| URI.decode_www_form(l.strip) }]
    
    zb(params)

    [
      '200', 
      {}, 
      []
    ]
  end

  def zb(params)
    response_url = params["response_url"]

    zb_generator = ZbGenerator.new(params["user_id"], params["text"])
    puts zb_generator.generate
    RestClient.post response_url, zb_generator.generate, content_type: 'application/json'
  end
end
