#==============================================================================
# ■ TBoss_Player
#------------------------------------------------------------------------------
# 　ボスアクションの自機クラス
#==============================================================================
class TBoss_Player < Sprite
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
    self.z = 100
    self.bitmap = Cache.picture("shoot1")
    self.src_rect = Rect.new(0,0, 32, 32)
    self.color = Color.new(0, 0, 0, 0)
    @hp = 30
    @sx = x << 10
    @sy = y << 10
    @vx = 0
    @vy = 0
    @charge = 0     # チャージタイマー
    @throw = 0      # 無敵タイマー
    @anime = 0      # アニメタイマー
    @dir = 6        # 向き
    @jump = false   # ジャンプフラグ
    @info = Sprite.new
    @info.bitmap = Bitmap.new(16, 120)
    @info.x = 36
    @info.y = 36
    @info.z = 50
    @speed = 2500
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
    update_move
    #if @throw < 60
      
      #if Input.press?(Input::C)      # ショット
      #  $scene.add_pbullet(1, self.x, self.y, @dir) if @charge == 0
      #  @charge += 1
      #  $scene.se_flag[4] = (@charge == 45 or @charge == 90)
      #else
      #  if @charge >= 45
      #    $scene.add_pbullet((@charge < 90 ? 2 : 3), self.x, self.y, @dir)
      #  end
      #  @charge = 0
      #end
    #end
    update_anime
  end
  #--------------------------------------------------------------------------
  # ● 更新(移動処理)
  #--------------------------------------------------------------------------
  def update_move
    @vx = 0
    @vy = 0
    

    if Input.press?(Input::LEFT)
      @vx = -@speed
      @dir = 4
    elsif Input.press?(Input::RIGHT)
      @vx = @speed
      @dir = 6
    end
    if Input.press?(Input::UP)
      @vy = -@speed
      @dir = 8
    elsif Input.press?(Input::DOWN)
      @vy = @speed
      @dir = 2
    end
    
    if Input.press?(Input::LEFT) || Input.press?(Input::RIGHT)
      
    else
      @vx = @speed /2
    end
    @sx += @vx
    @sy += @vy
    
    @sx = (32 << 10) if @sx < (32 << 10)
    @sx = (608-32 << 10) if @sx > (608-32 << 10)
    @sy = (0 << 10) if @sy < (0 << 10)
    @sy = (400-64 << 10) if @sy > (400-64 << 10)

    self.x = @sx >> 10
    self.y = @sy >> 10
    $shoot_player_x = self.x
    $shoot_player_y = self.y
  end
  #--------------------------------------------------------------------------
  # ● 更新(アニメーション)
  #--------------------------------------------------------------------------
  def update_anime
    self.visible = (@throw / 2 % 2 == 0 ? true : false)
    if @charge < 45
      self.color.set(0, 0, 0, 0)
    elsif @charge < 90
      self.color.set(255, 255, 64, 128)
    else
      self.color.set(255, 64, 64, 128)
    end
    @anime = (@anime + 1) % 60
    pattern = @anime / 15
    pattern = pattern < 3 ? pattern : 1
    #self.src_rect.set(($game_temp.tboss_p_index % 4 * 3 + pattern) * 32,
    #  $game_temp.tboss_p_index / 4 * 128 + ((@dir - 2) / 2) * 32, 32, 32)
  end
  #--------------------------------------------------------------------------
  # ● ダメージ
  #   返り値 : プレイヤーがダメージを受けたかどうかを返す
  #--------------------------------------------------------------------------
  def damage(n)
    return false if @throw > 0
    
    $shoot_damege_count +=1 
    $scene.se_flag[3] = true
    $scene.back_ground.shake(true, 8)
    $scene.back_ground.shake(false, 8)
    #@hp -= n
    if @hp <= 0   # 体力が０になった
      @hp = 0
      self.visible = false
      $scene.change_state(2)
      Audio.me_play("Audio/ME/Shock.mid", 100, 100)
      a = 0.0
      d = Math::PI * 2 / 8
      for i in 0...8
        $scene.add_effect(1, self.x, self.y, (Math.cos(a) * 2048).to_i,
          (Math.sin(a) * 2048).to_i)
        a += d
      end
    end
    #redraw_info
    @throw = 120
    @charge = 1
    return true
  end
  #--------------------------------------------------------------------------
  # ● 表示状態の変更
  #--------------------------------------------------------------------------
  def set_visible(flag)
    self.visible = flag
  end
  #--------------------------------------------------------------------------
  # ● 角度を返す
  #--------------------------------------------------------------------------
  def get_angle(sx, sy)
    angle = Math.atan2( @sy + (16 << 10) - sy, @sx + (16 << 10) - sx )
    return angle
  end
  #--------------------------------------------------------------------------
  # ● ＨＰゲージの再描画
  #--------------------------------------------------------------------------
  def redraw_info
    @info.bitmap.clear
    @info.bitmap.fill_rect(0, 0, 16, 120, Color.new(0, 0, 0))
    c = Color.new(224, 224, 255)
    for i in 0...@hp
      @info.bitmap.fill_rect(0, 116 - i * 4, 16, 3, c)
    end
  end
end

