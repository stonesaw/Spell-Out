class Menu < Scene
  def initialize
    super
    @@cover = Sprite.new(0, 0, Image.new(Window.width, Window.height, C_BLACK))
    @@cover.alpha = 100
    @@font_big = Font.new(160, 'Poco')
    @@font     = Font.new(80, 'Poco')
    @@font_jp  = Font.new(40, '美咲ゴシック')
    @@cursor = 0
    @@win_w = Window.width
    @@button_on_x = @@win_w * 0.6
    @@button_off_x = @@win_w * 0.7
    @@button_y = 270
    @@button_on  = Sprite.new(@@button_on_x,  @@button_y, Image.new(@@font.get_width('ON'),  @@font.size))
    @@button_off = Sprite.new(@@button_off_x, @@button_y, Image.new(@@font.get_width('OFF'), @@font.size))
    @@button_plus = Sprite.new(@@win_w * 0.3, 400, Image.new(@@font.get_width('+10'), @@font.size))
    @@button_minus = Sprite.new(@@win_w * 0.6, 400, Image.new(@@font.get_width('-10'), @@font.size))
  end

  class << self
    def update
      Input.mouse_enable = true
      SceneManager.next(:play, is_init: false) if Input.key_release?(K_TAB)
      PlayerSetting.auto_attack = true if @@button_on.on_mouse? && Input.mouse_push?(0)
      PlayerSetting.auto_attack = false if @@button_off.on_mouse? && Input.mouse_push?(0)
      @@volume = $volume * 255
      @@volume = @@volume.round(2)
      if @@button_plus.on_mouse? && Input.mouse_push?(0)
        if $volume < 1
          $volume = $volume + 0.1
        end
      end

      if @@button_minus.on_mouse? && Input.mouse_push?(0)
        if $volume > 0.2
          $volume = $volume - 0.1
        end
      end
    end

    def draw
      Play.draw # プレイ画面の表示
      @@cover.draw

      menu_x = (@@win_w - @@font_big.get_width('MENU')) / 2
      setting_x = (@@win_w - @@font_jp.get_width('設定')) / 2
      how_to_x = (@@win_w - @@font_jp.get_width('操作方法')) / 2
      w1 = @@win_w * 0.2
      w2 = @@win_w * 0.5
      ex = [220, 255, 255, 255]

      Window.draw_font(menu_x, 0, 'MENU', @@font_big)
        .draw_font(setting_x,      220,        '設定', @@font_jp)
        .draw_font(@@win_w * 0.2,  @@button_y, 'AUTO_ATTACK', @@font)
        .draw_font(w1,             400,        '音量', @@font_jp)
        .draw_font(@@win_w * 0.8,  400,        @@volume.to_s, @@font)
        .draw_font(@@win_w * 0.3,             400,         '+10',@@font)
        .draw_font(@@win_w * 0.6,             400,         '-10', @@font)
        .draw_font(@@button_on_x,  @@button_y, 'ON', @@font, color: PlayerSetting.auto_attack ? C_WHITE : [100, 255, 255, 255])
        .draw_font(@@button_off_x, @@button_y, 'OFF', @@font, color: !PlayerSetting.auto_attack ? C_WHITE : [100, 255, 255, 255])
        .draw_font(how_to_x,       480,        '操作方法', @@font_jp)
        .draw_font(w1,             560,        '移動', @@font_jp, color: ex)
        .draw_font(w2,             560,        'マウスの位置', @@font_jp, color: ex)
        .draw_font(w1,             620,        '攻撃', @@font_jp, color: ex)
        .draw_font(w2,             620,        'クリック or スペースキー', @@font_jp, color: ex)
        .draw_font(w1,             680,        'スペルの変更', @@font_jp, color: ex)
        .draw_font(w2,             680,        'Z, X or マウスホイール', @@font_jp, color: ex)
    end
  end
end
