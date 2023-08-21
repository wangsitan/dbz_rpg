#==============================================================================
# ■ TBoss_Effect
#------------------------------------------------------------------------------
# 　ボスアクションのエフェクトクラス
#==============================================================================
class TBoss_Effect < Sprite
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x, y, vx, vy)
    super()
    self.x = x
    self.y = y
    @sx = x << 10
    @sy = y << 10
    @vx = vx
    @vy = vy
    set_type
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    update_type
    @sx += @vx
    @sy += @vy
    self.x = @sx >> 10
    self.y = @sy >> 10
    @cnt -= 1
    self.x = 640 if @cnt == 0
    if self.x < -self.width or self.x > 640 or self.y < -self.height or self.y > 480
      dispose
      return
    end
  end
end

#==============================================================================
# ■ 爆発エフェクト
#==============================================================================
class TBoss_Effect1 < TBoss_Effect
  def set_type
    self.bitmap = Cache.system("effect1")
    self.opacity = 128
    self.z = 200
    @cnt = 2048
  end
  def update_type
    self.opacity -= 1
  end
end

#==============================================================================
# ■ 弾ヒットエフェクト
#==============================================================================
class TBoss_Effect2 < TBoss_Effect
  def set_type
    self.bitmap = Cache.system("effect1")
    self.opacity = 255
    self.ox = 16
    self.oy = 16
    self.z = 200
    self.zoom_x = 0.5
    self.zoom_y = 0.5
    @cnt = 32
  end
  def update_type
    self.opacity -= 8
    self.zoom_x += 0.01
    self.zoom_y += 0.01
  end
end



