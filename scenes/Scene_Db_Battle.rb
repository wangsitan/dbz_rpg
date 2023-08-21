#==============================================================================
# ■ Scene_Db_Battle
#------------------------------------------------------------------------------
# 　戦闘開始時のメイン処理
#==============================================================================
class Scene_Db_Battle < Scene_Base
  include Share
  #メインウインドウ表示位置
  Mainxstr = 16
  Mainystr = 348#350
  Mainxend = 128
  Mainyend = 118#116
  #カードウインドウ表示位置
  Cardxstr = 10
  Cardystr = 330
  Cardxend = 680
  Cardyend = 210
  Cardsize = 64 #カードサイズ
  Cardoutputkizyun = 118 #カード基準位置
  Cardup = 22 #カード選択時に上がる量 
  #キャラクターステータス表示位置
  Chastexstr = 10
  Chasteystr = 15
  Chastexend = 620
  Chasteyend = 196
  Chastelv = 84
  Chastex = 92#90 #x軸+量
  #メッセージウインドウ表示位置
  Msgxstr = 144
  Msgystr = 348
  Msgxend = 470
  Msgyend = 118
  Technique_backwin_sizex = 296     #必殺技ウインドウサイズX
  Technique_backwin_sizey = 236     #必殺技ウインドウサイズY
  Technique_win_sizex = Technique_backwin_sizex + 48     #必殺技ウインドウサイズX
  Technique_win_sizey = Technique_backwin_sizey     #必殺技ウインドウサイズY
  Tec_help_win_sizex = Technique_backwin_sizex + 52 #必殺技ヘルプウィンドウサイズX
  Tec_help_win_sizey = Technique_backwin_sizey #必殺技ヘルプウィンドウサイズX
  Tec_help_backwin_sizex = Technique_backwin_sizex + 24 #必殺技ヘルプ背景ウィンドウサイズX
  Tec_help_backwin_sizey = Technique_backwin_sizey #必殺技ヘルプ背景ウィンドウサイズX
  Techniquex = 16 + 2                #必殺技表示基準X
  Techniquey = 0                #必殺技表示基準Y
  MSG_ROW_SIZE = 20   #メッセージウインドウ行サイズ
  
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #引数(escape:戦闘から逃げれるか[true:逃げれる,false:逃げれない]
  #    (bgm:戦闘曲[0:デフォルト] ready_bgm:戦闘前曲[0:デフォルト]
  #--------------------------------------------------------------------------
  def initialize(escape = true,bgm = 0,ready_bgm = 0)
    $battle_bgm = bgm         #戦闘曲
    $battle_ready_bgm = ready_bgm #戦闘前曲
    $battle_escape = escape   #戦闘から逃げれるか
    
    #スキル名変更
    skill_name_chg
  end

  #--------------------------------------------------------------------------
  # ● スプライト開放
  #--------------------------------------------------------------------------
  def dispose_sprite
    @right_cursor.bitmap = nil
    @left_cursor.bitmap = nil
    @msg_cursor.bitmap = nil
    @right_cursor = nil
    @left_cursor = nil
    @msg_cursor = nil
    @up_cursor.bitmap = nil
    @down_cursor.bitmap = nil
    @up_cursor = nil
    @down_cursor = nil
    @sprite_cha_put_icon_hanigaimae.bitmap = nil
    @sprite_cha_put_icon_hanigaiato.bitmap = nil
    @sprite_cha_put_icon_hanigaimae = nil
    @sprite_cha_put_icon_hanigaiato = nil
=begin
    @scouter_l_cursor.bitmap = nil
    @scouter_r_cursor.bitmap = nil
    @scouter_u_cursor.bitmap = nil
    @scouter_back.bitmap = nil
    @scouter_cardf.bitmap = nil
    @scouter_carda.bitmap = nil
    @scouter_cardg.bitmap = nil
    @scouter_cardi.bitmap = nil
    @scouter_cha.bitmap = nil
    @scouter_cha_hp_mozi.bitmap = nil
    @scouter_cha_hp_1keta.bitmap = nil
    @scouter_cha_hp_2keta.bitmap = nil
    @scouter_cha_hp_3keta.bitmap = nil
    @scouter_cha_hp_4keta.bitmap = nil
    @scouter_l_cursor = nil
    @scouter_r_cursor = nil
    @scouter_u_cursor = nil
    @scouter_back = nil
    @scouter_cardf = nil
    @scouter_carda = nil
    @scouter_cardg = nil
    @scouter_cardi = nil
    @scouter_cha = nil
    @scouter_cha_hp_mozi = nil
    @scouter_cha_hp_1keta = nil
    @scouter_cha_hp_2keta = nil
    @scouter_cha_hp_3keta = nil
    @scouter_cha_hp_4keta = nil
=end
  end
  #--------------------------------------------------------------------------
  # ● スカウター関係スプライト開放
  #--------------------------------------------------------------------------
  def dispose_scouter_sprite

    @scouter_l_cursor.bitmap = nil
    @scouter_r_cursor.bitmap = nil
    @scouter_u_cursor.bitmap = nil
    @scouter_back.bitmap = nil
    @scouter_cardf.bitmap = nil
    @scouter_carda.bitmap = nil
    @scouter_cardg.bitmap = nil
    @scouter_cardi.bitmap = nil
    @scouter_cha.bitmap = nil
    @scouter_cha_hp_mozi.bitmap = nil
    @scouter_cha_hp_1keta.bitmap = nil
    @scouter_cha_hp_2keta.bitmap = nil
    @scouter_cha_hp_3keta.bitmap = nil
    @scouter_cha_hp_4keta.bitmap = nil
    @scouter_cha_hp_5keta.bitmap = nil
    @scouter_cha_hp_6keta.bitmap = nil
    @scouter_cha_hp_7keta.bitmap = nil
    @scouter_l_cursor = nil
    @scouter_r_cursor = nil
    @scouter_u_cursor = nil
    @scouter_back = nil
    @scouter_cardf = nil
    @scouter_carda = nil
    @scouter_cardg = nil
    @scouter_cardi = nil
    @scouter_cha = nil
    @scouter_cha_hp_mozi = nil
    @scouter_cha_hp_1keta = nil
    @scouter_cha_hp_2keta = nil
    @scouter_cha_hp_3keta = nil
    @scouter_cha_hp_4keta = nil
    @scouter_cha_hp_5keta = nil
    @scouter_cha_hp_6keta = nil
    @scouter_cha_hp_7keta = nil
    @right_cursor.visible = false
    @left_cursor.visible = false
    @msg_cursor.visible = false
    @up_cursor.visible = false
    @down_cursor.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    
    Graphics.fadeout(10)
    $game_switches[11] = false
    #create_enemy_card
    set_attack_order
    
    #TEMPに格納
    tmp_cha_btl_cont_part_turn = [0,0,0,0,0,0,0,0,0]
    tmp_btlmbr = []
    #($cardset_cha_no.size-1).step(0, -1) do |x|
    for x in 0..$cardset_cha_no.size-1
    
      if $cardset_cha_no[x] != 99
        get_battle_skill $partyc[$cardset_cha_no[x]],x,1
        
        tmp_btlmbr << $cardset_cha_no[x]
        
        
        #戦闘に参加しているキャラはカウント+1
        tmp_cha_btl_cont_part_turn[$cardset_cha_no[x]] += 1
        
        #光の旅計算
        hikaritrun = 0 #0なら取得していないという判定で
        meterdot = 0 #メーターの増加量
      
        hikaritrun,meterdot = chk_hikarinotabirun($partyc[$cardset_cha_no[x]])
      
        #光の旅を覚えていたら処理する
        if hikaritrun != 0
          #変数初期化
          $cha_hikari_turn[$partyc[$cardset_cha_no[x]]] = 0 if $cha_hikari_turn[$partyc[$cardset_cha_no[x]]] == nil
        
          #戦闘に参加していればターン数を追加する
          if $cha_hikari_turn[$partyc[$cardset_cha_no[x]]] <= hikaritrun
            $cha_hikari_turn[$partyc[$cardset_cha_no[x]]] += 1
          end
        end
      end
    end
    
    #降順ソート
    tmp_btlmbr = tmp_btlmbr.sort {|a, b| b <=> a }
    #p tmp_btlmbr
    for x in 0..tmp_btlmbr.size-1
      #先手
        #p $cardset_cha_no[x],$cha_sente_flag[$cardset_cha_no[x]]
        if $cha_sente_flag[tmp_btlmbr[x]] == true || $cha_sente_card_flag[tmp_btlmbr[x]] == true
          #p $cardset_cha_no[x]
          
          
          #p $attack_order,$cardset_cha_no[x]
          $attack_order.delete($cardset_cha_no.index(tmp_btlmbr[x]))
          $attack_order.unshift($cardset_cha_no.index(tmp_btlmbr[x]))
        end
      
    end
    
    #$full_cha_btl_cont_part_turn[$partyc[x]]
    #戦闘時のみ前のターンと参加ターンをFIX
    if @@battle_main_result == 1
      for x in 0..$cha_btl_cont_part_turn.size-1
        
        if tmp_cha_btl_cont_part_turn[x] == 0
          $cha_btl_cont_part_turn[x] = 0
          
          #パーティーサイズと異なることがあるので、チェックしておかないとエラーが出る
          if $partyc.size > x
            $full_cha_btl_cont_part_turn[$partyc[x]] = 0 if $full_cha_btl_cont_part_turn[$partyc[x]] == nil
            $full_cha_btl_cont_part_turn[$partyc[x]] = 0
          end
        else
          $cha_btl_cont_part_turn[x] += 1
          
          #nilなら初期化
          #p $full_cha_btl_cont_part_turn,$full_cha_btl_cont_part_turn[$partyc[x]],x,$partyc[x]
          $full_cha_btl_cont_part_turn[$partyc[x]] = 0 if $full_cha_btl_cont_part_turn[$partyc[x]] == nil
          $full_cha_btl_cont_part_turn[$partyc[x]] += 1
        end
          
      end
      
      #パーティーに居ないキャラの参加ターン数を初期化
      for x in 0..$full_cha_btl_cont_part_turn.size - 1
        if $partyc.index(x) == nil
          $full_cha_btl_cont_part_turn[x] = 0
        end
      end
    end
    #p $attack_order
    #dispose_sprite
    dispose_window
    for x in 1..$attack_anime_max
      $attack_anime[x] = 0
    end
    Graphics.fadein(0)
    #if @@battle_main_result == 2 || @@battle_main_result == 4
    #  p @@battle_main_result
    #  pre_terminate
    #end
    #$game_variables[16] = result
    $game_switches[3] = false
    $game_switches[10] = false
    Audio.se_stop
    
    #アイコン種類初期化
    $battle_icon_syurui = [nil,nil,nil,nil,nil,nil,nil,nil,nil]
    
    $fullpower_on_flag = []
    #パーティー先頭キャラを変更  
    $game_variables[42] = $partyc[0]
    
    #レベルアップSEをMEで流したときに邪魔なのでここで止める
    Audio.me_stop
  end
  
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def my_terminate
    
    #戦闘勝利したとき
    if @@battle_main_result != 4 && @@battle_main_result != 3
      
      #戦いの記録追記しないかチェック
      if $game_switches[121] == false
        #戦闘勝利回数
        $game_variables[202] += 1
        
        #お気に入りキャラカード購入用カウント
        $game_variables[228] += 1
        #味方撃破数格納
        for x in 0..$battle_enedead_cha_no.size - 1
          if $battle_enedead_cha_no[x] != nil #nil は自爆した敵
            cha_defeat_num_add $battle_enedead_cha_no[x]
          end
        end
        #敵個別撃破数格納
        for x in 0..$battleenemy.size - 1
          
          #べジータ大猿なら通常に戻す
          $battleenemy[x] = 12 if $battleenemy[x] == 26
          
          #ターレス大猿なら通常に戻す
          $battleenemy[x] = 59 if $battleenemy[x] == 70
          $battleenemy[x] = 233 if $battleenemy[x] == 222
          
          #スラッグ巨大化なら通常に戻す
          $battleenemy[x] = 255 if $battleenemy[x] == 223
          
          ene_defeat_num_add $battleenemy[x]
        end
        #p $cha_defeat_num,$ene_defeat_num
        
        if $game_switches[125] == false
          #ダメージ与えた合計
          for x in 0..$tmp_cha_attack_damege.size - 1
            $cha_attack_damege[x] = 0 if $cha_attack_damege[x] == nil
            $cha_attack_damege[x] += $tmp_cha_attack_damege[x] if $tmp_cha_attack_damege[x] != nil
          end
          #ダメージ食らった合計
          for x in 0..$tmp_cha_gard_damege.size - 1
            $cha_gard_damege[x] = 0 if $cha_gard_damege[x] == nil
            $cha_gard_damege[x] += $tmp_cha_gard_damege[x] if $tmp_cha_gard_damege[x] != nil
          end
          #最大ダメージ(与えた)
          if $game_variables[205] > $game_variables[203]
            $game_variables[203] = $game_variables[205]
            $game_variables[204] = $game_variables[206]
            $game_variables[214] = $game_variables[215]
          end
          
          #最大ダメージ(受けた)
          if $game_variables[209] > $game_variables[207]
            $game_variables[207] = $game_variables[209]
            $game_variables[208] = $game_variables[210]
            $game_variables[216] = $game_variables[217]
          end
        end
        
        #ダメージ与えた回数
        for x in 0..$tmp_cha_attack_count.size - 1
          $cha_attack_count[x] = 0 if $cha_attack_count[x] == nil
          $cha_attack_count[x] += $tmp_cha_attack_count[x] if $tmp_cha_attack_count[x] != nil
        end
        #ダメージ食らった回数
        for x in 0..$tmp_cha_gard_count.size - 1
          $cha_gard_count[x] = 0 if $cha_gard_count[x] == nil
          $cha_gard_count[x] += $tmp_cha_gard_count[x] if $tmp_cha_gard_count[x] != nil
        end
        
        #スカウターを使用し能力詳細表示フラグ
        if $run_scouter == true
          for x in 0..$battleenemy.size - 1
            if $run_scouter_ene[x] == true
              $ene_sco_history_flag[$battleenemy[x]] = true
            end
          end
        end
      end
      
      #全回復フラグONなら全回復
      if $game_switches[141] == true
        all_charecter_recovery
      end
    else #逃げた場合
      $game_variables[213] += 1 #逃走回数プラス1
    end
    $game_switches[4] = false
    $game_switches[2] = false
    $game_switches[1] = false
    $enehp = [nil] #敵現在HP
    $enemp = [nil] #敵現在MP
    $enedead = [nil] #敵死亡状態
    $attack_order = [nil] #攻撃順
    @@chk_attack_order = [nil] #攻撃順チェック用
    $game_variables[60] = $battleenemy[0] #最後に戦った敵キャラ
    $battleenemy = [nil] #戦闘時敵キャラNo
    $enedeadchk = [nil] #敵死亡状態チェック用
    $eneselfdeadchk = [nil] #敵自爆死亡状態チェック用
    $cardset_cha_no = [99,99,99,99,99,99]
    $cha_power_up = []
    $ene_power_up = []
    $cha_stop_num = [0,0,0,0,0,0,0,0,0]        #動けないターン数
    $ene_stop_num = [0,0,0,0,0,0,0,0,0]        #動けないターン数
    $cha_defense_up = []
    $one_turn_cha_defense_up = false   #ヤジロベーが使われているか？
    $ene_defense_up = false   #ヤジロベーが使われているか？
    $run_scouter = false      #スカウターをオフ
    $run_godscouter_card = false #ゴッドスカウターをオフ
    $run_scouter_ene = [false,false,false,false,false,false,false,false,false]
    
    $cha_ki_zero = [false,false,false,false,false,false,false,false,false] #必殺技カードの効果
    $cha_wakideru_rand = [999,999,999,999,999,999,999,999,999]      #湧き出る力スキル用乱数
    $cha_wakideru_flag = [false,false,false,false,false,false,false,false,false] #湧き出る力スキル有効フラグ
    $cha_ki_tameru_rand = [0,0,0,0,0,0,0,0,0]      #気を溜めるスキル用乱数
    $cha_ki_tameru_flag = [false,false,false,false,false,false,false,false,false] #気を溜めるスキル有効フラグ
  
    $cha_sente_rand = [0,0,0,0,0,0,0,0,0]      #senteスキル用乱数
    $cha_sente_flag = [false,false,false,false,false,false,false,false,false] #気を溜めるスキル有効フラグ
  
    #指定ターン数で戦闘終了を解く
    #戦闘終了時のターン数を変数に格納する
    $game_variables[320] = $battle_turn_num
    $game_variables[94] = 0
    $battle_turn_num = 0      #ターン数
    $battle_turn_num_chk_flag = false #ターン数カウントフラグ
    $battle_enedead_cha_no = []
    
    #ブリーフ博士が使われていた場合
    chk_val = 311
    if $game_variables[chk_val] > 0 
      if @@battle_main_result == 3
        $game_variables[chk_val] = 0
      else
        $game_variables[chk_val] -= 1
      end
    end
    #亀の甲羅が使われていた場合
    chk_val = 312
    if $game_variables[chk_val] > 0 
      if @@battle_main_result == 3
        $game_variables[chk_val] = 0
      else
        $game_variables[chk_val] -= 1
      end
    end
    #重い道着が使われていた場合
    chk_val = 313
    if $game_variables[chk_val] > 0 
      if @@battle_main_result == 3
        $game_variables[chk_val] = 0
      else
        $game_variables[chk_val] -= 1
      end
    end
    $tmp_cha_attack_damege　=[] #一時ダメージ与えた
    $tmp_cha_gard_damege = [] #一時ダメージ食らった
    $tmp_cha_attack_count　=[] #一時ダメージ与えた回数
    $tmp_cha_gard_count = [] #一時ダメージ食らった回数
    $cha_btl_cont_part_turn = [0,0,0,0,0,0,0,0,0] #戦闘連続参加ターン
    #べジータ大猿使用済み
    $battle_begi_oozaru_run = false
    
    #ターレス大猿使用済み
    $battle_tare_oozaru_run = false
    
    #スラッグ巨大化使用済み
    $battle_sura_big_run = false
    
    #リベンジャーチャージ
    $battle_ribe_charge = false
    $battle_ribe_charge_turn = false
    
    #戦闘関係のフラグ初期化
    reset_battle_flag

    #スーパーサイヤ人変身を解く
    off_super_saiyazin_all
    
    #大猿状態を解く
    off_oozaru_all
    
    #イベントNoを増やすかチェック
    chk_set_event_no
    
    #戦闘用のfull系の配列初期化
    reset_full_party_list
=begin
    #ボス系を倒した場合はイベントNoを1増やす
    #本当はここに書きたくないけど旨く動かないからここに書く
    if $game_variables[41]  == 59 #ラディッツ
      $game_variables[41] += 1
    elsif $game_variables[41]  == 93 #サンショ
      $game_variables[41] += 1
    elsif $game_variables[41]  == 103 #ニッキー
      $game_variables[41] += 1
    elsif $game_variables[41]  == 113 #ジンジャー
      $game_variables[41] += 1
    elsif $game_variables[41]  == 122 #ガーリック
      $game_variables[41] += 1
    elsif $game_variables[41]  == 126 #ガーリック巨大化
      $game_variables[41] += 1
    elsif $game_variables[41]  == 130 #界王様
      $game_variables[41] = 132
    elsif $game_variables[41]  == 155 #ベジータ
      $game_variables[41] += 1
    elsif $game_variables[41]  == 832#ラディッツ(バーダック編)
      $game_variables[41] += 1
    elsif $game_variables[41]  == 308 #異星人
      $game_variables[41] += 1
    elsif $game_variables[41]  == 340 #ドドリア
      $game_variables[41] += 1
    elsif $game_variables[41]  == 425 #カナッサ星
      $game_variables[41] += 1
    elsif $game_variables[41]  == 440 #ザーボン
      $game_variables[41] += 1
    elsif $game_variables[41]  == 443 #ザーボン変身
      $game_variables[41] += 1
    elsif $game_variables[41]  == 452 #ギニュー特選隊
      $game_variables[41] += 1
    elsif $game_variables[41]  == 472 #フリーザ
      $game_variables[41] += 1
    elsif $game_variables[41]  == 480 #フリーザ
      $game_variables[41] += 1
    elsif $game_variables[41]  == 485#フリーザ
      $game_variables[41] += 1
    elsif $game_variables[41]  == 493#フリーザ
      $game_variables[41] = 498
    elsif $game_variables[41]  == 497#フリーザ
      $game_variables[41] = 498
      if $game_switches[104] == true #超ベジータ戦闘判定
        if $game_actors[14].level > $game_actors[12].level
          $game_switches[105] = true
          
        end
      end
    elsif $game_variables[41]  == 501#超ベジータ
      $game_variables[41] += 1
    elsif $game_variables[41]  == 1107#フリーザ(フルパワー)
      $game_variables[41] = 1151
    elsif $game_variables[41]  ==  1197 #クラズ(最初の基地のボス
      $game_variables[41] = 1200
    elsif $game_variables[41]  ==  1216 #イール(最初の基地のボス
      $game_variables[41] = 1217
    end
