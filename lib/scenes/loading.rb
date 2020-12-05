# Scene - Loading
# specially scene
# imported 'scene-manager.rb'
class Loading < Scene
  @font = Font.new(32)

  class << self
    def draw
      Window.draw_font(0, 0, "Loading", @font)
    end
  end
end
