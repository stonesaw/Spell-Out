class Player < Sprite
  attr_accessor :spell, :life, :images, :_angle

  def initialize(spell, x, y, images)
    super
    self.x = x
    self.y = y
    @images = images
    self.image = @images[0][0]
    self.collision = [8, 36, 70, 112]
    @spell = spell.to_sym
    @spell_num = $spell_list.index(@spell)
    @has_spell = $spell_list.map {|key| [key, false]}.to_h
    @has_spell[@spell] = true
    @life = 3
    @speed = 4
    @_angle = 0 # キャラクターの画像用
    # @@se_bullet = Sound.new("#{$PATH}/assets/sound/se_retro03.wav")
    
    @_spell_color = {
      fire: C_RED, water: [55, 183, 230], wind: [135, 224, 83], holy: [249, 250, 212], dark: [121, 73, 173]
    }
    @bullet_count = 0
    @anime_count = 0
  end

  def update(tick)
    # player controll
    self.x += 5 if Input.key_down?(K_D)
    self.x -= 5 if Input.key_down?(K_A)
    self.y += 2 if Input.key_down?(K_S)
    self.y -= 5 if Input.key_down?(K_W)

    # マウス移動
    
    mx = Mouse.x
    my = Mouse.y
    ox = self.x + (self.image.width / 2)
    oy = self.y + (self.image.height / 2)
    
    unless (0..10).include?((ox - mx).abs) && (0..10).include?((oy - my).abs)
      angle = Math.atan2(my - oy, mx - ox) * 180.0 / Math::PI
      angle = 360 + angle if angle < 0
      angle = angle.to_i
      @_angle = angle
      self.x += @speed * Math.cos(@_angle * Math::PI / 180.0)
      self.y += @speed * Math.sin(@_angle * Math::PI / 180.0)
    end

    # _ang = @_angle > 180 ? 360 - @_angle : @_angle
    # if (@_angle - angle).abs < 3
    #   @_angle = angle
    # else
    #   if angle + _ang < 180
    #     @_angle += 3
    #   else
    #     @_angle -= 3
    #   end
      # if angle < 180 && (0..angle).include?(@_angle) || ((angle + 180) % 360..360).include?(@_angle)
      #   @_angle -= 5
      # else
      #   @_angle += 5
      # end
    # end

    self.x = [[0, self.x].max, Window.width - self.image.width].min
    self.y = [[0, self.y].max, Window.height - self.image.height].min

    # [右 → から時計回り][アニメーション]
    @anime_count += 1 if tick % 10 == 0
    self.image = @images[((@_angle + 23) % 360) / 45][@anime_count % 3]

    # hit enemy
    enemies = self.check(Enemies.list)
    unless enemies.empty?
      @life -= 1
      Enemies.list.delete(enemies[0])
    end


    # obj = Enemies.list + Bullet.list
    # obj.each { |o| o.x -= 3 } if Input.key_down?(K_D)
    # obj.each { |o| o.x += 3 } if Input.key_down?(K_A)
    # obj.each { |o| o.y -= 1 } if Input.key_down?(K_S)
    # obj.each { |o| o.y += 3 } if Input.key_down?(K_W)


    # spell change
    @spell_num -= 1 if Input.key_push?(K_Z)
    @spell_num += 1 if Input.key_push?(K_X)
    @spell = $spell_list[@spell_num % $spell_list.length]
    
    if Input.key_push?(K_SPACE)
      @bullet_count = 0
      _fire_bullet
    end
    if Input.key_down?(K_SPACE)
      @bullet_count += 1
      _fire_bullet if @bullet_count % 10 == 0
    end
  end

  private
  def _fire_bullet
    # @@se_bullet.play
    _x = self.x + (self.image.width * 0.5)  + self.image.width  * 0.4 * Math.cos(@_angle * Math::PI / 180.0)
    _y = self.y + (self.image.height * 0.6) + self.image.height * 0.4 * Math.sin(@_angle * Math::PI / 180.0)
    image = Image.new(10, 10, @_spell_color[@spell])
    Bullet.new(@spell, 20, @_angle, _x, _y, image)

    # x = self.x + (self.image.width - image.width) / 2
    # y = self.y - image.height
    # case @spell
    # when :fire
    #   anime = Bullet.fire_img
    #   image = Bullet.fire_img[0]
    #   x = self.x + (self.image.width - image.width) / 2
    #   y = self.y - image.height
    #   Bullet.new(@spell, 10, x, y, image, anime: anime).collision = [20, 35, 70, 73]
    # else
    #   anime = []
    #   Bullet.new(@spell, 10, x, y, image, anime: anime)
    # end
  end
  
  public
  def draw
    super
  end

  def has_spell?(spell)
    spell = spell.to_sym
    @has_spell[spell]
  end
end
