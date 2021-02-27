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
    @list[:level2_holy] = BulletHolyLevel2.new
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


# レベル1 全属性
class BulletLevel1 < IBulletData
  def self.new(spell, color)
    super(spell, 10, Image.new(10, 10, color))
  end

  def spawned(self_)
    self_.data.var[:speed] = 12
  end

  def lived(self_)
    if self_.data.var[:vanish_passed].nil?
      self_.x += dx = self_.data.var[:speed] * Math.cos(self_.direction * Math::PI / 180.0)
      self_.y += dy = self_.data.var[:speed] * Math.sin(self_.direction * Math::PI / 180.0)

      obj = self_.check(Play.stage.objects)
      unless obj.empty?
        self_.collision_enable = false
        self_.x -= dx * 0.5
        self_.y -= dy * 0.5
        self_.data.var[:vanish_passed] = 0
        self_.image = Image.new(20, 20)
      end
    else
      self_.data.var[:vanish_passed] += 1
      count = self_.data.var[:vanish_passed]
      self_.image = Image.new(10 + count, 10 + count, C_WHITE)
      self_.x -= 0.5
      self_.y -= 0.5
      self_.alpha -= 7
      self_.vanish if self_.alpha <= 7
    end
  end
end


# レベル2 ファイア
class BulletFileLevel2 < IBulletData
  def self.new
    @images ||= (0..1).map do |i|
      Image.load("#{$PATH}/assets/image/fire#{i}.png").set_color_key(C_WHITE)
    end
    super(:fire, 50, @images[0], anime: @images)
  end

  def spawned(self_)
    self_.center_x = 64
    self_.center_y = 128
  end

  def lived(self_)
    passed_tick = Play.tick - self_.spawn_tick

    player = Play.player
    self_.x = player.x - 30 + player.image.width  * 0.4  * Math.cos(player.direction * Math::PI / 180.0)
    self_.y = player.y - 50 + player.image.height * 0.35 * Math.sin(player.direction * Math::PI / 180.0)
    self_.angle = player.direction + 90
    self_.alpha -= 10 if passed_tick >= 80 - 25

    self_._anime_next if passed_tick % 16 == 0

    self_.vanish if passed_tick >= 80
  end
end


# レベル2 風
class BulletWindLevel2 < IBulletData
  def self.new
    @images ||= [0].map do |i|
      Image.load("#{$PATH}/assets/image/recovery#{i}.png").set_color_key(C_WHITE)
    end
    super(:wind, 0, @images[0], anime: @images, is_draw_after: true)
  end

  def spawned(self_)
    Play.player.life = [Play.player.life + 10, Play.player.max_life].min
    self_.collision_enable = false # 当たり判定をなくす
  end

  def lived(self_)
    passed_tick = Play.tick - self_.spawn_tick

    self_.x = Play.player.x + 10
    self_.y = Play.player.y + 50

    if (0..3).include?(passed_tick % 10)
      self_.alpha = 0
    else
      self_.alpha = 200
    end

    self_._anime_next if passed_tick % 16 == 0

    self_.vanish if passed_tick >= 80
  end
end


# レベル2 光
class BulletHolyLevel2 < IBulletData
  def self.new
    super(:holy, 0, Image.new(1, 1))
  end

  def spawned(self_)
    self_.collision_enable = false
  end

  def lived(self_)
    passed_tick = Play.tick - self_.spawn_tick
    if passed_tick % 10 == 0 && (0..50).include?(passed_tick)
      Bullet.new(BulletHolyLevel2Child.new, Play.player.x, Play.player.y)
    elsif passed_tick > 50
      self_.vanish
    end
  end
end

class BulletHolyLevel2Child < IBulletData
  def self.new
    @images ||= [Image.load("#{$PATH}/assets/image/_holy0.png")]
    super(:holy, 10, @images[0])
  end

  def spawned(self_)
    self_.data.var[:speed] = 14
    self_.data.var[:d] = self_.direction

    # TODO スポーンする位置の調整
    self_.angle = Play.player.direction + 90
  end

  def lived(self_)
    self_.x += self_.data.var[:speed] * Math.cos(self_.data.var[:d] * Math::PI / 180.0)
    self_.y += self_.data.var[:speed] * Math.sin(self_.data.var[:d] * Math::PI / 180.0)
  end
end
