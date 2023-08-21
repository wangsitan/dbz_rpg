#==============================================================================
# ■ Event_Sprite
#------------------------------------------------------------------------------
# 　イベント時画像描画
#==============================================================================
class Event_Sprite < Sprite#_Base
  
  def initialize(x, y,bitmap_name,bitmap_rect,i)
    super(nil)
    
    self.x = x
    self.y = y
    self.z = i
    self.bitmap = Cache.picture(bitmap_name)
    self.src_rect = bitmap_rect#Rect.new(bitmap_rect)
    @shake_x = 0
    @shake_y = 0
    @angle_x = 0.0
    @angle_y = 0.0
    #@info = Sprite.new()
    #@info.bitmap = Bitmap.new(16, 120)
    #@info.x = 84
    #@info.y = 36
    #@info.shake = false
    #redraw_info

  end
  
  def update
    if $game_switches[21] == true
      @shake_x = 4
      if $game_switches[22] == true
        @shake_x = 0
        @shake_y = 4
      elsif $game_switches[23] == true
        @shake_x = 4
        @shake_y = 4
      end
      if @shake_x > 0
        @angle_x += 0.7
        @shake_x -= 1
        #p (Math.cos(@angle_x) * @shake_x).to_i
        self.x = (Math.cos(@angle_x) * @shake_x).to_i + self.x
      end
      if @shake_y > 0
        @angle_y += 0.7
        @shake_y -= 1
        self.y = (Math.sin(@angle_y) * @shake_y).to_i + self.y
      end
    end
  end
end 