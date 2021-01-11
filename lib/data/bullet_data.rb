# BulletDataのインターフェース
class IBulletData
  attr_accessor :spell, :var, :attack, :wrap
  attr_reader :image, :anime, :block

  def initialize(spell, attack, image, anime: [], wrap: false)
    @spell = spell.to_sym
    @attack = attack
    @image = image
    @anime = anime
    @var = {}
    @block = nil
    @wrap = wrap
  end

  def spawn(&block)
    @block = block
  end
end


# ため攻撃のデータ
class BulletData
  def initialize
    @@list = {}

    fire_img = []
    2.times do |i|
      fire_img << Image.load("#{$PATH}/assets/image/fire#{i}.png")
      .set_color_key(C_WHITE)
    end
    @@list[:fire] = IBulletData.new(:fire, 50, fire_img[0], anime: fire_img)
    @@list[:fire].spawn do |me, tick, _player|
      passed_tick = tick - me.spawn_tick
      me.angle = me.direction + 90
      me.center_x = 64
      me.center_y = 128

      me.x = BulletData.fire_x(_player)
      me.y = BulletData.fire_y(_player)
      me.angle = _player.direction + 90
      me.alpha -= 10 if passed_tick >= 80 - 25

      me._anime_next if passed_tick % 16 == 0

      me.vanish if passed_tick >= 80
    end

    wind_img = []
    1.times do |i|
      wind_img << Image.load("#{$PATH}/assets/image/recovery#{i}.png")
      .set_color_key(C_WHITE)
    end
    @@list[:wind] = IBulletData.new(:wind, 0, wind_img[0], anime: wind_img, wrap: true)
    @@list[:wind].spawn do |me, tick, _player|
      passed_tick = tick - me.spawn_tick
      _player.life = [_player.life + 10, _player.max_life].min if passed_tick == 0
      me.collision_enable = false # 当たり判定をなくす

      me.x = BulletData.wind_x(_player)
      me.y = BulletData.wind_y(_player)

      if (0..3).include?(passed_tick % 10)
        me.alpha = 0
      else
        me.alpha = 200
      end

      me._anime_next if passed_tick % 16 == 0

      me.vanish if passed_tick >= 80
    end
  end

  class << self
    def list
      @@list
    end

    def charge_tick
      {
        fire: 60,
        water: 60,
        wind: 200,
        holy: 80,
        dark: 80
      }
    end
  
    def fire_x(player)
      player.x - 30 + player.image.width  * 0.4  * Math.cos(player.direction * Math::PI / 180.0)
    end
  
    def fire_y(player)
      player.y - 50 + player.image.height * 0.35 * Math.sin(player.direction * Math::PI / 180.0)
    end

    def wind_x(player)
      player.x + 10
    end
    
    def wind_y(player)
      player.y + 50
    end
  end
end
