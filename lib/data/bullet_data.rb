# BulletDataのインターフェース
class IBulletData < DataTemplate
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

  def initialize
    self.class._list_add_level1_bullet

    fire_img = []
    2.times do |i|
      fire_img << Image.load("#{$PATH}/assets/image/fire#{i}.png")
        .set_color_key(C_WHITE)
    end

    BulletData.list[:level2_fire] = IBulletData.new(:fire, 50, fire_img[0], anime: fire_img)
    .when_spawned do |bullet, tick, player|
      bullet.center_x = 64
      bullet.center_y = 128
    end
    .when_lived do |bullet, tick, player|
      passed_tick = tick - bullet.spawn_tick

      bullet.x = player.x - 30 + player.image.width  * 0.4  * Math.cos(player.direction * Math::PI / 180.0)
      bullet.y = player.y - 50 + player.image.height * 0.35 * Math.sin(player.direction * Math::PI / 180.0)
      bullet.angle = player.direction + 90
      bullet.alpha -= 10 if passed_tick >= 80 - 25

      bullet._anime_next if passed_tick % 16 == 0

      bullet.vanish if passed_tick >= 80
    end

    wind_img = []
    1.times do |i|
      wind_img << Image.load("#{$PATH}/assets/image/recovery#{i}.png").
        set_color_key(C_WHITE)
    end

    BulletData.list[:level2_wind] = IBulletData.new(:wind, 0, wind_img[0], anime: wind_img, is_draw_after: true)
    .when_spawned do |bullet, tick, player|
      player.life = [player.life + 10, player.max_life].min
      bullet.collision_enable = false # 当たり判定をなくす
    end
    .when_lived do |bullet, tick, player|
      passed_tick = tick - bullet.spawn_tick

      bullet.x = player.x + 10
      bullet.y = player.y + 50

      if (0..3).include?(passed_tick % 10)
        bullet.alpha = 0
      else
        bullet.alpha = 200
      end

      bullet._anime_next if passed_tick % 16 == 0

      bullet.vanish if passed_tick >= 80
    end
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

  private
  def self._list_add_level1_bullet
    spell_and_color.each_pair do |key, value|
      list[:"level1_#{key}"] = IBulletData.new(key, 10, Image.new(10, 10, value))
      .when_spawned do |bullet, tick, player|
        bullet.data.var[:speed] = 12
      end
      .when_lived do |bullet, tick, player|
        bullet.x += bullet.data.var[:speed] * Math.cos(bullet.direction * Math::PI / 180.0)
        bullet.y += bullet.data.var[:speed] * Math.sin(bullet.direction * Math::PI / 180.0)
      end
    end
  end
end
