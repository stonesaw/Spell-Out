# Scene - Play

class Play < Scene
  class << self
    attr_reader :tick
    attr_accessor :player, :stage
  end

  def self.new(stage_name)
    Debugger.color = [240, 240, 240]
    @tick = 0
    @font_big = Font.new(100, 'Poco')
    @font = Font.new(80, 'Poco')
    @font_mid = Font.new(70, 'Poco')
    @font_mini = Font.new(50, 'Poco')
    @font_spell = Font.new(90, 'Poco')
    @font_clear = Font.new(200, 'Poco')

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
    _x = @player.x + @player.image.width / 2
    _y = @player.y + @player.image.height / 2
    Input.set_mouse_pos(_x * Window.scale, _y * Window.scale)
    Bullet.reset
    Enemy.reset
    BulletData.load
    @stage_name = stage_name.to_s
    @stage = Stage.new(stage_name, StageData.load(@stage_name))

    @book_anime = Image.load_tiles("#{$PATH}/assets/image/book_anime.png", 16, 1)
    @book = Sprite.new(10, 800, @book_anime[0])
    @book_anime_count = 0

    # sleep 1
    SceneManager.next(:play_cut_in)
  end

  def self.update
    Input.mouse_enable = true
    $debug_mode = !$debug_mode if Input.key_release?(K_F5)
    if @tick == 0
      BGM.init
      SE.init
    end

    SceneManager.next(:menu) if Input.key_release?(K_TAB)

    @stage.update
    if @stage.is_clear || Input.key_down?(K_F12)
      _stage_clear
      if @stage_name == '1-6'
        SceneManager.next(:game_over, :game_clear, loading: true)
      else
        SceneManager.next(:stage_select, @stage_name, loading: true)
      end
    end

    # update
    @player.update

    if @player.life <= 0
      _game_over
      SceneManager.next(:game_over, nil, skip_draw: false)
    end

    Bullet.update
    i = -1
    Enemy.list.length.times do
      Enemy.list[i].update
      i -= 1
    end
    Sprite.clean(Enemy.list)

    if @book_anime_count != 0
      @book_anime_count += 1
      @book_anime_count = @book_anime_count % (@book_anime.length * 3)
    end
    @book_anime_count = 1 if @player.is_changed_spell

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
    Sprite.draw(Enemy.list)
    Bullet.draw
    @player.draw
    Bullet.draw_after
    HPBar.draw

    _draw_book
    _draw_ui

    if $debug_mode
      Debugger.draw_collision(
        Enemy.list + [@player] + Bullet.list + @stage.objects
      )
    end
  end

  def self._draw_book
    @book.draw
    case @player.spell
    when :wind
      color = [20, 217, 105]
    when :holy
      color = C_BLACK
    else
      color = BulletData.spell_and_color[@player.spell]
    end
    str = "#{@player.spell}".upcase
    Window.draw_font(115 - @font.get_width(str) / 2, 820, str, @font, color: color)
  end
  private_class_method :_draw_book

  def self._draw_ui
    case @player.life
    when 0..100
      color = [255, 0, 0]
    when 101..150
      color = [255, 210, 0]
    else
      color = [70, 130, 180]
    end
    Window.draw_font(10, -20, "LIFE : #{@player.life}", @font, color: color)
    if @stage.now == @stage.waves.length
      wave = 'CLEAR'
    else
      wave = "#{@stage.now + 1} / #{@stage.waves.length}"
    end
    x = (Window.width - @font_mid.get_width("STAGE : #{@stage_name}")) * 0.5
    Window.draw_font(x, -15, "STAGE : #{@stage_name}", @font_mid)
    x = (Window.width - @font_big.get_width("WAVE : #{wave}")) * 0.5
    Window.draw_font(x, 10, "WAVE : #{wave}", @font_big)
    w = @font.get_width(['SCORE : ', $score].join)
    Window.draw_font(Window.width - w - 40, -20, "SCORE : #{$score}", @font)
    Window.draw_font(230, Window.height - 60, "[TAB] MENU", @font_mini, color: [230, 230, 230])
    Window.draw_font(Window.width - 200, Window.height - 60,
                     "<FPS : #{Window.real_fps}>", @font_mini, color: [230, 230, 230])
    # Window.draw_font(Window.width - w - 40, 20, "LEVEL : #{@player.level}", @font)
  end
  private_class_method :_draw_ui

  def self._stage_clear
    cover = Sprite.new(0, 0, Image.new(Window.width, Window.height, C_BLACK))
    cover.alpha = 0
    @player.alpha = 255
    i = 0
    loop do
      Play.draw

      str = "STAGE CLEAR!"
      x = (Window.width - @font_clear.get_width(str)) / 2
      y = (Window.height - @font_clear.size) / 2
      Window.draw_font(x, y, str, @font_clear)
      if i > 400
        cover.alpha += 15 if i % 30 == 0
        break if cover.alpha > 255
      end

      cover.draw
      i += 1
      Window.update
    end
  end
  private_class_method :_stage_clear

  def self._game_over
    cover = Sprite.new(0, 0, Image.new(Window.width, Window.height, C_BLACK))
    cover.alpha = 0
    @player.alpha = 255
    i = 0
    loop do
      Window.update
      Play.draw

      cover.alpha += 15 if i % 30 == 0
      break if cover.alpha > 255

      cover.draw
      i += 1
    end

    Play.draw
  end
  private_class_method :_game_over
end
