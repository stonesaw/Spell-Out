class Player < Sprite
  attr_accessor :spell, :life

  def initialize(spell, x, y, image)
    super
    self.x = x
    self.y = y
    self.image = image
    @spell = spell.to_sym
    @spell_num = $spell_list.index(@spell)
    @has_spell = $spell_list.map {|key| [key, false]}.to_h
    @has_spell[@spell] = true
    @life = 1
    
    @_spell_color = {
      fire: C_RED, water: [55, 183, 230], wind: [135, 224, 83], holy: [249, 250, 212], dark: [121, 73, 173]
    }
    @bullet_count = 0
  end

  def update
    # player controll
    self.x += 5 if Input.key_down?(K_D)
    self.x -= 5 if Input.key_down?(K_A)
    self.y += 2 if Input.key_down?(K_S)
    self.y -= 5 if Input.key_down?(K_W)

    enemies = self.check(Enemies.list)
    unless enemies.empty?
      @life -= 1
      Enemies.list.delete(enemies[0])
    end

    if @life <= 0
      # game over
    end

    # obj = Enemies.list + Bullet.list
    # obj.each { |o| o.x -= 3 } if Input.key_down?(K_D)
    # obj.each { |o| o.x += 3 } if Input.key_down?(K_A)
    # obj.each { |o| o.y -= 1 } if Input.key_down?(K_S)
    # obj.each { |o| o.y += 3 } if Input.key_down?(K_W)

    self.x = [[0, self.x].max, Window.width - self.image.width].min
    self.y = [[0, self.y].max, Window.height - self.image.height].min

    # hit enemy
    

    # spell change
    @spell_num += 1 if Input.key_push?(K_K)
    @spell_num -= 1 if Input.key_push?(K_J)
    @spell = $spell_list[@spell_num % $spell_list.length]
    
    if Input.key_push?(K_SPACE)
      @bullet_count = 0
      _fire_bullet
    end
    if Input.key_down?(K_SPACE)
      @bullet_count += 1
      _fire_bullet if @bullet_count % 15 == 0
    end
  end

  private
  def _fire_bullet
    image = Image.new(10, 10, @_spell_color[@spell])
    Bullet.new(@spell, 10,
               self.x + (self.image.width - image.width) / 2,
               self.y - image.height, image
    )
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
