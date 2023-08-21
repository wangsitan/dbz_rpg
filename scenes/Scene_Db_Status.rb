#==============================================================================
# ■ Scene_Db_Status
#------------------------------------------------------------------------------
# 　能力表示画面
#==============================================================================
class Scene_Db_Status < Scene_Base
  include Share
  Puttyouseix = -4
  Party_win_sizex = 384         #パーティーウインドウサイズX
  Party_win_sizey = 480         #パーティーウインドウサイズY
  Party_backwin_sizex = (364 + Puttyouseix + 2)         #パーティーウインドウサイズX
  Party_backwin_sizey = 480         #パーティーウインドウサイズY
  Status_win_sizex = 288        #詳細ステータスウインドウサイズX
  Status_win_sizey = 244        #詳細ステータスウインドウサイズY
  Status_backwin_sizex = 278        #詳細ステータスウインドウサイズX
  Status_backwin_sizey = 244        #詳細ステータスウインドウサイズY
  Technique_win_sizex = 288     #必殺技ウインドウサイズX
  Technique_win_sizey = 236     #必殺技ウインドウサイズY
  Technique_backwin_sizex = 278     #背景必殺技ウインドウサイズX
  Technique_backwin_sizey = 236     #背景必殺技ウインドウサイズY
  Skill_memo_win_sizex = Party_backwin_sizex + 16 #スキル説明ウインドウサイズX
  Skill_memo_win_sizey = 184 #104 #スキル説明ウインドウサイズX
  Skill_memo_backwin_sizex = Party_backwin_sizex #スキル説明ウインドウサイズX
  Skill_memo_backwin_sizey = 184 #104 #スキル説明ウインドウサイズX
  Skill_list_win_sizex = Party_backwin_sizex #スキル一覧ウインドウサイズX
  Skill_list_win_sizey = 480 - Skill_memo_win_sizey #スキル一覧ウインドウサイズY
  Partyy = 46                   #パーティー表示行空き数
  Partynox = 0                  #パーティー表示基準X
  Partynoy = 32                 #パーティー表示基準Y
  Status_lbx = 16               #詳細ステータス表示基準X
  Status_lby = 0                #詳細ステータス表示基準Y
  #Typ_skill_lby = 168           #固有スキル表示基準Y
  
  Typ_skill_lby = 168           #固有スキル表示基準Y
  Add_skill_lby = Typ_skill_lby + 118           #追加スキル表示基準Y
  Techniquex = 0                #必殺技表示基準X
  Techniquey = 0                #必殺技表示基準Y
  Add_typ_Skill_new_liney = 46  #追加スキルの表示行空き数
  Skill_new_liney = 32#46           #固有スキルの表示行空き数
  Skill_list_lbx = 16            #スキル一覧の表示基準X
  Skill_list_lby = 0            #スキル一覧の表示基準Y
  Skill_list_new_liney = 24      #スキル一覧の表示行空き数
  Skill_list_put_max = 9 #13       #スキル一覧の表示最大数
  #Techniquenamex = 184          #必殺技画像取得サイズX
  #Techniquenamey = 24           #必殺技画像取得サイズY
  
  Skill_levelup_bairitu = 1     #スキルアップに使用するCAP倍率
  Freeskill_set_card_no = 110       #フリーゲットスキルカードNo
  Freeskill_release_card_no = 79    #フリーリリーススキルカードNo
  Captozp_card_no = 203                  #CAPをZPに変換するカード
  Addskill_lvup_card_no = 9999         #ついかスキルレベルアップ
  
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     call_state : どのプログラムから呼ばれたか 1:戦闘 2:マップ 3:カード 4:修行 5:お気に入りキャラ 6:ZP使用
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

    #$game_actors[4].skill_saiyanoti1 = 0 if $game_actors[4].skill_saiyanoti1 == nil
    #$game_actors[4].skill_saiyanoti1 += 1
    #$game_actors[4].db_skills_get_flag = [] if $game_actors[4].db_skills_get_flag == nil
    #$game_actors[4].db_skills_get_flag[1] = true
    #p $game_actors[4].db_skills_get_flag[1]
    @window_state = 0         #ウインドウ状態(並び替え時のみ使用) 0:未選択 1:キャラ選択
    @cursor_chara_select = 0      #並び替え時の選択キャラ
    @@cursorstate = 0             #カーソル位置
    @@old_cursorstate = -1             #ひとつ前のカーソル位置
    #@cursor_skill_select = 0      #選択スキル
    @skill_cursorstate = 0        #スキルカーソル位置
    @skill_list_cursorstate = 0        #スキル一覧カーソル位置
    @skill_list_put_strat = 0     #スキルリスト出力スタート
    @skill_list_put_count = 0     #スキルリスト出力カウント
    @skill_list_put_ok_count = 0     #スキルリスト出力OKカウント(事前チェック用)
    @skill_list_put_skill_no = [] #スキル一覧で出力されてるスキルの番号
    @tecput_page = 0
    @tecput_max = 7
    @run_card_result = false      #カード使用結果
    @skill_set_result = 0         #スキルをセットするかどうか選択
    @display_skill_level = -1
    @display_skill_window = -1 #スキルを表示しているか 1でスキルを表示
    @tmp_down_cursor_disp = false #下のカーソル表示状態の一時格納用
    
    @setfreeskill_flag = false #フリースキルセット中
    
    @captozp_cap = 0 #CAPをZPに変換時に使用するCAP
    @captozp_zp = 0 #CAPをZPに変換時にしゅとくできるZP
    create_window
    #フリースキルカードか追加スキルレベルアップを使ってるときは、初期表示をスキルに
    
    
    #put_skillwin_card = [Freeskill_set_card_no,Freeskill_release_card_no,Addskill_lvup_card_no]
    #if Freeskill_set_card_no == $run_item_card_id || Freeskill_release_card_no == $run_item_card_id || Addskill_lvup_card_no == $run_item_card_id
    
    #
    
    #if $data_items[$run_item_card_id].element_ranks[31] == 1
    #初期表示ZPWIN
    if $run_item_card_id != 0
      if $data_items[$run_item_card_id].element_set.index(31)
        @display_skill_window = -@display_skill_window
        set_status_window_size
      end
    end
    
    #初期表示必殺技回数WIN
    if $run_item_card_id != 0
      if $data_items[$run_item_card_id].element_set.index(54)
        @display_skill_level = -@display_skill_level
        #set_status_window_size
      end
    end
    
    #pre_update
    Graphics.fadein(5)
    #create_menu_background
    #シナリオ進行度によってファイル名の頭文字を変える
    chk_scenario_progress
    get_output_skill_list #スキル一覧の生成
    #pre_update
    @window_update_flag = true
    @recovery_flag = false
    @up_cursor = Sprite.new
    @down_cursor = Sprite.new
    create_up_down_cursor
  end 
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_sprite
    dispose_window
    
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
  # ● 必殺技表示ページの設定
  #-------------------------------------------------------------------------- 
  def set_tecpage add
    
      if ($game_actors[$partyc[@@cursorstate]].skills.size-1) / @tecput_max > 0
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      end
      if add == 1
        if @down_cursor.visible == true
          @tecput_page += 1
          
        else
          @tecput_page = 0
        end
      else
        if @up_cursor.visible == true
          @tecput_page -= 1
        else
          @tecput_page = ($game_actors[$partyc[@@cursorstate]].skills.size-1) / @tecput_max
        end
      end

  end
  #--------------------------------------------------------------------------
  # ● 上下カーソルの設定
  #-------------------------------------------------------------------------- 
  def create_up_down_cursor
   picture = Cache.picture("アイコン")
    
    #上カーソル
    # スプライトのビットマップに画像を設定
    @up_cursor.bitmap = Cache.picture("アイコン")
    @up_cursor.src_rect = Rect.new(16*5, 0, 16, 16)
    #@up_cursor.x = Technique_win_sizex - Technique_win_sizex/2 - 8
    #@up_cursor.y = Status_win_sizey+16+32
    @up_cursor.z = 200
    @up_cursor.angle = 91
    @up_cursor.visible = false
    
    #下カーソル
    # スプライトのビットマップに画像を設定
    @down_cursor.bitmap = Cache.picture("アイコン")
    @down_cursor.src_rect = Rect.new(16*5, 0, 16, 16)
    #@down_cursor.x = Technique_win_sizex - Technique_win_sizex/2 + 8
    #@down_cursor.y = 480-16
    @down_cursor.z = 200
    @down_cursor.angle = 269
    @down_cursor.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 上下カーソルの設定
  #--------------------------------------------------------------------------
  def set_up_down_cursor
    if @window_state == 0 || @window_state == 1
      @up_cursor.x = Technique_win_sizex - Technique_win_sizex/2 - 8
      @up_cursor.y = Status_win_sizey+16+32
      @down_cursor.x = Technique_win_sizex - Technique_win_sizex/2 + 8
      @down_cursor.y = 480-16
    elsif @window_state == 3
      @up_cursor.x = Status_win_sizex + Skill_list_win_sizex - Skill_list_win_sizex/2 - 8
      @up_cursor.y = 0+16
      @down_cursor.x = Status_win_sizex + Skill_list_win_sizex - Skill_list_win_sizex/2 + 8
      @down_cursor.y = Skill_list_win_sizey-16
    end
  end
  #--------------------------------------------------------------------------
  # ● 画面更新
  #--------------------------------------------------------------------------
  def pre_update
    #super
    if @window_update_flag == true || @recovery_flag == true
      window_contents_clear
      output_party if @window_state != 3
      output_status #if @window_state != 3
      output_technique if @window_state == 0 || @window_state == 1
      @technique_window.update
      @status_window.update
      @party_window.update

      if @skill_list_window.visible == true
        output_skill_list
        @skill_list_window.update
      end
      
      if @skill_memo_window.visible == true
        output_skill_memo
        @skill_memo_window.update
      end
      if @result_window != nil
        output_result
        @result_window.update
      end
      
      if @skillup_result_window != nil
        output_skillup_result
        @skillup_result_window.update
      end
      
      if @freeset_result_window != nil
        output_freeset_result
        @freeset_result_window.update
      end

      if @release_result_window != nil
        output_release_result
        @release_result_window.update
      end
      
      if @addskill_lvup_result_window != nil
        output_addskill_lvup_result
        @addskill_lvup_result_window.update
      end
      
      if @captozp_result_window != nil
        output_captozp_result
        @captozp_result_window.update
      end
      
      if @cap_window != nil
        output_cap
        @cap_window.update
      end
      
      @window_update_flag = false
    end
    
    @@old_cursorstate = @@cursorstate
    output_cursor
  end
  #--------------------------------------------------------------------------
  # ● CAPのウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_cap_window
    @cap_window.dispose
    @cap_window = nil
  end
  #--------------------------------------------------------------------------
  # ● CAPのウインドウ作成
  #--------------------------------------------------------------------------  
  def create_cap_window
    keta = 8
    defketa = 4
    sizex = 16*2+16*(keta+defketa)
    @cap_window = Window_Base.new(640-sizex,0,sizex,60)
    @cap_window.opacity=255
    @cap_window.back_opacity=255
    @cap_window.contents.font.color.set( 0, 0, 0)
    output_cap
  end
  #--------------------------------------------------------------------------
  # ● CAP表示
  #-------------------------------------------------------------------------- 
  def output_cap
    #@result_window.contents.draw_text(0,0, 300, 40, "このカードを使用しますか？")
    mozi = "CAP：" + $game_variables[25].to_s
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @cap_window.contents.blt(0,0, $tec_mozi,rect)

  end
  #--------------------------------------------------------------------------
  # ● 使用する、しないのウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_result_window
    @result_window.dispose
    @result_window = nil
  end
  #--------------------------------------------------------------------------
  # ● 使用する、しないのウインドウ作成
  #--------------------------------------------------------------------------  
  def create_result_window
    @result_window = Window_Base.new(142,166,402,148)
    @result_window.opacity=255
    @result_window.back_opacity=255
    @result_window.contents.font.color.set( 0, 0, 0)
    output_result
  end
  #--------------------------------------------------------------------------
  # ● CAP使用はいいいえ表示
  #-------------------------------------------------------------------------- 
  def output_result
    temp_skillno = @skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]
    temp_syuutokuritu = 1-($cha_skill_spval[$partyc[@@cursorstate]][temp_skillno].to_f / $cha_skill_get_val[temp_skillno].to_f).to_f#).round
    temp_syuutokuritu = ($cha_skill_set_get_val[temp_skillno] * temp_syuutokuritu).round
    #p temp_syuutokuritu
    #.round
    #@result_window.contents.draw_text(0,0, 300, 40, "このカードを使用しますか？")
    mozikirikae = ""
    
    #セットしたことがある
    if $cha_skill_set_flag[$partyc[@@cursorstate]][temp_skillno] == 1
      mozi_settype = "しゅうとく"
    else
      mozi_settype = "セット"
    end
    
    mozi = "しょじCAP：" + $game_variables[25].to_s
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @result_window.contents.blt(4,2, $tec_mozi,rect)
    #mozi = "スキルを　しゅうとくするには　CAP：" + $cha_skill_set_get_val[@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]].to_s
    mozi = "スキルを　" + mozi_settype.to_s + "するには　CAP：" + temp_syuutokuritu.to_s
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @result_window.contents.blt(4,2+24, $tec_mozi,rect)
    mozi = "つかいます　" + mozi_settype.to_s + "しますか？"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @result_window.contents.blt(4,2+48, $tec_mozi,rect)
    mozi = "　はい　　　いいえ"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @result_window.contents.blt(4,34+48, $tec_mozi,rect)
    #@result_window.contents.draw_text(0,30, 200, 40, "　はい　　　いいえ")
  end
  
  #--------------------------------------------------------------------------
  # ● 追加スキルレベルアップする、しないのウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_addskill_lvup_result_window
    @addskill_lvup_result_window.dispose
    @addskill_lvup_result_window = nil
  end

  #--------------------------------------------------------------------------
  # ● 追加スキルレベルアップする、しないのウインドウ作成
  #--------------------------------------------------------------------------  
  def create_addskill_lvup_result_window
    @addskill_lvup_result_window = Window_Base.new(98,166,444,148)
    @addskill_lvup_result_window.opacity=255
    @addskill_lvup_result_window.back_opacity=255
    @addskill_lvup_result_window.contents.font.color.set( 0, 0, 0)
    output_addskill_lvup_result
  end
  #--------------------------------------------------------------------------
  # ● 追加スキルレベルアップはいいいえ表示
  #-------------------------------------------------------------------------- 
  def output_addskill_lvup_result
    mozi = "レベルアップスキル：" + $cha_skill_mozi_set[$cha_upgrade_skill_no[$cha_add_skill[$partyc[@@cursorstate]][@skill_cursorstate-3].to_i]].to_s
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @addskill_lvup_result_window.contents.blt(4,2, $tec_mozi,rect)
    mozi = "このスキルを　セットかのうにしますか？"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @addskill_lvup_result_window.contents.blt(4,2+24, $tec_mozi,rect)
    #mozi = "※リリースした　スキルは　もとに　もどせないぞ！"
    #output_mozi mozi
    #rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    #@addskill_lvup_result_window.contents.blt(4,2+48, $tec_mozi,rect)
    mozi = "　はい　　　いいえ"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @addskill_lvup_result_window.contents.blt(4,34+48, $tec_mozi,rect)

  end
