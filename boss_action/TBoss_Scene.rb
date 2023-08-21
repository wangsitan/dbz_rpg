#==============================================================================
# ■ TBoss_Scene
#------------------------------------------------------------------------------
# 　ボスアクションのシーンクラス
#==============================================================================
class TBoss_Scene < Scene_Base
  SHOOT_TIME = 400#600
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader :back_ground
  attr_reader :player
  attr_reader :enemy
  attr_accessor :state
  attr_accessor :se_flag
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(boss)
    @boss = boss
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    $game_temp.map_bgm = RPG::BGM.last
    $game_temp.map_bgs = RPG::BGS.last
    RPG::BGM.stop
    RPG::BGS.stop
    Audio.bgm_play($game_temp.tboss_bgm, 100, 100)
    @state = 0    # シーンの状態
    @back_ground = TBoss_Ground.new
    @player = TBoss_Player.new(64, 200)
    @enemy = []
    add_enemy(@boss, 640-64, 200)
    @pbullet = []
    @ebullet = []
    @effect = []
    @se_flag = []
    for i in 0...16 do @se_flag[i] = false end
    @cnt = 0
    @main_win = Window_Base.new(200,400,640-400,80)
    @main_win.opacity=255
    @main_win.back_opacity=255
    @start_frame = Graphics.frame_count
    @draw_icon = 1
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    $game_temp.map_bgm.play
    $game_temp.map_bgs.play
    $game_switches[TBOSS::RESULT_CLEAR_ID] = (@state == 1)
    @player.dispose
    for i in 0...@enemy.size
      @enemy[i].dispose if @enemy[i] != nil
    end
    #clear_bullet
    @back_ground.dispose
    for i in 0...@effect.size
      @effect[i].dispose if @effect[i] != nil
    end
    @main_win.dispose
    @main_win = nil

  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    @cnt += 1
    if TBOSS::GC_COUNT > 0
      GC.start if @cnt % TBOSS::GC_COUNT == 0
    end
    @back_ground.update
    for i in 0...@effect.size
      next if @effect[i] == nil
      @effect[i].update
      @effect[i] = nil if @effect[i].disposed?
    end
    case @state
    when 0
      update_game
      
      if $shoot_end == false
        update_situation
      end
    
      if $shoot_enemy_x >= 700
        @state = 1
      end
    when 1
      update_result
    when 2
      update_gameover
    end
    for i in 0...16
      if @se_flag[i]
        Audio.se_play("Audio/SE/"+TBOSS::SE_NAME[i][0], TBOSS::SE_NAME[i][1],
          TBOSS::SE_NAME[i][2])
        @se_flag[i] = false
        break
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ゲームのフレーム更新
  #--------------------------------------------------------------------------
  def update_situation
    @main_win.contents.clear
    if $shoot_damege_count.to_s.size == 1
      damege = " " + $shoot_damege_count.to_s
    else
      damege = $shoot_damege_count.to_s
    end
    
    @main_win.contents.draw_text(0, 25, 200, 20,"ダメージ:" + damege,1 )
    @main_win.contents.draw_text(0, 0, 208, 16,"Ｓ",2 )
    @main_win.contents.draw_text(0, 0, 200, 16,"Ｇ" )
    picture = Cache.picture("アイコン")
    rect = Rect.new(16*6, 0, 16, 16) # アイコン
    for x in 0..(Graphics.frame_count - @start_frame)/SHOOT_TIME 
      
      if x != (Graphics.frame_count - @start_frame)/SHOOT_TIME && x <= 10
        @main_win.contents.blt(200-x*16-32,2,picture,rect)
      else

        if Graphics.frame_count % 30 == 0
          @draw_icon = -@draw_icon 
        end

        if @draw_icon == -1 && x <= 9
          @main_win.contents.blt(200-x*16-32,2,picture,rect)
        end
        
      end
    end
    
    if (Graphics.frame_count - @start_frame)/SHOOT_TIME == 10
      $shoot_end = true
      clear_bullet
    end
  end
  #--------------------------------------------------------------------------
  # ● ゲームのフレーム更新
  #--------------------------------------------------------------------------
  def update_game
    @player.update
    for i in 0...@enemy.size
      next if @enemy[i] == nil
      @enemy[i].update
      @enemy[i] = nil if @enemy[i].disposed?
    end
    for i in 0...@pbullet.size
      next if @pbullet[i] == nil
      @pbullet[i].update
      @pbullet[i] = nil if @pbullet[i].disposed?
    end
    for i in 0...@ebullet.size
      next if @ebullet[i] == nil
      @ebullet[i].update
      @ebullet[i] = nil if @ebullet[i].disposed?
    end
    #change_state(2) if Input.trigger?(Input::Z)
    
    if (Graphics.frame_count - @start_frame)/SHOOT_TIME == 5 && $shoot_enemy_state < 1 
      $shoot_enemy_state += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● リザルトのフレーム更新
  #--------------------------------------------------------------------------
  def update_result
    $game_variables[53] = $shoot_damege_count
    $game_variables[41] = 336
    $scene = Scene_Map.new #if Input.trigger?(Input::C)
  end
  #--------------------------------------------------------------------------
  # ● ゲームオーバーのフレーム更新
  #--------------------------------------------------------------------------
  def update_gameover
    if @cnt >= 60
      $scene = Scene_Map.new if Input.trigger?(Input::C)
    end
  end
  #--------------------------------------------------------------------------
  # ● シーンステートの変更
  #--------------------------------------------------------------------------
  def change_state(state)
    if state == 1
      Audio.me_play("Audio/ME/Victory1.mid", 100, 100)
      @player.set_visible(true)   # 自機を強制的に表示状態にする
    else
      Audio.me_play("Audio/ME/Shock.mid", 100, 100)
    end
    @state = state
    @cnt = 0
  end
  #--------------------------------------------------------------------------
  # ● 自機弾の追加処理
  #--------------------------------------------------------------------------
  def add_pbullet(type, x, y, dir)
    i = @pbullet.index(nil)
    i = @pbullet.size if i == nil
    return if i >= 3    # 同時に撃てる弾は３つまで
    @se_flag[type + 4] = true
    @pbullet[i] = TBoss_PBullet.new(type, x, y, dir)
  end
  #--------------------------------------------------------------------------
  # ● 敵機弾の追加処理
  #--------------------------------------------------------------------------
  def add_ebullet(x, y, vx, vy, type, index,tuibi = 0)
    i = @ebullet.index(nil)
    i = @ebullet.size if i == nil
    @ebullet[i] = TBoss_EBullet.new(x, y, vx, vy, type, index,tuibi)
  end
  #--------------------------------------------------------------------------
  # ● 弾の全削除
  #--------------------------------------------------------------------------
  def clear_bullet
    for i in 0...@pbullet.size
      @pbullet[i].dispose if @pbullet[i] != nil
      @pbullet[i] = nil
    end
    for i in 0...@ebullet.size
      @ebullet[i].dispose if @ebullet[i] != nil
      @ebullet[i] = nil
    end
  end
  #--------------------------------------------------------------------------
  # ● エフェクトの追加処理
  #--------------------------------------------------------------------------
  def add_effect(type, x, y, vx, vy)
    i = @effect.index(nil)
    i = @effect.size if i == nil
    if type == 1
      @effect[i] = TBoss_Effect1.new(x, y, vx, vy)
    elsif type == 2
      @effect[i] = TBoss_Effect2.new(x, y, vx, vy)
    end
  end
  #--------------------------------------------------------------------------
  # ● エネミーの追加処理
  #--------------------------------------------------------------------------
  def add_enemy(type, x, y)
    i = @enemy.index(nil)
    i = @enemy.size if i == nil
    if type == 1
      @enemy[i] = TBoss_Enemy1.new(x, y)
    elsif type == 2
      @enemy[i] = TBoss_Enemy2.new(x, y)
    elsif type == 3
      @enemy[i] = TBoss_Enemy3.new(x, y)
    elsif type == 4
      @enemy[i] = TBoss_Enemy4.new(x, y)
    elsif type == 5
      @enemy[i] = TBoss_Enemy5.new(x, y)
    elsif type == 6
      @enemy[i] = TBoss_Enemy6.new(x, y)
    elsif type == 7
      @enemy[i] = TBoss_Enemy7.new(x, y)
    elsif type == 8
      @enemy[i] = TBoss_Enemy8.new(x, y)
    end
  end
end


