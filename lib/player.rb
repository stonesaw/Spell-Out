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
    
    @bullet_count = 0
    @anime_count = 0
    @hit_tick = 0
    @is_hit = false
  end

  def update(tick)
    anime_stop = false

    # player controll
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
    else
      anime_stop = true
    end

    self.x = [[0, self.x].max, Window.width - self.image.width].min
    self.y = [[0, self.y].max, Window.height - self.image.height].min

    # [右 → から時計回り][アニメーション]
    @anime_count += 1 if tick % 10 == 0
    if anime_stop
      a = 1
    else
      a = @anime_count % 3 
    end
    self.image = @images[((@_angle + 23) % 360) / 45][a]


    # hit enemy
    enemies = self.check(Enemies.list)
    unless enemies.empty? || @is_hit
      @life -= 1
      @hit_tick = tick
      @is_hit = true
      Enemies.list.delete(enemies[0])
    end

    if @hit_tick != 0 && tick - @hit_tick < 180
      self.alpha += 30
    else
      self.alpha = 255
      @is_hit = false
    end

    # spell change
    @spell_num -= Input.mouse_wheel_pos / 120
    Input.mouse_wheel_pos = 0
    @spell_num -= 1 if Input.key_push?(K_Z)
    @spell_num += 1 if Input.key_push?(K_X)
    @spell = $spell_list[@spell_num % $spell_list.length]
    
    if Input.key_push?(K_SPACE) || Input.mouse_push?(0)
      @bullet_count = 0
      _fire_bullet
    end
    if $p_set.auto_attack || Input.key_down?(K_SPACE) || Input.mouse_down?(0)
      @bullet_count += 1
      _fire_bullet if @bullet_count % 14 == 0
    end
  end

  private
  def _fire_bullet
    # @@se_bullet.play
    _x = self.x + (self.image.width * 0.5)  + self.image.width  * 0.4 * Math.cos(@_angle * Math::PI / 180.0)
    _y = self.y + (self.image.height * 0.6) + self.image.height * 0.4 * Math.sin(@_angle * Math::PI / 180.0)
    image = Image.new(10, 10, $spell_color[@spell])
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
