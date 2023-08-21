#==============================================================================
# ■ Scene_Db_enemy_history
#------------------------------------------------------------------------------
# 　能力表示画面
#==============================================================================
class Scene_Db_enemy_history < Scene_Base
  include Share
  #Party_win_sizex = 274         #パーティーウインドウサイズX
  Party_win_sizex = 300         #パーティーウインドウサイズX
  Party_win_sizey = 480-56         #パーティーウインドウサイズY
  Status_win_sizex = 640-300    #詳細ステータスウインドウサイズX
  Status_win_sizey = 480-56        #詳細ステータスウインドウサイズY
  Technique_win_sizex = 274     #必殺技ウインドウサイズX
  Technique_win_sizey = 480-272 #必殺技ウインドウサイズY
  Partyy = 24                   #パーティー表示行空き数
  Partynox = 0                  #パーティー表示基準X
  Partynoy = 2                 #パーティー表示基準Y
  Status_lbx = 16               #詳細ステータス表示基準X
  Status_lby = 0                #詳細ステータス表示基準Y
  Techniquex = 0                #必殺技表示基準X
  Techniquey = 0                #必殺技表示基準Y
  Scombo_makix = 0              #まきもの位置X
  Scombo_makiy = 0              #まきもの位置Y
  Scombo_makitochaaki_x = 32     #まきものからどのくらい離すか
  Scombo_makitochaaki_y = 58    #まきものからどのくらい離すか
  Scombo_chayy = 134             #Sコンボパーティー表示行空き数
  Scombo_chatocardaki_x = 96    #Sコンボでキャラとカードの秋
  Scombo_chatotecakiy = 102      #対象必殺技表示
  Scombo_chatotecakix = 80       #対象必殺技表示
  Put_ene_num = 15                #一覧表示数
  Explanation_win_sizex = 640       #カード説明ウインドウサイズX
  Explanation_win_sizey = 56       #カード説明ウインドウサイズY
  #Techniquenamex = 184          #必殺技画像取得サイズX
  #Techniquenamey = 24           #必殺技画像取得サイズY
  
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     call_state : どのプログラムから呼ばれたか 1:戦闘 2:マップ 3:カード 4:修行
  #--------------------------------------------------------------------------
  def initialize(call_state = 2)
    @call_state = call_state
    if @call_state == 2
      set_bgm
    end
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    @window_state = 0         #ウインドウ状態(並び替え時のみ使用) 0:未選択 1:キャラ選択
    @cursor_scombo_select = 0      #Sコンボの選択キャラ
    @cursorstate = 0             #カーソル位置
    @run_card_result = false      #カード使用結果
    @scombo_cha_num = 0    #スパーキングコンボ技数
    @scombo_cha_no = []    #技の番号
    @option_line_height 
    create_window
    #pre_update
    @up_cursor = Sprite.new
    @down_cursor = Sprite.new
    set_up_down_cursor
    
    #create_menu_background
    #シナリオ進行度によってファイル名の頭文字を変える
    chk_scenario_progress
    #pre_update
    @display_skill_level = -1
    @window_update_flag = true
    @option_line_height = 24          #改行の高さ

    @tmp_ene_order_layer = []         #回数重ね用
    @put_strat = 1 #出力開始No
    @old_put_strat = 0 #ひとつ前の出力開始No
    update_eneput_flag #敵の表示状態を更新
    get_ene_history_list
    output_option_message
    Graphics.fadein(5)
    #set_bgm
  end


  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_sprite
    dispose_window
    $game_variables[41] = 41
    #$scene = Scene_Map.new
    #$game_player.reserve_transfer($game_variables[13], $game_variables[1], $game_variables[2], 0) # 場所移動    
  end
  #--------------------------------------------------------------------------
  # ● スプライト開放
  #--------------------------------------------------------------------------
  def dispose_sprite
    @up_cursor.bitmap = nil
    @down_cursor.bitmap = nil
    @up_cursor = nil
    @down_cursor = nil
  end
  #--------------------------------------------------------------------------
  # ● 画面更新
  #--------------------------------------------------------------------------
  def pre_update
    #super
    
    @party_window.contents.fill_rect(0,0,16,12800,@party_window.get_back_window_color)
    
    if @window_update_flag == true
      
      if @put_strat != @old_put_strat
        #window_contents_clear
        @party_window.contents.clear
        output_party
      end
      @status_window.contents.clear
      #@explanation_window.contents.clear
      output_status
      #output_option_message
      @status_window.update
      #output_cursor
      @party_window.update
      @window_update_flag = false
    end
    output_cursor
    
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------   
  def update
    super
    
    #chk_up = false #更新チェック
    
    #Graphics.update
    #Input.update
    if Input.trigger?(Input::C)
      @window_update_flag = true
    end
    if Input.trigger?(Input::B)
      @window_update_flag = true
      if @call_state == 1 #戦闘
        if @window_state == 0
          $chadeadchk = Marshal.load(Marshal.dump($chadead))
          Graphics.fadeout(5)
          $scene = Scene_Db_Battle.new ($battle_escape,$battle_bgm,$battle_ready_bgm)
        elsif @window_state == 1
          @window_state = 0
        end
      else
        if @window_state == 0
          Graphics.fadeout(5)
          #Audio.bgm_play("Audio/BGM/" + $map_bgm)    # 効果音を再生する
          $scene = Scene_Map.new
        elsif @window_state == 1
          @window_state = 0
          #Audio.bgm_play("Audio/BGM/" + $map_bgm)    # 効果音を再生する
          #@cursorstate = @cursor_chara_select
        end
      end
    end

    if Input.trigger?(Input::X)
      #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      #@display_skill_level = -@display_skill_level
    end
    
    if Input.trigger?(Input::DOWN)
      Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      #chk_up = true
      move_cursor 2 #カーソル移動

    end
    if Input.trigger?(Input::UP)
      Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      #chk_up = true
      move_cursor 8 #カーソル移動
    end
    if Input.trigger?(Input::RIGHT)
      Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      #Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      #cursor_right(Input.trigger?(Input::RIGHT))
      move_cursor 6 #カーソル移動
    end
    if Input.trigger?(Input::LEFT)
      Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      #Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      #cursor_left(Input.trigger?(Input::LEFT))
      move_cursor 4 #カーソル移動
    end
    @window_update_flag = true if Input.dir8 != 0 #何かカーソルを押したら画面を更新フラグをON
    #if chk_up == true #カーソル動かした時のみ画面更新
    pre_update
    #end
    
    
  end
  
  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_window
    @party_window.dispose
    @party_window = nil
    @status_window.dispose
    @status_window = nil
    #@technique_window.dispose
    #@technique_window = nil
    @explanation_window.dispose
    @explanation_window = nil
  end 
  
  #--------------------------------------------------------------------------
  # ● ウインドウ内容クリア
  #--------------------------------------------------------------------------    
  def window_contents_clear
    @party_window.contents.clear
    @status_window.contents.clear
    #@technique_window.contents.clear
    @explanation_window.contents.clear
  end
  
  #--------------------------------------------------------------------------
  # ● ウインドウ作成
  #--------------------------------------------------------------------------   
  def create_window
    Graphics.fadeout(0)
    #@party_window = Window_Base.new(Status_win_sizex,0,Party_win_sizex,Party_win_sizey)
    @party_window = Window_Base.new(0,Explanation_win_sizey,Party_win_sizex,Party_win_sizey)
    @party_window.opacity=255
    @party_window.back_opacity=255
    @party_window.contents.font.color.set( 0, 0, 0)
    #@party_window.contents.font.shadow = false
    #@party_window.contents.font.bold = true
    #@party_window.contents.font.name = ["ＭＳ ゴシック"]
    #@party_window.contents.font.size = 17
    @status_window = Window_Base.new(Party_win_sizex,Explanation_win_sizey,Status_win_sizex,Status_win_sizey)
    @status_window.opacity=255
    @status_window.back_opacity=255
    @status_window.contents.font.color.set( 0, 0, 0)
    #@status_window.contents.font.shadow = false
    #@status_window.contents.font.bold = true
    #@status_window.contents.font.name = ["ＭＳ ゴシック"]
    #@status_window.contents.font.size = 17
    #@technique_window = Window_Base.new(0,Party_win_sizey,Technique_win_sizex,Technique_win_sizey)
    #@technique_window.opacity=255
    #@technique_window.back_opacity=255
    @explanation_window = Window_Base.new(0,0,Explanation_win_sizex,Explanation_win_sizey)
    @explanation_window.opacity=255
    @explanation_window.back_opacity=255
    @explanation_window.contents.font.color.set( 0, 0, 0)
    Graphics.fadein(10)
  end
 
  #--------------------------------------------------------------------------
  # ● カーソル表示
  #--------------------------------------------------------------------------  
  def output_cursor
    $cursor_blink_count += 1
    picture = Cache.picture("アイコン")
    rect = set_yoko_cursor_blink
    @party_window.contents.blt(Partynox,Partynoy+(@cursorstate-(@put_strat-1))*Partyy,picture,rect)

    #上側カーソル
    if $ene_order_count > (@put_strat + Put_ene_num)
      @down_cursor.visible = true
    else
      @down_cursor.visible = false
    end
    
    if @put_strat != 1
      @up_cursor.visible = true
    else
      @up_cursor.visible = false
    end
  end

  #--------------------------------------------------------------------------
  # ● 必殺技表示
  # 　 カーソル上キャラのスキル一覧を取得する。(表示の詳細は"_detail")
  #-------------------------------------------------------------------------- 
  def output_technique  

    #@cursorstate
    @scombo_cha_num = 0
    @scombo_cha_no = []
    for x in 0..$scombo_count
      if $scombo_chk_flag[x] != 0
        if $scombo_chk_flag[x] == 1 #スイッチ
          next if $game_switches[$scombo_chk_flag_no[x]] == false
          #p $scombo_chk_flag_no[x],$game_switches[$scombo_chk_flag_no[x]]
        elsif $scombo_chk_flag[x] == 2 #変数
          #チェック方法 0:一致 1:以上 2:以下
          case $scombo_chk_flag_process[x]
          when 0
            next if $game_variables[$scombo_chk_flag_no[x]] != $scombo_chk_flag_value[x]
          when 1
            next if $game_variables[$scombo_chk_flag_no[x]] < $scombo_chk_flag_value[x]
          when 2
            next if $game_variables[$scombo_chk_flag_no[x]] > $scombo_chk_flag_value[x]
          end
        end
      end
      if $scombo_cha[x].index($partyc[@cursorstate]) != nil
        @scombo_cha_no[@scombo_cha_num] = x
        @scombo_cha_num += 1 
        picture = Cache.picture("文字_必殺技")
        if $game_switches[$scombo_get_flag[x]] == true
          rect = output_technique_detail $scombo_no[x]
        else
          #falseの場合は0を指定して0を取得する
          rect = output_technique_detail 0
        end
        @technique_window.contents.blt(Techniquex+16,Techniquey+Techniquenamey * (@scombo_cha_num - 1),picture,rect)
      end
    end
    
  end
  
  #--------------------------------------------------------------------------
  # ● 能力詳細表示
  #--------------------------------------------------------------------------   
  def output_status
    
    null_mozi = "？？？？？？？？"
    color = Color.new(0,0,0,260)
    
    #名前
    if $ene_enc_history_flag[$tmp_ene_order[@cursorstate]] == true
      tmp_ene_name = $data_enemies[$tmp_ene_order[@cursorstate]].name
    else
      tmp_ene_name = null_mozi
    end
    @status_window.contents.draw_text(Scombo_makix,Partynoy-2, 640, @option_line_height, tmp_ene_name)
    
    face_file_name = ""
    mainasu = 0
    
    ene_file_top_name = set_ene_str_no $tmp_ene_order[@cursorstate]
    
    if ene_file_top_name == "Z1_"
      
    elsif ene_file_top_name == "Z2_"
      mainasu = $ene_str_no[1] - 1
    elsif ene_file_top_name == "Z3_"
      mainasu = $ene_str_no[2] - 1
    end
    #顔
    picture = Cache.picture(ene_file_top_name + "顔敵") #敵キャラ
    rect = Rect.new(0, ($tmp_ene_order[@cursorstate] - mainasu)*64, 64, 64) # 顔敵
    @status_window.contents.fill_rect(Scombo_makix,Partynoy-2+@option_line_height*1,64,64,color)
    @status_window.contents.blt(Scombo_makix,Partynoy-2+@option_line_height*1,picture,rect) if $ene_enc_history_flag[$tmp_ene_order[@cursorstate]] == true
    #流派
    picture = Cache.picture("カード関係")
    rect = set_card_frame 4 # 流派枠
    @status_window.contents.blt(Scombo_makix,Partynoy-2+@option_line_height*1+64,picture,rect)
    if $ene_enc_history_flag[$tmp_ene_order[@cursorstate]] == true
      rect = Rect.new(32*($data_enemies[$tmp_ene_order[@cursorstate]].hit-1), 64, 32, 32) # 流派
    else
      rect = Rect.new(320, 0, 32, 32) # 流派
    end
    @status_window.contents.blt(Scombo_makix+16,Partynoy-2+@option_line_height*1+64,picture,rect)
      
    #枠
    if $data_enemies[$tmp_ene_order[@cursorstate]].element_ranks[23] != 1
      @status_window.contents.fill_rect(Scombo_makix + 80,Partynoy-2+@option_line_height*1,96,96,color)
    else
      @status_window.contents.fill_rect(Scombo_makix + 80,Partynoy-2+@option_line_height*1,96*2,96,color)
    end
    #戦闘キャラ
    picture = Cache.picture(ene_file_top_name + "戦闘_敵_" + $data_enemies[$tmp_ene_order[@cursorstate]].name) #敵キャラ
    if $data_enemies[$tmp_ene_order[@cursorstate]].element_ranks[23] != 1
      rect = Rect.new(0,0*96, 96, 96) # 敵戦闘キャラ
    else
      rect = Rect.new(0,0*96, 96*2, 96) # 敵戦闘キャラ
    end
    #@status_window.contents.blt(Scombo_makix + 80+12,Partynoy-2+@option_line_height*1+12,picture,rect)
    #@status_window.contents.blt(Scombo_makix + 80-4,Partynoy-2+@option_line_height*1-4,picture,rect) if $ene_enc_history_flag[$tmp_ene_order[@cursorstate]] == true
    @status_window.contents.blt(Scombo_makix + 80-2,Partynoy-2+@option_line_height*1-2,picture,rect) if $ene_enc_history_flag[$tmp_ene_order[@cursorstate]] == true
    
    hpikou_kizyun = 128
    put_line = 0
    #HP
    put_mozi = null_mozi
    put_mozi =$data_enemies[$tmp_ene_order[@cursorstate]].maxhp.to_s if $ene_sco_history_flag[$tmp_ene_order[@cursorstate]] == true
    @status_window.contents.draw_text(Scombo_makix,Partynoy-2+@option_line_height*put_line+hpikou_kizyun, 640, @option_line_height, "ＨＰ　　　　：" + put_mozi.to_s)
    put_line += 1
