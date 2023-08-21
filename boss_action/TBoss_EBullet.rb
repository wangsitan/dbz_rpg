#==============================================================================
# ■ TBoss_EBullet
#------------------------------------------------------------------------------
# 　ボスアクションの敵機弾クラス
#==============================================================================
class TBoss_EBullet < Sprite
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x, y, vx, vy, type, index,tuibi)
    super(nil)
    if type == 1
      self.bitmap = Cache.system("ebullet1")
      self.src_rect = Rect.new(index * 12, 0, 12, 12)
      @power = 1
    else
      self.bitmap = Cache.system("ebullet2")
      self.src_rect = Rect.new(index * 32, 0, 32, 32)
      @power = 2
    end
    self.x = x - self.width / 2
    self.y = y - self.height / 2
    self.z = 110
    @sx = self.x << 10
    @sy = self.y << 10
    @vx = vx
    @vy = vy
    @tuibi = tuibi
  end
  #--------------------------------------------------------------------------
  # ● 更新
  #--------------------------------------------------------------------------
  def update
    
    if @tuibi == 0 || $shoot_player_x > self.x-64 #誘導が無効の場合
      @sy += @vy
    else
      if $shoot_player_y > self.y
        @vy =700
      elsif $shoot_player_y < self.y
        @vy =-700
      else
        @vy = 0
      end
    end
    @sy += @vy
    @sx += @vx
    
    self.x = @sx >> 10
    self.y = @sy >> 10
    if $scene.player.x + 24 > self.x and $scene.player.x + 8 < self.x + self.width
    if $scene.player.y + 24 > self.y and $scene.player.y + 8 < self.y + self.height
      $scene.player.damage(@power)
      $scene.add_effect(2, self.x + self.width / 2, self.y + self.height / 2, 0, 0)
      self.x = 640
    end
    end
    dispose if self.x < -12 or self.x >= 640 or self.y < -12 or self.y >= 410-40
  end
end

