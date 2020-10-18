# Scene - GameOver

class GameOver < Scene
  def initialize
    @@font_big = Font.new(140, "Poco")
    @@font_nomal = Font.new(90, "Poco")
    @@font_mini = Font.new(50, "Poco")
    @@title_width = @@font_big.get_width("Game Over")
    @@score_is = @@font_nomal.get_width("score : ")
    @@tb = TextBox.new(Window.width * 0.3, Window.height * 0.7, Window.width * 0.4, 100,
      font_name: "Poco", font_size: 90, font_oy: - 16, cursor_scale: 0.9)
    @@alerts = []
    @@alerts_stay_cnt = []
    @@alerts_alpha = []
  end

  class << self
    def update
      @@tb.update
      if Input.key_push?(K_RETURN)
        # 名前の長さは8文字以下
        # user name の末尾のスペースを消す
        # 2つ以上の並んだスペースを1つのスペースに変換
        if /^\s+/ =~ @@tb.string || @@tb.string.length == 0
          _call_alert("PLZ ENTER YOUR NAME!")
          @@tb.string = ""
        elsif @@tb.string.length > 8
          _call_alert("PLZ ENTER A NAME NO MORE THAN 8 CHAR!")
        else
          SceneManager.next(:ranking, @@tb.string, $score)
        end
      end
    end

    def draw
      Window.draw_font((Window.width - @@title_width) / 2, (Window.height - @@font_big.size) * 0.3, "Game Over", @@font_big)
      score_width = @@score_is + @@font_nomal.get_width("0") * "#{$score}".length
      Window.draw_font((Window.width - score_width) / 2, (Window.height - @@font_nomal.size) * 0.4, ["score : ", $score].join, @@font_nomal)
      @@tb.draw

      # draw alerts
      i = 1
      @@alerts.reverse_each do |a|
        Window.draw_alpha(0, (@@alerts.length - i) * a.height, a, @@alerts_alpha[-i])
        if @@alerts_stay_cnt[-i] > 0
          @@alerts_stay_cnt[-i] -= 1
        else
          @@alerts_alpha[-i] -= 4
        end
        if @@alerts_alpha[-i] <= 80
          @@alerts.delete_at(-i)
          @@alerts_alpha.delete_at(-i)
          @@alerts_stay_cnt.delete_at(-i)
        end
        i += 1
      end
    end

    private
    def _call_alert(str)
      str = str.to_s
      @@alerts << Image.new(@@font_mini.get_width(str) + 20, @@font_mini.size)
                    .draw_font(10, 0, str, @@font_mini, [230, 230, 230])
      @@alerts_stay_cnt << 160 # tick
      @@alerts_alpha << 255
    end
  end
end
