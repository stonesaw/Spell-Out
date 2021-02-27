class Bullet < Sprite
  attr_accessor :spell, :attack, :anime, :is_anime, :_anime_cnt, :direction
  attr_reader :data, :spawn_tick

  def initialize(data, x, y)
    @data = data.clone
    @data.var = JSON.parse(data.var.to_json)
    super(x, y, @data.image)
    @direction = Play.player.direction
    @anime = @data.anime
    @spell = @data.spell
    @attack = @data.attack
    @_anime_cnt = 0
    @spawn_tick = Play.tick

    @data.spawned(self)
    self.class.list << self
    self
  end

  def _anime_next
    @_anime_cnt = (@_anime_cnt + 1) % @anime.length
    @image = @anime[@_anime_cnt]
    self.image = @image
  end


  @list = []
  class << self
    attr_reader :list
  end

  def self.update
    @list.each do |bullet|
      bullet.data.lived(bullet)

      if !((-500..Window.width + 500).include?(bullet.x) &&
           (-500..Window.height + 500).include?(bullet.y))
        bullet.vanish
      end
    end
    Sprite.clean(@list)
  end

  def self.draw
    @list.each do |bullet|
      bullet.draw unless bullet.data.is_draw_after
    end
  end

  def self.draw_after
    @list.each do |bullet|
      bullet.draw if bullet.data.is_draw_after
    end
  end

  def self.reset
    @list = []
  end

  def self._spell_color
    {
      fire: [255, 0, 0],
      water: [55, 183, 230],
      wind: [23, 255, 123],
      holy: [249, 250, 212],
      dark: [121, 73, 173],
    }
  end
end
