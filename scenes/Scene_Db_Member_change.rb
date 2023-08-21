#==============================================================================
# ■ Scene_Db_Member_change
#------------------------------------------------------------------------------
# 　能力表示画面
#==============================================================================
class Scene_Db_Member_change < Scene_Base
  include Share
  Party_win_sizex = 640-268         #パーティーウインドウサイズX
  Party_win_sizey = 480-102         #パーティーウインドウサイズY
  Status_win_sizex = 278        #詳細ステータスウインドウサイズX
  Status_win_sizey = 480-102        #詳細ステータスウインドウサイズY
  Status_backwin_sizex = 268        #詳細ステータスウインドウサイズX
  Status_backwin_sizey = 480-102        #詳細ステータスウインドウサイズY
  Member_win_sizex = 640     #必殺技ウインドウサイズX
  Member_win_sizey = 102     #必殺技ウインドウサイズY
  Skill_memo_win_sizex = Party_win_sizex #スキル説明ウインドウサイズX
  Skill_memo_win_sizey = 104 #スキル説明ウインドウサイズX
  Skill_list_win_sizex = Party_win_sizex #スキル一覧ウインドウサイズX
  Skill_list_win_sizey = 480 - Skill_memo_win_sizey #スキル一覧ウインドウサイズY
  Partyy = 90                   #パーティー表示行空き数
  Partyx = 84                   #パーティー表示行空き数
  Partynox = Status_backwin_sizex                  #パーティー表示基準X
  Partynoy = 0                 #パーティー表示基準Y
  Status_lbx = 16               #詳細ステータス表示基準X
  Status_lby = 0                #詳細ステータス表示基準Y
  Typ_skill_lby = 168           #固有スキル表示基準Y
  Add_skill_lby = Typ_skill_lby + 164           #追加スキル表示基準Y
  Memberx = 0                #必殺技表示基準X
  Membery = 0                #必殺技表示基準Y
  Skill_new_liney = 46           #スキルの表示行空き数
  Skill_list_lbx = 16            #スキル一覧の表示基準X
  Skill_list_lby = 0            #スキル一覧の表示基準Y
  Skill_list_new_liney = 24      #スキル一覧の表示行空き数
  Skill_list_put_max = 13       #スキル一覧の表示最大数
  #Membernamex = 184          #必殺技画像取得サイズX
  #Membernamey = 24           #必殺技画像取得サイズY

  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     call_state : どのプログラムから呼ばれたか 1:戦闘 2:マップ 3:カード 4:修行
  #--------------------------------------------------------------------------
  def initialize(call_state = 2)
    @call_state = call_state
    if @call_state == 2
      set_bgm
    end
    
    update_party_detail_status call_state
    
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
    #@cursor_skill_select = 0      #選択スキル
    @skill_cursorstate = 0        #スキルカーソル位置
    @skill_list_cursorstate = 0        #スキル一覧カーソル位置
    @skill_list_put_strat = 0     #スキルリスト出力スタート
    @skill_list_put_count = 0     #スキルリスト出力カウント
    @skill_list_put_ok_count = 0     #スキルリスト出力OKカウント(事前チェック用)
    @skill_list_put_skill_no = [] #スキル一覧で出力されてるスキルの番号
    @tecput_page = 0
    @tecput_max = 7
    @skill_set_result = 0         #スキルをセットするかどうか選択
    create_window
    #pre_update
    Graphics.fadein(5)
    #create_menu_background
    #シナリオ進行度によってファイル名の頭文字を変える
    chk_scenario_progress
    #pre_update
    @display_skill_level = -1
    @display_skill_window = -1 #スキルを表示しているか 1でスキルを表示
    @window_update_flag = true
    @recovery_flag = false
    @up_cursor = Sprite.new
    @down_cursor = Sprite.new
    
    #パーティーメンバーのNo画像用
    @member_no = []
    #パーティーメンバーのキャラ画像用
    @member_cha = []
    
    #パーティーメンバーリスト
    #@member_cha_list = []
    
    #セット済みパーティーメンバーリスト
    @member_list = Marshal.load(Marshal.dump($partyc))
    if @member_list.size < 9
      
      for x in 1..9-@member_list.size
        @member_list.push(0)
      end
      
    end
    
    #仲間可能パーティーメンバーのキャラ画像用
    @party_cha = []
    
    #何行目のキャラを表示するか0ならendも含め1～16表示
    @put_party_cha_y = 0
    
    #仲間可能パーティーメンバーリスト
    @party_list = []
    
    #パーティーカーソル位置x,y
    @p_cursor_x = 0
    @p_cursor_y = 0
    
    create_member_picture
    create_party_picture
    create_up_down_cursor
    create_party_cursor_picture
    
    
  end

 #--------------------------------------------------------------------------
  # ● パーティーメンバー画像の設定
  #-------------------------------------------------------------------------- 
  def create_party_cursor_picture
    
    picture = Cache.picture("アイコン")
    rect = set_tate_cursor_blink

    @p_cursor = Sprite.new
    @p_cursor.bitmap = picture
    @p_cursor.src_rect = rect
    @p_cursor.z = 255
    @p_cursor.x = Status_backwin_sizex + 52 + Partyx * @p_cursor_x
    @p_cursor.y = 12 + Partyy * @p_cursor_y
    @p_cursor.visible = true
      
  end
  #--------------------------------------------------------------------------
  # ● 選択元のメンバー画像の設定
  #-------------------------------------------------------------------------- 
  def create_party_picture
    
    #変更対象除外メンバーを更新
    update_party_del_list

    party_max = 7
    
    @party_list = [0,3,4,5,6,7,8,9]
    
    #チチ判定
    if $game_switches[68] == true || $game_switches[69] == true
      party_max += 1
      @party_list.push(10)
    end
    
    #亀仙人判定
    if $game_switches[502] == true
      party_max += 1
      @party_list.push(24)
    end
    
    #若者判定
    if $game_switches[95] == true || $game_switches[107] == true
      party_max += 1
      @party_list.push(15)
    end
    
    #ベジータ判定
    if $game_switches[522] == true
      party_max += 1
      @party_list.push(12)
    end
    
    #バーダック判定
    if $game_switches[109] == true || $game_variables[40] >= 2
      party_max += 1
      @party_list.push(16)
    end
    
    #バーダック一味判定
    if $game_switches[598] == true || #ZG バーダック一味編フリーザ撃破
      $game_switches[586] == true #外伝クリア
      party_max += 4
      @party_list.push(27)
      @party_list.push(28)
      @party_list.push(29)
      @party_list.push(30)
    end
    
    #トランクス判定
    if $game_switches[426] == true
      party_max += 1
      @party_list.push(17)
    end

    #未来悟飯判定
    #if $game_switches[523] == true #未来悟飯のイベント終わったら
    if $game_switches[598] == true || #ZG バーダック一味編フリーザ撃破
      $game_switches[586] == true #外伝クリア
      party_max += 1
      @party_list.push(25)
    end
    
    #16号判定
    if $game_switches[567] == true #メタルクウラコア倒したら
      party_max += 1
      @party_list.push(23)
    end
    
    #17-18号判定
    if $game_switches[598] == true || #ZG バーダック一味編フリーザ撃破
      $game_switches[586] == true #外伝クリア
      party_max += 2
      @party_list.push(22)
      @party_list.push(21)
    end
    
    #サタン判定
    #if $game_switches[524] == true
    #  party_max += 1
    #  @party_list.push(31)
    #end
    
    #超サイヤ人がいたら超サイヤ人に変更
    #スーパーサイヤ人フラグ 1：悟空、2：悟飯、3：ベジータ、4：トランクス、5：悟飯(超2)、6：未来悟飯、7：バーダック
    tmprepchano = [0, 3, 5,12,17, 5,25,16]
    tmpchkchano = [0,14,18,19,20,18,26,32]
    for y in 1..tmprepchano.size-1
      if $super_saiyazin_flag[y] == true
        @party_list.map!{|x| x==tmprepchano[y] ? tmpchkchano[y] : x}
      end
    end
      
    #リストから対象キャラを消す
    if $party_del_list.size > 0
      for x in 0..$party_del_list.size-1
        #p $party_del_list[x]
        if @party_list.include?($party_del_list[x]) == true
          @party_list.delete($party_del_list[x])
          party_max -= 1
        end
      end
    end
      picture = Cache.picture("Z3_顔イベント")
      @party_cha[0] = Sprite.new
      @party_cha[0].bitmap = picture
      rect = Rect.new(0, 64*61, 64, 64)
      @party_cha[0].z = 255
      @party_cha[0].x = 28 + Status_backwin_sizex
      @party_cha[0].y = 30
      @party_cha[0].visible = true
      @party_cha[0].src_rect = rect
      x_count = 1
      y_count = 0
      puty = 30
      putyaki = 90
      
      
    for x in 1..party_max
      #HP,KI回復
      
      #時の間なら全開
      if $game_variables[43] == 999
        $game_actors[@party_list[x]].hp = $game_actors[@party_list[x]].maxhp
        $game_actors[@party_list[x]].mp = $game_actors[@party_list[x]].maxmp
      end
      @party_cha[x] = Sprite.new
      if $full_chadead[@party_list[x]] == true #死亡時はモノクロを表示
        rect,picture = set_character_face 2,@party_list[x]-3
        #rect = Rect.new(128, 0+(($partyc[x]-3)*64), 64, 64) # 顔グラ
      elsif ($game_actors[@party_list[x]].hp.prec_f / $game_actors[@party_list[x]].maxhp.prec_f * 100).prec_i < $hinshi_hp
        rect,picture = set_character_face 1,@party_list[x]-3
        #rect = Rect.new(64, 0+(($partyc[x]-3)*64), 64, 64) # 顔グラ
      else
        rect,picture = set_character_face 0,@party_list[x]-3
        #rect = Rect.new(0, 0+(($partyc[x]-3)*64), 64, 64) # 顔グラ
      end
      #rect,picture = set_character_face 0,@party_list[x] - 3
      @party_cha[x].bitmap = picture
      @party_cha[x].src_rect = rect
      @party_cha[x].z = 255
      @party_cha[x].visible = false
      @party_cha[x].opacity = 255
      @party_cha[x].x = 28 + Status_backwin_sizex + x_count * Partyx
      @party_cha[x].y = 0
      
      @party_cha[x].y = (puty + y_count * putyaki).to_i
      @party_cha[x].visible = true if x < 16
      
      if @member_list.index(@party_list[x]) == nil || x == 0
        @party_cha[x].opacity = 255
      else
        @party_cha[x].opacity = 128
      end
      x_count += 1
      
      #横位置調整
      if x_count == 4
        x_count = 0
        y_count += 1
      end

    end
  end
  #--------------------------------------------------------------------------
  # ● パーティーメンバー画像の設定
  #-------------------------------------------------------------------------- 
  def create_member_picture
    
    
    member_max = 8
    for x in 0..member_max
      picture = Cache.picture("数字英語")
      @member_no[x] = Sprite.new
      @member_no[x].bitmap = picture
      rect = Rect.new((x+1)*16, 48, 16, 16)
      @member_no[x].src_rect = rect
      @member_no[x].z = 255
      @member_no[x].x = 40 + x * 68
      @member_no[x].y = Status_win_sizey + 10
      @member_no[x].visible = true
      
      #picture = Cache.picture("数字英語")
      @member_cha[x] = Sprite.new
      
      if @member_list[x] != 0
        if $full_chadead[@member_list[x]] == true #死亡時はモノクロを表示
          rect,picture = set_character_face 2,@member_list[x]-3
        elsif ($game_actors[@member_list[x]].hp.prec_f / $game_actors[@member_list[x]].maxhp.prec_f * 100).prec_i < $hinshi_hp
          rect,picture = set_character_face 1,@member_list[x]-3
        else
          rect,picture = set_character_face 0,@member_list[x]-3
        end
        #rect,picture = set_character_face 0,@member_list[x] - 3
        @member_cha[x].bitmap = picture
      end
      @member_cha[x].src_rect = rect
      @member_cha[x].z = 255
      @member_cha[x].x = 16 + x * 68
      @member_cha[x].y = Status_win_sizey + 10 + 18
      @member_cha[x].visible = true
    end

  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_sprite
    dispose_window
    
    
    $chadead = $chadead[0..$partyc.size - 1]
    if @call_state == 2 #時の間の時のみ実施する
      $chadead = []
      
      for x in 0..$partyc.size - 1
        if $game_actors[$partyc[x]].hp == 0
          $chadead[x] = true
        else
          $chadead[x] = false
        end
      end
    end  
    
    #状態更新 fullからpartyへ(これをしないと人数を変更したときにバグる)
    if @call_state == 1 || @call_state == 3 #3はマップでカードを利用したということ
      update_inparty_detail_status 5
    end
    
    #一人かつ、死んでいる場合はHP1で復活させる
    if $partyc.size == 1 && $game_actors[$partyc[0]].hp == 0
      $game_actors[$partyc[0]].hp = 1
      $chadead[0] = false
    end
    #対象外リストを初期化
    $party_del_list = []
  end
  #--------------------------------------------------------------------------
  # ● スプライト開放
  #--------------------------------------------------------------------------
  def dispose_sprite
    @up_cursor.bitmap = nil
    @down_cursor.bitmap = nil
    @up_cursor = nil
    @down_cursor = nil
    
    for x in 0..@member_cha.size - 1
      @member_cha[x].bitmap = nil
    end
    @member_cha = nil
    
    for x in 0..@member_no.size - 1
      @member_no[x].bitmap = nil
    end
    @member_no = nil
    
    for x in 0..@party_cha.size - 1
      @party_cha[x].bitmap = nil
    end
    @party_cha = nil
    
    @p_cursor.bitmap = nil
    @p_cursor = nil
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
    @up_cursor.x = 614 - 168
    @up_cursor.y = 16
    @up_cursor.z = 255
    @up_cursor.angle = 91
    @up_cursor.visible = false
    
    #下カーソル
    # スプライトのビットマップに画像を設定
    @down_cursor.bitmap = Cache.picture("アイコン")
    @down_cursor.src_rect = Rect.new(16*5, 0, 16, 16)
    @down_cursor.x = 630 - 168
    @down_cursor.y = 362
    @down_cursor.z = 255
    @down_cursor.angle = 269
    @down_cursor.visible = false
  end

  #--------------------------------------------------------------------------
  # ● 画面更新
  #--------------------------------------------------------------------------
  def pre_update
    #super
    if @window_update_flag == true || @recovery_flag == true
      window_contents_clear
      output_party
      output_status
      @Member_window.update
      @status_window.update
      @party_window.update

      if @skill_list_window.visible == true
        @skill_list_window.update
      end
      
      if @result_window != nil
        output_result
        @result_window.update
      end
      
      if @cap_window != nil
        output_cap
        @cap_window.update
      end
      
      update_member_picture
      
      @window_update_flag = false
      
      
      
    end
    
    output_cursor
  end
  
  #--------------------------------------------------------------------------
  # ● パーティーメンバー画像の更新
  #-------------------------------------------------------------------------- 
  def update_member_picture
    
    
    member_max = 8
    for x in 0..member_max
      
      if @member_list[x] != 0
        if $full_chadead[@member_list[x]] == true #死亡時はモノクロを表示
          rect,picture = set_character_face 2,@member_list[x]-3
        elsif ($game_actors[@member_list[x]].hp.prec_f / $game_actors[@member_list[x]].maxhp.prec_f * 100).prec_i < $hinshi_hp
          rect,picture = set_character_face 1,@member_list[x]-3
        else
          rect,picture = set_character_face 0,@member_list[x]-3
        end
        #rect,picture = set_character_face 0,@member_list[x] - 3
        @member_cha[x].bitmap = picture
        @member_cha[x].src_rect = rect
      else
        @member_cha[x].bitmap = nil
      end
      
      @member_cha[x].z = 255
      @member_cha[x].x = 16 + x * 68
      @member_cha[x].y = Status_win_sizey + 10 + 18
      @member_cha[x].visible = true
    end

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
    mozi = "パーティーを　へんこうせずに　おわりますか？"
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
    #@result_window.contents.draw_text(0,0, 300, 40, "このカードを使用しますか？")
    mozi = "しょじCAP：" + $game_variables[25].to_s
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @result_window.contents.blt(4,2, $tec_mozi,rect)
    mozi = "スキルを　セットするには　CAP：" + $cha_skill_set_get_val[@skill_list_put_skill_no[@skill_list_cursorstate-@skill_list_put_strat]].to_s
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @result_window.contents.blt(4,2+24, $tec_mozi,rect)
    mozi = "つかいます　セットしますか？"
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
        
      if @window_state == 0 && @p_cursor_y != 0 || @p_cursor_x !=0 || @put_party_cha_y != 0
        
        select_cha_no = chk_select_chano - 1
        
        if @member_list.index(@party_list[select_cha_no]) == nil && @member_list[@member_list.size - 1] != 0
          Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
        elsif @member_list.index(@party_list[select_cha_no]) != nil || @member_list[@member_list.size - 1] != 0
          #Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          
          #選択したキャラを削除
          @member_list = Marshal.load(Marshal.dump(@member_list.reject{|e| e == @party_list[select_cha_no]}))
          
          #0追加
          @member_list << 0
        else
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          @member_list[@member_list.index(0)] = @party_list[select_cha_no]
        end
      else
        if @member_list.index(0) != 0
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          $partyc = Marshal.load(Marshal.dump(@member_list))
          
          #0を削除
          $partyc = Marshal.load(Marshal.dump($partyc.reject{|e| e == 0}))
          #戦闘キャラ切り替え
          $game_variables[42] = $partyc[0]
          Graphics.fadeout(5)
          
          update_inparty_detail_status @call_state
          if @call_state == 1 #戦闘から呼ばれた
            $scene = Scene_Db_Battle.new ($battle_escape,$battle_bgm,$battle_ready_bgm)
          else #カードと時の間から呼ばれた時はマップに戻る
            Audio.bgm_play("Audio/BGM/" + $map_bgm)    # 効果音を再生する
            $scene = Scene_Map.new
          end
        else
          Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
        end
      end
    end
    if Input.trigger?(Input::B)
      @window_update_flag = true

      if @window_state == 0
        if @p_cursor_y != 0 || @p_cursor_x !=0 || @put_party_cha_y != 0
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          @p_cursor_y = 0
          @p_cursor_x = 0
          @put_party_cha_y = 0
        elsif @member_list.index(0) == 0
          Audio.se_play("Audio/SE/" + $BGM_Error)    # 効果音を再生する
        elsif @member_list.index(0) != nil
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          @member_list[@member_list.index(0) -1] = 0
        else
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
          @member_list[8] = 0
        end
      elsif @window_state == 1
        @window_state = 0
        @@cursorstate = @cursor_chara_select
      elsif @window_state == 3  
        @window_state = 2
        @skill_list_cursorstate = 0
        @skill_list_put_strat = 0
      elsif @window_state == 10 #スキルセット確認ウィンドウ
        @skill_set_result = 0
        @window_state = 3  
        dispose_result_window
      end

    end

    if Input.trigger?(Input::X)
      @window_update_flag = true
      Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      @member_list = Marshal.load(Marshal.dump($partyc))
      if @member_list.size < 9
      
        for x in 1..9-@member_list.size
          @member_list.push(0)
        end
      
      end
    end

    if Input.trigger?(Input::Y) #スキル切り替え
      
    end
    
    if Input.trigger?(Input::L)

    end
    
    if Input.trigger?(Input::R)

    end
    if Input.trigger?(Input::DOWN)
      #chk_up = true
      if @window_state == 0
        se_on = true
        move_cursor 2 #カーソル移動
      end
      
      if se_on == true
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      end
    elsif Input.trigger?(Input::UP)
      
      
      
      if @window_state == 0
        se_on = true
        move_cursor 8 #カーソル移動
      end
      
      if se_on == true
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      end
    elsif Input.trigger?(Input::RIGHT) #移動可能な時のみ音を鳴らす
      @window_update_flag = true
      if @window_state == 0
        se_on = true
        move_cursor 6 #カーソル移動
      end

      if se_on == true
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      end
    elsif Input.trigger?(Input::LEFT) #移動可能な時のみ音を鳴らす
      @window_update_flag = true
      if @window_state == 0
        se_on = true
        move_cursor 4 #カーソル移動
      end

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
    @status_window.dispose
    @status_window = nil
    @status_backwindow.dispose
    @status_backwindow = nil
    @Member_window.dispose
    @Member_window = nil
    @skill_list_window.dispose
    @skill_list_window = nil
  end 
  
  #--------------------------------------------------------------------------
  # ● ウインドウ内容クリア
  #--------------------------------------------------------------------------    
  def window_contents_clear
    @party_window.contents.clear
    @status_window.contents.clear
    @Member_window.contents.clear
    
    
    if @skill_list_window.visible == true
      @skill_list_window.contents.clear
    end
    if @result_window != nil
     @result_window.contents.clear
    end 
  end

  #--------------------------------------------------------------------------
  # ● ウインドウ作成
  #--------------------------------------------------------------------------   
  def create_window
    Graphics.fadeout(0)
    @party_window = Window_Base.new(Status_backwin_sizex,0,Party_win_sizex,Party_win_sizey)
    @party_window.opacity=255
    @party_window.back_opacity=255
    @Member_window = Window_Base.new(0,Status_win_sizey,Member_win_sizex,Member_win_sizey)
    @Member_window.opacity=255
    @Member_window.back_opacity=255
    @status_backwindow = Window_Base.new(0,0,Status_backwin_sizex,Status_backwin_sizey)
    @status_backwindow.opacity=255
    @status_backwindow.back_opacity=255
    @status_window = Window_Base.new(-4,0,Status_win_sizex,Status_win_sizey)
    @status_window.opacity=0
    @status_window.back_opacity=255
    @skill_list_window = Window_Base.new(Status_backwin_sizex,0,Skill_list_win_sizex,Skill_list_win_sizey)
    @skill_list_window.opacity=255
    @skill_list_window.back_opacity=255
    @skill_list_window.visible = false
    Graphics.fadein(10)
  end

  #--------------------------------------------------------------------------
  # ● カーソル表示
  #--------------------------------------------------------------------------  
  def output_cursor
    $cursor_blink_count += 1
    #picture = Cache.picture("アイコン")
    #rect = set_yoko_cursor_blink
    rect = set_tate_cursor_blink
    #キャラへカーソルを表示する
    @p_cursor.src_rect = rect
    @p_cursor.x = Status_backwin_sizex + 52 + Partyx * @p_cursor_x
    @p_cursor.y = 12 + Partyy * @p_cursor_y
    
    #はいいいえ表示
    if @result_window != nil 
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      @result_window.contents.blt(@skill_set_result*80+2,42+48,picture,rect)
    end
  end



  
  #--------------------------------------------------------------------------
  # ● 能力詳細表示
  #--------------------------------------------------------------------------   
  def output_status
    
    
    select_cha_no = chk_select_chano - 1

    tyouseix = 22
    
    if @p_cursor_y != 0 || @p_cursor_x !=0 || @put_party_cha_y != 0
      #picture = Cache.picture($top_file_name+"顔味方")
      #"if ($game_actors[@party_list[select_cha_no]].hp.prec_f / $game_actors[@party_list[select_cha_no]].maxhp.prec_f * 100).prec_i < $hinshi_hp || $chadead[@@cursorstate] == true#&& @call_state == 1
      #  rect,picture = set_character_face 1,@party_list[select_cha_no]-3
        #  rect = Rect.new(64, 0+((@party_list[select_cha_no]-3)*64), 64, 64) # 顔グラ
      #else
      
      #時の間ならキャラの表情は変えない
      if $game_variables[43] == 999
        rect,picture = set_character_face 0,@party_list[select_cha_no]-3
      else
        if $full_chadead[@party_list[select_cha_no]] == true #死亡時はモノクロを表示
          rect,picture = set_character_face 2,@party_list[select_cha_no]-3
          #rect = Rect.new(128, 0+(($partyc[x]-3)*64), 64, 64) # 顔グラ
        elsif ($game_actors[@party_list[select_cha_no]].hp.prec_f / $game_actors[@party_list[select_cha_no]].maxhp.prec_f * 100).prec_i < $hinshi_hp
          rect,picture = set_character_face 1,@party_list[select_cha_no]-3
          #rect = Rect.new(64, 0+(($partyc[x]-3)*64), 64, 64) # 顔グラ
        else
          rect,picture = set_character_face 0,@party_list[select_cha_no]-3
          #rect = Rect.new(0, 0+(($partyc[x]-3)*64), 64, 64) # 顔グラ
        end
      end
      #  rect = Rect.new(0, 0+((@party_list[select_cha_no]-3)*64), 64, 64) # 顔グラ
      #end
      @status_window.contents.blt(Status_lbx-16,Status_lby,picture,rect)
      picture = Cache.picture("カード関係")
      rect = set_card_frame 4 # 流派枠
      @status_window.contents.blt(Status_lbx-16 ,Status_lby+64,picture,rect)
      rect = Rect.new(32*($game_actors[@party_list[select_cha_no]].class_id-1), 64, 32, 32) # 流派
      @status_window.contents.blt(Status_lbx,Status_lby+64,picture,rect)
      picture = Cache.picture("数字英語")
      rect = Rect.new(64, 16, 32, 16) #LV
      @status_window.contents.blt(Status_lbx+80+tyouseix ,Status_lby+4,picture,rect)
      rect = Rect.new(0, 16, 32, 16) #HP
      @status_window.contents.blt(Status_lbx+80+tyouseix ,Status_lby+22,picture,rect) 
      rect = Rect.new(32, 16, 32, 16) #KI
      @status_window.contents.blt(Status_lbx+80+tyouseix ,Status_lby+58,picture,rect)
      rect = Rect.new(160, 0, 16, 16) # スラッシュ
      @status_window.contents.blt(Status_lbx+128+tyouseix,Status_lby+40,picture,rect)
      @status_window.contents.blt(Status_lbx+128+tyouseix,Status_lby+76,picture,rect)
      
      for y in 1..$game_actors[@party_list[select_cha_no]].level.to_s.size #LV
        rect = Rect.new($game_actors[@party_list[select_cha_no]].level.to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*16,Status_lby+4,picture,rect)
      end      
      
      for y in 1..$game_actors[@party_list[select_cha_no]].hp.to_s.size #HP
        
        if $game_actors[@party_list[select_cha_no]].hp.to_s.size <= 4
          rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].hp.to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*16,Status_lby+22,picture,rect)
        else
          case y
              
          when 1..2
            rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].hp.to_s[-y,1].to_i*8, 168, 8, 16)
            @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*8+8,Status_lby+22,picture,rect)
          else
            rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].hp.to_s[-y,1].to_i*16, 0, 16, 16)
            @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*16+16,Status_lby+22,picture,rect)
          end

        end
      end
      
      for y in 1..$game_actors[@party_list[select_cha_no]].maxhp.to_s.size #MHP
        if $game_actors[@party_list[select_cha_no]].maxhp.to_s.size <= 4
          rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].maxhp.to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*16,Status_lby+40,picture,rect)
        else
          case y
              
          when 1..2
            rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].maxhp.to_s[-y,1].to_i*8, 168, 8, 16)
            @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*8+8,Status_lby+40,picture,rect)
          else
            rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].maxhp.to_s[-y,1].to_i*16, 0, 16, 16)
            @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*16+16,Status_lby+40,picture,rect)
          end

        end
      end
      
      for y in 1..$game_actors[@party_list[select_cha_no]].mp.to_s.size #ki
        if $game_actors[@party_list[select_cha_no]].mp.to_s.size <= 4
          rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].mp.to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*16,Status_lby+58,picture,rect)
        else
          case y
              
          when 1..2
            rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].mp.to_s[-y,1].to_i*8, 168, 8, 16)
            @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*8+8,Status_lby+58,picture,rect)
          else
            rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].mp.to_s[-y,1].to_i*16, 0, 16, 16)
            @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*16+16,Status_lby+58,picture,rect)
          end

        end
      end
      
      for y in 1..$game_actors[@party_list[select_cha_no]].maxmp.to_s.size #mki
        if $game_actors[@party_list[select_cha_no]].maxmp.to_s.size <= 4
          rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].maxmp.to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*16,Status_lby+76,picture,rect)
        else
          case y
              
          when 1..2
            rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].maxmp.to_s[-y,1].to_i*8, 168, 8, 16)
            @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*8+8,Status_lby+76,picture,rect)
          else
            rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].maxmp.to_s[-y,1].to_i*16, 0, 16, 16)
            @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*16+16,Status_lby+76,picture,rect)
          end

        end
      end
      

      for y in 1..$game_actors[@party_list[select_cha_no]].atk.to_s.size #攻撃力
        rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].atk.to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*16,Status_lby+100,picture,rect)
      end

      for y in 1..$game_actors[@party_list[select_cha_no]].def.to_s.size #防御力
        rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].def.to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*16,Status_lby+124,picture,rect)
      end
      
      for y in 1..$game_actors[@party_list[select_cha_no]].agi.to_s.size #スピード
        rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].agi.to_s[-y,1].to_i*16, 0, 16, 16)
        @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*16,Status_lby+148,picture,rect)
      end
      
      for y in 1..$game_actors[@party_list[select_cha_no]].exp.to_s.size #経験値
        if $game_actors[@party_list[select_cha_no]].exp.to_s.size <= 11
          rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].exp.to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*16,Status_lby+172,picture,rect)
        else
          case y
              
          when 1..4
            rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].exp.to_s[-y,1].to_i*8, 168, 8, 16)
            @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*8+8,Status_lby+172,picture,rect)
          else
            rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].exp.to_s[-y,1].to_i*16, 0, 16, 16)
            @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*16+32,Status_lby+172,picture,rect)
          end

        end
      end
      
      if $game_actors[@party_list[select_cha_no]].level != $actor_final_level_default #レベル99だとうまく表示されないので
        for y in 1..$game_actors[@party_list[select_cha_no]].next_rest_exp_s.to_s.size #次のレベルまでの経験値
          rect = Rect.new(0+$game_actors[@party_list[select_cha_no]].next_rest_exp_s.to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*16,Status_lby+196,picture,rect)
        end
      else
          rect = Rect.new(0, 0, 16, 16)
          @status_window.contents.blt(Status_lbx+192+tyouseix,Status_lby+196,picture,rect)
      end
      
      #能力項目
      picture = Cache.picture("メニュー文字関係")
      rect = Rect.new(0, 192, 112, 116)
      @status_window.contents.blt(Status_lbx-16,Status_lby+96,picture,rect)
      
      picture = Cache.picture("数字英語")
      #撃破数がnilの場合0をセット
      $cha_defeat_num[@party_list[select_cha_no]] = 0 if $cha_defeat_num[@party_list[select_cha_no]] == nil
      
      for y in 1..$cha_defeat_num[@party_list[select_cha_no]].to_s.size #撃破数
          rect = Rect.new(0+$cha_defeat_num[@party_list[select_cha_no]].to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*16,Status_lby+220+(0*24),picture,rect)
      end
      
      #ZPがnilの場合0をセット
      $zp[@party_list[select_cha_no]] = 0 if $zp[@party_list[select_cha_no]] == nil
      
      for y in 1..$zp[@party_list[select_cha_no]].to_s.size #ZP
          rect = Rect.new(0+$zp[@party_list[select_cha_no]].to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(Status_lbx+192+tyouseix-(y-1)*16,Status_lby+220+(1*24),picture,rect)
        end
        
      picture = Cache.picture("メニュー文字関係")
      #撃破数
      mozi = "げきはすう"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @status_window.contents.blt(Status_lbx-14,Status_lby+212,$tec_mozi,rect)
      #@msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
      #rect = Rect.new(0, 376, 112, 20)
      #@status_window.contents.blt(Status_lbx-16,Status_lby+96,picture,rect)
      
      #ZP
      mozi = "ZP"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @status_window.contents.blt(Status_lbx-14,Status_lby+212+24,$tec_mozi,rect)
      
      if @call_state == 1 #戦闘時に呼ばれたらアイコン表示
        #界王様か最長老が使われているか？
        if $full_cha_power_up[@party_list[select_cha_no]] == true
          picture = Cache.picture("アイコン")
          rect = Rect.new(0, 16, 32, 32)
          @status_window.contents.blt(Status_lbx-14,Status_lby+212+24+24,picture,rect)
        end
        #ディフェンスアップ
        if $full_cha_defense_up[@party_list[select_cha_no]] == true
          picture = Cache.picture("アイコン")
          rect = Rect.new(32, 16, 32, 32)
          @status_window.contents.blt(Status_lbx-14+32,Status_lby+212+24+24,picture,rect)
        end
        #かなしばりターン数
        if $full_cha_stop_num[@party_list[select_cha_no]] == nil
          $full_cha_stop_num[@party_list[select_cha_no]] = 0
        end
        if $full_cha_stop_num[@party_list[select_cha_no]] > 0
          picture = Cache.picture("アイコン")
          rect = Rect.new(160, 16, 32, 32)
          @status_window.contents.blt(Status_lbx-14+32+32,Status_lby+212+24+24,picture,rect)          
          
          #回数表示
          picture = Cache.picture("数字英語")
          for y in 1..$full_cha_stop_num[@party_list[select_cha_no]].to_s.size
            rect = Rect.new($full_cha_stop_num[@party_list[select_cha_no]].to_s[-y,1].to_i*16, 48, 16, 16)
            @status_window.contents.blt(Status_lbx-14+32+32 - (y-1)*16 +16,Status_lby+212+24+24+16,picture,rect)
          end
        end
      end
      
    else
      #1行で14文字表示可能
      mozi =  "１２３４５６７８９０１２３４"

      mozi =  "・キャラクターを　ふやす\n"
      mozi += "　　　　　　　けっていボタン\n\n"
      mozi += "・キャラクターを　へらす\n"
      mozi += "　　　　　　　けっていボタン\n"
      mozi += "　　　　　　キャンセルボタン\n\n"
      mozi += "・へんせいを　リセット\n"
      mozi += "　　　　　　　Xボタン\n\n"
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
        @status_window.contents.blt(0,24*y,$tec_mozi,rect)
      end
    end
  end

  #--------------------------------------------------------------------------
  # ● パーティー一覧表示
  #-------------------------------------------------------------------------- 
  def output_party
    
    put_start = @put_party_cha_y * 4
    
    if 15 + put_start >= @party_cha.size
      put_end = @party_cha.size - 1 
    else
      put_end = 15 + put_start
    end
    
    puty = 30
    putyaki = 90
    
    x_count = 0
    y_count = 0
    
    #いったん全部非表示
    for x in 0..@party_cha.size - 1
      @party_cha[x].visible = false
    end
    
    
    for x in put_start..put_end
      @party_cha[x].y = (puty + y_count * putyaki).to_i
      @party_cha[x].visible = true
      
      if @member_list.index(@party_list[x]) == nil || x == 0
        @party_cha[x].opacity = 255
      else
        @party_cha[x].opacity = 128
      end
      x_count += 1
      
      if x_count == 4
        x_count = 0
        y_count += 1
      end
    end
  
    #カーソル表示管理
    @up_cursor.visible = false
    @down_cursor.visible = false
    
    if @put_party_cha_y != 0
      @up_cursor.visible = true
    end
    
    if @party_cha.size - 1 > put_end
      @down_cursor.visible = true
    end
  end



  #--------------------------------------------------------------------------
  # ● #カーソルが何人目を選択してるか計算
  #
  #--------------------------------------------------------------------------
  def chk_select_chano
    select_cha_no = @put_party_cha_y * 4 + @p_cursor_y * 4 + @p_cursor_x + 1
    
    return select_cha_no
  end
  #--------------------------------------------------------------------------
  # ● カーソル移動
  #引数:n (下:2 上:8 右:6 左:4)
  #--------------------------------------------------------------------------
  def move_cursor n

    #何人目を選択してるか計算
    select_cha_no = chk_select_chano
    
#@put_party_cha_y = 0 
    case n
    
    when 2 #下
        @p_cursor_y += 1
        #何人目を選択してるか計算
        select_cha_no = chk_select_chano
        if(@party_cha.size.to_f / 4).ceil.to_i - 1 < @p_cursor_y + @put_party_cha_y
          @p_cursor_y = 0
          @put_party_cha_y = 0
        elsif @p_cursor_y != 4
          
          if @party_cha.size < select_cha_no
            #p @party_cha.size % 4 - 1
            @p_cursor_x = @party_cha.size % 4 - 1 
          end
          
        else
          #p 1
          @p_cursor_y -= 1
          @put_party_cha_y += 1
          select_cha_no = chk_select_chano
          if @party_cha.size < select_cha_no
            #p @party_cha.size % 4 - 1
            @p_cursor_x = @party_cha.size % 4 - 1 
          end
        end

    when 8 #上
      
      if @put_party_cha_y == 0 && @p_cursor_y == 0
        if @party_cha.size > 16
          @put_party_cha_y = (@party_cha.size.to_f / 4).ceil.to_i - 4
          @p_cursor_y = 3
        else
          @p_cursor_y = (@party_cha.size.to_f / 4).ceil.to_i - 1
        end
        
        #何人目を選択してるか計算
        select_cha_no = chk_select_chano
        if @party_cha.size < select_cha_no
            #p @party_cha.size % 4 - 1
            @p_cursor_x = @party_cha.size % 4 - 1 
        end
      elsif @put_party_cha_y > 0 &&@p_cursor_y == 0
        @put_party_cha_y -= 1 
      else
        @p_cursor_y -= 1
      end
      
    when 6
      if @p_cursor_x == 3 || @party_cha.size - select_cha_no == 0
        @p_cursor_x = 0
      else
        @p_cursor_x += 1
      end
    when 4
      if @p_cursor_x == 0
        if @party_cha.size - (select_cha_no + 3) >= 0 
          @p_cursor_x = 3
        else
          @p_cursor_x = @party_cha.size % 4 - 1
        end
        
      else
        @p_cursor_x -= 1
      end
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
      #@Member_window.visible = true
      @status_window.dispose
      @status_window = nil
      @status_window = Window_Base.new(0,0,Status_win_sizex,Status_win_sizey)
      @status_window.opacity=255
      @status_window.back_opacity=255
      #@status_window.height = Status_win_sizey
      
    else
      #スキル
      @status_window.dispose
      @status_window = nil
      @status_window = Window_Base.new(0,0,Status_win_sizex,Party_win_sizey)
      @status_window.opacity=255
      @status_window.back_opacity=255
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