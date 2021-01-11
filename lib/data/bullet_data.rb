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
    1.times do |i|
      fire_img << Image.load("#{$PATH}/assets/image/fire#{i}.png")
      .set_color_key(C_WHITE)
    end
    @@list[:fire] = IBulletData.new(:fire, 50, fire_img[0], anime: fire_img)
    @@list[:fire].spawn do |me, tick, _player|
      me.angle = me.direction + 90
      me.center_x = 64
      me.center_y = 128
      me.x += 0
    end
  end

  def self.list
    @@list
  end
end
