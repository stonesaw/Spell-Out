class Ranking < Scene
  def initialize(user_name, score)
    @@font_title = Font.new(140, 'Poco')
    @@font_big   = Font.new(120, 'Poco')
    @@font_nomal = Font.new(100, 'Poco')
    @@font_mini  = Font.new(48, 'Poco')

    begin
      @@user_db = open('user') {|io| JSON.load(io) }
    rescue StandardError
      @@user_db = {}
    end

    t = Time.now
    min = t.min == 0 ? '00' : t.min
    @@user_db.store(user_name, {
                      'score' => score.to_i,
                      'time' => [t.year, '/', t.month, '/', t.day, ' ', t.hour, ':', min].join
                    })

    @@user_db = @@user_db.sort_by {|data| [-data[1]['score'], data[0].upcase] }
    @@user_db.pop(@@user_db.length - 10) if @@user_db.length > 10
    @@user_db = @@user_db.to_h

    str = JSON.pretty_generate(@@user_db)
    File.open('user', 'w') do |f|
      f.write(str)
      f.write("\n")
    end

    str = 'SCORE RANKING'
    w = @@font_title.get_width(str)
    img = Image.new(w + 20, @@font_title.size * 0.8).draw_font(10, -36, str, @@font_title)
    @@title = Sprite.new((Window.width - img.width) / 2, 60, img)

    @@table = []
    @@user_db.each_with_index do |item, i|
      break if i >= 5

      name = item[0]
      score = item[1]['score']
      time = item[1]['time']
      w = [
        @@font_big.get_width(name.to_s) + 20,
        @@font_nomal.get_width(score.to_s) + 20,
        @@font_mini.get_width(time.to_s) + 20
      ]
      name_s =  @@font_big.get_width('AAAAAAAA')
      score_s = name_s + @@font_big.get_width('1000')
      name_img =  Image.new(w[0], @@font_big.size   * 0.8).draw_font(10, -30, name.to_s, @@font_big)
      score_img = Image.new(w[1], @@font_nomal.size * 0.8).draw_font(10, -20, score.to_s, @@font_nomal)
      time_img =  Image.new(w[2], @@font_mini.size).draw_font(10, -10, time.to_s, @@font_mini, [240, 240, 240])
      @@table << Sprite.new(240,           220 + i * @@font_big.size * 0.9, name_img)
      @@table << Sprite.new(260 + name_s,  220 + i * @@font_big.size * 0.9 + name_img.height - score_img.height - 10, score_img)
      @@table << Sprite.new(280 + score_s, 220 + i * @@font_big.size * 0.9 + name_img.height - time_img.height - 10, time_img)
    end
  end

  class << self
    def update
      SceneManager.next(:title) if Input.key_push?(K_RETURN) || Input.key_push?(K_SPACE)
    end

    def draw
      @@title.draw
      Sprite.draw(@@table)
    end
  end
end
