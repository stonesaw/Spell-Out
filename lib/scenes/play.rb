# Scene - Play

class Play < Scene
  def self.new
    Debugger.color = [240, 240, 240]
    Window.bgcolor = [142, 199, 95]
    @font      = Font.new(80, 'Poco')
    @font_mini = Font.new(50, 'Poco')
    @spell_icon = Sprite.new(1000, 600, Image.new(64, 64, C_WHITE))
    # @heart_icon = Image.load("#{$PATH}/assets/image/icon_Heart.png")

    @player = Player.new(:fire, (Window.width - $player_images[0][0].width) * 0.5, Window.height * 0.7, $player_images)
    r = $player_images[0][0].width / 2
    Input.set_mouse_pos(@player.x * Window.scale + r, @player.y * Window.scale + r)
    Bullet.reset
    Enemy.reset
    EnemiesData.new
    BulletData.new
    EnemySpawnSystem.new

    @tick = 0
    $score = 0
    # Map._load
  end

  def self.set_music
    BGM.init
    SE.init
  end

  def self.update
    # test
    # SceneManager.next(:title) if Input.key_push?(K_BACK)
    Input.mouse_enable = true
    $debug_mode = !$debug_mode if Input.key_release?(K_F5)

    SceneManager.next(:menu) if Input.key_release?(K_TAB)

    # spown enemy
    EnemySpawnSystem.update(@tick, @player)

    # update
    @player.update(@tick)

    _to_scene_game_over if @player.life <= 0
    if EnemySpawnSystem.is_boss && Enemy.list.empty?
      _to_scene_game_clear
    end

    Bullet.update(@tick, @player)
    # Enemies.update(:any, @tick, @player)
    i = -1
    Enemy.list.length.times do
      enemy = Enemy.list[i]
      enemy.update(enemy, @tick, @player)
      i -= 1
    end
    Sprite.clean(Enemy.list)

    @tick += 1
  end

  def self.draw
    Debugger.puts("fps : #{Window.real_fps}")
    Debugger.puts("tick : #{@tick}")
    Debugger.puts("score : #{$score}")
    Debugger.puts("my life : #{@player.life}")
    Debugger.puts("player direction : #{@player.direction.to_i}")
    Debugger.puts("bullet : #{Bullet.list.length}")
    Debugger.puts("enemy : #{Enemy.list.length}")

    # @bg.draw
    Bullet.draw
    Sprite.draw(Enemy.list)
    # Enemies.draw
    @player.draw
    Bullet.draw_after
    HPBar.draw

    # @player.life.times do |i|
    #   Window.draw(14 + i * (@heart_icon.width + 4), 14, @heart_icon)
    # end
    w = @font.get_width(['SCORE : ', $score].join)
    case @player.life
    when 0..100
      Window.draw_font(0, 0, @player.life.to_s, @font, color: [255, 0, 0]) # red
    when 101..150
      Window.draw_font(0, 0, @player.life.to_s, @font, color: [255, 210, 0]) # orange
    else
      Window.draw_font(0, 0, @player.life.to_s, @font, color: [70, 130, 180]) # blue
    end
    Window.draw_font(Window.width - w - 40, -10, ['SCORE : ', $score].join, @font)
    Window.draw_font(Window.width - 200, Window.height - 60, ['<FPS : ', Window.real_fps, '>'].join, @font_mini, color: [230, 230, 230])
    Window.draw_font(Window.width - w - 40, 30, ['LEVEL: ', @player.level].join, @font)
  end

  def self.last
    $debug_mode = false
  end

  def self._to_scene_game_over
    cover = Sprite.new(0, 0, Image.new(Window.width, Window.height, C_BLACK))
    cover.alpha = 0
    @player.alpha = 255
    i = 0
    loop do
      Window.update
      cover.alpha += 15 if i % 60 == 0
      break if cover.alpha > 255

      Play.draw
      cover.draw
      i += 1
    end
    SceneManager.next(:game_over, nil)
  end

  def self._to_scene_game_clear
    cover = Sprite.new(0, 0, Image.new(Window.width, Window.height, C_BLACK))
    cover.alpha = 0
    @player.alpha = 255
    i = 0
    loop do
      Window.update
      cover.alpha += 15 if i % 60 == 0
      break if cover.alpha > 255

      Play.draw
      cover.draw
      i += 1
    end
    SceneManager.next(:game_over, :game_clear)
  end
end
