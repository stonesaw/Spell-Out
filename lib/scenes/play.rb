# Scene - Play

class Play < Scene
  def initialize
    Debugger.color = [240, 240, 240]
    Window.bgcolor = [142, 199, 95]
    @@font      = Font.new(80, "Poco")
    @@font_mini = Font.new(50, "Poco")
    @@spell_icon = Sprite.new(1000, 600, Image.new(64, 64, C_WHITE))
    @@e_list = EnemiesDataList.new
    @@heart_icon = Image.load("#{$PATH}/assets/image/icon_Heart.png")
    
    @@player = Player.new(:fire, (Window.width - $player_images[0][0].width) * 0.5, Window.height * 0.7, $player_images)
    r = $player_images[0][0].width / 2
    Input.set_mouse_pos(@@player.x * Window.scale + r, @@player.y * Window.scale + r)
    Bullet.reset
    Enemies.reset
    @@tick = 0
    p "call"
    @@boss_spawn_ticks = 180
    @@is_boss = false
    $score = 0
    @@enemy_count = 0
    @@slime_count = 0
    @@slime = @@e_list.slime
  end

  class << self
    def set_music
      BGM.set_s_time
      BGM.public[:chill][0].set_volume(250)  
    end

    def update
      # test
      # SceneManager.next(:title) if Input.key_push?(K_BACK)
      Input.mouse_enable = true
      $debug_mode = !$debug_mode if Input.key_release?(K_F5)

      SceneManager.next(:menu) if Input.key_release?(K_TAB)

      # spown enemy
      if @@tick % 200 == 0 && !@@is_boss
        if @@enemy_count <= 0
          @@enemy_count = rand(2..6)
          @@slime_count += 1
          if @@slime_count % 2 == 0
            @@slime = @@e_list.slime
          else
            @@slime = @@e_list.slime2
          end
        end
        x = 100 + rand(Window.width - @@e_list.slime.image.width - 200)
        Enemy.new(@@slime, @@tick, x, -@@e_list.slime.image.height).add_hp_bar(x: 0.7, y: 0.7)
        @@enemy_count -= 1
      end
      
      # if @@tick > @@boss_spawn_ticks && Enemies.list.length == 0
      #   x = (Window.width - @@e_list.slime.image.width) / 2
      #   Enemy.new(@@e_list.big_slime, @@tick, x, 0).add_boss_bar
      # end

      # update
      @@player.update(@@tick)
      if @@player.life <= 0
        cover= Sprite.new(0, 0, Image.new(Window.width, Window.height, C_BLACK))
        cover.alpha = 0
        @@player.alpha = 255
        i = 0
        loop do
          Window.update
          cover.alpha += 15 if i % 60 == 0
          break if cover.alpha > 255
          Play.draw
          cover.draw
          i += 1
        end
        SceneManager.next(:game_over)
      end
      Bullet.update
      Enemies.update(:any, @@tick, @@player)
      @@tick += 1
    end

    def draw
      Debugger.puts ["fps : ", Window.real_fps].join
      Debugger.puts ["score : ", $score].join
      Debugger.puts ["my life : ", @@player.life].join
      Debugger.puts ["angle : ", @@player._angle.to_i].join
      Debugger.puts ["bullet : ", Bullet.all.length].join
      Debugger.puts ["enemy : ", Enemies.list.length].join
      
      # @@bg.draw
      Bullet.draw
      Enemies.draw
      @@player.draw
      UI.draw

      @@player.life.times do |i|
        Window.draw(14 + i * (@@heart_icon.width + 4), 14, @@heart_icon)
      end
      w = @@font.get_width(["SCORE : ", $score].join)
      Window.draw_font(Window.width - w - 40, -10, ["SCORE : ", $score].join, @@font)
      Window.draw_font(Window.width - 200, Window.height - 60, ["<FPS : ", Window.real_fps, ">"].join, @@font_mini, color: [230, 230, 230])
    end

    def last
      $debug_mode = false
    end
  end
end
