# Scene - Play

class Play < Scene
  def initialize
    Debugger.color = [240, 240, 240]
    Window.bgcolor = [26, 26, 26]
    @@font = Font.new(80, "Poco")
    @@font_mini = Font.new(50, "Poco")
    @@spell_icon = Sprite.new(1000, 600, Image.new(64, 64, C_WHITE))
    images = Image.load_tiles("#{$PATH}/assets/image/wizard.png", 6, 4)
    @@player_images = []
    load_setting = [4, 3, 0, 1, 2, 7, 6, 5]
    8.times do |i|
      s = load_setting[i] * 3
      @@player_images[i] = [images[s], images[s + 1], images[s + 2]] 
    end
    @@e_list = EnemiesDataList.new
    @@heart_icon = Image.load("#{$PATH}/assets/image/icon_Heart.png")
    # @@bg = Sprite.new(0, 0, Image.load("#{$PATH}/assets/image/field_bg.png"))
  end

  class << self
    def start
      @@player = Player.new(:fire, (Window.width - @@player_images[0][0].width) * 0.5, Window.height * 0.7, @@player_images)
      Bullet.reset
      Enemies.reset
      @@tick = 0
      @@boss_spawn_ticks = 180
      @@is_boss = false
      $score = 0
      BGM.set_s_time
      BGM.public[:chill][0].set_volume(250)
      @@enemy_count = 0
      @@slime_count = 0
      @@slime = @@e_list.slime
    end

    def update
      # test
      SceneManager.next(:title) if Input.key_push?(K_BACK)
      Input.mouse_enable = true

      if @@tick % 200 == 0 && !@is_boss
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

      @@player.update(@@tick)
      SceneManager.next(:game_over) if @@player.life <= 0
      Bullet.update
      Enemies.update(:any, @@tick, @@player)
      @@tick += 1
    end

    def draw
      Debugger.puts ["fps : ", Window.real_fps].join
      Debugger.puts ["score : ", $score].join
      Debugger.puts ["my life : ", @@player.life].join
      Debugger.puts ["angle : ", @@player._angle.to_i].join
      Debugger.puts ["bullet len : ", Bullet.all.length].join
      # Debugger.puts ["enemy  len : ", Enemies.list.length].join
      
      # @@bg.draw
      @@player.draw
      Bullet.draw
      Enemies.draw
      UI.draw

      @@player.life.times do |i|
        Window.draw(14 + i * (@@heart_icon.width + 4), 14, @@heart_icon)
      end
      w = @@font.get_width(["SCORE : ", $score].join)
      Window.draw_font(Window.width - w - 40, -10, ["SCORE : ", $score].join, @@font)
      Window.draw_font(Window.width - 200, Window.height - 60, ["<FPS : ", Window.real_fps, ">"].join, @@font_mini, color: [230, 230, 230])
    end
  end
end
