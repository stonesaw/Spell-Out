# Scene - Titlee
# draw the scene & jump any scene

class Title < Scene
  def initialize
    Debugger.color = C_RED
    @@font_title = Font.new(300, "Poco")
    @@font = Font.new(160, "Poco")
    play   = @@font.get_width("PLAY")
    credit = @@font.get_width("CREDIT")
    exit_  = @@font.get_width("EXIT")
    @@section_play   = Sprite.new(900, 550, Image.new(play+10,   90, C_CYAN))
    @@section_credit = Sprite.new(850, 650, Image.new(credit+10, 90, C_CYAN))
    @@section_exit   = Sprite.new(800, 750, Image.new(exit_+10,  90, C_CYAN))
    @@cursor = -99
  end

  class << self
    def update
      @@cursor += 1 if Input.key_push?(K_DOWN)
      @@cursor -= 1 if Input.key_push?(K_UP)
      @@cursor = [[0, @@cursor].max, 2].min if @@cursor != -99
      @@cursor = -99 if @@section_play.on_mouse? || @@section_credit.on_mouse? || @@section_exit.on_mouse?

      if Input.mouse_down?(0) || Input.key_down?(K_RETURN)
        SceneManager.next(:play, loading: true) if @@section_play.on_mouse? || @@cursor == 0
        SceneManager.next(:play, loading: true) if @@section_credit.on_mouse? || @@cursor == 1
        exit if @@section_exit.on_mouse? || @@cursor == 2
      end
    end

    def draw
      Window.draw_font(30, -100, "Spell", @@font_title)
      Window.draw_font(30, 100, "Out", @@font_title)

      # @@section_play.draw
      # @@section_credit.draw
      # @@section_exit.draw

      # play
      if @@section_play.on_mouse? || @@cursor == 0
        Window.draw_font(@@section_play.x + 10, @@section_play.y - 60, "PLAY", @@font)
        Window.draw_line(@@section_play.x,               @@section_play.y + @@section_play.image.height,
          @@section_play.x + @@section_play.image.width, @@section_play.y + @@section_play.image.height, C_WHITE
        )
      else
        Window.draw_font(@@section_play.x + 10, @@section_play.y - 60, "PLAY", @@font, color: [200, 200, 200])
      end

      # credit
      if @@section_credit.on_mouse? || @@cursor == 1
        Window.draw_font(@@section_credit.x + 10, @@section_credit.y - 60, "CREDIT", @@font)
        Window.draw_line(@@section_credit.x,               @@section_credit.y + @@section_credit.image.height,
          @@section_credit.x + @@section_credit.image.width, @@section_credit.y + @@section_credit.image.height, C_WHITE
        )
      else
        Window.draw_font(@@section_credit.x + 10, @@section_credit.y - 60, "CREDIT", @@font, color: [200, 200, 200])
      end

      # exit
      if @@section_exit.on_mouse? || @@cursor == 2
        Window.draw_font(@@section_exit.x + 10, @@section_exit.y - 60, "EXIT", @@font)
        Window.draw_line(@@section_exit.x,               @@section_exit.y + @@section_exit.image.height,
          @@section_exit.x + @@section_exit.image.width, @@section_exit.y + @@section_exit.image.height, C_WHITE
        )
      else
        Window.draw_font(@@section_exit.x + 10, @@section_exit.y - 60, "EXIT", @@font, color: [200, 200, 200])
      end
      
      # Debugger.add_block do
      #   Window.draw_line(1200, 400, 1060, 900, C_WHITE)
      # end
    end
  end
end
