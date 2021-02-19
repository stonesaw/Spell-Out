class Menu < Scene
  def self.new
    super
    @cover = Sprite.new(0, 0, Image.new(Window.width, Window.height, C_BLACK))
    @cover.alpha = 100
    w = 400
    h = 10
    _bar = Image.new(w, h).
      box_fill(h / 2, 0, w - h / 2, h, [180, 255, 255, 255]).
      circle_fill(h / 2, h / 2, h / 2, [180, 255, 255, 255]).
      circle_fill(w - h / 2, h / 2, h / 2, [180, 255, 255, 255])
    _toggle = Image.new(30, 30).circle_fill(15, 15, 15, C_WHITE)
    @bgm_seek_bar = SeekBar.new((Window.width - _bar.width) * 0.5, 400, _bar, _toggle, percent: BGM.volume)
    @se_seek_bar = SeekBar.new((Window.width - _bar.width) * 0.5, 460, _bar, _toggle, percent: SE.volume)

    @tab_list = ['option', 'sounds', 'control']
    @now_tab = @tab_list[0]
    @tab_heads = []
    font = Font.new(42)
    @tab_list.each_with_index do |str, i|
      img = Image.new(200, 50).draw_font(0, 0, str, font)
      @tab_heads << Sprite.new(50 + i * 200, 50, img)
    end
  end

  def self.update
    Input.mouse_enable = true
    SceneManager.next(:play, is_init: false) if Input.key_release?(K_TAB)
    # PlayerSetting.auto_attack = true if @button_on.on_mouse? && Input.mouse_push?(0)
    # PlayerSetting.auto_attack = false if @button_off.on_mouse? && Input.mouse_push?(0)
    @bgm_seek_bar.update
    @se_seek_bar.update
    BGM.volume = @bgm_seek_bar.percent
    SE.volume = @se_seek_bar.percent
  end

  def self.draw
    Play.draw # プレイ画面の表示
    @cover.draw
    # @bgm_seek_bar.draw
    # @se_seek_bar.draw

    Sprite.draw(@tab_heads)
  end
end
