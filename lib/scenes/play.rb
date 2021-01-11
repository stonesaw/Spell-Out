# Scene - Play

class Play < Scene
  def initialize
    Debugger.color = [240, 240, 240]
    Window.bgcolor = [142, 199, 95]
    @@font      = Font.new(80, 'Poco')
    @@font_mini = Font.new(50, 'Poco')
    @@spell_icon = Sprite.new(1000, 600, Image.new(64, 64, C_WHITE))
    # @@heart_icon = Image.load("#{$PATH}/assets/image/icon_Heart.png")
    
    @@player = Player.new(:fire, (Window.width - $player_images[0][0].width) * 0.5, Window.height * 0.7, $player_images)
    r = $player_images[0][0].width / 2
    Input.set_mouse_pos(@@player.x * Window.scale + r, @@player.y * Window.scale + r)
    Bullet.reset
    Enemies.reset
    EnemiesData.new
    BulletData.new
    EnemySpawnSystem.new

    @@tick = 0
    $score = 0
    # Map._load
  end

  class << self
    def set_music
      BGM.set_s_time
      BGM.public[:chill][0].set_volume(255)
    end

    def update
      # test
      # SceneManager.next(:title) if Input.key_push?(K_BACK)
      Input.mouse_enable = true
      $debug_mode = !$debug_mode if Input.key_release?(K_F5)

      SceneManager.next(:menu) if Input.key_release?(K_TAB)

      # spown enemy
      EnemySpawnSystem.update(@@tick)
      

      # if @@tick > @@boss_spawn_ticks && Enemies.list.length == 0
      #   x = (Window.width - EnemiesData.slime.image.width) / 2
      #   Enemy.new(EnemiesData.big_slime, @@tick, x, 0).add_boss_bar
      # end

      # update
      @@player.update(@@tick)
      if @@player.life <= 0
        _to_scene_game_over()
      end
      Bullet.update(@@tick, @@player)
      Enemies.update(:any, @@tick, @@player)
      @@tick += 1
    end

    def draw
      Debugger.puts ['fps : ', Window.real_fps].join
      Debugger.puts ['score : ', $score].join
      Debugger.puts ['my life : ', @@player.life].join
      Debugger.puts ['player direction : ', @@player.direction.to_i].join
      Debugger.puts ['bullet : ', Bullet.list.length].join
      Debugger.puts ['enemy : ', Enemies.list.length].join

      # @@bg.draw
      Bullet.draw
      Enemies.draw
      @@player.draw
      Bullet.draw_wrapper
      UI.draw

      # @@player.life.times do |i|
      #   Window.draw(14 + i * (@@heart_icon.width + 4), 14, @@heart_icon)
      # end
      w = @@font.get_width(['SCORE : ', $score].join)
      case(@@player.life)
      when 0 .. 100
        Window.draw_font(0,0,@@player.life.to_s, @@font, color: [255, 0, 0]) # red
      when 101 .. 150
        Window.draw_font(0,0,@@player.life.to_s, @@font, color: [255, 210, 0]) # orange
      else
        Window.draw_font(0,0,@@player.life.to_s, @@font, color: [70, 130, 180]) # blue
      end
      Window.draw_font(Window.width - w - 40, -10, ['SCORE : ', $score].join, @@font)
      Window.draw_font(Window.width - 200, Window.height - 60, ['<FPS : ', Window.real_fps, '>'].join, @@font_mini, color: [230, 230, 230])
      Window.draw_font(Window.width - w -40, 30, ['LEVEL: ', $level].join, @@font)
    end

    def last
      $debug_mode = false
    end

    def _to_scene_game_over
      cover = Sprite.new(0, 0, Image.new(Window.width, Window.height, C_BLACK))
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
  end
end
