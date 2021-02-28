class StageSelect < Scene
  def self.new(stage_name)
    @font = Font.new(80, 'Poco')
    @stage_name = stage_name
  end

  def self.draw
    Window.draw_font(10, -20, 'Stage Select', @font)
    Window.draw_font(10, 40, "CLEAR #{@stage_name}", @font)
  end
end
