#==============================================================================
# ■ Sprite_Battler
#------------------------------------------------------------------------------
# 　バトラー表示用のスプライトです。Game_Battler クラスのインスタンスを監視し、
# スプライトの状態を自動的に変化させます。
#==============================================================================

class Sprite_Battler < Sprite_Base
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  WHITEN    = 1                      # 白フラッシュ (行動開始)
  BLINK     = 2                      # 点滅 (ダメージ)
  APPEAR    = 3                      # 出現 (出現、蘇生)
  DISAPPEAR = 4                      # 消滅 (逃走)
  COLLAPSE  = 5                      # 崩壊 (戦闘不能)
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :battler
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     viewport : ビューポート
  #     battler  : バトラー (Game_Battler)
  #--------------------------------------------------------------------------
  def initialize(viewport, battler = nil)
    super(viewport)
    @battler = battler
    @battler_visible = false
    @effect_type = 0            # エフェクトの種類
    @effect_duration = 0        # エフェクトの残り時間
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    if self.bitmap != nil
      self.bitmap.dispose
    end
    super
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    if @battler == nil
      self.bitmap = nil
    else
      @use_sprite = @battler.use_sprite?
      if @use_sprite
        self.x = @battler.screen_x
        self.y = @battler.screen_y
        self.z = @battler.screen_z
        update_battler_bitmap
      end
      setup_new_effect
      update_effect
    end
  end
  #--------------------------------------------------------------------------
  # ● 転送元ビットマップの更新
  #--------------------------------------------------------------------------
  def update_battler_bitmap
    if @battler.battler_name != @battler_name or
       @battler.battler_hue != @battler_hue
      @battler_name = @battler.battler_name
      @battler_hue = @battler.battler_hue
      self.bitmap = Cache.battler(@battler_name, @battler_hue)
      @width = bitmap.width
      @height = bitmap.height
      self.ox = @width / 2
      self.oy = @height
      if @battler.dead? or @battler.hidden
        self.opacity = 0
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 新しいエフェクトの設定
  #--------------------------------------------------------------------------
  def setup_new_effect
    if @battler.white_flash
      @effect_type = WHITEN
      @effect_duration = 16
      @battler.white_flash = false
    end
    if @battler.blink
      @effect_type = BLINK
      @effect_duration = 20
      @battler.blink = false
    end
    if not @battler_visible and @battler.exist?
      @effect_type = APPEAR
      @effect_duration = 16
      @battler_visible = true
    end
    if @battler_visible and @battler.hidden
      @effect_type = DISAPPEAR
      @effect_duration = 32
      @battler_visible = false
    end
    if @battler.collapse
      @effect_type = COLLAPSE
      @effect_duration = 48
      @battler.collapse = false
      @battler_visible = false
    end
    if @battler.animation_id != 0
      animation = $data_animations[@battler.animation_id]
      mirror = @battler.animation_mirror
      start_animation(animation, mirror)
      @battler.animation_id = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● エフェクトの更新
  #--------------------------------------------------------------------------
  def update_effect
    if @effect_duration > 0
      @effect_duration -= 1
      case @effect_type
      when WHITEN
        update_whiten
      when BLINK
        update_blink
      when APPEAR
        update_appear
      when DISAPPEAR
        update_disappear
      when COLLAPSE
        update_collapse
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 白フラッシュエフェクトの更新
  #--------------------------------------------------------------------------
  def update_whiten
    self.blend_type = 0
    self.color.set(255, 255, 255, 128)
    self.opacity = 255
    self.color.alpha = 128 - (16 - @effect_duration) * 10
  end
  #--------------------------------------------------------------------------
  # ● 点滅エフェクトの更新
  #--------------------------------------------------------------------------
  def update_blink
    self.blend_type = 0
    self.color.set(0, 0, 0, 0)
    self.opacity = 255
    self.visible = (@effect_duration % 10 < 5)
  end
  #--------------------------------------------------------------------------
  # ● 出現エフェクトの更新
  #--------------------------------------------------------------------------
  def update_appear
    self.blend_type = 0
    self.color.set(0, 0, 0, 0)
    self.opacity = (16 - @effect_duration) * 16
  end
  #--------------------------------------------------------------------------
  # ● 消滅エフェクトの更新
  #--------------------------------------------------------------------------
  def update_disappear
    self.blend_type = 0
    self.color.set(0, 0, 0, 0)
    self.opacity = 256 - (32 - @effect_duration) * 10
  end
  #--------------------------------------------------------------------------
  # ● 崩壊エフェクトの更新
  #--------------------------------------------------------------------------
  def update_collapse
    self.blend_type = 1
    self.color.set(255, 128, 128, 128)
    self.opacity = 256 - (48 - @effect_duration) * 6
  end
end
