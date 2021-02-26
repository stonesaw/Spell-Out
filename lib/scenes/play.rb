# Scene - Play

class Play < Scene
  class << self
    attr_reader :tick
    attr_accessor :player, :stage
  end

  def self.new(stage_name)
    Debugger.color = [240, 240, 240]
    @tick = 0
    @font = Font.new(80, 'Poco')
    @font_mini = Font.new(50, 'Poco')

    _img = Image.load_tiles("#{$PATH}/assets/image/wizard.png", 6, 4)
    load_setting = [4, 3, 0, 1, 2, 7, 6, 5]
    player_images = load_setting.map do |i|
      s = i * 3
      [_img[s], _img[s + 1], _img[s + 2]]
    end
    @player = Player.new(
      :fire,
      (Window.width - player_images[0][0].width) * 0.5, Window.height * 0.7,
      player_images
    )
    r = @player.image.width / 2
    Input.set_mouse_pos(@player.x * Window.scale + r, @player.y * Window.scale + r)
    BulletData.load
    @stage = Stage.new(stage_name, StageData.load(stage_name))
    $score = 0

    @book_anime = Image.load_tiles("#{$PATH}/assets/image/book_anime.png", 16, 1)
    @book = Sprite.new(10, 800, @book_anime[0])
    @book_anime_count = 0
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

    @stage.update
    if @stage.is_clear
      _to_scene_game_clear
      # SceneManager.next(:title)
    end

    # update
    @player.update

    _to_scene_game_over if @player.life <= 0

    Bullet.update
    # Enemies.update(:any, @tick, @player)
    i = -1
    Enemy.list.length.times do
      Enemy.list[i].update
      i -= 1
    end
    Sprite.clean(Enemy.list)

    # 仮
    if @book_anime_count != 0
      @book_anime_count += 1
      @book_anime_count = @book_anime_count % (@book_anime.length * 3)
    end
    if Input.key_push?(K_Z)
      @book_anime_count += 1
    end
    @book.image = @book_anime[@book_anime_count / 3]

    @tick += 1
  end

  def self.draw
    Debugger.puts("fps : #{Window.real_fps}")
    Debugger.puts("tick : #{@tick}")
    Debugger.puts("score : #{$score}")
    Debugger.puts("my life : #{@player.life}")
    Debugger.puts("player direction : #{@player.direction.to_i}°")
    Debugger.puts("bullet length : #{Bullet.list.length}")
    Debugger.puts("enemy length: #{Enemy.list.length}")

    @stage.draw
    Bullet.draw
    Sprite.draw(Enemy.list)
    # Enemies.draw
    @player.draw
    Bullet.draw_after
    HPBar.draw

    # 仮
    @book.draw

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
    Window.draw_font(Window.width - w - 40, -10, "SCORE : #{$score}", @font)
    Window.draw_font(
      Window.width - 200, Window.height - 60,
      "<FPS : #{Window.real_fps}>", @font_mini,
      color: [230, 230, 230]
    )
    Window.draw_font(Window.width - w - 40, 30, "LEVEL: #{@player.level}", @font)

    if $debug_mode
      Debugger.draw_collision(
        Enemy.list + [@player] + Bullet.list + @stage.objects
      )
    end
  end

  def self.last
    Bullet.reset
    Enemy.reset
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
    SceneManager.next(:game_over, :game_clear, loading: true)
  end
end
