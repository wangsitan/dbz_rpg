#==============================================================================
# ■ TBoss_Enemy
#------------------------------------------------------------------------------
# 　ボスアクションの敵機クラス
#==============================================================================
class TBoss_Enemy < Sprite
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader :sx
  attr_reader :sy
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(x, y)
    super(nil)
    self.x = x
    self.y = y
    self.z = 90
    @sx = x << 10
    @sy = y << 10
    @vx = 0
    @vy = 0
    @state = 0    # 状態ID
    @cnt = 0      # 行動カウント
    @throw = 0    # 無敵タイマー
    @anime = 0    # アニメタイマー
    @dir = 4
    @jump = false   # ジャンプフラグ
    @hp = 30
    set_type
    self.bitmap = Cache.picture("shoot1")
    self.src_rect = Rect.new(32,0, 32, 32)
    @info = Sprite.new
    @info.bitmap = Bitmap.new(16, 120)
    @info.x = 84
    @info.y = 36
    @info.z = 50
    #redraw_info
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    @info.dispose
    super
  end
  #--------------------------------------------------------------------------
  # ● 更新
  #--------------------------------------------------------------------------
  def update
    @throw -= 1 if @throw > 0
    if @hp <= 0
      $scene.se_flag[2] = true
      $scene.back_ground.shake(false, 16)
      a = 0.0
      d = Math::PI * 2 / 8
      for i in 0...8
        $scene.add_effect(1, self.x, self.y, (Math.cos(a) * 2048).to_i,
          (Math.sin(a) * 2048).to_i)
        a += d
      end
      dispose
      return
    end
    action
    @cnt += 1

    @sx += @vx
    @sy += @vy
    
    @sx = (0 << 10) if @sx < (0 << 10)
    @sx = (640+64 << 10) if @sx > (640+64 << 10)
    @sy = (0 << 10) if @sy < (0 << 10)
    @sy = (400-64 << 10) if @sy > (400-64 << 10)
    
    self.x = @sx >> 10
    self.y = @sy >> 10
    $shoot_enemy_x = self.x
    $shoot_enemy_y = self.y
    if $scene.player.x + 32 > self.x and $scene.player.x < self.x + 32
    if $scene.player.y + 32 > self.y and $scene.player.y < self.y + 32
      $scene.player.damage(3)
    end
    end
    update_anime
  end
  #--------------------------------------------------------------------------
  # ● ジャンプ
  #--------------------------------------------------------------------------
  def jump(vy)
    unless @jump
      @vy = vy
      @jump = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 更新(アニメーション)
  #--------------------------------------------------------------------------
  def update_anime
    self.visible = (@throw / 2 % 2 == 0 ? true : false)
    @anime = (@anime + 1) % 60
    pattern = @anime / 15
    pattern = pattern < 3 ? pattern : 1
    #self.src_rect.set((@file_index % 4 * 3 + pattern) * 32,
    #  @file_index / 4 * 128 + ((@dir - 2) / 2) * 32, 32, 32)
  end
  #--------------------------------------------------------------------------
  # ● ダメージ
  #   返り値 : 敵機がダメージを受けたかどうかを返す
  #--------------------------------------------------------------------------
  def damage(n)
    return false if @throw > 0
    $scene.se_flag[1] = true
    #@hp -= n
    #redraw_info
    @throw = 120
    return true
  end
  #--------------------------------------------------------------------------
  # ● n方向ショット
  #--------------------------------------------------------------------------
  def nway_shot(n, space, angle, speed, aim, type, index)
    x = @sx + (16 << 10)
    y = @sy + (16 << 10)
    d = angle
    d += $scene.player.get_angle(x, y) if aim
     d = d - ( space * ( n - 1 ) / 2 )
    for i in 0...n
      $scene.add_ebullet(self.x + 16, self.y + 16, (Math.cos(d) * speed).to_i,
        (Math.sin(d) * speed).to_i, type, index)
      d += space
    end
  end
  #--------------------------------------------------------------------------
  # ● 誘導ショット
  #--------------------------------------------------------------------------
  def pursuit_shot(n, space, angle, speed, aim, type, index,tuibi = 1)
    x = @sx + (16 << 10)
    y = @sy + (16 << 10)
    d = angle
    d += $scene.player.get_angle(x, y) if aim
     d = d - ( space * ( n - 1 ) / 2 )
    for i in 0...n
      $scene.add_ebullet(self.x + 16, self.y + 16, (Math.cos(d) * speed).to_i,
        (Math.sin(d) * speed).to_i, type, index,tuibi)
      d += space
    end
  end
  #--------------------------------------------------------------------------
  # ● 全方位ショット
  #--------------------------------------------------------------------------
  def nall_shot(n, angle, speed, aim, type, index)
    x = @sx + (16 << 10)
    y = @sy + (16 << 10)
    a = angle
    a += $scene.player.get_angle(x, y) if aim
    d = Math::PI * 2 / n
    for i in 0...n
      $scene.add_ebullet(self.x + 16, self.y + 16, (Math.cos(a) * speed).to_i,
        (Math.sin(a) * speed).to_i, type, index)
      a += d
    end
  end
  #--------------------------------------------------------------------------
  # ● ＨＰゲージの再描画
  #--------------------------------------------------------------------------
  def redraw_info
    @info.bitmap.clear
    @info.bitmap.fill_rect(0, 0, 16, 120, Color.new(0, 0, 0))
    c = Color.new(255, 224, 224)
    for i in 0...@hp
      @info.bitmap.fill_rect(0, 116 - i * 4, 16, 3, c)
    end
  end
end



