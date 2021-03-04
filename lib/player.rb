class Player < Sprite
  attr_accessor :spell, :max_life, :life, :images, :direction, :level, :exp
  attr_reader :is_changed_spell, :speed

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
    @direction = -90 # キャラクターの向いている方向 (画像の角度ではない)
    @cool_time = 0
    @is_changed_spell = false

    @bullet_count = 0 # バレット 自動発射用のカウント変数
    @anime_count = 0
    @_mouse_down_count = 0
    @_old_spell_num = @spell_num
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

  def update
    # player controll
    mx = Mouse.x
    my = Mouse.y
    ox = x + (image.width / 2)
    oy = y + (image.height / 2)

    # [右 → から時計回り][アニメーション]
    @anime_count += 1 if Play.tick % 10 == 0
    if (0..10).include?((ox - mx).abs) && (0..10).include?((oy - my).abs)
      animation(1)
    else
      animation(@anime_count)
      angle = Math.atan2(my - oy, mx - ox) * 180.0 / Math::PI
      angle = 360 + angle if angle < 0
      @direction = angle

      obj = Play.stage.objects
      self.x += dx = @speed * Math.cos(@direction * Math::PI / 180.0)
      self.x -= dx unless check(obj).empty?

      self.y += dy = @speed * Math.sin(@direction * Math::PI / 180.0)
      self.y -= dy unless check(obj).empty?
    end

    self.x = [[0, self.x].max, Window.width - image.width].min
    self.y = [[0, self.y].max, Window.height - image.height].min
    # self.x = (Window.width - self.image.width) / 2
    # self.y = (Window.height - self.image.height) / 2


    # hit enemy
    enemies = check(Enemy.list) # unless Enemy.list.empty?
    if !enemies.empty? && !@is_hit
      @life -= 50
      @hit_tick = Play.tick
      @is_hit = true
      Enemy.list.delete(enemies[0]) if enemies[0].data.name != 'ゴーレム'
    end

    if @hit_tick != 0 && Play.tick - @hit_tick < 180
      self.alpha += 30
    else
      self.alpha = 255
      @is_hit = false
    end

    # Input
    # spell change
    @is_changed_spell = !(@_old_spell_num == @spell_num)
    @_old_spell_num = @spell_num
    @spell_num -= Input.mouse_wheel_pos / 120
    Input.mouse_wheel_pos = 0
    @spell_num -= 1 if Input.key_push?(K_Z)
    @spell_num += 1 if Input.key_push?(K_X)
    @spell = @spell_list[@spell_num % @spell_list.length]

    @charge_percent = 0.0 if @_old_spell_num != @spell_num
    @cool_time -= 1

    if @cool_time <= 0
      if !Input.mouse_down?(1)
        @bullet_count += 1
        _fire_bullet if @bullet_count % 14 == 0
      end

      if @charge_percent >= 1.0 && Input.mouse_release?(1)
        _fire_bullet(level: 2)
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

  def draw
    super

    # ため攻撃のゲージ
    Window.draw(self.x - 20, self.y + 10,
                @charge_circle_img[(@charge_percent * 8).to_i])
  end

  def animation(frame)
    self.image = @images[((@direction + 23) % 360) / 45][frame % 3]
  end

  private def _fire_bullet(level: 1)
    if level == 1
      _x = self.x + (image.width * 0.5)  + image.width  * 0.4 * Math.cos(@direction * Math::PI / 180.0)
      _y = self.y + (image.height * 0.6) + image.height * 0.4 * Math.sin(@direction * Math::PI / 180.0)
      Bullet.new(BulletData.list[:"level1_#{@spell}"], _x, _y)
    elsif level == 2
      case @spell
      when :holy
        Bullet.new(BulletData.list[:level2_holy], self.x, self.y)
      else
        bullet_name = :"level2_#{@spell}"
        unless BulletData.list.keys.include?(bullet_name)
          raise NameError, "BulletData.list undefined :#{bullet_name}"
        end
        Bullet.new(BulletData.list[bullet_name], nil, nil)
      end
      @cool_time = 100
    end
  end
end