=end
    $game_switches[128] = false #戦闘終了後イベントNo追加
    $game_variables[95] = 0     #戦闘終了後指定イベントへ
    $battle_bgm = 0
    $battle_ready_bgm = 0
    #ループ様変数初期化
    $bgm_name = nil
    $bgm_str_time = nil
    
    #通常の戦闘の時のみオートセーブ
    #かつ勝利した時のみ
    if $game_variables[41] == 0 && @@battle_main_result != 4
      DDS::Auto_Save::save()
    end
  end
  #--------------------------------------------------------------------------
  # ● イベントNoを変更するかチェック
  #--------------------------------------------------------------------------  
  def chk_set_event_no
    if $game_switches[128] == true #変更フラグがONならば
      
      if $game_variables[95] == 0 #指定Noへ移動が0ならば追加1
        $game_variables[41] += 1
      else
        $game_variables[41] = $game_variables[95] #0以外なら指定をセット
      end
      
      #Z2超ベジータ戦への例外処理
      if $game_switches[104] == true #超ベジータ戦闘判定
        #if $game_actors[14].level > $game_actors[12].level
          $game_switches[105] = true
        #end
      end
      
    end
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_window
    @menu_window.dispose
    @menu_window = nil
    @card_window.dispose
    @card_window = nil
    @status_window.dispose
    @status_window = nil
    @hp_window.dispose
    @hp_window = nil
    @back_window.dispose
    @back_window = nil
    dispose_msg_window
    dispose_techniqu_window
    dispose_tec_help_window
    dispose_btl_menu_window
  end
  #--------------------------------------------------------------------------
  # ● メッセージウインドウ開放
  #--------------------------------------------------------------------------  
  def dispose_btl_menu_window
    if @btl_menu_window != nil
      @btl_menu_window.dispose
      @btl_menu_window = nil
    end
  end
  #--------------------------------------------------------------------------
  # ● メッセージウインドウ開放
  #--------------------------------------------------------------------------  
  def dispose_techniqu_window
    if @technique_window != nil
      @technique_window.dispose
      @technique_window = nil
      @technique_backwindow.dispose
      @technique_backwindow = nil
    end
  end
  
  #--------------------------------------------------------------------------
  # ● メッセージウインドウ開放
  #--------------------------------------------------------------------------  
  def dispose_tec_help_window
    if @tec_help_window != nil
      @tec_help_window.dispose
      @tec_help_window = nil
      @tec_help_backwindow.dispose
      @tec_help_backwindow = nil
    end
  end
  #--------------------------------------------------------------------------
  # ● メッセージウインドウ開放
  #--------------------------------------------------------------------------    
  def dispose_msg_window
    if @msg_window != nil
      @msg_window.dispose
      @msg_window = nil
    end
  end
  
  #--------------------------------------------------------------------------
  # ● ウインドウ内容クリア
  #--------------------------------------------------------------------------   
  def window_contents_clear
    if @menu_window != nil
      @menu_window.contents.clear
    end
    if @card_window != nil
      @card_window.contents.clear
    end
    
    if @back_window != nil
      @back_window.contents.clear
    end
    if @msg_window != nil
      @msg_window.contents.clear
    end
    if @btl_menu_window != nil
      @btl_menu_window.contents.clear
    end
    
    #重いので個別に
    #if @technique_window != nil
    #  @technique_window.contents.clear
    #end
    
    if @hp_window != nil
      @hp_window.contents.clear
    end
  end
  
  #--------------------------------------------------------------------------
  # ● ウインドウ作成
  #--------------------------------------------------------------------------  
  def create_window

    # バックウインドウ作成(色・背景・敵キャラ)
    @back_window = Window_Base.new(-30,-30,700,540)
    @back_window.opacity=0
    @back_window.back_opacity=0

    # バックウインドウ作成(色・背景・敵キャラ)
    @hp_window = Window_Base.new(-30,-30,700,540)
    @hp_window.opacity=0
    @hp_window.back_opacity=0
    @hp_window.z=256
    
    # カードウインドウ作成(カード用)
    @card_window = Window_Base.new(Cardxstr,Cardystr,Cardxend,Cardyend)
    @card_window.opacity=0
    @card_window.back_opacity=0

    # メニューウインドウ表示
    @menu_window = Window_Base.new(Mainxstr,Mainystr,Mainxend,Mainyend)
    @menu_window.opacity=255
    @menu_window.back_opacity=255

    # キャラステータスウインドウ表示
    @status_window = Window_Base.new(Chastexstr,Chasteystr,Chastexend,Chasteyend)
    @status_window.opacity=255
    @status_window.back_opacity=255
  end
  #--------------------------------------------------------------------------
  # ● ウインドウ作成
  #--------------------------------------------------------------------------   
  def create_menu_window
    @menu_window = Window_Base.new(Mainxstr,Mainystr,Mainxend,Mainyend)
    @menu_window.opacity=255
    @menu_window.back_opacity=255
  end  
  #--------------------------------------------------------------------------
  # ● ウインドウ作成
  #--------------------------------------------------------------------------   
  def create_btl_menu_window
    @btl_menu_window = Window_Base.new(Mainxstr,Mainystr+26,Mainxend,Mainyend-26)
    @btl_menu_window.opacity=255
    @btl_menu_window.back_opacity=255
  end
  
  #--------------------------------------------------------------------------
  # ● メッセージウインドウ作成
  #--------------------------------------------------------------------------   
  def create_msg_window
    @msg_window = Window_Base.new(Msgxstr,Msgystr,Msgxend,Msgyend)
    @msg_window.opacity=255
    @msg_window.back_opacity=255
    @msg_window.contents.font.color.set( 0, 0, 0)
    @msg_window.contents.font.size = 17.5
  end
  #--------------------------------------------------------------------------
  # ● 必殺技ウインドウ作成
  #--------------------------------------------------------------------------   
  def create_tec_window
    #@technique_window = Window_Base.new(166,Chasteystr+Chasteyend,Technique_win_sizex+4,Technique_win_sizey)
    @technique_backwindow = Window_Base.new(10,Chasteystr+Chasteyend,Technique_backwin_sizex+4,Technique_backwin_sizey)
    @technique_backwindow.opacity=255
    @technique_backwindow.back_opacity=255
    @technique_backwindow.contents.font.color.set( 0, 0, 0)
    @technique_backwindow.contents.font.size = 18
    
    @technique_window = Window_Base.new(10-4,Chasteystr+Chasteyend,Technique_win_sizex+4,Technique_win_sizey)
    @technique_window.opacity=0
    @technique_window.back_opacity=0
    @technique_window.contents.font.color.set( 0, 0, 0)
    @technique_window.contents.font.size = 18

    @tec_help_backwindow = Window_Base.new(@technique_backwindow.x + @technique_backwindow.width ,Chasteystr+Chasteyend,Tec_help_backwin_sizex,Tec_help_backwin_sizey)
    @tec_help_backwindow.opacity=255
    @tec_help_backwindow.back_opacity=255
    @tec_help_backwindow.contents.font.color.set( 0, 0, 0)
    @tec_help_backwindow.contents.font.size = 18
    
    @tec_help_window = Window_Base.new(@technique_backwindow.x + @technique_backwindow.width - 8,Chasteystr+Chasteyend,Tec_help_win_sizex,Tec_help_win_sizey)
    @tec_help_window.opacity=0
    @tec_help_window.back_opacity=0
    @tec_help_window.contents.font.color.set( 0, 0, 0)
    @tec_help_window.contents.font.size = 18
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super

    #$WinState = 98
    #$CursorState = 0
    @temp_carda = []                        #スキルで攻防の星を弄ったのを戻すよう
    @temp_cardg = []                        #スキルで攻防の星を弄ったのを戻すよう
    $temp_cardi = []                        #スキルで流派を弄ったのを戻すよう
    $cursor_blink_count = 0                 #カーソル点滅
    @battle_str_cursor_state = 0            #戦闘開始確認カーソル(Xを押した時のやつ)
    @total_exp = 0                          #取得経験値合計
    @total_cap = 0                          #取得キャパシティ合計
    @total_sp  = 0                          #取得スキルポイント合計
    @card_ryuha_blink_count = 0             #カード点滅カウント
    @@chk_attack_order = []                 #攻撃順番(チェック用)
    @@card_set_no = [99,99,99,99,99,99]     #カードをセットした順番(戻すよう)
    @@battle_cha_cursor_state = -1           #味方キャラカーソル位置
    @@battle_ene_cursor_state = 0           #敵キャラキャラカーソル位置
    @@card_set_count = 0                    #攻撃をセットしたキャラ数
    @battle_cha_num = 0                     #有効味方キャラ数
    @@battle_main_result = 0                #戦闘処理結果
    @output_cha_window_state = 0            #キャラウインドウ表示位置0:1-6 1:2-7
    @chk_select_cursor_control_flag = false #調整したか
    
    create_window
    @right_cursor = Sprite.new
    @left_cursor = Sprite.new
    @sprite_cha_put_icon_hanigaimae = Sprite.new
    @sprite_cha_put_icon_hanigaimae.bitmap = Cache.picture("アイコン")
    @sprite_cha_put_icon_hanigaiato = Sprite.new
    @sprite_cha_put_icon_hanigaiato.bitmap = Cache.picture("アイコン")
    @sprite_cha_put_icon_hanigaimae.visible = false
    @sprite_cha_put_icon_hanigaiato.visible = false
    @scouter_l_cursor = Sprite.new
    @scouter_l_cursor.bitmap = Cache.picture("アイコン")
    @scouter_l_cursor.visible = false
    @scouter_l_cursor.z = 255
    @scouter_l_cursor.src_rect = Rect.new(16*28, 0, 16, 16)
    @scouter_r_cursor = Sprite.new
    @scouter_r_cursor.bitmap = Cache.picture("アイコン")
    @scouter_r_cursor.visible = false
    @scouter_r_cursor.z = 255
    @scouter_r_cursor.angle = 181
    @scouter_r_cursor.src_rect = Rect.new(16*28, 0, 16, 16)
    @scouter_u_cursor = Sprite.new
    @scouter_u_cursor.bitmap = Cache.picture("アイコン")
    @scouter_u_cursor.visible = false
    @scouter_u_cursor.z = 255
    @scouter_u_cursor.angle = 91
    @scouter_u_cursor.src_rect = Rect.new(16*28, 0, 16, 16)
    @scouter_cursor_count = 0 #点滅管理
    @scouter_cursor_move_count = 0 #移動管理
    @scouter_damage_count = 0 #破壊時のフレーム管理
    @scouter_search_count = 0 #人造人間のフレーム管理
    @scouter_back = Sprite.new
    @scouter_back.visible = false
    @scouter_back.z = 254
    @scouter_back_bitmap = Bitmap.new(640,137)
    color = Color.new(56,104,0,255)
    @scouter_back_bitmap.fill_rect(0,0,640,137,color)
    @scouter_back.bitmap = @scouter_back_bitmap
    @scouter_cardf = Sprite.new
    @scouter_carda = Sprite.new
    @scouter_cardg = Sprite.new
    @scouter_cardi = Sprite.new
    
    @scouter_carda.visible = false
    @scouter_cardg.visible = false
    @scouter_cardi.visible = false
    @scouter_cardf.visible = false
    @scouter_carda.z = 253
    @scouter_cardg.z = 253
    @scouter_cardi.z = 253
    @scouter_cardf.z = 253
    @scouter_carda.bitmap = Cache.picture("カード関係")
    @scouter_cardg.bitmap = Cache.picture("カード関係")
    @scouter_cardi.bitmap = Cache.picture("カード関係")
    @scouter_cardf.bitmap = Cache.picture("カード関係")
    @scouter_carda.src_rect = set_card_frame 2,1
    @scouter_cardg.src_rect = set_card_frame 3,1
    @scouter_cardi.src_rect = Rect.new(0 + 32 * 1, 64, 32, 32)
    @scouter_cardf.src_rect = set_card_frame 0
    @scouter_cha = Sprite.new
    @scouter_cha.visible = false
    @scouter_cha.z = 253
    @scouter_cha_move_count = 0
    @scouter_cha_num = $enedead.index(false)
    @scouter_cha_hp_mozi = Sprite.new
    @scouter_cha_hp_mozi.visible = false
    @scouter_cha_hp_mozi.bitmap = Cache.picture("数字英語")
    @scouter_cha_hp_mozi.src_rect = Rect.new(0, 16, 32, 16)
    @scouter_cha_hp_mozi.z = 255
    @scouter_cha_hp_1keta = Sprite.new
    @scouter_cha_hp_1keta.visible = false
    @scouter_cha_hp_1keta.bitmap = Cache.picture("数字英語")
    @scouter_cha_hp_1keta.z = 255
    @scouter_cha_hp_2keta = Sprite.new
    @scouter_cha_hp_2keta.visible = false
    @scouter_cha_hp_2keta.bitmap = Cache.picture("数字英語")
    @scouter_cha_hp_2keta.z = 255
    @scouter_cha_hp_3keta = Sprite.new
    @scouter_cha_hp_3keta.visible = false
    @scouter_cha_hp_3keta.bitmap = Cache.picture("数字英語")
    @scouter_cha_hp_3keta.z = 255
    @scouter_cha_hp_4keta = Sprite.new
    @scouter_cha_hp_4keta.visible = false
    @scouter_cha_hp_4keta.bitmap = Cache.picture("数字英語")
    @scouter_cha_hp_4keta.z = 255
    @scouter_cha_hp_5keta = Sprite.new
    @scouter_cha_hp_5keta.visible = false
    @scouter_cha_hp_5keta.bitmap = Cache.picture("数字英語")
    @scouter_cha_hp_5keta.z = 255
    @scouter_cha_hp_6keta = Sprite.new
    @scouter_cha_hp_6keta.visible = false
    @scouter_cha_hp_6keta.bitmap = Cache.picture("数字英語")
    @scouter_cha_hp_6keta.z = 255
    @scouter_cha_hp_7keta = Sprite.new
    @scouter_cha_hp_7keta.visible = false
    @scouter_cha_hp_7keta.bitmap = Cache.picture("数字英語")
    @scouter_cha_hp_7keta.z = 255
    @scouter_cha_hp_hyouzi = 0
    @scouter_back_count = 0
    @scouter_run_put_card = false
    @scouter_put_end = false #カード表示、またはHP表示後
    @scouter_next_go = false #カード表示、またはHP表示後に決定ボタンを押した
    @msg_cursor = Sprite.new
    @msg_cursor.bitmap = Cache.picture("アイコン")
    @msg_cursor.visible = false
    @msg_cursor.src_rect = set_tate_cursor_blink
    @msg_cursor.x = 320+52
    @msg_cursor.y = 480 -16-14
    @msg_cursor.z = 255
    @btl_menu_fight_back_color = set_skn_color 1
    @btl_menu_fight_back = Sprite.new
    @btl_menu_fight_back.bitmap = Cache.picture("メニューたたかう_背景")
    @btl_menu_fight_back.bitmap.fill_rect(0,0,64,18,@btl_menu_fight_back_color)
    @btl_menu_fight_back.x = Mainxstr+34
    @btl_menu_fight_back.y = Mainystr+20
    @btl_menu_fight_back.z = 253
    @btl_menu_fight_back.visible = false
    @btl_menu_fight = Sprite.new
    @btl_menu_fight.bitmap = Cache.picture("メニュー文字関係")
    @btl_menu_fight.src_rect = Rect.new(66, 9, 64, 16)
    
    @scombo_flag = false #Sコンボ条件が果たしたか？(発動ウィンドウ表示用)
    @btl_menu_fight.x = Mainxstr+34
    @btl_menu_fight.y = Mainystr+22
    @btl_menu_fight.z = 253
    @btl_menu_fight.visible = false
    @btl_menu_fight_back.visible = false
    
    @cha_put_icon = Array.new(9,Array.new())
    
    #@cha_put_icon[0] << "AD"
    #p @cha_put_icon[0]
    @cha_put_icon_tenmetu = Array.new(9,0)

    #スキル発動表示
    @cha_put_icon_hanigaimae = [] #発動スキル格納
    @cha_put_icon_hanigaiato = [] #発動スキル格納
    @battle_icon_syurui_hanigaimae = 0 #点滅時に表示するスキル
    @battle_icon_syurui_hanigaiato = 0 #点滅時に表示するスキル
    @cha_put_icon_tenmetu_hanigaimae = 0 #点滅管理
    @cha_put_icon_tenmetu_hanigaiato = 0 #点滅管理
    #for x in 0..@cha_put_icon_tenmetu.size - 1
    #  p @cha_put_icon_tenmetu[x]
    #end
    
    @window_update_flag = true
    @tecwinupdate_flag = false #必殺技ウィンドウ更新フラグ

    @run_puthp = false #スカウター使用後Xボタンを押して敵のHPを表示しているか
    #シナリオ進行度によってファイル名の頭文字を変える
    chk_scenario_progress
    #詳細からステータスやカードに飛ぶとウインドウが消えているので
    if $WinState == 5 && @msg_window == nil
      create_msg_window
    end
    
    #カードから敵キャラ選択へ行った場合のカーソル初期設定
    if $WinState == 7
      @@battle_ene_cursor_state = chk_select_cursor_control (2,@@battle_ene_cursor_state,0,0,$battleenenum-1)#その場からチェック
    end
    
    #指定の技の必殺技が存在しない場合初期化
    #フリーザ戦の超サイヤ人変身イベントなど、ここで実行しておかないと
    #悟空が超元気玉を作戦に設定してオートを選ぶとエラー落ちすることの対策
    for x in 0..$partyc.size - 1
      set_tactec_learn $partyc[x],$cha_tactics[7][$partyc[x]],$game_actors[$partyc[x]].skills[0].id
    end
    
    #ターン数増加
    if $battle_turn_num_chk_flag == false
      
      #Sコンボ使用しないフラグ
      $cha_single_attack = [false,false,false,false,false,false,false,false,false]
      
      #Sコンボ優先度最新化(ここで処理をしておかないと、パーティー変更時にエラーになる事がある
      update_player_scombo_priority
      
      #亀仙人の魔封波ひらめき可能チェック
      run_common_event 38

      for x in 0..$MAX_ACTOR_NUM
        #その他発動スキル用
        $full_cha_mzenkai_num[x] = rand(100) + 1 #ミラクル全開パワー

        $full_cha_wakideru_flag[x] = false #湧き出る力フラグ初期化
        $full_cha_wakideru_rand[x] = rand(100)+1      #湧き出る力スキル用乱数
        $full_cha_ki_tameru_flag[x] = false #気を溜めるフラグ初期化
        $full_cha_ki_tameru_rand[x] = rand(100)+1      #気を溜めるスキル用乱数
        $full_cha_sente_flag[x] = false #先手フラグ初期化
        $full_cha_sente_rand[x] = rand(100)+1      #先手スキル用乱数
      end
      
      #状態更新 fullからpartyへ
      update_inparty_detail_status 1
      
      #p $full_chadead
      
      #M全開パワーと気まぐれようループ
      for x in 0..$cha_mzenkai_num.size - 1
        $create_card_num = x
        #カードランダムスキル用
        $cha_carda_rand[x] = rand(8)
        $cha_cardg_rand[x] = rand(8)
        $cha_cardi_rand[x] = create_card_i 0

        #発動フラグの更新
        if x <= $partyc.size - 1
          set_skill_nil_to_zero $partyc[x]
          get_mp_cost $partyc[x],1 #湧き出る力フラグ更新のためチェックを実行
          get_skill_kiup $partyc[x] #気を溜めるフラグ更新のためチェックを実行
          get_skill_sente $partyc[x] #先手フラグ更新のためチェックを実行
        end

      end
      
      #敵のカード生成
      create_enemy_card

      #敵のカードで流派一致 or 必にする必要があるか
      for x in 0..$battleenenum -1
        ryuhakakuritu_keisan x,$battleenemy[x]
      end
      
      $battle_turn_num += 1 #戦闘ターン数
   
      #2ターン目以降であれば敵のHP回復が必要か？
      if $battle_turn_num > 1
        #合計damage出力フラグをON
        if $game_switches[1305] == true
          $btl_put_sumdamage_flag = true
        end
        
        for x in 0..$battleenenum -1
          
          tmpeneno = $battleenemy[x]
          #敵が死んでいないかつ、リカバー率が0より大きいかつ、最大HPより小さい、
          #かつ 現在HPが0より大きい(倒しても再度攻撃してしまう事があり、ここが原因かわからないが、とりあえず対策としていれておく
          if $enedead[x] == false && $ene_add_para_hprecover[tmpeneno] > 0 &&
            $enehp[x] < $data_enemies[tmpeneno].maxhp && $enehp[x] > 0

            #HP回復
            $enehp[x] += (($ene_add_para_hprecover[tmpeneno].to_f / 100) * $data_enemies[tmpeneno].maxhp.to_f).to_i
            
            #回復後のHPが最大値を超えてたら最大値に合わせる
            if $enehp[x] > $data_enemies[tmpeneno].maxhp
              $enehp[x] = $data_enemies[tmpeneno].maxhp
            end
            
          end
        end
      end
      
      #2ターン目以降であれば味方HpKi回復
      if $battle_turn_num > 1
        turn_recover_hpki  #&& $enedeadchk.index(false) != nil
        
        #ここで初期化しないと、戦闘キャラしか反映されないのでここで処理
        $fullpower_on_flag = []
      end
      
      $battle_turn_num_chk_flag = true
      for x in 0..$battleenemy.size - 1
        $ene_enc_history_flag[$battleenemy[x]] = true
      end
      
      #ストップターン数を減らす
      for x in 0..$partyc.size - 1
        #p $cha_btl_cont_part_turn[x]
        if $cha_stop_num[x] > 0 && $cha_btl_cont_part_turn[x] == 0
          $cha_stop_num[x] -= 1
          
          if $full_cha_stop_num == nil || $full_cha_stop_num == [] || $full_cha_stop_num[$partyc[x]] == nil
            $full_cha_stop_num[$partyc[x]] = 0
          end
          $full_cha_stop_num[$partyc[x]] -= 1
        end
      end
      
      #スキルのブランクチェック
      for x in 0..$partyc.size - 1
        set_skill_nil_to_zero $partyc[x]
      end
      
#フリーザ戦などイベントで超サイヤ人になった時に、必殺技を初期化しないとエラーになるので一応毎回実行する
=begin
      #指定の技の必殺技が存在しない場合初期化
      for x in 0..$partyc.size - 1
        
        set_tactec_learn $partyc[x],$cha_tactics[7][$partyc[x]],$game_actors[$partyc[x]].skills[0].id
        #if chk_tec_learn($partyc[x],$cha_tactics[7][$partyc[x]]) == false
        #    $cha_tactics[7][$partyc[x]] = $game_actors[$partyc[x]].skills[0].id
        #end
      end
=end      
      #リベンジャーチャージターン使用ターンを解除
      $battle_ribe_charge_turn = false
    end

    
    pre_update
    @display_skill_level = -1
    @tecput_page = 0
    @tecput_max = 7
    @up_cursor = Sprite.new
    @down_cursor = Sprite.new
    set_up_down_cursor
    Graphics.fadein(40)
    
    #戦闘前の曲を流すか
    #オプション、またはシステムで指定されていれば戦闘前曲
    #または曲固定(たった一人の最終決戦)
    #p $game_variables[319]
    if $game_variables[319] == 0 && $battle_ready_bgm == 0 ||
      $game_variables[429] == 0 && $battle_ready_bgm == 0 && $game_laps >= 1 && $battle_escape == false ||
      $game_switches[111] == true
      set_battle_bgm
    else
      set_battle_ready_bgm
    end

    #Sコンボ切り替えチェック
    run_common_event 205

  end

  #--------------------------------------------------------------------------
  # ● 必殺技表示ページの設定
  #-------------------------------------------------------------------------- 
  def set_tecpage add
    
    if ($game_actors[$partyc[@@battle_cha_cursor_state]].skills.size-1) / @tecput_max > 0
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
        @tecput_page = ($game_actors[$partyc[@@battle_cha_cursor_state]].skills.size-1) / @tecput_max
      end
    end
    
    if ($game_actors[$partyc[@@battle_cha_cursor_state]].skills.size - 1) / @tecput_max > 0
      $MenuCursorState = 0
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
    @up_cursor.x = 640/2 - 8 - 156
    @up_cursor.y = Chasteyend+Chasteystr+16+32
    @up_cursor.z = 255
    @up_cursor.angle = 91
    @up_cursor.visible = false
    
    #下カーソル
    # スプライトのビットマップに画像を設定
    @down_cursor.bitmap = Cache.picture("アイコン")
    @down_cursor.src_rect = Rect.new(16*5, 0, 16, 16)
    @down_cursor.x = 640/2 + 8 - 156
    @down_cursor.y = Chasteyend+Chasteystr+Technique_win_sizey-16
    @down_cursor.z = 255
    @down_cursor.angle = 269
    @down_cursor.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 画面更新
  #--------------------------------------------------------------------------    
  def pre_update
    input_fast_fps
    window_contents_clear
    output_back
    
    if @window_update_flag == true
      @status_window.contents.clear
      output_status
      @window_update_flag = false
    end

    output_card
    output_menu
    if @technique_window != nil && @tecwinupdate_flag == true
     output_technique
    end
   
    output_btl_icon
    output_cursor
    
    @card_window.update
    @menu_window.update
    @status_window.update
    @back_window.update
  end
  
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------   
  def output_btl_icon
    
    x = @output_cha_window_state
    for y in 0..$partyc.size - 1
      
      if $battle_icon_syurui[y] == nil
        #p @cha_put_icon[x][0]
        
        if @cha_put_icon[y][0] != nil
          $battle_icon_syurui[y] = 0
        end
      else
        if @cha_put_icon_tenmetu[y] >= 60
          if @cha_put_icon[y].size - 1 != $battle_icon_syurui[y]
            $battle_icon_syurui[y] += 1
          else
            $battle_icon_syurui[y] = 0
          end
          @cha_put_icon_tenmetu[y] = 0
        end
      end
    end
    

    
    begin
      #if $battle_icon_syurui = [nil,nil,nil,nil,nil,nil,nil,nil,nil]
      picture = Cache.picture("アイコン")
      if $cha_set_action[x] != 0 #行動決定済み
        rect = Rect.new(32, 0, 16, 16) # 行動決定済み
        @status_window.contents.blt(32+(x-@output_cha_window_state)*Chastex ,18,picture,rect)
      elsif $chadead[x] == true
        rect = Rect.new(48, 0, 16, 16) # 死亡アイコン
        @status_window.contents.blt(32+(x-@output_cha_window_state)*Chastex ,18,picture,rect)
      elsif $cha_stop_num[x] != 0
        rect = Rect.new(16*27, 0, 16, 16) # 行動不可
        @status_window.contents.blt(32+(x-@output_cha_window_state)*Chastex ,18,picture,rect)
        
      else
        
        if @cha_put_icon[x][0] != nil && @@battle_cha_cursor_state != x
          #スキル文字表示
          output_btl_skill_icon 5,@cha_put_icon[x][$battle_icon_syurui[x]],(32+(x-@output_cha_window_state)*Chastex)
        end

      end

      @cha_put_icon_tenmetu[x] += 1
      x += 1
      
    end while x != $partyc.size && x != 6 + @output_cha_window_state
    
    #範囲外前
    #p @cha_put_icon_hanigaimae
    if @cha_put_icon_hanigaimae != []
      putx=7
      puty=60
      if @cha_put_icon_tenmetu_hanigaimae >= 60
        if @cha_put_icon_hanigaimae.size - 1 != @battle_icon_syurui_hanigaimae
          @battle_icon_syurui_hanigaimae += 1
        else
          @battle_icon_syurui_hanigaimae = 0
        end
        @cha_put_icon_tenmetu_hanigaimae = 0
      end
      
      #スキル文字表示
      output_btl_skill_icon 4,@cha_put_icon_hanigaimae[@battle_icon_syurui_hanigaimae],putx,puty

      @cha_put_icon_tenmetu_hanigaimae += 1
      
    end
    
    #p @cha_put_icon_hanigaiato
    #範囲外後ろ
    if @cha_put_icon_hanigaiato != []
      putx=619
      puty=60
      if @cha_put_icon_tenmetu_hanigaiato >= 60
        if @cha_put_icon_hanigaiato.size - 1 != @battle_icon_syurui_hanigaiato
          @battle_icon_syurui_hanigaiato += 1
        else
          @battle_icon_syurui_hanigaiato = 0
        end
        @cha_put_icon_tenmetu_hanigaiato = 0
      end
      #スキル文字表示
      output_btl_skill_icon 6,@cha_put_icon_hanigaiato[@battle_icon_syurui_hanigaiato],putx,puty

      @cha_put_icon_tenmetu_hanigaiato += 1
      
    end
    
  end
  #--------------------------------------------------------------------------
  # ● 発動スキルのアイコン表示
  # skill_mozi:表示するスキル文字
  # putx:座標
  # puty:座標
  #--------------------------------------------------------------------------   
  def output_btl_skill_icon mode,skill_mozi,putx=0,puty=18
    picture = Cache.picture("アイコン")
    case skill_mozi

    when "RD"
      rect = Rect.new(16*3, 64, 16, 16) # D 回避
    when "RF"
      rect = Rect.new(16*5, 64, 16, 16) # F 先手
    when "RK"  
      rect = Rect.new(16*10, 64, 16, 16) # K 気を溜める
    when "RM"
      rect = Rect.new(16*12, 64, 16, 16) # M M全開パワー
    when "BW"
      rect = Rect.new(16*22, 80, 16, 16) # W 必殺 KI ゼロ
    else
      #p "スキル文字出力でエラーが発生しています(skill_mozi):" + skill_mozi.to_s
      rect = Rect.new(16*0, 0, 0, 0) #エラー回避
    end
    
    if mode == 5
      @status_window.contents.blt(putx ,puty,picture,rect)
    elsif mode == 4
      @sprite_cha_put_icon_hanigaimae.src_rect = rect
      @sprite_cha_put_icon_hanigaimae.x = putx
      @sprite_cha_put_icon_hanigaimae.y = puty
      @sprite_cha_put_icon_hanigaimae.z = 255
      @sprite_cha_put_icon_hanigaimae.visible = true
    elsif mode == 6
      @sprite_cha_put_icon_hanigaiato.src_rect = rect
      @sprite_cha_put_icon_hanigaiato.x = putx
      @sprite_cha_put_icon_hanigaiato.y = puty
      @sprite_cha_put_icon_hanigaiato.z = 255
      @sprite_cha_put_icon_hanigaiato.visible = true
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------   
  def update
    result=0
    chkkeypush = false
    if $battleenenum != $enedead.size
      p "サイズが違う"
      p "battleenenum:" + $battleenenum.to_s , "$enedead.size:" + $enedead.size.to_s
    end
    #super
    
    battlechacount #戦闘有効キャラ更新
    pre_update
    if @msg_window != nil
      @msg_window.update
    end

    chk_battle_start if @battle_cha_num != 0
    chk_new_tecspark #閃き必殺覚えた
    chk_new_scombo #Sコンボ覚えた
    chk_damage_counter #戦闘練習のダメージカウント表示
    
    #p $WinState
    
    #死亡チェックはメニュー操作以外に実行する
    chk_character_dead if $WinState != 5
    chk_all_character_dead if $WinState != 5
    chk_enemy_dead
    
    #===============================================
    #以下例外処理開始
    #===============================================
    #フリーザ戦で仲間が初めて死んだ
    if $game_switches[103] == true && $game_switches[104] == false && @@battle_main_result != 2 && @@battle_main_result != 3
      @@battle_main_result = 8
    end
    

    #指定ターン経過したら終了 変数が5の場合は6ターン目に入った時点で
    if $game_variables[94] != 0 && $game_variables[94] + 1 <= $battle_turn_num
      @@battle_main_result = 9
    end
    #===============================================
    #以下例外処理終了
    #===============================================
    
    if @@battle_main_result == 0 #戦闘終了前だけキーを受け取る
      if Input.press?(Input::X) && $WinState == 0 && $run_scouter_ene.index(true) != nil
          if @run_puthp == false
            Audio.se_play("Audio/SE/" + "Z1 スカウター測定")    # 効果音を再生する
            #@scouter_back.visible = true
            #@scouter_back.y = 226
            #@scouter_back.blend_type = 1
            #color = Color.new(56,104,0,255)
            #@scouter_back_bitmap.fill_rect(0,0,640,100,color)
            @run_puthp = true
          else
            #@run_puthp = true
          end
      else
        
        if  $WinState != 98 && $WinState != 99
          @run_puthp = false
          @scouter_back.visible = false
        end
        
        if Input.trigger?(Input::C)
          window_key_state "C"
          chkkeypush = true
        end
        if Input.trigger?(Input::B)
          window_key_state "B"
          chkkeypush = true
        end
        
        if Input.trigger?(Input::Y)
          window_key_state "Y"
          chkkeypush = true
        end
        
        if Input.trigger?(Input::X)
          window_key_state "X"
          chkkeypush = true
        end
        if Input.trigger?(Input::L)
          window_key_state "L"
          chkkeypush = true
        end 
        if Input.trigger?(Input::R)
          window_key_state "R"
          chkkeypush = true
        end 

        #必殺技を選ぶ時に斜め入力でエラーが出るのでどれか一つだけ受け取る
        if Input.trigger?(Input::DOWN)
          window_key_state 2
          chkkeypush = true
        elsif Input.trigger?(Input::UP)
          window_key_state 8
          chkkeypush = true
        elsif Input.trigger?(Input::RIGHT)
          window_key_state 6
          chkkeypush = true
        elsif Input.trigger?(Input::LEFT)
          window_key_state 4
          chkkeypush = true
        end
=begin
        if Input.trigger?(Input::DOWN)
          window_key_state 2
          chkkeypush = true
        end
        if Input.trigger?(Input::UP)
          window_key_state 8
          chkkeypush = true
        end
        if Input.trigger?(Input::RIGHT)
          window_key_state 6
          chkkeypush = true
        end
        if Input.trigger?(Input::LEFT)
          window_key_state 4
          chkkeypush = true
        end
=end
      end

    end
    
    #戦闘開始確認ウインドウが表示されていないときと
    #詳細ウインドウ表示時のみウインドウを消す
    if $WinState != 4 && $WinState != 5  
      dispose_msg_window
      @msg_cursor.visible = false if @msg_cursor != nil
    end

    case @@battle_main_result 
    
    when 1 #戦闘開始
      #p "戦闘開始"
      #$game_temp.next_scene = "db_battle_anime"
      #$game_temp.next_scene = "gameover
      
      Graphics.fadeout(5)
      @btl_menu_fight_back.visible = false
      @btl_menu_fight.visible = false
      dispose_sprite
      #for x in 0..$cardset_cha_no.size-1
      #  if $cardset_cha_no[x] != 99
      #    get_battle_skill $partyc[$cardset_cha_no[x]],x,1
      #  end
      #end

      $scene = Scene_Db_Battle_Anime.new
    when 2 #敵全滅
      Graphics.wait(30)
      Graphics.fadeout(20)
      dispose_sprite
      $game_variables[21] = 0
      $game_variables[239] = 0 #全滅後指定イベントへ変数初期化
      $put_battle_bgm = false
      #my_terminate

      #前の戦闘で全滅したフラグ
      $game_switches[142] = false
      #前の戦闘で撃破したフラグ
      $game_switches[143] = true
      #前の戦闘でターン経過フラグ
      $game_switches[144] = false
      
      $scene = Scene_Map.new
    when 3 #味方全滅
      Graphics.wait(30)
      Graphics.fadeout(20)
      $put_battle_bgm = false
      if $game_variables[239] != 0 #全滅後指定イベントへ
        $game_variables[21] = 0
        dispose_sprite
        my_terminate
        $game_variables[41] = $game_variables[239]
        $game_variables[239] = 0 #全滅後指定イベントへ変数初期化
        #前の戦闘で全滅したフラグ
        $game_switches[142] = true
        #前の戦闘で撃破したフラグ
        $game_switches[143] = false
        #前の戦闘でターン経過フラグ
        $game_switches[144] = false
        $scene = Scene_Map.new
      elsif $game_variables[41] != 130 #界王様と戦っているか
        dispose_sprite
        #$scene = Scene_Map.new
        Graphics.wait(30)
        my_terminate
        Graphics.fadeout(20)
        $scene = Scene_Gameover.new
      else
        $game_variables[41] += 1
        $game_variables[52] = $enehp[0]
        all_charecter_recovery #全キャラ回復
        $game_switches[62] = true #界王様に負けたフラグ
        dispose_sprite
        $scene = Scene_Map.new
      end
    when 4 #逃げた場合
      Graphics.wait(10)
      Graphics.fadeout(20)
      #Audio.bgm_play("Audio/BGM/" + $map_bgm )
      dispose_sprite
      $put_battle_bgm = false
      my_terminate
      $scene = Scene_Map.new
    when 8 #例外処理中
      #フリーザ戦で誰か死ぬ(悟空超サイヤ人変身)
      $game_variables[56] = $enehp[0]
      $game_variables[41] += 1
      Graphics.wait(30)
      Graphics.fadeout(20)
      dispose_sprite
      $put_battle_bgm = false
      $scene = Scene_Map.new
    when 9 #ターンで戦闘終了
      #イベントNoを増やすかチェック
      my_terminate
      Graphics.wait(30)
      Graphics.fadeout(20)
      dispose_sprite
      $game_variables[239] = 0 #全滅後指定イベントへ変数初期化
      $put_battle_bgm = false
      #前の戦闘で全滅したフラグ
      $game_switches[142] = false
      #前の戦闘で撃破したフラグ
      $game_switches[143] = false
      #前の戦闘でターン経過フラグ
      $game_switches[144] = true
      $scene = Scene_Map.new
    end
    
#ボタン連打でエラーが出るようなので処理を前に持っていく
=begin
    #===============================================
    #以下例外処理
    #===============================================
    #フリーザ戦で仲間が初めて死んだ
    if $game_switches[103] == true && $game_switches[104] == false && @@battle_main_result != 2 && @@battle_main_result != 3
      $game_variables[56] = $enehp[0]
      $game_variables[41] += 1
      Graphics.wait(30)
      Graphics.fadeout(20)
      dispose_sprite
      $put_battle_bgm = false
      $scene = Scene_Map.new
    end
    

    #指定ターン経過したら終了 変数が5の場合は6ターン目に入った時点で
    if $game_variables[94] != 0 && $game_variables[94] + 1 <= $battle_turn_num
      #イベントNoを増やすかチェック
      my_terminate
      Graphics.wait(30)
      Graphics.fadeout(20)
      dispose_sprite
      $game_variables[239] = 0 #全滅後指定イベントへ変数初期化
      $put_battle_bgm = false
      #前の戦闘で全滅したフラグ
      $game_switches[142] = false
      #前の戦闘で撃破したフラグ
      $game_switches[143] = false
      #前の戦闘でターン経過フラグ
      $game_switches[144] = true
      $scene = Scene_Map.new
    end
