class Enemy < Sprite
  attr_reader :data, :spawn_tick
  attr_accessor :hp_bar, :hp_bar_base

  class << self
    attr_accessor :list
    attr_reader :_spell_match, :_spell_miss
  end

  def self.reset
    @list = []
  end


  def initialize(data, now_tick, x, y, player)
    @data = data.dup
    super
    self.x = x
    self.y = y
    self.image = @data.image
    @anime = @data.anime
    @_anime_count = 0
    # @data.remove_instance_variable(:@image)
    # @data.remove_instance_variable(:@anime)
    @spawn_tick = now_tick

    @data.proc_spawned.call(self, now_tick, player)

    self.class.list << self
  end

  def update(enemy, tick, player)
    @data.proc_lived.call(enemy, tick, player)
    @data.proc_dead.call(enemy, tick, player) if data.hp <= 0
  end

  # utils

  def calc_hp(bullet)
    boost = if spell_matching?(bullet)
              1.5
            elsif spell_missing?(bullet)
              0.3
            else
              1.0
            end

    data.hp = [0, data.hp - bullet.attack * boost].max
  end

  def spell_matching?(bullet)
    self.class._spell_match.each do |to, from|
      return (bullet.spell == to && data.spell == from)
    end
    false
  end

  def spell_missing?(bullet)
    self.class._spell_miss.each do |to, from|
      return true if bullet.spell == to && data.spell == from
    end
    false
  end

  def anime_next
    @_anime_count = (@_anime_count + 1) % @anime.length
    @image = @anime[@_anime_count]
    self.image = @image
  end

  def add_hp_bar(x: 1, y: 1)
    HPBar.enemy_hp_bar << {
      enemy: self,
      base: Image.new(x * (image.width * 0.9),    y * (image.height * 0.15), [240, 240, 240]),
      bar: Image.new(x * (image.width * 0.9 - 4), y * (image.height * 0.15 - 4), [124, 224, 43]),
    }
  end

  def add_boss_bar
    HPBar.boss_hp_bar << {
      enemy: self,
      base: Image.new(image.width * 0.9, image.height * 0.15, [240, 240, 240]),
      bar: Image.new(image.width * 0.9 - 4, image.height * 0.15 - 4, [124, 224, 43]),
    }
  end

  # class method & variable

  @list = []
  @_spell_match = [
    # [to, from] (bullet -> enemy)
    [:fire, :wind],
    [:wind, :water],
    [:water, :fire],
    [:holy, :dark],
    [:dark, :holy],
  ]
  @_spell_miss = @_spell_match.map.with_index {|spells, i| spells.reverse if i < 3 }
  @_spell_miss.compact!
end
