class Ranking < Scene
  def initialize(user_name, score)
    @@font_big = Font.new(120, "Poco")
    @@font_nomal = Font.new(100, "Poco")
    @@font_mini = Font.new(48, "Poco")

    @@user_db = open("user") do |io|
      JSON.load(io)
    end
    t = Time.now
    min = t.min == 0 ? "00" : t.min
    @@user_db[user_name] = {
      "score" => score.to_i,
      "time" => [t.year, "/", t.month, "/", t.day, " ", t.hour, ":", min].join
    }

    str = JSON.pretty_generate(@@user_db)
    File.open("user", "w") do |f|
      f.write(str)
      f.write("\n")
    end


    @@rank_table = []
    @@user_db.each_with_index do |item, i|
      name = item[0]
      score = item[1]["score"]
      time = item[1]["time"]
      w = [
        @@font_big.get_width("#{name}") + 20,
        @@font_nomal.get_width("#{score}") + 20,
        @@font_mini.get_width("#{time}") + 20
      ]
      name_img =  Image.new(w[0], @@font_big.size   * 0.8, [30, 30, 30]).draw_font(10, -30, "#{name}", @@font_big)
      score_img = Image.new(w[1], @@font_nomal.size * 0.8, [30, 30, 30]).draw_font(10, -20, "#{score}", @@font_nomal)
      time_img =  Image.new(w[2], @@font_mini.size       , [30, 30, 30]).draw_font(10, -10, "#{time}", @@font_mini, [240, 240, 240])
      @@rank_table << Sprite.new(220, 200 + i*@@font_big.size, name_img)
      @@rank_table << Sprite.new(470, 200 + i*@@font_big.size + name_img.height - score_img.height - 10, score_img)
      @@rank_table << Sprite.new(670, 200 + i*@@font_big.size + name_img.height - time_img.height - 10, time_img)
    end
  end

  class << self
    def draw
      Sprite.draw(@@rank_table)
    end
  end
end