#--------------------------------------------------------------------------
  # ● スキルリリースする、しないのウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_release_result_window
    @release_result_window.dispose
    @release_result_window = nil
  end

  #--------------------------------------------------------------------------
  # ● スキルリリースする、しないのウインドウ作成
  #--------------------------------------------------------------------------  
  def create_release_result_window
    @release_result_window = Window_Base.new(98,166,444,148)
    @release_result_window.opacity=255
    @release_result_window.back_opacity=255
    @release_result_window.contents.font.color.set( 0, 0, 0)
    output_release_result
  end
  #--------------------------------------------------------------------------
  # ● スキルリリースはいいいえ表示
  #-------------------------------------------------------------------------- 
  def output_release_result
    mozi = "リリーススキル：" + $cha_skill_mozi_set[$cha_typical_skill[$partyc[@@cursorstate]][@skill_cursorstate]].to_s
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @release_result_window.contents.blt(4,2, $tec_mozi,rect)
    mozi = "このスキルを　リリースしますか？"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @release_result_window.contents.blt(4,2+24, $tec_mozi,rect)
    mozi = "※リリースした　スキルは　もとに　もどせないぞ！"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @release_result_window.contents.blt(4,2+48, $tec_mozi,rect)
    mozi = "　はい　　　いいえ"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @release_result_window.contents.blt(4,34+48, $tec_mozi,rect)

  end
  
 #--------------------------------------------------------------------------
  # ● CAP変換量指定のウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_captozp_result_window
    @captozp_result_window.dispose
    @captozp_result_window = nil
  end

  #--------------------------------------------------------------------------
  # ● CAP変換量指定のウインドウ作成
  #--------------------------------------------------------------------------  
  def create_captozp_result_window
    @captozp_result_window = Window_Base.new(66,158,500,220)#Window_Base.new(86,154,468,196)#Window_Base.new(98,166,444,172)
    @captozp_result_window.opacity=255
    @captozp_result_window.back_opacity=255
    @captozp_result_window.contents.font.color.set( 0, 0, 0)
    @captozp_result_window.z = 255
    output_captozp_result
  end
  #--------------------------------------------------------------------------
  # ● CAP変換量指定のはいいいえ表示
  #-------------------------------------------------------------------------- 
  def output_captozp_result
    nonnum = ""
    rnum = ""
    lrnum = ""
    
    #倍率変更
    case $game_variables[471]
    
    when 0
      nonnum = "1"
      rnum = "10"
      lrnum = "100"
    when 1
      nonnum = "10"
      rnum = "100"
      lrnum = "1000"
    when 2
      nonnum = "100"
      rnum = "1000"
      lrnum = "1まん"
    when 3
      nonnum = "1000"
      rnum = "1まん"
      lrnum = "10まん"
    end
    mozi = "CAP：" + ($captozp_rate * nonnum.to_i).to_s + "につき　ZP：" + nonnum + "にへんかんできます"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @captozp_result_window.contents.blt(4,2, $tec_mozi,rect)
    mozi = "へんかんするCAPを　じょうげで　きめてください"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @captozp_result_window.contents.blt(4,2+1*24, $tec_mozi,rect)
    mozi = "※Rをおしながら　じょうげで　" + rnum + "ずつ"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @captozp_result_window.contents.blt(4,2+2*24, $tec_mozi,rect)
    mozi = "　LRをおしながら　じょうげで　" + lrnum + "ずつへんどうします"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @captozp_result_window.contents.blt(4,2+3*24, $tec_mozi,rect)
    mozi = "しょじCAP：" + $game_variables[25].to_s
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @captozp_result_window.contents.blt(4,2+4*24, $tec_mozi,rect)
    mozi = "しようCAP：" + @captozp_cap.to_s + "　しゅとくZP：" + @captozp_zp.to_s
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @captozp_result_window.contents.blt(4,2+5*24, $tec_mozi,rect)
    mozi = "　はい　　　いいえ"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @captozp_result_window.contents.blt(4,2+6*24+12, $tec_mozi,rect)#(4,34+48, $tec_mozi,rect)

  end
 #--------------------------------------------------------------------------
  # ● フリースキルセットする、しないのウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_freeset_result_window
    @freeset_result_window.dispose
    @freeset_result_window = nil
  end

  #--------------------------------------------------------------------------
  # ● フリースキルセットする、しないのウインドウ作成
  #--------------------------------------------------------------------------  
  def create_freeset_result_window
    @freeset_result_window = Window_Base.new(98,166,444,148)
    @freeset_result_window.opacity=255
    @freeset_result_window.back_opacity=255
    @freeset_result_window.contents.font.color.set( 0, 0, 0)
    @freeset_result_window.z = 255
    output_freeset_result
  end
  #--------------------------------------------------------------------------
  # ● フリースキルセットはいいいえ表示
  #-------------------------------------------------------------------------- 
  def output_freeset_result
    mozi = "セットスキル：" + $cha_skill_mozi_set[@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]].to_s
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @freeset_result_window.contents.blt(4,2, $tec_mozi,rect)
    mozi = "このスキルを　フリーに　セットしますか？"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @freeset_result_window.contents.blt(4,2+24, $tec_mozi,rect)
    #mozi = ""
    #output_mozi mozi
    #rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    #@freeset_result_window.contents.blt(4,2+48, $tec_mozi,rect)
    mozi = "　はい　　　いいえ"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @freeset_result_window.contents.blt(4,34+48, $tec_mozi,rect)

  end
  #--------------------------------------------------------------------------
  # ● レベルアップ使用する、しないのウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_skillup_result_window
    @skillup_result_window.dispose
    @skillup_result_window = nil
  end
  #--------------------------------------------------------------------------
  # ● レベルアップ使用する、しないのウインドウ作成
  #--------------------------------------------------------------------------  
  def create_skillup_result_window
    @skillup_result_window = Window_Base.new(98,166,444,148)
    @skillup_result_window.opacity=255
    @skillup_result_window.back_opacity=255
    @skillup_result_window.contents.font.color.set( 0, 0, 0)
    @skillup_result_window.z = 255
    output_skillup_result
  end
  #--------------------------------------------------------------------------
  # ● レベルアップCAP使用はいいいえ表示
  #-------------------------------------------------------------------------- 
  def output_skillup_result
    #@result_window.contents.draw_text(0,0, 300, 40, "このカードを使用しますか？")
    mozi = "しょじCAP：" + $game_variables[25].to_s
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @skillup_result_window.contents.blt(4,2, $tec_mozi,rect)
    #mozi = "スキルを　レベルアップするには　CAP：" + $cha_skill_set_get_val[@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]].to_s
    
    #レベルアップスキル
    mozi = "スキルを　レベルアップするには　CAP：" + ($cha_skill_set_get_val[$cha_upgrade_skill_no[$cha_typical_skill[$partyc[@@cursorstate]][@skill_cursorstate]].to_i] * Skill_levelup_bairitu).to_s

    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @skillup_result_window.contents.blt(4,2+24, $tec_mozi,rect)
    mozi = "つかいます　レベルアップしますか？"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @skillup_result_window.contents.blt(4,2+48, $tec_mozi,rect)
    mozi = "　はい　　　いいえ"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @skillup_result_window.contents.blt(4,34+48, $tec_mozi,rect)
    #@result_window.contents.draw_text(0,30, 200, 40, "　はい　　　いいえ")
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------   
  def update
    super
    se_on = false
    #chk_up = false #更新チェック
    
    #Graphics.update
    #Input.update
    if Input.trigger?(Input::C)
      @window_update_flag = true
      if @call_state == 1 || @call_state == 2 #戦闘かマップ
        
        
        
        if @window_state == 0 #&& $partyc.size > 1 #仲間が1人以上の場合は並び替え準備に
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          @cursor_chara_select = @@cursorstate  #現在カーソル位置を選択に格納
          
          #能力表示時のみかつマップのみ
          #if @display_skill_window == 1 && @call_state == 1 
            #@window_state = 0
            #Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
          if @display_skill_window == 1 #&& @call_state == 2
            #set_skill_nil_to_zero $partyc[@@cursorstate]
            @window_state = 2                     #ウインドウ状態をスキル設定に
            move_skill_cursor 0 #スキルカーソル初期値移動
            @skill_list_cursorstate = 0
            @skill_list_put_strat = 0
            @skill_memo_window.visible = true
            @skill_memo_backwindow.visible = true
          elsif $partyc.size > 1 #仲間が2人以上の場合は並び替え準備に
            @window_state = 1                     #ウインドウ状態を並び替えに
            move_cursor 2 #カーソル下移動
          end
          
        elsif @window_state == 1 #並び替え
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          #パーティー順の入れ替え
          $partyc[@@cursorstate],$partyc[@cursor_chara_select] = $partyc[@cursor_chara_select],$partyc[@@cursorstate]
          #死亡状態
          $chadead[@@cursorstate],$chadead[@cursor_chara_select] = $chadead[@cursor_chara_select],$chadead[@@cursorstate]
          #パワーアップ
          $cha_power_up[@@cursorstate],$cha_power_up[@cursor_chara_select] = $cha_power_up[@cursor_chara_select],$cha_power_up[@@cursorstate]
          #ディフェンスアップ
          $cha_defense_up[@@cursorstate],$cha_defense_up[@cursor_chara_select] = $cha_defense_up[@cursor_chara_select],$cha_defense_up[@@cursorstate]
          #ストップ
          $cha_stop_num[@@cursorstate],$cha_stop_num[@cursor_chara_select] = $cha_stop_num[@cursor_chara_select],$cha_stop_num[@@cursorstate]
          #巨大キャラ
          $cha_bigsize_on[@@cursorstate],$cha_bigsize_on[@cursor_chara_select] = $cha_bigsize_on[@cursor_chara_select],$cha_bigsize_on[@@cursorstate]
          #ミラクル全開パワー乱数
          $cha_mzenkai_num[@@cursorstate],$cha_mzenkai_num[@cursor_chara_select] = $cha_mzenkai_num[@cursor_chara_select],$cha_mzenkai_num[@@cursorstate]
          #きまぐれカードランダム
          $cha_carda_rand[@@cursorstate],$cha_carda_rand[@cursor_chara_select] = $cha_carda_rand[@cursor_chara_select],$cha_carda_rand[@@cursorstate]
          $cha_cardg_rand[@@cursorstate],$cha_cardg_rand[@cursor_chara_select] = $cha_cardg_rand[@cursor_chara_select],$cha_cardg_rand[@@cursorstate]
          $cha_cardi_rand[@@cursorstate],$cha_cardi_rand[@cursor_chara_select] = $cha_cardi_rand[@cursor_chara_select],$cha_cardi_rand[@@cursorstate]
          #KIの消費ゼロ
          $cha_ki_zero[@@cursorstate],$cha_ki_zero[@cursor_chara_select] = $cha_ki_zero[@cursor_chara_select],$cha_ki_zero[@@cursorstate]
          #戦闘連続参加ターン数
          $cha_btl_cont_part_turn[@@cursorstate],$cha_btl_cont_part_turn[@cursor_chara_select] = $cha_btl_cont_part_turn[@cursor_chara_select],$cha_btl_cont_part_turn[@@cursorstate]
          #湧き出る力乱数
          $cha_wakideru_rand[@@cursorstate],$cha_wakideru_rand[@cursor_chara_select] = $cha_wakideru_rand[@cursor_chara_select],$cha_wakideru_rand[@@cursorstate]
          #湧き出る力スキル有効フラグ
          $cha_wakideru_flag[@@cursorstate],$cha_wakideru_flag[@cursor_chara_select] = $cha_wakideru_flag[@cursor_chara_select],$cha_wakideru_flag[@@cursorstate] 
          #気を溜める乱数
          $cha_ki_tameru_rand[@@cursorstate],$cha_ki_tameru_rand[@cursor_chara_select] = $cha_ki_tameru_rand[@cursor_chara_select],$cha_ki_tameru_rand[@@cursorstate]
          #気を溜める有効フラグ
          $cha_ki_tameru_flag[@@cursorstate],$cha_ki_tameru_flag[@cursor_chara_select] = $cha_ki_tameru_flag[@cursor_chara_select],$cha_ki_tameru_flag[@@cursorstate] 
          #先手スキル有効フラグ
          $cha_sente_flag[@@cursorstate],$cha_sente_flag[@cursor_chara_select] = $cha_sente_flag[@cursor_chara_select],$cha_sente_flag[@@cursorstate] 
          #先手カードスキル有効フラグ
          $cha_sente_card_flag[@@cursorstate],$cha_sente_card_flag[@cursor_chara_select] = $cha_sente_card_flag[@cursor_chara_select],$cha_sente_card_flag[@@cursorstate] 
          #回避カード有効フラグ
          $cha_kaihi_card_flag[@@cursorstate],$cha_kaihi_card_flag[@cursor_chara_select] = $cha_kaihi_card_flag[@cursor_chara_select],$cha_kaihi_card_flag[@@cursorstate] 
          
          #歩行か飛行切り替え
          #時の間じゃないかつZ3以降かつクリティカル頻発かつ飛行禁止フラグが無効
          ####################################
          #テスト
          #マップの初期化処理実行フラグを戻す 歩行から飛行キャラに変えるとキャラがズレる不具合のため
          #$game_switches[1] = false
          #$game_switches[4] = false
          #####################################
          
          
          if $game_switches[466] == false &&
            $game_variables[40] >= 2 &&
            $data_actors[$partyc[0]].critical_bonus == true && $game_switches[79] == false
            #飛行フラグON
            
            #飛行フラグがOFFの場合のみ飛行キャラの強制初期化フラグを変える
            #キャラが一瞬点滅する事の対策
            if $game_switches[19] == false
              $game_switches[862] = false
            end
            $game_switches[19] = true
          else
            
            $game_switches[19] = false
            
          end
          #パーティー先頭キャラを変更
          $game_variables[42] = $partyc[0]
          
          @window_state = 0
          set_map_cha
        elsif @window_state == 2 #固定追加スキル選択
          if @skill_cursorstate <= 2 && @call_state == 2 #固有スキルを選択
            #$cha_upgrade_skill_no
            #次のレベルがあるスキルか確認
            #p $cha_typical_skill[$partyc[@@cursorstate]][@skill_cursorstate],$cha_upgrade_skill_no[$cha_typical_skill[$partyc[@@cursorstate]][@skill_cursorstate]]
            if $cha_upgrade_skill_no[$cha_typical_skill[$partyc[@@cursorstate]][@skill_cursorstate]] != 0 
              Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
              @window_state = 11
              #@skill_set_result = 0
              create_skillup_result_window
            else
              Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
            end
          elsif @skill_cursorstate > 2 && @call_state == 2 #追加スキルを選択しているかかつマップから呼ばれているか
            Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
            @window_state = 3
            #@skill_list_put_strat = 0
            #@skill_list_cursorstate = 0
            @skill_list_window.visible = true
            @party_window.visible = false
            get_output_skill_list #スキル一覧の生成
            #dp @skill_list_put_strat.to_s + ":" + @skill_list_cursorstate.to_s
            #create_cap_window
          else
            Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
          end
        elsif @window_state == 3 #スキル一覧選択
          #同じスキルがないかチェック
          #p @skill_list_cursorstate,@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]
          sel_skill_no = @skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]
          
          #dp $cha_skill_get_flag[$partyc[@@cursorstate]][$cha_old_skill_no[sel_skill_no]]
          
          #p $cha_skill_get_flag[$partyc[@@cursorstate]][$cha_old_skill_no[sel_skill_no]] 
          if chk_same_skill ($partyc[@@cursorstate] ,sel_skill_no,(@skill_cursorstate -2)) == false && $cha_skill_get_flag[$partyc[@@cursorstate]][$cha_old_skill_no[sel_skill_no]] == 1 ||
            chk_same_skill ($partyc[@@cursorstate] ,sel_skill_no,(@skill_cursorstate -2)) == false && $cha_old_skill_no[sel_skill_no] == 0 ||
            sel_skill_no == 0
            
            Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
            
            #セットしたことあるかチェックしセットしたことあればそのままセットなければCAP使うか確認
            #p $cha_skill_set_flag[$partyc[@@cursorstate]]#[sel_skill_no]
            #初期化
            if $cha_skill_get_flag[$partyc[@@cursorstate]][sel_skill_no] == nil
              $cha_skill_get_flag[$partyc[@@cursorstate]][sel_skill_no] = 0
            end
            if $cha_skill_set_flag[$partyc[@@cursorstate]][sel_skill_no] == nil
              $cha_skill_set_flag[$partyc[@@cursorstate]][sel_skill_no] = 0
            end
            
            if $cha_add_skill[$partyc[@@cursorstate]][@skill_cursorstate -3] == sel_skill_no && #選択したスキルがセット済み
              $cha_skill_get_flag[$partyc[@@cursorstate]][sel_skill_no] != 1 && $cha_skill_set_flag[$partyc[@@cursorstate]][sel_skill_no] == 1 #かつ未取得
              #レベル1 or レベルなしの取得中スキルを再選択した
            
              Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
              @window_state = 10
              #@skill_set_result = 0
              
              create_result_window
            elsif $cha_skill_get_flag[$partyc[@@cursorstate]][sel_skill_no] == 1 || ($cha_skill_set_flag[$partyc[@@cursorstate]][sel_skill_no] == 1 && $cha_old_skill_no[sel_skill_no] == 0) || sel_skill_no == 0#if $cha_skill_set_flag[$partyc[@@cursorstate]][sel_skill_no] != 0 || sel_skill_no == 0
              #p $partyc[@@cursorstate],@skill_cursorstate -3,@skill_list_put_skill_no[@skill_list_cursorstate]
              #p $cha_add_skill[$partyc[@@cursorstate]],sel_skill_no
              $cha_add_skill[$partyc[@@cursorstate]][@skill_cursorstate -3] = sel_skill_no
              @window_state = 2
              #@skill_list_put_strat = 0
              #@skill_list_cursorstate = 0
              
            else
              #p 1
              @window_state = 10
              @skill_set_result = 0
             
              create_result_window
              
            end
          else
            Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
          end
        elsif @window_state == 8
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          @window_state = 2
        elsif @window_state == 10 #スキルセット確認ウィンドウ
          sel_skill_no = @skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]
          if @skill_set_result == 0 #はい
            #p $game_variables[25],$cha_skill_set_get_val[@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]]
            
            
            temp_syuutokuritu = 1-($cha_skill_spval[$partyc[@@cursorstate]][sel_skill_no].to_f / $cha_skill_get_val[sel_skill_no].to_f).to_f#).round
            temp_syuutokuritu = ($cha_skill_set_get_val[sel_skill_no] * temp_syuutokuritu).round

            if $game_variables[25] >= temp_syuutokuritu
            #if $game_variables[25] >= $cha_skill_set_get_val[sel_skill_no]
              #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
              Audio.se_play("Audio/SE/" + "DB2 アイテム取得")    # 効果音を再生する
              
              
              #初回のレベルを取得なのか
              if $cha_skill_set_flag[$partyc[@@cursorstate]][sel_skill_no] == 0
                #スキルセットフラグ更新
                $cha_skill_set_flag[$partyc[@@cursorstate]][sel_skill_no] = 1
                #CAP減らす
                $game_variables[25] -= $cha_skill_set_get_val[sel_skill_no]
              else
                temp_syuutokuritu = 1-($cha_skill_spval[$partyc[@@cursorstate]][sel_skill_no].to_f / $cha_skill_get_val[sel_skill_no].to_f).to_f#).round
                temp_syuutokuritu = ($cha_skill_set_get_val[sel_skill_no] * temp_syuutokuritu).round
                
                #CAP減らす
                $game_variables[25] -= temp_syuutokuritu
                
                #スキル取得フラグ更新
                $cha_skill_get_flag[$partyc[@@cursorstate]][sel_skill_no] = 1
                
                #SP取得
                $cha_skill_spval[$partyc[@@cursorstate]][sel_skill_no] = $cha_skill_get_val[sel_skill_no]
                
                #次のスキルも取得する
                if chk_run_next_add_skill($partyc[@@cursorstate],sel_skill_no) == true
                  $skill_set_get_num[0][$cha_upgrade_skill_no[sel_skill_no]] = 1
                  $skill_set_get_num[1][$cha_upgrade_skill_no[sel_skill_no]] = 1
                  #セットしたことがあることにする
                  $cha_skill_set_flag[$partyc[@@cursorstate]][$cha_upgrade_skill_no[sel_skill_no]] = 1
                end
              end
              #スキルセット
              $cha_add_skill[$partyc[@@cursorstate]][@skill_cursorstate -3] = sel_skill_no
              @window_state = 2
              #@skill_list_cursorstate = 0
              dispose_result_window
              
              #新たなスキルを覚える事があるためスキルリストの更新
              get_output_skill_list
            else
              Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
              @skill_set_result = 0
              @window_state = 3  
              dispose_result_window
            end
          else #いいえ
            @skill_set_result = 0
            @window_state = 3  
            dispose_result_window
          end
        elsif @window_state == 11 #スキルレベルアップウィンドウ
            
          if @skill_set_result == 0 #はい
            
            get_skill = ($cha_upgrade_skill_no[$cha_typical_skill[$partyc[@@cursorstate]][@skill_cursorstate]]).to_i
            
            #p $game_variables[25],$cha_skill_set_get_val[@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]]
            if $game_variables[25] >= ($cha_skill_set_get_val[get_skill] * Skill_levelup_bairitu)
              #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
              Audio.se_play("Audio/SE/" + "Z3 レベルアップ")    # 効果音を再生する
              #CAP減らす
              $game_variables[25] -= ($cha_skill_set_get_val[get_skill] * Skill_levelup_bairitu)
              #スキルセットフラグ更新
              $cha_skill_set_flag[$partyc[@@cursorstate]][get_skill] = 1
              #スキル取得フラグ更新
              $cha_skill_get_flag[$partyc[@@cursorstate]][get_skill] = 1
              #スキル取得可能数も更新
              $skill_set_get_num[0][get_skill] = 1 
              $skill_set_get_num[1][get_skill] = 1 
              
              #SPもセット
              $cha_skill_spval[$partyc[@@cursorstate]][get_skill] = $cha_skill_get_val[get_skill]
              #スキルセット
              $cha_typical_skill[$partyc[@@cursorstate]][@skill_cursorstate] = get_skill
              @window_state = 2
              dispose_skillup_result_window
              get_output_skill_list #スキル一覧の生成
            else
              Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
              #@skill_set_result = 0
              @window_state = 2  
              dispose_skillup_result_window
            end
            
          else #いいえ
            @skill_set_result = 0
            @window_state = 2  
            dispose_skillup_result_window
          end
          
        end
      elsif @call_state == 3 #カード
        if @window_state == 2 #キャラスキル選択
          
          skillno = $cha_add_skill[$partyc[@@cursorstate]][@skill_cursorstate-3].to_i
          
          #p [nil,0].include?($skill_set_get_num[0][$cha_upgrade_skill_no[skillno]]),$skill_set_get_num[0][$cha_upgrade_skill_no[skillno]]
          if @skill_cursorstate > 2 && #追加スキルを選択しているか
            $cha_add_lvup[skillno] != 0 && #追加スキルでレベルアップ可能か
            $cha_upgrade_skill_no[skillno] != 0 && #追加スキルNoがあるか(念のためチェック)
            [nil,0].include?($skill_set_get_num[0][$cha_upgrade_skill_no[skillno]]) == true && #まだセット可能になってないか
            chk_skill_learn(skillno,$partyc[@@cursorstate])[0] == true #かつ取得済み
            Audio.se_play("Audio/SE/" + $BGM_CursorOn)
            @window_state = 14
            create_addskill_lvup_result_window
            @skill_set_result = 0
            
          else
            Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
          end

        elsif @window_state == 3 #スキル一覧選択
          #同じスキルがないかチェック かつ　はずすじゃないか　かつ　覚えているスキルか
          #同じスキルでも追加スキルなら後で外す処理をするので前に進める
          #p @skill_list_cursorstate,@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]
          #if chk_same_skill ($partyc[@@cursorstate] ,@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat],9) == false &&

          #if (chk_same_skill ($partyc[@@cursorstate] ,@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat],9) == false || chk_same_skill ($partyc[@@cursorstate] ,@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat],9) == true && $same_skill_type == 2) &&

          #p chk_same_skill ($partyc[@@cursorstate] ,@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat],9),$same_skill_type
          if ((chk_same_skill ($partyc[@@cursorstate] ,@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat],9)) == false || (chk_same_skill ($partyc[@@cursorstate] ,@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat],9)) == true && $same_skill_type == 2) &&
          @skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat] != 0 &&
          $cha_skill_spval[$partyc[@@cursorstate]][@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]] >= $cha_skill_get_val[@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]]

            Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
            @window_state = 12
            @skill_set_result = 0
            create_freeset_result_window
          else
            Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
          end
        elsif @window_state == 12 #フリースキル変更
          
          if @skill_set_result == 0 #はい
              #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
              Audio.se_play("Audio/SE/" + "DB2 アイテム取得")    # 効果音を再生する
              #p chk_same_skill ($partyc[@@cursorstate] ,@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat],9),$same_skill_type
              if (chk_same_skill ($partyc[@@cursorstate] ,@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat],9)) == true && $same_skill_type == 2
                $cha_add_skill[$partyc[@@cursorstate]][$same_skill_no] = 0
              end
              #スキルセットフラグ更新
              $cha_skill_set_flag[$partyc[@@cursorstate]][@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]] = 1
              #スキル取得フラグ更新
              $cha_skill_get_flag[$partyc[@@cursorstate]][@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]] = 1
              #SPもセット
              #$cha_skill_spval[$partyc[@@cursorstate]][@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]] = $cha_skill_get_val[@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]]
              #スキルセット
              $cha_typical_skill[$partyc[@@cursorstate]][@skill_cursorstate] = @skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]
              #追加スキルとかぶっているのがあったら外す
              #スキル取得可能数も更新
              $skill_set_get_num[0][@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]] = 1 
              $skill_set_get_num[1][@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]] = 1 
              #@window_state = 3
              #@skill_list_cursorstate = 0
              $cha_set_free_skill[$partyc[@@cursorstate]] = true
              dispose_freeset_result_window
              pre_update
              Graphics.wait(40)
              Graphics.fadeout(5)
              $game_party.lose_item ($data_items[$run_item_card_id], 1)
              card_run_num_add $run_item_card_id
              $scene = Scene_Db_Card.new (3)
          else #いいえ
            @skill_set_result = 0
            @window_state = 3  
            dispose_freeset_result_window
          end
        elsif @window_state == 13 #スキルリリース
          
          if @skill_set_result == 0 #はい
              #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
              Audio.se_play("Audio/SE/" + "Z3 アイテム取得")    # 効果音を再生する
              #スキルセットフラグ更新
              #$cha_skill_set_flag[$partyc[@@cursorstate]][@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]] = 1
              #SPもセット
              #$cha_skill_spval[$partyc[@@cursorstate]][@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]] = $cha_skill_get_val[@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]]
              #スキルセット
              $cha_typical_skill[$partyc[@@cursorstate]][@skill_cursorstate] = 34
              #$cha_typical_skill[$partyc[@@cursorstate]][@skill_cursorstate] = @skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]
              #@window_state = 3
              #@skill_list_cursorstate = 0
              $cha_set_free_skill[$partyc[@@cursorstate]] = false
              dispose_release_result_window
              pre_update
              Graphics.wait(40)
              Graphics.fadeout(5)
              $game_party.lose_item ($data_items[$run_item_card_id], 1)
              card_run_num_add $run_item_card_id
              $scene = Scene_Db_Card.new (3)
          else #いいえ
            @skill_set_result = 0
            @window_state = 0
            dispose_release_result_window
          end
        elsif @window_state == 14 #追加スキルレベルアップセット可能
          if @skill_set_result == 0 #はい
            Audio.se_play("Audio/SE/" + "DB2 アイテム取得")    # 効果音を再生する
            skillno = $cha_add_skill[$partyc[@@cursorstate]][@skill_cursorstate-3]
            #スキルセットフラグ更新
            $cha_skill_set_flag[$partyc[@@cursorstate]][$cha_upgrade_skill_no[skillno]] = 1 #まだセット可能になってないか
            #スキル取得可能数も更新
            #セット可能数？こっちはボツだけど念のため更新する
            $skill_set_get_num[0][$cha_upgrade_skill_no[skillno]] = 1
            #一度でもセットした/スキル一覧に表示
            $skill_set_get_num[1][$cha_upgrade_skill_no[skillno]] = 1
            dispose_addskill_lvup_result_window
            pre_update
            Graphics.wait(40)
            Graphics.fadeout(5)
            $game_party.lose_item ($data_items[$run_item_card_id], 1)
            card_run_num_add $run_item_card_id
            $scene = Scene_Db_Card.new (3)
          else #いいえ
            @window_state = 2
            dispose_addskill_lvup_result_window
          end
        elsif @window_state == 15 #CAPZP変換
          if @skill_set_result == 0 #はい
            
            if @captozp_cap > 0 
              Audio.se_play("Audio/SE/" + "Z1 パワーアップ")    # 効果音を再生する
              $zp[$partyc[@@cursorstate]] += @captozp_zp #ZP取得
              $game_variables[25] -= @captozp_cap #CAP減少
              dispose_captozp_result_window
              pre_update
              Graphics.wait(40)
              Graphics.fadeout(5)
              card_run_num_add $run_item_card_id
              $scene = Scene_Db_Card.new (3)
            else
              Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
            end
          else #いいえ
            @window_state = 0  
            dispose_captozp_result_window
          end
        else #キャラ選択
          @run_card_result = run_card
          if @run_card_result == true
            @cursor_chara_select = @@cursorstate  #現在カーソル位置を選択に格納
            if $run_item_card_id == Freeskill_set_card_no #仮面男
              Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
              @display_skill_window = 1
              #@display_skill_window = -@display_skill_window
              set_status_window_size
              #set_skill_nil_to_zero $partyc[@@cursorstate]
              #@window_state = 2                     #ウインドウ状態をスキル設定に
              move_skill_cursor 0 #スキルカーソル初期値移動
