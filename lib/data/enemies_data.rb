class IEnemyData < ISpriteData
  attr_accessor :name, :hp, :max_hp, :score, :direction, :exp

  def initialize(name, spell, hp, score, exp, image, anime: [])
    super(spell, image, anime)
    @name   = name.to_s
    @hp     = hp.to_i
    @max_hp = hp.to_i
    @score  = score.to_i
    @exp    = exp.to_i
    @direction = 0
  end

  def dead(self_)
  end
end

# スライム
class Slime < IEnemyData
  def initialize(name, spell, image, anime: [])
    super(name, spell, 100, 10, 10, image, anime: anime)
  end

  def spawned(self_)
    self_.add_hp_bar(x: 0.7, y: 0.7)
    self_.collision = [64, 100, 27]
    self_.data.var[:speed] = 2
  end

  def lived(self_)
    passed_tick = Play.tick - self_.spawn_tick

    distance_x = self_.x - Play.player.x
    distance_y = self_.y - Play.player.y
    self_.data.direction = Math.atan2(distance_y, distance_x) * 180.0 / Math::PI
    self_.data.direction = 360 + self_.data.direction if self_.data.direction < 0

    obj = Play.stage.objects
    self_.x -= dx = self_.data.var[:speed] * Math.cos(self_.data.direction * Math::PI / 180.0)
    self_.x += dx * 2 unless self_.check(obj).empty?

    self_.y -= dy = self_.data.var[:speed] * Math.sin(self_.data.direction * Math::PI / 180.0)
    self_.y += dy * 2 unless self_.check(obj).empty?

    self_.anime_next if passed_tick % 10 == 0

    bullets = self_.check(Bullet.list)
    unless bullets.empty?
      SE.play(:slime)
      self_.calc_hp(bullets[0])
      Bullet.list.delete(bullets[0]) # TODO: Bullet の削除 : bullet_data に移動
    end
  end

  def dead(self_)
    SE.play(:retro04)
    # $se_retro04.set_volume(255 * $volume)
    $score += self_.data.score
    Play.player.exp += self_.data.exp
    Play.player.level = Play.player.exp / 50 # TODO: レベルのあげ方

    self_.vanish
  end
end

class SlimeWater < Slime
  def self.new
    @images ||= Image.load_tiles("#{$PATH}/assets/image/slime.png", 3, 1)
    super('水スライム', :water, @images[0], anime: @images)
  end
end

class SlimeWind < Slime
  def self.new
    if @images.nil?
      @images = Image.load_tiles("#{$PATH}/assets/image/slime2.png", 3, 1)
    end
    super('風スライム', :wind, @images[0], anime: @images)
  end
end

# ゴーレム
class Golem < IEnemyData
  def initialize
    _golem_img = Image.load_tiles("#{$PATH}/assets/image/Golem_stone.png", 6, 4)
    golem_img = [_golem_img[0], _golem_img[1], _golem_img[2]]
    super('ゴーレム', :dark, 500, 1000, 100, golem_img[0], anime: golem_img)
  end

  def spawned(self_)
    self_.add_hp_bar
  end

  def lived(self_)
    passed_tick = Play.tick - self_.spawn_tick

    self_.y += 2
    self_.y = -300 if self_.y > Window.height

    self_.anime_next if passed_tick % 10 == 0

    bullets = self_.check(Bullet.list)
    unless bullets.empty?
      SE.play(:slime)
      self_.calc_hp(bullets[0])
      Bullet.list.delete(bullets[0]) # TODO: Bullet の削除 : bullet_data に移動
    end
  end

  def dead
    SE.play(:retro04)
    # $se_retro04.set_volume(255 * $volume)
    $score += self_.data.score
    Play.player.exp += self_.data.exp
    Play.player.level = Play.player.exp / 50 # TODO: レベルのあげ方

    self_.vanish
  end
end
