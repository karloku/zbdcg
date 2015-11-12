class ZbGenerator
  attr_accessor :user_id, :text

  def initialize(user_id, text)
    self.user_id = user_id
    self.text = text
  end

  def generate
    
    display_name = generate_display_name
    sentiment = get_sentiment

    color = 
      case sentiment.first
      when sentiment.first >= 0.6
        "good"
      when sentiment.first >= 0.4
        "warning"
      else
        "danger"
      end

    response = {
      response_type: 'in_channel',
      attachments: [
        {
          fallback: "#{display_name} says:\ntext",

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
    Digest::MD5.base64digest("#{user_id}#{Date.today.to_s}")
  end

  def get_sentiment
    text.c_sentiment.first
  end
end