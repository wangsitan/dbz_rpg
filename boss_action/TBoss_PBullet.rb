#==============================================================================
# ■ TBoss_PBullet
#------------------------------------------------------------------------------
# 　ボスアクションの自機弾クラス
#==============================================================================
class TBoss_PBullet < Sprite
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(type, x, y, dir)
    super(nil)
    if type == 1
      self.bitmap = Cache.system("pbullet1")
    elsif type == 2
      self.bitmap = Cache.system("pbullet2")
    else
      self.bitmap = Cache.system("pbullet3")
    end
    self.x = x + (16 - self.width / 2)
    self.y = y + (16 - self.height / 2)
    self.z = 100
    self.mirror = (dir == 4 ? true : false)
    @vx = (dir == 4 ? -8 : 8)
    @power = type
  end
  #--------------------------------------------------------------------------
  # ● 更新
  #--------------------------------------------------------------------------
  def update
    self.x += @vx
    for i in 0...$scene.enemy.size
      next if $scene.enemy[i] == nil
      if self.x <= $scene.enemy[i].x + 32 and self.x + self.width >= $scene.enemy[i].x
      if self.y <= $scene.enemy[i].y + 32 and self.y + self.height >= $scene.enemy[i].y
        $scene.enemy[i].damage(@power)
        $scene.add_effect(2, self.x + self.width / 2, self.y + self.height / 2, 0, 0)
        self.x = 640
        break
      end
      end
    end
    dispose if self.x < 0 - self.width or self.x >= 640
  end
end

