class Menu < Scene
  def self.new
    @cover = Sprite.new(0, 0, Image.new(Window.width, Window.height, C_BLACK))
    @cover.alpha = 100
    @font_big = Font.new(160, 'Poco')
    @font     = Font.new(80, 'Poco')
    @font_jp  = Font.new(40, '美咲ゴシック')
    @cursor = 0
    @button_on_x = Window.width * 0.6
    @button_off_x = Window.width * 0.7
    @button_y = 270
    @button_on = Sprite.new(@button_on_x, @button_y, Image.new(@font.get_width('ON'), @font.size))
    @button_off = Sprite.new(@button_off_x, @button_y, Image.new(@font.get_width('OFF'), @font.size))
    w = 400
    h = 10
    _bar = Image.new(w, h).
      box_fill(h / 2, 0, w - h / 2, h, [180, 255, 255, 255]).
      circle_fill(h / 2, h / 2, h / 2, [180, 255, 255, 255]).
      circle_fill(w - h / 2, h / 2, h / 2, [180, 255, 255, 255])
    _toggle = Image.new(30, 30).circle_fill(15, 15, 15, C_WHITE)
    @bgm_seek_bar = SeekBar.new((Window.width - _bar.width) * 0.5, 300,
                                _bar, _toggle, percent: BGM.volume)
    @se_seek_bar = SeekBar.new((Window.width - _bar.width) * 0.5, 360,
                               _bar, _toggle, percent: SE.volume)
  end

  def self.update
    Input.mouse_enable = true
    SceneManager.next(:play, is_init: false) if Input.key_release?(K_TAB)
    @bgm_seek_bar.update
    @se_seek_bar.update
    BGM.volume = @bgm_seek_bar.percent
    SE.volume = @se_seek_bar.percent
  end

  def self.draw
    Play.draw # プレイ画面の表示
    @cover.draw
    @bgm_seek_bar.draw
    @se_seek_bar.draw

    menu_x = (Window.width - @font_big.get_width('MENU')) / 2
    setting_x = (Window.width - @font_jp.get_width('設定')) / 2
    how_to_x = (Window.width - @font_jp.get_width('操作方法')) / 2
    ex = [220, 255, 255, 255]

    Window.draw_font(menu_x,          0, 'MENU', @font_big).
      draw_font(setting_x,          220, '設定', @font_jp).
      # draw_font(Window.width * 0.2, 200, '音量', @font_jp).
      draw_font(Window.width * 0.2, 255, 'BGM', @font).
      draw_font(Window.width * 0.7, 255, "#{(BGM.volume * 100).floor}", @font).
      draw_font(Window.width * 0.2, 316, 'SE', @font).
      draw_font(Window.width * 0.7, 316, "#{(SE.volume * 100).floor}", @font).
      draw_font(how_to_x,           480, '操作方法', @font_jp).
      draw_font(Window.width * 0.2, 560, '移動', @font_jp, color: ex).
      draw_font(Window.width * 0.5, 560, 'マウスの位置', @font_jp, color: ex).
      draw_font(Window.width * 0.2, 620, 'チャージ攻撃', @font_jp, color: ex).
      draw_font(Window.width * 0.5, 620, '右クリック', @font_jp, color: ex).
      draw_font(Window.width * 0.2, 680, 'スペルの変更', @font_jp, color: ex).
      draw_font(Window.width * 0.5, 680, 'Z, X or マウスホイール', @font_jp, color: ex)
  end
end
