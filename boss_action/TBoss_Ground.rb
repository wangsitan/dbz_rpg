#==============================================================================
# ■ TBoss_Ground
#------------------------------------------------------------------------------
# 　シューティングの背景クラス
#==============================================================================
class TBoss_Ground < Sprite
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  SCROLL_SPEED = 6
  def initialize
    super(nil)
    self.bitmap = Cache.picture("Z2_シューティング背景")
    self.x = 0
    self.y = 480-60
    self.z = 25
    @flash = 0
    @shake_x = 0
    @angle_x = 0.0
    @color = Color.new(152,232,0,255)
    # スクロール用に背景をもう１枚作成
    @back_sub = Sprite.new
    @back_sub.bitmap = self.bitmap
    @back_sub.x = self.x - self.bitmap.width
    @back_sub.y = self.y
    @back_main = Sprite.new
    @back_main.bitmap = Bitmap.new(640,420)
    @back_main.bitmap.fill_rect (0,0,640,420,@color)
    #@back_main.color = @color
    #@back_main.x = 640
    #@back_main.y = 480
    #@back_main.width = 640
    #@back_main.height = 480
    # ピクチャの作成
    #@viewport2 = Viewport.new(16, 16, 320, 384)
    #@viewport2.z = 8900
    #@pictures = []
    #for i in 0..20
    #  @pictures.push(Game_Picture.new(i))
    #end
    #@picture_sprites = []
    #for i in 1..20
    #  @picture_sprites.push(Sprite_Picture.new(@viewport2, @pictures[i]))
    #end
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    @back_sub.dispose
    @back_main.dispose
    #for sprite in @picture_sprites
    #  sprite.dispose
    #end
    #@viewport1.dispose
    #@viewport2.dispose
    super
  end
  #--------------------------------------------------------------------------
  # ● ピクチャの表示
  #--------------------------------------------------------------------------
  def show_picture(number, name, origin, x, y, zoom_x, zoom_y, opacity, blend_type)
    @pictures[number].show(name, origin, x, y, zoom_x, zoom_y, opacity, blend_type)
  end
  #--------------------------------------------------------------------------
  # ● ピクチャの消去
  #--------------------------------------------------------------------------
  def erase_picture(number)
    @pictures[number].erase
  end
  #--------------------------------------------------------------------------
  # ● 揺らす
  #   dir    : trueなら横揺れ、falseなら縦揺れ
  #   power  : 揺れの強さ
  #--------------------------------------------------------------------------
  def shake(dir, power = 16)
    @shake_x = power
    @angle_x = 0.0
  end
  #--------------------------------------------------------------------------
  # ● フラッシュ
  #--------------------------------------------------------------------------
  def flash
    @flash = 255
  end
  #--------------------------------------------------------------------------
  # ● 更新
  #--------------------------------------------------------------------------
  def update
    #if @shake_x > 0
    #  @angle_x += 0.7
    #  @shake_x -= 1
    #  self.x = (Math.cos(@angle_x) * @shake_x).to_i - 16
    #end
    #if @flash > 0
    #  @flash -= 32
    #  #@back_main.color.set(255, 255, 255, @flash)
    #end
    self.x += SCROLL_SPEED
    self.x -= self.bitmap.width * 2 if self.x >= self.bitmap.width
    @back_sub.x += SCROLL_SPEED
    @back_sub.x -= self.bitmap.width * 2 if @back_sub.x >= self.bitmap.width
    #@back_sub.x = self.x
    #for picture in @pictures
    #  picture.update
    #end
    #for sprite in @picture_sprites
    #  sprite.update
    #end
  end
end

