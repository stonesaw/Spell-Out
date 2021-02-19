class Player < Sprite
  attr_accessor :spell, :max_life, :life, :images, :direction, :level, :exp

  def initialize(spell, x, y, images)
    super
    self.x = x
    self.y = y
    @images = images
    self.image = @images[0][0]
    self.collision = [8, 36, 70, 112]

    @spell = spell.to_sym
    @spell_list = [:fire, :water, :wind, :holy, :dark]
    @spell_num = @spell_list.index(@spell)
    @max_life = 250
    @life = 250
    @level = 1
    @exp = 0
    @speed = 4
    @direction = 0 # キャラクターの向いている方向 (画像の角度ではない)
    @cool_time = 0

    @bullet_count = 0
    @anime_count = 0
    @_mouse_down_count = 0
    @_old_spell_num = nil
    @hit_tick = 0
    @is_hit = false
    @charge_percent = 0.0
    @charge_circle_img = []
    9.times do |i|
      @charge_circle_img << Image.load("#{$PATH}/assets/image/circle#{i}.png").
        set_color_key(C_BLACK).
        flush([200, 255, 255, 255]) # 色を変更
    end
  end

  def update(tick)
    # player controll
    mx = Mouse.x
    my = Mouse.y
    ox = x + (image.width / 2)
    oy = y + (image.height / 2)

    anime_stop = false
    if (0..10).include?((ox - mx).abs) && (0..10).include?((oy - my).abs)
      anime_stop = true
    else
      angle = Math.atan2(my - oy, mx - ox) * 180.0 / Math::PI
      angle = 360 + angle if angle < 0
      @direction = angle
      # obj = Bullet.list + Enemy.list
      # obj.each do |o|
      #   o.x -= @speed * Math.cos(@direction * Math::PI / 180.0)
      #   o.y -= @speed * Math.sin(@direction * Math::PI / 180.0)
      # end
      self.x += @speed * Math.cos(@direction * Math::PI / 180.0)
      self.y += @speed * Math.sin(@direction * Math::PI / 180.0)
    end

    self.x = [[0, self.x].max, Window.width - image.width].min
    self.y = [[0, self.y].max, Window.height - image.height].min
    # self.x = (Window.width - self.image.width) / 2
    # self.y = (Window.height - self.image.height) / 2

    # [右 → から時計回り][アニメーション]
    @anime_count += 1 if tick % 10 == 0
    frame = if anime_stop
              1
            else
              @anime_count % 3
            end
    self.image = @images[((@direction + 23) % 360) / 45][frame]

    # hit enemy
    enemies = check(Enemy.list) # unless Enemy.list.empty?
    unless enemies.empty? || @is_hit
      @life -= 50
      @hit_tick = tick
      @is_hit = true
      Enemy.list.delete(enemies[0])
    end

    if @hit_tick != 0 && tick - @hit_tick < 180
      self.alpha += 30
    else
      self.alpha = 255
      @is_hit = false
    end

    # Input
    # spell change
    @_old_spell_num = @spell_num
    @spell_num -= Input.mouse_wheel_pos / 120
    Input.mouse_wheel_pos = 0
    @spell_num -= 1 if Input.key_push?(K_Z)
    @spell_num += 1 if Input.key_push?(K_X)
    @spell = @spell_list[@spell_num % @spell_list.length]

    @charge_percent = 0.0 if @_old_spell_num != @spell_num
    @cool_time -= 1

    if @cool_time <= 0
      if !Input.mouse_down?(1) && (Input.key_push?(K_SPACE) || Input.mouse_push?(0))
        @bullet_count = 0
        _fire_bullet(tick)
      end
      if !Input.mouse_down?(1) && (PlayerSetting.auto_attack || Input.key_down?(K_SPACE) || Input.mouse_down?(0))
        @bullet_count += 1
        _fire_bullet(tick) if @bullet_count % 14 == 0
      end

      if @charge_percent >= 1.0 && Input.mouse_release?(1)
        _fire_bullet(tick, 2)
        @_mouse_down_count = 0
      end

      if Input.mouse_down?(1)
        @_mouse_down_count += 1
        @_mouse_down_count = [@_mouse_down_count, BulletData.charge_tick[@spell]].min
      else
        @_mouse_down_count = 0
      end

      @charge_percent = @_mouse_down_count.to_f / BulletData.charge_tick[@spell]
    end
  end

  private

  def _fire_bullet(tick, level = 1)
    if level == 1
      _x = self.x + (image.width * 0.5)  + image.width  * 0.4 * Math.cos(@direction * Math::PI / 180.0)
      _y = self.y + (image.height * 0.6) + image.height * 0.4 * Math.sin(@direction * Math::PI / 180.0)
      Bullet.new(self, BulletData.list[:"level1_#{@spell}"], tick, _x, _y, @direction)
    elsif level == 2
      bullet_name = :"level2_#{@spell}"
      unless BulletData.list.keys.include?(bullet_name)
        raise NameError, "BulletData.list undefined :#{bullet_name}"
      end
      Bullet.new(self, BulletData.list[bullet_name], tick, nil, nil, @direction)
      @cool_time = 100
    end
  end

  public

  def draw
    if $debug_mode # キャラの当たり判定の範囲
      x1 = self.x + 8
      y1 = self.y + 36
      Window.draw_box(x1, y1, x1 + 62, y1 + 76, C_WHITE)
      # center_x = self.x - 30
      # center_y = self.y - 50
      # _x = center_x + self.image.width  * 0.4  * Math.cos(@direction * Math::PI / 180.0)
      # _y = center_y + self.image.height * 0.35 * Math.sin(@direction * Math::PI / 180.0)
      # Window.draw_rot(_x, _y, BulletData.list[:fire].image, @direction + 90, 64, 128)
    end

    # self.image
    super

    # ため攻撃のゲージ
    _x = self.x - 20
    _y = self.y + 10
    Window.draw(_x, _y, @charge_circle_img[(@charge_percent * 8).to_i])
  end
end
