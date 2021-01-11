# BulletDataのインターフェース
class IBulletData
  attr_accessor :spell, :var, :attack
  attr_reader :image, :anime, :block

  def initialize(spell, attack, image, anime: [])
    @spell = spell.to_sym
    @attack = attack
    @image = image
    @anime = anime
    @var = {}
    @block = nil
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

      me.x = _player.x - 30 + _player.image.width  * 0.4  * Math.cos(_player.direction * Math::PI / 180.0)
      me.y = _player.y - 50 + _player.image.height * 0.35 * Math.sin(_player.direction * Math::PI / 180.0)
      me.angle = _player.direction + 90
      if passed_tick >= 80 - 25
        me.alpha -= 10
      end
      me._anime_next if passed_tick % 16 == 0

      if passed_tick >= 80
        me.vanish
      end
    end
  end

  def self.list
    @@list
  end
end
