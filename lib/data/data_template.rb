class DataTemplate
  attr_accessor :spell, :var
  attr_reader :image, :anime, :proc_spawned, :proc_lived

  def initialize(spell, image, anime)
    @spell = spell.to_sym
    @image = image
    @anime = anime
    @var = {}
    @proc_spawned = proc {}
    @proc_lived = proc {}
  end

  def when_spawned(&block)
    @proc_spawned = block
    self
  end

  def when_lived(&block)
    @proc_lived = block
    self
  end
end
