# BulletDataのインターフェース
class IBulletData < ISpriteData
  attr_accessor :attack
  attr_reader :is_draw_after

  def initialize(spell, attack, image, anime: [], is_draw_after: false)
    super(spell, image, anime)
    @is_draw_after = is_draw_after
    @attack = attack
  end
end

# ため攻撃のデータ
class BulletData
  @list = {}
  @charge_tick = {
    fire: 60,
    water: 60,
    wind: 200,
    holy: 80,
    dark: 80,
  }

  class << self
    attr_reader :list, :charge_tick
  end

  def self.load
    _list_add_level1_bullet
    @list[:level2_fire] = BulletFileLevel2.new
    @list[:level2_wind] = BulletWindLevel2.new
  end

  def self.spell_and_color
    {
      fire: [255, 0, 0],
      water: [55, 183, 230],
      wind: [23, 255, 123],
      holy: [249, 250, 212],
      dark: [121, 73, 173],
    }
  end


  def self._list_add_level1_bullet
    spell_and_color.each_pair do |spell, color|
      list[:"level1_#{spell}"] = BulletLevel1.new(spell, color)
    end
  end
  private_class_method :_list_add_level1_bullet
end

class BulletLevel1 < IBulletData
  def self.new(spell, color)
    super(spell, 10, Image.new(10, 10, color))
  end

  def spawned(bullet)
    bullet.data.var[:speed] = 12
  end

  def lived(bullet)
    bullet.x += bullet.data.var[:speed] * Math.cos(bullet.direction * Math::PI / 180.0)
    bullet.y += bullet.data.var[:speed] * Math.sin(bullet.direction * Math::PI / 180.0)
  end
end

class BulletFileLevel2 < IBulletData
  def self.new
    @images ||= (0..1).map do |i|
      Image.load("#{$PATH}/assets/image/fire#{i}.png").set_color_key(C_WHITE)
    end
    super(:fire, 50, @images[0], anime: @images)
  end

  def spawned(bullet)
    bullet.center_x = 64
    bullet.center_y = 128
  end

  def lived(bullet)
    passed_tick = Play.tick - bullet.spawn_tick

    bullet.x = Play.player.x - 30 + Play.player.image.width  * 0.4  * Math.cos(Play.player.direction * Math::PI / 180.0)
    bullet.y = Play.player.y - 50 + Play.player.image.height * 0.35 * Math.sin(Play.player.direction * Math::PI / 180.0)
    bullet.angle = Play.player.direction + 90
    bullet.alpha -= 10 if passed_tick >= 80 - 25

    bullet._anime_next if passed_tick % 16 == 0

    bullet.vanish if passed_tick >= 80
  end
end

class BulletWindLevel2 < IBulletData
  def self.new
    @images ||= [0].map do |i|
      Image.load("#{$PATH}/assets/image/recovery#{i}.png").set_color_key(C_WHITE)
    end
    super(:wind, 0, @images[0], anime: @images, is_draw_after: true)
  end

  def spawned(bullet)
    Play.player.life = [Play.player.life + 10, Play.player.max_life].min
    bullet.collision_enable = false # 当たり判定をなくす
  end

  def lived(bullet)
    passed_tick = Play.tick - bullet.spawn_tick

    bullet.x = Play.player.x + 10
    bullet.y = Play.player.y + 50

    if (0..3).include?(passed_tick % 10)
      bullet.alpha = 0
    else
      bullet.alpha = 200
    end

    bullet._anime_next if passed_tick % 16 == 0

    bullet.vanish if passed_tick >= 80
  end
end