#=begin              
              #カーソルセット
              temp_cha_no = $partyc[@@cursorstate]
              #p temp_cha_no
              free_skill = false
              
              #フリースキルを取得しているか
              for y in 0..$cha_typical_skill[temp_cha_no].size
                if 34 == $cha_typical_skill[temp_cha_no][y]
                  free_skill = true 
                  @skill_cursorstate = y
                  break
                end
              end
#=end
#p @skill_cursorstate
              #フリーで選択したキャラのスキルリストを取得
              @setfreeskill_flag = true
              get_output_skill_list
              @skill_list_cursorstate = 0
              @skill_list_put_strat = 0
              @skill_memo_window.visible = true
              @skill_memo_backwindow.visible = true
              @window_state = 3
              @skill_list_put_strat = 0
              @skill_list_cursorstate = 0
              @skill_list_window.visible = true
              @party_window.visible = false
            elsif $run_item_card_id == Freeskill_release_card_no #ねずみ
              Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
              @window_state = 13
              @skill_cursorstate = 2
              @skill_set_result = 0
              create_release_result_window
            elsif $run_item_card_id == Addskill_lvup_card_no #超聖水
              Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
              @window_state = 2
              @skill_cursorstate = 0
            elsif $run_item_card_id == Captozp_card_no      #重力装置(CAPをZPに変換)
              Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
              @window_state = 15
              @skill_set_result = 0
              #使用するCAPとしゅとくできるZPを初期化
              @captozp_cap = 0
              @captozp_zp = 0
              create_captozp_result_window
              
            else #通常のカード
              Graphics.wait(40)
              Graphics.fadeout(5)
              $game_party.lose_item ($data_items[$run_item_card_id], 1)
              card_run_num_add $run_item_card_id
              $scene = Scene_Db_Card.new (3)
            end
          end
        end
      elsif @call_state == 4 #修行
        if $chadead[@@cursorstate] == false
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          $training_chara_num = @@cursorstate
          Graphics.fadeout(5)
          if $game_variables[41] == 31 #スピード・敏捷
            $scene = Scene_Db_Speed_Training.new
          elsif $game_variables[41] == 32 #重力
            $scene = Scene_Db_Gravity_Training.new
          elsif $game_variables[41] == 33 #ダジャレ
            $scene = Scene_Db_Dajare_Training.new
          elsif $game_variables[41] == 34 #ポポ
            $scene = Scene_Db_Popo_Training.new
          elsif $game_variables[41] == 35 #チチ
            $scene = Scene_Db_Chi_Chi_Training.new
          end

        else
          Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
        end
      elsif @call_state == 5 #お気に入りキャラ選択
        if $game_variables[104] != $partyc[@@cursorstate]
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          #$game_variables[105] = $partyc[@@cursorstate]
          
          
          $game_variables[105] = get_ori_cha_no $partyc[@@cursorstate]

          $game_variables[41] += 1 if $game_variables[41] == 48
          Graphics.fadeout(5)
          $scene = Scene_Map.new
        end
      elsif @call_state == 6 #ZPパワーアップ
          #選択キャラNoとZPをセット
          $game_variables[261] = $partyc[@@cursorstate]
          $game_variables[262] = $zp[$partyc[@@cursorstate]]
          $game_variables[263] = $zp[$partyc[@@cursorstate]] / $statusup_zp
          
          if $game_variables[263] != 0
            Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
            $game_variables[41] += 1
            Graphics.fadeout(0)
            #p $game_variables[41],$game_variables[261],$game_variables[262]
            $game_player.reserve_transfer(7, 1, 0, 0)
            $scene = Scene_Map.new
          else
            Audio.se_play("Audio/SE/" + $BGM_Error)
          end
        elsif @call_state == 7 #共有経験値
          #選択キャラNoとZPをセット
          $game_variables[327] = $partyc[@@cursorstate] #対象者No
          $game_variables[321] = $game_actors[$partyc[@@cursorstate]].level #対象者レベル
          $game_variables[322] = $game_actors[$partyc[@@cursorstate]].next_rest_exp_s #対象者次までいくつ
          $game_variables[323] = 1+(($game_variables[324] - $game_variables[321]) * 0.1).to_f #倍率計算
          
          if $game_variables[323] < 1 #基準値以下
            $game_variables[323] = 1.0
          elsif $game_variables[323] > 3 #最大3倍とする
            $game_variables[323] = 3.0
          end
          
          if $game_variables[321] != $actor_final_level_default
            Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
            $game_variables[41] += 1
            Graphics.fadeout(0)
            #p $game_variables[41],$game_variables[261],$game_variables[262]
            $game_player.reserve_transfer(7, 1, 0, 0)
            $scene = Scene_Map.new
          else
            Audio.se_play("Audio/SE/" + $BGM_Error)
          end
      end
    end
    if Input.trigger?(Input::B)
      @window_update_flag = true
      @tecput_page = 0
      if @call_state == 1 || @call_state == 2 #戦闘かかマップ
        if @window_state == 0 && @call_state == 1 #戦闘
          $chadeadchk = Marshal.load(Marshal.dump($chadead))
          Graphics.fadeout(5)
          $scene = Scene_Db_Battle.new ($battle_escape,$battle_bgm,$battle_ready_bgm)
        elsif @window_state == 0 && @call_state == 2 #マップ
          Graphics.fadeout(5)
          Audio.bgm_play("Audio/BGM/" + $map_bgm)    # 効果音を再生する
          $scene = Scene_Map.new
          #$game_switches[4] = false
          #$game_switches[2] = false
          #$game_switches[1] = false
        elsif @window_state == 1
          @window_state = 0
          @@cursorstate = @cursor_chara_select
        elsif @window_state == 2
          @skill_memo_window.visible = false
          @skill_memo_backwindow.visible = false
          @skill_list_window.visible = false
          @party_window.visible = true
          dispose_cap_window if @cap_window != nil
          @window_state = 0
        elsif @window_state == 3  
          @window_state = 2
          @skill_list_cursorstate = 0
          @skill_list_put_strat = 0
        elsif @window_state == 8
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          @window_state = 2
          @skill_memo_window.visible = false
          @skill_memo_backwindow.visible = false
        elsif @window_state == 10 #スキルセット確認ウィンドウ
          @skill_set_result = 0
          @window_state = 3  
          dispose_result_window
        elsif @window_state == 11 #スキルレベルアップ確認ウィンドウ
          #@skill_set_result = 0
          @window_state = 2  
          dispose_skillup_result_window
        end
      elsif @call_state == 3 #カード
        if @window_state == 2
          @skill_memo_window.visible = false
          @skill_memo_backwindow.visible = false
          @skill_list_window.visible = false
          @party_window.visible = true
          dispose_cap_window if @cap_window != nil
          
          @window_state = 0
        elsif @window_state == 3 #スキル一覧選択
          @window_state = 0
          @skill_memo_window.visible = false
          @skill_memo_backwindow.visible = false
          @skill_list_window.visible = false
          @party_window.visible = true
        elsif @window_state == 12 #フリースキル確認ウィンドウ
          #@skill_set_result = 0
          @window_state = 3  
          dispose_freeset_result_window
        elsif @window_state == 13 #フリースキル確認ウィンドウ
          #@skill_set_result = 0
          @window_state = 0  
          dispose_release_result_window
        elsif @window_state == 14 #追加スキルレベルアップ確認ウィンドウ
          #@skill_set_result = 0
          @window_state = 2  
          dispose_addskill_lvup_result_window
        elsif @window_state == 15 #CAPZP変換ウインドウ
          #@skill_set_result = 0
          @window_state = 0  
          dispose_captozp_result_window
        else
          Graphics.fadeout(5)
          $scene = Scene_Db_Card.new 3
        end
      elsif @call_state == 5 #お気に入りキャラ選択
        $game_variables[41] += 1 if $game_variables[41] == 48
          Graphics.fadeout(5)
          $scene = Scene_Map.new
      elsif @call_state == 6 #ZPパワーアップ
          #選択キャラNoとZPをセット
          #$game_variables[261] = $partyc[@@cursorstate]
          #$game_variables[262] = $zp[$partyc[@@cursorstate]]
          #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          $game_variables[41] -= 1
          Graphics.fadeout(0)
          #p $game_variables[41],$game_variables[261],$game_variables[262]
          $game_player.reserve_transfer(7, 1, 0, 0)
          $scene = Scene_Map.new
      elsif @call_state == 7 #共有経験値
          #選択キャラNoとZPをセット
          #$game_variables[261] = $partyc[@@cursorstate]
          #$game_variables[262] = $zp[$partyc[@@cursorstate]]
          #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          $game_variables[41] -= 1
          Graphics.fadeout(0)
          #p $game_variables[41],$game_variables[261],$game_variables[262]
          $game_player.reserve_transfer(7, 1, 0, 0)
          $scene = Scene_Map.new
  
      end
    end

    if Input.trigger?(Input::X) 
      
      
      if @display_skill_window == -1 #能力表示時のみ
        #熟練度切り替え
        @window_update_flag = true
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        @display_skill_level = -@display_skill_level
      #elsif @window_state == 2 #スキル説明表示
      #  Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      #  #create_skill_memo_window
      #  @skill_memo_window.visible = true
      #  @window_state = 8
      end
      
      
    end

    if Input.trigger?(Input::Y) #スキル切り替え
      
      #フリースキルカードの時もボタンを無効に
      if @window_state == 0 && Freeskill_set_card_no != $run_item_card_id #|| @window_state == 1 #並び替えじゃ無い時
        @window_update_flag = true
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        @display_skill_window = -@display_skill_window
        set_status_window_size
      end
    end
    
    if Input.trigger?(Input::L) #衣替え
      @window_update_flag = true
      #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      if @window_state == 2
        move_cursor 8 #スキルカーソル移動
        get_output_skill_list #スキル一覧の生成
        @cursor_chara_select = @@cursorstate
        move_skill_cursor 0
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      elsif @window_state == 15 #CAP変換(反応させないために記載)
        
      else
        set_dress -1,$partyc[@@cursorstate]
      end
    end
    
    if Input.trigger?(Input::R) #衣替え
      @window_update_flag = true
      #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      if @window_state == 2
        move_cursor 2 #スキルカーソル移動
        get_output_skill_list #スキル一覧の生成
        @cursor_chara_select = @@cursorstate
        move_skill_cursor 0
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      elsif @window_state == 15 #CAP変換(反応させないために記載)
        
      else
        set_dress 1,$partyc[@@cursorstate]
      end
    end
    if Input.trigger?(Input::DOWN) ||
      Input.repeat?(Input::DOWN) && @window_state == 15 #CAP変換の時だけ押しっぱなしでも反応する
      #chk_up = true
      if @window_state == 0 || @window_state == 1
        se_on = true
        move_cursor 2 #カーソル移動
      elsif @window_state == 2
        se_on = true
        move_skill_cursor 2 #スキルカーソル移動
        @skill_list_put_strat = 0
        @skill_list_cursorstate = 0
      elsif @window_state == 3
        move_skill_list_cursor 2 #スキルリストカーソル移動
        se_on = true
      elsif @window_state == 15 #CAP変換
        se_on = true
        
        bairitu = 0
        case $game_variables[471]
        
        when 0
          bairitu = 1
        when 1
          bairitu = 10
        when 2
          bairitu = 100
        when 3
          bairitu = 1000
        end
        
        #0以上の時は下げる
        if Input.press?(Input::L) && Input.press?(Input::R) 
          #LR押しながらだと100ずつ変換
          @captozp_cap -= $captozp_rate * 100 * bairitu
        elsif Input.press?(Input::R)
          #R押しながらだと10ずつ変換
          @captozp_cap -= $captozp_rate * 10 * bairitu
        else
          @captozp_cap -= $captozp_rate * bairitu
        end
        
        if @captozp_cap < 0
          #0の時はそれ以上下げられない
          @captozp_cap = 0
        end
        #ZPの再計算
        @captozp_zp = @captozp_cap / $captozp_rate
        #Graphics.wait(1)
      end
      
      if se_on == true
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      end
    elsif Input.trigger?(Input::UP) ||
      Input.repeat?(Input::UP) && @window_state == 15 #CAP変換の時だけ押しっぱなしでも反応する
      
      if @window_state == 0 || @window_state == 1
        se_on = true
        move_cursor 8 #カーソル移動
        
      elsif @window_state == 2
        move_skill_cursor 8 #スキルカーソル移動
        @skill_list_put_strat = 0
        @skill_list_cursorstate = 0
        se_on = true
      elsif @window_state == 3
        move_skill_list_cursor 8 #スキルリストスキルカーソル移動
        se_on = true
      elsif @window_state == 15 #CAP変換
        se_on = true
        bairitu = 0
        case $game_variables[471]
        
        when 0
          bairitu = 1
        when 1
          bairitu = 10
        when 2
          bairitu = 100
        when 3
          bairitu = 1000
        end
        
        if Input.press?(Input::L) && Input.press?(Input::R) 
          #LR押しながらだと100ずつ変換
          @captozp_cap += $captozp_rate * 100 * bairitu
        elsif Input.press?(Input::R)
          #R押しながらだと10ずつ変換
          @captozp_cap += $captozp_rate * 10 * bairitu
        else
          @captozp_cap += $captozp_rate * bairitu
        end
        
        if $game_variables[25] < @captozp_cap
          #最大量を超えた
          @captozp_cap = ($game_variables[25] / $captozp_rate) * $captozp_rate 
        end
        #ZPの再計算
        @captozp_zp = @captozp_cap / $captozp_rate
        #Graphics.wait(1)
      end
      
      if se_on == true
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      end
    elsif Input.trigger?(Input::RIGHT) #移動可能な時のみ音を鳴らす
      @window_update_flag = true
      if @window_state == 0 || @window_state == 1
      #Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        set_tecpage 1
      elsif @window_state == 3
        move_skill_list_cursor 6 #スキルリストスキルカーソル移動
        se_on = true
      #elsif @window_state == 10 || @window_state == 11 || @window_state == 12 || @window_state == 13 #スキルセット確認カーソル
      elsif [10,11,12,13,14,15].include?(@window_state) == true #スキルセット確認カーソル
      #elsif @window_state == /(10|11|12|13|14)/ #スキルセット確認カーソル 
        if @skill_set_result == 0
          @skill_set_result = 1
        else
          @skill_set_result = 0
        end
        se_on = true
      end
      #Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      #cursor_right(Input.trigger?(Input::RIGHT))
      if se_on == true
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      end
    elsif Input.trigger?(Input::LEFT) #移動可能な時のみ音を鳴らす
      @window_update_flag = true
      #Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      if @window_state == 0 || @window_state == 1
        set_tecpage -1
      elsif @window_state == 3
        move_skill_list_cursor 4 #スキルリストスキルカーソル移動
        se_on = true
      #elsif @window_state == 10 || @window_state == 11 || @window_state == 12 || @window_state == 13 #スキルセット確認カーソル
      elsif [10,11,12,13,14,15].include?(@window_state) == true #スキルセット確認カーソル
        if @skill_set_result == 0
          @skill_set_result = 1
        else
          @skill_set_result = 0
        end
        se_on = true
      end
      #Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      #cursor_left(Input.trigger?(Input::LEFT))
      if se_on == true
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      end
    end

    @window_update_flag = true if Input.dir8 != 0 #何かカーソルを押したら画面を更新フラグをON
    pre_update
  end
  
  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_window
    @party_window.dispose
    @party_window = nil
    @party_backwindow.dispose
    @party_backwindow = nil
    @status_window.dispose
    @status_window = nil
    @status_backwindow.dispose
    @status_backwindow = nil
    @technique_window.dispose
    @technique_window = nil
    @technique_backwindow.dispose
    @technique_backwindow = nil
    @skill_memo_window.dispose
    @skill_memo_window = nil
    @skill_memo_backwindow.dispose
    @skill_memo_backwindow = nil
    @skill_list_window.dispose
    @skill_list_window = nil
  end 
  
  #--------------------------------------------------------------------------
  # ● ウインドウ内容クリア
  #--------------------------------------------------------------------------    
  def window_contents_clear
    @party_window.contents.clear if @window_state != 3
    @status_window.contents.clear #if @window_state != 3
    @technique_window.contents.clear if @window_state != 3
    
    if @skill_memo_window.visible == true
      @skill_memo_window.contents.clear
    end
    
    if @skill_list_window.visible == true
      @skill_list_window.contents.clear
    end
    if @result_window != nil
     @result_window.contents.clear
    end
    
    if @skillup_result_window != nil
     @skillup_result_window.contents.clear
    end
    
    if @freeset_result_window != nil
     @freeset_result_window.contents.clear
    end
    
    if @release_result_window != nil
     @release_result_window.contents.clear
    end
   
    if @addskill_lvup_result_window != nil
     @addskill_lvup_result_window.contents.clear
   end
   
    if @captozp_result_window != nil
      @captozp_result_window.contents.clear
    end
   
  end

  #--------------------------------------------------------------------------
  # ● ウインドウ作成
  #--------------------------------------------------------------------------   
  def create_window
    Graphics.fadeout(0)
    winputx = Puttyouseix
    @party_backwindow = Window_Base.new(Status_backwin_sizex,0,Party_backwin_sizex,Party_backwin_sizey)
    @party_backwindow.opacity=255
    @party_backwindow.back_opacity=255
    @party_window = Window_Base.new(Status_backwin_sizex + winputx + 2,0,Party_win_sizex,Party_win_sizey)
    @party_window.opacity=0
    @party_window.back_opacity=0
    @technique_backwindow = Window_Base.new(0,Status_win_sizey,Technique_backwin_sizex,Technique_backwin_sizey)
    @technique_backwindow.opacity=255
    @technique_backwindow.back_opacity=255
    @technique_window = Window_Base.new(winputx,Status_win_sizey,Technique_win_sizex,Technique_win_sizey)
    @technique_window.opacity=0
    @technique_window.back_opacity=0
    @status_backwindow = Window_Base.new(0,0,Status_backwin_sizex,Status_backwin_sizey)
    @status_backwindow.opacity=255
    @status_backwindow.back_opacity=255
    @status_window = Window_Base.new(winputx,0,Status_win_sizex,Status_win_sizey)
    @status_window.opacity=0
    @status_window.back_opacity=0
    create_skill_memo_window
    @skill_list_window = Window_Base.new(Status_backwin_sizex,0,Skill_list_win_sizex,Skill_list_win_sizey)
    @skill_list_window.opacity=255
    @skill_list_window.back_opacity=255
    @skill_list_window.visible = false
    
    Graphics.fadein(10)
  end
  #--------------------------------------------------------------------------
  # ● スキル説明ウインドウ作成
  #-------------------------------------------------------------------------- 
  def create_skill_memo_window
    #@skill_memo_window = Window_Base.new(0,0,640,Skill_memo_win_sizey)
    @skill_memo_backwindow = Window_Base.new(Status_backwin_sizex,480-Skill_memo_backwin_sizey,Skill_memo_backwin_sizex,Skill_memo_backwin_sizey)
    @skill_memo_backwindow.opacity=255
    @skill_memo_backwindow.back_opacity=255
    @skill_memo_backwindow.visible = false
    
    @skill_memo_window = Window_Base.new(Status_backwin_sizex-4,480-Skill_memo_win_sizey-8,Skill_memo_win_sizex,Skill_memo_win_sizey+16)
    @skill_memo_window.opacity=0
    @skill_memo_window.back_opacity=0
    @skill_memo_window.visible = false
    

  end
  #--------------------------------------------------------------------------
  # ● カーソル表示
  #--------------------------------------------------------------------------  
  def output_cursor
    $cursor_blink_count += 1
    picture = Cache.picture("アイコン")
    rect = set_yoko_cursor_blink
    
    #キャラへカーソルを表示する
    if @window_state == 0 || @window_state == 1 || @window_state == 10
      @party_window.contents.blt(Partynox-0,Partynoy+@@cursorstate*Partyy,picture,rect)
    end
    
    #並び替えやスキル選択したキャラへカーソルを表示する
    #if @window_state == 1 || @window_state == 2 || @window_state == 11 || @window_state == 13 #|| @window_state == 8 || @window_state == 9
    if [1,2,8,9,11,13,14,15].include?(@window_state) == true #スキル一覧画面時
      rect = set_yoko_cursor_blink 0 # アイコン
      @party_window.contents.blt(Partynox-0,Partynoy+@cursor_chara_select*Partyy,picture,rect)
    end
    
    #スキルカーソルを表示する
    if @window_state == 2 #|| @window_state == 8 || @window_state == 9
      #点滅あり
      rect = set_yoko_cursor_blink # アイコン
      
      if @skill_cursorstate <= 2 
        @status_window.contents.blt(Status_lbx-16,Typ_skill_lby+32+Skill_new_liney*@skill_cursorstate,picture,rect)
      else
        @status_window.contents.blt(Status_lbx-16,Add_skill_lby+32+Add_typ_Skill_new_liney*(@skill_cursorstate-3),picture,rect)
      end
    #elsif @window_state == 3 || @window_state == 10 || @window_state == 11 || @window_state == 12 || @window_state == 13 #スキル一覧画面時
    elsif [3,10,11,12,13,14].include?(@window_state) == true #スキル一覧画面時
      #点滅なし
      rect = set_yoko_cursor_blink 0 # アイコン
      if @skill_cursorstate <= 2 
        @status_window.contents.blt(Status_lbx-16,Typ_skill_lby+32+Skill_new_liney*@skill_cursorstate,picture,rect)
      else
        @status_window.contents.blt(Status_lbx-16,Add_skill_lby+32+Add_typ_Skill_new_liney*(@skill_cursorstate-3),picture,rect)
      end
    end
    #スキル一覧カーソルを表示する
    if @window_state == 3 #|| @window_state == 9 
      rect = set_yoko_cursor_blink # アイコン
      @skill_list_window.contents.blt(Skill_list_lbx-16,Skill_list_lby+8+(Skill_list_new_liney*(@skill_list_cursorstate-@skill_list_put_strat)),picture,rect)
    elsif @window_state == 10 || @window_state == 12
      rect = set_yoko_cursor_blink 0 # アイコン
      @skill_list_window.contents.blt(Skill_list_lbx-16,Skill_list_lby+8+(Skill_list_new_liney*(@skill_list_cursorstate-@skill_list_put_strat)),picture,rect)
    end
    
    #はいいいえ表示
    if @result_window != nil 
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      @result_window.contents.blt(@skill_set_result*80+2,42+48,picture,rect)
    end
    
    if @skillup_result_window != nil 
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      @skillup_result_window.contents.blt(@skill_set_result*80+2,42+48,picture,rect)
    end
    
    if @freeset_result_window != nil 
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      @freeset_result_window.contents.blt(@skill_set_result*80+2,42+48,picture,rect)
    end
    
    if @release_result_window != nil 
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      @release_result_window.contents.blt(@skill_set_result*80+2,42+48,picture,rect)
    end
    
    if @addskill_lvup_result_window != nil 
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      @addskill_lvup_result_window.contents.blt(@skill_set_result*80+2,42+48,picture,rect)
    end
    
    if @captozp_result_window != nil 
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      @captozp_result_window.contents.blt(@skill_set_result*80+2,42+100+24,picture,rect)
    end
  end

  #--------------------------------------------------------------------------
  # ● スキル一覧作成
  #--------------------------------------------------------------------------  
  def get_output_skill_list
    #表示するスキル一覧
    @tmp_skill_list_put_skill_no = []
    #表示するスキルの並び順
    tmp_skill_list_put_skill_order_no = []
    #並び替え用スキル一覧
    tmp_order_skill_list_put_skill_no = []
    
    @skill_list_put_ok_count = 0
    
    #事前に対象スキル数を取得
    for x in 0..$cha_skill_count
      #nilかチェックして空欄なら0を格納
      $skill_set_get_num = Array.new(2).map{Array.new(1,0)} if $skill_set_get_num == []
      $skill_set_get_num[0][x] = 0 if $skill_set_get_num[0][x] == nil
      $skill_set_get_num[1][x] = 0 if $skill_set_get_num[1][x] == nil
      #前のレベルの配列も初期化
      $skill_set_get_num[1][$cha_old_skill_no[x]] = 0 if $skill_set_get_num[1][$cha_old_skill_no[x]] == nil
      
      #SPの値も初期化
      $cha_skill_spval[$partyc[@@cursorstate]] = [0] if $cha_skill_spval[$partyc[@@cursorstate]] == nil
      $cha_skill_spval[$partyc[@@cursorstate]][x] = 0 if $cha_skill_spval[$partyc[@@cursorstate]][x] == nil
      $cha_skill_spval[$partyc[@@cursorstate]][$cha_upgrade_skill_no[x]] = 0 if $cha_skill_spval[$partyc[@@cursorstate]][$cha_upgrade_skill_no[x]] == nil

      #何故か一部のキャラで外すが表示されなくなるので、その対策として毎回セットする
      if x == 0
        #初回に開くときの対策
        if $cha_skill_set_flag[$partyc[@@cursorstate]] == nil
          $cha_skill_set_flag[$partyc[@@cursorstate]] = []
        end
        if $cha_skill_get_flag[$partyc[@@cursorstate]] == nil
          $cha_skill_get_flag[$partyc[@@cursorstate]] = []
        end
        $cha_skill_set_flag[$partyc[@@cursorstate]][x] = 1
        $cha_skill_get_flag[$partyc[@@cursorstate]][x] = 1
      end
      
      #&& $cha_skill_botu_flag[x] == 0
      #対象スキルを取得したことがある
      #ボツではない
      #レベルがあるものは前のレベルのスキルも取得したことがある
      if $skill_set_get_num[1][x] > 0 && $cha_skill_botu_flag[x] == 0 && $skill_set_get_num[1][$cha_old_skill_no[x]] > 0 || x == 0

        #共有スキルかスキルセット制限解除がONなら一覧に表示
        #フリースキルの処理中は共有じゃなくても表示することにした
        if $cha_skill_share[x] != 0 && @setfreeskill_flag == false || @setfreeskill_flag == true || $game_switches[467] == true || x == 0

          #p x,$skill_set_get_num[1][x],$skill_set_get_num[1][$cha_old_skill_no[x]]
          #p $cha_skill_share[x],$game_switches[467],x,@skill_list_put_ok_count,$cha_skill_mozi_set[x]

          #if  $cha_skill_share[x] != 0 || $game_switches[467] == true || x == 0
          
          #オプションで最高レベルのみを選択
          #次のレベルがない、前もないスキル = レベル無しスキル
          #レベルアップスキルであれば次のスキルを覚えていないかつ前のスキルを覚えているかつ、自身のレベルを覚えている
          #レベルアップスキルでレベル1または2を覚えていない
          #次のレベルがない、前のレベルを覚えている、自分も覚えている = LVMAX
          #フリー選択時は取得したスキルを全て表示
          #取得中
          if $cha_skill_set_flag[$partyc[@@cursorstate]] == nil
            $cha_skill_set_flag[$partyc[@@cursorstate]] = []
          end
          
          if $cha_skill_get_flag[$partyc[@@cursorstate]] == nil
            $cha_skill_get_flag[$partyc[@@cursorstate]] = []
          end
          
          
          #if x == 61
            #p $cha_skill_spval[$partyc[@@cursorstate]][$cha_upgrade_skill_no[x]],$cha_skill_get_val[$cha_upgrade_skill_no[x]],$cha_old_skill_no[x],$cha_skill_spval[$partyc[@@cursorstate]][$cha_old_skill_no[x]],$cha_skill_get_val[$cha_old_skill_no[x]],$cha_skill_spval[$partyc[@@cursorstate]][x],$cha_skill_get_val[x]
            #p $cha_upgrade_skill_no[x],$cha_old_skill_no[x],$cha_skill_spval[$partyc[@@cursorstate]][$cha_upgrade_skill_no[x]],$cha_skill_get_val[$cha_upgrade_skill_no[x]]
            #p $cha_upgrade_skill_no[x],$cha_skill_spval[$partyc[@@cursorstate]][x],$cha_skill_get_val[x]
            #p $cha_skill_set_flag[$partyc[@@cursorstate]][x],$cha_skill_get_flag[$partyc[@@cursorstate]][x]
          #end
            
          #p $cha_skill_mozi_set[x],$cha_skill_set_flag[$partyc[@@cursorstate]][x],$cha_skill_get_flag[$partyc[@@cursorstate]][x]
          if ($cha_upgrade_skill_no[x] == 0 && $cha_old_skill_no[x] == 0 ||
            $cha_upgrade_skill_no[x] != 0 && $cha_skill_spval[$partyc[@@cursorstate]][$cha_upgrade_skill_no[x]] < $cha_skill_get_val[$cha_upgrade_skill_no[x]] && $cha_old_skill_no[x] != 0 && $cha_skill_spval[$partyc[@@cursorstate]][$cha_old_skill_no[x]] >= $cha_skill_get_val[$cha_old_skill_no[x]] && $cha_skill_spval[$partyc[@@cursorstate]][x] >= $cha_skill_get_val[x] ||
            $cha_upgrade_skill_no[x] != 0 && $cha_old_skill_no[x] == 0 && $cha_skill_spval[$partyc[@@cursorstate]][$cha_upgrade_skill_no[x]] < $cha_skill_get_val[$cha_upgrade_skill_no[x]] ||
            $cha_upgrade_skill_no[x] == 0 && $cha_skill_spval[$partyc[@@cursorstate]][x] >= $cha_skill_get_val[x] ||
            $cha_skill_set_flag[$partyc[@@cursorstate]][x] == 1 && $cha_skill_get_flag[$partyc[@@cursorstate]][x] == 0) ||
            $game_variables[354] == 0 

            
            #フリー選択時はフリースキルを除外する
            if $game_switches[467] == true || @setfreeskill_flag == false || (@setfreeskill_flag == true && $cha_skill_No[x] != 34 && $cha_skill_get_flag[$partyc[@@cursorstate]][x] == 1 && $cha_typical_skill[$partyc[@@cursorstate]].index($cha_skill_No[x]) == nil && $cha_skill_same_no[$cha_typical_skill[$partyc[@@cursorstate]][0]].index($cha_skill_No[x]) == nil && $cha_skill_same_no[$cha_typical_skill[$partyc[@@cursorstate]][1]].index($cha_skill_No[x]) == nil)
              @tmp_skill_list_put_skill_no[@skill_list_put_ok_count] = x
              tmp_skill_list_put_skill_order_no[@skill_list_put_ok_count] = $cha_skill_order_no[x]
              @skill_list_put_ok_count += 1

            end
          end
    
