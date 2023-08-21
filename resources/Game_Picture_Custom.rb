class Game_Picture
  attr_accessor :mirror
  attr_accessor :zoom_x
  alias _cao_initialize_picture initialize
  def initialize(number)
    _cao_initialize_picture(number)
    @mirror = false
  end
  alias _cao_show_picture show
  def show(name, origin, x, y, zoom_x, zoom_y, opacity, blend_type)
    _cao_show_picture(name, origin, x, y, zoom_x, zoom_y, opacity, blend_type)
    @mirror = false

  end
end
class Sprite_Picture < Sprite
  alias _cao_update_picture update
  def update
    _cao_update_picture
    self.mirror = @picture.mirror if @picture_name != ""
  end
  
end