class Bullet < Sprite
  attr_accessor :spell, :attack
  
  @@list = []
  
  def initialize(spell, attack, x, y, image)
    @spell = spell.to_sym
    @attack = attack
    super
    self.x = x
    self.y = y
    self.image = image
    
    @@list << self
  end

  class << self
    def update
      i = 1
      @@list.length.times do
        @@list[-i].y -= 8
        if @@list[-i].y < 0
          @@list.delete_at(-i)
        end
        i += 1
      end
    end

    def draw
      Sprite.draw(@@list)
    end

    def all
      @@list
    end
  end
end