=begin
    #攻撃力
    put_mozi = null_mozi
    put_mozi = $data_enemies[$tmp_ene_order[@cursorstate]].atk.to_s if $ene_sco_history_flag[$tmp_ene_order[@cursorstate]] == true
    @status_window.contents.draw_text(Scombo_makix,Partynoy-2+@option_line_height*put_line+hpikou_kizyun, 640, @option_line_height, "攻撃力　　　：" + put_mozi.to_s)
    put_line += 1
    #防御力
    put_mozi = null_mozi
    put_mozi = $data_enemies[$tmp_ene_order[@cursorstate]].def.to_s if $ene_sco_history_flag[$tmp_ene_order[@cursorstate]] == true
    @status_window.contents.draw_text(Scombo_makix,Partynoy-2+@option_line_height*put_line+hpikou_kizyun, 640, @option_line_height, "防御力　　　：" + put_mozi.to_s)
    put_line += 1
    #スピード
    put_mozi = null_mozi
    put_mozi = $data_enemies[$tmp_ene_order[@cursorstate]].agi.to_s if $ene_sco_history_flag[$tmp_ene_order[@cursorstate]] == true
    @status_window.contents.draw_text(Scombo_makix,Partynoy-2+@option_line_height*put_line+hpikou_kizyun, 640, @option_line_height, "スピード　　：" + put_mozi.to_s)
    put_line += 1
