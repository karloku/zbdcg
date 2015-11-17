class ZbGenerator
  attr_accessor :user_id, :text

  def initialize(user_id, text)
    self.user_id = user_id
    self.text = text
  end

  def generate
    
    display_name = generate_display_name
    sentiment = get_sentiment

    color = get_color(sentiment)

    response = {
      response_type: 'in_channel',
      attachments: [
        {
          fallback: "看看谁在装逼",

          color: color,

          author_name: display_name,

          text: text,

          # fields: [
          #   {
          #     title: "Positive",
          #     value: '%.4f' % sentiment.first,
          #     short: true
          #   },
          #   {
          #     title: "Negative",
          #     value: '%.4f' % sentiment.last,
          #     short: true
          #   },
          # ]
        }
      ]
    }
    Oj.dump response, mode: :compat
  end

  def generate_display_name
    Digest::MD5.base64digest("#{user_id}#{Date.today.to_s}")[0..3]
  end

  def get_sentiment
    text.c_sentiment.first
  end

  def get_color(sentiment)
    r, g = 255, 255

    case sentiment.first 
    when 0..0.5
      g -= sentiment.first * 255
    else
      r -= sentiment.last * 255
    end

    "##{ '%02x' % r }#{ '%02x' % g }00".upcase
  end

end