=begin
          if ($cha_upgrade_skill_no[x] == 0 && $cha_old_skill_no[x] == 0 ||
            $cha_upgrade_skill_no[x] != 0 && $cha_skill_spval[$partyc[@@cursorstate]][$cha_upgrade_skill_no[x]] < $cha_skill_get_val[$cha_upgrade_skill_no[x]] && $cha_old_skill_no[x] != 0 && $cha_skill_spval[$partyc[@@cursorstate]][$cha_old_skill_no[x]] >= $cha_skill_get_val[$cha_old_skill_no[x]] && $cha_skill_spval[$partyc[@@cursorstate]][x] >= $cha_skill_get_val[x] ||
            $cha_upgrade_skill_no[x] != 0 && $cha_old_skill_no[x] == 0 && $cha_skill_spval[$partyc[@@cursorstate]][$cha_upgrade_skill_no[x]] < $cha_skill_get_val[$cha_upgrade_skill_no[x]] ||
            $cha_upgrade_skill_no[x] == 0 && $cha_skill_spval[$partyc[@@cursorstate]][x] >= $cha_skill_get_val[x]) || $game_variables[354] == 0
            @tmp_skill_list_put_skill_no[@skill_list_put_ok_count] = x
            tmp_skill_list_put_skill_order_no[@skill_list_put_ok_count] = $cha_skill_order_no[x]
            @skill_list_put_ok_count += 1
          end
=end
        end
      end
    end
    
    #レベル1のスキル または　次のレベルがないスキル
    #レベル2以降は取得済であるスキル
    #if $cha_upgrade_skill_no[x] == 0 || $cha_old_skill_no[x] == 0 || $cha_old_skill_no[x] != 0 && $cha_skill_spval[$partyc[@@cursorstate]][x] > $cha_skill_get_val[x]
    
    #並び順に格納しなおし
    for x in 0..@skill_list_put_ok_count - 1
      tmp_order_skill_list_put_skill_no[tmp_skill_list_put_skill_order_no[x]] = @tmp_skill_list_put_skill_no[x]
    end
    
    #配列からnil削除し、元の変数に格納しなおし
    @tmp_skill_list_put_skill_no = tmp_order_skill_list_put_skill_no.compact

  end
  #--------------------------------------------------------------------------
  # ● スキル一覧表示
  #--------------------------------------------------------------------------  
  def output_skill_list
    set_up_down_cursor
    

    @skill_list_put_count = 0
=begin
    #表示するスキル一覧
    tmp_skill_list_put_skill_no = []
    #表示するスキルの並び順
    tmp_skill_list_put_skill_order_no = []
    #並び替え用スキル一覧
    tmp_order_skill_list_put_skill_no = []
    
    #事前に対象スキル数を取得
    for x in 0..$cha_skill_count
      #nilかチェックして空欄なら0を格納
      $skill_set_get_num = Array.new(2).map{Array.new(1,0)} if $skill_set_get_num == []
      $skill_set_get_num[0][x] = 0 if $skill_set_get_num[0][x] == nil
      $skill_set_get_num[1][x] = 0 if $skill_set_get_num[1][x] == nil
      #前のレベルの配列も初期化
      $skill_set_get_num[1][$cha_old_skill_no[x]] = 0 if $skill_set_get_num[1][$cha_old_skill_no[x]] == nil
      #p $cha_skill_share[x],$skill_set_get_num[1][x]
      
      #&& $cha_skill_botu_flag[x] == 0
      #対象スキルを取得したことがある
      #ボツではない
      #レベルがあるものは前のレベルのスキルも取得したことがある
      if $skill_set_get_num[1][x] > 0 && $cha_skill_botu_flag[x] == 0 && $skill_set_get_num[1][$cha_old_skill_no[x]] > 0 || x == 0
        
        #共有スキルかスキルセット制限解除がONなら一覧に表示
        if  $cha_skill_share[x] != 0 || $game_switches[467] == true || x == 0
          #p x,$skill_set_get_num[1][x],$skill_set_get_num[1][$cha_old_skill_no[x]]
          #p $cha_skill_share[x],$game_switches[467],x,@skill_list_put_ok_count,$cha_skill_mozi_set[x]

          #if  $cha_skill_share[x] != 0 || $game_switches[467] == true || x == 0
          
          #オプションで最高レベルのみを選択
          #次のレベルがない、前もないスキル = レベル無しスキル
          #レベルアップスキルであれば次のスキルを覚えていないかつ前のスキルを覚えているかつ、自身のレベルを覚えている
          #レベルアップスキルでレベル1または2を覚えていない
          #次のレベルがない、前のレベルを覚えている、自分も覚えている = LVMAX
          if ($cha_upgrade_skill_no[x] == 0 && $cha_old_skill_no[x] == 0 ||
            $cha_upgrade_skill_no[x] != 0 && $cha_skill_spval[$partyc[@@cursorstate]][$cha_upgrade_skill_no[x]] < $cha_skill_get_val[$cha_upgrade_skill_no[x]] && $cha_old_skill_no[x] != 0 && $cha_skill_spval[$partyc[@@cursorstate]][$cha_old_skill_no[x]] >= $cha_skill_get_val[$cha_old_skill_no[x]] && $cha_skill_spval[$partyc[@@cursorstate]][x] >= $cha_skill_get_val[x] ||
            $cha_upgrade_skill_no[x] != 0 && $cha_old_skill_no[x] == 0 && $cha_skill_spval[$partyc[@@cursorstate]][$cha_upgrade_skill_no[x]] < $cha_skill_get_val[$cha_upgrade_skill_no[x]] ||
            $cha_upgrade_skill_no[x] == 0 && $cha_skill_spval[$partyc[@@cursorstate]][x] >= $cha_skill_get_val[x]) || $game_variables[354] == 0
            tmp_skill_list_put_skill_no[@skill_list_put_ok_count] = x
            tmp_skill_list_put_skill_order_no[@skill_list_put_ok_count] = $cha_skill_order_no[x]
            @skill_list_put_ok_count += 1
          end
        end
      end
    end
    
    
    #レベル1のスキル または　次のレベルがないスキル
    #レベル2以降は取得済であるスキル
    #if $cha_upgrade_skill_no[x] == 0 || $cha_old_skill_no[x] == 0 || $cha_old_skill_no[x] != 0 && $cha_skill_spval[$partyc[@@cursorstate]][x] > $cha_skill_get_val[x]
    
    
    #並び順に格納しなおし
    for x in 0..@skill_list_put_ok_count - 1
      tmp_order_skill_list_put_skill_no[tmp_skill_list_put_skill_order_no[x]] = tmp_skill_list_put_skill_no[x]
    end
    
    #配列からnil削除し、元の変数に格納しなおし
    tmp_skill_list_put_skill_no = tmp_order_skill_list_put_skill_no.compact

