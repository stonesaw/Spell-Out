class HPBar
  class << self
    attr_reader :enemy_hp_bar, :boss_hp_bar
  end

  def self.new
    @enemy_hp_bar = []
    @boss_hp_bar = []
  end

  def self.draw
    @enemy_hp_bar.each do |me|
      if !Enemy.list.include?(me[:enemy]) || me[:enemy].vanished?
        @enemy_hp_bar.delete(me)
      end
      next if me[:enemy].data.hp == me[:enemy].data.max_hp

      me[:bar] = Image.new(1 + me[:base].width * (me[:enemy].data.hp / me[:enemy].data.max_hp.to_f),
                           me[:base].height - 4,
                           C_GREEN)
      x = me[:enemy].x + (me[:enemy].image.width - me[:base].width) / 2
      y = me[:enemy].y #- me[:base].height
      Window.draw(x, y, me[:base])
      Window.draw(x + 2, y + 2, me[:bar])
    end
  end
end

HPBar.new
