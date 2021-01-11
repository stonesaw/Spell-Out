class Bullet < Sprite
  attr_accessor :spell, :attack, :anime, :is_anime, :_anime_cnt, :direction, :speed
  attr_reader :data

  # 引数 data は、BulletData を参照
  # 通常の Bullet の場合は nil
  # ため攻撃のときのみ、data を与える
  def initialize(spell, attack, direction, x, y, image, anime: [])
    @spell = spell.to_sym
    @attack = attack
    @direction = direction.to_i
    super
    self.x = x
    self.y = y
    self.image = image
    # self.angle = -90
    @anime = anime
    @_anime_cnt = 0
    @is_anime = !anime.empty?

    @speed = 12
    @@list << self

    @data = nil
  end


  class << self
    def _load
      @@list = []
      # 61.times do |i|
      #   @@fire_img << Image.load(["#{$PATH}/assets/image/Fx_pack/1/1_", i, ".png"].join)
      # end
    end

    def update(tick, _player)
      i = 1
      del = []
      @@list.length.times do
        if @@list[-i].data == nil
          @@list[-i].x += @@list[-i].speed * Math.cos(@@list[-i].direction * Math::PI / 180.0)
          @@list[-i].y += @@list[-i].speed * Math.sin(@@list[-i].direction * Math::PI / 180.0)
        else
          @@list[-i].data.block.call(@@list[-i], tick, _player)
        end

        # if @@list[-i].is_anime
        #   @@list[-i]._anime_cnt += 1
        #   @@list[-i]._anime_cnt %= @@list[-i].anime.length
        #   @@list[-i].image = @@list[-i].anime[@@list[-i]._anime_cnt]
        # end

        unless (0..Window.width).include?(@@list[-i].x) &&
               (0..Window.height).include?(@@list[-i].y)
          del << i
        end
        i += 1
      end
      del.each do |i|
        @@list.delete_at(-i)
      end
    end

    

    def draw
      Sprite.draw(@@list)
    end

    def _spell_color
      {
        fire: [255, 0, 0],
        water: [55, 183, 230],
        wind: [23, 255, 123],
        holy: [249, 250, 212],
        dark: [121, 73, 173]
      }
    end

    def list
      @@list
    end

    def reset
      @@list = []
    end
  end
end

Bullet._load


class ChargeBullet < Sprite
  attr_accessor :spell, :attack, :anime, :is_anime, :_anime_cnt, :direction
  attr_reader :data, :spawn_tick

  def initialize(data, now_tick, x, y, direction)
    @data = data.dup
    super
    self.x = x
    self.y = y
    self.image = @data.image
    @direction = direction
    @anime = @data.anime
    @spell = @data.spell
    @attack = @data.attack
    @_anime_cnt = 0
    @spawn_tick = now_tick

    Bullet.list << self
    self
  end

  
  def _anime_next
    @_anime_cnt = (@_anime_cnt + 1) % @anime.length
    @image = @anime[@_anime_cnt]
    self.image = @image
  end
end