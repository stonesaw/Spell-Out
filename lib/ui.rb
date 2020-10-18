class UI
  def initialize
    @@enemy_hp_bar = []
  end

  class << self
    def draw
      @@enemy_hp_bar.each do |me|
        @@enemy_hp_bar.delete(me) unless Enemies.list.include?(me[:enemy])
        next if me[:enemy].data.hp == me[:enemy].data.max_hp
        me[:bar] = Image.new(1 + me[:base].width * (me[:enemy].data.hp.to_f / me[:enemy].data.max_hp.to_f), me[:base].height - 4, C_GREEN)
        x = me[:enemy].x + (me[:enemy].image.width - me[:base].width) / 2
        y = me[:enemy].y - me[:base].height
        Window.draw(x, y, me[:base])
        Window.draw(x + 2, y + 2, me[:bar])
      end
    end

    def enemy_hp_bar
      @@enemy_hp_bar
    end
  end
end

UI.new