=end
    #攻撃回数
    #put_mozi = null_mozi
    #put_mozi = $data_enemies[$tmp_ene_order[@cursorstate]].eva.to_s if $ene_sco_history_flag[$tmp_ene_order[@cursorstate]] == true
    #@status_window.contents.draw_text(Scombo_makix,Partynoy-2+@option_line_height*put_line+hpikou_kizyun, 640, @option_line_height, "攻撃回数　　：" + put_mozi.to_s)
    #put_line += 1
    #カード1
    put_mozi = null_mozi
    if $data_enemies[$tmp_ene_order[@cursorstate]].drop_item1.kind != 0
      put_mozi = $data_items[$data_enemies[$tmp_ene_order[@cursorstate]].drop_item1.item_id].name if $ene_crd_history_flag[$tmp_ene_order[@cursorstate]] == 1 || $ene_crd_history_flag[$tmp_ene_order[@cursorstate]] == 3 || $ene_sco_history_flag[$tmp_ene_order[@cursorstate]] == true
    else
      put_mozi = "なし"
    end
    @status_window.contents.draw_text(Scombo_makix,Partynoy-2+@option_line_height*put_line+hpikou_kizyun, 640, @option_line_height, "獲得カード　：" + put_mozi.to_s)
    put_line += 1
    #カード2
    put_mozi = null_mozi
    if $data_enemies[$tmp_ene_order[@cursorstate]].drop_item2.kind != 0
      put_mozi = $data_items[$data_enemies[$tmp_ene_order[@cursorstate]].drop_item2.item_id].name if $ene_crd_history_flag[$tmp_ene_order[@cursorstate]] == 2 || $ene_crd_history_flag[$tmp_ene_order[@cursorstate]] == 3 || $ene_sco_history_flag[$tmp_ene_order[@cursorstate]] == true
    else
      put_mozi = "なし"
    end
    @status_window.contents.draw_text(Scombo_makix,Partynoy-2+@option_line_height*put_line+hpikou_kizyun, 640, @option_line_height, "　　　　　　　" + put_mozi.to_s)
    put_line += 1
    #経験値
    put_mozi = null_mozi
    put_mozi = $data_enemies[$tmp_ene_order[@cursorstate]].exp.to_s if $ene_enc_history_flag[$tmp_ene_order[@cursorstate]] == true
    @status_window.contents.draw_text(Scombo_makix,Partynoy-2+@option_line_height*put_line+hpikou_kizyun, 640, @option_line_height, "経験値　　　：" + put_mozi.to_s)
    put_line += 1
    #CAP
    put_mozi = null_mozi
    put_mozi = $data_enemies[$tmp_ene_order[@cursorstate]].gold.to_s if $ene_enc_history_flag[$tmp_ene_order[@cursorstate]] == true
    @status_window.contents.draw_text(Scombo_makix,Partynoy-2+@option_line_height*put_line+hpikou_kizyun, 640, @option_line_height, "ＣＡＰ　　　：" + put_mozi.to_s)
    put_line += 1
    #SP
    put_mozi = null_mozi
    put_mozi = $data_enemies[$tmp_ene_order[@cursorstate]].maxmp.to_s if $ene_enc_history_flag[$tmp_ene_order[@cursorstate]] == true
    @status_window.contents.draw_text(Scombo_makix,Partynoy-2+@option_line_height*put_line+hpikou_kizyun, 640, @option_line_height, "ＳＰ　　　　：" + put_mozi.to_s)
    put_line += 1
    #撃破数
    put_mozi = null_mozi
    put_mozi = $ene_defeat_num[$tmp_ene_order[@cursorstate]].to_s if $ene_enc_history_flag[$tmp_ene_order[@cursorstate]] == true
    @status_window.contents.draw_text(Scombo_makix,Partynoy-2+@option_line_height*put_line+hpikou_kizyun, 640, @option_line_height, "撃破数　　　：" + put_mozi.to_s)
    put_line += 1    
    #合計経験値
    #p $data_enemies[$tmp_ene_order[@cursorstate]].exp , $ene_defeat_num[$tmp_ene_order[@cursorstate]]
    #put_mozi = null_mozi
    #put_mozi = ($data_enemies[$tmp_ene_order[@cursorstate]].exp * $ene_defeat_num[$tmp_ene_order[@cursorstate]]).to_s if $ene_enc_history_flag[$tmp_ene_order[@cursorstate]] == true
    #@status_window.contents.draw_text(Scombo_makix,Partynoy-2+@option_line_height*put_line+hpikou_kizyun, 640, @option_line_height, "経験値合計　：" + put_mozi.to_s)
    #put_line += 1

    #カットイン
    
    #$tmp_ene_order[@cursorstate]
    if ene_file_top_name != "Z1_"
      if ene_file_top_name == "Z2_"
        mainasu = $ene_str_no[1]
        tyousei = 0
        xtyousei = -170
      else
        mainasu = $ene_str_no[2]
        tyousei = 0
        xtyousei = -160
      end
      picture = Cache.picture(ene_file_top_name + "敵カットイン") #敵キャラ
      rect = Rect.new(0, 64*($tmp_ene_order[@cursorstate]-mainasu)+tyousei, 640, 64-tyousei) # 背景上
      @status_window.contents.blt(xtyousei,Partynoy-2+@option_line_height*put_line+hpikou_kizyun,picture,rect) if $ene_enc_history_flag[$tmp_ene_order[@cursorstate]] == true
      put_line += 1
    end
  end

  #--------------------------------------------------------------------------
  # ● パーティー一覧表示
  #-------------------------------------------------------------------------- 
  def output_party
    put_end = @put_strat + Put_ene_num - 1
    put_line = 0
    tmp_ene_name = ""
    #p tmp_ene_order_layer
    for z in (@put_strat - 1)..put_end
      #if $tmp_ene_order[z] != nil && $data_enemies[$tmp_ene_order[z]].name != ""
      
      #遭遇したか
      if $ene_enc_history_flag[$tmp_ene_order[z]] == true
        tmp_ene_name = $data_enemies[$tmp_ene_order[z]].name
      else
        tmp_ene_name = "？？？？？？？？"
      end
      @party_window.contents.draw_text(Partynox+16+39-((z + 1).to_s.length*10),Partynoy+@option_line_height.to_i*put_line-2, 640, @option_line_height, (z + 1).to_s + "：" + tmp_ene_name)
      put_line += 1
      #end
    end
    #-tmp_get_max_val[z].to_s.length*13
    
    #picturea = Cache.picture("名前")
    #pictureb = Cache.picture("数字英語")
    #picturec = Cache.picture("アイコン")
    #rect = Rect.new(128, 16, 32, 16) #No
    #@party_window.contents.blt(Partynox+16 ,Partynoy-32,pictureb,rect)
    
    #for x in 0..$partyc.size-1
         
    #  rect = Rect.new((x+1)*16, 0, 16, 16) #No
    #  @party_window.contents.blt(Partynox+16,Partynoy+x*Partyy,pictureb,rect)

    #  rect = Rect.new(0, 0+(($partyc[x]-3)*16), 160, 16) # 名前
    #  @party_window.contents.blt(Partynox+32,Partynoy+x*Partyy,picturea,rect)
      
    #end

  end

  #--------------------------------------------------------------------------
  # ● カーソル移動
  #引数:n (下:2 上:8 右:6 左:4)
  #--------------------------------------------------------------------------
  def move_cursor n
    #ひとつ前のカーソルスタート状態を格納
    #画面更新処理をするかどうかの判断用
    @old_put_strat = @put_strat 
    
    case n
    
    when 2 #下
      
      if @window_state == 0
        @cursorstate +=1
        
        if @put_strat + Put_ene_num - 1 < @cursorstate
          @put_strat += 1
        end
        
        if @cursorstate >= $ene_order_count
          @cursorstate = 0
          @put_strat = 1
        end
      else
        @cursor_scombo_select += 1
        if @cursor_scombo_select >= @scombo_cha_num
          @cursor_scombo_select = 0
        end
      end

    when 8 #上
      
      if @window_state == 0
        @cursorstate -=1
        if @put_strat - 1 > @cursorstate
          @put_strat -= 1
        end
        if @cursorstate <= -1
          @cursorstate = $ene_order_count - 1
          @put_strat = $ene_order_count - Put_ene_num
        end
      else
        @cursor_scombo_select -= 1
        if @cursor_scombo_select <= -1
          @cursor_scombo_select = @scombo_cha_num -1
        end
      end

    when 6 #右
      @cursorstate += Put_ene_num + 1
      @put_strat += Put_ene_num + 1
      if @cursorstate >= $ene_order_count
        @cursorstate = $ene_order_count - 1
        @put_strat = $ene_order_count - Put_ene_num
      #elsif @put_strat + Put_ene_num + 1 >= $ene_order_count
      elsif @put_strat + Put_ene_num >= $ene_order_count
        @put_strat = $ene_order_count - Put_ene_num
      end 
      
    when 4 #左
      @cursorstate -= Put_ene_num  + 1
      @put_strat -= Put_ene_num + 1
      if @cursorstate <= 0
        @cursorstate = 0
        @put_strat = 1
      elsif @put_strat <= 0
        #@cursorstate = 0
        @put_strat = 1
      end
    end
    
  end
  #--------------------------------------------------------------------------
  # ● 上下カーソルの設定
  #-------------------------------------------------------------------------- 
  def set_up_down_cursor
   picture = Cache.picture("アイコン")
    
    #上カーソル
    # スプライトのビットマップに画像を設定
    @up_cursor.bitmap = Cache.picture("アイコン")
    @up_cursor.src_rect = Rect.new(16*5, 0, 16, 16)
    @up_cursor.x = 171-16
    @up_cursor.y = Explanation_win_sizey+16
    @up_cursor.z = 255
    @up_cursor.angle = 91
    @up_cursor.visible = false
    
    #下カーソル
    # スプライトのビットマップに画像を設定
    @down_cursor.bitmap = Cache.picture("アイコン")
    @down_cursor.src_rect = Rect.new(16*5, 0, 16, 16)
    @down_cursor.x = 171
    @down_cursor.y = 480-16
    @down_cursor.z = 255
    @down_cursor.angle = 269
    @down_cursor.visible = false
  end
  #--------------------------------------------------------------------------
  # ● オプションメッセージ
  #-------------------------------------------------------------------------- 
  def output_option_message
    option_msg = ""
    msg_height = 25
    option_msg = "敵の情報"
    @explanation_window.contents.draw_text(0,msg_height*0, 630, msg_height, option_msg)
  end
  #--------------------------------------------------------------------------
  # ● メニュー再生
  #--------------------------------------------------------------------------    
  def set_bgm
      #set_menu_bgm_name true
      #Audio.bgm_play("Audio/BGM/" + $option_menu_bgm_name)
    #if $put_battle_bgm == false
      set_battle_bgm_name true
      #p $option_battle_bgm_name
      #if $option_menu_bgm_name.include?("_user") == false
      #  Audio.bgm_play("Audio/BGM/" + $option_menu_bgm_name)    # 効果音を再生する
      #else
      #  Audio.bgm_play("Audio/MYBGM/" + $option_menu_bgm_name)    # 効果音を再生する
      #end
      if $option_battle_bgm_name.include?("_user") == false
        Audio.bgm_play("Audio/BGM/" + $option_battle_bgm_name)    # 効果音を再生する
      else
        Audio.bgm_play("Audio/MYBGM/" + $option_battle_bgm_name)    # 効果音を再生する
      end
      #$put_battle_bgm = true
    #end
  end
end