=end
    
    put_end = @skill_list_put_strat + Skill_list_put_max
    
    if @skill_list_put_ok_count <= put_end
      put_end = @skill_list_put_ok_count-1
    end
    #p @skill_list_put_ok_count,put_end
    for x in (@skill_list_put_strat)..put_end
      #if $skill_set_get_num[1][x] > 0 || x == 0
        #共有スキルかスキルセット制限解除がONなら一覧に表示
        #if  $cha_skill_share[x] != 0 || $game_switches[467] == true 
          #p $cha_skill_share[x],$skill_set_get_num[1][x]
          mozi = ""
          if x != 0 #0ははずす他はそのまま表示
            #if $skill_set_get_num[0][x] < 10
            #  mozi += "　"
            #end
            #mozi += $skill_set_get_num[0][x].to_s + "／"
            #if $skill_set_get_num[1][x] < 10
            #  mozi += "　"
            #end
            #mozi += $skill_set_get_num[1][x].to_s
            #mozi += "　"
            #p tmp_skill_list_put_skill_no,x
            mozi += $cha_skill_mozi_set[@tmp_skill_list_put_skill_no[x]]
          else
            mozi = "はずす"
          end
          #p mozi
          output_mozi mozi
          rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
          
          #スキルのポイント状況空欄であれば0を格納
          $cha_skill_spval[$partyc[@@cursorstate]] = [0] if $cha_skill_spval[$partyc[@@cursorstate]] == nil
          $cha_skill_spval[$partyc[@@cursorstate]][@tmp_skill_list_put_skill_no[x]] = 0 if $cha_skill_spval[$partyc[@@cursorstate]][@tmp_skill_list_put_skill_no[x]] == nil
          #セットフラグ空欄であれば0を格納
          $cha_skill_set_flag[$partyc[@@cursorstate]] = [0] if $cha_skill_set_flag[$partyc[@@cursorstate]] == nil
          $cha_skill_set_flag[$partyc[@@cursorstate]][@tmp_skill_list_put_skill_no[x]] = 0if $cha_skill_set_flag[$partyc[@@cursorstate]][@tmp_skill_list_put_skill_no[x]] == nil

          #もしまだ取得してなければ色を変える
          if $cha_skill_spval[$partyc[@@cursorstate]][@tmp_skill_list_put_skill_no[x]] < $cha_skill_get_val[@tmp_skill_list_put_skill_no[x]]
            $tec_mozi.change_tone(128,128,128)
          end
          
          #もしまだセットしたことなければ色を変える
          if $cha_skill_set_flag[$partyc[@@cursorstate]][@tmp_skill_list_put_skill_no[x]] == 0 && @tmp_skill_list_put_skill_no[x] != 0
            $tec_mozi.change_tone(255,255,255)
          end
          
          @skill_list_window.contents.blt(Skill_list_lbx+2,Skill_list_lby+(Skill_list_new_liney*(@skill_list_put_count)),$tec_mozi,rect)
          @skill_list_put_skill_no[@skill_list_put_count] = @tmp_skill_list_put_skill_no[x]
          @skill_list_put_count += 1
        #end
      #end
    end
    
    #スキル一覧カーソル表示
    if @skill_list_put_strat > 0
      @up_cursor.visible = true
    else
      @up_cursor.visible = false
    end
    
    if @skill_list_put_count + @skill_list_put_strat < @skill_list_put_ok_count &&
      @window_state != 10
      @down_cursor.visible = true
    else
      @down_cursor.visible = false
    end
  end
  #--------------------------------------------------------------------------
  # ● スキル説明表示
  #--------------------------------------------------------------------------  
  def output_skill_memo
    
    #スキル説明を表示する
    if @window_state == 2 || @window_state == 8 || @window_state == 11
      tmp_x = 0
      tmp_skill_no = 0
      if @skill_cursorstate < 3
        tmp_x = @skill_cursorstate
        tmp_skill_no = $cha_typical_skill[$partyc[@@cursorstate]][tmp_x]
      else
        tmp_x = @skill_cursorstate - 3
        tmp_skill_no = $cha_add_skill[$partyc[@@cursorstate]][tmp_x]
      end
      
      if tmp_skill_no == 0
        mozi = "なにも　セットしていないぞ！"
      else
        #スキルの説明を取得
        mozi = get_cha_skill_manual tmp_skill_no

      end
      
    elsif @window_state == 3 || @window_state == 10 || @window_state == 12
      if @skill_list_cursorstate + @skill_list_put_strat == 0 #はずすの場合
        mozi = "セットしている　スキルを　はずすぞ！"
      else
        #p @skill_list_cursorstate,@skill_list_put_strat
        tmp_x = @skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat] #+ @skill_list_put_strat
        #スキルの説明を取得
        mozi = get_cha_skill_manual tmp_x
      end
    end
    
    text_list=[]
    x = 0
    text = mozi.gsub("\\n","\n")
    
    text.each_line {|line| #改行を読み取り複数行表示する
          line.sub!("￥n", "") # ￥は半角に直す
          line = line.gsub("\r", "")#改行コード？が文字化けするので削除
          line = line.gsub("\n", "")#
          line = line.gsub(" ", "")#半角スペースも削除
          text_list[x]=line
          #p text,text_list[x]
          x += 1
          
          }
    
    for y in 0..x-1
      output_mozi text_list[y]
      #p text_list[y].length# > 59
        #p "説明文が欠けている可能性があります"
      #end
      rect = Rect.new(16*0,16*0, 16*text_list[y].split(//u).size,24)
      @skill_memo_window.contents.blt(0,24*y,$tec_mozi,rect)
    end
    #output_mozi mozi
    #rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    #@skill_memo_window.contents.blt(0,0,$tec_mozi,rect)
  end
  #--------------------------------------------------------------------------
  # ● 必殺技表示
  # 　 カーソル上キャラのスキル一覧を取得する。(表示の詳細は"_detail")
  #-------------------------------------------------------------------------- 
  def output_technique #必殺技表示

    set_up_down_cursor
    picture = Cache.picture("メニュー文字関係")
    rect = Rect.new(0, 312, 112, 20)
    tyousei_y = 8
    @technique_window.contents.blt(Techniquex,Techniquey,picture,rect)
    
    if @display_skill_level == -1 #使用気表示
      rect = Rect.new(0, 336, 112, 20)
      @technique_window.contents.blt(Techniquex+164+14,Techniquey,picture,rect)
    else #技使用回数表示
      rect = Rect.new(0, 356, 112, 20)
      @technique_window.contents.blt(Techniquex+176+14,Techniquey,picture,rect)
    end
    tecput_page_strat = @tecput_page * @tecput_max
    
    if $game_actors[$partyc[@@cursorstate]].skills.size - 1 < (@tecput_page + 1) * @tecput_max
      tecput_end = $game_actors[$partyc[@@cursorstate]].skills.size - 1
    else
      tecput_end = (@tecput_page+1)*@tecput_max - 1
    end
    
    if $game_actors[$partyc[@@cursorstate]].skills.size > (@tecput_page + 1) * @tecput_max && @display_skill_window == -1
      @down_cursor.visible = true
    else
      @down_cursor.visible = false
    end
    
    if @tecput_page > 0 && @display_skill_window == -1
      @up_cursor.visible = true
    else
      @up_cursor.visible = false
    end
    for x in tecput_page_strat..tecput_end
      
      rect = output_technique_detail $game_actors[$partyc[@@cursorstate]].skills[x].id
      #rect = output_technique_detail @@cursorstate,x
      #picture = Cache.picture("文字_必殺技")
      picture = $tec_mozi #必殺技文字列化
      #@technique_window.contents.blt(Techniquex,Techniquey+24+Techniquenamey * x,picture,rect)
      @technique_window.contents.blt(Techniquex,Techniquey+24+Techniquenamey * (x-tecput_page_strat)+tyousei_y,$tec_mozi,rect)
      picture = Cache.picture("数字英語")
      
      if @display_skill_level == -1 #使用気表示
        tec_mp_cost = get_mp_cost $partyc[@@cursorstate],$game_actors[$partyc[@@cursorstate]].skills[x].id,0
        #p tec_mp_cost,$partyc[@@cursorstate],$game_actors[$partyc[@@cursorstate]].skills[x].id
        #p tec_mp_cost

        for y in 1..tec_mp_cost.to_s.size
        rect = Rect.new(tec_mp_cost.to_s[-y,1].to_i*16, 0, 16, 16)
          #for y in 1..$game_actors[$partyc[@@cursorstate]].skills[x].mp_cost.to_s.size #KI消費量
        #rect = Rect.new($game_actors[$partyc[@@cursorstate]].skills[x].mp_cost.to_s[-y,1].to_i*16, 0, 16, 16)
        @technique_window.contents.blt(Techniquex+226-(y-1)*16+14,Techniquey+32+Techniquenamey * (x-tecput_page_strat)+tyousei_y,picture,rect)
        end
      else #技使用回数表示
        
        if $cha_skill_level[$game_actors[$partyc[@@cursorstate]].skills[x].id] == nil
          $cha_skill_level[$game_actors[$partyc[@@cursorstate]].skills[x].id] = 0
        end
        for y in 1..$cha_skill_level[$game_actors[$partyc[@@cursorstate]].skills[x].id].to_s.size #熟練度
            if $cha_skill_level[$game_actors[$partyc[@@cursorstate]].skills[x].id].to_s.size < 5
              #4桁以内
              rect = Rect.new($cha_skill_level[$game_actors[$partyc[@@cursorstate]].skills[x].id].to_s[-y,1].to_i*16, 0, 16, 16)
              @technique_window.contents.blt(Techniquex+226-(y-1)*16+14,Techniquey+32+Techniquenamey * (x-tecput_page_strat)+tyousei_y,picture,rect)
            else
              #5桁
              case y
              
              when 1..2
                rect = Rect.new($cha_skill_level[$game_actors[$partyc[@@cursorstate]].skills[x].id].to_s[-y,1].to_i*8, 168, 8, 16)
                @technique_window.contents.blt(Techniquex+226-(y-1)*8+14+8,Techniquey+32+Techniquenamey * (x-tecput_page_strat)+tyousei_y,picture,rect)
              else
                rect = Rect.new($cha_skill_level[$game_actors[$partyc[@@cursorstate]].skills[x].id].to_s[-y,1].to_i*16, 0, 16, 16)
                @technique_window.contents.blt(Techniquex+226-(y-1)*16+14+16,Techniquey+32+Techniquenamey * (x-tecput_page_strat)+tyousei_y,picture,rect)
              end
            end
        end
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 能力詳細表示
  #--------------------------------------------------------------------------   
  def output_status
    
    tyouseix = 32
    #picture = Cache.picture($top_file_name+"顔味方")
    if ($game_actors[$partyc[@@cursorstate]].hp.prec_f / $game_actors[$partyc[@@cursorstate]].maxhp.prec_f * 100).prec_i < $hinshi_hp || $chadead[@@cursorstate] == true#&& @call_state == 1
      rect,picture = set_character_face 1,$partyc[@@cursorstate]-3
      #  rect = Rect.new(64, 0+(($partyc[@@cursorstate]-3)*64), 64, 64) # 顔グラ
    else
      rect,picture = set_character_face 0,$partyc[@@cursorstate]-3
    #  rect = Rect.new(0, 0+(($partyc[@@cursorstate]-3)*64), 64, 64) # 顔グラ
    end
    @status_window.contents.blt(Status_lbx-16,Status_lby,picture,rect)
    
    if @call_state == 1 #戦闘時に呼び出されていたら
      #かなしばり回数
      #オプションで表示全てか敵のみか
      if $game_variables[356] == 0 || $game_variables[356] == 1
      
        if $cha_stop_num[@@cursorstate] != 0 && $chadead[@@cursorstate] == false
          picture = Cache.picture("数字英語")
          #p $ene_stop_num[x].to_s.size,$ene_stop_num[x]
          
          for y in 1..$cha_stop_num[@@cursorstate].to_s.size
            rect = Rect.new($cha_stop_num[@@cursorstate].to_s[-y,1].to_i*16, 48, 16, 16)
            @status_window.contents.blt(Status_lbx-16+48 - (y-1)*16 ,Status_lby+48,picture,rect)
          end
          
        end
      end
    end
    
=begin
    #攻撃防御アップ
    #顔グラの横に変更
    if $cha_power_up[@@cursorstate] == true # パワーアップアイコン表示
      picture = Cache.picture("アイコン")
      rect = Rect.new(0, 16, 32, 32)
      @status_window.contents.blt(Status_lbx-16+64,Status_lby-4,picture,rect)
    end
    
    if $one_turn_cha_defense_up == true # ディフェンスアップアイコン表示
      picture = Cache.picture("アイコン")
      rect = Rect.new(32, 16, 32, 32)
      @status_window.contents.blt(Status_lbx-16+64,Status_lby-4 + 32,picture,rect)
    end
    
    if $cha_defense_up[@@cursorstate] == true
      picture = Cache.picture("アイコン")
      rect = Rect.new(32, 16, 32, 32)
      @status_window.contents.blt(Status_lbx-16+64,Status_lby-4 + 32,picture,rect)
    end
=end
    picture = Cache.picture("カード関係")
    rect = set_card_frame 4 # 流派枠
    @status_window.contents.blt(Status_lbx-16 ,Status_lby+64,picture,rect)
    rect = Rect.new(32*($game_actors[$partyc[@@cursorstate]].class_id-1), 64, 32, 32) # 流派
    @status_window.contents.blt(Status_lbx,Status_lby+64,picture,rect)
    picture = Cache.picture("数字英語")
    rect = Rect.new(64, 16, 32, 16) #LV
    @status_window.contents.blt(Status_lbx+80 + tyouseix ,Status_lby+4,picture,rect)
    rect = Rect.new(0, 16, 32, 16) #HP
    @status_window.contents.blt(Status_lbx+80 + tyouseix ,Status_lby+22,picture,rect) 
    rect = Rect.new(32, 16, 32, 16) #KI
    @status_window.contents.blt(Status_lbx+80 + tyouseix ,Status_lby+58,picture,rect)
    rect = Rect.new(160, 0, 16, 16) # スラッシュ
    @status_window.contents.blt(Status_lbx+128 + tyouseix,Status_lby+40,picture,rect)
    @status_window.contents.blt(Status_lbx+128 + tyouseix,Status_lby+76,picture,rect)

    for y in 1..$game_actors[$partyc[@@cursorstate]].level.to_s.size #LV
      #if $game_actors[$partyc[@@cursorstate]].level.to_s.size <= 3 #LV3桁 通常
        rect = Rect.new($game_actors[$partyc[@@cursorstate]].level.to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix,Status_lby+4,picture,rect)
      #else
      #  case y
      #        
      #  when 1..2
      #    rect = Rect.new($game_actors[$partyc[@@cursorstate]].level.to_s[-y,1].to_i*8, 168, 8, 16)
      #    @status_window.contents.blt(Status_lbx+192-(y-1)*8 + tyouseix + 8,Status_lby+4,picture,rect)
      #  else
      #    rect = Rect.new($game_actors[$partyc[@@cursorstate]].level.to_s[-y,1].to_i*16, 0, 16, 16)
      #    @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix + 16,Status_lby+4,picture,rect)
      #  end
      #end
    end
    
    for y in 1..$game_actors[$partyc[@@cursorstate]].hp.to_s.size #HP
      
      if $game_actors[$partyc[@@cursorstate]].hp.to_s.size <= 4 #HP4桁
        rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].hp.to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix,Status_lby+22,picture,rect)
      else
        case y
        
        when 1..2
          rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].hp.to_s[-y,1].to_i*8, 168, 8, 16)
          @status_window.contents.blt(Status_lbx+192-(y-1)*8 + tyouseix + 8,Status_lby+22,picture,rect)
        else
          rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].hp.to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix + 16,Status_lby+22,picture,rect)

        end
      end
    end
    
    for y in 1..$game_actors[$partyc[@@cursorstate]].maxhp.to_s.size #MHP
      
      if $game_actors[$partyc[@@cursorstate]].maxhp.to_s.size <= 4 #MHP4桁
        rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].maxhp.to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix,Status_lby+40,picture,rect)
      else
        case y
              
        when 1..2
          rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].maxhp.to_s[-y,1].to_i*8, 168, 8, 16)
          @status_window.contents.blt(Status_lbx+192-(y-1)*8 + tyouseix + 8,Status_lby+40,picture,rect)
        else
          rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].maxhp.to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix + 16,Status_lby+40,picture,rect)
        end
        
      end
    end
    
    for y in 1..$game_actors[$partyc[@@cursorstate]].mp.to_s.size #ki
      
      if $game_actors[$partyc[@@cursorstate]].mp.to_s.size <= 4 #KI4桁
        rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].mp.to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix,Status_lby+58,picture,rect)
      else
        case y
              
        when 1..2
          rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].mp.to_s[-y,1].to_i*8, 168, 8, 16)
          @status_window.contents.blt(Status_lbx+192-(y-1)*8 + tyouseix + 8,Status_lby+58,picture,rect)

        else
          rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].mp.to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix + 16,Status_lby+58,picture,rect)

        end
      end
    end
    
    for y in 1..$game_actors[$partyc[@@cursorstate]].maxmp.to_s.size #mki
      
      if $game_actors[$partyc[@@cursorstate]].maxmp.to_s.size <= 4 #MKI4桁
        rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].maxmp.to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix,Status_lby+76,picture,rect)
      else
        case y
              
        when 1..2
          rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].maxmp.to_s[-y,1].to_i*8, 168, 8, 16)
          @status_window.contents.blt(Status_lbx+192-(y-1)*8 + tyouseix + 8,Status_lby+76,picture,rect)

        else
          rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].maxmp.to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix + 16,Status_lby+76,picture,rect)
        end
      end
    end
    
    if @display_skill_window == -1
      #for y in 1..$data_actors[$partyc[@@cursorstate]].parameters[2,$game_actors[$partyc[@@cursorstate]].level].to_s.size #攻撃力
      #  rect = Rect.new(0+$data_actors[$partyc[@@cursorstate]].parameters[2,$game_actors[$partyc[@@cursorstate]].level].to_s[-y,1].to_i*16, 0, 16, 16)
      for y in 1..$game_actors[$partyc[@@cursorstate]].atk.to_s.size #攻撃力
        rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].atk.to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix,Status_lby+100,picture,rect)
      end

      #for y in 1..$data_actors[$partyc[@@cursorstate]].parameters[3,$game_actors[$partyc[@@cursorstate]].level].to_s.size #防御力
      #  rect = Rect.new(0+$data_actors[$partyc[@@cursorstate]].parameters[3,$game_actors[$partyc[@@cursorstate]].level].to_s[-y,1].to_i*16, 0, 16, 16)
      for y in 1..$game_actors[$partyc[@@cursorstate]].def.to_s.size #防御力
        rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].def.to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix,Status_lby+124,picture,rect)
      end
      
      #for y in 1..$data_actors[$partyc[@@cursorstate]].parameters[5,$game_actors[$partyc[@@cursorstate]].level].to_s.size #スピード
      #  rect = Rect.new(0+$data_actors[$partyc[@@cursorstate]].parameters[5,$game_actors[$partyc[@@cursorstate]].level].to_s[-y,1].to_i*16, 0, 16, 16)
      for y in 1..$game_actors[$partyc[@@cursorstate]].agi.to_s.size #スピード
        rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].agi.to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix,Status_lby+148,picture,rect)
      end
      
       
      for y in 1..$game_actors[$partyc[@@cursorstate]].exp.to_s.size #経験値
        if $game_actors[$partyc[@@cursorstate]].exp.to_s.size <= 11
          rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].exp.to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix,Status_lby+172,picture,rect)
        else
          case y
                
          when 1..4
            rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].exp.to_s[-y,1].to_i*8, 168, 8, 16)
            @status_window.contents.blt(Status_lbx+192-(y-1)*8 + tyouseix + 8,Status_lby+172,picture,rect)
          else
            rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].exp.to_s[-y,1].to_i*16, 0, 16, 16)
            @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix + 32,Status_lby+172,picture,rect)
          end
          
        end
      end
      
      if $game_actors[$partyc[@@cursorstate]].level != $actor_final_level_default #最大レベルだとうまく表示されないので処理を入れる
        for y in 1..$game_actors[$partyc[@@cursorstate]].next_rest_exp_s.to_s.size #次のレベルまでの経験値
          rect = Rect.new(0+$game_actors[$partyc[@@cursorstate]].next_rest_exp_s.to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix,Status_lby+196,picture,rect)
        end
      else
          rect = Rect.new(0, 0, 16, 16)
          @status_window.contents.blt(Status_lbx+192 + tyouseix,Status_lby+196,picture,rect)
      end
      
      #能力項目
      picture = Cache.picture("メニュー文字関係")
      rect = Rect.new(0, 192, 112, 128)
      @status_window.contents.blt(Status_lbx-16,Status_lby+96,picture,rect)
    else
      
      #撃破数がnilの場合0をセット
      $cha_defeat_num[$partyc[@@cursorstate]] = 0 if $cha_defeat_num[$partyc[@@cursorstate]] == nil
      
      for y in 1..$cha_defeat_num[$partyc[@@cursorstate]].to_s.size #撃破数
          rect = Rect.new(0+$cha_defeat_num[$partyc[@@cursorstate]].to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix,Status_lby+100+(0*24),picture,rect)
      end
      
      #ZPがnilの場合0をセット
      $zp[$partyc[@@cursorstate]] = 0 if $zp[$partyc[@@cursorstate]] == nil
      
      for y in 1..$zp[$partyc[@@cursorstate]].to_s.size #撃破数
        rect = Rect.new(0+$zp[$partyc[@@cursorstate]].to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix,Status_lby+100+(1*24),picture,rect)
      end
      
      #通常攻撃がnilの場合0をセット
      $cha_normal_attack_level[$partyc[@@cursorstate]] = 0 if $cha_normal_attack_level[$partyc[@@cursorstate]] == nil
      
      for y in 1..$cha_normal_attack_level[$partyc[@@cursorstate]].to_s.size #通常攻撃数
        rect = Rect.new(0+$cha_normal_attack_level[$partyc[@@cursorstate]].to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(Status_lbx+192-(y-1)*16 + tyouseix,Status_lby+100+(2*24),picture,rect)
      end
      
      picture = Cache.picture("メニュー文字関係")
      #撃破数
      mozi = "げきはすう"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @status_window.contents.blt(Status_lbx-14,Status_lby+96-4,$tec_mozi,rect)
      #@msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
      #rect = Rect.new(0, 376, 112, 20)
      #@status_window.contents.blt(Status_lbx-16,Status_lby+96,picture,rect)
      
      #ZP
      mozi = "ZP"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @status_window.contents.blt(Status_lbx-14,Status_lby+96-4+24,$tec_mozi,rect)
      
      #通常攻撃回数
      mozi = "つうじょうこうげきすう"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @status_window.contents.blt(Status_lbx-14,Status_lby+96-4+24+24,$tec_mozi,rect)
      
      #固有スキル
      mozi = "こゆうスキル"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @status_window.contents.blt(Status_lbx-16,Typ_skill_lby+(0*24),$tec_mozi,rect)
      #rect = Rect.new(0, 396, 112, 20)
      #@status_window.contents.blt(Status_lbx-16,Typ_skill_lby+(0*24),picture,rect)
      
      #ついかスキル
      mozi = "ついかスキル"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @status_window.contents.blt(Status_lbx-16,Add_skill_lby+(0*24),$tec_mozi,rect)
      
      
      set_skill_nil_to_zero $partyc[@@cursorstate]
      #空欄の時は0をセット
      #$cha_typical_skill[$partyc[@@cursorstate]] = [0] if $cha_typical_skill[$partyc[@@cursorstate]] == nil
      
      #tmp_typical_skill = $cha_typical_skill[$partyc[@@cursorstate]]
      
      
      #SPnilかチェック
      #if $cha_skill_spval == []
      #  $cha_skill_spval = Array.new(255).map{Array.new(1,0)}
      #end
        
      for x in 0..$cha_typical_skill[$partyc[@@cursorstate]].size-1
        #スキル名
        
        case x
        
        when 0
          lstmozi = "１"
        when 1
          lstmozi = "２"
        when 2
          lstmozi = "３"
        when 3
          lstmozi = "４"
        end
        
        if $cha_typical_skill[$partyc[@@cursorstate]][x] > 0
          output_mozi lstmozi
          rect = Rect.new(16*0,16*0, 16*lstmozi.split(//u).size,24)
          @status_window.contents.blt(Status_lbx+2,Typ_skill_lby+24+Skill_new_liney*x,$tec_mozi,rect)
        end
        
        #mozi = $cha_skill_mozi_set[tmp_typical_skill[x]]
        mozi = $cha_skill_mozi_set[$cha_typical_skill[$partyc[@@cursorstate]][x]]
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        

        if $cha_skill_spval[$partyc[@@cursorstate]][$cha_typical_skill[$partyc[@@cursorstate]][x]] == nil
          $cha_skill_spval[$partyc[@@cursorstate]][$cha_typical_skill[$partyc[@@cursorstate]][x]] = 0
          #$cha_skill_spval[$partyc[@@cursorstate]][tmp_typical_skill[x]] += 300
          #$cha_skill_spval[$partyc[@@cursorstate]][tmp_typical_skill[x]] = 0
        end
        
        #スキルが取得済みかチェックし取得済みならスキル名のみ表示し未取得ならスキル名を薄くしSPも表示
        #if $cha_skill_spval[$partyc[@@cursorstate]][$cha_typical_skill[$partyc[@@cursorstate]][x]] < $cha_skill_get_val[$cha_typical_skill[$partyc[@@cursorstate]][x]] || $cha_typical_skill[$partyc[@@cursorstate]][x] == 1
        #  $tec_mozi.change_tone(128,128,128)
        #end
        
        @status_window.contents.blt(Status_lbx+4+16,Typ_skill_lby+24+Skill_new_liney*x,$tec_mozi,rect)
=begin
        if $cha_typical_skill[$partyc[@@cursorstate]][x] > 1
          
          
          #SP
          mozi = $cha_skill_spval[$partyc[@@cursorstate]][$cha_typical_skill[$partyc[@@cursorstate]][x]].to_s
          mozi += "／"
          mozi += $cha_skill_get_val[$cha_typical_skill[$partyc[@@cursorstate]][x]].to_s
          output_mozi mozi
          rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
          
          #スキルが取得済みかチェックし取得済みならスキル名のみ表示し未取得ならスキル名を薄くしSPも表示
          if $cha_skill_spval[$partyc[@@cursorstate]][$cha_typical_skill[$partyc[@@cursorstate]][x]] < $cha_skill_get_val[$cha_typical_skill[$partyc[@@cursorstate]][x]]
            $tec_mozi.change_tone(128,128,128)
          end
          
          @status_window.contents.blt(Status_lbx+4+16,Typ_skill_lby+44+Skill_new_liney*x,$tec_mozi,rect)
        end
=end
        #else
        #  @status_window.contents.blt(Status_lbx-16,Typ_skill_lby+24+Skill_new_liney*x,$tec_mozi,rect)
        #end
      end
      
#追加スキル
      #空欄の時は0をセット
      $cha_add_skill[$partyc[@@cursorstate]] = [0,0] if $cha_add_skill[$partyc[@@cursorstate]] == nil
      #$cha_add_skill[$partyc[@@cursorstate]][0] = 7
      #$cha_add_skill[$partyc[@@cursorstate]][1] = 8
      #追加スキル
      for x in 0..2 #$cha_add_skill[$partyc[@@cursorstate]].size-1
        #スキル名
        
        case x
        
        when 0
          lstmozi = "１"
        when 1
          lstmozi = "２"
        when 2
          lstmozi = "３"
        when 3
          lstmozi = "４"
        end
        
        if $cha_add_skill_set_num[$partyc[@@cursorstate]] <= x
          lstmozi = ""
        end
        #if $cha_add_skill[$partyc[@@cursorstate]][x] > 0
          output_mozi lstmozi
          rect = Rect.new(16*0,16*0, 16*lstmozi.split(//u).size,24)
          @status_window.contents.blt(Status_lbx+2,Add_skill_lby+24+Add_typ_Skill_new_liney*x,$tec_mozi,rect)
        #end
        
        #nilのための初期化
        $cha_add_skill[$partyc[@@cursorstate]][x] = 0 if $cha_add_skill[$partyc[@@cursorstate]][x] == nil 
        #mozi = $cha_skill_mozi_set[tmp_typical_skill[x]]
        temp_skillno = $cha_add_skill[$partyc[@@cursorstate]][x]
        mozi = $cha_skill_mozi_set[temp_skillno]
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        
        #スキル名は現在のスキルを表示したいのでスキル名表示あとに切り替え
        if $cha_skill_spval[$partyc[@@cursorstate]][temp_skillno] == nil
          $cha_skill_spval[$partyc[@@cursorstate]][temp_skillno] = 0
        end
        
        #スキルが取得済みかチェックし取得済みならスキル名のみ表示し未取得ならスキル名を薄くしSPも表示
        if $cha_skill_spval[$partyc[@@cursorstate]][temp_skillno] < $cha_skill_get_val[temp_skillno] || temp_skillno == 1
          $tec_mozi.change_tone(128,128,128)
        end
        
        @status_window.contents.blt(Status_lbx+4+16,Add_skill_lby+24+Add_typ_Skill_new_liney*x,$tec_mozi,rect)
        
        if temp_skillno > 1
          run_nextskill = false
          if chk_run_next_add_skill ($partyc[@@cursorstate],temp_skillno,true) == true
            temp_skillno = $cha_upgrade_skill_no[temp_skillno]
            run_nextskill = true
          end
          #SP
          mozi = ""
          
          $cha_skill_get_flag[$partyc[@@cursorstate]][$cha_upgrade_skill_no[temp_skillno]] == 0
          
          if run_nextskill == true #次のスキルなら文字を加える
            mozi = "lUP："
          elsif $cha_skill_get_flag[$partyc[@@cursorstate]][temp_skillno] == 1
            #自スキルで取得済みであれば
            mozi = "MAX："
          else
            #自スキルで取得中であれば
            mozi = "GET："
          end
          mozi += $cha_skill_spval[$partyc[@@cursorstate]][temp_skillno].to_s
          mozi += "／"
          mozi += $cha_skill_get_val[temp_skillno].to_s
          output_mozi mozi
          rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
          
          #スキルが取得済みかチェックし取得済みならスキル名のみ表示し未取得ならスキル名を薄くしSPも表示
          #次のレベル取得中も黒にする
          if $cha_skill_spval[$partyc[@@cursorstate]][temp_skillno] < $cha_skill_get_val[temp_skillno] && run_nextskill == false
            $tec_mozi.change_tone(128,128,128)
          end
          
          @status_window.contents.blt(Status_lbx+4+16,Add_skill_lby+44+Add_typ_Skill_new_liney*x,$tec_mozi,rect)
        end

        #else
        #  @status_window.contents.blt(Status_lbx-16,Add_skill_lby+24+Skill_new_liney*x,$tec_mozi,rect)
        #end
      end
      
    end
  end

  #--------------------------------------------------------------------------
  # ● パーティー一覧表示
  #-------------------------------------------------------------------------- 
  def output_party
    
    tyousei_x = 6
    picturea = Cache.picture("名前")
    pictureb = Cache.picture("数字英語")
    #picturec = Cache.picture("Z1_顔味方")
    picturec = Cache.picture("アイコン")
    rect = Rect.new(128, 16, 32, 16) #No
    @party_window.contents.blt(Partynox+16 ,Partynoy-32,pictureb,rect)
    rect = Rect.new(64, 16, 32, 16) #LV
    @party_window.contents.blt(Partynox+136 ,Partynoy-32,pictureb,rect)
    rect = Rect.new(0, 16, 32, 16) #HP
    @party_window.contents.blt(Partynox+192 -tyousei_x,Partynoy-32,pictureb,rect) 
    rect = Rect.new(32, 16, 32, 16) #KI
    @party_window.contents.blt(Partynox+280-tyousei_x,Partynoy-32,pictureb,rect) 

    for x in 0..$partyc.size-1
      
      rect = Rect.new((x+1)*16, 48, 16, 16) #No
      @party_window.contents.blt(Partynox+18,Partynoy+x*Partyy,pictureb,rect)

      rect = Rect.new(0, 0+(($partyc[x]-3)*16), 160, 16) # 名前
      @party_window.contents.blt(Partynox+36,Partynoy+x*Partyy,picturea,rect)
      
      #
      put_dtype_flag = false
      put_dtype_mozi = ""
      #ドレスタイプ出力判定
      case $partyc[x]
      
      when 3,14 #悟空
        if $game_variables[40] == 2 && $game_switches[440] == true
          put_dtype_flag = true
          
          if $game_variables[171] == 0
            #武道着
            put_dtype_mozi = "N"
          elsif $game_variables[171] == 1
            #武道着(ボロボロ)
            put_dtype_mozi = "T"           
          elsif $game_variables[171] == 2
            #武道着(さらにボロボロ)
            put_dtype_mozi = "T2"           
          elsif $game_variables[171] == 3
            #バトルスーツ
            put_dtype_mozi = "B"
            
          else
            
          end
        end
      when 5,18 #悟飯
      
        #Z2 かつ　バトルスーツ取得
        if $game_variables[40] == 1 && $game_switches[439] == true
          put_dtype_flag = true
          
          if $game_variables[161] == 0
            #武道着
            put_dtype_mozi = "N"
            
          elsif $game_variables[161] == 1
            #バトルスーツ
            put_dtype_mozi = "B"
            
          else
            
          end
        elsif $game_variables[40] == 2 && $game_switches[441] == true && $game_switches[443] == true && $game_switches[445] == false 
          #Z3 超サイヤ人になってなければ
          put_dtype_flag = true
          if $game_variables[172] == 0
            #武道着
            put_dtype_mozi = "N"
          elsif $game_variables[172] == 1
            #バトルスーツ
            put_dtype_mozi = "B"           
          else
            put_dtype_mozi = "N"
          end
        elsif $game_variables[40] == 2 && $game_switches[441] == true && $game_switches[445] == true && $game_switches[447] == true
          put_dtype_flag = true
          if $game_variables[172] == 0
            #武道着
            put_dtype_mozi = "N"
          elsif $game_variables[172] == 2
            #武道着赤
            put_dtype_mozi = "NR"           
          else
            put_dtype_mozi = "N"
          end
        end
      when 6 #クリリン  
        #Z2 かつ　バトルスーツ取得
        if $game_variables[40] == 1 && $game_switches[439] == true
          put_dtype_flag = true
          
          if $game_variables[162] == 0
            #武道着
            put_dtype_mozi = "N"
            
          elsif $game_variables[162] == 1
            #バトルスーツ
            put_dtype_mozi = "B"
            
          else
            
          end
        end
        
      when 17,20 #トランクス
        if $game_variables[40] == 2 && $game_switches[442] == true
          put_dtype_flag = true
          case $game_variables[173]
          
          when 0 #短髪私服            
            put_dtype_mozi = "N"
          when 1 #バトルスーツ
            put_dtype_mozi = "B"       
          when 2 #タンクトップ
            put_dtype_mozi = "T"
          when 3 #長髪私服
            put_dtype_mozi = "TL"
          when 4 #長髪私服
            put_dtype_mozi = "NL"
          end
        end
        
      when 21 #18号
        put_dtype_flag = true
        case $game_variables[177]
        when 0 #      
          put_dtype_mozi = "N"
        when 1 #着せ替え
          put_dtype_mozi = "S"
        end
      when 24 #亀仙人
        put_dtype_flag = true
        
        if $game_switches[363] == false
          #武道着
          put_dtype_mozi = "N"
        else
          #普段着
          put_dtype_mozi = "S"
        end
      end
        
      #ドレスタイプ出力
      if put_dtype_flag == true
        rect = Rect.new(16*23, 0, 16, 16) # D
        @party_window.contents.blt(Partynox+4+16*3,Partynoy+x*Partyy-16,pictureb,rect) 
        rect = Rect.new(16*25, 0, 16, 16) # ：
        @party_window.contents.blt(Partynox+4+16*4,Partynoy+x*Partyy-16,pictureb,rect)
        
        mozi = put_dtype_mozi.to_s

        case mozi
        
        when "N"
          rect = Rect.new(16*8, 16, 16, 16) # N
          @party_window.contents.blt(Partynox+4+16*5,Partynoy+x*Partyy-16,pictureb,rect)
        when "B"
          rect = Rect.new(16*14, 16, 16, 16) # B
          @party_window.contents.blt(Partynox+4+16*5,Partynoy+x*Partyy-16,pictureb,rect)
        when "S"
          rect = Rect.new(16*12, 16, 16, 16) # S
          @party_window.contents.blt(Partynox+4+16*5,Partynoy+x*Partyy-16,pictureb,rect)

        when "T"
          rect = Rect.new(16*25, 16, 16, 16) # T
          @party_window.contents.blt(Partynox+4+16*5,Partynoy+x*Partyy-16,pictureb,rect)  
        when "TL"
          rect = Rect.new(16*25, 16, 16, 16) # T
          @party_window.contents.blt(Partynox+4+16*5,Partynoy+x*Partyy-16,pictureb,rect)  
          rect = Rect.new(16*4, 16, 16, 16) # L
           @party_window.contents.blt(Partynox+4+16*6,Partynoy+x*Partyy-16,pictureb,rect)  
        when "T2"
          rect = Rect.new(16*25, 16, 16, 16) # T
          @party_window.contents.blt(Partynox+4+16*5,Partynoy+x*Partyy-16,pictureb,rect)  
          rect = Rect.new(16*2, 0, 16, 16) # 2
           @party_window.contents.blt(Partynox+4+16*6,Partynoy+x*Partyy-16,pictureb,rect)  
        when "NL"
          rect = Rect.new(16*8, 16, 16, 16) # N
          @party_window.contents.blt(Partynox+4+16*5,Partynoy+x*Partyy-16,pictureb,rect)  
          rect = Rect.new(16*4, 16, 16, 16) # L
          @party_window.contents.blt(Partynox+4+16*6,Partynoy+x*Partyy-16,pictureb,rect)  
        when "NR"
          rect = Rect.new(16*8, 16, 16, 16) # N
          @party_window.contents.blt(Partynox+4+16*5,Partynoy+x*Partyy-16,pictureb,rect)  
          rect = Rect.new(16*26, 16, 16, 16) # R
          @party_window.contents.blt(Partynox+4+16*6,Partynoy+x*Partyy-16,pictureb,rect)  
        end
      end
        
      if $game_variables[104] == get_ori_cha_no($partyc[x]) #お気に入りキャラかチェック
        rect = Rect.new(29*16, 0, 16, 16)
        @party_window.contents.blt(Partynox+4+16*2,Partynoy+x*Partyy-16,picturec,rect) 
      end
      
      if $chadead[x] == true #死亡状態表示
        rect = Rect.new(48, 0, 16, 16)
        @party_window.contents.blt(Partynox+4+16*3,Partynoy+x*Partyy-16,picturec,rect) 
      end
      
      #顔グラの横に変更
      if $cha_power_up[x] == true # パワーアップアイコン表示
        rect = Rect.new(64, 0, 16, 16) # パワーアップアイコン
        @party_window.contents.blt(Partynox+4+16*4,Partynoy+x*Partyy-16,picturec,rect) 
      end
      
      if $one_turn_cha_defense_up == true # ディフェンスアップアイコン表示
        rect = Rect.new(112, 0, 16, 16) # ディフェンスーアップアイコン
        @party_window.contents.blt(Partynox+4+16*5,Partynoy+x*Partyy-16,picturec,rect) 
      end
      
      if $cha_defense_up[x] == true
        rect = Rect.new(128, 0, 16, 16) # ディフェンスーアップアイコン
        @party_window.contents.blt(Partynox+4+16*5,Partynoy+x*Partyy-16,picturec,rect) 
      end
      
      rect = Rect.new(160, 0, 16, 16) # スラッシュ
      @party_window.contents.blt(Partynox+176-tyousei_x,Partynoy+x*Partyy+18,pictureb,rect)
      @party_window.contents.blt(Partynox+264-tyousei_x,Partynoy+x*Partyy+18,pictureb,rect)
      
      for y in 1..$game_actors[$partyc[x]].level.to_s.size #LV
        if $game_actors[$partyc[x]].level.to_s.size <= 3 #LV3桁 通常
          rect = Rect.new($game_actors[$partyc[x]].level.to_s[-y,1].to_i*16, 0, 16, 16)
          @party_window.contents.blt(Partynox+152-(y-1)*16,Partynoy+x*Partyy,pictureb,rect)
        else
          case y
                
          when 1..2
            rect = Rect.new($game_actors[$partyc[x]].level.to_s[-y,1].to_i*8, 168, 8, 16)
            @party_window.contents.blt(Partynox+152-(y-1)*8 + 8,Partynoy+x*Partyy,pictureb,rect)
          else
            rect = Rect.new($game_actors[$partyc[x]].level.to_s[-y,1].to_i*16, 0, 16, 16)
            @party_window.contents.blt(Partynox+152-(y-1)*16 + 16,Partynoy+x*Partyy,pictureb,rect)
          end
        end
      end      
      
      for y in 1..$game_actors[$partyc[x]].hp.to_s.size #HP
        
        if $game_actors[$partyc[x]].hp.to_s.size <= 4 #HP4桁
          rect = Rect.new(0+$game_actors[$partyc[x]].hp.to_s[-y,1].to_i*16, 0, 16, 16)
          @party_window.contents.blt(Partynox+240-(y-1)*16-tyousei_x,Partynoy+x*Partyy,pictureb,rect)
        else
          case y
                
          when 1..2
            rect = Rect.new(0+$game_actors[$partyc[x]].hp.to_s[-y,1].to_i*8, 168, 8, 16)
            @party_window.contents.blt(Partynox+240-(y-1)*8-tyousei_x+8,Partynoy+x*Partyy,pictureb,rect)
          else
            rect = Rect.new(0+$game_actors[$partyc[x]].hp.to_s[-y,1].to_i*16, 0, 16, 16)
            @party_window.contents.blt(Partynox+240-(y-1)*16-tyousei_x+16,Partynoy+x*Partyy,pictureb,rect)
          end
        end
      end
      
      for y in 1..$game_actors[$partyc[x]].maxhp.to_s.size #MHP
        if $game_actors[$partyc[x]].maxhp.to_s.size <= 4
          rect = Rect.new(0+$game_actors[$partyc[x]].maxhp.to_s[-y,1].to_i*16, 0, 16, 16)
          @party_window.contents.blt(Partynox+240-(y-1)*16-tyousei_x,Partynoy+x*Partyy+18,pictureb,rect)
        else
          case y
              
          when 1..2
            rect = Rect.new(0+$game_actors[$partyc[x]].maxhp.to_s[-y,1].to_i*8, 168, 8, 16)
            @party_window.contents.blt(Partynox+240-(y-1)*8-tyousei_x+8,Partynoy+x*Partyy+18,pictureb,rect)
          else
            rect = Rect.new(0+$game_actors[$partyc[x]].maxhp.to_s[-y,1].to_i*16, 0, 16, 16)
            @party_window.contents.blt(Partynox+240-(y-1)*16-tyousei_x+16,Partynoy+x*Partyy+18,pictureb,rect)
          end
        end
      end
      
      for y in 1..$game_actors[$partyc[x]].mp.to_s.size #ki
        if $game_actors[$partyc[x]].mp.to_s.size <= 4 #KI4桁
          rect = Rect.new(0+$game_actors[$partyc[x]].mp.to_s[-y,1].to_i*16, 0, 16, 16)
          @party_window.contents.blt(Partynox+328-(y-1)*16-tyousei_x,Partynoy+x*Partyy,pictureb,rect)
        else
          case y
              
          when 1..2
            rect = Rect.new(0+$game_actors[$partyc[x]].mp.to_s[-y,1].to_i*8, 168, 8, 16)
            @party_window.contents.blt(Partynox+328-(y-1)*8-tyousei_x+8,Partynoy+x*Partyy,pictureb,rect)
          else
            rect = Rect.new(0+$game_actors[$partyc[x]].mp.to_s[-y,1].to_i*16, 0, 16, 16)
            @party_window.contents.blt(Partynox+328-(y-1)*16-tyousei_x+16,Partynoy+x*Partyy,pictureb,rect)

          end
        end
      end
      
      for y in 1..$game_actors[$partyc[x]].maxmp.to_s.size #mki
        if $game_actors[$partyc[x]].maxmp.to_s.size <= 4 #MKI4桁
          rect = Rect.new(0+$game_actors[$partyc[x]].maxmp.to_s[-y,1].to_i*16, 0, 16, 16)
          @party_window.contents.blt(Partynox+328-(y-1)*16-tyousei_x,Partynoy+x*Partyy+18,pictureb,rect)
        else
          case y
              
          when 1..2
            rect = Rect.new(0+$game_actors[$partyc[x]].maxmp.to_s[-y,1].to_i*8, 168, 8, 16)
            @party_window.contents.blt(Partynox+328-(y-1)*8-tyousei_x+8,Partynoy+x*Partyy+18,pictureb,rect)
          else
            rect = Rect.new(0+$game_actors[$partyc[x]].maxmp.to_s[-y,1].to_i*16, 0, 16, 16)
            @party_window.contents.blt(Partynox+328-(y-1)*16-tyousei_x+16,Partynoy+x*Partyy+18,pictureb,rect)
          end
        end
      end
    end

  end
  #--------------------------------------------------------------------------
  # ● カード使用
  #-------------------------------------------------------------------------- 
  def run_card
    run_hp = false #hpを回復するか
    run_mp = false #mpを回復するか
    run_chara_hp = $game_actors[$partyc[@@cursorstate]].hp #対象キャラHP
    run_chara_mp = $game_actors[$partyc[@@cursorstate]].mp #対称キャラMP
    run_chara_mhp = $game_actors[$partyc[@@cursorstate]].maxhp #対称キャラMHP
    run_chara_mmp = $game_actors[$partyc[@@cursorstate]].maxmp #対称キャラMMP
    all_chare_chk = false
    recovery_hp_num = 0
    recovery_mp_num = 0
    #HP回復かチェック
    if 0 != $data_items[$run_item_card_id].hp_recovery_rate
      run_hp = true
    end
    
    #MP回復かチェック
    if 0 != $data_items[$run_item_card_id].mp_recovery_rate
      run_mp = true
    end
    
    #回復系カードが使用可能かチェック
    if run_hp == true && run_mp == true
      
      if $data_items[$run_item_card_id].scope != 8
        if run_chara_hp == run_chara_mhp && run_chara_mp == run_chara_mmp
          Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
          return false
        end
      else
        for x in 0..$partyc.size - 1
          if $game_actors[$partyc[@@cursorstate]].hp != $game_actors[$partyc[@@cursorstate]].maxhp ||
             $game_actors[$partyc[@@cursorstate]].mp != $game_actors[$partyc[@@cursorstate]].maxmp
             all_chare_chk = true
              break
          end
            
        end
        
        if all_chare_chk == false
          Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
          return false
        end
      end
    elsif run_hp == true
      if $data_items[$run_item_card_id].scope != 8
        if run_chara_hp == run_chara_mhp
          Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
          return false
        end
      else
        for x in 0..$partyc.size - 1
          if $game_actors[$partyc[@@cursorstate]].hp != $game_actors[$partyc[@@cursorstate]].maxhp
             all_chare_chk = true
              break
          end
            
        end
        
        if all_chare_chk == false
          Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
          return false
        end
      end
    elsif run_mp == true
      if $data_items[$run_item_card_id].scope != 8
        if run_chara_mp == run_chara_mmp
          Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
          return false
        end
      else
        for x in 0..$partyc.size - 1
          if $game_actors[$partyc[@@cursorstate]].mp != $game_actors[$partyc[@@cursorstate]].maxmp
             all_chare_chk = true
              break
          end
            
        end
        
        if all_chare_chk == false
          Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
          return false
        end
      end
    end
    
    if $data_items[$run_item_card_id].scope == 8
      #ヘビ姫は一括で回復する
      #if $data_items[$run_item_card_id].name == "へびひめ"
      #  for x in 0..$partyc.size - 1
      #    $game_actors[$partyc[x]].hp = $game_actors[$partyc[x]].maxhp  
      #    $game_actors[$partyc[x]].mp = $game_actors[$partyc[x]].maxmp
      #    $chadead[x] = false
      #    if $chadeadchk.size > 0
      #      $chadeadchk[x] = false #もし戦闘中ならチェック用もfals
      #    end
      #    
      #  end
      #els
      if $data_items[$run_item_card_id].name == "シェンロン"

        for x in 0..$partyc.size - 1
          
          if $chadead[x] == false
            $game_actors[$partyc[x]].hp = $game_actors[$partyc[x]].maxhp  
            $game_actors[$partyc[x]].mp = $game_actors[$partyc[x]].maxmp
          else
            #死んでるとき
            #全体効果のカードは値を取得しなおす
            run_chara_hp = $game_actors[$partyc[x]].hp #対象キャラHP
            run_chara_mp = $game_actors[$partyc[x]].mp #対称キャラMP
            run_chara_mhp = $game_actors[$partyc[x]].maxhp #対称キャラMHP
            run_chara_mmp = $game_actors[$partyc[x]].maxmp #対称キャラMMP
            #スキル追加効果回復量格納
            recovery_hp_skill_par = 0
            recovery_mp_skill_par = 0

            #スキル追加効果取得
            recovery_hp_skill_par,recovery_mp_skill_par = get_recovery_hpki_skill_par $partyc[x]
            
            recovery_hp_num = (((run_chara_mhp * (100+recovery_hp_skill_par)).prec_f / 100).ceil / 2).prec_i
            recovery_mp_num = (((run_chara_mmp * (100+recovery_mp_skill_par)).prec_f / 100).ceil / 2).prec_i
            
            $game_actors[$partyc[x]].hp += recovery_hp_num
            #$game_actors[$partyc[x]].hp += ($game_actors[$partyc[x]].maxhp.to_f / 2).ceil.to_i
            $chadead[x] = false
            if $chadeadchk.size > 0
              $chadeadchk[x] = false #もし戦闘中ならチェック用もfals
            end
            if $game_actors[$partyc[x]].hp >= $game_actors[$partyc[x]].maxhp
              $game_actors[$partyc[x]].hp = $game_actors[$partyc[x]].maxhp
              
            end
            
            $game_actors[$partyc[x]].mp += recovery_mp_num
            #$game_actors[$partyc[x]].mp += ($game_actors[$partyc[x]].maxmp.to_f / 2).ceil.to_i
            if $game_actors[$partyc[x]].mp >= $game_actors[$partyc[x]].maxmp
              $game_actors[$partyc[x]].mp = $game_actors[$partyc[x]].maxmp
            end
          end
        end
      else
        for x in 0..$partyc.size - 1
          #全体効果のカードは値を取得しなおす
          run_chara_hp = $game_actors[$partyc[x]].hp #対象キャラHP
          run_chara_mp = $game_actors[$partyc[x]].mp #対称キャラMP
          run_chara_mhp = $game_actors[$partyc[x]].maxhp #対称キャラMHP
          run_chara_mmp = $game_actors[$partyc[x]].maxmp #対称キャラMMP
          #スキル追加効果回復量格納
          recovery_hp_skill_par = 0
          recovery_mp_skill_par = 0

          #スキル追加効果取得
          recovery_hp_skill_par,recovery_mp_skill_par = get_recovery_hpki_skill_par $partyc[x]
          #p $chadead[x],$data_items[$run_item_card_id].id
          if $chadead[x] == false || $data_items[$run_item_card_id].id != 61
            recovery_hp_num = (((run_chara_mhp * ($data_items[$run_item_card_id].hp_recovery_rate+recovery_hp_skill_par)).prec_f / 100).ceil).prec_i
            recovery_mp_num = (((run_chara_mmp * ($data_items[$run_item_card_id].mp_recovery_rate+recovery_mp_skill_par)).prec_f / 100).ceil).prec_i
          else
            #HP全開カードの場合
            recovery_hp_num = (((run_chara_mhp * ($data_items[$run_item_card_id].hp_recovery_rate+recovery_hp_skill_par)).prec_f / 100).ceil / 2).prec_i
            recovery_mp_num = (((run_chara_mmp * ($data_items[$run_item_card_id].mp_recovery_rate+recovery_mp_skill_par)).prec_f / 100).ceil / 2).prec_i
          end
          #p recovery_hp_skill_par,recovery_mp_skill_par
          #p ($data_items[$run_item_card_id].hp_recovery_rate+recovery_hp_skill_par),($data_items[$run_item_card_id].mp_recovery_rate+recovery_mp_skill_par)
          #p recovery_hp_num,recovery_mp_num

          if run_hp == true
            $game_actors[$partyc[x]].hp += recovery_hp_num
            if $game_actors[$partyc[x]].hp >= $game_actors[$partyc[x]].maxhp
              $game_actors[$partyc[x]].hp = $game_actors[$partyc[x]].maxhp
              $chadead[x] = false
              if $chadeadchk.size > 0
                $chadeadchk[x] = false #もし戦闘中ならチェック用もfals
              end
            end
          end
          
          if run_mp == true
            $game_actors[$partyc[x]].mp += recovery_mp_num
            if $game_actors[$partyc[x]].mp >= $game_actors[$partyc[x]].maxmp
              $game_actors[$partyc[x]].mp = $game_actors[$partyc[x]].maxmp
            end
            
          end
        end
=begin
          if run_hp == true && run_mp == true
            $game_actors[$partyc[x]].hp += recovery_hp_num
            if $game_actors[$partyc[x]].hp >= $game_actors[$partyc[x]].maxhp
              $game_actors[$partyc[x]].hp = $game_actors[$partyc[x]].maxhp
              $chadead[x] = false
              if $chadeadchk.size > 0
                $chadeadchk[x] = false #もし戦闘中ならチェック用もfals
              end
            end
            
            $game_actors[$partyc[x]].mp += recovery_mp_num
            if $game_actors[$partyc[x]].mp >= $game_actors[$partyc[x]].maxmp
              $game_actors[$partyc[x]].mp = $game_actors[$partyc[x]].maxmp
            end
          elsif run_hp == true
            $game_actors[$partyc[x]].hp += recovery_hp_num
            if $game_actors[$partyc[x]].hp >= $game_actors[$partyc[x]].maxhp
              $game_actors[$partyc[x]].hp = $game_actors[$partyc[x]].maxhp
              $chadead[x] = false
              if $chadeadchk.size > 0
                $chadeadchk[x] = false #もし戦闘中ならチェック用もfals
              end
            end
            
          else
            $game_actors[$partyc[x]].mp += recovery_mp_num
            if $game_actors[$partyc[x]].mp >= $game_actors[$partyc[x]].maxmp
              $game_actors[$partyc[x]].mp = $game_actors[$partyc[x]].maxmp
            end
            
          end
=end
            
        
=begin
          if $chadead[x] == false
            $game_actors[$partyc[x]].hp = $game_actors[$partyc[x]].maxhp  
            $game_actors[$partyc[x]].mp = $game_actors[$partyc[x]].maxmp
          else
            $game_actors[$partyc[x]].hp += ($game_actors[$partyc[x]].maxhp.to_f / 2).ceil.to_i
            if $game_actors[$partyc[x]].hp >= $game_actors[$partyc[x]].maxhp
              $game_actors[$partyc[x]].hp = $game_actors[$partyc[x]].maxhp
              $chadead[x] = false
              if $chadeadchk.size > 0
                $chadeadchk[x] = false #もし戦闘中ならチェック用もfals
              end
            end
          
            $game_actors[$partyc[x]].mp += ($game_actors[$partyc[x]].maxmp.to_f / 2).ceil.to_i
            if $game_actors[$partyc[x]].mp >= $game_actors[$partyc[x]].maxmp
              $game_actors[$partyc[x]].mp = $game_actors[$partyc[x]].maxmp
            end
          end

        end
=end
      end
      Audio.se_play("Audio/SE/" + "Z3 回復")    # 効果音を再生する
      pre_update
      Graphics.update
      return true
      
      
    end
    
    #回復系カードを先に判定する
    if run_hp == true || run_mp == true
      #回復量格納
      
      #スキル追加効果回復量格納
      recovery_hp_skill_par = 0
      recovery_mp_skill_par = 0

      #スキル追加効果取得
      recovery_hp_skill_par,recovery_mp_skill_par = get_recovery_hpki_skill_par $partyc[@@cursorstate]
      
      #p recovery_hp_skill_par ,recovery_mp_skill_par
      #スキル効果分追加
      recovery_hp_num = (((run_chara_mhp * ($data_items[$run_item_card_id].hp_recovery_rate + recovery_hp_skill_par)).prec_f / 100).ceil).prec_i
      #recovery_hp_num = (((run_chara_mhp * $data_items[$run_item_card_id].hp_recovery_rate).prec_f / 100).ceil).prec_i
      recovery_mp_num = (((run_chara_mmp * ($data_items[$run_item_card_id].mp_recovery_rate + recovery_mp_skill_par)).prec_f / 100).ceil).prec_i
      #recovery_mp_num = (((run_chara_mmp * $data_items[$run_item_card_id].mp_recovery_rate).prec_f / 100).ceil).prec_i
      recovery_hp_count = 0 #HP回復ループ数
      recovery_mp_count = 0 #MP回復ループ数
      recovery_hp_count_num = 0 #HP回復数
      recovery_mp_count_num = 0 #MP回復数
      recovery_end_flag = false #カード使用完了フラグ
      loop_count = 0 #画面更新頻度調整用
      Audio.se_play("Audio/SE/" + "Z3 回復")    # 効果音を再生する
      #p "HP:" +run_chara_hp.to_s,"MHP:" +run_chara_mhp.to_s,"MP:" +run_chara_mp.to_s,"MMP:" +run_chara_mmp.to_s,"HP回復量:" + recovery_hp_num.to_s,"MP回復量:" + recovery_mp_num.to_s
      
      #回復量が差分を超えないように調整
      if run_hp == true && (run_chara_mhp - run_chara_hp) < recovery_hp_num
        recovery_hp_num = run_chara_mhp - run_chara_hp
      end
      
      if run_mp == true && (run_chara_mmp - run_chara_mp) < recovery_mp_num
        recovery_mp_num = run_chara_mmp - run_chara_mp
      end      
      
      #サイヤ人パワーアップ、仙豆かつサイヤ人かつピンチ
      if $run_item_card_id == 17 && ($game_actors[$partyc[@@cursorstate]].hp.prec_f / $game_actors[$partyc[@@cursorstate]].maxhp.prec_f * 100).prec_i < $hinshi_hp && $chadead[@@cursorstate] == false 
      #if $run_item_card_id == 17 && $game_actors[$partyc[@@cursorstate]].hp < 10 && $chadead[@@cursorstate] == false #仙豆かつサイヤ人であれば
        
        case $partyc[@@cursorstate]
        
        when 3,5,12,14,16..20,25..30,32
          $cha_power_up[@@cursorstate] = true
          $cha_defense_up [@@cursorstate] = true
        end
      end
      @recovery_flag = true
      begin

        #HP回復増加量
        if recovery_hp_num - recovery_hp_count >= 1000
          recovery_hp_count_num = 100
        elsif recovery_hp_num - recovery_hp_count >= 100
          recovery_hp_count_num = 10
        else
          recovery_hp_count_num = 1
        end
 
        #MP回復増加量
        if recovery_mp_num - recovery_mp_count >= 1000
          recovery_mp_count_num = 100
        elsif recovery_mp_num - recovery_mp_count >= 100
          recovery_mp_count_num = 10
        else
          recovery_mp_count_num = 1
        end
        
        #HPMP回復
        if run_hp == true && recovery_hp_count <= recovery_hp_num #HP回復
          
          run_chara_hp += recovery_hp_count_num
          $game_actors[$partyc[@@cursorstate]].hp = run_chara_hp
          
          #HPが全回復なら復活かつ行動不可解除
          if run_chara_hp == run_chara_mhp
            $chadead[@@cursorstate] = false
            $cha_stop_num[@@cursorstate] = 0
            if $chadeadchk.size > 0 #もし戦闘中ならチェック用もfalse
              $chadeadchk[@@cursorstate] = false
            end
          end
          
 
          
        end
        
        if run_mp == true && recovery_mp_count <= recovery_mp_num #MP回復
          run_chara_mp += recovery_mp_count_num
          $game_actors[$partyc[@@cursorstate]].mp = run_chara_mp
          #$game_actors[$partyc[@@cursorstate]].mp += 1
        end
        
        #回復数増加
        recovery_hp_count += recovery_hp_count_num
        recovery_mp_count += recovery_mp_count_num
        
        #回復系が終了したかチェック
        if run_hp == true && run_mp == true
          if recovery_hp_count >= recovery_hp_num && recovery_mp_count >= recovery_mp_num
            recovery_end_flag = true
          end
        elsif run_hp == true && recovery_hp_count >= recovery_hp_num
          recovery_end_flag = true
        elsif run_mp == true && recovery_mp_count >= recovery_mp_num
          recovery_end_flag = true
        end
        
        loop_count += 1 #ループカウント増加
        
        
        #画面更新頻度(2か3ぐらい良い)
        if loop_count % 3 == 0
          pre_update #画面更新
          Graphics.update
        end
      end while recovery_end_flag == false

      temp_cha_skill = []
      temp_skill_no = 0
      skill_effect_flag = false
    
      
      #スキル対象者回復====================================
      set_skill_nil_to_zero $partyc[@@cursorstate]
      temp_cha_no = $partyc[@@cursorstate]
      #tempに所持スキルを追加
      if $cha_typical_skill != []
      
        for y in 0..$cha_typical_skill[temp_cha_no].size
          temp_cha_skill << $cha_typical_skill[temp_cha_no][y]
        end
      end
      
      if $cha_add_skill != []
        for y in 0..$cha_add_skill[temp_cha_no].size
          temp_cha_skill << $cha_add_skill[temp_cha_no][y]
        end
      end
      fukkatuhosei = 1

      #rskill,rch_no = chk_skill_learn(420) #不死身の肉体
      if chk_skill_learn(420,temp_cha_no)[0] == true #不死身の肉体9
        skill_effect_flag = true
        fukkatuhosei = 0.3
      elsif chk_skill_learn(419,temp_cha_no)[0] == true #不死身の肉体8
        skill_effect_flag = true
        fukkatuhosei = 0.35
      elsif chk_skill_learn(418,temp_cha_no)[0] == true #不死身の肉体7
        skill_effect_flag = true
        fukkatuhosei = 0.4
      elsif chk_skill_learn(417,temp_cha_no)[0] == true #不死身の肉体6
        skill_effect_flag = true
        fukkatuhosei = 0.45
      elsif chk_skill_learn(416,temp_cha_no)[0] == true #不死身の肉体5
        skill_effect_flag = true
        fukkatuhosei = 0.5
      elsif chk_skill_learn(415,temp_cha_no)[0] == true #不死身の肉体4
        skill_effect_flag = true
        fukkatuhosei = 0.55
      elsif chk_skill_learn(414,temp_cha_no)[0] == true #不死身の肉体3
        skill_effect_flag = true
        fukkatuhosei = 0.6
      elsif chk_skill_learn(413,temp_cha_no)[0] == true #不死身の肉体2
        skill_effect_flag = true
        fukkatuhosei = 0.65
      elsif chk_skill_learn(412,temp_cha_no)[0] == true #不死身の肉体1
        skill_effect_flag = true
        fukkatuhosei = 0.7
      end
      
      if skill_effect_flag == true
        if $game_actors[temp_cha_no].hp >= ($game_actors[temp_cha_no].maxhp * fukkatuhosei) 
          #$game_actors[temp_cha_no].hp = $game_actors[temp_cha_no].maxhp
          $chadeadchk[@@cursorstate] = false #復活
          $chadead[@@cursorstate] = false
        end
        skill_effect_flag = false
      end
      
      pre_update #画面更新
      Graphics.update
      @recovery_flag = false
      return true
    end
    
    case $run_item_card_id #回復系以外
    
    when 32 #界王様
      if $cha_power_up[@@cursorstate] != true
        Audio.se_play("Audio/SE/" + "Z1 パワーアップ")    # 効果音を再生する
        Graphics.wait(30)
        $cha_power_up[@@cursorstate] = true
        return true
      else
        Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
      end
    when 33 #最長老
      
      all_cha_power_up = true
      
      for i in 0..$partyc.size-1
        if $cha_power_up[i] == false || $cha_power_up[i] == nil
          all_cha_power_up = false
          break
        end
      end
      
      if $cha_power_up.size == 0
        all_cha_power_up = false
      end 
      
      if all_cha_power_up == false
        Audio.se_play("Audio/SE/" + "Z1 パワーアップ")    # 効果音を再生する
        Graphics.wait(30)
        
        for i in 0..$partyc.size-1
          $cha_power_up[i] = true
        end
        return true
      else
        Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
      end
    when 40 #超神水
      if $cha_power_up[@@cursorstate] != true || $cha_defense_up [@@cursorstate] != true
        Audio.se_play("Audio/SE/" + "Z1 パワーアップ")    # 効果音を再生する
        Graphics.wait(30)
        $cha_power_up[@@cursorstate] = true
        $cha_defense_up [@@cursorstate] = true
        return true
      else
        Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
      end
    when 41 #バトルスーツ
      if $cha_defense_up [@@cursorstate] != true
        Audio.se_play("Audio/SE/" + "Z1 刀")    # 効果音を再生する
        Graphics.wait(30)
        $cha_defense_up [@@cursorstate] = true
        return true
      else
        Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
      end
    when 48 #未来の薬
      if $partyc[@@cursorstate] == 3 || $partyc[@@cursorstate] == 14
        Audio.se_play("Audio/SE/" + "Z3 レベルアップ")    # 効果音を再生する
        Graphics.wait(30)
        $game_switches[428] = true #悟空が心臓病発症しない
        return true
      else
        Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
      end
    when 53 #少年
      if $cha_sente_card_flag[@@cursorstate] == false && $cha_sente_flag[@@cursorstate] == false
        Audio.se_play("Audio/SE/" + "Z1 飛ぶ")    # 効果音を再生する
        Graphics.wait(30)
        $cha_sente_card_flag[@@cursorstate] = true
        return true
      else
        Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
      end
    when 54 #カナッサ
      if $cha_kaihi_card_flag[@@cursorstate] == false
        Audio.se_play("Audio/SE/" + "Z1 高速移動")    # 効果音を再生する
        Graphics.wait(30)
        $cha_kaihi_card_flag[@@cursorstate] = true
        return true
      else
        Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
      end
    when 55 #月とシッポ
      if $partyc[@@cursorstate] == 5 && $game_switches[70] == false
        Audio.se_play("Audio/SE/" + "Z1 パワーアップ")    # 効果音を再生する
        Graphics.wait(30)
        if $game_variables[40] == 0
          $game_actors[$partyc[@@cursorstate]].learn_skill(51)
        else
          $game_actors[$partyc[@@cursorstate]].learn_skill(52)
        end
        $game_switches[70] = true
        return true
      else
        Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
      end
    when 64 #必殺技
      if $cha_ki_zero[@@cursorstate] == false && $cha_wakideru_flag[@@cursorstate] == false
        Audio.se_play("Audio/SE/" + "Z2 カードアップ")    # 効果音を再生する
        Graphics.wait(30)
        $cha_ki_zero[@@cursorstate] = true
        return true
      else
        Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
      end
    when 72 #ゴハン(追加スキル上限開放)
      if $cha_add_skill_set_num[$partyc[@@cursorstate]] < 3
        Audio.se_play("Audio/SE/" + "Z1 パワーアップ")    # 効果音を再生する
        Graphics.wait(30)
        $cha_add_skill_set_num[$partyc[@@cursorstate]] += 1
        return true
      else
        Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
      end
      
    when 79 #ねずみ(フリースキルに戻す)
      if $cha_set_free_skill[$partyc[@@cursorstate]] == true
        return true
      else
        Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
      end
    when 88 #ちょうせいすい(ZP取得)
      Audio.se_play("Audio/SE/" + "Z1 パワーアップ")    # 効果音を再生する
      Graphics.wait(30)
      if $zp[$partyc[@@cursorstate]] == nil
        $zp[$partyc[@@cursorstate]] = 0
      end
      $zp[$partyc[@@cursorstate]] += 15
      #temp_cha_no = $partyc[@@cursorstate]
      return true

    when 110 #仮面男(フリースキル変更)
      
      temp_cha_no = $partyc[@@cursorstate]
      
      free_skill = false
      
      #フリースキルを取得しているか
      for y in 0..$cha_typical_skill[temp_cha_no].size
        if 34 == $cha_typical_skill[temp_cha_no][y]
          free_skill = true 
          break
        end
      end

      if free_skill == true #フリースキル取得
        return true
      else
        Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
      end
    when 121 #おばけ 瀕死を回復
       if $chadead[@@cursorstate] == true && $game_actors[$partyc[@@cursorstate]].hp != 0
         Audio.se_play("Audio/SE/" + "Z3 回復")
         $chadead[@@cursorstate] = false
         $chadeadchk[@@cursorstate] = false
         return true
       else
         Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
       end
    when 140 #芭蕉扇
      if $partyc[@@cursorstate] == 10 && $game_switches[557] == false
        Audio.se_play("Audio/SE/" + "DB3 刀")    # 効果音を再生する
        Graphics.wait(30)
        $game_switches[557] = true
        return true
      else
        Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
      end
    when 196 #デストロンガス発生装置
     if $chadeadchk[@@cursorstate] == false#&& $game_actors[$partyc[@@cursorstate]].hp != 0
       Audio.se_play("Audio/SE/" + "Z2 気が遠くなる")
       
       #フリーザ戦以外なら、戦闘不能フラグを両方更新し、死亡処理を発生させない。
       #フリーザ戦の場合、これをしないとイベント発生するので、あえてフラグを変えない
       if $game_variables[41] != 493
         $chadead[@@cursorstate] = true
       end
       $chadeadchk[@@cursorstate] = true
       #$full_chadead[$partyc[@@cursorstate]] = true
       #$chadeadchk[x] = $full_chadead[$partyc[x]] 
       $game_actors[$partyc[@@cursorstate]].hp = 0
       return true
     else
       Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
     end
    when 197 #修行の石
     #if $chadeadchk[@@cursorstate] == false#&& $game_actors[$partyc[@@cursorstate]].hp != 0
       Audio.se_play("Audio/SE/" + "Z1 パワーアップ")
       addnum = 5 #追加回数
       add_actor_all_tec_level $partyc[@@cursorstate],addnum
       return true
     #else
     #  Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
     #end
    when 201 #ガっちゃん(ZP取得)
      Audio.se_play("Audio/SE/" + "Z1 パワーアップ")    # 効果音を再生する
      Graphics.wait(30)
      if $zp[$partyc[@@cursorstate]] == nil
        $zp[$partyc[@@cursorstate]] = 0
      end
      $zp[$partyc[@@cursorstate]] += 1500
      #temp_cha_no = $partyc[@@cursorstate]
      return true
    when 202 #界王星(ZP取得)
      Audio.se_play("Audio/SE/" + "Z1 パワーアップ")    # 効果音を再生する
      Graphics.wait(30)
      if $zp[$partyc[@@cursorstate]] == nil
        $zp[$partyc[@@cursorstate]] = 0
      end
      $zp[$partyc[@@cursorstate]] += 150
      #temp_cha_no = $partyc[@@cursorstate]
      return true

    when 203 #重力装置
      return true
    end
    return false
  end

    #--------------------------------------------------------------------------
  # ● スキルカーソル移動
  #引数:n (下:2 上:8 右:6 左:4)
  #--------------------------------------------------------------------------
  def move_skill_cursor n
    
    chk_typical = false
    case n
    
    when 0 #初期値
      
      for x in 0..$cha_typical_skill[$partyc[@@cursorstate]].size-1
        if $cha_typical_skill[$partyc[@@cursorstate]][x] > 0
          #p x
          @skill_cursorstate = x
          chk_typical = true
          break
        end
      end
      if chk_typical == false
        @skill_cursorstate = 3
      end
    when 2 #下
      
      @skill_cursorstate +=1
      #@skill_cursorstate = 3 if @skill_cursorstate == 3 + $cha_add_skill_set_num[$partyc[@@cursorstate]]
      #if @skill_cursorstate <= 2
        for x in @skill_cursorstate..$cha_typical_skill[$partyc[@@cursorstate]].size-1
          
          #エラー回避用にnilかチェックしてnilなら0を格納
          $cha_typical_skill[$partyc[@@cursorstate]][x] = 0 if $cha_typical_skill[$partyc[@@cursorstate]][x] == nil
          if $cha_typical_skill[$partyc[@@cursorstate]][x] > 0
            @skill_cursorstate = x
            chk_typical = true
            break
          else
            @skill_cursorstate = 0
          end
        end
        if chk_typical == false
          
          if @skill_cursorstate <= 2 
            @skill_cursorstate = 3
          elsif @skill_cursorstate == 4
            
            if $cha_add_skill_set_num[$partyc[@@cursorstate]] <= 1
              @skill_cursorstate = 0
            end
          elsif @skill_cursorstate == 5
            
            if $cha_add_skill_set_num[$partyc[@@cursorstate]] <= 2
              @skill_cursorstate = 0
            end
          elsif @skill_cursorstate == 6
              @skill_cursorstate = 0
          end
        end
      #end

      

    when 8 #上
      
      @skill_cursorstate -=1
      
      if @skill_cursorstate == -1
        @skill_cursorstate = 2 + $cha_add_skill_set_num[$partyc[@@cursorstate]] #4
      end
      #elsif @skill_cursorstate <= 2
      if @skill_cursorstate <= 2
      
        @skill_cursorstate.step(0,-1) do |x|
          #エラー回避用にnilかチェックしてnilなら0を格納
          $cha_typical_skill[$partyc[@@cursorstate]][x] = 0 if $cha_typical_skill[$partyc[@@cursorstate]][x] == nil
          if $cha_typical_skill[$partyc[@@cursorstate]][x] > 0
            
            @skill_cursorstate = x
            chk_typical = true
            break
          end
        end
        if chk_typical == false
          @skill_cursorstate = @skill_cursorstate = 2 + $cha_add_skill_set_num[$partyc[@@cursorstate]]#4
        end
      end
      
    when 6

    when 4

    end
    #@tecput_page = 0
  end

  #--------------------------------------------------------------------------
  # ● スキル一覧カーソル移動
  #引数:n (下:2 上:8 右:6 左:4)
  #--------------------------------------------------------------------------
  def move_skill_list_cursor n
    
    case n
    
    when 2 #下
      @skill_list_cursorstate += 1
        
      if @skill_list_put_strat + Skill_list_put_max < @skill_list_cursorstate
        @skill_list_put_strat += 1
      end
      
      if @skill_list_cursorstate > @skill_list_put_ok_count-1
        @skill_list_cursorstate = 0
        @skill_list_put_strat = 0
      end
      if @skill_list_put_ok_count == 1
        @skill_list_cursorstate = 0
        @skill_list_put_strat = 0
      end
    when 8 #上
      @skill_list_cursorstate -=1
      if @skill_list_put_strat > @skill_list_cursorstate
        @skill_list_put_strat -= 1
      end
      if @skill_list_cursorstate <= -1
        
        @skill_list_cursorstate = @skill_list_put_ok_count-1
        
        @skill_list_put_strat = @skill_list_put_ok_count-1 - Skill_list_put_max
        @skill_list_put_strat = 0 if @skill_list_put_strat < 0 
      end
      
      if @skill_list_put_ok_count == 1
        @skill_list_cursorstate = 0
        @skill_list_put_strat = 0
      end
    when 6 #右
      @skill_list_cursorstate += Skill_list_put_max + 1
      @skill_list_put_strat += Skill_list_put_max + 1
      if @skill_list_cursorstate >= @skill_list_put_ok_count
        @skill_list_cursorstate = @skill_list_put_ok_count -1
        @skill_list_put_strat = @skill_list_put_ok_count-1 - Skill_list_put_max
      #elsif @put_strat + Put_ene_num + 1 >= @ene_count
      elsif @skill_list_put_strat + Skill_list_put_max >= @skill_list_put_ok_count
        @skill_list_put_strat = @skill_list_put_ok_count-1 - Skill_list_put_max
      end
      @skill_list_put_strat = 0 if @skill_list_put_strat < 0 
      if @skill_list_put_ok_count == 1
        @skill_list_cursorstate = 0
        @skill_list_put_strat = 0
      end
    when 4 #左
      @skill_list_cursorstate -= Skill_list_put_max + 1
      @skill_list_put_strat -= Skill_list_put_max + 1
      if @skill_list_cursorstate <= 0
        @skill_list_cursorstate = 0
        @skill_list_put_strat = 0
      elsif @skill_list_put_strat <= 0
        #@cursorstate = 0
        @skill_list_put_strat = 0
      end
      if @skill_list_put_ok_count == 1
        @skill_list_cursorstate = 0
        @skill_list_put_strat = 0
      end
    end

  end  

  #--------------------------------------------------------------------------
  # ● カーソル移動
  #引数:n (下:2 上:8 右:6 左:4)
  #--------------------------------------------------------------------------
  def move_cursor n
    
    case n
    
    when 2 #下
      @@cursorstate +=1
      
      if @@cursorstate >= $partyc.size
        @@cursorstate = 0
      end
      
      #並び替え時は選択キャラと重ならないようにする
      if @window_state == 1 && @cursor_chara_select == @@cursorstate
        @@cursorstate +=1
        if @@cursorstate >= $partyc.size
          @@cursorstate = 0
        end
      end
          when 8 #上
      @@cursorstate -=1
      
      if @@cursorstate <= -1
        @@cursorstate = $partyc.size - 1
      end
      
      #並び替え時は選択キャラと重ならないようにする
      if @window_state == 1 && @cursor_chara_select == @@cursorstate
        @@cursorstate -=1
        if @@cursorstate <= -1
          @@cursorstate = $partyc.size - 1
        end
      end


      
    when 6

    when 4

    end
    @tecput_page = 0
  end

  #--------------------------------------------------------------------------
  # ● メニュー再生
  #-------------------------------------------------------------------------- 
  def set_status_window_size
    
    #ウインドウサイズを変えるだけでは表示範囲が変わらないのでウインドウを作り直す
    if @display_skill_window == -1
      #標準
      #@technique_window.visible = true
      @status_backwindow.dispose
      @status_backwindow = nil
      @status_backwindow = Window_Base.new(0,0,Status_backwin_sizex,Status_backwin_sizey)
      @status_backwindow.opacity=255
      @status_backwindow.back_opacity=255
      @status_window.dispose
      @status_window = nil
      @status_window = Window_Base.new(Puttyouseix,0,Status_win_sizex,Status_win_sizey)
      @status_window.opacity=0
      @status_window.back_opacity=0

      #@status_window.height = Status_win_sizey
      
    else
      #スキル
      @status_backwindow.dispose
      @status_backwindow = nil
      @status_backwindow = Window_Base.new(0,0,Status_backwin_sizex,Party_backwin_sizey)
      @status_backwindow.opacity=255
      @status_backwindow.back_opacity=255
      @status_window.dispose
      @status_window = nil
      @status_window = Window_Base.new(Puttyouseix,0,Status_win_sizex,Party_win_sizey)
      @status_window.opacity=0
      @status_window.back_opacity=0

      #@status_window.height = Party_win_sizey
    end
    
  end
  #--------------------------------------------------------------------------
  # ● メニュー再生
  #--------------------------------------------------------------------------    
  def set_bgm
      set_menu_bgm_name true
      if $option_menu_bgm_name.include?("_user") == false
        Audio.bgm_play("Audio/BGM/" + $option_menu_bgm_name)    # 効果音を再生する
      else
        Audio.bgm_play("Audio/MYBGM/" + $option_menu_bgm_name)    # 効果音を再生する
      end
  end
end