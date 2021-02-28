class ISpriteData
  attr_accessor :spell, :var
  attr_reader :image, :anime

  def initialize(spell, image, anime)
    @spell = spell.to_sym
    @image = image
    @anime = anime
    @var = {}
  end

  def spawned
  end

  def lived
  end

  class << self
    attr_accessor :images
  end
end
