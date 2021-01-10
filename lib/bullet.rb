class Bullet < Sprite
  attr_accessor :spell, :attack, :anime, :is_anime, :anime_cnt, :direction, :speed

  def initialize(spell, attack, direction, x, y, image, anime: [])
    @spell = spell.to_sym
    @attack = attack
    @direction = direction.to_i
    super
    self.x = x
    self.y = y
    self.image = image
    self.angle = -90
    @anime = anime
    @anime_cnt = 0
    @is_anime = !anime.empty?

    @speed = 12
    @@list << self
  end

  class << self
    def _load
      @@list = []
      # @@fire_img = []
      # 61.times do |i|
      #   @@fire_img << Image.load(["#{$PATH}/assets/image/Fx_pack/1/1_", i, ".png"].join)
      # end
    end

    def update
      i = 1
      del = []
      @@list.length.times do
        @@list[-i].x += @@list[-i].speed * Math.cos(@@list[-i].direction * Math::PI / 180.0)
        @@list[-i].y += @@list[-i].speed * Math.sin(@@list[-i].direction * Math::PI / 180.0)
        # @@list[-i].y -= 8
        if @@list[-i].is_anime
          @@list[-i].anime_cnt = (@@list[-i].anime_cnt + 1) % @@list[-i].anime.length
          @@list[-i].image = @@list[-i].anime[@@list[-i].anime_cnt]
        end

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

    # def fire_img
    #   @@fire_img
    # end

    def reset
      @@list = []
    end
  end
end

Bullet._load
