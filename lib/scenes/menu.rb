class Menu < Scene
  def initialize
    @@cover = Sprite.new(0, 0, Image.new(Window.width, Window.height, C_BLACK))
    @@cover.alpha = 100
    @@font_big = Font.new(160, "Poco")
    @@font = Font.new(80, "Poco")
    @@font_jp = Font.new(40, "美咲ゴシック")
    @@cursor = 0
    @@win_w = Window.width
    @@button_on_x, @@button_off_x = @@win_w * 0.6, @@win_w * 0.7
    @@button_y = 270
    @@button_on  = Sprite.new(@@button_on_x,  @@button_y, Image.new(@@font.get_width("ON"),  @@font.size))
    @@button_off = Sprite.new(@@button_off_x, @@button_y, Image.new(@@font.get_width("OFF"), @@font.size))
  end

  class << self
    def update
      Input.mouse_enable = true
      SceneManager.next(:play, is_init: false) if Input.key_release?(K_TAB)
      $p_set.auto_attack = true if @@button_on.on_mouse? && Input.mouse_push?(0)
      $p_set.auto_attack = false if @@button_off.on_mouse? && Input.mouse_push?(0)
    end

    def draw
      Play.draw
      @@cover.draw
      x = (@@win_w - @@font_big.get_width("MENU")) / 2
      Window.draw_font(x, 0, "MENU", @@font_big)
      Window.draw_font((@@win_w - @@font_jp.get_width("設定")) / 2, 220, "設定", @@font_jp)
      Window.draw_font(@@win_w * 0.2, @@button_y, "AUTO_ATTACK", @@font)
      Window.draw_font(@@button_on_x,  @@button_y, "ON", @@font, color: $p_set.auto_attack ? C_WHITE : [100, 255, 255, 255])
      Window.draw_font(@@button_off_x, @@button_y, "OFF", @@font, color: !$p_set.auto_attack ? C_WHITE : [100, 255, 255, 255])
      Window.draw_font((@@win_w - @@font_jp.get_width("操作方法")) / 2, 480, "操作方法", @@font_jp)
      w1 = @@win_w * 0.2
      w2 = @@win_w * 0.5
      ex = [220, 255, 255, 255]
      Window.draw_font(w1, 560, "移動", @@font_jp, color: ex)
      Window.draw_font(w2, 560, "マウスの位置", @@font_jp, color: ex)
      Window.draw_font(w1, 620, "攻撃", @@font_jp, color: ex)
      Window.draw_font(w2, 620, "クリック or スペースキー", @@font_jp, color: ex)
      Window.draw_font(w1, 680, "スペルの変更", @@font_jp, color: ex)   
      Window.draw_font(w2, 680, "Z, X or マウスホイール", @@font_jp, color: ex)
    end
  end
end