=end
    if chkkeypush == true
      @window_update_flag = true
    end 
  end
  
  #--------------------------------------------------------------------------
  # ● 背景・色・敵キャラ表示
  #--------------------------------------------------------------------------   
  def output_back
    color = set_skn_color 0
    @back_window.contents.fill_rect(0,0,680,510,color)
     #背景取得
    
     
     
    if $WinState != 98 && $WinState != 99
      
      if $game_switches[466] != true #戦闘背景を特殊進行度で格納するか
        chk_scenario_progress $game_variables[40],3
      else
        chk_scenario_progress $game_variables[301],3
      end
      if @run_puthp == false
        #p $Battle_MapID,$btl_map_top_file_name
        picture = Cache.picture($btl_map_top_file_name + "戦闘_背景")
        rect = Rect.new(0, 100*$Battle_MapID, 640, 100) # 背景         
        @back_window.contents.blt(14 , 240,picture,rect)
      else
        #color = Color.new(255,255,255,128)
        color = Color.new(0,0,0,128)
        @back_window.contents.fill_rect(0,240,672,100,color)
        @scouter_back.visible = true
            @scouter_back.y = 226
            @scouter_back.blend_type = 1
            @scouter_back.z = 100
            #p @scouter_back.height
            color = Color.new(56,104,0,255)
            @scouter_back_bitmap.clear_rect(0, 100, 640, 39)
            @scouter_back_bitmap.fill_rect(0,0,640,100,color)
      
        
      end
    
    
      for x in 0..$battleenenum -1
        if $enedead[x] == false #敵死亡確認死んでいたら黒に
          
          if $battleenemy[x] < $ene_str_no[1]
            if ($enehp[x].prec_f / $data_enemies[$battleenemy[x]].maxhp.prec_f * 100).prec_i < $hinshi_hp
              rect = Rect.new(64, $battleenemy[x]*64, 64, 64) # Z1_顔敵
            else
              rect = Rect.new(0, $battleenemy[x]*64, 64, 64) # Z1_顔敵
            end
          elsif $battleenemy[x] < $ene_str_no[2]
            if ($enehp[x].prec_f / $data_enemies[$battleenemy[x]].maxhp.prec_f * 100).prec_i < $hinshi_hp
              rect = Rect.new(64, ($battleenemy[x]-$ene_str_no[1]+1).to_i*64, 64, 64) # Z1_顔敵
            else
              rect = Rect.new(0, ($battleenemy[x]-$ene_str_no[1]+1).to_i*64, 64, 64) # Z1_顔敵
            end
          else
            if ($enehp[x].prec_f / $data_enemies[$battleenemy[x]].maxhp.prec_f * 100).prec_i < $hinshi_hp
              rect = Rect.new(64, ($battleenemy[x]-$ene_str_no[2]+1).to_i*64, 64, 64) # Z1_顔敵
            else
              rect = Rect.new(0, ($battleenemy[x]-$ene_str_no[2]+1).to_i*64, 64, 64) # Z1_顔敵
            end
          #else
          #  if ($enehp[x].prec_f / $data_enemies[$battleenemy[x]].maxhp.prec_f * 100).prec_i < $hinshi_hp
          #    rect = Rect.new(64, ($battleenemy[x]-$ene_str_no[3]+1).to_i*64, 64, 64) # Z1_顔敵
          #  else
          #    rect = Rect.new(0, ($battleenemy[x]-$ene_str_no[3]+1).to_i*64, 64, 64) # Z1_顔敵
          #  end
          end
        else
          rect = Rect.new(0, 0, 64, 64) # Z1_顔敵
        end
        top_name = set_ene_str_no $battleenemy[x]
        picture = Cache.picture(top_name + "顔敵") #敵キャラ
        
        if $battleenenum != 9
          #8体まで
          
          putx = 640/2-18-($battleenenum-1)*40+x*80
          
          #@back_window.contents.blt(640/2-18-($battleenenum-1)*40+x*80, 260,picture,rect) # 真ん中
          
        else
          #9体
          
          putx = 640/2-18+48-($battleenenum-1)*40+x*68
          #@back_window.contents.blt(640/2-18+48-($battleenenum-1)*40+x*68, 260,picture,rect) # 真ん中
        end
        
        #敵顔グラ出力
        @back_window.contents.blt(putx, 260,picture,rect) # 真ん中
        
        #敵行動停止回数出力
        
        #オプションで表示全てか敵のみか
        if $game_variables[356] == 0 || $game_variables[356] == 2
        
          if $ene_stop_num[x] != 0 && $enedead[x] == false
            picture = Cache.picture("数字英語")
            #p $ene_stop_num[x].to_s.size,$ene_stop_num[x]
            
            for y in 1..$ene_stop_num[x].to_s.size
              rect = Rect.new($ene_stop_num[x].to_s[-y,1].to_i*16, 48, 16, 16)
              @back_window.contents.blt(putx + 48 - (y-1)*16, 260 + 48,picture,rect)
            end
            
          end
        end
        
        if @run_puthp == true
          
          if $run_scouter_ene[x] == true
            picture = Cache.picture("数字英語")
            mozi = $enehp[x].to_s
            output_mozi $enehp[x].to_s
            rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
            #color = Color.new(200,240,128)
            $tec_mozi.change_tone(200,240,128)
            
            if $battleenenum != 9
              @hp_window.contents.blt(640/2-18-($battleenenum-1)*40+64+x*80-($enehp[x].to_s.size)*16, 260-24,$tec_mozi,rect)
            else
              @hp_window.contents.blt(640/2-18+48-($battleenenum-1)*40+64+x*68-($enehp[x].to_s.size)*16, 260-24,$tec_mozi,rect)
            end
          end
        end
      end
    
    else
      color = Color.new(0,0,0,0)
      @back_window.contents.fill_rect(0,225,680,137,color)
      if @scouter_cha_move_count == 0
        
        
        @scouter_l_cursor.y = 259
        @scouter_l_cursor.x = 640/2-110
        @scouter_r_cursor.y = 259+15
        @scouter_r_cursor.x = 640/2+110
        @scouter_u_cursor.y = 259 + 86
        @scouter_u_cursor.x = 640/2 - 8
        @scouter_back.visible = true
        @scouter_back.y = 211
        @scouter_l_cursor.visible = true 
        @scouter_r_cursor.visible = true 
        @scouter_u_cursor.visible = true
        @scouter_cha.color = Color.new ( 0,256,0,160)
        #@scouter_cha.tone = Tone.new ( 0,255,0)
        @scouter_cha.y = 211
        #@scouter_cha.x = 640/2-64
        @scouter_cha.x = 640
        @scouter_cha.blend_type = 1
        @scouter_back.blend_type = 1
        color = Color.new(56,104,0,255)
        @scouter_back_bitmap.fill_rect(0,0,640,139,color)
        top_name = set_ene_str_no $battleenemy[@scouter_cha_num]
        
        @scouter_cha.bitmap = Cache.picture(top_name + "戦闘_敵_" + $data_enemies[$battleenemy[@scouter_cha_num]].name)
        
        #巨大キャラかどうか
        if $data_enemies[$battleenemy[@scouter_cha_num]].element_ranks[23] != 1
          @scouter_cha.src_rect = Rect.new(0, 8*96, 96, 96)
          @scouter_cha.zoom_x = 1
          @scouter_cha.zoom_y = 1
        else
          @scouter_cha.src_rect = Rect.new(0, 8*192, 192, 192)
          @scouter_cha.zoom_x = 0.5
          @scouter_cha.zoom_y = 0.5
        end
        @scouter_cha.visible = true
        @scouter_cha.x = 640
        @scouter_cha_move_count = 0
        @scouter_cursor_move_count = 0
        @scouter_cha_hp_hyouzi = 0
        @scouter_cursor_count = 0
        @scouter_cha_hp_mozi.y = 213
        @scouter_cha_hp_1keta.y = @scouter_cha_hp_mozi.y
        @scouter_cha_hp_2keta.y = @scouter_cha_hp_mozi.y
        @scouter_cha_hp_3keta.y = @scouter_cha_hp_mozi.y
        @scouter_cha_hp_4keta.y = @scouter_cha_hp_mozi.y
        @scouter_cha_hp_5keta.y = @scouter_cha_hp_mozi.y
        @scouter_cha_hp_6keta.y = @scouter_cha_hp_mozi.y
        @scouter_cha_hp_7keta.y = @scouter_cha_hp_mozi.y
        @scouter_cha_hp_mozi.x = 640/2-60
        @scouter_cha_hp_1keta.x = @scouter_cha_hp_mozi.x + 16 * 5+24
        @scouter_cha_hp_2keta.x = @scouter_cha_hp_mozi.x + 16 * 4+24
        @scouter_cha_hp_3keta.x = @scouter_cha_hp_mozi.x + 16 * 3+24
        @scouter_cha_hp_4keta.x = @scouter_cha_hp_mozi.x + 16 * 2+24
        @scouter_cha_hp_5keta.x = @scouter_cha_hp_mozi.x + 16 * 1+24
        @scouter_cha_hp_6keta.x = @scouter_cha_hp_mozi.x + 16 * 0+24
        @scouter_cha_hp_7keta.x = @scouter_cha_hp_mozi.x - 16 * 1+24
        
        if $enehp[@scouter_cha_num].to_s.size >= 6
          @scouter_cha_hp_mozi.x -= 24
        end
        if $enehp[@scouter_cha_num].to_s.size >= 7
          @scouter_cha_hp_mozi.x -= 24
        end
        
        color = Color.new(200,240,128)
        @scouter_cha_hp_mozi.color = color
        @scouter_cha_hp_1keta.color = color
        @scouter_cha_hp_2keta.color = color
        @scouter_cha_hp_3keta.color = color
        @scouter_cha_hp_4keta.color = color
        @scouter_cha_hp_5keta.color = color
        @scouter_cha_hp_6keta.color = color
        @scouter_cha_hp_7keta.color = color
        @scouter_cha_hp_1keta.src_rect = Rect.new(0*0, 0, 16, 16)
        @scouter_cha_hp_2keta.src_rect = Rect.new(0*0, 0, 16, 16)
        @scouter_cha_hp_3keta.src_rect = Rect.new(0*0, 0, 16, 16)
        @scouter_cha_hp_4keta.src_rect = Rect.new(0*0, 0, 16, 16)
        @scouter_cha_hp_5keta.src_rect = Rect.new(0*0, 0, 16, 16)
        @scouter_cha_hp_6keta.src_rect = Rect.new(0*0, 0, 16, 16)
        @scouter_cha_hp_7keta.src_rect = Rect.new(0*0, 0, 16, 16)
        scouter_cha_hp_num = 0
        @scouter_damage_count = 0
        @scouter_search_count = 0
        @scouter_run_put_card = false
        @scouter_put_end = false
        @scouter_next_go = false
      end
      
      #スカウター反転
      if @scouter_back_count == 1
        if @scouter_back.visible == true
          @scouter_back.visible = false
        else
          @scouter_back.visible = true
        end
        @scouter_back_count = 0
      else
        @scouter_back_count += 1
      end
      
      if @scouter_cha_move_count < 47
        @scouter_cha.x -= 8
        @scouter_cha.update
        @scouter_cha_move_count += 1
      elsif @scouter_cha_move_count == 47
        @scouter_cha_move_count += 1
        Audio.se_play("Audio/SE/" + "Z1 スカウター測定")
        #Audio.bgs_play("Audio/BGS/" + "Z2 スカウター")
      elsif @scouter_cha_move_count == 48 && @scouter_run_put_card == false
        if @scouter_cursor_count == 8
          if @scouter_l_cursor.visible == true
            @scouter_l_cursor.visible = false
            @scouter_r_cursor.visible = false
            @scouter_u_cursor.visible = false
          else
            @scouter_l_cursor.visible = true
            @scouter_r_cursor.visible = true
            @scouter_u_cursor.visible = true
          end
          @scouter_cursor_count = 0
        else
          @scouter_cursor_count += 1
        end
        
        if @scouter_cursor_move_count <= 14
          
          @scouter_l_cursor.x += 4
          @scouter_r_cursor.x -= 4
          @scouter_u_cursor.y -= 2 if @scouter_cursor_move_count <= 11
          @scouter_cursor_move_count += 1
        
          
          #スカウター測定不可(人造人間)
        elsif @scouter_cursor_move_count == 15 && $data_enemies[$battleenemy[@scouter_cha_num]].element_ranks[17] == 1 && ($game_switches[490] == false && $run_godscouter_card == false) ||
          @scouter_cursor_move_count == 15 && $data_enemies[$battleenemy[@scouter_cha_num]].element_ranks[30] == 1 && ($game_switches[490] == false && $run_godscouter_card == false)
            idoux = 4
            #p $data_enemies[$battleenemy[@scouter_cha_num]].element_ranks[17] ,@scouter_cha_num,$battleenemy[@scouter_cha_num]
            if @scouter_r_cursor.x - @scouter_l_cursor.x < 220 && @scouter_search_count < 3
              @scouter_r_cursor.x += idoux
              @scouter_l_cursor.x -= idoux
              if @scouter_u_cursor.y != 259 + 86
                @scouter_u_cursor.y += 2
              end
            elsif @scouter_search_count < 3
              @scouter_cursor_move_count = 0 if @scouter_search_count < 2
              Audio.se_play("Audio/SE/" + "Z1 スカウター測定") if @scouter_search_count < 2
              @scouter_l_cursor.y = 259
              @scouter_l_cursor.x = 640/2-110
              @scouter_r_cursor.y = 259+15
              @scouter_r_cursor.x = 640/2+110
              @scouter_u_cursor.y = 259 + 86
              @scouter_u_cursor.x = 640/2 - 8
              @scouter_search_count += 1
            end
            
            if @scouter_search_count == 3
              @scouter_back.visible = true
              create_msg_window
              output_menu
              @msg_cursor.visible = true
              output_status
              output_card
              output_menu
              output_cursor
              
              @card_window.update
              @menu_window.update
              @status_window.update
              @back_window.update
              input_loop_run
              Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
              #Graphics.fadeout(5)
              #dispose_scouter_sprite
              #$scene = Scene_Db_Card.new 1
              @scouter_search_count += 1
            end
            if @scouter_search_count == 4
              if @scouter_cha.x > -210
                #p @scouter_search_count
                @scouter_cha.x -= idoux * 2
              else
                @scouter_search_count += 1
              end
            end
            if @scouter_search_count == 5
              if @scouter_cha_num != $battleenemy.size - 1
                
                for x in @scouter_cha_num + 1..$battleenemy.size - 1
                  if $enedead[x] == false
                    @scouter_cha_num = x
                    @scouter_cha_move_count = 0
                    break
                  elsif
                    if x == $battleenemy.size - 1
                      
                      Graphics.fadeout(5)
                      dispose_scouter_sprite
                      $scene = Scene_Db_Card.new 1
                    end
                  end
                  
                end

              else
                
                Graphics.fadeout(5)
                dispose_scouter_sprite
                $scene = Scene_Db_Card.new 1
              end
            end
          #end
          #end
        elsif @scouter_cursor_move_count == 15
          Audio.bgs_play("Audio/BGS/" + "Z2 スカウター")
          @scouter_cha_hp_mozi.visible = true
          @scouter_cha_hp_1keta.visible = true
          @scouter_cha_hp_2keta.visible = true
          @scouter_cha_hp_3keta.visible = true
          @scouter_cha_hp_4keta.visible = true
          @scouter_cha_hp_5keta.visible = true
          
          if $enehp[@scouter_cha_num].to_s.size >= 6
            @scouter_cha_hp_6keta.visible = true
          end
          if $enehp[@scouter_cha_num].to_s.size >= 7
            @scouter_cha_hp_7keta.visible = true
          end
          @scouter_cursor_move_count += 1
          
        else
          
          #スカウター動作設定
          if $data_enemies[$battleenemy[@scouter_cha_num]].element_ranks[16] == 1 && ($game_switches[490] == false && $run_godscouter_card == false)
            #target_hp = 9999
            target_hp = 99999
          else
            target_hp = $enehp[@scouter_cha_num]
          end
          if target_hp != @scouter_cha_hp_hyouzi
            
            if target_hp - @scouter_cha_hp_hyouzi >= 1000000
              scouter_cha_hp_num = 100000
            elsif target_hp - @scouter_cha_hp_hyouzi >= 100000
              scouter_cha_hp_num = 10000
            elsif target_hp - @scouter_cha_hp_hyouzi >= 10000
              scouter_cha_hp_num = 1000
            elsif target_hp - @scouter_cha_hp_hyouzi >= 1000
              scouter_cha_hp_num = 100
              #scouter_cha_hp_num = 10
            elsif target_hp - @scouter_cha_hp_hyouzi >= 100
              scouter_cha_hp_num = 10
              #scouter_cha_hp_num = 1
            else
              scouter_cha_hp_num = 1
            end
            @scouter_cha_hp_hyouzi += scouter_cha_hp_num
            for y in 1..@scouter_cha_hp_hyouzi.to_s.size #HP
              rect = Rect.new(0+@scouter_cha_hp_hyouzi.to_s[-y,1].to_i*16, 0, 16, 16)
              if y == 1
                @scouter_cha_hp_1keta.src_rect = rect
              elsif y == 2
                @scouter_cha_hp_2keta.src_rect = rect
              elsif y == 3
                @scouter_cha_hp_3keta.src_rect = rect
              elsif y == 4
                @scouter_cha_hp_4keta.src_rect = rect
              elsif y == 5
                @scouter_cha_hp_5keta.src_rect = rect
              elsif y == 6
                @scouter_cha_hp_6keta.src_rect = rect
              elsif y == 7
                @scouter_cha_hp_7keta.src_rect = rect
              end
              
            end
          else
            Audio.bgs_stop
            @scouter_l_cursor.visible = true
            @scouter_r_cursor.visible = true
            @scouter_u_cursor.visible = true
            if $data_enemies[$battleenemy[@scouter_cha_num]].element_ranks[16] == 1 && ($game_switches[490] == false && $run_godscouter_card == false)
              if @scouter_damage_count == 0
                color = Color.new(224,80,0,255)
                @scouter_back_bitmap.fill_rect(0,0,640,139,color)
                
                Audio.se_play("Audio/SE/" + "Z3 光線系ヒット")
              end
              @scouter_damage_count += 1
              if @scouter_damage_count == 60
                #dispose_scouter_sprite
                
                create_msg_window
                output_menu
                @msg_cursor.visible = true
                output_status
                output_card
                output_menu
                output_cursor
                
                @card_window.update
                @menu_window.update
                @status_window.update
                @back_window.update
                @scouter_l_cursor.visible = false
                @scouter_r_cursor.visible = false
                @scouter_u_cursor.visible = false
                @scouter_back.visible = false
                @scouter_cha.visible = false
                @scouter_cha_hp_mozi.visible = false
                @scouter_cha_hp_1keta.visible = false
                @scouter_cha_hp_2keta.visible = false
                @scouter_cha_hp_3keta.visible = false
                @scouter_cha_hp_4keta.visible = false
                @scouter_cha_hp_5keta.visible = false
                @scouter_cha_hp_6keta.visible = false
                @scouter_cha_hp_7keta.visible = false
                #top_name = set_ene_str_no $battleenemy[@scouter_cha_num]
                #@scouter_cha.bitmap = Cache.picture(top_name + "戦闘_敵_" + $data_enemies[$battleenemy[@scouter_cha_num]].name)
                #@scouter_cha.color = Color.new ( 0,0,0,0)
                #@scouter_cha.visible = true
                input_loop_run
                @scouter_cha.visible = false
                Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
                Graphics.fadeout(5)
                dispose_scouter_sprite
                $scene = Scene_Db_Card.new 1
              end
            else
              @scouter_run_put_card  = true
              @scouter_carda.x = 320+64+2+$output_carda_tyousei_x
              @scouter_cardg.x = 320+64+30+$output_cardg_tyousei_x
              @scouter_cardi.x = 320+64+16+$output_cardi_tyousei_x
              @scouter_cardf.x = 320+64
              @scouter_carda.y = 231+2+$output_carda_tyousei_y
              @scouter_cardg.y = 231+62+$output_cardg_tyousei_y
              @scouter_cardi.y = 231+32+$output_cardi_tyousei_y
              @scouter_cardf.y = 231
              #@scouter_carda.blend_type = 1
              #@scouter_cardg.blend_type = 1
              #@scouter_cardi.blend_type = 1
              @scouter_cardf.blend_type = 1
              #p @scouter_cardg.x,@scouter_carda.x,@scouter_cardi.x
              #p @scouter_cardg.y,@scouter_carda.y,@scouter_cardi.y
              #@scouter_carda.color = Color.new ( 0,256,0,256)
              #@scouter_cardg.color = Color.new ( 0,256,0,256)
              #@scouter_cardi.color = Color.new ( 0,256,0,256)
              #@scouter_cardf.color = Color.new ( 0,256,0,256)
              @scouter_carda.src_rect = set_card_frame 2,$enecarda [@scouter_cha_num]
              @scouter_cardg.src_rect = set_card_frame 3,$enecardg [@scouter_cha_num]
              @scouter_cardi.src_rect = Rect.new(0 + 32 * ($enecardi[@scouter_cha_num]), 64, 32, 32) # 流派
              @scouter_cardf.visible = true
              @scouter_carda.visible = true
              @scouter_cardg.visible = true
              @scouter_cardi.visible = true
            end
            
          end

        end

      end
      
      if @scouter_run_put_card == true && @scouter_next_go == false
        
        if @scouter_cha_move_count != 72
          idoux = 4
          @scouter_l_cursor.x -= idoux
          @scouter_r_cursor.x -= idoux
          @scouter_u_cursor.x -= idoux
          @scouter_cha.x -= idoux
          @scouter_cha_hp_mozi.x -= idoux
          @scouter_cha_hp_1keta.x -= idoux
          @scouter_cha_hp_2keta.x -= idoux
          @scouter_cha_hp_3keta.x -= idoux
          @scouter_cha_hp_4keta.x -= idoux
          @scouter_cha_hp_5keta.x -= idoux
          @scouter_cha_hp_6keta.x -= idoux
          @scouter_cha_hp_7keta.x -= idoux
          @scouter_cha_move_count += 1
        else
          #$WinState = 99
          @scouter_put_end = true
        end
      end
      
      if @scouter_next_go == true
          $run_scouter_ene[@scouter_cha_num] = true
          idoux = 4
          #@scouter_l_cursor.x -= idoux
          if @scouter_r_cursor.x - @scouter_l_cursor.x < 220
            @scouter_r_cursor.x += idoux
            if @scouter_u_cursor.x - @scouter_l_cursor.x < 102
              @scouter_u_cursor.x += idoux
            end
          else
            if @scouter_l_cursor.x != 640/2-110
              @scouter_l_cursor.x += idoux
              @scouter_r_cursor.x += idoux
              @scouter_u_cursor.x += idoux
            end
          end
          
          if @scouter_u_cursor.y != 259 + 86
            @scouter_u_cursor.y += 2
          end
          
          if @scouter_cha.x > -210
            @scouter_cha.x -= idoux * 2
          else
            

            
            if @scouter_cha_num != $battleenemy.size - 1
              
              for x in @scouter_cha_num + 1..$battleenemy.size - 1
                if $enedead[x] == false
                  @scouter_cha_num = x
                  @scouter_cha_move_count = 0
                  break
                elsif
                  if x == $battleenemy.size - 1
                    
                    Graphics.fadeout(5)
                    dispose_scouter_sprite
                    $scene = Scene_Db_Card.new 1
                  end
                end
                
              end
              
              
            else
              
              Graphics.fadeout(5)
              dispose_scouter_sprite
              $scene = Scene_Db_Card.new 1
            end
            #$WinState = 99
          end
          

        end

          #pre_update
          #update
          #p move_count
      #for x in 0..$battleenemy.size - 1
      #  ene_defeat_num_add $battleenemy[x]
      #end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● メニュー表示
  #--------------------------------------------------------------------------   
  def output_menu
    # メニュー文字
    if $WinState == 0 || $WinState == 5 || $WinState == 7 || $WinState == 8 || $WinState == 98 || $WinState == 99
      picture = Cache.picture("メニュー文字関係")
      rect = Rect.new(64, 0, 64, 96) # メニュー文字格納
      @menu_window.contents.blt(16 ,-3,picture,rect)
    end
    
    #戦闘開始確認
    if $WinState == 4 && @msg_window != nil #戦闘開始か確認中
      #picture = Cache.picture("メニュー文字関係")
      #rect = Rect.new(128, 0, 382, 96) # メニュー文字格納
      #@msg_window.contents.blt(0 ,-3,picture,rect)
      mozi = "バトルさんかにんずうは　これで　いいですか？"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @msg_window.contents.blt(2 ,-2+32*0,$tec_mozi,rect)
      mozi = "　　　　　　　　　　　　　　　　　　　はい"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @msg_window.contents.blt(2 ,-2+32*1,$tec_mozi,rect)
      mozi = "　　　　　　　　　　　　　　　　　　　いいえ"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      @msg_window.contents.blt(2 ,-2+32*2,$tec_mozi,rect)
    elsif $WinState == 6 && @msg_window != nil #Sコンボ確定
      mozi = "きあいは　じゅうぶんだ！"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      picture = $tec_mozi
      @msg_window.contents.blt(2 ,-2,picture,rect)
      
      mozi = $data_skills[@btl_ani_scombo_no].description
      mozi += "　がはつどうするぞ！！"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      picture = $tec_mozi
      @msg_window.contents.blt(2 ,-2+1*32,picture,rect)
    elsif $WinState == 98 && @msg_window != nil && @scouter_damage_count != 0 #スカウター爆発
      mozi = "スカウターが　こわれてしまった！！"
      
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      picture = $tec_mozi
      @msg_window.contents.blt(2 ,-2,picture,rect)
      mozi = "ヤツの　せんとうりょくは　はかりしれない！！！"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      picture = $tec_mozi
      @msg_window.contents.blt(2 ,-2+32,picture,rect)
    elsif $WinState == 98 && @msg_window != nil && @scouter_search_count != 0 #スカウター気を感じ取れない
      mozi = "まるで　キをかんじない！！"
      
      mozi = "さまざまな　キがあわさって　キがそくていできない！！" if $data_enemies[$battleenemy[@scouter_cha_num]].element_ranks[30] == 1
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      picture = $tec_mozi
      @msg_window.contents.blt(2 ,-2,picture,rect)
    end
    
    # 詳細メニュー
    # 0:能力 1:カード 2:セーブ 3:並び替え 4:未使用 5:あらすじ
    if $WinState == 5
      picture = Cache.picture("メニュー文字関係")
      rect = Rect.new(0, 96, 128, 64) # メニュー文字格納
      @msg_window.contents.blt(16 ,0,picture,rect)
      rect = Rect.new(128, 128, 128, 64) # メニュー文字格納
      @msg_window.contents.blt(16+128 ,0+32,picture,rect)
    end
    
    #オートマニュアル設定
    if $WinState != 0 && $WinState != 7 && $WinState != 5 && $WinState != 98 && $WinState != 99
      picture = Cache.picture("メニュー文字関係")
      rect = Rect.new(128, 192, 96, 64) # メニュー文字格納
      @btl_menu_window.contents.blt(16 ,6,picture,rect)
    end
    
  end

  #--------------------------------------------------------------------------
  # ● 必殺技を選択した時に処理する内容
  # mode:0 通常 1:Sコンボ使用しない
  #-------------------------------------------------------------------------- 
  def run_tec_select mode=0
    tec_mp_cost = get_mp_cost $partyc[@@battle_cha_cursor_state],$game_actors[$partyc[@@battle_cha_cursor_state]].skills[$MenuCursorState+@tecput_page*@tecput_max].id,0
    if $game_actors[$partyc[@@battle_cha_cursor_state]].mp >= tec_mp_cost
      #if $game_actors[$partyc[@@battle_cha_cursor_state]].mp >= $game_actors[$partyc[@@battle_cha_cursor_state]].skills[$MenuCursorState+@tecput_page*@tecput_max].mp_cost
      @down_cursor.visible = false
      @up_cursor.visible = false
      @btl_menu_fight.visible = true
      @btl_menu_fight_back.visible = true
    
      #Sコンボ使わないモードか？
      if mode == 1
        #Sコンボ使わないフラグをON
        $cha_single_attack[@@battle_cha_cursor_state] = true
      else
        #Sコンボ使わないフラグをOFF
        $cha_single_attack[@@battle_cha_cursor_state] = false
      end
      #if $game_actors[$partyc[@@battle_cha_cursor_state]].mp >= $game_actors[$partyc[@@battle_cha_cursor_state]].skills[$MenuCursorState].mp_cost
      
      #$cardset_cha_no[$CardCursorState] = @@battle_cha_cursor_state
      $cha_set_action[@@battle_cha_cursor_state] = $game_actors[$partyc[@@battle_cha_cursor_state]].skills[$MenuCursorState+@tecput_page*@tecput_max].id + 10
      #Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
      chk_scombo_flag_num $cha_set_action[@@battle_cha_cursor_state]-10
      dispose_techniqu_window
      dispose_tec_help_window
      if @scombo_flag == true
        #Audio.se_play("Audio/SE/" + "Z3 レベルアップ") # 効果音を再生する
        #Audio.se_play("Audio/SE/" + "DB3 キラーン") # 効果音を再生する
        Audio.se_play("Audio/SE/" + "DB3 刀") # 効果音を再生する
        #Audio.se_play("Audio/SE/" + "Z1 パワーアップ") # 効果音を再生する
        #Audio.se_play("Audio/SE/" + "Z1 必殺技") # 効果音を再生する
        #p "sコンボ"
        create_msg_window
        output_menu
        @msg_cursor.visible = true
        input_loop_run
        Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
      else
        Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
      end 
      #p $game_actors[$partyc[@@battle_cha_cursor_state]].skills[$MenuCursorState+@tecput_page*@tecput_max].element_set.index(10)#.element_set
      if $game_actors[$partyc[@@battle_cha_cursor_state]].skills[$MenuCursorState+@tecput_page*@tecput_max].scope == 1 && $game_actors[$partyc[@@battle_cha_cursor_state]].skills[$MenuCursorState+@tecput_page*@tecput_max].element_set.index(10) == nil
      #if $game_actors[$partyc[@@battle_cha_cursor_state]].skills[$MenuCursorState].scope == 1
        #単体攻撃
        $WinState = 3
        @@battle_ene_cursor_state = 0
        @@battle_ene_cursor_state = chk_select_cursor_control (2,@@battle_ene_cursor_state,0,0,$battleenenum-1)#その場からチェック
      else
        #全体攻撃またはダメージなし
        $cha_set_enemy[@@battle_cha_cursor_state] = 0
        @@card_set_no[@@card_set_count] = @@battle_cha_cursor_state
        @@card_set_count += 1
        if @@card_set_count != @battle_cha_num then
          @@battle_cha_cursor_state = chk_select_cursor_control (0,@@battle_cha_cursor_state,0, 0, $partyc.size-1) #その場からチェック
        end
        if @chk_select_cursor_control_flag == true
          if @@battle_cha_cursor_state >= @output_cha_window_state + 5
            @output_cha_window_state = @@battle_cha_cursor_state - 5
            #elsif @@battle_cha_cursor_state == 0
            #  @output_cha_window_state = 0
          elsif @@battle_cha_cursor_state < @output_cha_window_state
            #p @output_cha_window_state ,@@battle_cha_cursor_state
            @output_cha_window_state = @@battle_cha_cursor_state
          end
        end
        $WinState = 1
      end
      

      
    else
      
      Audio.se_play("Audio/SE/" + $BGM_Error) # 効果音を再生する
    end
  end
  
  #--------------------------------------------------------------------------
  # ● キー取得時の処理(処理が多いのでここでは別に書く)
  # 引数：n[押したボタン]
  #--------------------------------------------------------------------------  
  def window_key_state(n)
    
    case n
    
    when "C" # 決定
      if $WinState == 0 then # メインメニュー
        
        if $CursorState != 2
          Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        end
        
        if $CursorState == 0 then
          #tempに攻防の星格納
          @temp_carda = Marshal.load(Marshal.dump($carda))
          @temp_cardg = Marshal.load(Marshal.dump($cardg))
          $temp_cardi = Marshal.load(Marshal.dump($cardi))
          if @battle_cha_num != 0
            $WinState = 8 #オートマニュアル選択
            create_btl_menu_window
            @btl_menu_fight_back.visible = true
            @btl_menu_fight.visible = true
            if $game_variables[30] == 0
              $btl_MenuCursorState = 1
            else
              $btl_MenuCursorState = 0
            end
          else
            set_auto_btl
          end
        elsif $CursorState == 1 then
          $WinState = 5 #メニュー表示
          $MenuCursorState = 0
          create_msg_window
        elsif $CursorState == 2 then
          if $battle_escape == true || $game_switches[1305] == true #戦闘の練習中も逃げれることとする
            $run_stop_card = false
            Audio.se_play("Audio/SE/" + "Z1 逃げる") # 効果音を再生する
            
            @@battle_main_result = 4
            $CursorState = 0
          else
            Audio.se_play("Audio/SE/" + $BGM_Error) # 効果音を再生する
          end
        else
        
        end
      elsif $WinState == 1 then # 味方キャラ選択前
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        $WinState = 2 # カード選択前
        $CardCursorState = 0
        $CardCursorState = chk_select_cursor_control (1,$CardCursorState,0, 0, $Cardmaxnum) #その場からチェック
      elsif $WinState == 2 then # カード選択前
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        
        #お気に入りキャラで必殺カード選択時
        #流派カードに変更する。
        #
        
        temp_cha_no = get_ori_cha_no $partyc[@@battle_cha_cursor_state]
        if temp_cha_no == $game_variables[104] && $cardi[$CardCursorState] == 0
          $cardi[$CardCursorState] = $game_actors[$partyc[@@battle_cha_cursor_state]].class_id-1
        end
        
        #気カードの場合は、流派に変更
        if $cardi[$CardCursorState] == 16
          $cardi[$CardCursorState] = $game_actors[$partyc[@@battle_cha_cursor_state]].class_id-1
        end
        
        $cardset_cha_no[$CardCursorState] = @@battle_cha_cursor_state
        #スキルでカード攻防の星調整
        get_battle_skill $partyc[@@battle_cha_cursor_state],$CardCursorState,0
        #流派合致ならか必殺尚且つ必殺技を持っているならかつ剛腕を覚えていない
        if ($cardi[$CardCursorState] == $game_actors[$partyc[@@battle_cha_cursor_state]].class_id-1 && $game_actors[$partyc[@@battle_cha_cursor_state]].skills.size != 0 || 
          $cardi[$CardCursorState] == 0 && $game_actors[$partyc[@@battle_cha_cursor_state]].skills.size != 0) &&
          chk_gouwanrun($partyc[@@battle_cha_cursor_state]) == false
          
          $MenuCursorState = 0
          create_tec_window
          @tecput_page =0
          @display_skill_level = -1
          $WinState = 6 #必殺技選択
          @tecwinupdate_flag = true
          @btl_menu_fight.visible = false
          @btl_menu_fight_back.visible = false
        else  
          $WinState = 3 # 敵キャラ選択前
          #$cardset_cha_no[$CardCursorState] = @@battle_cha_cursor_state
          $cha_set_action[@@battle_cha_cursor_state] = 1
          @@battle_ene_cursor_state = 0
          @@battle_ene_cursor_state = chk_select_cursor_control (2,@@battle_ene_cursor_state,0,0,$battleenenum-1)#その場からチェック
        end
      elsif $WinState == 3 then # バトル対象味方⇒敵
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        $cha_set_enemy[@@battle_cha_cursor_state] = @@battle_ene_cursor_state
        @@card_set_no[@@card_set_count] = @@battle_cha_cursor_state
        @@card_set_count += 1
        if @@card_set_count != @battle_cha_num && $Cardmaxnum + 1 != @@card_set_count then
          @@battle_cha_cursor_state = chk_select_cursor_control (0,@@battle_cha_cursor_state,0, 0, $partyc.size-1) #その場からチェック
          if @@battle_cha_cursor_state >= @output_cha_window_state + 6
            @output_cha_window_state += 1
            @battle_icon_syurui_hanigaimae = 0
            @battle_icon_syurui_hanigaiato = 0
          end
          #カーソルを調整したらウインドウ位置を再チェックする
          if @chk_select_cursor_control_flag == true
           if @@battle_cha_cursor_state >= @output_cha_window_state + 5
             @output_cha_window_state = @@battle_cha_cursor_state - 5
           #elsif @@battle_cha_cursor_state == 0
           #  @output_cha_window_state = 0
           elsif @@battle_cha_cursor_state < @output_cha_window_state
             #p @output_cha_window_state ,@@battle_cha_cursor_state
             @output_cha_window_state = @@battle_cha_cursor_state
           end
          end
          #if @@battle_cha_cursor_state >= 6
          #  @output_cha_window_state = @@battle_cha_cursor_state - 5
          #elsif @@battle_cha_cursor_state <= 5
          #  @output_cha_window_state = 0
          #elsif @@battle_cha_cursor_state < @output_cha_window_state
          #  #@output_cha_window_state -= 1
          #end
        end
        $WinState = 1
      elsif $WinState == 4 then #戦闘途中開始確認
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        dispose_msg_window
        if @battle_str_cursor_state == 0 #はいならば戦闘開始
          $WinState = 1
          @@card_set_count = @battle_cha_num
          
          if $Cardmaxnum + 1 < @@card_set_count #カードセット数を調整
            @@card_set_count = $Cardmaxnum + 1
          end
          $CursorState = 0
        else
          $WinState = 1
        end
      elsif $WinState == 5 then #詳細メニュー
        Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
        Graphics.fadeout(5)
        # 0:能力 1:カード 2:セーブ 3:並び替え 4:未使用 5:あらすじ
        case $MenuCursorState 
        
        when 0 #能力
          dispose_sprite
          $run_item_card_id = 0
          $scene = Scene_Db_Status.new 1
          
        when 1 #カード
          dispose_sprite
          $scene = Scene_Db_Card.new 1
        when 4 #Sコンボ
          dispose_sprite
          $scene = Scene_Db_Scombo_Menu.new 1
          #Graphics.fadeout(5)
        when 5 #さくせん
          dispose_sprite
          $scene = Scene_Db_Tactics_Menu.new 1
        end
      elsif $WinState == 6 #必殺技
        mode = 0
        run_tec_select mode
        

      elsif $WinState == 7 #カードで敵キャラ選択
        case $run_item_card_id
        
        when 30 #じいちゃん
          color = Color.new(255,255,255,255)
          for x in 0..4
            Audio.se_play("Audio/SE/" + "Z1 歩く音") # 効果音を再生する
            @back_window.contents.fill_rect(640/2-18-($battleenenum-1)*40+@@battle_ene_cursor_state*80, 260,64,64,color) # 真ん中
            #pre_update
            Graphics.update
            Graphics.wait(1)
            pre_update
            Graphics.update
            Graphics.wait(1)
          end
          $run_stop_card = true
          $ene_stop_num[@@battle_ene_cursor_state] += 1
          $game_party.lose_item ($data_items[$run_item_card_id], 1) #カード減らす
          Graphics.fadeout(5)
          dispose_sprite
          $scene = Scene_Db_Card.new 1
        when 51 #ゴズ
          color = Color.new(255,255,255,255)
          for x in 0..4
            Audio.se_play("Audio/SE/" + "Z1 歩く音") # 効果音を再生する
            @back_window.contents.fill_rect(640/2-18-($battleenenum-1)*40+@@battle_ene_cursor_state*80, 260,64,64,color) # 真ん中
            #pre_update
            Graphics.update
            Graphics.wait(1)
            pre_update
            Graphics.update
            Graphics.wait(1)
          end
          $run_alow_card = true
          #p $enecarda[@@battle_ene_cursor_state]
          $enecarda[@@battle_ene_cursor_state] -= (rand(2)+1)
          $enecarda[@@battle_ene_cursor_state] = 0 if $enecarda[@@battle_ene_cursor_state] < 0
          $game_party.lose_item ($data_items[$run_item_card_id], 1) #カード減らす
          Graphics.fadeout(5)
          dispose_sprite
          $scene = Scene_Db_Card.new 1
        when 52 #メズ
          color = Color.new(255,255,255,255)
          for x in 0..4
            Audio.se_play("Audio/SE/" + "Z1 歩く音") # 効果音を再生する
            @back_window.contents.fill_rect(640/2-18-($battleenenum-1)*40+@@battle_ene_cursor_state*80, 260,64,64,color) # 真ん中
            #pre_update
            Graphics.update
            Graphics.wait(1)
            pre_update
            Graphics.update
            Graphics.wait(1)
          end
          $run_glow_card = true
          #p $enecardg[@@battle_ene_cursor_state]
          $enecardg[@@battle_ene_cursor_state] -= (rand(2)+1)
          $enecardg[@@battle_ene_cursor_state] = 0 if $enecardg[@@battle_ene_cursor_state] < 0
          $game_party.lose_item ($data_items[$run_item_card_id], 1) #カード減らす
          Graphics.fadeout(5)
          dispose_sprite
          $scene = Scene_Db_Card.new 1
        end
      
      elsif $WinState == 8 #オートマニュアル選択
        Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
        #dispose_btl_menu_window
        case $btl_MenuCursorState 
        
        when 0 #オート
          set_auto_btl
        when 1 #マニュアル
          $WinState = 1 #キャラ選択前
          #@btl_menu_fight.visible = false
          @@battle_cha_cursor_state = 0
          @@battle_cha_cursor_state = chk_select_cursor_control (0,@@battle_cha_cursor_state,0, 0, $partyc.size-1) #その場からチェック
          if @@battle_cha_cursor_state >= 6
            @output_cha_window_state = @@battle_cha_cursor_state - 5
          elsif @@battle_cha_cursor_state <= 5
            @output_cha_window_state = 0
          #elsif @@battle_cha_cursor_state < @output_cha_window_state
            #@output_cha_window_state -= 1
          end
        end
      elsif $WinState == 98 #スカウター測定後
        if @scouter_put_end == true && @scouter_next_go == false
          Audio.se_play("Audio/SE/" + "Z1 スカウター測定")
          @scouter_next_go = true
          @scouter_cardf.visible = false
          @scouter_carda.visible = false
          @scouter_cardg.visible = false
          @scouter_cardi.visible = false
          @scouter_cha_hp_mozi.visible = false
          @scouter_cha_hp_1keta.visible = false
          @scouter_cha_hp_2keta.visible = false
          @scouter_cha_hp_3keta.visible = false
          @scouter_cha_hp_4keta.visible = false
          @scouter_cha_hp_5keta.visible = false
          @scouter_cha_hp_6keta.visible = false
          @scouter_cha_hp_7keta.visible = false
        end
      end  
      
    when "B" # キャンセル
      #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      if $WinState == 0 then 

      elsif $WinState == 1 then # 味方キャラ選択前
        if @@card_set_count == 0 
          $WinState = 8
          @@battle_cha_cursor_state = -1
        elsif
          battle_set_cancel
          
          $cha_single_attack[@@battle_cha_cursor_state] = false #Sコンボ使わないフラグを初期化 
          
          #if @@battle_cha_cursor_state >= 6
          #  @output_cha_window_state = @@battle_cha_cursor_state - 5
          #elsif @@battle_cha_cursor_state < @output_cha_window_state
          #  @output_cha_window_state -= 1
          #end
          if @@battle_cha_cursor_state >= 6
            @output_cha_window_state = @@battle_cha_cursor_state - 5
          #elsif @@battle_cha_cursor_state == 0
          #  @output_cha_window_state = 0
          elsif @@battle_cha_cursor_state < @output_cha_window_state
            @output_cha_window_state = @@battle_cha_cursor_state
          end
        end
      elsif $WinState == 2 then #カード選択前
        $WinState = 1
        $CardCursorState = 0
        
      elsif $WinState == 3 then #カード選択後(移動前)
        $WinState = 2
        $carda[$CardCursorState] = @temp_carda[$CardCursorState]
        $cardg[$CardCursorState] = @temp_cardg[$CardCursorState]
        $cardi[$CardCursorState] = $temp_cardi[$CardCursorState]
        $cardset_cha_no[$CardCursorState] = 99          #カード初期化
        $cha_set_action[@@battle_cha_cursor_state] = 0 #攻撃アクションNo 初期化
        $cha_single_attack[@@battle_cha_cursor_state] = false
      elsif $WinState == 4 then #戦闘途中開始確認
        #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
        $WinState = 1
        dispose_msg_window
      elsif $WinState == 5 then #詳細メニュー
        $WinState = 0
      elsif $WinState == 6 then #必殺技メニュー
        @down_cursor.visible = false
        @up_cursor.visible = false
        @btl_menu_fight.visible = true
        @btl_menu_fight_back.visible = true
        dispose_techniqu_window
        dispose_tec_help_window
        $cardset_cha_no[$CardCursorState] = 99
        $carda[$CardCursorState] = @temp_carda[$CardCursorState]
        $cardg[$CardCursorState] = @temp_cardg[$CardCursorState]
        $cardi[$CardCursorState] = $temp_cardi[$CardCursorState]
        $WinState = 2 
      elsif $WinState == 7 #カードで敵キャラ選択
        Graphics.fadeout(5)
        dispose_sprite
        $scene = Scene_Db_Card.new 1
      elsif $WinState == 8 #オートマニュアル選択
        dispose_btl_menu_window
        $WinState = 0
        @btl_menu_fight_back.visible = false
        @btl_menu_fight.visible = false
      end
    when "X" # 途中で戦闘開始
      #Audio.se_play("Audio/SE/" + $BGM_CursorOn)    # 効果音を再生する
      
      #戦闘中にセーブした
      #$game_switches[500] = true
      #$scene = Scene_File.new(true, false, false, true)
      if $WinState == 1 && @@card_set_count >= 1 
        $WinState = 4
        @battle_str_cursor_state = 0
        create_msg_window
      elsif $WinState == 6
        @tecwinupdate_flag = true
        Audio.se_play("Audio/SE/" + $BGM_CursorOn)
        @display_skill_level = -@display_skill_level
      end
    when "Y"
      if $WinState == 6 #必殺技選択中
        mode = 1
        run_tec_select mode
      end
    when "L" #必殺技ページ送り
      #if $WinState == 6
      #  Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      #  set_tecpage -1
      #end
    when "R" #必殺技ページ送り
      #if $WinState == 6
      #  Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
      #  set_tecpage 1
      #end
    when 2 # 下
      
      if $WinState == 0
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if $CursorState < 2
          $CursorState += 1
        else
          $CursorState = 0
        end
      elsif $WinState == 4
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if @battle_str_cursor_state == 0
          @battle_str_cursor_state = 1
        else
          @battle_str_cursor_state = 0
        end
      elsif $WinState == 5 #メニュー
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if $MenuCursorState == 1
          $MenuCursorState = 5
        elsif $MenuCursorState == 4
          $MenuCursorState = 5
        elsif $MenuCursorState == 5
          $MenuCursorState = 4
        else
          $MenuCursorState += 1
        end
      elsif $WinState == 6 #必殺技
        @tecwinupdate_flag = true
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        tecput_page_strat = @tecput_page * @tecput_max
            if $game_actors[$partyc[@@battle_cha_cursor_state]].skills.size - 1 < (@tecput_page + 1) * @tecput_max
              tecput_end = $game_actors[$partyc[@@battle_cha_cursor_state]].skills.size - 1
            else
              tecput_end = @tecput_max - 1
            end
        
        
          if $MenuCursorState == tecput_end - tecput_page_strat
            $MenuCursorState = 0
            if @tecput_page == ($game_actors[$partyc[@@battle_cha_cursor_state]].skills.size - 1)  / @tecput_max
              @tecput_page = 0
            else
              @tecput_page += 1
            end
          else
            $MenuCursorState += 1
          end

      elsif $WinState == 8
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if $btl_MenuCursorState == 1
          $btl_MenuCursorState = 0
        else
          $btl_MenuCursorState += 1
        end
      end 
    when 4 # 左
      if $WinState == 0
      
      elsif $WinState == 1
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @@battle_cha_cursor_state = chk_select_cursor_control (0,@@battle_cha_cursor_state,2, 0, $partyc.size-1) #左へチェック
        
        if @@battle_cha_cursor_state < @output_cha_window_state
          @output_cha_window_state -= 1
          @battle_icon_syurui_hanigaimae = 0
          @battle_icon_syurui_hanigaiato = 0
        end
        if @chk_select_cursor_control_flag == true
         if @@battle_cha_cursor_state >= 6
           @output_cha_window_state = @@battle_cha_cursor_state - 5
         #elsif @@battle_cha_cursor_state == 0
         #  @output_cha_window_state = 0
         elsif @@battle_cha_cursor_state < @output_cha_window_state
           @output_cha_window_state = @@battle_cha_cursor_state
         end
        end
      elsif $WinState == 2
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        $CardCursorState = chk_select_cursor_control (1,$CardCursorState,2,0,$Cardmaxnum)#左へチェック
      elsif  $WinState == 3 || $WinState == 7
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @@battle_ene_cursor_state = chk_select_cursor_control (2,@@battle_ene_cursor_state,2,0,$battleenenum-1)#左へチェック
      elsif $WinState == 5
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if $MenuCursorState == 4
          $MenuCursorState = 1
        elsif $MenuCursorState == 5
          $MenuCursorState = 1
        else
          $MenuCursorState = 4
        end
      elsif $WinState == 6 #必殺技選択
        #Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        set_tecpage -1
        @tecwinupdate_flag = true
      else
      end 
      
    when 6 # 右
      if $WinState == 0
        
      elsif $WinState == 1
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @@battle_cha_cursor_state = chk_select_cursor_control (0,@@battle_cha_cursor_state,1, 0, $partyc.size-1) #右へチェック
        if @@battle_cha_cursor_state >= @output_cha_window_state + 6
          @output_cha_window_state += 1
          @battle_icon_syurui_hanigaimae = 0
          @battle_icon_syurui_hanigaiato = 0
        end
        #カーソルを調整したらウインドウ位置を再チェックする
        if @chk_select_cursor_control_flag == true
         if @@battle_cha_cursor_state >= @output_cha_window_state + 5
           @output_cha_window_state = @@battle_cha_cursor_state - 5
         #elsif @@battle_cha_cursor_state == 0
         #  @output_cha_window_state = 0
         elsif @@battle_cha_cursor_state < @output_cha_window_state
           #p @output_cha_window_state ,@@battle_cha_cursor_state
           @output_cha_window_state = @@battle_cha_cursor_state
         end
        end
        #elsif @@battle_cha_cursor_state <= 5
        #  @output_cha_window_state = 0
        #elsif @@battle_cha_cursor_state < @output_cha_window_state
        #  @output_cha_window_state -= 1
        #end
      elsif  $WinState == 2
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        $CardCursorState = chk_select_cursor_control (1,$CardCursorState,1,0,$Cardmaxnum)#右カウント
      elsif  $WinState == 3 || $WinState == 7
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        @@battle_ene_cursor_state = chk_select_cursor_control (2,@@battle_ene_cursor_state,1,0,$battleenenum-1)#右へチェック
      elsif $WinState == 5
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if $MenuCursorState == 4
          $MenuCursorState = 1
        elsif $MenuCursorState == 5
          $MenuCursorState = 1
        else
          $MenuCursorState = 4
        end
      elsif $WinState == 6 #必殺技選択
        #Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        set_tecpage 1
        @tecwinupdate_flag = true
      else
      end 
    when 8 # 上
      
      if $WinState == 0
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if $CursorState > 0
          $CursorState -= 1
        else
          $CursorState = 2
        end
        
      elsif $WinState == 4
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if @battle_str_cursor_state == 0
          @battle_str_cursor_state = 1
        else
          @battle_str_cursor_state = 0
        end
      elsif $WinState == 5
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if $MenuCursorState == 0
          $MenuCursorState += 1
        elsif $MenuCursorState == 4
          $MenuCursorState = 0
        elsif $MenuCursorState == 5
          $MenuCursorState = 4
        else
          $MenuCursorState -= 1
        end
      elsif $WinState == 6
        @tecwinupdate_flag = true
        #Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        tecput_page_strat = @tecput_page * @tecput_max
        if $game_actors[$partyc[@@battle_cha_cursor_state]].skills.size - 1 < (@tecput_page + 1) * @tecput_max
          tecput_end = $game_actors[$partyc[@@battle_cha_cursor_state]].skills.size - 1
        else
          tecput_end = @tecput_max - 1
        end
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if $MenuCursorState == 0
          
          if @tecput_page > 0
            @tecput_page -= 1
            $MenuCursorState = @tecput_max - 1
          else
            @tecput_page = ($game_actors[$partyc[@@battle_cha_cursor_state]].skills.size - 1)  / @tecput_max
            tecput_page_strat = @tecput_page * @tecput_max
            if $game_actors[$partyc[@@battle_cha_cursor_state]].skills.size - 1 < (@tecput_page + 1) * @tecput_max
              tecput_end = $game_actors[$partyc[@@battle_cha_cursor_state]].skills.size - 1
            else
              tecput_end = @tecput_max - 1
            end
            $MenuCursorState = tecput_end - tecput_page_strat
          end
        else
          $MenuCursorState -= 1
        end
      elsif $WinState == 8
        Audio.se_play("Audio/SE/" + $BGM_CursorMove)    # 効果音を再生する
        if $btl_MenuCursorState == 1
          $btl_MenuCursorState = 0
        else
          $btl_MenuCursorState += 1
        end
      else
          
      end 
      
    end
  end
  
  #--------------------------------------------------------------------------
  # ● オート戦闘時の必殺技設定
  # chano:キャラNo
  # orderno:並び順no
  #--------------------------------------------------------------------------  
  def set_auto_tec chano,orderno
    
    ki_tarinai = false #気が足りないのが確定か
    minimum_skillmp = 99999 #大技、指定の技の最小mp(ki)
    skillloopmax = 50 #ループ最大数
    
    if $game_actors[chano].skills.size != 0
      #流派一致
      #set_skill_rand = rand($game_actors[chano].skills.size)
      
      #p $game_actors[chano].mp,set_skill_rand
      #p $game_actors[chano].skills[set_skill_rand].mp_cost
      
      #作戦の値の初期値を設定
      set_cha_tactics_nil_to_zero chano
      skillloop = 0
      skillresult = false
      begin

        set_skill_rand = rand($game_actors[chano].skills.size)
        
        #とにかくオートの時用にセット
        minimum_skillmp = get_mp_cost(chano,$game_actors[chano].skills[set_skill_rand].id)
        
        
        tec_set = $cha_tactics[1][chano]
        
        #事前チェック
        case tec_set
        
        when 3 #大技
          for b in 0..$game_actors[chano].skills.size - 1 
            #大技で一番KIの消費が少ないものをチェック
            if $game_actors[chano].skills[b].element_set.index(28) != nil
              if minimum_skillmp > get_mp_cost(chano,$game_actors[chano].skills[b].id)
                #p get_mp_cost(chano,$game_actors[chano].skills[b].id),chano,$game_actors[chano].skills[b].id,$game_actors[chano].skills[b].name
                minimum_skillmp = get_mp_cost(chano,$game_actors[chano].skills[b].id)
              end
            end
          end
        when 4 #指定の技
          #p $cha_tactics[7][chano]
          if minimum_skillmp > get_mp_cost(chano,$cha_tactics[7][chano])
            minimum_skillmp = get_mp_cost(chano,$cha_tactics[7][chano])
          end
          
          
        end
        
        #指定の技や大技で気が足りない
        #または大技がない場合は 99999となるため足りない判定になる
        ki_tarinai = true if $game_actors[chano].mp < minimum_skillmp

        #p chano,tec_set,ki_tarinai
        #p ki_tarinai
        
        
        #気が足りないからループを終わらせる
        if ki_tarinai == true
          skillloop = skillloopmax
        end
        #以下作戦==================================================
        
        skillloop += 1 
        
        tec_set = $cha_tactics[1][chano]
        #気が足りないとき
        if skillloop > skillloopmax
          if $cha_tactics[5][chano] == 0
            tec_set = 1
          else
            tec_set = 2
          end
        end
        
        #変身技の使用
        if $cha_tactics[2][chano] != 0
          next if $game_actors[chano].skills[set_skill_rand].element_set.index(26) != nil
        end
        
        #気が減っている時
        if $cha_tactics[6][chano] == 1 && $cha_tactics[8][chano] >= (($game_actors[chano].mp * 100) / $game_actors[chano].maxmp)
          tec_set = 1
        end
        
        #p chano,tec_set,$game_actors[chano].skills[set_skill_rand]
        #必殺技の選択
        #p tec_set,skillloop
        case tec_set
        
        when 0 #とにかくオート
          
        when 1 #KIを消費しない
          next if $game_actors[chano].skills[set_skill_rand].mp_cost != 0
        when 2 #小技
          #p $game_actors[chano].skills[set_skill_rand].element_set.index(27)
          next if $game_actors[chano].skills[set_skill_rand].element_set.index(27) == nil
        when 3 #大技
          next if $game_actors[chano].skills[set_skill_rand].element_set.index(28) == nil
        when 4 #指定の技
          #p $cha_tactics[7][chano]
          #if ki_tarinai == false
          set_skill_rand = $cha_tactics[7][chano]
          #end
        end
        
        if tec_set != 4
          tec_id = $game_actors[chano].skills[set_skill_rand].id
        else
          tec_id = $data_skills[set_skill_rand].id
        end
        tec_mp_cost = get_mp_cost chano,$data_skills[tec_id].id
        next if $game_actors[chano].mp < tec_mp_cost
        skillresult = true
      end while skillresult != true
      #$cha_set_action[orderno] = $game_actors[chano].skills[set_skill_rand].id + 10
      $cha_set_action[orderno] = $data_skills[tec_id].id + 10
    else
      $cha_set_action[orderno] = 1
    end
    
  end
  #--------------------------------------------------------------------------
  # ● オート戦闘設定
  # 左から順に、
  #--------------------------------------------------------------------------  
  def set_auto_btl

    set_enehp = 1
    chk_stop_non = false
    
    #全員行動不可であれば行動不可をカウントする
    
    #p @battle_cha_num,@@card_set_count
    if @battle_cha_num == 0
      chk_stop_non = true
      battlechacount chk_stop_non
    end 
    #p @battle_cha_num,@@card_set_count
    temp_cardi = Marshal.load(Marshal.dump($cardi))
    temp_cardi[$Cardmaxnum+1] = 99
    

    #事前にカードをセット
    for b in 0..$partyc.size-1
      set_card = 0
      set_mode = 0
      
      if @@card_set_count == @battle_cha_num || @@card_set_count == $Cardmaxnum + 1
        break
      end
      if $chadead[b] == false && $cha_stop_num[b] == 0 || $chadead[b] == false && chk_stop_non == true #
        if temp_cardi.index($game_actors[$partyc[b]].class_id-1) != nil && chk_gouwanrun($partyc[b]) == false
          set_card = temp_cardi.index($game_actors[$partyc[b]].class_id-1)
          temp_cardi[set_card] = 99
          $cardset_cha_no[set_card] = b
          #@@card_set_count += 1
        elsif (temp_cardi.index(0) != nil && $game_actors[$partyc[b]].skills.size != 0 || #必殺技カード
          temp_cardi.index(16) != nil && $game_actors[$partyc[b]].skills.size != 0) && #気カード
          chk_gouwanrun($partyc[b]) == false #剛腕を覚えていない
          #temp_cha_no = get_ori_cha_no $partyc[b]
          
          #気カードのチェックが優先
          if temp_cardi.index(16) != nil
            set_card = temp_cardi.index(16)
          elsif temp_cardi.index(0) != nil
            set_card = temp_cardi.index(0)
          end
          
          temp_cardi[set_card] = 99
          $cardset_cha_no[set_card] = b
          
        end
        @@card_set_count += 1
      end
    end

    @@card_set_count = 0 
    #p temp_cardi,$cardset_cha_no

    for a in 0..$partyc.size-1
      #行動できるか？
      if $chadead[a] == false && $cha_stop_num[a] == 0 || $chadead[a] == false && chk_stop_non == true #
        set_card = 0
        set_mode = 0
        
        #流派のカードか
        
        if $cardset_cha_no.index(a) != nil && $cardi[$cardset_cha_no.index(a)] == $game_actors[$partyc[a]].class_id-1 && chk_gouwanrun($partyc[a]) == false
        #if temp_cardi.index($game_actors[$partyc[a]].class_id-1) != nil #流派
          
          #必殺技をセット
          set_auto_tec $partyc[a],a
          
          set_card = $cardset_cha_no.index(a)

          set_mode = 1
        #elsif temp_cardi.index(0) != nil && $game_actors[$partyc[a]].skills.size != 0 || #必殺技カード
        #  temp_cardi.index(16) != nil && $game_actors[$partyc[a]].skills.size != 0 || #気カード
        elsif ($cardset_cha_no.index(a) != nil && $cardi[$cardset_cha_no.index(a)] == 0 || #必カード
          $cardset_cha_no.index(a) != nil && $cardi[$cardset_cha_no.index(a)] == 16 || #気カード 
          chk_zetubo_ran($partyc[a],0,true) == true ||
          chk_kinobousou_ran($partyc[a],0,true) == true) && chk_gouwanrun($partyc[a]) == false
          #お気に入りキャラで必カードの時は流派を一致させる
          #絶望への反抗、気の暴走が有効の場合
          temp_cha_no = get_ori_cha_no $partyc[a]
          if $cardset_cha_no.index(a) != nil
            if $cardi[$cardset_cha_no.index(a)] == 16
              $cardi[$cardset_cha_no.index(a)] = $game_actors[$partyc[a]].class_id-1
              set_card = $cardset_cha_no.index(a)
            elsif $cardi[$cardset_cha_no.index(a)] == 0
              if temp_cha_no == $game_variables[104]
                $cardi[$cardset_cha_no.index(a)] = $game_actors[$partyc[a]].class_id-1
              end
              set_card = $cardset_cha_no.index(a)
            end
          else chk_zetubo_ran($partyc[a],0,true) == true || chk_kinobousou_ran($partyc[a],0,true) == true
            #まだセットしていないカードをセットする
            $cardi[$cardset_cha_no.index(99)] = $game_actors[$partyc[a]].class_id-1
            set_card = $cardset_cha_no.index(99)
          end
=begin
          #気カードのチェックが優先
          if temp_cardi.index(16) != nil
            #気カードの場合は、流派に変更
            if $cardi[temp_cardi.index(16)] != nil
              $cardi[temp_cardi.index(16)] = $game_actors[$partyc[a]].class_id-1
            end
            set_card = temp_cardi.index(16)
          elsif temp_cardi.index(0) != nil
            if temp_cha_no == $game_variables[104] #&& $cardi[temp_cardi.index($game_actors[$partyc[a]].class_id-1)] == 0
              $cardi[temp_cardi.index(0)] = $game_actors[$partyc[a]].class_id-1
            end
            set_card = temp_cardi.index(0)
          elsif chk_zetubo_ran($partyc[a],0,true) == true || chk_kinobousou_ran($partyc[a],0,true) == true
            #まだセットしていないカードをセットする
            $cardi[$cardset_cha_no.index(99)] = $game_actors[$partyc[a]].class_id-1
            set_card = $cardset_cha_no.index(99)
          end
=end
          #必殺技をセット
          set_auto_tec $partyc[a],a
          
          set_mode = 2
        else #その他
          set_card_rand = rand($Cardmaxnum+1)
          while temp_cardi[set_card_rand] == 99
            set_card_rand = rand($Cardmaxnum+1)
          end
          set_card = set_card_rand
          $cha_set_action[a] = 1
          set_mode = 3
          
        end
        
        set_cha_tactics_nil_to_zero $partyc[a]
        
        #テキの選択
        
        case $cha_tactics[0][$partyc[a]]
        
        when 0 #弱い敵
          if $enehp.min != 0 #HPが低い敵から攻撃していく
            $cha_set_enemy[a] = $enehp.index($enehp.min)
          else
            while $enehp.index(set_enehp) == nil
              set_enehp += 1
            end
            $cha_set_enemy[a] = $enehp.index(set_enehp)
          end
        when 1 #強い敵
          
          #if $enehp.min != 0 #HPが高い敵から攻撃していく
            enemaxhp = [[],[]]
            for x in 0..$battleenemy.size - 1
              
              if $enedead[x] == false
                enemaxhp[0][x] = $data_enemies[$battleenemy[x]].maxhp
                
              else
                enemaxhp[0][x] = 0
              end
              enemaxhp[1][x] = x
            end
            #p enemaxhp[0],enemaxhp[1],enemaxhp[0].max
            $cha_set_enemy[a] = enemaxhp[1][enemaxhp[0].index(enemaxhp[0].max)]
          #end
        end
        
        #p temp_cardi,$cardset_cha_no,$partyc[a],set_card
        get_battle_skill $partyc[a],set_card,0
        temp_cardi[set_card] = 99
        #p temp_cardi,set_card,set_mode
        $cardset_cha_no[set_card] = a
        @@card_set_count += 1
      end
      
      #@battle_cha_num = @@card_set_count
      chk_battle_start
      if @@battle_main_result == 1
        
        break
      end
    end
      
  end
  #--------------------------------------------------------------------------
  # ● カード表示
  #--------------------------------------------------------------------------  
  def output_card
      # カード表示
      picture = Cache.picture("カード関係")
      recta = set_card_frame 0
      for a in 1..6 do
        @card_ryuha_blink_count += 1
        rectb = set_card_frame 2,$carda[a-1]
        rectc = set_card_frame 3,$cardg[a-1]
        rectd = Rect.new(0 + 32 * ($cardi[a-1]), 64, 32, 32) # 流派 
        #カードが選択された場合は上に挙げる
        if $cardset_cha_no[a-1] != 99 then
          @card_window.contents.blt(Cardoutputkizyun + Cardsize * (a-1),24-Cardup,picture,recta)
          @card_window.contents.blt(Cardoutputkizyun + 2 + Cardsize * (a-1)+$output_carda_tyousei_x,26-Cardup+$output_carda_tyousei_y,picture,rectb)
          @card_window.contents.blt(Cardoutputkizyun + 30 + Cardsize * (a-1)+$output_cardg_tyousei_x,86-Cardup+$output_cardg_tyousei_y,picture,rectc)
          @card_window.contents.blt(Cardoutputkizyun + 16 + Cardsize * (a-1)+$output_cardi_tyousei_x,56-Cardup+$output_cardi_tyousei_y,picture,rectd)
        else
          
          if $WinState == 2 && @card_ryuha_blink_count <= 20
            #流派か必殺、気の場合は点滅させる
            if $cardi[a-1] == $game_actors[$partyc[@@battle_cha_cursor_state]].class_id-1 || $cardi[a-1] == 0 || $cardi[a-1] == 16 || chk_zetubo_ran($partyc[@@battle_cha_cursor_state],0,true) == true || chk_kinobousou_ran($partyc[@@battle_cha_cursor_state],0,true) == true
              rectd = Rect.new(32 * ($cardi[a-1]), 240, 32, 32) # 流派
            end
            
          else
            if @card_ryuha_blink_count >= 40
              @card_ryuha_blink_count = 0
            end 
          end
          @card_window.contents.blt(Cardoutputkizyun + Cardsize * (a-1),24,picture,recta)
          @card_window.contents.blt(Cardoutputkizyun + 2 + Cardsize * (a-1)+$output_carda_tyousei_x,26+$output_carda_tyousei_y,picture,rectb)
          @card_window.contents.blt(Cardoutputkizyun + 30 + Cardsize * (a-1)+$output_cardg_tyousei_x,86+$output_cardg_tyousei_y,picture,rectc)
          @card_window.contents.blt(Cardoutputkizyun + 16 + Cardsize * (a-1)+$output_cardi_tyousei_x,56+$output_cardi_tyousei_y,picture,rectd)
        end
      end

  end
 
  #--------------------------------------------------------------------------
  # ● カーソル表示
  #--------------------------------------------------------------------------  
  def output_cursor
    $cursor_blink_count += 1
    # メニューカーソル表示
    if $WinState == 0 || $WinState == 5 || $WinState == 7 || $WinState == 98 || $WinState == 99
      picture = Cache.picture("アイコン")
      if $WinState == 0 
        rect = set_yoko_cursor_blink
      else
        rect = set_yoko_cursor_blink 0 # アイコン
      end
      @menu_window.contents.blt(0 ,6+$CursorState*32,picture,rect)
    end
    # 行動対象カーソル表示
    if $WinState != 0 && $WinState != 5 && $WinState != 7 && $WinState != 8 && $WinState != 98 && $WinState != 99
      picture = Cache.picture("アイコン")
      if $WinState == 1 
        rect = set_yoko_cursor_blink
      else
        rect = set_yoko_cursor_blink 0 # アイコン
      end
      @status_window.contents.blt(32 + Chastex * (@@battle_cha_cursor_state-@output_cha_window_state)  ,18,picture,rect)
    end
    
    # カードカーソル表示
    if $WinState == 2
      picture = Cache.picture("アイコン")
      rect = set_tate_cursor_blink
      @card_window.contents.blt(60 + Cardsize * ($CardCursorState+1)  ,8,picture,rect)
    end
    
    # 敵キャラカーソル表示
    if $WinState == 3 || $WinState == 7
      if $WinState == 7
        @@battle_ene_cursor_state = chk_select_cursor_control (2,@@battle_ene_cursor_state,0,0,$battleenenum-1)#その場からチェック
      end
      picture = Cache.picture("アイコン")
      rect = set_tate_cursor_blink
      if $battleenenum != 9
        @back_window.contents.blt(640/2+6-($battleenenum-1)*40+@@battle_ene_cursor_state*80, 244,picture,rect) # 真ん中
      else
        #9体
        @back_window.contents.blt(640/2+6+48-($battleenenum-1)*40+@@battle_ene_cursor_state*68, 244,picture,rect) # 真ん中
      end
    end
    
    # オートマニュアル選択
    if $WinState != 0 && $WinState != 7 && $WinState != 5 && $WinState != 98 && $WinState != 99
      picture = Cache.picture("アイコン")
      if $WinState == 8
        rect = set_yoko_cursor_blink
      else
        rect = set_yoko_cursor_blink 0 # アイコン
      end
      @btl_menu_window.contents.blt(0 ,12+$btl_MenuCursorState*32,picture,rect)
    end
    
    # ページカーソル表示
    if $partyc.size > 6
      picture = Cache.picture("アイコン")
      
      #右側カーソル
      if @output_cha_window_state == 0 || $partyc.size > @output_cha_window_state + 6

        # スプライトのビットマップに画像を設定
        @right_cursor.bitmap = Cache.picture("アイコン")
        @right_cursor.src_rect = Rect.new(16*5, 0, 16, 16)
        @right_cursor.x = 619
        @right_cursor.y = 41
        @right_cursor.z = 255
        #@back_window.contents.blt(600, 400,picture,rect) # 真ん中
      else
        @right_cursor.bitmap = nil
      end
      
      #左側カーソル
      if @output_cha_window_state != 0
        # スプライトのビットマップに画像を設定
        @left_cursor.bitmap = Cache.picture("アイコン")
        @left_cursor.src_rect = Rect.new(16*6, 0, 16, 16)
        @left_cursor.x = 5
        @left_cursor.y = 41
        @left_cursor.z = 255
        #rect = Rect.new(16*6, 0, 16, 16) # アイコン
        #@back_window.contents.blt(40,400,picture,rect) # 真ん中
      else
        @left_cursor.bitmap = nil
      end
    end
    
    # 戦闘開始確認カーソル表示
    if $WinState == 4 && @msg_window != nil
      
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      case @battle_str_cursor_state
      when 0 then
        # はい
        @msg_window.contents.blt(288 ,38,picture,rect)
      when 1 then
        # いいえ
        @msg_window.contents.blt(288 ,70,picture,rect)
      end
    end
    
    # 詳細メニュー時
    if $WinState == 5
      picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      if $MenuCursorState <= 2 #左
        @msg_window.contents.blt(0 ,6+$MenuCursorState*32,picture,rect)
      elsif $MenuCursorState <= 5 #右
        @msg_window.contents.blt(128 ,6+$MenuCursorState*32-96,picture,rect)
      end
      
    end
    
    #必殺技ウインドウ
    if $WinState == 6
    picture = Cache.picture("アイコン")
      rect = set_yoko_cursor_blink
      @technique_window.contents.blt(0 ,32+$MenuCursorState*24+8,picture,rect)
    end
  end
  
  #--------------------------------------------------------------------------
  # ● キャラ能力・死亡・行動済み・攻撃先状態表示
  #--------------------------------------------------------------------------   
  def output_status

    #ターン文字
    mozi = "TN"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(0 ,-8,picture,rect)
    
    #ターン数
    mozi = $battle_turn_num.to_s
    
    #1桁であれば頭に0を加える
    if mozi.size == 1
      mozi = "0" + mozi
    elsif mozi.size == 3
      #100ターンを超えた場合
      mozi = "99"
    end
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    picture = $tec_mozi
    @status_window.contents.blt(0 ,-8 + 16,picture,rect)
    
    #ヘッダ
    picture = Cache.picture("数字英語")
    
    #HP
    rect = Rect.new(0, 16, 32, 16)
    @status_window.contents.blt(0 ,Chastelv+16,picture,rect)
    #KI
    rect = Rect.new(32, 16, 32, 16)
    @status_window.contents.blt(0 ,Chastelv+48,picture,rect)


    
    #キャラ能力
    picturea = Cache.picture("名前")
    pictureb = Cache.picture("数字英語")
    #picturec = Cache.picture($top_file_name + "顔味方")
    #for x in 0..$partyc.size -1 #キャラ分ループ
    #@output_cha_window_state = 1
    x = @output_cha_window_state
    
    for z in 0..@cha_put_icon.size - 1
      @cha_put_icon[z] = []
    end
      
    begin
      #ヘッダ
      picture = Cache.picture("数字英語")
      
      if $game_actors[$partyc[x]].level < 100
        rect = Rect.new(64, 16, 32, 16)#LV
      else
        rect = Rect.new(336, 0, 16, 16)#LV
      end
      @status_window.contents.blt(48+((x-@output_cha_window_state)*Chastex) ,Chastelv,picture,rect)
      rect = Rect.new(0, 0+($partyc[x]-3)*16, 160, 16) # 名前
      if $partyc[x] != 8 && $partyc[x] != 24 && $partyc[x] != 30 then #テンシンハン_かめせんにん_パンブーキンの時のみ左に1文字分ずらす
        @status_window.contents.blt(48+((x-@output_cha_window_state)*Chastex) ,0,picturea,rect)
      else
        @status_window.contents.blt(36+((x-@output_cha_window_state)*Chastex) ,0,picturea,rect)
      end
      
      if $chadead[x] == true #死亡時はモノクロを表示
        rect,picturec = set_character_face 2,$partyc[x]-3
        #rect = Rect.new(128, 0+(($partyc[x]-3)*64), 64, 64) # 顔グラ
      elsif ($game_actors[$partyc[x]].hp.prec_f / $game_actors[$partyc[x]].maxhp.prec_f * 100).prec_i < $hinshi_hp
        rect,picturec = set_character_face 1,$partyc[x]-3
        #rect = Rect.new(64, 0+(($partyc[x]-3)*64), 64, 64) # 顔グラ
      else
        rect,picturec = set_character_face 0,$partyc[x]-3
        #rect = Rect.new(0, 0+(($partyc[x]-3)*64), 64, 64) # 顔グラ
      end
      @status_window.contents.blt(48+((x-@output_cha_window_state)*Chastex) ,18,picturec,rect)
      
      #味方行動停止回数出力
      
      #オプションで表示全てか敵のみか
      if $game_variables[356] == 0 || $game_variables[356] == 1
      
        if $cha_stop_num[x] != 0 && $chadead[x] == false
          picture = Cache.picture("数字英語")
          #p $ene_stop_num[x].to_s.size,$ene_stop_num[x]
          
          for y in 1..$cha_stop_num[x].to_s.size
            rect = Rect.new($cha_stop_num[x].to_s[-y,1].to_i*16, 48, 16, 16)
            @status_window.contents.blt(48+((x-@output_cha_window_state)*Chastex) + 48 - (y-1)*16 ,18+48,picture,rect)
          end
          
        end
      end
      
      rect = Rect.new(160, 0, 16, 16) # スラッシュ
      @status_window.contents.blt(32+((x-@output_cha_window_state)*Chastex) ,Chastelv+32,pictureb,rect)
      @status_window.contents.blt(32+((x-@output_cha_window_state)*Chastex) ,Chastelv+64,pictureb,rect)
      
      for y in 1..$game_actors[$partyc[x]].level.to_s.size #LV
        
        if $game_actors[$partyc[x]].level.to_s.size <= 3 #LV3桁 通常
          rect = Rect.new(0+$game_actors[$partyc[x]].level.to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(96-((y-1)*16)+((x-@output_cha_window_state)*Chastex) ,Chastelv,pictureb,rect)
        else
          case y
              
          when 1..2
            rect = Rect.new(0+$game_actors[$partyc[x]].level.to_s[-y,1].to_i*8, 168, 8, 16)
            @status_window.contents.blt(96-((y-1)*8)+((x-@output_cha_window_state)*Chastex)+8,Chastelv,pictureb,rect)
          else
            rect = Rect.new(0+$game_actors[$partyc[x]].level.to_s[-y,1].to_i*16, 0, 16, 16)
            @status_window.contents.blt(96-((y-1)*16)+((x-@output_cha_window_state)*Chastex)+16,Chastelv,pictureb,rect)
          end
        end
      end      
      
      for y in 1..$game_actors[$partyc[x]].hp.to_s.size #HP
        if $game_actors[$partyc[x]].hp.to_s.size <= 4 #HP4桁
          rect = Rect.new(0+$game_actors[$partyc[x]].hp.to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(96-((y-1)*16)+((x-@output_cha_window_state)*Chastex) ,Chastelv+16,pictureb,rect)
        else
          case y
              
          when 1..2
            rect = Rect.new(0+$game_actors[$partyc[x]].hp.to_s[-y,1].to_i*8, 168, 8, 16)
            @status_window.contents.blt(96-((y-1)*8)+((x-@output_cha_window_state)*Chastex)+8,Chastelv+16,pictureb,rect)
          else
            rect = Rect.new(0+$game_actors[$partyc[x]].hp.to_s[-y,1].to_i*16, 0, 16, 16)
            @status_window.contents.blt(96-((y-1)*16)+((x-@output_cha_window_state)*Chastex)+16,Chastelv+16,pictureb,rect)
          end          
        end
      end
      
      for y in 1..$game_actors[$partyc[x]].maxhp.to_s.size #MHP
        if $game_actors[$partyc[x]].maxhp.to_s.size <= 4
          rect = Rect.new(0+$game_actors[$partyc[x]].maxhp.to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(96-((y-1)*16)+((x-@output_cha_window_state)*Chastex) ,Chastelv+32,pictureb,rect)
        else
          case y
              
          when 1..2
            rect = Rect.new(0+$game_actors[$partyc[x]].maxhp.to_s[-y,1].to_i*8, 168, 8, 16)
            @status_window.contents.blt(96-((y-1)*8)+((x-@output_cha_window_state)*Chastex)+8,Chastelv+32,pictureb,rect)
          else
            rect = Rect.new(0+$game_actors[$partyc[x]].maxhp.to_s[-y,1].to_i*16, 0, 16, 16)
            @status_window.contents.blt(96-((y-1)*16)+((x-@output_cha_window_state)*Chastex)+16,Chastelv+32,pictureb,rect)
          end

        end
      end
      
      for y in 1..$game_actors[$partyc[x]].mp.to_s.size #ki
        if $game_actors[$partyc[x]].mp.to_s.size <= 4 #KI4桁
          rect = Rect.new(0+$game_actors[$partyc[x]].mp.to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(96-((y-1)*16)+((x-@output_cha_window_state)*Chastex) ,Chastelv+48,pictureb,rect)
        else
          case y
              
          when 1..2
            rect = Rect.new(0+$game_actors[$partyc[x]].mp.to_s[-y,1].to_i*8, 168, 8, 16)
            @status_window.contents.blt(96-((y-1)*8)+((x-@output_cha_window_state)*Chastex)+8,Chastelv+48,pictureb,rect)
          else
            rect = Rect.new(0+$game_actors[$partyc[x]].mp.to_s[-y,1].to_i*16, 0, 16, 16)
            @status_window.contents.blt(96-((y-1)*16)+((x-@output_cha_window_state)*Chastex)+16,Chastelv+48,pictureb,rect)
          end

        end
      end
      
      for y in 1..$game_actors[$partyc[x]].maxmp.to_s.size #mki
        if $game_actors[$partyc[x]].maxmp.to_s.size <= 4 #MKI4桁
          rect = Rect.new(0+$game_actors[$partyc[x]].maxmp.to_s[-y,1].to_i*16, 0, 16, 16)
          @status_window.contents.blt(96-((y-1)*16)+((x-@output_cha_window_state)*Chastex) ,Chastelv+64,pictureb,rect)
        else
          case y
              
          when 1..2
            rect = Rect.new(0+$game_actors[$partyc[x]].maxmp.to_s[-y,1].to_i*8, 168, 8, 16)
            @status_window.contents.blt(96-((y-1)*8)+((x-@output_cha_window_state)*Chastex)+8,Chastelv+64,pictureb,rect)
          else
            rect = Rect.new(0+$game_actors[$partyc[x]].maxmp.to_s[-y,1].to_i*16, 0, 16, 16)
            @status_window.contents.blt(96-((y-1)*16)+((x-@output_cha_window_state)*Chastex)+16,Chastelv+64,pictureb,rect)
          end

        end
      end
      
      #表示icon格納用
      set_cha_put_icon x

      picture = Cache.picture("アイコン")
      # パワーアップアイコン表示
      rect = Rect.new(64, 0, 16, 16) # 死亡アイコン
      if $cha_power_up[x] == true then
        @status_window.contents.blt(32+(x-@output_cha_window_state)*Chastex ,34,picture,rect)
      end
      
      # ディフェンスアップアイコン表示
      rect = Rect.new(112, 0, 16, 16) # 死亡アイコン
      if $one_turn_cha_defense_up == true then
        @status_window.contents.blt(32+(x-@output_cha_window_state)*Chastex ,50,picture,rect)
      end
      
      if $cha_defense_up[x] == true then
        rect = Rect.new(128, 0, 16, 16) # ディフェンスーアップアイコン
        @status_window.contents.blt(32+(x-@output_cha_window_state)*Chastex ,50,picture,rect) 
      end
      
      # 攻撃先No表示
      
      picture = Cache.picture("数字英語")
      if $cha_set_enemy[x] != 99 then
        
        put = true
        if $cha_set_action[x] > 10
          put =false if $data_skills[$cha_set_action[x]-10].element_set.index(10)!= nil
        end
        
        if put == true
          
          if $data_skills[$cha_set_action[x]-10].scope == 2
            rect = Rect.new(18*16,0, 16, 16) # 攻撃先
          else
            rect = Rect.new(($cha_set_enemy[x]+1)*16,0, 16, 16) # 攻撃先
          end
          @status_window.contents.blt(32+(x-@output_cha_window_state)*Chastex ,66,picture,rect)
        end
      end
      
      if $cha_single_attack[x] == true then
        rect = Rect.new(16*16,0, 16, 16)
        @status_window.contents.blt(32+(x-@output_cha_window_state)*Chastex ,66 + 16 + 2,picture,rect)
      end
      #光の旅ゲージ表示
      hikaritrun = 0 #0なら取得していないという判定で
      meterdot = 0 #メーターの増加量
      
      hikaritrun,meterdot = chk_hikarinotabirun($partyc[x])
      
      if hikaritrun != 0
        #ゲージ枠表示
        #picture = Cache.picture("光の旅ゲージ")
        picture = Cache.picture("光の旅ゲージ_横4")
        #rect = Rect.new(6*(hikaritrun-1),0, 6, 64)
        rect = Rect.new(8*(hikaritrun-1),0, 8, 64)
        meterwakux = 48+((x-@output_cha_window_state)*Chastex)+64
        meterwakuy = 18
        
        @status_window.contents.blt(meterwakux,meterwakuy,picture,rect)
        
        $cha_hikari_turn[$partyc[x]] = 0 if $cha_hikari_turn[$partyc[x]] == nil
        chameter = $cha_hikari_turn[$partyc[x]]
        color = Color.new(254,120,48,256) #メーター(オレンジ)
        color2 = Color.new(255,255,255,256) #線(白)
        #ゲージのバーを表示
        if chameter != 0
          #ゲージを表示
          #@status_window.contents.fill_rect(meterwakux + 2,meterwakuy + 62-(meterdot*chameter),2,chameter*meterdot,color)
          @status_window.contents.fill_rect(meterwakux + 2,meterwakuy + 62-(meterdot*chameter),4,chameter*meterdot,color)
          for y in 1..chameter
            #白の横線を上書き
            #@status_window.contents.fill_rect(meterwakux + 2,meterwakuy + 62-(meterdot*y),2,2,color2)
            @status_window.contents.fill_rect(meterwakux + 2,meterwakuy + 62-(meterdot*y),4,2,color2)
          end
        end
        
=begin
        case hikaritrun
        
        when 2
          
        when 3
          
        when 4
          
        when 5
          
        when 6
        
        end
=end
      end
      x += 1
    end while x != $partyc.size && x != 6 + @output_cha_window_state

    #表示範囲外(前)のキャラのスキルを取得
    if $partyc.size >= 7
      @cha_put_icon_hanigaimae = []
      @sprite_cha_put_icon_hanigaimae.visible = false
      for x in 0..@output_cha_window_state - 1
        #死んでいないキャラ かつ行動を選択していないキャラ
        if $chadead[x] == false && $cha_set_action[x] == 0
          set_cha_put_icon x,4 #範囲外前のキャラのスキル発動を格納
        end
      end
    end
    
    #表示範囲外(後)のキャラのスキルを取得
    if $partyc.size >= 7
      @cha_put_icon_hanigaiato = []
      @sprite_cha_put_icon_hanigaiato.visible = false
      for x in (@output_cha_window_state + 6)..$partyc.size - 1
        #死んでいないキャラ かつ行動を選択していないキャラ
        if $chadead[x] == false && $cha_set_action[x] == 0
          set_cha_put_icon x,6 #範囲外後ろのキャラのスキル発動を格納
        end
      end
    end
    
  end
  #--------------------------------------------------------------------------
  # ● スキル発動表示iconのセット用
  #--------------------------------------------------------------------------   
  # mode:表示範囲内か、外か
  #      4:範囲外(前),5:範囲内,6:範囲外(後)
  #arraynum:チェック、格納配列
  def set_cha_put_icon arraynum=0,mode = 5
    
    
    if $cha_ki_zero[arraynum] == true || #KIの消費ゼロ
      $cha_wakideru_flag[arraynum] == true # #湧き出る力
      @cha_put_icon[arraynum] << "BW" if mode == 5
      @cha_put_icon_hanigaimae << "BW" if mode == 4
      @cha_put_icon_hanigaiato << "BW" if mode == 6
    end
    
    if get_battle_skill($partyc[arraynum],0,0,1) == true #M全開パワー発動かチェック
      @cha_put_icon[arraynum] << "RM"
      @cha_put_icon_hanigaimae << "RM" if mode == 4
      @cha_put_icon_hanigaiato << "RM" if mode == 6
    end
    
    if $cha_ki_tameru_flag[arraynum] == true #気を溜めるチェック
     @cha_put_icon[arraynum] << "RK"
     @cha_put_icon_hanigaimae << "RK" if mode == 4
      @cha_put_icon_hanigaiato << "RK" if mode == 6
    end
    
    if $cha_sente_flag[arraynum] == true ||#先手チェック
        $cha_sente_card_flag[arraynum] == true #先手カード
      @cha_put_icon[arraynum] << "RF"
      @cha_put_icon_hanigaimae << "RF" if mode == 4
      @cha_put_icon_hanigaiato << "RF" if mode == 6
    end
    
    if $cha_kaihi_card_flag[arraynum] == true #回避チェック
      @cha_put_icon[arraynum] << "RD"
      @cha_put_icon_hanigaimae << "RD" if mode == 4
      @cha_put_icon_hanigaiato << "RD" if mode == 6
    end
    
    #重複削除
    if mode != 5
      @cha_put_icon_hanigaiato.uniq!
      #p @cha_put_icon[0],@cha_put_icon_hanigaiato
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソル数値の最適化
  #--------------------------------------------------------------------------   
  # num:チェックの種類 ,x:対象の値 ,n:チェック種類 ,min左最小 ,max右最大
  # num:0:バトルキャラ ,1:カード ,2:バトル
  # n:0:その場 1:右へ 2:左へ
  # rubyの使用が参照渡しのようなので年のためxをyへ格納する
  def chk_select_cursor_control(num,x,n,min,max)
    
    @chk_select_cursor_control_flag = false
    y = x
    if n == 1 then #右ならx+1 左ならx-1
      y += 1
    elsif n == 2 then
      y -= 1
    end
    
    if y > max then #yがmaxより大きければ一番左へminより小さければ右へ
      y = min
      @chk_select_cursor_control_flag = true
    elsif y < min then
      y = max
      @chk_select_cursor_control_flag = true
    end
    while y <= max do

      if y > max then
        y = min 
      elsif y < min then
        y = max
      end 
      
      #チェック方法
      case num
      
      when 0 then #バトルキャラ味方
        if $cha_set_action[y] == 0 && $chadead[y] == false && $cha_stop_num[y] == 0 then
        #if $cha_set_action[y] == 0 && $chadead[y] == false then
          return y
        end
      when 1 then #カード
        if $cardset_cha_no[y] == 99 then
          return y
        end
      
      when 2 then #バトル対象味方⇒敵
        if $enedead[y] == false then
          return y
        end        
      end
      
      @chk_select_cursor_control_flag = true
      
      if n <= 1 then
        y += 1
      elsif n == 2 then
        y -= 1
      end
      
      if y > max then
        y = min 
      elsif y < min then
        y = max
      end      
    end
  end

  #--------------------------------------------------------------------------
  # ● 攻撃先設定を解除
  #-------------------------------------------------------------------------- 
  def battle_set_cancel
    if @@card_set_count > 0 then
      
      $cha_set_action[@@card_set_no[@@card_set_count-1]] = 0
      $cha_set_enemy[@@card_set_no[@@card_set_count-1]] = 99
      
      for x in 0..$Cardmaxnum
        if $cardset_cha_no[x] == @@card_set_no[@@card_set_count-1] then
          @@battle_cha_cursor_state = $cardset_cha_no[x]
          $cardset_cha_no[x] = 99
          @@card_set_no[@@card_set_count] = 99
          $carda[x] = @temp_carda[x]
          $cardg[x] = @temp_cardg[x]
          $cardi[x] = $temp_cardi[x]
        end
      
      end
      @@card_set_count -= 1
      
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 新しく閃き必殺技を覚えたかチェック
  #-------------------------------------------------------------------------- 
  def chk_new_tecspark
    
    #新技取得フラグ
    if $game_switches[30] == true
      #new_index = 0
      #text2 = ""
      new_count = 0
      text2 = []
      #ダブル衝撃波
      
      for x in 0..$tecspark_count
        
        if $game_switches[$tecspark_new_flag[x]] == true
          new_count += 1
          $game_switches[$tecspark_get_flag[x]] = true
          $game_switches[$tecspark_new_flag[x]] = false
          #text2[new_count] = $data_skills[$tecspark_no[x]].name
          text2[new_count] = $data_skills[$tecspark_no[x]].description
          $game_actors[$tecspark_cha[x]].learn_skill($tecspark_no[x])
        end
        
      end  
      
      if @msg_window == nil
        create_msg_window
      end
      #p text2
      for i in 1..new_count
        Audio.se_play("Audio/SE/" +"ZG 技取得")
        #text1 = "よし！"
        text2[i] += " を"
        #text3 = "使えるようになったぞ！"
        #@msg_window.contents.draw_text( 0, 0, 400, MSG_ROW_SIZE, text1)
        #@msg_window.contents.draw_text( 0, 22, 400, MSG_ROW_SIZE, text2[i])
        #@msg_window.contents.draw_text( 0, 44, 400, MSG_ROW_SIZE, text3)
        mozi = "よし！"
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        picture = $tec_mozi
        @msg_window.contents.blt(2 ,-2+0*32,picture,rect)
        mozi = text2[i]
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        picture = $tec_mozi
        @msg_window.contents.blt(2 ,-2+1*32,picture,rect)
        mozi = "つかえるようになったぞ！"
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        picture = $tec_mozi
        @msg_window.contents.blt(2 ,-2+2*32,picture,rect)
        if $game_variables[38] == 0
          Graphics.wait(120)
        else
          @msg_cursor.visible = true
          input_loop_run
          #@msg_cursor.visible = false
          Graphics.wait(5)
        end
        @msg_window.contents.clear
        
      end
      
    end
    

    #$game_switches[30] = false
    
  end
  
  #--------------------------------------------------------------------------
  # ● 新しくスパーキングコンボを覚えたかチェック
  #-------------------------------------------------------------------------- 
  def chk_new_scombo
    
    #スパーキングコンボ取得フラグ
    if $game_switches[30] == true
      #new_index = 0
      #text2 = ""
      new_count = 0
      text2 = []
      #ダブル衝撃波
      
      for x in 0..$scombo_count
        
        if $game_switches[$scombo_new_flag[x]] == true
          new_count += 1
          $game_switches[$scombo_get_flag[x]] = true
          $game_switches[$scombo_new_flag[x]] = false
          #text2[new_count] = $data_skills[$scombo_no[x]].name
          text2[new_count] = $data_skills[$scombo_no[x]].description
        end
        
      end  
      
      if @msg_window == nil
        create_msg_window
      end
      #p text2
      for i in 1..new_count
        Audio.se_play("Audio/SE/" +"ZG 技取得")
        #text1 = "よし！"
        text2[i] += " を"
        #text3 = "使えるようになったぞ！"
        #@msg_window.contents.draw_text( 0, 0, 400, MSG_ROW_SIZE, text1)
        #@msg_window.contents.draw_text( 0, 22, 400, MSG_ROW_SIZE, text2[i])
        #@msg_window.contents.draw_text( 0, 44, 400, MSG_ROW_SIZE, text3)
        mozi = "よし！"
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        picture = $tec_mozi
        @msg_window.contents.blt(2 ,-2+0*32,picture,rect)
        mozi = text2[i]
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        picture = $tec_mozi
        @msg_window.contents.blt(2 ,-2+1*32,picture,rect)
        mozi = "つかえるようになったぞ！"
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        picture = $tec_mozi
        @msg_window.contents.blt(2 ,-2+2*32,picture,rect)
        if $game_variables[38] == 0
          Graphics.wait(120)
        else
          @msg_cursor.visible = true
          input_loop_run
          #@msg_cursor.visible = false
          Graphics.wait(5)
        end
        @msg_window.contents.clear
        
      end
      
    end
    

    $game_switches[30] = false
    
  end
  
  #--------------------------------------------------------------------------
  # ● ダメージ合計表示
  #-------------------------------------------------------------------------- 
  def chk_damage_counter
    
    #出力フラグがONかつ戦闘練習中
    if $btl_put_sumdamage_flag == true && $game_switches[1305] == true
      
      if @msg_window == nil
        create_msg_window
      end
      #p text2
      Audio.se_play("Audio/SE/" +"Z3 アイテム取得")
      #text1 = "よし！"
      #text2[i] += " を"
      #text3 = "使えるようになったぞ！"
      #@msg_window.contents.draw_text( 0, 0, 400, MSG_ROW_SIZE, text1)
      #@msg_window.contents.draw_text( 0, 22, 400, MSG_ROW_SIZE, text2[i])
      #@msg_window.contents.draw_text( 0, 44, 400, MSG_ROW_SIZE, text3)
      mozi = "それぞれのきろくは　いかのとおりだ！"
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      picture = $tec_mozi
      @msg_window.contents.blt(2 ,-2+0*32,picture,rect)
      mozi = "このターンのきろく：" + $game_variables[425].to_s
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      picture = $tec_mozi
      @msg_window.contents.blt(2 ,-2+1*32,picture,rect)
      mozi = "かいしまえのきろく：" + $game_variables[423].to_s
      output_mozi mozi
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      picture = $tec_mozi
      @msg_window.contents.blt(2 ,-2+2*32,picture,rect)
      
      #この戦闘の最高ダメージか確認
      if $game_variables[424] < $game_variables[425]
        #ダメージ
        $game_variables[424] = $game_variables[425]
        #ターン数
        $game_variables[426] = $battle_turn_num - 1
      end
      
      if $game_variables[38] == 0
        Graphics.wait(120)
      else
        @msg_cursor.visible = true
        input_loop_run
        #@msg_cursor.visible = false
        Graphics.wait(5)
      end
      @msg_window.contents.clear
      $btl_put_sumdamage_flag = false
      
      #ターンの最高ダメージ初期化
      $game_variables[425] = 0
    end
  end

  #--------------------------------------------------------------------------
  # ● 味方キャラの戦闘有効数(生きていて戦闘ができる数)
  # stop_non:ストップは引かない
  #--------------------------------------------------------------------------     
  def battlechacount stop_non = false
    @battle_cha_num = $partyc.size
    
    for x in 0..$partyc.size - 1
      
      if $chadead[x] == true || $cha_stop_num[x] != 0 && stop_non == false
        @battle_cha_num -= 1
      end
      #if $chadead[x] == true then
      #  @battle_cha_num -= 1
      #end
    end
    
  end
  
  #--------------------------------------------------------------------------
  # ● 味方死亡処理
  #-------------------------------------------------------------------------- 
  def chk_character_dead
    
    #dead = false #死亡処理を実行したか？
    for y in 0..$partyc.size - 1 #味方死亡処理
      if $chadead[y] != $chadeadchk[y]
        #p $full_chadead
        $chadead[y] = $chadeadchk[y]
        Graphics.wait(20)
        output_status
        @status_window.update
        Graphics.update
        if @msg_window == nil
          create_msg_window
        end
        Audio.se_play("Audio/SE/" +"Z3 死亡")
        #text = $game_actors[$partyc[y]].name + " が戦闘不能になった。"
        #@msg_window.contents.draw_text( 0, 0, 400, MSG_ROW_SIZE, text)
        mozi = chg_fc_mozi_tikan($game_actors[$partyc[y]].name) + "が　せんとうふのうになった"
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        @msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
        if $game_variables[38] == 0
          Graphics.wait(60)
        else
          @msg_cursor.visible = true
          input_loop_run
          #@msg_cursor.visible = false
          Graphics.wait(5)
        end
        @msg_window.contents.clear
        dead = true
        
        #フリーザ戦でかつ悟空が死んでなければ
        if $game_variables[41] == 493 && $chadead[$partyc.index(3)] == false
          $game_switches[103] = true
        end
      end      

    end
  end
  
  #--------------------------------------------------------------------------
  # ● 敵死亡処理
  #--------------------------------------------------------------------------  
  def chk_enemy_dead
    
    #dead = false #死亡処理を実行したか？
    

    
    for x in 0..$battleenenum - 1 #敵死亡処理
      if $enedead[x] != $enedeadchk[x]
        $enedead[x] = $enedeadchk[x]
        if $game_variables[38] == 0
          Graphics.wait(20)
        else
          Graphics.wait(5)
        end
        output_back
        Graphics.update
        if @msg_window == nil
          create_msg_window
        end
        Audio.se_play("Audio/SE/" +"Z3 死亡")
        #text = $data_enemies[$battleenemy[x]].name + " を倒した。"
        #@msg_window.contents.draw_text( 0, 0, 400, MSG_ROW_SIZE, text)
        if $game_switches[137] == true && $data_enemies[$battleenemy[x]].element_ranks[21] == 1
          mozi = chg_fc_mozi_tikan($data_enemies[$battleenemy[x]].name) + "は　だいダメージを　くらった！！"
        elsif $eneselfdeadchk[x] == true
          mozi = chg_fc_mozi_tikan($data_enemies[$battleenemy[x]].name) + "は　じばくした！"
        else
          mozi = chg_fc_mozi_tikan($data_enemies[$battleenemy[x]].name) + "を　たおした！"
          
        end
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        @msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
        if $game_variables[38] == 0
          Graphics.wait(60)
        else
          @msg_cursor.visible = true
          input_loop_run
          #@msg_cursor.visible = false
          Graphics.wait(5)
        end
        @msg_window.contents.clear
        dead = true
      end      
    end
    
    result=chk_all_enemy_dead
    
    return result
  end
  
  #--------------------------------------------------------------------------
  # ● 味方全滅確認
  #--------------------------------------------------------------------------
  def chk_all_character_dead
    if $chadead.index(false) == nil
      @@battle_main_result = 3
    end
  end
  #--------------------------------------------------------------------------
  # ● 敵全滅確認
  #--------------------------------------------------------------------------
  def chk_all_enemy_dead
    if $enedead.index(false) == nil #敵を全員倒したか判定
      
      #戦闘終了後のBGM鳴らさないフラグがOFFならならす
      put_btl_end_bgm if $game_switches[148] == false
      @total_exp = 0

      #9人を超える場合があるので、フルメンバーを取得する
      temp_full_party = get_full_party
      #p temp_full_party
      
      #共有経験値の取得
      if $game_variables[306] != 0
        #周回プレイ用に経験値を計算する
        rate = 100 + ($game_variables[353] * 10)
        sexp = (($game_variables[306].to_i * rate).to_f / 100).ceil
        mozi = "テキをたおして　Sけいけんち　" + sexp.to_s + "　を　えた！"
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        @msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
        @msg_window.update
        if $game_variables[38] == 0
          Graphics.wait(80)
        else
          Graphics.wait(10)
          @msg_cursor.visible = true
          input_loop_run
          #@msg_cursor.visible = false
          Graphics.wait(10)
        end
        $game_variables[305] += sexp.to_i
        @msg_window.contents.clear
        
        
      end

      for y in 0..temp_full_party.size - 1 #ZP取得
        
        #if $chadead[y] == false || $chadead[y] == nil #死んでなければ増加
          $zp[temp_full_party[y]] = 0 if $zp[temp_full_party[y]] == nil
          #とりあえず敵を倒したぶん取得するように
          add_zp = $battleenenum
          
          #ZPの取得倍率を取得する
          zp_bairitu = get_zp_bairitu
          
          add_zp = add_zp * zp_bairitu
          $zp[temp_full_party[y]] += add_zp
        #end
      end
      
      #経験値取得
      if $game_switches[124] == false

        for y in 0..$battleenenum - 1
          @total_exp = @total_exp.to_i + $data_enemies[$battleenemy[y.to_i]].exp.to_i
        end
        
        @total_cap = 0
        for y in 0..$battleenenum - 1
          @total_cap += $data_enemies[$battleenemy[y.to_i]].gold.to_i
        end
        
        @total_sp  = 0
        for y in 0..$battleenenum - 1
          @total_sp += $data_enemies[$battleenemy[y.to_i]].maxmp.to_i
        end
        
        if $game_variables[311] > 0 # ブリーフ博士使用時
          @total_exp = (@total_exp*1.5).prec_i
        end
        
        #割り振りように経験値追加
        $game_variables[305] += @total_exp
        
        #text = "敵を倒して経験値" + @total_exp.to_s + "を得た！"
        #@msg_window.contents.draw_text( 0, 0, 400, MSG_ROW_SIZE, text)
        mozi = "テキをたおして　けいけんち　" + @total_exp.to_s + "　を　えた！"
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        @msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
        
        if $game_variables[311] > 1 # ブリーフ博士の効果ターン数表示
          mozi = "(ブリーフはかせの　こうか　のこり　" + ($game_variables[311]-1).to_s + "かい)"
          output_mozi mozi
          rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
          @msg_window.contents.blt(2 ,-2+1*32,$tec_mozi,rect)
        end
        @msg_window.update
        if $game_variables[38] == 0
          Graphics.wait(80)
        else
          Graphics.wait(10)
          @msg_cursor.visible = true
          input_loop_run
          #@msg_cursor.visible = false
          Graphics.wait(10)
        end
       if $game_variables[311] == 1 # ブリーフ博士の効果が終わったか表示
          @msg_window.contents.clear
          mozi = "ブリーフはかせの　こうかが　きれたぞ！"
          output_mozi mozi
          rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
          @msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
        
          @msg_window.update
          if $game_variables[38] == 0
            Graphics.wait(80)
          else
            Graphics.wait(10)
            @msg_cursor.visible = true
            input_loop_run
            #@msg_cursor.visible = false
            Graphics.wait(10)
          end
        end
        

        for y in 0..temp_full_party.size - 1 #経験値取得
          #if $chadead[y] == false || $chadead[y] == nil #死んでなければ経験値増加
            actorlevel = $game_actors[temp_full_party[y]].level
            temp_exp = get_exp_add temp_full_party[y],@total_exp.to_i
            $game_actors[temp_full_party[y]].change_exp($game_actors[temp_full_party[y]].exp + temp_exp,false)
            #$game_actors[temp_full_party[y]].change_exp($game_actors[temp_full_party[y]].exp + @total_exp.to_i,false)
            
            if actorlevel != $game_actors[temp_full_party[y]].level
              #Audio.se_play("Audio/SE/" +$BGM_levelup_se)
              run_common_event 188 #レベルアップSEを鳴らす(MEを使うかをコモンイベントで定義) 
              @status_window.contents.clear
              output_status
              @status_window.update
              @msg_window.contents.clear
              Graphics.update
              #text = $game_actors[temp_full_party[y]].name + "はレベル" + $game_actors[temp_full_party[y]].level.to_s + "になった！" 
              #@msg_window.contents.draw_text( 0, 0, 400, MSG_ROW_SIZE, text)
              mozi = chg_fc_mozi_tikan($game_actors[temp_full_party[y]].name)
              mozi = mozi + "　はレベル　" + $game_actors[temp_full_party[y]].level.to_s + "　になった！" 
              output_mozi mozi
              rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
              @msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
              if $game_variables[38] == 0
                Graphics.wait(80)
              else
                @msg_cursor.visible = true
                input_loop_run
                #@msg_cursor.visible = false
                Graphics.wait(5)
              end
            end
          #end
        end
        @msg_window.contents.clear
      end
      
      #CAP/SP取得
      if $game_variables[317] != 0 || $game_switches[124] == false
        
        #時の間ボス戦の場合
        @total_cap = $game_variables[317] if $game_variables[317] != 0
        
        if $game_variables[312] > 0 # 亀の甲羅使用時
          @total_cap = (@total_cap*1.5).prec_i
        end
        #text = "キャパシティ" + @total_cap.to_s + "を得た！"
        #@msg_window.contents.draw_text( 0, 0, 400, MSG_ROW_SIZE, text)
        mozi = "キャパシティ　" + @total_cap.to_s + "　を　えた！"
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        @msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
        if $game_variables[312] > 1 # 亀の甲羅の効果ターン数表示
          mozi = "(かめのこうらの　こうか　のこり　" + ($game_variables[312]-1).to_s + "かい)"
          output_mozi mozi
          rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
          @msg_window.contents.blt(2 ,-2+1*32,$tec_mozi,rect)
        end
        @msg_window.update
        if $game_variables[38] == 0
          Graphics.wait(80)
        else
          Graphics.wait(10)
          @msg_cursor.visible = true
          input_loop_run
          #@msg_cursor.visible = false
          Graphics.wait(10)
        end
        if $game_variables[312] == 1 # かめのこうらの効果が終わったか表示
          @msg_window.contents.clear
          mozi = "かめのこうらの　こうかが　きれたぞ！"
          output_mozi mozi
          rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
          @msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
        
          @msg_window.update
          if $game_variables[38] == 0
            Graphics.wait(80)
          else
            Graphics.wait(10)
            @msg_cursor.visible = true
            input_loop_run
            #@msg_cursor.visible = false
            Graphics.wait(10)
          end
        end
        $game_variables[25] +=@total_cap
        
        @msg_window.contents.clear
        
        #時の間ボス戦の場合
        @total_sp = $game_variables[318] if $game_variables[318] != 0
        if $game_variables[313] > 0 # 重い道着使用時
          @total_sp = (@total_sp*1.5).prec_i
        end
        #text = "スキルポイント" + @total_sp.to_s + "を得た！"
        #@msg_window.contents.draw_text( 0, 0, 400, MSG_ROW_SIZE, text)
        mozi = "スキルポイント　" + @total_sp.to_s + "　を　えた！"
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        @msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
        if $game_variables[313] > 1 # 亀の甲羅の効果ターン数表示
          mozi = "(おもいどうぎの　こうか　のこり　" + ($game_variables[313]-1).to_s + "かい)"
          output_mozi mozi
          rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
          @msg_window.contents.blt(2 ,-2+1*32,$tec_mozi,rect)
        end
        @msg_window.update
        if $game_variables[38] == 0
          Graphics.wait(80)
        else
          Graphics.wait(10)
          @msg_cursor.visible = true
          input_loop_run
          #@msg_cursor.visible = false
          Graphics.wait(10)
        end
        if $game_variables[313] == 1 # 重い道着の効果が終わったか表示
          @msg_window.contents.clear
          mozi = "おもいどうぎの　こうかが　きれたぞ！"
          output_mozi mozi
          rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
          @msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
        
          @msg_window.update
          if $game_variables[38] == 0
            Graphics.wait(80)
          else
            Graphics.wait(10)
            @msg_cursor.visible = true
            input_loop_run
            #@msg_cursor.visible = false
            Graphics.wait(10)
          end
        end
        for y in 0..temp_full_party.size - 1 #スキルポイント取得
          #if $chadead[y] == false || $chadead[y] == nil #死んでなければスキルポイント増加
            
            temp_sp = get_sp_add temp_full_party[y],@total_sp.to_i
            #空欄の時は0をセット
            $cha_typical_skill[temp_full_party[y]] = [0] if $cha_typical_skill[temp_full_party[y]] == nil
              
            for x in 0..$cha_typical_skill[temp_full_party[y]].size-1
              #==========================================================
              #固有スキル
              #==========================================================
              
              #空欄の時は0をセット
              $cha_typical_skill[temp_full_party[y]][x] = 0 if $cha_typical_skill[temp_full_party[y]][x] == nil
              
              $cha_skill_spval[temp_full_party[y]] = [0] if $cha_skill_spval[temp_full_party[y]] == nil
              $cha_skill_spval[temp_full_party[y]][$cha_typical_skill[temp_full_party[y]][x]] = 0 if $cha_skill_spval[temp_full_party[y]][$cha_typical_skill[temp_full_party[y]][x]] == nil
              #最大値未満なら経験値を増加する
              $cha_skill_spval[temp_full_party[y]][$cha_typical_skill[temp_full_party[y]][x]] += temp_sp if $cha_skill_spval[temp_full_party[y]][$cha_typical_skill[temp_full_party[y]][x]] < $cha_skill_get_val[$cha_typical_skill[temp_full_party[y]][x]]
              
              #最大値を超えたら最大値に調整し取得文字を表示する
              if $cha_skill_spval[temp_full_party[y]][$cha_typical_skill[temp_full_party[y]][x]] >= $cha_skill_get_val[$cha_typical_skill[temp_full_party[y]][x]] && $cha_skill_set_flag[temp_full_party[y]][$cha_typical_skill[temp_full_party[y]][x]] != 1
                $cha_skill_spval[temp_full_party[y]][$cha_typical_skill[temp_full_party[y]][x]] = $cha_skill_get_val[$cha_typical_skill[temp_full_party[y]][x]]
                #セットしたことがあることにする
                $cha_skill_set_flag[temp_full_party[y]][$cha_typical_skill[temp_full_party[y]][x]] = 1
                #取得したフラグをON
                $cha_skill_get_flag[temp_full_party[y]][$cha_typical_skill[temp_full_party[y]][x]] = 1
                #ハテナと空欄以外なら取得扱い
                if $cha_typical_skill[temp_full_party[y]][x] > 1
                  #Audio.se_play("Audio/SE/" +"Z3 レベルアップ")
                  #Audio.se_stop
                  #Audio.se_play("Audio/SE/" +"ZG 技取得")
                  Audio.se_play("Audio/SE/" +"DB2 アイテム取得")
                  @status_window.contents.clear
                  output_status
                  @status_window.update
                  @msg_window.contents.clear
                  Graphics.update
                  
                  #スキルの取得数とセット数 使わない予定だけど取得したか判断のため数は増やしておく
                  $skill_set_get_num = Array.new(2).map{Array.new(1,0)} if $skill_set_get_num == []
                  $skill_set_get_num[0][$cha_typical_skill[temp_full_party[y]][x]] = 0 if $skill_set_get_num[0][$cha_typical_skill[temp_full_party[y]][x]] == nil
                  $skill_set_get_num[1][$cha_typical_skill[temp_full_party[y]][x]] = 0 if $skill_set_get_num[1][$cha_typical_skill[temp_full_party[y]][x]] == nil
                  if $skill_set_get_num[1][$cha_typical_skill[temp_full_party[y]][x]] < $skill_get_max  
                    $skill_set_get_num[0][$cha_typical_skill[temp_full_party[y]][x]] += 1
                    $skill_set_get_num[1][$cha_typical_skill[temp_full_party[y]][x]] += 1
                  end
                  mozi1 = chg_fc_mozi_tikan($game_actors[temp_full_party[y]].name)
                  mozi2 = $cha_skill_mozi_set[$cha_typical_skill[temp_full_party[y]][x]]
                  mozi = mozi1 + "　はスキル　"# + mozi2 + "　をしゅとくした！" 
                  output_mozi mozi
                  rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
                  @msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
                  mozi = mozi2 + "　をしゅとくした！" 
                  output_mozi mozi
                  rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
                  @msg_window.contents.blt(2 ,-2+1*32,$tec_mozi,rect)
                  if $game_variables[38] == 0
                    Graphics.wait(80)
                  else
                    @msg_cursor.visible = true
                    input_loop_run
                    #@msg_cursor.visible = false
                    Graphics.wait(5)
                  end
                end
              end
            end
            

            #==========================================================
            #追加スキル
            #==========================================================
            skillget_flag = false
            skillget_no = []
            skillget_flag,skillget_no = get_cha_sp_run temp_full_party[y],temp_sp
            
            if skillget_flag == true
              for x in 0..skillget_no.size-1
                Audio.se_play("Audio/SE/" +"DB2 アイテム取得")
                @status_window.contents.clear
                output_status
                @status_window.update
                @msg_window.contents.clear
                Graphics.update
                mozi1 = chg_fc_mozi_tikan($game_actors[temp_full_party[y]].name)
                mozi2 = $cha_skill_mozi_set[skillget_no[x]]
                mozi = mozi1 + "　はスキル　"# + mozi2 + "　をしゅとくした！" 
                output_mozi mozi
                rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
                @msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
                mozi = mozi2 + "　をしゅとくした！" 
                output_mozi mozi
                rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
                @msg_window.contents.blt(2 ,-2+1*32,$tec_mozi,rect)
                if $game_variables[38] == 0
                  Graphics.wait(80)
                else
                  @msg_cursor.visible = true
                  input_loop_run
                  #@msg_cursor.visible = false
                  Graphics.wait(5)
                end
              end
            end
=begin
            #空欄の時は0をセット
            $cha_add_skill[temp_full_party[y]] = [0] if $cha_add_skill[temp_full_party[y]] == nil
            for x in 0..2#$cha_add_skill[temp_full_party[y]].size-1
              #処理スキルNo格納
              temp_skillno = $cha_add_skill[temp_full_party[y]][x]
              
              #空欄の時は0をセット
              temp_skillno = 0 if temp_skillno == nil
              $cha_skill_spval[temp_full_party[y]] = [0] if $cha_skill_spval[temp_full_party[y]] == nil
              $cha_skill_spval[temp_full_party[y]][temp_skillno] = 0 if $cha_skill_spval[temp_full_party[y]][temp_skillno] == nil
              
              #自分自身か次のスキル化をチェック
              run_nextskill = false
              #p $cha_skill_get_flag[temp_full_party[y]][temp_skillno],
              #$cha_add_lvup[temp_skillno],
              #$cha_skill_share[$cha_upgrade_skill_no[temp_skillno]]
              #p chk_run_next_add_skill temp_full_party[y],temp_skillno
              if chk_run_next_add_skill(temp_full_party[y],temp_skillno) == true
                #次のスキル
                temp_skillno = $cha_upgrade_skill_no[temp_skillno]
                run_nextskill = true
                #p temp_skillno,temp_full_party[y]
              end
              #最大値未満なら経験値を増加する(セットしているスキル)
              $cha_skill_spval[temp_full_party[y]][temp_skillno] += temp_sp if $cha_skill_spval[temp_full_party[y]][temp_skillno] < $cha_skill_get_val[temp_skillno]
              
              #最大値を超えたら最大値に調整する
              
              #取得フラグを初期化
              #$cha_skill_get_flag[temp_full_party[y]][temp_skillno] = 0 if $cha_skill_get_flag[temp_full_party[y]][temp_skillno] == nil
              
              
              #p $cha_skill_spval[temp_full_party[y]][temp_skillno] , $cha_skill_get_val[temp_skillno] , $cha_skill_get_flag[temp_full_party[y]][temp_skillno]
              if $cha_skill_spval[temp_full_party[y]][temp_skillno] >= $cha_skill_get_val[temp_skillno] && $cha_skill_get_flag[temp_full_party[y]][temp_skillno] != 1
                $cha_skill_spval[temp_full_party[y]][temp_skillno] = $cha_skill_get_val[temp_skillno]
                
                
                #セットしたことがあることにする
                $cha_skill_set_flag[temp_full_party[y]][temp_skillno] = 1
                
                #取得したフラグをON
                $cha_skill_get_flag[temp_full_party[y]][temp_skillno] = 1
                
                
                #ハテナと空欄以外なら取得扱い
                if temp_skillno > 1
                  #Audio.se_play("Audio/SE/" +"Z3 レベルアップ")
                  #Audio.se_stop
                  #Audio.se_play("Audio/SE/" +"ZG 技取得")
                  Audio.se_play("Audio/SE/" +"DB2 アイテム取得")
                  @status_window.contents.clear
                  output_status
                  @status_window.update
                  @msg_window.contents.clear
                  Graphics.update
                  
                  #スキルの取得数とセット数 使わない予定だけど取得したか判断のため数は増やしておく
                  $skill_set_get_num = Array.new(2).map{Array.new(1,0)} if $skill_set_get_num == []
                  $skill_set_get_num[0][temp_skillno] = 0 if $skill_set_get_num[0][temp_skillno] == nil
                  $skill_set_get_num[1][temp_skillno] = 0 if $skill_set_get_num[1][temp_skillno] == nil
                  if $skill_set_get_num[1][temp_skillno] < $skill_get_max  
                    $skill_set_get_num[0][temp_skillno] += 1 
                    $skill_set_get_num[1][temp_skillno] += 1 
                  end
                  
                  #次のスキルも取得する
                  
                  temp_skillno = temp_skillno
                  #p "スキル名：" + $cha_skill_mozi_set[temp_skillno].to_s,
                  #  "次のNo：" + $cha_upgrade_skill_no[temp_skillno].to_s,
                  #  "次のスキル名：" + $cha_skill_mozi_set[$cha_upgrade_skill_no[temp_skillno]].to_s,
                  ##  "追加スキルでレベルアップ：" + $cha_add_lvup[temp_skillno].to_s,
                  #  "共有スキル：" + $cha_skill_share[temp_skillno].to_s
                  #比較で注意"TRUE"としないと動かない
                  if chk_run_next_add_skill(temp_full_party[y],temp_skillno) == true
                    $skill_set_get_num[0][$cha_upgrade_skill_no[temp_skillno]] = 1
                    $skill_set_get_num[1][$cha_upgrade_skill_no[temp_skillno]] = 1
                    #セットしたことがあることにする
                    $cha_skill_set_flag[temp_full_party[y]][$cha_upgrade_skill_no[temp_skillno]] = 1
                  end
                  
                  mozi1 = chg_fc_mozi_tikan($game_actors[temp_full_party[y]].name)
                  mozi2 = $cha_skill_mozi_set[temp_skillno]
                  mozi = mozi1 + "　はスキル　"# + mozi2 + "　をしゅとくした！" 
                  output_mozi mozi
                  rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
                  @msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
                  mozi = mozi2 + "　をしゅとくした！" 
                  output_mozi mozi
                  rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
                  @msg_window.contents.blt(2 ,-2+1*32,$tec_mozi,rect)
                  if $game_variables[38] == 0
                    Graphics.wait(80)
                  else
                    @msg_cursor.visible = true
                    input_loop_run
                    #@msg_cursor.visible = false
                    Graphics.wait(5)
                  end
                  
                  #上限値を超えた値がセットされるバグ対策で念のためここでも処理しておく
                  if $cha_skill_spval[temp_full_party[y]][$cha_add_skill[temp_full_party[y]][x]] >= $cha_skill_get_val[$cha_add_skill[temp_full_party[y]][x]]
                    $cha_skill_spval[temp_full_party[y]][$cha_add_skill[temp_full_party[y]][x]] = $cha_skill_get_val[$cha_add_skill[temp_full_party[y]][x]]
                    
                    #セットしたことがあることにする
                    $cha_skill_set_flag[temp_full_party[y]][$cha_add_skill[temp_full_party[y]][x]] = 1
                    
                    #取得したフラグをON
                    $cha_skill_get_flag[temp_full_party[y]][$cha_add_skill[temp_full_party[y]][x]] = 1
                    
                  end
                  
                  #もし次レベルのスキルなら次のレベルのスキルをセットする
                  if run_nextskill == true
                    $cha_add_skill[temp_full_party[y]][x] = temp_skillno
                    
                  end
                end
                

              end
              
              #,$cha_skill_spval[temp_full_party[y]][$cha_add_skill[temp_full_party[y]][x]],$cha_skill_get_val[$cha_add_skill[temp_full_party[y]][x]]
              #p temp_full_party[y],$cha_add_skill[temp_full_party[y]][x],$cha_skill_spval[temp_full_party[y]][$cha_add_skill[temp_full_party[y]][x]],$cha_skill_get_val[$cha_add_skill[temp_full_party[y]][x]]
              
            
            end
=end
            #固有スキル
            get_skill_no = get_typical_skill temp_full_party[y]
            #p get_skill_no
            if get_skill_no[0].length != 0
              for x in 0..get_skill_no[0].length - 1
                
                @msg_window.contents.clear
                Graphics.update
                mozi1 = chg_fc_mozi_tikan($game_actors[temp_full_party[y]].name)
                mozi2 = $cha_skill_mozi_set[get_skill_no[0][x]]
                mozi = mozi1 + "　はスキル　"# + mozi2 + "　をしゅとくした！"
                output_mozi mozi
                rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
                @msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
                
                if get_skill_no[1][x] == $getnewskill_no
                  mozi = mozi2 + "　がセットされた！" 
                  Audio.se_play("Audio/SE/" +"ZG 技取得")
                  
                else
                  mozi = mozi2 + "　をしゅとくした！" 
                  #Audio.se_play("Audio/SE/" +"Z3 レベルアップ")
                  Audio.se_play("Audio/SE/" +"DB2 アイテム取得")
                  $cha_skill_spval[temp_full_party[y]][get_skill_no[2][x]] = $cha_skill_get_val[get_skill_no[2][x]]
                  $cha_skill_spval[temp_full_party[y]][get_skill_no[0][x]] = $cha_skill_get_val[get_skill_no[0][x]]
                  if $skill_set_get_num[1][get_skill_no[0][x]] < $skill_get_max  
                    $skill_set_get_num[0][get_skill_no[0][x]] += 1
                    $skill_set_get_num[1][get_skill_no[0][x]] += 1
                  end
                  #セットしたことがあることにする
                  $cha_skill_set_flag[temp_full_party[y]][get_skill_no[0][x]] = 1
                  $cha_skill_get_flag[temp_full_party[y]][get_skill_no[0][x]] = 1
                end
                $cha_typical_skill[temp_full_party[y]][get_skill_no[2][x]] = get_skill_no[0][x]
                output_mozi mozi
                rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
                @msg_window.contents.blt(2 ,-2+1*32,$tec_mozi,rect)
                if $game_variables[38] == 0
                  Graphics.wait(80)
                else
                  @msg_cursor.visible = true
                  input_loop_run
                  #@msg_cursor.visible = false
                  Graphics.wait(5)
                end
              end
            end
          end
        #end
      end
      
      #カード取得
      get_item_card if $game_switches[122] == false || $game_switches[477] == true

      #ウルフハリケーンを覚える
      #新狼牙風風拳を覚えたときに発生
      if $game_switches[609] == true && $game_switches[702] == false
        $game_switches[702] = true
        @msg_window.contents.clear
        Graphics.update
        Audio.se_play("Audio/SE/" +"DB3 狼牙風風拳")
        mozi = "なんと！？　ヤムチャが　うたを　うたいはじめた！"
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        @msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
        if $game_variables[38] == 0
          Graphics.wait(80)
        else
          @msg_cursor.visible = true
          input_loop_run
          #@msg_cursor.visible = false
          Graphics.wait(5)
        end
        Graphics.update
        Audio.se_play("Audio/SE/" +"Z3 アイテム取得")
        #mozi = "オプションで　ウルフハリケーンが　ついかされたぞ！"
        mozi = "オプションの　バトル／バトルまえBGMに"
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        @msg_window.contents.blt(2 ,-2+1*32,$tec_mozi,rect)
        mozi = "ウルフハリケーンが　ついかされたぞ！！"
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        @msg_window.contents.blt(2 ,-2+2*32,$tec_mozi,rect)
        if $game_variables[38] == 0
          Graphics.wait(80)
        else
          @msg_cursor.visible = true
          input_loop_run
          #@msg_cursor.visible = false
          Graphics.wait(5)
        end
      end
      
      my_terminate
      @@battle_main_result = 2
    end
  end

  #--------------------------------------------------------------------------
  # ● 戦闘開始確認
  #--------------------------------------------------------------------------  
  def chk_battle_start
    if @@card_set_count == @battle_cha_num || @@card_set_count == $Cardmaxnum + 1 then #戦闘開始
      $WinState = 0
      $chadeadchk = Marshal.load(Marshal.dump($chadead))
      $enedeadchk = Marshal.load(Marshal.dump($enedead))
      $eneselfdeadchk = Marshal.load(Marshal.dump($enedead))
      @@battle_main_result = 1
    end
  end
  #--------------------------------------------------------------------------
  # ● 攻撃順設定
  #--------------------------------------------------------------------------  
  def set_attack_order
    $attack_order = [nil]
    @@chk_attack_order = [nil]
    for x in 0..5+$battleenenum #使用されたカードをセット
      #$cardset_cha_no = [99,99,99,99,99,99]
      if x < 6 #6を超えたら敵のカードをセット
        if $cardset_cha_no[x] != 99 
          @@chk_attack_order[x] = [x,$carda[x] + $cardg[x]]
        end
      else
        @@chk_attack_order[x] = [10+x-6,$enecarda[x-6] + $enecardg[x-6]]
      end
    
    end
    
    @@chk_attack_order.compact! #配列nil削除
    @@chk_attack_order.sort! {|x, y| y[1] <=> x[1]} #配列ソート
    for x in 0..@@chk_attack_order.size-1
      
      $attack_order[x] = @@chk_attack_order[x].join(',') #配列書式から文字列へ
      $attack_order[x] = $attack_order[x][0,$attack_order[x].index(",")].to_i #配列の前の部分のみ取得
      #$attack_order[x]
    end
  end

  #--------------------------------------------------------------------------
  # ● 戦闘前曲再生
  #--------------------------------------------------------------------------    
  def set_battle_ready_bgm
    
    #if $put_battle_bgm == false
    #  set_battle_bgm_name true
      mode = 0
      #イベント戦の取得をするか？
      if $game_laps >= 1 && $battle_escape == false
        mode = 1
      end
      set_battle_ready_bgm_name false,mode
      if $option_battle_ready_bgm_name.include?("_user") == false
        Audio.bgm_play("Audio/BGM/" + $option_battle_ready_bgm_name)    # 効果音を再生する
      else
        Audio.bgm_play("Audio/MYBGM/" + $option_battle_ready_bgm_name)    # 効果音を再生する
      end
      #Audio.bgm_play("Audio/BGM/Z1 戦闘前")
      #$put_battle_bgm = false
    #  $put_battle_bgm = true
    #end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘曲再生
  #--------------------------------------------------------------------------    
  def set_battle_bgm
    
    if $put_battle_bgm == false
      if $battle_escape == true
        set_battle_bgm_name true
      else
        #逃げられないのはイベント戦判定にする。
        set_battle_bgm_name true,1
      end
      
      if $battle_escape == true
        if $option_battle_bgm_name.include?("_user") == false
          Audio.bgm_play("Audio/BGM/" + $option_battle_bgm_name)    # 効果音を再生する
        else
          Audio.bgm_play("Audio/MYBGM/" + $option_battle_bgm_name)    # 効果音を再生する
        end
      else
        if $option_evbattle_bgm_name.include?("_user") == false
          Audio.bgm_play("Audio/BGM/" + $option_evbattle_bgm_name)    # 効果音を再生する
        else
          Audio.bgm_play("Audio/MYBGM/" + $option_evbattle_bgm_name)    # 効果音を再生する
        end
      end

      $put_battle_bgm = true
    end
  end
  #--------------------------------------------------------------------------
  # ● カード取得処理
  #--------------------------------------------------------------------------  
  def get_item_card
    
    get_card = []   #取得カードNo
    text1 = ""      #取得カード表示1行目
    text2 = ""      #取得カード表示2行目
    text3 = ""      #取得カード表示3行目
    text_flag = 1   #取得カード処理行数フラグ
    
    #アイテムカード取得処理
    
    if $game_switches[477] != true
      for y in 0..$battleenenum - 1 #通常取得
        #カード取得状態初期化
        $ene_crd_history_flag[$battleenemy[y.to_i]] = 0 if $ene_crd_history_flag[$battleenemy[y.to_i]] == nil
        if $data_enemies[$battleenemy[y.to_i]].drop_item1.kind == 1
          
          #ドラゴンボールを取得しない
          if $data_enemies[$battleenemy[y.to_i]].drop_item1.item_id > 8 || $game_switches[126] == false
            if 0 == rand($data_enemies[$battleenemy[y.to_i]].drop_item1.denominator)
              get_card << $data_enemies[$battleenemy[y.to_i]].drop_item1.item_id
              
              #カード取得フラグ
              if $ene_crd_history_flag[$battleenemy[y.to_i]] == 0 || $ene_crd_history_flag[$battleenemy[y.to_i]] == 2
                $ene_crd_history_flag[$battleenemy[y.to_i]] += 1 
              end
            end
          end
        end
        
        if $data_enemies[$battleenemy[y.to_i]].drop_item2.kind == 1
          #ドラゴンボールを取得しない
          if $data_enemies[$battleenemy[y.to_i]].drop_item2.item_id > 8 || $game_switches[126] == false
            
            drop_proba = get_card_drop_add $data_enemies[$battleenemy[y.to_i]].drop_item2.denominator
            #p $data_enemies[$battleenemy[y.to_i]].drop_item2.denominator,drop_proba
            #if 0 == rand($data_enemies[$battleenemy[y.to_i]].drop_item2.denominator)
            if 0 == rand(drop_proba)
              get_card << $data_enemies[$battleenemy[y.to_i]].drop_item2.item_id
              #カード取得フラグ
              if $ene_crd_history_flag[$battleenemy[y.to_i]] == 0 || $ene_crd_history_flag[$battleenemy[y.to_i]] == 1
                $ene_crd_history_flag[$battleenemy[y.to_i]] += 2 
              end
            end
          end
        end      
      end
    else #時の間取得
      
      #取得カード1
      card_dropritu = 241
      card_kind = 246
      if $game_variables[card_kind] != 0 
        if $game_variables[card_dropritu] >= rand(100)
          get_card << $game_variables[card_kind]
        end
      end
      
      #取得カード2
      card_dropritu = 242
      card_kind = 247
      if $game_variables[card_kind] != 0 
        if $game_variables[card_dropritu] >= rand(100)
          get_card << $game_variables[card_kind]
        end
      end
      
      #取得カード3
      card_dropritu = 243
      card_kind = 248
      if $game_variables[card_kind] != 0 
        if $game_variables[card_dropritu] >= rand(100)
          get_card << $game_variables[card_kind]
        end
      end
      
      #取得カード4
      card_dropritu = 244
      card_kind = 249
      if $game_variables[card_kind] != 0 
        if $game_variables[card_dropritu] >= rand(100)
          get_card << $game_variables[card_kind]
        end
      end
      
      #取得カード5
      card_dropritu = 245
      card_kind = 250
      if $game_variables[card_kind] != 0 
        if $game_variables[card_dropritu] >= rand(100)
          get_card << $game_variables[card_kind]
        end
      end
    end
    
    #アイテムカードを取得したら増加処理と表示処理へ
    if get_card.size > 0
      for x in 0..get_card.size - 1
        
        
        #アイテムカード増加 最大数以上は持てないように
        #しようと思ったけどアイテムカード表示時に調整することにする
        #if $game_party.item_number($data_items[get_card[x]]) < $max_item_card_num
        $game_party.gain_item ($data_items[get_card[x]], 1) #カード増やす
        #end
        
        #文字数が最大数を超えたら次の行へ
        if text_flag == 1 && text1.split(//u).size + $data_items[get_card[x]].name.split(//u).size + 1 >= 27#30
          text_flag = 2
        elsif text_flag == 2 && text2.split(//u).size + $data_items[get_card[x]].name.split(//u).size + 1 >= 27#30
          text_flag = 3
        end
        
        #対象の行へアイテムカード名を格納
        if text_flag == 1
          text1 += $data_items[get_card[x]].name + "　"
        elsif text_flag == 2
          #取得カード多すぎた場合は　ほか　と表示
          #if text2.split(//u).size + $data_items[get_card[x]].name.split(//u).size + 1 >= 24
            #text2 += "　ほか"
          #else
            text2 += $data_items[get_card[x]].name + "　"
          #end
        elsif text_flag == 3
          text3 += $data_items[get_card[x]].name + "　"
        end
      end
    @msg_window.contents.clear
  
    Audio.se_play("Audio/SE/" +"Z1 アイテム取得")
    mozi = "いかの　おたすけカードを　てにいれた！"
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
    mozi = text1
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @msg_window.contents.blt(2 ,-2+1*32,$tec_mozi,rect)
    mozi = text2
    output_mozi mozi
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    @msg_window.contents.blt(2 ,-2+2*32,$tec_mozi,rect)
    
    #@msg_window.contents.draw_text( 0, 0, 500, MSG_ROW_SIZE, "以下の　お助けカードを　手に入れた！")
    #@msg_window.contents.draw_text( 0, 22, 500, MSG_ROW_SIZE, text1)
    #@msg_window.contents.draw_text( 0, 44, 500, MSG_ROW_SIZE, text2)
    #@msg_window.contents.draw_text( 0, 66, 500, MSG_ROW_SIZE, text3)
    Graphics.update
    if $game_variables[38] == 0
      Graphics.wait(90)
    else
      @msg_cursor.visible = true
      input_loop_run
      #取得カードが多い場合は2ページに別ける
      if text_flag == 3
        @msg_window.contents.clear
        mozi = text3
        output_mozi mozi
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        @msg_window.contents.blt(2 ,-2+0*32,$tec_mozi,rect)
        input_loop_run
      end
      #@msg_cursor.visible = false
    end
    end

  end
  #--------------------------------------------------------------------------
  # ● 必殺技表示
  # 　 カーソル上キャラのスキル一覧を取得する。(表示の詳細は"_detail")
  #-------------------------------------------------------------------------- 
  def output_technique #必殺技表示
    if @technique_window != nil
      @technique_window.contents.clear
    end
    
    picture = Cache.picture("メニュー文字関係")
    rect = Rect.new(0, 312, 112, 20)
    tyousei_y = 8
    @technique_window.contents.blt(Techniquex,Techniquey,picture,rect)
    if @display_skill_level == -1 #使用気表示
      rect = Rect.new(0, 336, 112, 20)
      @technique_window.contents.blt(Techniquex+164+16,Techniquey,picture,rect)
    else #技使用回数表示
      
      rect = Rect.new(0, 356, 112, 20)
      @technique_window.contents.blt(Techniquex+176+16,Techniquey,picture,rect)
    end
    
    tecput_page_strat = @tecput_page * @tecput_max
    
    if $game_actors[$partyc[@@battle_cha_cursor_state]].skills.size - 1 < (@tecput_page + 1) * @tecput_max
      tecput_end = $game_actors[$partyc[@@battle_cha_cursor_state]].skills.size - 1
    else
      tecput_end = @tecput_max - 1
    end
    
    if $WinState == 6
      if $game_actors[$partyc[@@battle_cha_cursor_state]].skills.size > (@tecput_page + 1) * @tecput_max
        @down_cursor.visible = true
      else
        @down_cursor.visible = false
      end
      
      if @tecput_page > 0
        @up_cursor.visible = true
      else
        @up_cursor.visible = false
      end
    end
    for x in tecput_page_strat..tecput_end
      rect = output_technique_detail $game_actors[$partyc[@@battle_cha_cursor_state]].skills[x].id
      #rect = output_technique_detail @@battle_cha_cursor_state,x
      #picture = Cache.picture("文字_必殺技")
      picture = $tec_mozi
      @technique_window.contents.blt(Techniquex,Techniquey+24+Techniquenamey * (x-tecput_page_strat)+tyousei_y,picture,rect)
      picture = Cache.picture("数字英語")
      if @display_skill_level == -1 #使用気表示
        tec_mp_cost = get_mp_cost $partyc[@@battle_cha_cursor_state],$game_actors[$partyc[@@battle_cha_cursor_state]].skills[x].id,0
        for y in 1..tec_mp_cost.to_s.size #KI消費量
        #for y in 1..$game_actors[$partyc[@@battle_cha_cursor_state]].skills[x].mp_cost.to_s.size #KI消費量
        rect = Rect.new(tec_mp_cost.to_s[-y,1].to_i*16, 0, 16, 16)
          #rect = Rect.new($game_actors[$partyc[@@battle_cha_cursor_state]].skills[x].mp_cost.to_s[-y,1].to_i*16, 0, 16, 16)
          @technique_window.contents.blt(Techniquex+226-(y-1)*16+16,Techniquey+32+Techniquenamey * (x-tecput_page_strat)+tyousei_y,picture,rect)
        end
      else
        if $cha_skill_level[$game_actors[$partyc[@@battle_cha_cursor_state]].skills[x].id] == nil
          $cha_skill_level[$game_actors[$partyc[@@battle_cha_cursor_state]].skills[x].id] = 0
        end
        for y in 1..$cha_skill_level[$game_actors[$partyc[@@battle_cha_cursor_state]].skills[x].id].to_s.size #回数
          if $cha_skill_level[$game_actors[$partyc[@@battle_cha_cursor_state]].skills[x].id].to_s.size < 5
            #4桁以内
            rect = Rect.new($cha_skill_level[$game_actors[$partyc[@@battle_cha_cursor_state]].skills[x].id].to_s[-y,1].to_i*16, 0, 16, 16)
            @technique_window.contents.blt(Techniquex+226-(y-1)*16+16,Techniquey+32+Techniquenamey * (x-tecput_page_strat)+tyousei_y,picture,rect)
          else
            #5桁
            
            case y
            
            when 1..2
              rect = Rect.new($cha_skill_level[$game_actors[$partyc[@@battle_cha_cursor_state]].skills[x].id].to_s[-y,1].to_i*8, 168, 8, 16)
              @technique_window.contents.blt(Techniquex+226-(y-1)*8+16+8,Techniquey+32+Techniquenamey * (x-tecput_page_strat)+tyousei_y,picture,rect)
            else
              rect = Rect.new($cha_skill_level[$game_actors[$partyc[@@battle_cha_cursor_state]].skills[x].id].to_s[-y,1].to_i*16, 0, 16, 16)
              @technique_window.contents.blt(Techniquex+226-(y-1)*16+16+16,Techniquey+32+Techniquenamey * (x-tecput_page_strat)+tyousei_y,picture,rect)
            end
          end
        end
      end
    end
    
    #必殺技ヘルプも更新する
    output_tec_help 
    
    @tecwinupdate_flag = false
  end
  #--------------------------------------------------------------------------
  # ● 必殺技ヘルプ表示
  # 　 カーソル上キャラのスキル一覧を取得する。(表示の詳細は"_detail")
  #-------------------------------------------------------------------------- 
  def output_tec_help #必殺技表示
    if @tec_help_window != nil
      @tec_help_window.contents.clear
    end
    
    tyouseiy = -4
    tyouseix = 16
    #発動条件を満たしている or 可能性のあるSコンボ
    get_scombono = []
    #チェック結果の詳細
    get_result = []
    #Sコンボ行
    get_scomborow = []

    #出力行数
    put_liney = 0
    
    #追加効果カウント
    put_add_effect_num = 0
    
    #追加効果出力文字
    put_add_effect_mozi = ""
    
    #選択している必殺技ID
    sel_tecid = $game_actors[$partyc[@@battle_cha_cursor_state]].skills[$MenuCursorState+@tecput_page*@tecput_max].id
    
    put_kanashibari_flag = false #%の追加の文言を切替用
    
    #追加効果タイトル
    mozi = "・ついかこうか"
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    output_mozi mozi
    @tec_help_window.contents.blt(0,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
    put_liney += 1
    
    #追加効果一覧を表示
    
    #必中
    if $data_skills[sel_tecid].element_set.index(29) != nil
      put_add_effect_num += 1
      #put_add_effect_mozi += "／" if put_add_effect_mozi != ""
      mozi = "ひっちゅう"
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @tec_help_window.contents.blt(tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1
    end
    
    #超能力
    if $data_skills[sel_tecid].element_set.index(12) != nil
      put_add_effect_num += 1
      #mozi = "ちょうのうりょく"
      mozi = "かなしばり"
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @tec_help_window.contents.blt(tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1
      
      put_add_effect_num += 1
      #mozi = "ちょうのうりょく"
      mozi = "りゅうはいっちでさらにかなしばり"
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @tec_help_window.contents.blt(tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1
      put_kanashibari_flag = true
    end
        
    #太陽拳
    if $data_skills[sel_tecid].element_set.index(14) != nil
      put_add_effect_num += 1
      #mozi = "たいようけん"
      mozi = "かなしばり"
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @tec_help_window.contents.blt(tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1

      put_add_effect_num += 1
      #mozi = "ちょうのうりょく"
      mozi = "りゅうはいっちでさらにかなしばり"
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @tec_help_window.contents.blt(tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1
      put_kanashibari_flag = true
    end
    
    #流派一致で超能力
    if $data_skills[sel_tecid].element_set.index(13) != nil
      put_add_effect_num += 1
      #mozi = "りゅうはいっちでうごきをとめる"
      mozi = "りゅうはいっちでかなしばり"
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @tec_help_window.contents.blt(tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1
      put_kanashibari_flag = true
    end
    
    #一定確率でかなしばり
    if $data_skills[sel_tecid].element_set.index(61) != nil
      put_add_effect_num += 1
      if put_kanashibari_flag == true
        mozi = $data_skills[sel_tecid].variance.to_s + "％でさらにかなしばり"
      else
        mozi = $data_skills[sel_tecid].variance.to_s + "％でかなしばり"
      end
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @tec_help_window.contents.blt(tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1
      
      put_kanashibari_flag = true
    end
    
    #尻尾を切る
    if $data_skills[sel_tecid].element_set.index(25) != nil
      put_add_effect_num += 1
      mozi = "しっぽをきる"
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @tec_help_window.contents.blt(tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1
    end
    
    #追加効果がない場合はなしを出力
    if put_add_effect_num == 0
      mozi = "なし"
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @tec_help_window.contents.blt(tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1
    end
    
    #追加効果との間に位置行あける
    #put_liney += 1
    
    #Sコンボタイトル
    mozi = "・Sコンボ"
    rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
    output_mozi mozi
    @tec_help_window.contents.blt(0,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
    put_liney += 1
    
    if $cardi[$CardCursorState] != $game_actors[$partyc[@@battle_cha_cursor_state]].class_id-1
      mozi = "りゅうはがいっちしてないぞ！"
      rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
      output_mozi mozi
      @tec_help_window.contents.blt(tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
      put_liney += 1
    else
      #パーティー内で発動できるSコンボを取得
      get_scombono,get_result,get_scomborow = get_tec_scombo sel_tecid,0
      
      #1つでも取得したか
      if get_scombono.size > 0
        for x in 0..get_scombono.size - 1
          rect = output_technique_detail get_scombono[x]
          
          if get_result[x] == 1 #発動可能
            $tec_mozi.change_tone(255,120,48) #流派一致と同じ色
            
          elsif get_result[x] == 7 #他のキャラが条件を満たしていない
            $tec_mozi.change_tone(255,255,255) #白
          elsif get_result[x] == 9 #自分の星の数が足りない
            $tec_mozi.change_tone(128,128,128) #灰色


          else #発動の可能性あり
            $tec_mozi.change_tone(0,0,0) #黒
          end
          picture = $tec_mozi
          @tec_help_window.contents.blt(tyouseix,tyouseiy + put_liney*Techniquenamey,picture,rect)

          #自分の星が足りないときは必要な星の数を表示する
          #表示幅が足りないからボツ

          if get_result[x] == 9 
            #攻防の星
            mozi = ($scombo_card_attack_num[get_scomborow[x]][$scombo_cha[get_scomborow[x]].index($partyc[@@battle_cha_cursor_state])] + 1).to_s + 
            "：" +
            ($scombo_card_gard_num[get_scomborow[x]][$scombo_cha[get_scomborow[x]].index($partyc[@@battle_cha_cursor_state])] + 1).to_s
            rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
            output_mozi mozi
            $tec_mozi.change_tone(128,128,128) #灰色
            @tec_help_window.contents.blt(16*15 + 12,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
          end

          put_liney += 1
        end
      else
        mozi = "はつどうできるSコンボはないぞ！"
        rect = Rect.new(16*0,16*0, 16*mozi.split(//u).size,24)
        output_mozi mozi
        @tec_help_window.contents.blt(tyouseix,tyouseiy + put_liney*Techniquenamey,$tec_mozi,rect)
        put_liney += 1

      end
    end
    #テストで必殺技名を表示する
    #rect = output_technique_detail $game_actors[$partyc[@@battle_cha_cursor_state]].skills[$MenuCursorState+@tecput_page*@tecput_max].id
  
    #picture = $tec_mozi
    #@tec_help_window.contents.blt(0,tyouseiy + put_liney*Techniquenamey,picture,rect)
    #put_liney += 1
    
    
    
  end
  #--------------------------------------------------------------------------
  # ● 対象の必殺技のSコンボを取得する
  # set_action:対象の必殺技, mode:0:パーティー内で使用可能なもの
  #-------------------------------------------------------------------------- 
  def get_tec_scombo set_action,mode = 0
    
    tmp_scombo_renban = Marshal.load(Marshal.dump($scombo_renban))
    tmp_scombo_count = Marshal.load(Marshal.dump($scombo_count))
    tmp_scombo_cha_count = Marshal.load(Marshal.dump($scombo_cha_count))
    tmp_scombo_get_flag = Marshal.load(Marshal.dump($scombo_get_flag))
    tmp_scombo_new_flag = Marshal.load(Marshal.dump($scombo_new_flag))
    tmp_scombo_no = Marshal.load(Marshal.dump($scombo_no))
    tmp_scombo_cha = Marshal.load(Marshal.dump($scombo_cha))
    tmp_scombo_flag_tec = Marshal.load(Marshal.dump($scombo_flag_tec))
    tmp_scombo_skill_level_num = Marshal.load(Marshal.dump($scombo_skill_level_num))
    tmp_scombo_card_attack_num = Marshal.load(Marshal.dump($scombo_card_attack_num))
    tmp_scombo_card_gard_num = Marshal.load(Marshal.dump($scombo_card_gard_num))
    tmp_scombo_chk_flag_oozaru_put = Marshal.load(Marshal.dump($scombo_chk_flag_oozaru_put))
    
    tmp_scombo_chk_flag_ssaiya = Marshal.load(Marshal.dump($scombo_chk_flag_ssaiya))
    tmp_scombo_chk_flag_ssaiya_cha = Marshal.load(Marshal.dump($scombo_chk_flag_ssaiya_cha))
    tmp_scombo_chk_flag_ssaiya_put = Marshal.load(Marshal.dump($scombo_chk_flag_ssaiya_put))
    
    #Sコンボの並びを自分で変えるときだけ処理する
    if $game_variables[358] == 1
      #処理用に再格納
      ttmp_scombo_renban = Marshal.load(Marshal.dump($scombo_renban))
      ttmp_scombo_count = Marshal.load(Marshal.dump($scombo_count))
      ttmp_scombo_cha_count = Marshal.load(Marshal.dump($scombo_cha_count))
      ttmp_scombo_get_flag = Marshal.load(Marshal.dump($scombo_get_flag))
      ttmp_scombo_new_flag = Marshal.load(Marshal.dump($scombo_new_flag))
      ttmp_scombo_no = Marshal.load(Marshal.dump($scombo_no))
      ttmp_scombo_cha = Marshal.load(Marshal.dump($scombo_cha))
      ttmp_scombo_flag_tec = Marshal.load(Marshal.dump($scombo_flag_tec))
      ttmp_scombo_skill_level_num = Marshal.load(Marshal.dump($scombo_skill_level_num))
      ttmp_scombo_card_attack_num = Marshal.load(Marshal.dump($scombo_card_attack_num))
      ttmp_scombo_card_gard_num = Marshal.load(Marshal.dump($scombo_card_gard_num))
      ttmp_scombo_chk_flag_oozaru_put = Marshal.load(Marshal.dump($scombo_chk_flag_oozaru_put))
      
      ttmp_scombo_chk_flag_ssaiya = Marshal.load(Marshal.dump($scombo_chk_flag_ssaiya))
      ttmp_scombo_chk_flag_ssaiya_cha = Marshal.load(Marshal.dump($scombo_chk_flag_ssaiya_cha))
      ttmp_scombo_chk_flag_ssaiya_put = Marshal.load(Marshal.dump($scombo_chk_flag_ssaiya_put))
      
      #Sコンボが一つもないかどうかで処理を変える
      if $player_scombo_priority[$partyc[@@battle_cha_cursor_state]] == nil
        scomsize = 0
      else
        scomsize = $player_scombo_priority[$partyc[@@battle_cha_cursor_state]].size
      end
      
      #配列系はサイズを縮める
      tmp_scombo_count = scomsize - 1
      tmp_scombo_renban = tmp_scombo_renban[0..scomsize - 1]
      tmp_scombo_cha_count = tmp_scombo_cha_count[0..scomsize - 1]
      tmp_scombo_get_flag = tmp_scombo_get_flag[0..scomsize - 1]
      tmp_scombo_new_flag = tmp_scombo_new_flag[0..scomsize - 1]
      tmp_scombo_no = tmp_scombo_no[0..scomsize - 1]
      tmp_scombo_cha = tmp_scombo_cha[0..scomsize - 1]
      tmp_scombo_flag_tec = tmp_scombo_flag_tec[0..scomsize - 1]
      tmp_scombo_skill_level_num = tmp_scombo_skill_level_num[0..scomsize - 1]
      tmp_scombo_card_attack_num = tmp_scombo_card_attack_num[0..scomsize - 1]
      tmp_scombo_card_gard_num = tmp_scombo_card_gard_num[0..scomsize - 1]
      tmp_scombo_chk_flag_oozaru_put = tmp_scombo_chk_flag_oozaru_put[0..scomsize - 1]
      
      tmp_scombo_chk_flag_ssaiya = tmp_scombo_chk_flag_ssaiya[0..scomsize - 1]
      tmp_scombo_chk_flag_ssaiya_cha = tmp_scombo_chk_flag_ssaiya_cha[0..scomsize - 1]
      tmp_scombo_chk_flag_ssaiya_put = tmp_scombo_chk_flag_ssaiya_put[0..scomsize - 1]
      
      #初期化 
      for x in 0..scomsize - 1
        tmp_scombo_renban[x] = ttmp_scombo_renban[$player_scombo_priority[$partyc[@@battle_cha_cursor_state]][x]]
        tmp_scombo_cha_count[x] = ttmp_scombo_cha_count[$player_scombo_priority[$partyc[@@battle_cha_cursor_state]][x]]
        tmp_scombo_get_flag[x] = ttmp_scombo_get_flag[$player_scombo_priority[$partyc[@@battle_cha_cursor_state]][x]]
        tmp_scombo_new_flag[x] = ttmp_scombo_new_flag[$player_scombo_priority[$partyc[@@battle_cha_cursor_state]][x]]
        
        tmp_scombo_no[x] = ttmp_scombo_no[$player_scombo_priority[$partyc[@@battle_cha_cursor_state]][x]]
        tmp_scombo_cha[x] = ttmp_scombo_cha[$player_scombo_priority[$partyc[@@battle_cha_cursor_state]][x]]
        tmp_scombo_flag_tec[x] = ttmp_scombo_flag_tec[$player_scombo_priority[$partyc[@@battle_cha_cursor_state]][x]]
        tmp_scombo_skill_level_num[x] = ttmp_scombo_skill_level_num[$player_scombo_priority[$partyc[@@battle_cha_cursor_state]][x]]
        tmp_scombo_card_attack_num[x] = ttmp_scombo_card_attack_num[$player_scombo_priority[$partyc[@@battle_cha_cursor_state]][x]]
        tmp_scombo_card_gard_num[x] = ttmp_scombo_card_gard_num[$player_scombo_priority[$partyc[@@battle_cha_cursor_state]][x]]
        tmp_scombo_chk_flag_oozaru_put[x] = ttmp_scombo_chk_flag_oozaru_put[$player_scombo_priority[$partyc[@@battle_cha_cursor_state]][x]]
        
        tmp_scombo_chk_flag_ssaiya[x] = ttmp_scombo_chk_flag_ssaiya[$player_scombo_priority[$partyc[@@battle_cha_cursor_state]][x]]
        tmp_scombo_chk_flag_ssaiya_cha[x] = ttmp_scombo_chk_flag_ssaiya_cha[$player_scombo_priority[$partyc[@@battle_cha_cursor_state]][x]]
        tmp_scombo_chk_flag_ssaiya_put[x] = ttmp_scombo_chk_flag_ssaiya_put[$player_scombo_priority[$partyc[@@battle_cha_cursor_state]][x]]
      end
        
      #p tmp_scombo_no,$player_scombo_priority[$partyc[@@battle_cha_cursor_state]]
    end
    x = 0
    
    #発動条件を満たしている or 可能性のあるSコンボ
    get_scombono = []
    #チェック結果の詳細
    get_result = []
    #Sコンボ行
    get_scomborow = []
    
    case mode
    
    when 0 #パーティー内で使用可能なもの

      #Sコンボ分ループ
      for x in 0..tmp_scombo_count
        
        chk_loop_result = tmp_scombo_flag_tec[x].index(set_action)
        #p "最初のループ",chk_loop_result,x,tmp_scombo_flag_tec[x]
        if chk_loop_result != nil
          #ヒットした
          #スパーキングコンボチェック用
          @btl_ani_scombo_cha_count = tmp_scombo_cha_count[x]
          @btl_ani_scombo_get_flag = tmp_scombo_get_flag[x]
          @btl_ani_scombo_new_flag = tmp_scombo_new_flag[x]
          @btl_ani_scombo_no = tmp_scombo_no[x]
          @btl_ani_scombo_cha = tmp_scombo_cha[x]
          @btl_ani_scombo_flag_tec = tmp_scombo_flag_tec[x]
          @btl_ani_scombo_skill_level_num = tmp_scombo_skill_level_num[x]
          @btl_ani_scombo_card_attack_num = tmp_scombo_card_attack_num[x]
          @btl_ani_scombo_card_gard_num = tmp_scombo_card_gard_num[x]
          @btl_ani_scombo_chk_flag_oozaru_put = tmp_scombo_chk_flag_oozaru_put[x]
          
          @btl_ani_scombo_chk_flag_ssaiya = tmp_scombo_chk_flag_ssaiya[x]
          @btl_ani_scombo_chk_flag_ssaiya_cha = tmp_scombo_chk_flag_ssaiya_cha[x]
          @btl_ani_scombo_chk_flag_ssaiya_put = tmp_scombo_chk_flag_ssaiya_put[x]

          #@btl_ani_scombo_tec_no = x
          #今までは並びが固定だったのでループカウントで良かったが任意のため、格納した連番をセットする
          @btl_ani_scombo_tec_no = tmp_scombo_renban[x]
          
          #超サイヤ人で重複表示されないように
          #if @btl_ani_scombo_chk_flag_ssaiya_put == 0
          #  next if $partyc.index(@btl_ani_scombo_chk_flag_ssaiya_cha) == nil
          #else
          #  next if $partyc.index(@btl_ani_scombo_chk_flag_ssaiya_cha) != nil
          #end
            
          tmp_scombo_flag_tec[x] = [0,0] #検索に引っかからないように値を変更
          #tmp_loop_count += 1
          #p @btl_ani_scombo_cha_count,@btl_ani_scombo_get_flag,@btl_ani_scombo_new_flag,@btl_ani_scombo_no,@btl_ani_scombo_cha,@btl_ani_scombo_flag_tec,@btl_ani_scombo_skill_level_num,@btl_ani_scombo_card_attack_num,@btl_ani_scombo_card_gard_num
          #p "スパーキングコンボチェック前",chk_loop_result,x,tmp_scombo_flag_tec[x]
          chk_result = get_scombo_flag @btl_ani_scombo_no

          #p chk_result
          case chk_result
          
          when 1 #発動可能
            get_scombono << @btl_ani_scombo_no
            get_result << chk_result
            get_scomborow << tmp_scombo_renban[x]#x
          when 7 #他の見方が星などの条件を満たしていない
            get_scombono << @btl_ani_scombo_no
            get_result << chk_result
            get_scomborow << tmp_scombo_renban[x]#x
          when 8 #カード未設定
            get_scombono << @btl_ani_scombo_no
            get_result << chk_result
            get_scomborow << tmp_scombo_renban[x]#x
          when 9 #自分が星の条件を満たしていない
            get_scombono << @btl_ani_scombo_no
            get_result << chk_result
            get_scomborow << tmp_scombo_renban[x]#x
          end
        end
        
      end
      
    end
    
    #p get_scombono,get_result
    return get_scombono,get_result,get_scomborow
  end
  
  #--------------------------------------------------------------------------
  # ● 合体攻撃が使用可能かチェック
  # tmp_set_action:対象Sコンボ
  # 戻り値:0　スイッチなどの条件をみたいしていない
  # 　　　:1　発動可能

  # 　　　:3　スキルの効果でSコンボ発動無し
  # 　　　:4　パーティー内にいない
  # 　　　:7　他キャラが原因で発動できない(攻防星、超能力、セットしている必殺技　
  # 　　　:8　可能性あり、他キャラがカードをセットしていない
  # 　　　:9　自分がカードの星を満たしていない
  #--------------------------------------------------------------------------  
  def get_scombo_flag tmp_set_action
 #p $cha_set_action キャラごとの攻撃スキル番号をセット、攻撃しないのであれば値は0
 #p $cardset_cha_no 指定の枚目にキャラ番号が振ってある1人目は0,2人目は1

    ############################################################
    #全体でチェックできるもの
    ############################################################

    #取得しているか？
    if $game_switches[@btl_ani_scombo_get_flag] == false
      return 0
    end

    #フラグの判定を見るか

    if $scombo_chk_flag[@btl_ani_scombo_tec_no] != 0
          
      #スイッチ、変数のフラグを確認
      if $scombo_chk_flag[@btl_ani_scombo_tec_no] == 1 #スイッチ
        return 0 if $game_switches[$scombo_chk_flag_no[@btl_ani_scombo_tec_no]] == false
        #p $scombo_chk_flag_no[x],$game_switches[$scombo_chk_flag_no[x]]
      elsif $scombo_chk_flag[@btl_ani_scombo_tec_no] == 2 #変数
        #チェック方法 0:一致 1:以上 2:以下
        case $scombo_chk_flag_process[x]
        when 0
          return 0 if $game_variables[$scombo_chk_flag_no[@btl_ani_scombo_tec_no]] != $scombo_chk_flag_value[@btl_ani_scombo_tec_no]
        when 1
          return 0 if $game_variables[$scombo_chk_flag_no[@btl_ani_scombo_tec_no]] < $scombo_chk_flag_value[@btl_ani_scombo_tec_no]
        when 2
          return 0 if $game_variables[$scombo_chk_flag_no[@btl_ani_scombo_tec_no]] > $scombo_chk_flag_value[@btl_ani_scombo_tec_no]
        end
      end
    end
    
    #シナリオ進行度
    return 0 if $scombo_chk_scenario_progress[@btl_ani_scombo_tec_no] > $game_variables[40]
    
    ########################################################
    #キャラ毎にチェックが必要なもの
    ########################################################
    
    #自身がカードの条件を満たしていない
    re_mycard_condition = false
    #他キャラがカードをセットしていない
    re_othercard_non = false
    #他キャラがカードの条件を満たしていない
    re_othercard_condition = false
    
    #パーティー内に居ない
    #p tmp_set_action,@btl_ani_scombo_cha[x],$partyc.index(@btl_ani_scombo_cha[x])
    #p @btl_ani_scombo_cha[x],x,@btl_ani_scombo_cha_count-1
    #p $partyc.index(@btl_ani_scombo_cha[x]),@btl_ani_scombo_cha[x],x,@btl_ani_scombo_cha_count-1
    for x in 0..@btl_ani_scombo_cha_count-1
      return 4 if $partyc.index(@btl_ani_scombo_cha[x]) == nil
    end
    
    for x in 0..@btl_ani_scombo_cha_count-1
      
      
      #p tmp_set_action,x,@btl_ani_scombo_cha_count
      

      #スキルでSコンボの必要な星を調整
      scmb_mainasu_a = 0
      scmb_mainasu_g = 0
      
      scmb_mainasu_a,scmb_mainasu_g = chk_doutyou_run @btl_ani_scombo_cha[x]

      #大猿チェック
      if @btl_ani_scombo_chk_flag_oozaru_put == 0
        if $partyc.index(@btl_ani_scombo_cha[x]) != nil
          return 0 if $cha_bigsize_on[$partyc.index(@btl_ani_scombo_cha[x])] == true
        else
          return 0
        end
      else
        if $partyc.index(@btl_ani_scombo_cha[x]) != nil
          return 0 if $cha_bigsize_on[$partyc.index(@btl_ani_scombo_cha[x])] == false
        else
          return 0
        end
      end
      
      #アウトサイダー
      return 3 if chk_skill_learn(430,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
      return 3 if chk_skill_learn(644,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
      return 3 if chk_skill_learn(645,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
      return 3 if chk_skill_learn(646,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
      return 3 if chk_skill_learn(647,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
      return 3 if chk_skill_learn(648,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
      return 3 if chk_skill_learn(649,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
      return 3 if chk_skill_learn(650,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
      return 3 if chk_skill_learn(651,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
      
      
      #傍若無人
      return 3 if chk_skill_learn(476,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
      return 3 if chk_skill_learn(477,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
      return 3 if chk_skill_learn(478,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
      return 3 if chk_skill_learn(479,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
      return 3 if chk_skill_learn(480,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
      return 3 if chk_skill_learn(481,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
      return 3 if chk_skill_learn(482,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
      return 3 if chk_skill_learn(483,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
      return 3 if chk_skill_learn(484,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
      
      #剛腕
      return 3 if chk_skill_learn(705,@btl_ani_scombo_cha[x])[0] == true #剛腕取得していないか
      return 3 if chk_skill_learn(704,@btl_ani_scombo_cha[x])[0] == true #剛腕取得していないか
      return 3 if chk_skill_learn(703,@btl_ani_scombo_cha[x])[0] == true #剛腕取得していないか
      return 3 if chk_skill_learn(702,@btl_ani_scombo_cha[x])[0] == true #剛腕取得していないか
      return 3 if chk_skill_learn(701,@btl_ani_scombo_cha[x])[0] == true #剛腕取得していないか
      return 3 if chk_skill_learn(700,@btl_ani_scombo_cha[x])[0] == true #剛腕取得していないか
      return 3 if chk_skill_learn(699,@btl_ani_scombo_cha[x])[0] == true #剛腕取得していないか
      return 3 if chk_skill_learn(698,@btl_ani_scombo_cha[x])[0] == true #剛腕取得していないか
      return 3 if chk_skill_learn(697,@btl_ani_scombo_cha[x])[0] == true #剛腕取得していないか
      
      #パーティー内に居ない
      #p tmp_set_action,@btl_ani_scombo_cha[x],$partyc.index(@btl_ani_scombo_cha[x])
      #p @btl_ani_scombo_cha[x],x,@btl_ani_scombo_cha_count-1
      #p $partyc.index(@btl_ani_scombo_cha[x]),@btl_ani_scombo_cha[x],x,@btl_ani_scombo_cha_count-1
      #return 4 if $partyc.index(@btl_ani_scombo_cha[x]) == nil
      
      #生きているか
      return 7 if $chadead[$partyc.index(@btl_ani_scombo_cha[x])] == true #生きてる
      
      #超能力にかかってないか
      return 7 if $cha_stop_num[$partyc.index(@btl_ani_scombo_cha[x])] != 0 
      
      #Sコンボ使わないフラグがONになっていないか
      return 7 if $cha_single_attack[$partyc.index(@btl_ani_scombo_cha[x])] == true
      
      #カードをセットしている時のみチェック
      if $cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x])) != nil
        
        #必殺技選択中のキャラは対象外
        if $partyc[@@battle_cha_cursor_state] != @btl_ani_scombo_cha[x]
          #対象技を使ってるか (これはチェックすべきか要検証
          return 7 if $cha_set_action[$partyc.index(@btl_ani_scombo_cha[x])]-10 != @btl_ani_scombo_flag_tec[x] 
        
          #流派が一致しているか (これはチェックすべきか要検証
          return 7 if $game_actors[@btl_ani_scombo_cha[x]].class_id-1 != $cardi[$cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x]))] #流派が一致
        end
      end

      
      #カードの攻撃星が以上
      #p $cardset_cha_no,@btl_ani_scombo_cha[x]
      
      if $partyc[@@battle_cha_cursor_state] == @btl_ani_scombo_cha[x]
        #攻撃
        re_mycard_condition = true if $carda[$cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x]))] < (@btl_ani_scombo_card_attack_num[x] - scmb_mainasu_a)
        #防御
        re_mycard_condition = true if $cardg[$cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x]))] < (@btl_ani_scombo_card_gard_num[x] - scmb_mainasu_g) 
      else
        if $cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x])) == nil
          #対象キャラがカードをセットしていない
          re_othercard_non = true
        else
          #対象キャラがカードをセットしているが星が足りない
          #攻撃
          re_othercard_condition = true if $carda[$cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x]))] < (@btl_ani_scombo_card_attack_num[x] - scmb_mainasu_a)
          #防御
          re_othercard_condition = true if $cardg[$cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x]))] < (@btl_ani_scombo_card_gard_num[x] - scmb_mainasu_g) 
        end
      end
    
      
      
    end

    #自分がカードの条件を満たしていないかによって戻り値を変える
    if re_mycard_condition == true
      return 9
    elsif re_othercard_non == true
      return 8
    elsif re_othercard_condition == true
      return 7
    else
      return 1
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 合体攻撃対象の技を探し使用可能かチェックする
  #-------------------------------------------------------------------------- 
  def chk_scombo_flag_num set_action
    #$cha_set_action[@chanum] - 10
    chk_result = false
    @scombo_flag = false #フラグ初期化
    #@combo_num = 0 #Sコンボの使用No
    tmp_scombo_count = Marshal.load(Marshal.dump($scombo_count))
    tmp_scombo_cha_count = Marshal.load(Marshal.dump($scombo_cha_count))
    tmp_scombo_get_flag = Marshal.load(Marshal.dump($scombo_get_flag))
    tmp_scombo_new_flag = Marshal.load(Marshal.dump($scombo_new_flag))
    tmp_scombo_no = Marshal.load(Marshal.dump($scombo_no))
    tmp_scombo_cha = Marshal.load(Marshal.dump($scombo_cha))
    tmp_scombo_flag_tec = Marshal.load(Marshal.dump($scombo_flag_tec))
    tmp_scombo_skill_level_num = Marshal.load(Marshal.dump($scombo_skill_level_num))
    tmp_scombo_card_attack_num = Marshal.load(Marshal.dump($scombo_card_attack_num))
    tmp_scombo_card_gard_num = Marshal.load(Marshal.dump($scombo_card_gard_num))
    tmp_scombo_chk_flag_oozaru_put = Marshal.load(Marshal.dump($scombo_chk_flag_oozaru_put))
    #Sコンボ配列内に対象技があるかチェック
    #なければループ抜ける
    #あれば
    x = 0
    loop do
      
      for x in 0..tmp_scombo_count
        chk_loop_result = tmp_scombo_flag_tec[x].index(set_action)
        #p "最初のループ",chk_loop_result,x,tmp_scombo_flag_tec[x]
        if chk_loop_result != nil || x >= tmp_scombo_count
          break
        end
        x += 1 if chk_loop_result == nil
      end
      
      #p "最初のループ抜けた",chk_loop_result,x,tmp_scombo_flag_tec[x]
      if chk_loop_result != nil
        #スパーキングコンボチェック用
        @btl_ani_scombo_cha_count = tmp_scombo_cha_count[x]
        @btl_ani_scombo_get_flag = tmp_scombo_get_flag[x]
        @btl_ani_scombo_new_flag = tmp_scombo_new_flag[x]
        @btl_ani_scombo_no = tmp_scombo_no[x]
        @btl_ani_scombo_cha = tmp_scombo_cha[x]
        @btl_ani_scombo_flag_tec = tmp_scombo_flag_tec[x]
        @btl_ani_scombo_skill_level_num = tmp_scombo_skill_level_num[x]
        @btl_ani_scombo_card_attack_num = tmp_scombo_card_attack_num[x]
        @btl_ani_scombo_card_gard_num = tmp_scombo_card_gard_num[x]
        @btl_ani_scombo_chk_flag_oozaru_put = tmp_scombo_chk_flag_oozaru_put[x]
        @btl_ani_scombo_tec_no = x
        tmp_scombo_flag_tec[x] = [0,0] #検索に引っかからないように値を変更
        #tmp_loop_count += 1
        #p @btl_ani_scombo_cha_count,@btl_ani_scombo_get_flag,@btl_ani_scombo_new_flag,@btl_ani_scombo_no,@btl_ani_scombo_cha,@btl_ani_scombo_flag_tec,@btl_ani_scombo_skill_level_num,@btl_ani_scombo_card_attack_num,@btl_ani_scombo_card_gard_num
        #p "スパーキングコンボチェック前",chk_loop_result,x,tmp_scombo_flag_tec[x]
        if $game_switches[@btl_ani_scombo_get_flag] == true
          chk_result = chk_scombo_flag @btl_ani_scombo_no
        end
      end
      
      if chk_result == true || x >= tmp_scombo_count
        break
        
      end 
    end 
    
    #もし条件が一致するなら合体攻撃を格納
    if chk_result == true
      @scombo_flag = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 合体攻撃が使用可能かチェック
  #--------------------------------------------------------------------------  
  def chk_scombo_flag tmp_set_action
 #p $cha_set_action キャラごとの攻撃スキル番号をセット、攻撃しないのであれば値は0
 #p $cardset_cha_no 指定の枚目にキャラ番号が振ってある1人目は0,2人目は1

    for x in 0..@btl_ani_scombo_cha_count-1
      if $partyc.index(@btl_ani_scombo_cha[x]) != nil #仲間にいる
        if $cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x])) != nil #攻撃参加している
          if $scombo_chk_flag[@btl_ani_scombo_tec_no] != 0
            
            
            if $scombo_chk_flag[@btl_ani_scombo_tec_no] == 1 #スイッチ
              return false if $game_switches[$scombo_chk_flag_no[@btl_ani_scombo_tec_no]] == false
              #p $scombo_chk_flag_no[x],$game_switches[$scombo_chk_flag_no[x]]
            elsif $scombo_chk_flag[@btl_ani_scombo_tec_no] == 2 #変数
              #チェック方法 0:一致 1:以上 2:以下
              case $scombo_chk_flag_process[x]
              when 0
                return false if $game_variables[$scombo_chk_flag_no[@btl_ani_scombo_tec_no]] != $scombo_chk_flag_value[@btl_ani_scombo_tec_no]
              when 1
                return false if $game_variables[$scombo_chk_flag_no[@btl_ani_scombo_tec_no]] < $scombo_chk_flag_value[@btl_ani_scombo_tec_no]
              when 2
                return false if $game_variables[$scombo_chk_flag_no[@btl_ani_scombo_tec_no]] > $scombo_chk_flag_value[@btl_ani_scombo_tec_no]
              end
            end
          end
          
          #スキルでSコンボの必要な星を調整
          scmb_mainasu_a = 0
          scmb_mainasu_g = 0
          
          scmb_mainasu_a,scmb_mainasu_g = chk_doutyou_run @btl_ani_scombo_cha[x]
         
          #p scmb_mainasu_a,scmb_mainasu_g
          #p chk_skill_learn(430,@btl_ani_scombo_cha[x])[0]
          #シナリオ進行度
          return false if $scombo_chk_scenario_progress[@btl_ani_scombo_tec_no] > $game_variables[40]
          return false if chk_skill_learn(430,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
          return false if chk_skill_learn(644,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
          return false if chk_skill_learn(645,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
          return false if chk_skill_learn(646,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
          return false if chk_skill_learn(647,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
          return false if chk_skill_learn(648,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
          return false if chk_skill_learn(649,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
          return false if chk_skill_learn(650,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
          return false if chk_skill_learn(651,@btl_ani_scombo_cha[x])[0] == true #アウトサイダー取得していないか
          return false if chk_skill_learn(476,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
          return false if chk_skill_learn(477,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
          return false if chk_skill_learn(478,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
          return false if chk_skill_learn(479,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
          return false if chk_skill_learn(480,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
          return false if chk_skill_learn(481,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
          return false if chk_skill_learn(482,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
          return false if chk_skill_learn(483,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
          return false if chk_skill_learn(484,@btl_ani_scombo_cha[x])[0] == true #傍若無人取得していないか
          return false if $chadead[$partyc.index(@btl_ani_scombo_cha[x])] == true #生きてる
          return false if $cha_stop_num[$partyc.index(@btl_ani_scombo_cha[x])] != 0 #超能力にかかってないか
          #return false if @cha_attack_run[$partyc.index(@btl_ani_scombo_cha[x])] == true #行動済みではない
          return false if $cha_set_action[$partyc.index(@btl_ani_scombo_cha[x])]-10 != @btl_ani_scombo_flag_tec[x] #対象技を使ってるか
          return false if $game_actors[@btl_ani_scombo_cha[x]].class_id-1 != $cardi[$cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x]))] #流派が一致
          return false if $carda[$cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x]))] < (@btl_ani_scombo_card_attack_num[x] - scmb_mainasu_a) #カードの攻撃星が以上
          return false if $cardg[$cardset_cha_no.index($partyc.index(@btl_ani_scombo_cha[x]))] < (@btl_ani_scombo_card_gard_num[x] - scmb_mainasu_g) #カードの防御星が以上
          $cha_skill_level[@btl_ani_scombo_flag_tec[x]] = 0 if $cha_skill_level[@btl_ani_scombo_flag_tec[x]] == nil #必殺技使用回数がnilかチェックしてnilなら0格納
          return false if $cha_skill_level[@btl_ani_scombo_flag_tec[x]] < @btl_ani_scombo_skill_level_num[x]
          return false if $cha_single_attack[$partyc.index(@btl_ani_scombo_cha[x])] == true #Sコンボ使わないフラグがONになっていないか
      
          
          #大猿チェック
          if @btl_ani_scombo_chk_flag_oozaru_put == 0
            return false if $cha_bigsize_on[$partyc.index(@btl_ani_scombo_cha[x])] == true
          else
            return false if $cha_bigsize_on[$partyc.index(@btl_ani_scombo_cha[x])] == false
          end
        else
          return false
        end
      else
        return false
      end
    
    end

    return true
  end
  #--------------------------------------------------------------------------
  # ● 決定ボタンが押されるまでループ
  #-------------------------------------------------------------------------- 
  def input_loop_run

    Graphics.update
    result = false

    #見えないレベルでページが送られるのでその対策
    if $WinState == 6 && #Sコンボ気合は十分だ
      $game_variables[357] == 1 #押しっぱなしで送る
      Graphics.wait(15)
    end
    
    begin
    $cursor_blink_count += $msg_cursor_blink
    @msg_cursor.src_rect = set_tate_cursor_blink
    Input.update
      if Input.trigger?(Input::B) or Input.trigger?(Input::C) or ($game_variables[357] == 1 and (Input.press?(Input::B) or Input.press?(Input::C))) or (Input.press?(Input::R) and (Input.press?(Input::B) or Input.press?(Input::C)))
        result = true
      end
      input_fast_fps
      Graphics.wait(1)
    end while result == false
    Input.update
  end
end