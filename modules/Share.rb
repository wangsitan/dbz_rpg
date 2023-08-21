#==============================================================================
# ■ 色々共有して使用できるメソッド
#------------------------------------------------------------------------------
# 　IDに対応するアイコンを返すように
#==============================================================================
module Share
include Share_Sub_procedure
include Share_Sub_battle_arena
include Share_Sub_skill
include Share_Sub_card_compo

  Techniquenamex = 248          #必殺技画像取得サイズX
  Techniquenamey = 24           #必殺技画像取得サイズY
  
  #--------------------------------------------------------------------------
  # ● 縦カーソル点滅制御
  # n:マイナス調整分 tenmetu: 0チェックなし 1:チェックあり blink: 0:x,1:xxを取得
  #--------------------------------------------------------------------------
  def get_cursor_pic count=0,tenmetu=1,n=1,blink=0
    
    x = 0
    xx = 0
    case $skin_kanri
    
    when "Z1_","Z2_"
      x = 12*16
      xx = 14*16
    when "Z3_"
      x = 16*16
      xx = 18*16
    when "ZG_"
      #x = 1*16
      #xx = 10*16
      x = 24*16
      xx = 26*16
    when "ZSSD_"
      x = 20*16
      xx = 22*16
    when "DB2_"
      x = 33*16
      xx = 35*16
    when "DB3_"
      x = 37*16
      xx = 39*16
    else
      x = 12*16
      xx = 14*16
    end
    
    x -= 16*n 
    xx -= 16*n

    tenmetubairitu = 1
    
    if blink == 1 
      return Rect.new(xx, 0, 16, 16),count # アイコン
    elsif count <= 8 * tenmetubairitu || tenmetu==0
      return Rect.new(x, 0, 16, 16),count # アイコン
    elsif count <= 16 * tenmetubairitu
      return Rect.new(xx, 0, 16, 16),count # アイコン
    else
      count = 0
      return Rect.new(x, 0, 16, 16),count # アイコン
    end
  end
  #--------------------------------------------------------------------------
  # ● 対象キャラの全必殺技の使用回数を増加
  # chano:対象キャラ
  # add_skillnum:増加回数
  #--------------------------------------------------------------------------
  def add_all_skill_num chano,add_skillnum
    #必殺技回数追加
    for x in 0..$game_actors[chano].skills.size - 1
      
      target_tec = $game_actors[chano].skills[x].id
      #指定の必殺技がnullだったら0をセット(エラー回避)
      set_cha_tec_null_to_zero target_tec
      
      $cha_skill_level[target_tec] += add_skillnum
      
      #最大値を超えたら最大値にあわせる
      $cha_skill_level[target_tec] = $cha_skill_level_max if $cha_skill_level[target_tec] > $cha_skill_level_max

    end
  end
  #--------------------------------------------------------------------------
  # ● 対象キャラの必殺技をランダムで使用回数を増加
  # chano:対象キャラ
  # add_skillnum:増加回数
  #--------------------------------------------------------------------------
  def add_random_skill_num chano,add_skillnum

    #必殺技回数追加
    for x in 1..add_skillnum
      
      randno = rand($game_actors[chano].skills.size)
      
      target_tec = $game_actors[chano].skills[randno].id
      #指定の必殺技がnullだったら0をセット(エラー回避)
      set_cha_tec_null_to_zero target_tec
      
      $cha_skill_level[target_tec] += 1
      
      #最大値を超えたら最大値にあわせる
      $cha_skill_level[target_tec] = $cha_skill_level_max if $cha_skill_level[target_tec] > $cha_skill_level_max

    end
  end

  #--------------------------------------------------------------------------
  # ● 渡されたスキル配列を降順で値を取得して、実行されたSスキル内にあるか確認し、
  #    さらに発動スキル表示変数にも入っていないか確認する。
  #    降順で取得しているのは、重複表示を避け、高いレベルのスキルのみ表示するため
  # chk_skillno:チェックした全体のスキル
  # chk_run_skill:実際に実行したスキル
  #--------------------------------------------------------------------------
  def chk_run_scomskillno chk_skillno,chk_run_skill
    chk_skillno.reverse_each { |i|
      if chk_run_skill.index(i) != nil
        #発動スキルに既に入っていないか確認
        if $tmp_run_skill.index(i) == nil
          return i
        end
      end
    }
    
    return nil
  end
  #--------------------------------------------------------------------------
  # ● 対象者が戦闘中に選択したカードを返す
  # get_chano:対象キャラクターNo
  #--------------------------------------------------------------------------
  def get_chaselcardno get_chano
    for x in 0..$Cardmaxnum
      if $partyc[$cardset_cha_no[x]] == get_chano
        return x
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 対象者が戦闘に参加かつ生きているか確認(サイバイマンの自爆とかで使う
  # get_chano:対象キャラクターNo
  #--------------------------------------------------------------------------
  def get_chabtljoin_dead get_chano
    for x in 0..$Cardmaxnum
      #対象キャラが先頭に参加しているか
      if $partyc[$cardset_cha_no[x]] == get_chano
        #対象キャラが生きているか
        if $chadead[$cardset_cha_no[x]] == false &&
          $chadeadchk[$cardset_cha_no[x]] == false
          return false
        else
          return true
        end
      end
    end
    
    #最後まで見つからなかったのでいない判定とする
    return true
  end
  #--------------------------------------------------------------------------
  # ● 対象カードの最大所持数
  # item_id:対象カードID
  #--------------------------------------------------------------------------
  def get_havemax_card item_id
    if $data_items[item_id].element_set.index(5)
      #Sランク
      tmp_max_item_card_num = $game_variables[224]
    elsif $data_items[item_id].element_set.index(6)
      #Aランク
      tmp_max_item_card_num = $game_variables[225]
    elsif $data_items[item_id].element_set.index(7)
      #Bランク
      tmp_max_item_card_num = $game_variables[226]
    elsif $data_items[item_id].element_set.index(8)
      #Cランク
      tmp_max_item_card_num = $game_variables[227]
    else
      tmp_max_item_card_num = 1
    end
    
    return tmp_max_item_card_num
  end
  #--------------------------------------------------------------------------
  # ● レベルアップSEの変更
  #--------------------------------------------------------------------------
  def set_levelup_se
    
    case $game_variables[427]
    
    when 0
      $BGM_levelup_se = "Z1 レベルアップ"
    when 1
      $BGM_levelup_se = "Z2 レベルアップ"
    when 2
      $BGM_levelup_se = "Z3 レベルアップ"
    when 3
      $BGM_levelup_se = "ZSSD レベルアップ"
    else
      $BGM_levelup_se = "Z3 レベルアップ"
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘参加人数取得
  #--------------------------------------------------------------------------
  def get_battle_sankaninzu
    #戦闘参加人数取得
    cardset_cha_num = 0 #戦闘参加人数
    tmp_cardset_cha_no = [] #カード選択配列の一時処理用
    
    #カードを選択した配列を格納
    tmp_cardset_cha_no = $cardset_cha_no.reject { |num| num == 99 }
    
    #配列から戦闘参加人数を取得
    cardset_cha_num = tmp_cardset_cha_no.size
    
    return cardset_cha_num
  end
  #--------------------------------------------------------------------------
  # ● Sコンボ プ必殺技変更に伴うプレイヤ発動優先度の変更
  # cha_no:キャラクターNo
  # scom_flag_no_mae:Sコンボ取得フラグNo前
  # scom_flag_no_ato:Sコンボ取得フラグNo後
  #--------------------------------------------------------------------------
  def tecchg_player_scombo_priority cha_no,scom_flag_no_mae,scom_flag_no_ato
    
    #変更前のSコンボNoを取得
    sno_mae = $scombo_chk_flag_no.index(scom_flag_no_mae)
    #変更後のSコンボNoを取得
    sno_ato = $scombo_chk_flag_no.index(scom_flag_no_ato)
    
    #対象キャラにSコンボ優先度配列がなければ作成する
    if $player_scombo_priority[cha_no] == nil
      $player_scombo_priority[cha_no] = []
    end

    #変更前のSコンボがあるかチェック
    if $player_scombo_priority[cha_no].index(sno_mae) != nil
      #変更後のSコンボNoに置き換える
      $player_scombo_priority[cha_no][$player_scombo_priority[cha_no].index(sno_mae)] = sno_ato
      
    end
  end
  #--------------------------------------------------------------------------
  # ● Sコンボ プレイヤ発動優先度の最新化
  #--------------------------------------------------------------------------
  def update_player_scombo_priority
    result = get_scombo_list 3
    #p result
    scombo_list = [] #現在発動可能なSコンボの取得
    scombo_sort_list = [] #現在発動可能なSコンボで取得済み、未取得でソートしたもの
    
    #Sコンボの並びを自分で変えるときだけ処理する
    if $game_variables[358] == 1
      if $player_scombo_priority == [] 
        #未設定で初期値(デフォルト順)を格納していく
        #パーティー全体の現在発動可能なSコンボを取得し、変数に格納する
        for x in 0..$partyc.size - 1
          #対象キャラのSコンボ取得
          scombo_list = get_scombo_list $partyc[x]
          #scombo_sort_list = scombo_list_onoffsort scombo_list
          #p scombo_list,scombo_sort_list
          $player_scombo_priority[$partyc[x]] = scombo_list
        end
      else
        #一度でも設定(開いていたら)していたらこっち
        #新しく取得した分を変数の最後に追加する
        for x in 0..$partyc.size - 1
          #対象キャラのSコンボ取得
          scombo_list = get_scombo_list $partyc[x]
          
          #対象キャラのSコンボ取得済み、未取得でソート
          scombo_sort_list = scombo_list_onoffsort scombo_list
          
          #p "追加処理前" + $player_scombo_priority[$partyc[x]].to_s
          #変数に入っていないSコンボを変数に追加する
          for y in 0..scombo_sort_list.size-1
            #変数に入っているか確認
            #変数の初期化
            $player_scombo_priority[$partyc[x]] = [] if $player_scombo_priority[$partyc[x]] == nil 
            #p $player_scombo_priority[$partyc[x]],scombo_sort_list[y],x,y
            if $player_scombo_priority[$partyc[x]].index(scombo_sort_list[y]) == nil
              #変数に入っていなかった
              #p scombo_sort_list[y],$player_scombo_priority[$partyc[x]].index(scombo_sort_list[y]),$player_scombo_priority[$partyc[x]]
              $player_scombo_priority[$partyc[x]] << scombo_sort_list[y]
              
              
            end
          end

          #重複Sコンボ削除(不具合で複数表示されることがあることの対策)
          if $player_scombo_priority[$partyc[x]] != nil
            $player_scombo_priority[$partyc[x]].uniq!
          end
          
          #p "追加処理後:" + $player_scombo_priority[$partyc[x]].to_s
        end
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Sコンボリストのソート
  # 取得済みと未取得順に並び替える
  #--------------------------------------------------------------------------
  def scombo_list_onoffsort scombo_list
    scombo_sort_list = [] #ソート後のリスト
    
    #取得済み
    for x in 0..scombo_list.size - 1
      if $game_switches[$scombo_get_flag[scombo_list[x]]] == true
        scombo_sort_list << scombo_list[x]
      end
    end
    
    #未取得
    for x in 0..scombo_list.size - 1
      if $game_switches[$scombo_get_flag[scombo_list[x]]] == false
        scombo_sort_list << scombo_list[x]
      end
    end
    
    return scombo_sort_list
  end
  #--------------------------------------------------------------------------
  # ● キャラのSコンボ取得
  #--------------------------------------------------------------------------
  def get_scombo_list chano
    scombo_cha_num = 0
    scombo_cha_no = []
    scombo_ssaiya_cha = []
    ssaiya_loop_chk = false
    for x in 0..$scombo_count
      if $scombo_chk_flag[x] != 0
        #シナリオ進行度
        next if $scombo_chk_scenario_progress[x] > $game_variables[40]

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
      
      #超サイヤになると毎回並びがリセットされそうなので一旦コメントアウトとする
=begin
      ssaiya_loop_chk = false
      if $scombo_chk_flag_ssaiya[x] != 0
        scombo_ssaiya_cha = $scombo_chk_flag_ssaiya_cha[x]

        if $scombo_chk_flag_ssaiya_put[x] == 0
          next if $partyc.index($scombo_chk_flag_ssaiya_cha[x]) == nil
        else
          next if $partyc.index($scombo_chk_flag_ssaiya_cha[x]) != nil
        end
        
        
      end
=end
      #大猿になると毎回並びがリセットされそうなので一旦コメントアウトとする
      #if $partyc.index(chano) != nil
      #  if $scombo_chk_flag_oozaru_put[x] == 0
      #    next if $cha_bigsize_on[$partyc.index(chano)] == true
      #  else
      #    next if $cha_bigsize_on[$partyc.index(chano)] == false
      #  end
      #end

      if $scombo_cha[x].index(chano) != nil
        scombo_cha_no[scombo_cha_num] = x
        scombo_cha_num += 1
      end

    end
    
    return scombo_cha_no
  end

  #--------------------------------------------------------------------------
  # ● Z1バーダック編変数初期化
  #--------------------------------------------------------------------------
  def z1bar_varinitialize
    $cha_typical_skill_z1bar =      Marshal.load(Marshal.dump($cha_typical_skill))
    $cha_add_skill_z1bar =          Marshal.load(Marshal.dump($cha_add_skill))
    $cha_skill_set_flag_z1bar =     Marshal.load(Marshal.dump($cha_skill_set_flag))
    $cha_skill_get_flag_z1bar =     Marshal.load(Marshal.dump($cha_skill_get_flag))
    $cha_add_skill_set_num_z1bar =  Marshal.load(Marshal.dump($cha_add_skill_set_num))
    $cha_skill_spval_z1bar =        Marshal.load(Marshal.dump($cha_skill_spval))
    $zp_z1bar =                     Marshal.load(Marshal.dump($zp))
    $game_actors_z1bar =            Marshal.load(Marshal.dump($game_actors))
    $cha_defeat_num_z1bar =         Marshal.load(Marshal.dump($cha_defeat_num))
    $game_party_z1bar =             Marshal.load(Marshal.dump($game_party))
    
    
    $cha_add_skill_set_num_z1bar[4] = 1
    $cha_typical_skill_z1bar[4] = [0,0,0]
    $cha_add_skill_z1bar[4] = [0,0]
    $cha_skill_spval_z1bar[4]
    
    for x in 0..$cha_skill_spval_z1bar[4].size - 1
      $cha_skill_spval_z1bar[4][x] = 0
    end
    $zp_z1bar[4] = 0
    $cha_defeat_num_z1bar[4] = 0
    
    $cha_add_skill_set_num_z1bar[16] = 1
    $cha_typical_skill_z1bar[16] = [0,0,0]
    $cha_add_skill_z1bar[16] = [0,0]
    for x in 0..$cha_skill_spval_z1bar[16].size - 1
      $cha_skill_spval_z1bar[16][x] = 0
    end
    $zp_z1bar[16] = 0
    $cha_defeat_num_z1bar[16] = 0
    
    #$game_party_z1bar.gold = 0
    #$game_party_z1bar.items = []
  end

  #--------------------------------------------------------------------------
  # ● エラーメッセージのまとめ
  #--------------------------------------------------------------------------
  def set_err_run_process_msg
    $err_run_process_msg = ""
    
    if $err_run_process != ""
      $err_run_process_msg += "===" + $err_run_process.to_s + "==="
    end
    #実行中の詳細
    if $err_run_process_d != ""
      $err_run_process_msg += "\n" + $err_run_process_d.to_s
    end
    
    if $err_run_process_d2 != ""
      $err_run_process_msg += "\n" + $err_run_process_d2.to_s
    end
    
    if $err_run_process_d3 != ""
      $err_run_process_msg += "\n" + $err_run_process_d3.to_s
    end

    
  end
  
  
  #--------------------------------------------------------------------------
  # ● メイン編とZ1バーダック編　変数入れ替え
  #--------------------------------------------------------------------------
  def main_z1bar_varchange
    $cha_typical_skill_z1bar , $cha_typical_skill = $cha_typical_skill , $cha_typical_skill_z1bar
    $cha_add_skill_z1bar , $cha_add_skill = $cha_add_skill , $cha_add_skill_z1bar
    $cha_skill_set_flag_z1bar , $cha_skill_set_flag = $cha_skill_set_flag , $cha_skill_set_flag_z1bar
    $cha_skill_get_flag_z1bar , $cha_skill_get_flag = $cha_skill_get_flag , $cha_skill_get_flag_z1bar
    $cha_add_skill_set_num_z1bar , $cha_add_skill_set_num = $cha_add_skill_set_num , $cha_add_skill_set_num_z1bar
    $cha_skill_spval_z1bar , $cha_skill_spval = $cha_skill_spval , $cha_skill_spval_z1bar
    $zp_z1bar , $zp = $zp , $zp_z1bar
    $game_actors_z1bar , $game_actors = $game_actors , $game_actors_z1bar
    $cha_defeat_num_z1bar , $cha_defeat_num = $cha_defeat_num , $cha_defeat_num_z1bar
    $game_party_z1bar , $game_party = $game_party , $game_party_z1bar
    $game_variables[305] , $game_variables[330] = $game_variables[330] , $game_variables[305] #共有経験値
    $game_variables[324] , $game_variables[331] = $game_variables[331] , $game_variables[324] #共有経験値基準レベル
    
  end
  #--------------------------------------------------------------------------
  # ● 作戦の必殺技が無かった時の初期化
  #引数：[chano:キャラNo, tactecno：作戦の必殺技No kizerotecno:キャラのKI0で使える技]
  #--------------------------------------------------------------------------
  def set_tactec_learn chano,tactecno,kizerotecno
    #指定の技の必殺技が存在しない場合初期化
    if chk_tec_learn(chano,tactecno) == false
      case tactecno
       
      #悟飯の超1,2の必殺技を個別に保持するようにしたためコメントアウト
      #when 53 #激烈魔閃光
      #  $cha_tactics[7][chano] = 54
      #when 54 #スーパーかめはめ波
      #  $cha_tactics[7][chano] = 53
      when 177 #シャイニングソードアタック
        if chk_tec_learn(chano,178) == true #ヒートドームアタック
          $cha_tactics[7][chano] = 178
        elsif chk_tec_learn(chano,181) == true #フィニッシュバスター
          $cha_tactics[7][chano] = 181
        else
          $cha_tactics[7][chano] = kizerotecno
        end
      when 178 #ヒートドームアタック
        if chk_tec_learn(chano,177) == true #シャイニングソードアタック
          $cha_tactics[7][chano] = 177
        elsif chk_tec_learn(chano,181) == true #フィニッシュバスター
          $cha_tactics[7][chano] = 181
        else
          $cha_tactics[7][chano] = kizerotecno
        end
      when 181 #フィニッシュバスター
        if chk_tec_learn(chano,177) == true #シャイニングソードアタック
          $cha_tactics[7][chano] = 177
        elsif chk_tec_learn(chano,178) == true #ヒートドームアタック
          $cha_tactics[7][chano] = 178
        else
          $cha_tactics[7][chano] = kizerotecno
        end
      else
        $cha_tactics[7][chano] = kizerotecno
      end
    end
  end  
  #--------------------------------------------------------------------------
  # ● 必殺技を覚えているかチェック
  #引数：[chano:キャラNo, tecno：必殺技No ]
  #--------------------------------------------------------------------------
  def chk_tec_learn chano,tecno
    for x in 0..$game_actors[chano].skills.size - 1
      return true if tecno == $game_actors[chano].skills[x].id
    end
    
    return false
  end
  #--------------------------------------------------------------------------
  # ● 全所持カード0にする
  #--------------------------------------------------------------------------
  def lose_allitem
    
    for x in 1..$data_items.size
      $game_party.lose_item ($data_items[x], 99)
    end
  end
  
  #--------------------------------------------------------------------------
  # ● キャラのsp取得処理
  #--------------------------------------------------------------------------
  def get_cha_sp_run chano,temp_sp
    
    skillget_flag = false
    skillget_no = []
    #空欄の時は0をセット
    $cha_add_skill[chano] = [0] if $cha_add_skill[chano] == nil
    for x in 0..2#$cha_add_skill[chano].size-1
      #処理スキルNo格納
      temp_skillno = $cha_add_skill[chano][x]
      
      #空欄の時は0をセット
      temp_skillno = 0 if temp_skillno == nil
      $cha_skill_spval[chano] = [0] if $cha_skill_spval[chano] == nil
      $cha_skill_spval[chano][temp_skillno] = 0 if $cha_skill_spval[chano][temp_skillno] == nil
      
      #自分自身か次のスキル化をチェック
      run_nextskill = false
      #p $cha_skill_get_flag[chano][temp_skillno],
      #$cha_add_lvup[temp_skillno],
      #$cha_skill_share[$cha_upgrade_skill_no[temp_skillno]]
      #p chk_run_next_add_skill chano,temp_skillno
      if chk_run_next_add_skill(chano,temp_skillno) == true
        #次のスキル
        temp_skillno = $cha_upgrade_skill_no[temp_skillno]
        run_nextskill = true
        #p temp_skillno,chano
      end
      #最大値未満なら経験値を増加する(セットしているスキル)
      $cha_skill_spval[chano][temp_skillno] += temp_sp if $cha_skill_spval[chano][temp_skillno] < $cha_skill_get_val[temp_skillno]
      
      #最大値を超えたら最大値に調整する
      
      #取得フラグを初期化
      #$cha_skill_get_flag[chano][temp_skillno] = 0 if $cha_skill_get_flag[chano][temp_skillno] == nil
      
      
      #p $cha_skill_spval[chano][temp_skillno] , $cha_skill_get_val[temp_skillno] , $cha_skill_get_flag[chano][temp_skillno]
      if $cha_skill_spval[chano][temp_skillno] >= $cha_skill_get_val[temp_skillno] && $cha_skill_get_flag[chano][temp_skillno] != 1
        $cha_skill_spval[chano][temp_skillno] = $cha_skill_get_val[temp_skillno]
        
        
        #セットしたことがあることにする
        $cha_skill_set_flag[chano][temp_skillno] = 1
        
        #取得したフラグをON
        $cha_skill_get_flag[chano][temp_skillno] = 1
        
        
        #ハテナと空欄以外なら取得扱い
        if temp_skillno > 1
          #Audio.se_play("Audio/SE/" +"Z3 レベルアップ")
          #Audio.se_stop
          #Audio.se_play("Audio/SE/" +"ZG 技取得")
          
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
          if chk_run_next_add_skill(chano,temp_skillno) == true
            $skill_set_get_num[0][$cha_upgrade_skill_no[temp_skillno]] = 1
            $skill_set_get_num[1][$cha_upgrade_skill_no[temp_skillno]] = 1
            #セットしたことがあることにする
            $cha_skill_set_flag[chano][$cha_upgrade_skill_no[temp_skillno]] = 1
          end
          
          #取得したフラグとスキルを更新
          skillget_flag = true
          skillget_no << temp_skillno
          
          #上限値を超えた値がセットされるバグ対策で念のためここでも処理しておく
          if $cha_skill_spval[chano][$cha_add_skill[chano][x]] >= $cha_skill_get_val[$cha_add_skill[chano][x]]
            $cha_skill_spval[chano][$cha_add_skill[chano][x]] = $cha_skill_get_val[$cha_add_skill[chano][x]]
            
            #セットしたことがあることにする
            $cha_skill_set_flag[chano][$cha_add_skill[chano][x]] = 1
            
            #取得したフラグをON
            $cha_skill_get_flag[chano][$cha_add_skill[chano][x]] = 1
            
          end
          
          #もし次レベルのスキルなら次のレベルのスキルをセットする
          if run_nextskill == true
            $cha_add_skill[chano][x] = temp_skillno
            
          end
          
        end

      end
      
      #,$cha_skill_spval[chano][$cha_add_skill[chano][x]],$cha_skill_get_val[$cha_add_skill[chano][x]]
      #p chano,$cha_add_skill[chano][x],$cha_skill_spval[chano][$cha_add_skill[chano][x]],$cha_skill_get_val[$cha_add_skill[chano][x]]
      
    
    end
    
    return skillget_flag,skillget_no
  end
  #--------------------------------------------------------------------------
  # ● ZPの取得倍率を取得
  #--------------------------------------------------------------------------
  def get_zp_bairitu
    
    zp_bairitu = 0
    
    if $game_switches[499] == true #5倍フラグ
      zp_bairitu = 5
    elsif $game_switches[498] == true #4倍フラグ
      zp_bairitu = 4
    elsif $game_switches[497] == true #3倍フラグ
      zp_bairitu = 3
    elsif $game_switches[496] == true #2倍フラグ
      zp_bairitu = 2
    else
      zp_bairitu = 1
    end
    
    return zp_bairitu
  end
  
  #--------------------------------------------------------------------------
  # ● 対象キャラクターがいるかチェック
  # 引数：[chano: ]
  #--------------------------------------------------------------------------
  def chk_chain chano
    result = false
    if $partyc.index(chano) != nil
      result = true
    end
    
    return result
  end
  
  #--------------------------------------------------------------------------
  # ● カタカナをひらがなに変換する
  # 標準の変換だと正常に動作しなかったので自作した
  # 引数：[str:変換した文字列 ]
  #--------------------------------------------------------------------------  
  def kanatohira str
    str = str.gsub("ァ", "ぁ")
    str = str.gsub("ィ", "ぃ")
    str = str.gsub("ゥ", "ぅ")
    str = str.gsub("ェ", "ぇ")
    str = str.gsub("ォ", "ぉ")
    str = str.gsub("ッ", "っ")
    str = str.gsub("ア", "あ")
    str = str.gsub("イ", "い")
    str = str.gsub("ウ", "う")
    str = str.gsub("エ", "え")
    str = str.gsub("オ", "お")
    str = str.gsub("カ", "か")
    str = str.gsub("キ", "き")
    str = str.gsub("ク", "く")
    str = str.gsub("ケ", "け")
    str = str.gsub("コ", "こ")
    str = str.gsub("サ", "さ")
    str = str.gsub("シ", "し")
    str = str.gsub("ス", "す")
    str = str.gsub("セ", "せ")
    str = str.gsub("ソ", "そ")
    str = str.gsub("タ", "た")
    str = str.gsub("チ", "ち")
    str = str.gsub("ツ", "つ")
    str = str.gsub("テ", "て")
    str = str.gsub("ト", "と")
    str = str.gsub("ナ", "な")
    str = str.gsub("ニ", "に")
    str = str.gsub("ヌ", "ぬ")
    str = str.gsub("ネ", "ね")
    str = str.gsub("ノ", "の")
    str = str.gsub("ハ", "は")
    str = str.gsub("ヒ", "ひ")
    str = str.gsub("フ", "ふ")
    str = str.gsub("ヘ", "へ")
    str = str.gsub("ホ", "ほ")
    str = str.gsub("マ", "ま")
    str = str.gsub("ミ", "み")
    str = str.gsub("ム", "む")
    str = str.gsub("メ", "め")
    str = str.gsub("ヤ", "や")
    str = str.gsub("ユ", "ゆ")
    str = str.gsub("ヨ", "よ")
    str = str.gsub("ラ", "ら")
    str = str.gsub("リ", "り")
    str = str.gsub("ル", "る")
    str = str.gsub("レ", "れ")
    str = str.gsub("ロ", "ろ")
    str = str.gsub("ワ", "わ")
    str = str.gsub("ヲ", "を")
    str = str.gsub("ン", "ん")
    str = str.gsub("ガ", "が")
    str = str.gsub("ギ", "ぎ")
    str = str.gsub("グ", "ぐ")
    str = str.gsub("ゲ", "げ")
    str = str.gsub("ゴ", "ご")
    str = str.gsub("ザ", "ざ")
    str = str.gsub("ジ", "じ")
    str = str.gsub("ズ", "ず")
    str = str.gsub("ゼ", "ぜ")
    str = str.gsub("ゾ", "ぞ")
    str = str.gsub("ダ", "だ")
    str = str.gsub("ヂ", "ぢ")
    str = str.gsub("ヅ", "づ")
    str = str.gsub("デ", "で")
    str = str.gsub("ド", "ど")
    str = str.gsub("バ", "ば")
    str = str.gsub("ビ", "び")
    str = str.gsub("ブ", "ぶ")
    str = str.gsub("ベ", "べ")
    str = str.gsub("ボ", "ぼ")
    str = str.gsub("パ", "ぱ")
    str = str.gsub("ピ", "ぴ")
    str = str.gsub("プ", "ぷ")
    str = str.gsub("ペ", "ぺ")
    str = str.gsub("ポ", "ぽ")
    str = str.gsub("", "")
    str = str.gsub("", "")
    str = str.gsub("", "")
    str = str.gsub("", "")
    str = str.gsub("", "")
    
    return str
  end
  #--------------------------------------------------------------------------
  # ● FC文字化する際に　漢字とかをひらがなに置換する
  # 引数：[mozi:文字列 ]
  #--------------------------------------------------------------------------
  def chg_fc_mozi_tikan mozi
    mozi = mozi.sub("(超)","")
    mozi = mozi.sub("強","きょう")
    mozi = mozi.sub("号","ごう")
    mozi = mozi.sub("若者","わかもの")
    mozi = mozi.sub("(巨大化)","")
    mozi = mozi.sub("(大猿)","")
    mozi = mozi.sub("(変身)","")
    mozi = mozi.sub("(第１形態)","")
    mozi = mozi.sub("(第２形態)","")
    mozi = mozi.sub("(第３形態)","")
    mozi = mozi.sub("(最終形態)","")
    mozi = mozi.sub("(完全体)","")
    mozi = mozi.sub("界王様","カイオウさま")
    mozi = mozi.sub("惑星戦士","わくせいせんし")
    mozi = mozi.sub("戦闘員","せんとういん")
    mozi = mozi.sub("(フルパワー)","")
    mozi = mozi.sub("(サイボーグ)","")
    mozi = mozi.sub("改","かい")
    mozi = mozi.sub("桃白白","タオパイパイ")
    mozi = mozi.sub("一般兵","いっぱんへい")
    mozi = mozi.sub("軍","ぐん")
    mozi = mozi.sub("兵","へい")
    mozi = mozi.sub("合体","がったい")
    mozi = mozi.sub("(未来)","")
    mozi = mozi.sub("(未来超)","")
    mozi = mozi.sub("変身覚醒","へんしんかくせい")
    mozi = mozi.sub("第１覚醒","だい1かくせい")
    mozi = mozi.sub("第２覚醒","だい2かくせい")
    mozi = mozi.sub("覚醒","かくせい")
    return mozi
    
  end
  
  #--------------------------------------------------------------------------
  # ● 特殊文字の変換
  #--------------------------------------------------------------------------
  def convert_special_characters mozi
    mozi.gsub!(/\\V\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
    mozi.gsub!(/\\V\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
    mozi.gsub!(/\\N\[([0-9]+)\]/i) { $game_actors[$1.to_i].name }
    mozi.gsub!(/\\I\[([0-9]+)\]/i) { $data_items[$1.to_i].name }
    mozi.gsub!(/\\C\[([0-9]+)\]/i) { "\x01[#{$1}]" }
    mozi.gsub!(/\\G/)              { "\x02" }
    mozi.gsub!(/\\\./)             { "\x03" }
    mozi.gsub!(/\\\|/)             { "\x04" }
    mozi.gsub!(/\\!/)              { "\x05" }
    mozi.gsub!(/\\>/)              { "\x06" }
    mozi.gsub!(/\\</)              { "\x07" }
    mozi.gsub!(/\\\^/)             { "\x08" }
    mozi.gsub!(/\\\\/)             { "\\" }
    #mozi.gsub!(/\\SNM\[([0-9]+)\]/i) { $data_items[$1.to_i].base_damage }
    #mozi.gsub!(/\\SNA\[([0-9]+)\]/i) { $cha_skill_mozi_set[$1.to_i] }
    return mozi
  end
  #--------------------------------------------------------------------------
  # ● 必殺技表示詳細
  # 　 スキルIDを見て画像を表示する。
  # 引数：[skill_no:スキルNo ]
  #--------------------------------------------------------------------------
  
  def output_mozi mozi
    mozi = convert_special_characters mozi
    mozi_num = mozi.split(//u).size
    #p mozi,mozi_num
    $tec_mozi=Bitmap.new(16*(mozi_num)+16, 24)
    listnoy = 3
    
    for x in 0..mozi_num-1
      dakuten = false
      handakuten = false
      suuzi_eigo = false
      tokusyumozi = false
      mozi_x = 0
      mozi_y = 0
      #p mozi.split(//)[x,1].join(" ")
      itimozi = mozi.split(//)[x,1].join(" ")
      case itimozi #mozi.split(//)[x,1]
      when "0"
        mozi_x = 0
        mozi_y = 0
        suuzi_eigo = true
      when "1"
        mozi_x = 1
        mozi_y = 0
        suuzi_eigo = true
      when "2"
        mozi_x = 2
        mozi_y = 0
        suuzi_eigo = true
      when "3"
        mozi_x = 3
        mozi_y = 0
        suuzi_eigo = true
      when "4"
        mozi_x = 4
        mozi_y = 0
        suuzi_eigo = true
      when "5"
        mozi_x = 5
        mozi_y = 0
        suuzi_eigo = true
      when "6"
        mozi_x = 6
        mozi_y = 0
        suuzi_eigo = true
      when "7"
        mozi_x = 7
        mozi_y = 0
        suuzi_eigo = true
      when "8"
        mozi_x = 8
        mozi_y = 0
        suuzi_eigo = true
      when "9"
        mozi_x = 9
        mozi_y = 0
        suuzi_eigo = true
      when "〇"
        mozi_x = 0
        mozi_y = listnoy
        suuzi_eigo = true
      when "１"
        mozi_x = 1
        mozi_y = listnoy
        suuzi_eigo = true
      when "２"
        mozi_x = 2
        mozi_y = listnoy
        suuzi_eigo = true
      when "３"
        mozi_x = 3
        mozi_y = listnoy
        suuzi_eigo = true
      when "４"
        mozi_x = 4
        mozi_y = listnoy
        suuzi_eigo = true
      when "５"
        mozi_x = 5
        mozi_y = listnoy
        suuzi_eigo = true
      when "６"
        mozi_x = 6
        mozi_y = listnoy
        suuzi_eigo = true
      when "７"
        mozi_x = 7
        mozi_y = listnoy
        suuzi_eigo = true
      when "８"
        mozi_x = 8
        mozi_y = listnoy
        suuzi_eigo = true
      when "９"
        mozi_x = 9
        mozi_y = listnoy
        suuzi_eigo = true
      when "あ"
        mozi_x = 0
        mozi_y = 0
      when "い"
        mozi_x = 1
        mozi_y = 0      
      when "う"
        mozi_x = 2
        mozi_y = 0      
      when "え"
        mozi_x = 3
        mozi_y = 0      
      when "お"
        mozi_x = 4
        mozi_y = 0
      when "か"
        mozi_x = 5
        mozi_y = 0
      when "き"
        mozi_x = 6
        mozi_y = 0
      when "く"
        mozi_x = 7
        mozi_y = 0
      when "け"
        mozi_x = 8
        mozi_y = 0
      when "こ"
        mozi_x = 9
        mozi_y = 0
      when "が"
        mozi_x = 5
        mozi_y = 0
        dakuten = true
      when "ぎ"
        mozi_x = 6
        mozi_y = 0
        dakuten = true
      when "ぐ"
        mozi_x = 7
        mozi_y = 0
        dakuten = true
      when "げ"
        mozi_x = 8
        mozi_y = 0
        dakuten = true
      when "ご"
        mozi_x = 9
        mozi_y = 0
        dakuten = true
      when "さ"
        mozi_x = 10
        mozi_y = 0
      when "し"
        mozi_x = 11
        mozi_y = 0
      when "す"
        mozi_x = 12
        mozi_y = 0
      when "せ"
        mozi_x = 13
        mozi_y = 0
      when "そ"
        mozi_x = 14
        mozi_y = 0
      when "ざ"
        mozi_x = 10
        mozi_y = 0
        dakuten = true
      when "じ"
        mozi_x = 11
        mozi_y = 0
        dakuten = true
      when "ず"
        mozi_x = 12
        mozi_y = 0
        dakuten = true
      when "ぜ"
        mozi_x = 13
        mozi_y = 0
        dakuten = true
      when "ぞ"
        mozi_x = 14
        mozi_y = 0
        dakuten = true
      when "た"
        mozi_x = 15
        mozi_y = 0
      when "ち"
        mozi_x = 16
        mozi_y = 0
      when "つ"
        mozi_x = 17
        mozi_y = 0
      when "て"
        mozi_x = 18
        mozi_y = 0
      when "と"
        mozi_x = 19
        mozi_y = 0      
      when "だ"
        mozi_x = 15
        mozi_y = 0
        dakuten = true
      when "ぢ"
        mozi_x = 16
        mozi_y = 0
        dakuten = true
      when "づ"
        mozi_x = 17
        mozi_y = 0
        dakuten = true
      when "で"
        mozi_x = 18
        mozi_y = 0
        dakuten = true
      when "ど"
        mozi_x = 19
        mozi_y = 0      
        dakuten = true
      when "な"
        mozi_x = 20
        mozi_y = 0      
      when "に"
        mozi_x = 21
        mozi_y = 0      
      when "ぬ"
        mozi_x = 22
        mozi_y = 0
      when "ね"
        mozi_x = 23
        mozi_y = 0
      when "の"
        mozi_x = 24
        mozi_y = 0
      when "は"
        mozi_x = 25
        mozi_y = 0
      when "ひ"
        mozi_x = 26
        mozi_y = 0
      when "ふ"
        mozi_x = 27
        mozi_y = 0
      when "へ"
        mozi_x = 28
        mozi_y = 0
      when "ほ"
        mozi_x = 29
        mozi_y = 0
      when "ば"
        mozi_x = 25
        mozi_y = 0
        dakuten = true
      when "び"
        mozi_x = 26
        mozi_y = 0
        dakuten = true
      when "ぶ"
        mozi_x = 27
        mozi_y = 0
        dakuten = true
      when "べ"
        mozi_x = 28
        mozi_y = 0
        dakuten = true
      when "ぼ"
        mozi_x = 29
        mozi_y = 0
        dakuten = true
      when "ぱ"
        mozi_x = 25
        mozi_y = 0
        handakuten = true
      when "ぴ"
        mozi_x = 26
        mozi_y = 0
        handakuten = true
      when "ぷ"
        mozi_x = 27
        mozi_y = 0
        handakuten = true
      when "ぺ"
        mozi_x = 28
        mozi_y = 0
        handakuten = true
      when "ぽ"
        mozi_x = 29
        mozi_y = 0
        handakuten = true
      when "ま"
        mozi_x = 30
        mozi_y = 0
      when "み"
        mozi_x = 31
        mozi_y = 0
      when "む"
        mozi_x = 32
        mozi_y = 0
      when "め"
        mozi_x = 33
        mozi_y = 0
      when "も"
        mozi_x = 34
        mozi_y = 0
      when "や"
        mozi_x = 35
        mozi_y = 0
      when "ゆ"
        mozi_x = 36
        mozi_y = 0
      when "よ"
        mozi_x = 37
        mozi_y = 0
      when "ら"
        mozi_x = 38
        mozi_y = 0
      when "り"
        mozi_x = 39
        mozi_y = 0
      when "る"
        mozi_x = 40
        mozi_y = 0
      when "れ"
        mozi_x = 41
        mozi_y = 0
      when "ろ"
        mozi_x = 42
        mozi_y = 0
      when "わ"
        mozi_x = 43
        mozi_y = 0
      when "を"
        mozi_x = 44
        mozi_y = 0
      when "ん"
        mozi_x = 45
        mozi_y = 0
      when "っ"
        mozi_x = 46
        mozi_y = 0
      when "ゃ"
        mozi_x = 47
        mozi_y = 0
      when "ゅ"
        mozi_x = 48
        mozi_y = 0
      when "ょ"
        mozi_x = 49
        mozi_y = 0
      when "ぃ"
        mozi_x = 50
        mozi_y = 0
      when "ぁ"
        mozi_x = 51
        mozi_y = 0
      when "ア"
        mozi_x = 0
        mozi_y = 1
      when "イ"
        mozi_x = 1
        mozi_y = 1      
      when "ウ"
        mozi_x = 2
        mozi_y = 1      
      when "エ"
        mozi_x = 3
        mozi_y = 1      
      when "オ"
        mozi_x = 4
        mozi_y = 1
      when "カ"
        mozi_x = 5
        mozi_y = 1
      when "キ"
        mozi_x = 6
        mozi_y = 1
      when "ク"
        mozi_x = 7
        mozi_y = 1
      when "ケ"
        mozi_x = 8
        mozi_y = 1
      when "コ"
        mozi_x = 9
        mozi_y = 1
      when "ガ"
        mozi_x = 5
        mozi_y = 1
        dakuten = true
      when "ギ"
        mozi_x = 6
        mozi_y = 1
        dakuten = true
      when "グ"
        mozi_x = 7
        mozi_y = 1
        dakuten = true
      when "ゲ"
        mozi_x = 8
        mozi_y = 1
        dakuten = true
      when "ゴ"
        mozi_x = 9
        mozi_y = 1
        dakuten = true
      when "サ"
        mozi_x = 10
        mozi_y = 1
      when "シ"
        mozi_x = 11
        mozi_y = 1
      when "ス"
        mozi_x = 12
        mozi_y = 1
      when "セ"
        mozi_x = 13
        mozi_y = 1
      when "ソ"
        mozi_x = 14
        mozi_y = 1
      when "ザ"
        mozi_x = 10
        mozi_y = 1
        dakuten = true
      when "ジ"
        mozi_x = 11
        mozi_y = 1
        dakuten = true
      when "ズ"
        mozi_x = 12
        mozi_y = 1
        dakuten = true
      when "ゼ"
        mozi_x = 13
        mozi_y = 1
        dakuten = true
      when "ゾ"
        mozi_x = 14
        mozi_y = 1
        dakuten = true
      when "タ"
        mozi_x = 15
        mozi_y = 1
      when "チ"
        mozi_x = 16
        mozi_y = 1
      when "ツ"
        mozi_x = 17
        mozi_y = 1
      when "テ"
        mozi_x = 18
        mozi_y = 1
      when "ト"
        mozi_x = 19
        mozi_y = 1      
      when "ダ"
        mozi_x = 15
        mozi_y = 1
        dakuten = true
      when "ヂ"
        mozi_x = 16
        mozi_y = 1
        dakuten = true
      when "ヅ"
        mozi_x = 17
        mozi_y = 1
        dakuten = true
      when "デ"
        mozi_x = 18
        mozi_y = 1
        dakuten = true
      when "ド"
        mozi_x = 19
        mozi_y = 1      
        dakuten = true
      when "ナ"
        mozi_x = 20
        mozi_y = 1      
      when "ニ"
        mozi_x = 21
        mozi_y = 1      
      when "ヌ"
        mozi_x = 22
        mozi_y = 1
      when "ネ"
        mozi_x = 23
        mozi_y = 1
      when "ノ"
        mozi_x = 24
        mozi_y = 1
      when "ハ"
        mozi_x = 25
        mozi_y = 1
      when "ヒ"
        mozi_x = 26
        mozi_y = 1
      when "フ"
        mozi_x = 27
        mozi_y = 1
      when "ヘ"
        mozi_x = 28
        mozi_y = 1
      when "ホ"
        mozi_x = 29
        mozi_y = 1
      when "バ"
        mozi_x = 25
        mozi_y = 1
        dakuten = true
      when "ビ"
        mozi_x = 26
        mozi_y = 1
        dakuten = true
      when "ブ"
        mozi_x = 27
        mozi_y = 1
        dakuten = true
      when "ベ"
        mozi_x = 28
        mozi_y = 1
        dakuten = true
      when "ボ"
        mozi_x = 29
        mozi_y = 1
        dakuten = true
      when "パ"
        mozi_x = 25
        mozi_y = 1
        handakuten = true
      when "ピ"
        mozi_x = 26
        mozi_y = 1
        handakuten = true
      when "プ"
        mozi_x = 27
        mozi_y = 1
        handakuten = true
      when "ペ"
        mozi_x = 28
        mozi_y = 1
        handakuten = true
      when "ポ"
        mozi_x = 29
        mozi_y = 1
        handakuten = true
      when "マ"
        mozi_x = 30
        mozi_y = 1
      when "ミ"
        mozi_x = 31
        mozi_y = 1
      when "ム"
        mozi_x = 32
        mozi_y = 1
      when "メ"
        mozi_x = 33
        mozi_y = 1
      when "モ"
        mozi_x = 34
        mozi_y = 1
      when "ヤ"
        mozi_x = 35
        mozi_y = 1
      when "ユ"
        mozi_x = 36
        mozi_y = 1
      when "ヨ"
        mozi_x = 37
        mozi_y = 1
      when "ラ"
        mozi_x = 38
        mozi_y = 1
      when "リ"
        mozi_x = 39
        mozi_y = 1
      when "ル"
        mozi_x = 40
        mozi_y = 1
      when "レ"
        mozi_x = 41
        mozi_y = 1
      when "ロ"
        mozi_x = 42
        mozi_y = 1
      when "ワ"
        mozi_x = 43
        mozi_y = 1
      when "ヲ"
        mozi_x = 44
        mozi_y = 1
      when "ン"
        mozi_x = 45
        mozi_y = 1
      when "ッ"
        mozi_x = 46
        mozi_y = 1
      when "ャ"
        mozi_x = 47
        mozi_y = 1
      when "ュ"
        mozi_x = 48
        mozi_y = 1
      when "ョ"
        mozi_x = 49
        mozi_y = 1
      when "ィ"
        mozi_x = 50
        mozi_y = 1
      when "ァ"
        mozi_x = 51
        mozi_y = 1
      when "ェ"
        mozi_x = 52
        mozi_y = 1
      when "ォ"
        mozi_x = 54
        mozi_y = 1
      when "？"
        mozi_x = 0
        mozi_y = 2
      when "！"
        mozi_x = 1
        mozi_y = 2
      when "・"
        mozi_x = 2
        mozi_y = 2
      when "ー"
        mozi_x = 5
        mozi_y = 2
      when "…"
        mozi_x = 6
        mozi_y = 2
      when "＝"
        mozi_x = 16
        mozi_y = 2
      when "＋"
        mozi_x = 17
        mozi_y = 2
      when "A"
        mozi_x = 13
        mozi_y = 1
        suuzi_eigo = true
      when "B"
        mozi_x = 14
        mozi_y = 1
        suuzi_eigo = true
      when "C"
        mozi_x = 15
        mozi_y = 1
        suuzi_eigo = true
      when "D"
        mozi_x = 23
        mozi_y = 0
        suuzi_eigo = true
      when "E"
        mozi_x = 24
        mozi_y = 0
        suuzi_eigo = true
      when "F"
        mozi_x = 22
        mozi_y = 1
        suuzi_eigo = true
      when "G"
        mozi_x = 21
        mozi_y = 1
        suuzi_eigo = true
      when "H"
        mozi_x = 0
        mozi_y = 1
        suuzi_eigo = true
      when "I"
        mozi_x = 3
        mozi_y = 1
        suuzi_eigo = true
      when "K"
        mozi_x = 2
        mozi_y = 1
        suuzi_eigo = true
      when "L"
        mozi_x = 4
        mozi_y = 1
        suuzi_eigo = true
      when "M"
        mozi_x = 24
        mozi_y = 1
        suuzi_eigo = true
      when "N"
        mozi_x = 8
        mozi_y = 1
        suuzi_eigo = true
      when "O"
        mozi_x = 22
        mozi_y = 0
        suuzi_eigo = true
      when "P"
        mozi_x = 1
        mozi_y = 1
        suuzi_eigo = true
      when "R"
        mozi_x = 26
        mozi_y = 1
        suuzi_eigo = true
      when "S"
        mozi_x = 12
        mozi_y = 1
        suuzi_eigo = true
      when "T"
        mozi_x = 25
        mozi_y = 1
        suuzi_eigo = true
      
      when "U"
        mozi_x = 27
        mozi_y = 0
        suuzi_eigo = true
      when "X"
        mozi_x = 19
        mozi_y = 0
        suuzi_eigo = true
      when "x" #小さい英語
        mozi_x = 27
        mozi_y = 1
        suuzi_eigo = true
      when "Y"
        mozi_x = 26
        mozi_y = 0
        suuzi_eigo = true
      when "Z"
        mozi_x = 23
        mozi_y = 1
        suuzi_eigo = true
      when "＆"
        mozi_x = 20
        mozi_y = 0
        suuzi_eigo = true
      when "("
        mozi_x = 7
        mozi_y = 2
      when ")"
        mozi_x = 8
        mozi_y = 2
      when "「"
        mozi_x = 9
        mozi_y = 2
      when "」"
        mozi_x = 10
        mozi_y = 2
      when "："
        mozi_x = 11
        mozi_y = 2
      when "％"
        mozi_x = 12
        mozi_y = 2
      when "＊"
        mozi_x = 13
        mozi_y = 2
      when "※"
        mozi_x = 14
        mozi_y = 2
      when "."
        mozi_x = 15
        mozi_y = 2
      when "無"
        mozi_x = 18
        mozi_y = 2
      when "限"
        mozi_x = 19
        mozi_y = 2
      when "／"
        mozi_x = 10
        mozi_y = 0
        suuzi_eigo = true
      when "l"#(LV)
        mozi_x = 21
        mozi_y = 0
        suuzi_eigo = true
      when "地"
        mozi_x = 0
        mozi_y = 0
        tokusyumozi = true
      when "球"
        mozi_x = 1
        mozi_y = 0
        tokusyumozi = true
      when "超"
        mozi_x = 2
        mozi_y = 0
        tokusyumozi = true
      when "熱"
        mozi_x = 3
        mozi_y = 0
        tokusyumozi = true
      when "戦"
        mozi_x = 4
        mozi_y = 0
        tokusyumozi = true
      when "烈"
        mozi_x = 5
        mozi_y = 0
        tokusyumozi = true
      when "激"
        mozi_x = 6
        mozi_y = 0
        tokusyumozi = true
      when "改"
        mozi_x = 7
        mozi_y = 0
        tokusyumozi = true
      else
        mozi_x = 0
        mozi_y = 3
      end
      
      if suuzi_eigo == true
        picture = Cache.picture("数字英語")
      elsif tokusyumozi == true
        picture = Cache.picture("文字_特殊")
      else
        picture = Cache.picture("文字_Z3")
      end
      rect = Rect.new(16*mozi_x,16*mozi_y, 16,16)
      $tec_mozi.blt(16*x, 8,picture,rect)
      if dakuten == true
        rect = Rect.new(16*3,16*2, 16,16)
        $tec_mozi.blt(16*x, -8,picture,rect)
      end
      if handakuten == true
        rect = Rect.new(16*4,16*2, 16,16)
        $tec_mozi.blt(16*x, -8,picture,rect)
      end
    
    end 
  end

  def output_ed_mozi mozi
    mozi_num = mozi.split(//u).size
    #p mozi,mozi_num
    $tec_mozi=Bitmap.new(16*(mozi_num)+16, 24)
    
    for x in 0..mozi_num-1
      dakuten = false
      handakuten = false
      suuzi_eigo = false
      mozi_x = 0
      mozi_y = 0
      #p mozi.split(//)[x,1].join(" ")
      itimozi = mozi.split(//)[x,1].join(" ")
      case itimozi #mozi.split(//)[x,1]

      when "1"
        mozi_x = 27
        mozi_y = 0
      when "2"
        mozi_x = 28
        mozi_y = 0
      when "3"
        mozi_x = 29
        mozi_y = 0
      when "4"
        mozi_x = 30
        mozi_y = 0
      when "5"
        mozi_x = 31
        mozi_y = 0
      when "6"
        mozi_x = 32
        mozi_y = 0
      when "7"
        mozi_x = 33
        mozi_y = 0
      when "8"
        mozi_x = 34
        mozi_y = 0
      when "9"
        mozi_x = 35
        mozi_y = 0
      when "0"
        mozi_x = 36
        mozi_y = 0
      when "！"
        mozi_x = 37
        mozi_y = 0
      when "＆"
        mozi_x = 38
        mozi_y = 0
      when ","
        mozi_x = 39
        mozi_y = 0
      when "."
        mozi_x = 40
        mozi_y = 0
      when "@" #コピーライトの代用
        mozi_x = 41
        mozi_y = 0
      when "・"
        mozi_x = 44
        mozi_y = 0
      when "A"
        mozi_x = 0
        mozi_y = 0
      when "B"
        mozi_x = 1
        mozi_y = 0
      when "C"
        mozi_x = 2
        mozi_y = 0
      when "D"
        mozi_x = 3
        mozi_y = 0
      when "E"
        mozi_x = 4
        mozi_y = 0
      when "F"
        mozi_x = 5
        mozi_y = 0
      when "G"
        mozi_x = 6
        mozi_y = 0
      when "H"
        mozi_x = 7
        mozi_y = 0
      when "I"
        mozi_x = 8
        mozi_y = 0
      when "J"
        mozi_x = 9
        mozi_y = 0
      when "K"
        mozi_x = 10
        mozi_y = 0
      when "L"
        mozi_x = 11
        mozi_y = 0
      when "M"
        mozi_x = 12
        mozi_y = 0
      when "N"
        mozi_x = 13
        mozi_y = 0
      when "O"
        mozi_x = 14
        mozi_y = 0
      when "P"
        mozi_x = 15
        mozi_y = 0
      when "Q"
        mozi_x = 16
        mozi_y = 0
      when "R"
        mozi_x = 17
        mozi_y = 0
      when "S"
        mozi_x = 18
        mozi_y = 0
      when "T"
        mozi_x = 19
        mozi_y = 0
      when "U"
        mozi_x = 20
        mozi_y = 0
      when "V"
        mozi_x = 21
        mozi_y = 0
      when "W"
        mozi_x = 22
        mozi_y = 0
      when "X"
        mozi_x = 23
        mozi_y = 0
      when "Y"
        mozi_x = 24
        mozi_y = 0
      when "Z"
        mozi_x = 25
        mozi_y = 0
      when "／"
        mozi_x = 26
        mozi_y = 0
      when "-"
        mozi_x = 45
        mozi_y = 0
      when "◆"
        mozi_x = 46
        mozi_y = 0
      when "_" #アンスコを空欄扱い
        mozi_x = 43
        mozi_y = 0
      else #空欄
        mozi_x = 43
        mozi_y = 0
      end

      picture = Cache.picture("文字_Z1_スタッフロール")

      rect = Rect.new(16*mozi_x,16*mozi_y, 16,16)
      $tec_mozi.blt(16*x, 8,picture,rect)
    
    end 
  end  
  
  def output_technique_detail skill_no #必殺技表示詳細
    rect = nil
    
    #p $data_skills[skill_no.to_i].description
    
    if skill_no != 0
      mozi = $data_skills[skill_no.to_i].description
    else
      mozi = "？？？？？？？？？？？"
    end
    output_mozi mozi
    picture = Cache.picture("文字_必殺技")
    #必殺技IDによって表示する内容を変化させる
    case skill_no
    when 0 #はてなを取得
      rect = Rect.new(0, 30*Techniquenamey, Techniquenamex, Techniquenamey)
    when 1 #衝撃波
      rect = Rect.new(0, 0*Techniquenamey, Techniquenamex, Techniquenamey)
    when 2 #エネルギー波
      rect = Rect.new(0, 1*Techniquenamey, Techniquenamex, Techniquenamey)
    when 3 #複数エネルギー波
      
    when 4 #太陽拳
      rect = Rect.new(0, 3*Techniquenamey, Techniquenamex, Techniquenamey)
    when 5 #かめはめ波
      rect = Rect.new(0, 2*Techniquenamey, Techniquenamex, Techniquenamey)
    when 6 #界王拳
      rect = Rect.new(0, 19*Techniquenamey, Techniquenamex, Techniquenamey)
    when 7 #界王拳・かめはめ波
      rect = Rect.new(0, 20*Techniquenamey, Techniquenamex, Techniquenamey)
    when 18 #元気弾
      rect = Rect.new(0, 21*Techniquenamey, Techniquenamex, Techniquenamey)
    when 19 #超元気弾
      rect = Rect.new(0, 22*Techniquenamey, Techniquenamex, Techniquenamey)
    when 26 #スーパーかめはめ波
      rect = Rect.new(0, 26*Techniquenamey, Techniquenamex, Techniquenamey)
    when 31 #魔光砲
      rect = Rect.new(0, 4*Techniquenamey, Techniquenamex, Techniquenamey)
    when 32 #連続魔光砲　←爆裂波に変えた
      rect = Rect.new(0, 47*Techniquenamey, Techniquenamex, Techniquenamey)
    when 33 #目から怪光線
      rect = Rect.new(0, 5*Techniquenamey, Techniquenamex, Techniquenamey)
    when 34 #口から怪光線
      rect = Rect.new(0, 6*Techniquenamey, Techniquenamex, Techniquenamey)
    when 35 #爆裂魔光砲
      rect = Rect.new(0, 7*Techniquenamey, Techniquenamex, Techniquenamey)
    when 36 #魔貫光殺砲
      rect = Rect.new(0, 8*Techniquenamey, Techniquenamex, Techniquenamey)
    when 40 #魔空包囲弾
      rect = Rect.new(0, 48*Techniquenamey, Techniquenamex, Techniquenamey)
    when 41 #フルパワー魔貫光殺砲
      rect = Rect.new(0, 49*Techniquenamey, Techniquenamex, Techniquenamey)
    when 46 #魔光砲(悟飯)
      rect = Rect.new(0, 4*Techniquenamey, Techniquenamex, Techniquenamey)
    when 47 #魔閃光(悟飯)
      rect = Rect.new(0, 9*Techniquenamey, Techniquenamex, Techniquenamey)
    when 51 #大猿変身(悟飯)
      rect = Rect.new(0, 45*Techniquenamey, Techniquenamex, Techniquenamey)
    when 52 #爆烈ラッシュ(悟飯)
      rect = Rect.new(0, 46*Techniquenamey, Techniquenamex, Techniquenamey)
    when 61 #エネルギー波(クリリン)
      rect = Rect.new(0, 1*Techniquenamey, Techniquenamex, Techniquenamey)
    when 62 #かめはめ波(クリリン)
      rect = Rect.new(0, 2*Techniquenamey, Techniquenamex, Techniquenamey) 
    when 63 #拡散エネルギー波(クリリン)
      rect = Rect.new(0, 10*Techniquenamey, Techniquenamex, Techniquenamey) 
    when 64 #気円斬(クリリン)
      rect = Rect.new(0, 11*Techniquenamey, Techniquenamex, Techniquenamey)
    when 71 #狼牙風風拳(ヤムチャ)
      rect = Rect.new(0, 12*Techniquenamey, Techniquenamex, Techniquenamey)
    when 72 #かめはめ波(ヤムチャ)
      rect = Rect.new(0, 2*Techniquenamey, Techniquenamex, Techniquenamey)
    when 73 #そうきだん(ヤムチャ)
      rect = Rect.new(0, 13*Techniquenamey, Techniquenamex, Techniquenamey)
    when 81 #エネルギー波(テンシンハン)
      rect = Rect.new(0, 1*Techniquenamey, Techniquenamex, Techniquenamey)
    when 82 #四身の拳
      rect = Rect.new(0, 15*Techniquenamey, Techniquenamex, Techniquenamey)
    when 83 #気功砲
      rect = Rect.new(0, 14*Techniquenamey, Techniquenamex, Techniquenamey)
    when 84 #四身の拳気功砲
      rect = Rect.new(0, 16*Techniquenamey, Techniquenamex, Techniquenamey)
    when 91 #どどんぱ(チャオズ)
      rect = Rect.new(0, 17*Techniquenamey, Techniquenamex, Techniquenamey)
    when 92 #超能力(チャオズ)
      rect = Rect.new(0, 18*Techniquenamey, Techniquenamex, Techniquenamey)
    when 93 #サイコアタック(チャオズ)
      rect = Rect.new(0, 44*Techniquenamey, Techniquenamex, Techniquenamey)
    when 101 #衝撃波
      rect = Rect.new(0, 0*Techniquenamey, Techniquenamex, Techniquenamey)
    when 121 #エネルギー波
      rect = Rect.new(0, 1*Techniquenamey, Techniquenamex, Techniquenamey)
    when 123 #爆発波
      rect = Rect.new(0, 23*Techniquenamey, Techniquenamex, Techniquenamey)
    when 124 #ギャリック砲
      rect = Rect.new(0, 24*Techniquenamey, Techniquenamex, Techniquenamey)
    when 141 #エネルギー波(若者)
      rect = Rect.new(0, 1*Techniquenamey, Techniquenamex, Techniquenamey)
    when 142 #強力エネルギー波(若者)
      rect = Rect.new(0, 27*Techniquenamey, Techniquenamex, Techniquenamey)
    when 147 #エネルギー波(若者)
      rect = Rect.new(0, 1*Techniquenamey, Techniquenamex, Techniquenamey)
    when 148 #強力エネルギー波(若者)
      rect = Rect.new(0, 27*Techniquenamey, Techniquenamex, Techniquenamey)
    when 149 #爆発波
      rect = Rect.new(0, 23*Techniquenamey, Techniquenamex, Techniquenamey)
    when 151 #ファイナルリベンジャー
      rect = Rect.new(0, 28*Techniquenamey, Techniquenamex, Techniquenamey)
    when 152 #ファイナルスピリッツキャノン
      rect = Rect.new(0, 29*Techniquenamey, Techniquenamex, Techniquenamey)
    when 159 #エネルギー波(若者)
      rect = Rect.new(0, 1*Techniquenamey, Techniquenamex, Techniquenamey)
    when 160 #強力エネルギー波(若者)
      rect = Rect.new(0, 27*Techniquenamey, Techniquenamex, Techniquenamey)
    when 161 #爆発波
      rect = Rect.new(0, 23*Techniquenamey, Techniquenamex, Techniquenamey)
    when 163 #ファイナルリベンジャー
      rect = Rect.new(0, 28*Techniquenamey, Techniquenamex, Techniquenamey)
    when 164 #ファイナルスピリッツキャノン
      rect = Rect.new(0, 29*Techniquenamey, Techniquenamex, Techniquenamey)
    when 171 #エネルギー波(トランクス)
      rect = Rect.new(0, 1*Techniquenamey, Techniquenamex, Techniquenamey)
    when 172 #剣攻撃(トランクス)
      rect = Rect.new(0, 50*Techniquenamey, Techniquenamex, Techniquenamey)
    when 173 #爆発波(トランクス)
      rect = Rect.new(0, 23*Techniquenamey, Techniquenamex, Techniquenamey)
    when 174 #魔せんこう(トランクス)
      rect = Rect.new(0, 4*Techniquenamey, Techniquenamex, Techniquenamey)
    when 176 #バーニングアタック(トランクス)
      rect = Rect.new(0, 51*Techniquenamey, Techniquenamex, Techniquenamey)
    when 177 #シャイニングソードアタック(トランクス)
      rect = Rect.new(0, 52*Techniquenamey, Techniquenamex, Techniquenamey)
    when 704 #ダブル衝撃波
      rect = Rect.new(0, 31*Techniquenamey, Techniquenamex, Techniquenamey)
    when 705 #捨て身の攻撃
      rect = Rect.new(0, 32*Techniquenamey, Techniquenamex, Techniquenamey)
    when 706 #カメハメ乱舞
      rect = Rect.new(0, 33*Techniquenamey, Techniquenamex, Techniquenamey)
    when 707 #操気円斬
      rect = Rect.new(0, 34*Techniquenamey, Techniquenamex, Techniquenamey)
    when 708 #願いを込めた元気だま
      rect = Rect.new(0, 35*Techniquenamey, Techniquenamex, Techniquenamey)
    when 709 #ダブルどどんぱ
      rect = Rect.new(0, 36*Techniquenamey, Techniquenamex, Techniquenamey)
    when 710 #超能力気光砲
      rect = Rect.new(0, 37*Techniquenamey, Techniquenamex, Techniquenamey)
    when 701 #師弟の絆
      rect = Rect.new(0, 38*Techniquenamey, Techniquenamex, Techniquenamey)
    when 702 #サイヤンアタック(ゴ
      rect = Rect.new(0, 39*Techniquenamey, Techniquenamex, Techniquenamey)
    when 703 #サイヤンアタック(バ
      rect = Rect.new(0, 40*Techniquenamey, Techniquenamex, Techniquenamey)
    when 711 #狼鶴相打陣
      rect = Rect.new(0, 41*Techniquenamey, Techniquenamex, Techniquenamey)
    when 712 #地球人ストライク
      rect = Rect.new(0, 42*Techniquenamey, Techniquenamex, Techniquenamey)
    when 713 #ギャリックかめはめ波
      rect = Rect.new(0, 43*Techniquenamey, Techniquenamex, Techniquenamey)
    else
      rect = Rect.new(0, 0*Techniquenamey, Techniquenamex, Techniquenamey)
    end
rect = Rect.new(0, 0*Techniquenamey, Techniquenamex, Techniquenamey)
    return rect
  end
  #--------------------------------------------------------------------------
  # カード残りいくつ取得できるか
  #
  #-------------------------------------------------------------------------- 
  def set_card_remaining
    #食べ物
    $game_variables[381] = $game_variables[227] - $game_party.item_number($data_items[74])
    #ごちそう
    $game_variables[382] = $game_variables[227] - $game_party.item_number($data_items[75])
    #せんず
    $game_variables[383] = $game_variables[225] - $game_party.item_number($data_items[17])

  end
  #--------------------------------------------------------------------------
  # ● パーティー全回復
  #
  #-------------------------------------------------------------------------- 
  def all_charecter_recovery
    
    #控えも含め全体
    for x in 0..$full_party_menber.size - 1
      $full_chadead[x] = false
      $game_actors[$full_party_menber[x]].hp = $game_actors[$full_party_menber[x]].maxhp
      $game_actors[$full_party_menber[x]].mp = $game_actors[$full_party_menber[x]].maxmp
    end

    #パーティー内のみ
    for x in 0..$partyc.size - 1 #回復処理
      $chadead[x] = false
      $game_actors[$partyc[x]].hp = $game_actors[$partyc[x]].maxhp
      $game_actors[$partyc[x]].mp = $game_actors[$partyc[x]].maxmp
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティー全回復(0だったら1にする)
  #
  #-------------------------------------------------------------------------- 
  def all_charecter_recovery_giri
    for x in 0..$partyc.size - 1 #回復処理
      $chadead[x] = false
      if $game_actors[$partyc[x]].hp = 0
        $game_actors[$partyc[x]].hp = 1
      end
    end
  end

  def get_item
    num = 99

    for x in 0..19
      $game_party.gain_item($data_weapons[x],num,false)
      $game_party.gain_item($data_armors[x],num,false)
    end
  end

  #--------------------------------------------------------------------------
  # ● 戦闘曲設定
  #
  # #mode = 0:通常 = 1イベント (ボツにするかも)
  # #name = "ファイル名"
  #-------------------------------------------------------------------------- 
  def set_battle_bgm_name_modetype name,mode
    
    if mode == 0
      $option_battle_bgm_name = name
    else
      $option_evbattle_bgm_name = name
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 戦闘曲設定
  # #mode = 0:通常 = 1イベント (ボツにするかも)
  #-------------------------------------------------------------------------- 
  def set_battle_bgm_name(frag_random = false,mode = 0)
    
    if mode == 0
      bgm_no = $game_variables[37]
    else
      bgm_no = $game_variables[428]
    end
   
    if $battle_bgm != 0 #&& $game_variables[428] == 0
      bgm_no =  $battle_bgm
    end
    
    if  bgm_no == 1 && frag_random == true
      chk_scenario_progress

      chk_battle_bgm_on
      loop_end = false
      loop_num = 0
      begin
        
         bgm_no = rand($max_set_battle_bgm-2)+2
         $bgm_btl_random_flag[bgm_no] = 1 if $bgm_btl_random_flag[bgm_no] == nil
         $bgm_evbtl_random_flag[bgm_no] = 1 if $bgm_evbtl_random_flag[bgm_no] == nil
         
         if mode == 0
           if $battle_bgm_on[bgm_no] == true && $bgm_btl_random_flag[bgm_no] == 1
             loop_end = true
           end
         else
           if $battle_bgm_on[bgm_no] == true && $bgm_evbtl_random_flag[bgm_no] == 1
             loop_end = true
           end
         end
         #p bgm_no,$max_set_battle_bgm,$battle_bgm_on[bgm_no] ,loop_end
         
         loop_num += 1
         
         if loop_num >= 10000 #全てのフラグがＯＦＦだと思われる場合は処理を抜けてデフォルト曲を流す
           loop_end = true
           bgm_no = 0
         end
       end while loop_end == false

     end
     
     
    if $game_switches[111] == true
      set_battle_bgm_name_modetype "ZArrang_ソリッドステートスカウター2",mode
      return "DBZ TVSP ソリッドステートスカウター(Full2)"
    end
    case bgm_no
    
    when 0 #デフォルト
      case $game_variables[43] #あらすじNo
      
      when 0..2,101,901,903..910 #蛇の道まで,バーダック編ラディッツエリア
        set_battle_bgm_name_modetype "Z1 戦闘1",mode
      when 3..9,902 #ガーリック撃破まで
        set_battle_bgm_name_modetype "Z1 戦闘2",mode
      when 10..15 #ガーリック撃破後
        set_battle_bgm_name_modetype "Z1 戦闘1",mode
      when 21..50,143..145,911..920 #Z2
        set_battle_bgm_name_modetype "Z2 戦闘1",mode
      when 51..150,921..937 #Z3_Z4
        set_battle_bgm_name_modetype "Z3 戦闘1",mode
      when 151..200
        set_battle_bgm_name_modetype "ZG 戦闘1",mode
      else
        set_battle_bgm_name_modetype "Z1 戦闘1",mode
      end
      return "デフォルト"
    when 1 #ランダム
      set_battle_bgm_name_modetype "",mode
      return "ランダム"
    when 2
      set_battle_bgm_name_modetype "DB1 フィールド",mode
      return "DB 神龍の謎『フィールド』"
    when 3
      set_battle_bgm_name_modetype "DB1 戦闘",mode
      return "DB 神龍の謎『ボス』"
    when 4
      set_battle_bgm_name_modetype "DB2 戦闘1",mode
      return "DB2 大魔王復活『通常』"
    when 5
      set_battle_bgm_name_modetype "DB2 戦闘2",mode
      return "DB2 大魔王復活『ラスト』"
    when 6
      set_battle_bgm_name_modetype "DB3 戦闘1",mode
      return "DB3 悟空伝『通常』"
    when 7
      set_battle_bgm_name_modetype "DB3 戦闘2",mode
      return "DB3 悟空伝『天下一武道会』"
    when 8
      set_battle_bgm_name_modetype "Z1 戦闘1",mode
      return "DBZ 強襲！サイヤ人！『サイヤ人編』"
    when 9
      set_battle_bgm_name_modetype "Z1 戦闘2",mode
      return "DBZ 強襲！サイヤ人！『ガーリック編』"
    when 10
      set_battle_bgm_name_modetype "Z1 戦闘ボス1(中ボス)",mode
      return "DBZ 強襲！サイヤ人！『サイヤ人(ボス)』"
    when 11
      set_battle_bgm_name_modetype "Z1 戦闘ボス2(ベジータ)",mode
      return "DBZ 強襲！サイヤ人！『ラスト』"
    when 12
      set_battle_bgm_name_modetype "Z2 戦闘1",mode
      return "DBZ2 激神フリーザ！！『通常』"
    when 13
      set_battle_bgm_name_modetype "Z2 戦闘2",mode
      return "DBZ2 激神フリーザ！！『天下一武道会』"
    when 14
      set_battle_bgm_name_modetype "Z3 戦闘1",mode
      return "DBZ3 烈戦人造人間『通常』"
    when 15
      set_battle_bgm_name_modetype "Z3 戦闘2(ボス)",mode
      return "DBZ3 烈戦人造人間『ボス』"
    when 16
      set_battle_bgm_name_modetype "Z3 戦闘3(簡易)",mode
      return "DBZ3 烈戦人造人間『簡易』"
    when 17
      set_battle_bgm_name_modetype "ZG 戦闘1",mode
      return "DBZ外伝 サイヤ人絶滅計画『通常1』"
    when 18
      set_battle_bgm_name_modetype "ZG 戦闘2",mode
      return "DBZ外伝 サイヤ人絶滅計画『通常2』"
    when 19
      set_battle_bgm_name_modetype "ZG 戦闘3",mode
      return "DBZ外伝 サイヤ人絶滅計画『中ボス』"
    when 20
      set_battle_bgm_name_modetype "ZG 戦闘4",mode
      return "DBZ外伝 サイヤ人絶滅計画『ボス』"
    when 21
      set_battle_bgm_name_modetype "ZG 戦闘5",mode
      return "DBZ外伝 サイヤ人絶滅計画『ラスト』"
    when 22
      set_battle_bgm_name_modetype "ZD 戦闘",mode
      return "DBZ 激闘天下一武道会『通常』"
    when 23
      set_battle_bgm_name_modetype "DB1 フィールド",mode
      return "？？？"
    when 24 
      set_battle_bgm_name_modetype "DB3 カメハウス",mode
      return "DB3 カメハウス"
    when 31 #GBZバトル1
      set_battle_bgm_name_modetype "GBZ1 戦闘1",mode
      return "DBZ 悟空飛翔伝『通常1』"
    when 32 #GBZバトル2
      set_battle_bgm_name_modetype "GBZ1 戦闘2",mode
      return "DBZ 悟空飛翔伝『通常2』"
    when 33 #GBZバトル3
      set_battle_bgm_name_modetype "GBZ1 戦闘3",mode
      return "DBZ 悟空飛翔伝『通常3』"
    when 34 #GBZバトル4
      set_battle_bgm_name_modetype "GBZ1 戦闘4",mode
      return "DBZ 悟空飛翔伝『ボス』"
    when 35 #GBZバトル5
      set_battle_bgm_name_modetype "GBZ1 戦闘5",mode
      return "DBZ 悟空飛翔伝『ラスト』"
    when 36 #GBZ2バトル1
      set_battle_bgm_name_modetype "GBZ2 戦闘1",mode
      return "DBZ 悟空激闘伝『通常1』"
    when 37 #GBZ2バトル2
      set_battle_bgm_name_modetype "GBZ2 戦闘2",mode
      return "DBZ 悟空激闘伝『通常2』"
    when 38 #GBZ2バトル3
      set_battle_bgm_name_modetype "GBZ2 戦闘3",mode
      return "DBZ 悟空激闘伝『ボス1』"
    when 39 #GBZ2バトル4
      set_battle_bgm_name_modetype "GBZ2 戦闘4",mode
      return "DBZ 悟空激闘伝『ボス2』"
    when 40 #GBZ2バトル5
      set_battle_bgm_name_modetype "GBZ2 戦闘5",mode
      return "DBZ 悟空激闘伝『ラスト』"
    when $bgm_no_Z2_battle1_arrange1
      set_battle_bgm_name_modetype "Z2 戦闘1(VRC6)",mode
      return "DBZ2 激神フリーザ！！『通常(VRC6)』"
    when $bgm_no_ZSSD_battle1 #超サイヤ通常バトル
      set_battle_bgm_name_modetype "ZSSD 戦闘1",mode
      return "DBZ 超サイヤ伝説『通常』"
    when $bgm_no_ZSSD_battle2 #超サイヤラストバトル
      set_battle_bgm_name_modetype "ZSSD 戦闘2",mode
      return "DBZ 超サイヤ伝説『ラスト』"
    when $bgm_no_ZMove_M814A   #劇場版BGM1
      set_battle_bgm_name_modetype "ZArrang_btl02_恐怖のギニュー特戦隊",mode
      return "DBZ 劇場版 ガーリック戦"
    when $bgm_no_ZTV_kyouhug2 #恐怖のギニュー特戦隊
      set_battle_bgm_name_modetype "ZArrang_btl02b_恐怖のギニュー特戦隊B",mode
      return "DBZ TV 恐怖のギニュー特戦隊" 
    when $bgm_no_ZMove_bgm1   #劇場版BGM1
      set_battle_bgm_name_modetype "ZArrang_劇場版BGM1",mode
      return "DBZ 劇場版 BGM1"
    when $bgm_no_ZMove_bgm1_full   #劇場版BGM1
      set_battle_bgm_name_modetype "ZArrang_劇場版BGM1(Full)",mode
      return "DBZ 劇場版 BGM1(Full)"
    when $bgm_no_ZMove_bgm1_2
      set_battle_bgm_name_modetype "ZArrang_btl01_レッドゾーンの闘い(仮",mode
      return "DBZ 劇場版 BGM1 ver2"
    when $bgm_no_ZMove_metarukuura_battlebgm2
      set_battle_bgm_name_modetype "ZArrang_stra03_謎の怪物(仮",mode
      return "DBZ 劇場版 メタルクウラ戦Ver2"
    when $bgm_no_ZMove_metarukuura_battlebgm
      set_battle_bgm_name_modetype "ZArrang_stra03_謎の怪物(ロング2)",mode
      return "DBZ 劇場版 メタルクウラ戦"
    when $bgm_no_ZMove_metarukuura_battlebgm3
      set_battle_bgm_name_modetype "ZArrang_stra03_謎の怪物(ロング)",mode
      return "DBZ 劇場版 メタルクウラ戦Ver3"
    when $bgm_no_ZMove_zinzouningen_battlebgm
      set_battle_bgm_name_modetype "ZArrang_btl10_形勢逆転(仮",mode
      return "DBZ 劇場版 人造人間戦"
    when $bgm_no_ZTVSP_sorid  #ソリッドステートスカウター
      set_battle_bgm_name_modetype "ZArrang_ソリッドステートスカウター",mode
      return "DBZ TVSP ソリッドステートスカウター"
    when $bgm_no_ZTVSP_sorid_full  #ソリッドステートスカウター
      set_battle_bgm_name_modetype "ZArrang_ソリッドステートスカウター(Full)",mode
      return "DBZ TVSP ソリッドステートスカウター(Full)"
    when $bgm_no_ZTVSP_sorid_full2  #ソリッドステートスカウター
      set_battle_bgm_name_modetype "ZArrang_ソリッドステートスカウター2",mode
      return "DBZ TVSP ソリッドステートスカウター(Full2)"
    when $bgm_no_ZTVSP_sorid_full3  #ソリッドステートスカウター
      set_battle_bgm_name_modetype "ZArrang_ソリッドステートスカウター5(full)",mode
      return "DBZ TVSP ソリッドステートスカウター(Full3)"
    when $bgm_no_ZTVSP_sorid_2  #ソリッドステートスカウター
      set_battle_bgm_name_modetype "ZArrang_ソリッドステートスカウター4",mode
      return "DBZ TVSP ソリッドステートスカウター(Ver2)"
    when $bgm_no_ZTV_cellgame  #死を呼ぶセルゲーム
      set_battle_bgm_name_modetype "ZArrang_btl08_死を呼ぶセルゲーム(仮",mode
      return "DBZ TV 死を呼ぶセルゲーム(M1307)"
    when $bgm_no_ZTV_tamashiivs1  #運命の日 魂vs魂ver1
      set_battle_bgm_name_modetype "ZArrang_運命の日 魂vs魂_fix1",mode
      return "DBZ TV 運命の日 ～魂vs魂～Ver1"
    when $bgm_no_ZTV_tamashiivs2  #運命の日 魂vs魂ver2
      set_battle_bgm_name_modetype "ZArrang_運命の日 魂vs魂_fix2b",mode
      return "DBZ TV 運命の日 ～魂vs魂～Ver2"
    when $bgm_no_ZMove_ikusa #Dr.ウィローこの世で一番強いやつ
      set_battle_bgm_name_modetype "ZArrang_btl13_戦(IKUSA)3",mode
      return "DBZ 劇場版『戦(I・KU・SA)』"
    when $bgm_no_ZMove_ikusa_btl #Dr.ウィローこの世で一番強いやつ(バトル)
      set_battle_bgm_name_modetype "ZArrang_btl13_戦(IKUSA)_バトル",mode
      return "DBZ 劇場版『戦(I・KU・SA)(バトルVer)』"
    when $bgm_no_ZMove_ikusa2 #Dr.ウィローこの世で一番強いやつ2
      set_battle_bgm_name_modetype "ZArrang_btl13_戦(IKUSA)2",mode
      return "DBZ 劇場版『戦(I・KU・SA)2』"
    when $bgm_no_ZMove_ikusa_btl2 #Dr.ウィローこの世で一番強いやつ(バトル2)
      set_battle_bgm_name_modetype "ZArrang_btl13_戦(IKUSA)_バトル2",mode
      return "DBZ 劇場版『戦(I・KU・SA)(バトルVer)2』"
    when $bgm_no_ZMove_ikusa3 #Dr.ウィローこの世で一番強いやつ3
      set_battle_bgm_name_modetype "ZArrang_btl13_戦(IKUSA)(サビ前)",mode
      return "DBZ 劇場版『戦(I・KU・SA)3』"
    when $bgm_no_ZMove_marugoto #ターレス まるごと
      set_battle_bgm_name_modetype "ZArrang_btl14_まるごとB",mode
      return "DBZ 劇場版『まるごと』"
    when $bgm_no_ZMove_marugoto_btl #ターレス まるごと(バトル)
      set_battle_bgm_name_modetype "ZArrang_btl14_まるごと_バトル",mode
      return "DBZ 劇場版『まるごと(バトルVer)』"
    when $bgm_no_ZMove_marugoto2 #ターレス まるごと
      set_battle_bgm_name_modetype "ZArrang_btl14_まるごとA",mode
      return "DBZ 劇場版『まるごと2』"
    when $bgm_no_ZMove_genkidama #劇場版 「ヤ」なことには元気玉!!
      set_battle_bgm_name_modetype "ZArrang_btl15_ヤなことは元気玉2",mode
      return "DBZ 劇場版『「ヤ」なことには元気玉!!』"
    when $bgm_no_ZMove_genkidama2 #劇場版 「ヤ」なことには元気玉!!
      set_battle_bgm_name_modetype "ZArrang_btl15_ヤなことは元気玉",mode
      return "DBZ 劇場版『「ヤ」なことには元気玉!!2』"
    when $bgm_no_ZMove_genkidama_btl #劇場版 「ヤ」なことには元気玉!!(バトル)
      set_battle_bgm_name_modetype "ZArrang_btl15_ヤなことは元気玉_battle2",mode
      return "DBZ 劇場版『「ヤ」なことには元気玉!!(バトルVer)』"
    when $bgm_no_ZMove_genkidama_btl2 #劇場版 「ヤ」なことには元気玉!!(バトル2)
      set_battle_bgm_name_modetype "ZArrang_btl15_ヤなことは元気玉_battle",mode
      return "DBZ 劇場版『「ヤ」なことには元気玉!!(バトルVer)2』"
    when $bgm_no_ZMove_saikyo #とびっきりの最強対最強
      set_battle_bgm_name_modetype "ZArrang_btl06_最強vs最強(仮",mode
      return "DBZ 劇場版『とびっきりの最強対最強』"
    when $bgm_no_ZMove_saikyo_btl #とびっきりの最強対最強(バトル)
      set_battle_bgm_name_modetype "ZArrang_btl06_最強vs最強_バトル",mode
      return "DBZ 劇場版『とびっきりの最強対最強(バトルver)』"
    when $bgm_no_ZMove_hero #HERO
      set_battle_bgm_name_modetype "ZArrang_btl16_ヒーロー",mode
      return "DBZ 劇場版『HERO(キミがヒーロー)』"
    when $bgm_no_ZMove_hero_btl #HERO(バトル)
      set_battle_bgm_name_modetype "ZArrang_btl16_ヒーロー_バトル",mode
      return "DBZ 劇場版『HERO(キミがヒーロー)(バトルVer)』"
    when $bgm_no_ZMove_hero2 #HERO
      set_battle_bgm_name_modetype "ZArrang_btl16_ヒーロー(イントロなし)",mode
      return "DBZ 劇場版『HERO(キミがヒーロー)2』"
    when $bgm_no_ZMove_hero_btl2 #HERO(バトル)
      set_battle_bgm_name_modetype "ZArrang_btl16_ヒーロー_バトル2",mode
      return "DBZ 劇場版『HERO(キミがヒーロー)(バトルVer)2』"
    when $bgm_no_ZMove_girigiri #GIRI GIRI -世界極限-
      set_battle_bgm_name_modetype "ZArrang_btl17_GIRI極限",mode
      return "DBZ 劇場版『GIRI GIRI -世界極限-』"
    when $bgm_no_ZMove_girigiri_btl #GIRI GIRI -世界極限-
      set_battle_bgm_name_modetype "ZArrang_btl17_GIRI極限_バトル",mode
      return "DBZ 劇場版『GIRI GIRI -世界極限-(バトルVer)』"
    when $bgm_no_ZMove_nessen #バーニング･ファイト-熱戦･烈戦･超激戦-
      set_battle_bgm_name_modetype "ZArrang_btl18_バーニングファイト(速度1",mode
      return "DBZ 劇場版『バーニング･ファイト-熱戦･烈戦･超激戦-』"
    when $bgm_no_ZMove_nessen_btl #バーニング･ファイト-熱戦･烈戦･超激戦-(バトル)
      set_battle_bgm_name_modetype "ZArrang_btl18_バーニングファイト_バトルA",mode
      return "DBZ 劇場版『バーニング･ファイト-熱戦･烈戦･超激戦-(バトルVer)』"
    when $bgm_no_ZMove_nessen_btl2 #バーニング･ファイト-熱戦･烈戦･超激戦-(バトル)2
      set_battle_bgm_name_modetype "ZArrang_btl18_バーニングファイト_バトルB",mode
      return "DBZ 劇場版『バーニング･ファイト-熱戦･烈戦･超激戦-(バトルVer)2』"
      
    when $bgm_no_ZMove_raizing #銀河を超えてライジング･ハイ
      set_battle_bgm_name_modetype "ZArrang_btl19_銀河を超えて(速度2",mode
      return "DBZ 劇場版『銀河を超えてライジング･ハイ』"
    when $bgm_no_ZMove_raizing_btl #銀河を超えてライジング･ハイ
      set_battle_bgm_name_modetype "ZArrang_btl19_銀河を超えて_バトル",mode
      return "DBZ 劇場版『銀河を超えてライジング･ハイ(バトルVer)』"
    when $bgm_no_ZMove_raizing2 #銀河を超えてライジング･ハイ
      set_battle_bgm_name_modetype "ZArrang_btl19_銀河を超える気がしない",mode
      return "DBZ 劇場版『銀河を超えてライジング･ハイ2』"
    when $bgm_no_ZPS2_Z2_heart #くすぶるハートに火をつけろ
      set_battle_bgm_name_modetype "ZArrang_btl22_ハートに火をつけろ",mode
      return "DBZ2(PS2)『くすぶるheartに火をつけろ!!』"
    when $bgm_no_ZPS2_Z2_heart_btl #くすぶるハートに火をつけろ(バトル)
      set_battle_bgm_name_modetype "ZArrang_btl22_ハートに火をつけろ_バトル",mode
      return "DBZ2(PS2)『くすぶるheartに火をつけろ!!(バトルVer)』"
    when $bgm_no_ZPS2_Z3_ore #俺はとことん止まらない
      set_battle_bgm_name_modetype "ZArrang_btl23_俺はとことん止まらない",mode
      return "DBZ3(PS2)『俺はとことん止まらない』"
    when $bgm_no_ZPS2_Z3_ore_btl #俺はとことん止まらない(バトル)
      set_battle_bgm_name_modetype "ZArrang_btl23_俺はとことん止まらない_バトル",mode
      return "DBZ3(PS2)『俺はとことん止まらない(バトルVer1)』"
    when $bgm_no_ZPS2_Z3_ore_btl2 #俺はとことん止まらない(バトル2)
      set_battle_bgm_name_modetype "ZArrang_btl23_俺はとことん止まらない_バトル2",mode
      return "DBZ3(PS2)『俺はとことん止まらない(バトルVer2)』"
    when $bgm_no_ZSPM_SSurvivor #超サバイバー
      set_battle_bgm_name_modetype "ZArrang_btl21_超Survivor(速度1",mode
      return "DBZ Sparking! METEOR『Super Survivor』"
    when $bgm_no_ZSPM_SSurvivor_btl #超サバイバー(バトル)
      set_battle_bgm_name_modetype "ZArrang_btl21_超Survivor_バトル",mode
      return "DBZ Sparking! METEOR『Super Survivor(バトルVer)』"
    when $bgm_no_ZSPM_SSurvivor_btl2 #超サバイバー(バトル2)
      set_battle_bgm_name_modetype "ZArrang_btl21_超Survivor_バトル2",mode
      return "DBZ Sparking! METEOR『Super Survivor(バトルVer2)』"
    when $bgm_no_ZPS3_BR_kiseki #奇跡の炎よ燃え上れ
      set_battle_bgm_name_modetype "ZArrang_btl24_奇跡の炎よ",mode
      return "DBZ バーストリミット『奇跡の炎よ 燃え上がれ!!』"
    when $bgm_no_ZPS3_BR_kiseki_btl #奇跡の炎よ燃え上れ(バトル)
      set_battle_bgm_name_modetype "ZArrang_btl24_奇跡の炎よ_バトル",mode
      return "DBZ バーストリミット『奇跡の炎よ 燃え上がれ!!(バトルVer)』"
    when $bgm_no_ZPS3_RB2_boo #Battle of Omega
      set_battle_bgm_name_modetype "ZArrang_btl25_BattleOfOmega",mode
      return "DBZ レイジングブラスト2『Battle of Omega』"
    when $bgm_no_ZPS3_RB2_boo_btl #Battle of Omega(バトル)
      set_battle_bgm_name_modetype "ZArrang_btl25_BattleOfOmega_バトル",mode
      return "DBZ レイジングブラスト2『Battle of Omega(バトルVer)』"
    when $bgm_no_ZMove_brori_battlebgm #ブロリー戦
      set_battle_bgm_name_modetype "ZArrang_btlブロリー",mode
      return "DBZ 劇場版 ブロリー戦"
    when $bgm_no_ZMove_brori_battlebgm_btl #ブロリー戦(バトル)
      set_battle_bgm_name_modetype "ZArrang_btlブロリー_バトル",mode
      return "DBZ 劇場版 ブロリー戦(バトルVer)』"
    when $bgm_no_DB_dbdensetu #DBarrang_ドラゴンボール伝説
      set_battle_bgm_name_modetype "ZArrang_dbdnst_ドラゴンボール伝説",mode
      return "DB『ドラゴンボール伝説』"      
    when $bgm_no_DB_mezatenka  #DBArrang_めざせ天下一
      set_battle_bgm_name_modetype "DBArrang_めざせ天下一",mode
      return "DB『めざせ天下一』"
    when $bgm_no_DB_wolf  #ウルフハリケーン(ファミコン風 狼牙風風拳版)
      set_battle_bgm_name_modetype "ZArrang_wolf_ウルフハリケーン",mode
      return "DB『ウルフハリケーン(音声 FC風)』"
    when $bgm_no_DB_wolf2  #ウルフハリケーン(綺麗な狼牙風風拳版)
      set_battle_bgm_name_modetype "ZArrang_wolf_ウルフハリケーン(綺麗な狼牙風風拳版)",mode
      return "DB『ウルフハリケーン(音声 綺麗)』"
    when $bgm_no_DB_wolf3  #ウルフハリケーン(Novoice 狼牙風風拳版)
      set_battle_bgm_name_modetype "ZArrang_wolf_ウルフハリケーン(novoice)",mode
      return "DB『ウルフハリケーン(音声なし)』"
    when $bgm_no_DB_wolf_btl  #ウルフハリケーン(狼牙風風拳版(バトル))
      set_battle_bgm_name_modetype "ZArrang_wolf_ウルフハリケーン_バトル",mode
      return "DB『ウルフハリケーン(バトル)』"
    when $bgm_no_DB_m109 #レッドリボン軍戦
      set_battle_bgm_name_modetype "ZArrang_db_m109_マッスルタワーの攻防(仮",mode
      return "DB M109"
    when $bgm_no_DB_m422 #不明(戦闘)
      set_battle_bgm_name_modetype "ZArrang_db_m422_それぞれの道(仮",mode
      return "DB M422"
    when $bgm_no_DB_m441 #テンシンハン戦
      set_battle_bgm_name_modetype "ZArrang_db_m441_実力伯仲!!(仮",mode
      return "DB M441"
    when $bgm_no_ZMove_M1216 #劇場版BGMクウラ戦
      set_battle_bgm_name_modetype "ZArrang_m1216_悟空vsクウラ",mode
      return "DBZ M1216"
    when $bgm_no_ZMove_M1619 #劇場版BGMボージャック一味戦
      set_battle_bgm_name_modetype "ZArrang_m1619_命懸けのベジータ(仮",mode
      return "DBZ M1619"
    when $bgm_no_ZMove_M1619_btl #劇場版BGMボージャック一味戦(バトル)
      set_battle_bgm_name_modetype "ZArrang_m1619_命懸けのベジータ(仮_バトル",mode
      return "DBZ M1619(バトル)" 
    when $bgm_no_ZSSD_battle1_for_gb #超サイヤ通常バトル(GB音源)
      set_battle_bgm_name_modetype "ZSSD 戦闘1(GB音源Ver)",mode
      return "DBZ 超サイヤ伝説『通常(GB音源Ver)』"
    when $bgm_no_ZSSD_training_for_gb #超サイヤ修行(GB音源)
      set_battle_bgm_name_modetype "ZSSD 修行(GB音源Ver)",mode
      return "DBZ 超サイヤ伝説『修行(GB音源Ver)』"
    when $bgm_no_ZSB1_pikkoro_for_gb #超武闘伝ピッコロ(GB)
      set_battle_bgm_name_modetype "ZSB1 ピッコロのテーマ(GB音源Ver)",mode
      return "DBZ 超武闘伝『ピッコロのテーマ(GB音源Ver)』"
    when $bgm_no_ZSB1_freezer_for_gxscc #超武闘伝フリーザ(GXSCC)
      set_battle_bgm_name_modetype "ZSB1 フリーザのテーマ(GXSCC音源Ver)",mode
      return "DBZ 超武闘伝『フリーザのテーマ』"
    when $bgm_no_ZSB1_20gou_for_gxscc #超武闘伝20gou(gxscc)
      #set_battle_bgm_name_modetype "ZSB1 20号のテーマ(GXSCC音源Ver)",mode
      set_battle_bgm_name_modetype "ZSB1 20号のテーマ2",mode
      return "DBZ 超武闘伝『20号のテーマ』"
    when $bgm_no_ZSB1_18gou_for_gxscc #超武闘伝18gou(gxscc)
      #set_battle_bgm_name_modetype "ZSB1 18号のテーマ(GXSCC音源Ver)",mode
      set_battle_bgm_name_modetype "ZSB1 18号のテーマ2",mode
      return "DBZ 超武闘伝『18号のテーマ』"
    when $bgm_no_ZSB1_cell #超武闘伝セルのテーマ
      set_battle_bgm_name_modetype "ZSB1 セルのテーマ",mode
      return "DBZ 超武闘伝『セルのテーマ』"
    when $bgm_no_ZSB1_16gou_for_gb #超武闘伝16gou(gb)
      set_battle_bgm_name_modetype "ZSB1 16号のテーマ(GB音源Ver)",mode
      return "DBZ 超武闘伝『16号のテーマ(GB音源Ver)』"
    when $bgm_no_ZSB2_pikkoro_for_gb #超武闘伝2ピッコロ(GB)
      set_battle_bgm_name_modetype "ZSB2 ピッコロのテーマ(GB音源Ver)",mode
      return "DBZ 超武闘伝2『ピッコロのテーマ(GB音源Ver)』"
    when $bgm_no_ZSB2_bejita_for_gb # #超武闘伝2ベジータ(GB)
      set_battle_bgm_name_modetype "ZSB2 ベジータのテーマ(GB音源Ver)",mode
      return "DBZ 超武闘伝2『ベジータのテーマ(GB音源Ver)』"
    when $bgm_no_ZSB2_gohan_for_gxscc # #超武闘伝2悟飯のテーマ(gxscc音源Ver)
      set_battle_bgm_name_modetype "ZSB2 悟飯のテーマ(GXSCC音源Ver)",mode
      return "DBZ 超武闘伝2『悟飯のテーマ(GXSCC音源Ver)』"
    when $bgm_no_ZSB2_buro_for_gb # #超武闘伝2ブロリーのテーマ(gxscc音源Ver)
      set_battle_bgm_name_modetype "ZSB2 ブロリーのテーマ(GB音源Ver)",mode
      return "DBZ 超武闘伝2『ブロリーのテーマ(GB音源Ver)』"
    when $bgm_no_ZSB2_buro_for_gxscc # #超武闘伝2ブロリーのテーマ(gxscc音源Ver)
      set_battle_bgm_name_modetype "ZSB2 ブロリーのテーマ(GXSCC音源Ver)",mode
      return "DBZ 超武闘伝2『ブロリーのテーマ(GXSCC音源Ver)』"
    when $bgm_no_ZSB3_goku # #超武闘伝3悟空のテーマ
      set_battle_bgm_name_modetype "ZSB3  悟空のテーマ2(1stlapc)",mode
      return "DBZ 超武闘伝3『悟空のテーマ』"
    when $bgm_no_FCJ1_battle1 #ファミコンジャンプ1戦闘1
      set_battle_bgm_name_modetype "FCJ1 戦闘1",mode
      return "ファミコンジャンプ1『戦闘1』"  
    when $bgm_no_FCJ1_battle2 #ファミコンジャンプ1戦闘2
      set_battle_bgm_name_modetype "FCJ1 戦闘2",mode
      return "ファミコンジャンプ1『戦闘2』"  
    when $bgm_no_FCJ1_battle3 #ファミコンジャンプ1戦闘3
      set_battle_bgm_name_modetype "FCJ1 戦闘3",mode
      return "ファミコンジャンプ1『戦闘3』"  
    when $bgm_no_FCJ1_battle4 #ファミコンジャンプ1戦闘4
      set_battle_bgm_name_modetype "FCJ1 戦闘4",mode
      return "ファミコンジャンプ1『戦闘4』"  
    when $bgm_no_FCJ2_battle1 #ファミコンジャンプ2戦闘1
      set_battle_bgm_name_modetype "FCJ2 戦闘1",mode
      return "ファミコンジャンプ2『戦闘1』"  
    when $bgm_no_FCJ2_battle2 #ファミコンジャンプ2戦闘2
      set_battle_bgm_name_modetype "FCJ2 戦闘2",mode
      return "ファミコンジャンプ2『戦闘2』"  
    when $bgm_no_ZUB_royal_guard #UB22ロイヤルガード
      set_battle_bgm_name_modetype "ZUB_ロイヤルガード",mode
      return "DBZ アルティメットバトル22『ロイヤルガード』"  
    when $bgm_no_ZUB_will_power #UB22 光のWILL POWER
      set_battle_bgm_name_modetype "ZUB_光のWILL POWER(GXSCC)",mode
      return "DBZ アルティメットバトル22『光のWILL POWER』" 
    when $bgm_no_ZUB_zetumei #UB22 絶体絶命
      set_battle_bgm_name_modetype "ZUB_絶体絶命2",mode
      return "DBZ アルティメットバトル22『絶体絶命』"
    when $bgm_no_ZUB_zetumei2 #UB22 絶体絶命
      set_battle_bgm_name_modetype "ZUB_絶体絶命",mode
      return "DBZ アルティメットバトル22『絶体絶命Ver2』"
    when $bgm_no_ZSA1_big_fight_for_gb #超悟空伝1ビッグファイト(GB)
      set_battle_bgm_name_modetype "ZSA1 ビッグファイト(GB音源Ver)",mode
      return "DBZ 超悟空伝 突激編『ビッグファイト』"  
    when $bgm_no_ZSA2_bgm01_for_gb #超悟空伝2_bgm01(GB)
      set_battle_bgm_name_modetype "ZSA2 BGM01(GB音源Ver)",mode
      return "DBZ 超悟空伝 覚醒編 BGM01"  
    when $bgm_no_ZSA2_bgm02_for_gb #超悟空伝2_bgm02(GB)
      set_battle_bgm_name_modetype "ZSA2 BGM02(GB音源Ver)",mode
      return "DBZ 超悟空伝 覚醒編 BGM02"  
    when $bgm_no_ZSA2_bgm06_for_gb #超悟空伝2_bgm06(GB)
      set_battle_bgm_name_modetype "ZSA2 BGM06(GB音源Ver)",mode
      return "DBZ 超悟空伝 覚醒編 BGM06"  
    when $bgm_no_ZSA2_bgm16_for_gb #超悟空伝2_bgm16(GB)
      set_battle_bgm_name_modetype "ZSA2 BGM16(GB音源Ver)",mode
      return "DBZ 超悟空伝 覚醒編 BGM16"  
    when $bgm_no_ZID_bgm01 #偉大なるドラゴンボール伝説 BGM01(GXSCCVer)
      set_battle_bgm_name_modetype "ZID BGM01(GXSCCVer)",mode
      return "DBZ 偉大なるドラゴンボール伝説 BGM01"
    when $bgm_no_ZID_bgm02 #偉大なるドラゴンボール伝説 BGM02(GXSCCVer)
      set_battle_bgm_name_modetype "ZID BGM02(GXSCCVer)",mode
      return "DBZ 偉大なるドラゴンボール伝説 BGM02" 
    when $bgm_no_waiwai #ワイワイワールド (アラレちゃん)
      set_battle_bgm_name_modetype "O_ワイワイワールド_倍速(GXSCCVer)",mode
      return "Dr.スランプ アラレちゃん『ワイワイワールド』"
    when $bgm_no_ZFZ1_namek_btl #ドラゴンボールファイターズナメック星
      set_battle_bgm_name_modetype "ZFZ1_ナメック星のテーマ",mode
      return "DB ファイターズ『ナメック星のテーマ』"
    when $bgm_no_ZFZ1_bardak_btl #ドラゴンボールファイターズナメック星
      set_battle_bgm_name_modetype "ZFZ1_バーダックのテーマ",mode
      return "DB ファイターズ『バーダックのテーマ』" 
    when $bgm_no_DKN_tyoubardak_btl #DKN バーダック(超サイヤ人)
      set_battle_bgm_name_modetype "DKN バーダック超サイヤ人",mode
      return "DBZ ドッカンバトル『バーダック(超サイヤ人)』"  
    when $bgm_no_battle_Original1  #戦闘曲オリジナル1
      set_battle_bgm_name_modetype $btl_user_name + "1",mode
      return "ユーザー設定1"
    when $bgm_no_battle_Original2  #戦闘曲オリジナル2
      set_battle_bgm_name_modetype $btl_user_name + "2",mode
      return "ユーザー設定2"
    when $bgm_no_battle_Original3  #戦闘曲オリジナル3
      set_battle_bgm_name_modetype $btl_user_name + "3",mode
      return "ユーザー設定3"
    when $bgm_no_battle_Original4  #戦闘曲オリジナル4
      set_battle_bgm_name_modetype $btl_user_name + "4",mode
      return "ユーザー設定4"
    when $bgm_no_battle_Original5  #戦闘曲オリジナル5
      set_battle_bgm_name_modetype $btl_user_name + "5",mode
      return "ユーザー設定5"
    else
      set_battle_bgm_name_modetype "",mode
      return "ランダム"
    end

  end

  
  
  
  #--------------------------------------------------------------------------
  # ● 戦闘終了後BGM設定
  #-------------------------------------------------------------------------- 
  def put_btl_end_bgm
    if $game_switches[111] != true #ソリッド固定じゃなければ
      btl_end_bgm = set_battle_end_bgm_name(true)
      
      bgm_stopflag = false
      bgm_playflag = false
      se_playflag = false
      
      case btl_end_bgm
        
      when "DB2 大魔王復活"
        bgm_stopflag = true
        se_playflag = true
      when "DB3 悟空伝"
        bgm_stopflag = true
        se_playflag = true
      when "DBZ 強襲！サイヤ人！"
        se_playflag = true
      when "DBZ外伝 サイヤ人絶滅計画"
        se_playflag = true
      when "DBZ 悟空激闘伝"
        bgm_playflag = true
      when "DBZ 超サイヤ伝説"
        bgm_stopflag = true
        se_playflag = true
      when "DBZ 超武闘伝"
        bgm_stopflag = true
        se_playflag = true
      when "DBZ 伝説の超戦士たち"
        bgm_stopflag = true
        se_playflag = true
      when "DBZ TV アイキャッチ1"
        bgm_stopflag = true
        se_playflag = true
      when "DBZ TV アイキャッチ2"
        bgm_stopflag = true
        se_playflag = true
      when "DBZ TV バトルリザルト"
        bgm_playflag = true
      when "DB TV ロマンチックあげるよ(ジングル)"
        bgm_playflag = true
      else
        
      end
      
      #BGMストップ
      if bgm_stopflag == true
        Audio.bgm_stop
      end
      
      #BGMで再生
      if bgm_playflag == true
        Audio.bgm_play("Audio/" +$option_battle_end_bgm_name)
      end
      
      #SEで再生 (BGMとかぶることもあり)
      if se_playflag == true
        Audio.se_play("Audio/" +$option_battle_end_bgm_name)
      end
    end
  end

  #--------------------------------------------------------------------------
  # ● 戦闘前曲設定
  #
  # #mode = 0:通常 = 1イベント (ボツにするかも)
  # #name = "ファイル名"
  #-------------------------------------------------------------------------- 
  def set_battle_ready_bgm_name_modetype name,mode
    
    if mode == 0
      $option_battle_ready_bgm_name = name
    else
      $option_evbattle_ready_bgm_name = name
      #ここでセットしないと曲を鳴らすときにエラーになる
      $option_battle_ready_bgm_name = $option_evbattle_ready_bgm_name
    end

  end
  
  #--------------------------------------------------------------------------
  # ● 戦闘前BGM設定
  # mode = 0:通常バトル = 1:イベント戦
  #-------------------------------------------------------------------------- 
  def set_battle_ready_bgm_name(frag_random = false,mode = 0)
    if $battle_ready_bgm != 0
      bgm_no =  $battle_ready_bgm
    else
      if mode == 0
        bgm_no = $game_variables[319] #戦闘前BGMNo
      else
        bgm_no = $game_variables[429] #イベント戦闘前BGMNo
      end
    end
    chk_battle_ready_bgm_on
    #if  bgm_no == 1 && frag_random == true
    #  bgm_no = rand($max_btl_end_bgm-1)+1
    #end

    case bgm_no
    
    when 0 #デフォルト
      case $game_variables[40]
      when 0    
        set_battle_ready_bgm_name_modetype "",mode
      when 1
        set_battle_ready_bgm_name_modetype "",mode
      when 2
        set_battle_ready_bgm_name_modetype "",mode
      when 3
      
      else
        set_battle_ready_bgm_name_modetype "",mode
      end
      return "デフォルト"
    when 1 #
      set_battle_ready_bgm_name_modetype "",mode
      return "ランダム"
    when 2
      set_battle_ready_bgm_name_modetype "DB3 戦闘前",mode
      return "DB3 悟空伝"
    when 3
      set_battle_ready_bgm_name_modetype "Z1 戦闘前",mode
      return "DBZ 強襲！サイヤ人！"
    when 4
      set_battle_ready_bgm_name_modetype "ZD カード入力待ち",mode
      return "DBZ 激闘天下一武道会"
    when 5
      set_battle_ready_bgm_name_modetype "GBZ3 戦闘前",mode
      return "DBZ 伝説の超戦士たち"
    when $bgm_no_ready_DB_wolf #DBウルフハリケーン
      set_battle_ready_bgm_name_modetype "ZArrang_wolf_ウルフハリケーン_戦闘準備",mode
      return "DB『ウルフハリケーン』"
    when $bgm_no_ready_ZPS2_Z2_heart #Z2くすぶるハート火をつけろ
      set_battle_ready_bgm_name_modetype "ZArrang_btl22_ハートに火をつけろ_戦闘準備",mode
      return "DBZ2(PS2)『くすぶるheartに火をつけろ!!』"
    when $bgm_no_ready_ZPS2_Z3_ore #Z3俺はとことん止まらない
      set_battle_ready_bgm_name_modetype "ZArrang_btl23_俺はとことん止まらない_戦闘準備",mode
      return "DBZ3(PS2)『俺はとことん止まらない』"
    when $bgm_no_ready_ZSPM_SSurvivor #スパーキングメテオ超サバイバー
      set_battle_ready_bgm_name_modetype "ZArrang_btl21_超Survivor_戦闘準備",mode
      return "DBZ Sparking! METEOR『Super Survivor』"
    when $bgm_no_ready_ZSPM_SSurvivor2 #スパーキングメテオ超サバイバー2
      set_battle_ready_bgm_name_modetype "ZArrang_btl21_超Survivor_戦闘準備2",mode
      return "DBZ Sparking! METEOR『Super Survivor2』"
    when $bgm_no_ready_ZPS3_BR_kiseki #バーストリミット奇跡の炎よ燃え上れ
      set_battle_ready_bgm_name_modetype "ZArrang_btl24_奇跡の炎よ_戦闘準備",mode
      return "DBZ バーストリミット『奇跡の炎よ 燃え上がれ!!』"
    when $bgm_no_ready_ZPS3_RB2_boo #レイジングブラスト2BattleOfOmega
      set_battle_ready_bgm_name_modetype "ZArrang_btl25_BattleOfOmega_戦闘準備",mode
      return "DBZ レイジングブラスト2『Battle of Omega』"
    when $bgm_no_ready_ZMove_brori_battlebgm #劇場版BGMブロリー戦
      set_battle_ready_bgm_name_modetype "ZArrang_btlブロリー_戦闘準備A",mode
      return "DBZ 劇場版 ブロリー戦"
    when $bgm_no_ready_ZMove_brori_battlebgm2 #劇場版BGMブロリー戦2
      set_battle_ready_bgm_name_modetype "ZArrang_btlブロリー_戦闘準備B(ストーカーちっく)",mode
      return "DBZ 劇場版 ブロリー戦2"
    when $bgm_no_ready_ZMove_ikusa #劇場版 戦 IKUSA
      set_battle_ready_bgm_name_modetype "ZArrang_btl13_戦(IKUSA)_戦闘準備",mode
      return "DBZ 劇場版『戦(I・KU・SA)』"
    when $bgm_no_ready_ZMove_marugoto #劇場版 まるごと
      set_battle_ready_bgm_name_modetype "ZArrang_btl14_まるごと_戦闘準備",mode
      return "DBZ 劇場版『まるごと』"
    when $bgm_no_ready_ZMove_genkidama #劇場版 「ヤ」なことには元気玉!!
      set_battle_ready_bgm_name_modetype "ZArrang_btl15_ヤなことは元気玉_ready",mode
      return "DBZ 劇場版『「ヤ」なことには元気玉!!』"
    when $bgm_no_ready_ZMove_saikyo #劇場版 最強対最強
      set_battle_ready_bgm_name_modetype "ZArrang_btl06_最強vs最強_戦闘準備",mode
      return "DBZ 劇場版『とびっきりの最強対最強』"
    when $bgm_no_ready_ZMove_hero #劇場版 HERO（キミがヒーロー）
      set_battle_ready_bgm_name_modetype "ZArrang_btl16_ヒーロー_戦闘準備AB",mode
      return "DBZ 劇場版『HERO(キミがヒーロー)』"
    when $bgm_no_ready_ZMove_hero2 #劇場版 HERO（キミがヒーロー）2
      set_battle_ready_bgm_name_modetype "ZArrang_btl16_ヒーロー_戦闘準備A",mode
      return "DBZ 劇場版『HERO(キミがヒーロー)2』"
    when $bgm_no_ready_ZMove_hero3 #劇場版 HERO（キミがヒーロー）3
      set_battle_ready_bgm_name_modetype "ZArrang_btl16_ヒーロー_戦闘準備B",mode
      return "DBZ 劇場版『HERO(キミがヒーロー)3』"
    when $bgm_no_ready_ZMove_girigiri #劇場版 GIRIGIRI-世界極限-
      set_battle_ready_bgm_name_modetype "ZArrang_btl17_GIRI極限_戦闘準備",mode
      return "DBZ 劇場版『GIRI GIRI -世界極限-』"
    when $bgm_no_ready_ZMove_nessen #劇場版 バーニング・ファイト-熱戦・烈戦・超激戦-
      set_battle_ready_bgm_name_modetype "ZArrang_btl18_バーニングファイト_戦闘準備C",mode
      return "DBZ 劇場版『バーニング･ファイト-熱戦･烈戦･超激戦-』"
    when $bgm_no_ready_ZMove_nessen2 #劇場版 バーニング・ファイト-熱戦・烈戦・超激戦-2
      set_battle_ready_bgm_name_modetype "ZArrang_btl18_バーニングファイト_戦闘準備A",mode
      return "DBZ 劇場版『バーニング･ファイト-熱戦･烈戦･超激戦-2』"
    when $bgm_no_ready_ZMove_nessen3 #劇場版 バーニング・ファイト-熱戦・烈戦・超激戦-3
      set_battle_ready_bgm_name_modetype "ZArrang_btl18_バーニングファイト_戦闘準備B",mode
      return "DBZ 劇場版『バーニング･ファイト-熱戦･烈戦･超激戦-3』"
    when $bgm_no_ready_ZMove_raizing #劇場版 銀河を超えてライジング・ハイ
      set_battle_ready_bgm_name_modetype "ZArrang_btl19_銀河を超えて_戦闘準備",mode
      return "DBZ 劇場版『銀河を超えてライジング･ハイ』"
    when $bgm_no_battle_ready_Original1 #戦闘前曲オリジナル1
      set_battle_ready_bgm_name_modetype $btl_ready_user_name + "1",mode
      return "ユーザー設定1"
    when $bgm_no_battle_ready_Original2  #戦闘前曲オリジナル2
      set_battle_ready_bgm_name_modetype $btl_ready_user_name + "2",mode
      return "ユーザー設定2"
    when $bgm_no_battle_ready_Original3  #戦闘前曲オリジナル3
      set_battle_ready_bgm_name_modetype $btl_ready_user_name + "3",mode
      return "ユーザー設定3"
    when $bgm_no_battle_ready_Original4  #戦闘前曲オリジナル4
      set_battle_ready_bgm_name_modetype $btl_ready_user_name + "4",mode
      return "ユーザー設定4"
    when $bgm_no_battle_ready_Original5  #戦闘前曲オリジナル5
      set_battle_ready_bgm_name_modetype $btl_ready_user_name + "5",mode
      return "ユーザー設定5"
    else
      return "未設定"
    end
  end

  #--------------------------------------------------------------------------
  # ● 戦闘終了後BGM設定
  #-------------------------------------------------------------------------- 
  def set_battle_end_bgm_name(frag_random = false)
    bgm_no = $game_variables[103]
    
    if  bgm_no == 1 && frag_random == true
      bgm_no = rand($max_btl_end_bgm-1)+1
    end

    case bgm_no
    
    when 0 #デフォルト
      case $game_variables[40]
      when 0    
        $option_battle_end_bgm_name = ""
      when 1
        $option_battle_end_bgm_name = ""
      when 2
        $option_battle_end_bgm_name = ""
      when 3
      
      else
        $option_battle_end_bgm_name = ""
      end
      return "デフォルト"
    when 1 #
      $option_battle_end_bgm_name = ""
      return "ランダム"
    #when 2 #DB1 フィールド
    #  $option_menu_bgm_name = "DB1 イベント1"
    #  return "DB 神龍の謎"
    when 2
      $option_battle_end_bgm_name = "SE/DB2 戦闘終了"
      return "DB2 大魔王復活"
    when 3
      $option_battle_end_bgm_name = "SE/DB3 戦闘終了"
      return "DB3 悟空伝"
    when 4
      $option_battle_end_bgm_name = "SE/Z1 完了"
      return "DBZ 強襲！サイヤ人！"
    when 5
      $option_battle_end_bgm_name = "SE/ZG 戦闘終了"
      return "DBZ外伝 サイヤ人絶滅計画"
    when 6
      $option_battle_end_bgm_name = "BGM/GBZ2 戦闘終了"
      return "DBZ 悟空激闘伝"
    when 7
      $option_battle_end_bgm_name = "SE/ZSSD 戦闘終了"
      return "DBZ 超サイヤ伝説"
    when 8
      $option_battle_end_bgm_name = "SE/ZSB1 戦闘終了2"
      return "DBZ 超武闘伝"
    when 9
      $option_battle_end_bgm_name = "SE/GBZ3 戦闘勝利"
      return "DBZ 伝説の超戦士たち"
    when 10
      $option_battle_end_bgm_name = "BGM/ZArrang_cm1out_アイキャッチ1b"
      return "DBZ TV アイキャッチ1"
    when 11
      $option_battle_end_bgm_name = "BGM/ZArrang_cm2out_アイキャッチ2b"
      return "DBZ TV アイキャッチ2"
    when 12
      $option_battle_end_bgm_name = "BGM/ZArrang_btlresult_バトルリザルト(仮"
      return "DBZ TV バトルリザルト"
    when 13
      $option_battle_end_bgm_name = "BGM/ZArrang_db_ロマンチックCジングル"
      return "DB TV ロマンチックあげるよ(ジングル)"
    #when 6
    #  $option_menu_bgm_name = "Z2 カード選択"
    #  return "DBZ2 激神フリーザ！！"
    #when 7
    #  $option_menu_bgm_name = "ZG メニュー"
    #  return "DBZ3 烈戦人造人間/DBZ外伝 サイヤ人絶滅計画"
    #when 8
    #  $option_menu_bgm_name = "ZD メニュー"
    #  return "DBZ 激闘天下一武道会"
    #when 9
    #  title_name = "デフォルト"
    #  return "？？？"
    #when 10
    #  title_name = "デフォルト"
    #  return "？？？"
    #when 11
    #  title_name = "デフォルト"
    #  return "？？？"
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 行動選択BGM設定
  #-------------------------------------------------------------------------- 
  def set_action_sel_bgm_name
    bgm_no = $game_variables[475]

    case bgm_no
    
    when 0 #デフォルト
      $option_action_sel_bgm_name = "ZUB_キャラクターセレクト"
      return "DBZ アルティメットバトル22 キャラ選択"
    when 1 #DB2マップ
      $option_action_sel_bgm_name = "DB2 フィールド"
      return "DB2 大魔王復活 フィールド"
    when 2 #DB1 フィールド
      $option_action_sel_bgm_name = "DB3 フィールド"
      return "DB3 悟空伝 フィールド"
    when 3
      $option_action_sel_bgm_name = "FCJ1 フィールド1"
      return "ファミコンジャンプ1 英雄列伝 フィールド"
    when 4
      $option_action_sel_bgm_name = "FCJ2 フィールド2"
      return "ファミコンジャンプ2 最強の7人 フィールド"
    
      
    ########ここの曲数を増やしたら「chk_action_sel_bgm_on」のループ数を変更すること
      
    when $bgm_no_action_sel_Original1  #戦闘曲オリジナル1
      $option_action_sel_bgm_name = $action_sel_user_name + "1"
      return "ユーザー設定1"
    when $bgm_no_action_sel_Original2  #戦闘曲オリジナル2
      $option_action_sel_bgm_name = $action_sel_user_name + "2"
      return "ユーザー設定2"
    when $bgm_no_action_sel_Original3  #戦闘曲オリジナル3
      $option_action_sel_bgm_name = $action_sel_user_name + "3"
      return "ユーザー設定3"
    when $bgm_no_action_sel_Original4  #戦闘曲オリジナル4
      $option_action_sel_bgm_name = $action_sel_user_name + "4"
      return "ユーザー設定4"
    when $bgm_no_action_sel_Original5  #戦闘曲オリジナル5
      $option_action_sel_bgm_name = $action_sel_user_name + "5"
      return "ユーザー設定5"
    end
    
    
  end
  
  #--------------------------------------------------------------------------
  # ● 行動選択ＢＧＭ使用可能かチェック
  #-------------------------------------------------------------------------- 
  def chk_action_sel_bgm_on
    #シナリオ進行度によってファイル名の頭文字を変える
    chk_scenario_progress
    
    for x in 0..$max_action_sel_bgm
      
      if 4 >= x #ここはset_action_sel_bgm_nameの定義曲数をsetする
        $action_sel_bgm_on[x] = true
      else
        $action_sel_bgm_on[x] = false
      end
      
    end
    
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $action_sel_user_name + "1.ogg") 
      $action_sel_bgm_on[$bgm_no_action_sel_Original1] = true
    end
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $action_sel_user_name + "2.ogg") 
      $action_sel_bgm_on[$bgm_no_action_sel_Original2] = true
    end
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $action_sel_user_name + "3.ogg") 
      $action_sel_bgm_on[$bgm_no_action_sel_Original3] = true
    end
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $action_sel_user_name + "4.ogg") 
      $action_sel_bgm_on[$bgm_no_action_sel_Original4] = true
    end
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $action_sel_user_name + "5.ogg") 
      $action_sel_bgm_on[$bgm_no_action_sel_Original5] = true
    end
  end
  #--------------------------------------------------------------------------
  # ● メニュー設定
  #-------------------------------------------------------------------------- 
  def set_menu_bgm_name(frag_random = false)
    bgm_no = $game_variables[36]
    
=begin
    if  bgm_no == 1 && frag_random == true
      chk_scenario_progress

      bgm_no = rand($max_menu_bgm-1)+2
    end
=end
    
    if  bgm_no == 1 && frag_random == true
      chk_scenario_progress

      chk_menu_bgm_on
      loop_end = false
      loop_num = 0
      begin
        
         bgm_no = rand($max_set_menu_bgm-2)+2
         $bgm_menu_random_flag[bgm_no] = 1 if $bgm_menu_random_flag[bgm_no] == nil
         #p $menu_bgm_on[bgm_no],$bgm_menu_random_flag[bgm_no]
         if $menu_bgm_on[bgm_no] == true && $bgm_menu_random_flag[bgm_no] == 1
           loop_end = true
         end
         #p bgm_no,$max_set_battle_bgm,$battle_bgm_on[bgm_no] ,loop_end
         
         loop_num += 1
         
         if loop_num >= 1000 #全てのフラグがＯＦＦだと思われる場合は処理を抜けてデフォルト曲を流す
           loop_end = true
           bgm_no = 0
         end
       end while loop_end == false

     end
    
    
    if $game_switches[111] == true
      $option_menu_bgm_name = "ZArrang_ソリッドステートスカウター2"
      return "DBZ TVSP ソリッドステートスカウター(Full2)"
    end

    case bgm_no
    
    when 0 #デフォルト
      case $game_variables[40]
      when 0    
        $option_menu_bgm_name = "Z1 メニュー"
      when 1
        $option_menu_bgm_name = "Z2 カード選択"
      when 2
        $option_menu_bgm_name = "ZG メニュー"
      when 3
      
      else
        $option_menu_bgm_name = "Z1 メニュー"
      end
      return "デフォルト"
    when 1 #
      $option_menu_bgm_name = ""
      return "ランダム"
    when 2 #DB1 フィールド
      $option_menu_bgm_name = "DB1 イベント1"
      return "DB 神龍の謎"
    when 3
      $option_menu_bgm_name = "DB2 カード選択"
      return "DB2 大魔王復活"
    when 4
      $option_menu_bgm_name = "DB3 メニュー"
      return "DB3 悟空伝"
    when 5
      $option_menu_bgm_name = "Z1 メニュー"
      return "DBZ 強襲！サイヤ人！"
    when 6
      $option_menu_bgm_name = "Z2 カード選択"
      return "DBZ2 激神フリーザ！！"
    when 7
      $option_menu_bgm_name = "ZG メニュー"
      return "DBZ3 烈戦人造人間/DBZ外伝 サイヤ人絶滅計画"
    when 8
      $option_menu_bgm_name = "ZD メニュー"
      return "DBZ 激闘天下一武道会"
    when 9
      $option_menu_bgm_name = "デフォルト"
      return "？？？"
    when 10
      $option_menu_bgm_name = "デフォルト"
      return "？？？"
    when 11
      $option_menu_bgm_name = "デフォルト"
      return "？？？"
    when 51
      $option_menu_bgm_name = "ZSSD 家1(FC音源Ver)"
      return "DBZ 超サイヤ伝説 民家(地球)"
    when 52
      $option_menu_bgm_name = "ZSSD 家2"
      return "DBZ 超サイヤ伝説 民家(ナメック星)"
    when 56
      $option_menu_bgm_name = "ZSB1 キャラセレクト"
      return "DBZ 超武闘伝"
    when 61
      $option_menu_bgm_name = "ZSA1 ちょっとひといき‥"
      return "DBZ 超悟空伝 突激編"
    when 62
      $option_menu_bgm_name = "ZSA2 BGM00(GB音源Ver)"
      return "DBZ 超悟空伝 覚醒編"    
    when 101
      $option_menu_bgm_name = "FCJ1 メニュー"
      return "ファミコンジャンプ1 英雄列伝"
    
    when $bgm_no_menu_Original1  #戦闘曲オリジナル1

      $option_menu_bgm_name = $menu_user_name + "1"
      return "ユーザー設定1"
    when $bgm_no_menu_Original2  #戦闘曲オリジナル2
      $option_menu_bgm_name = $menu_user_name + "2"
      return "ユーザー設定2"
    when $bgm_no_menu_Original3  #戦闘曲オリジナル3
      $option_menu_bgm_name = $menu_user_name + "3"
      return "ユーザー設定3"
    when $bgm_no_menu_Original4  #戦闘曲オリジナル4
      $option_menu_bgm_name = $menu_user_name + "4"
      return "ユーザー設定4"
    when $bgm_no_menu_Original5  #戦闘曲オリジナル5
      $option_menu_bgm_name = $menu_user_name + "5"
      return "ユーザー設定5"
    end
    
    
  end
  #--------------------------------------------------------------------------
  # ● メニューＢＧＭ使用可能かチェック
  #-------------------------------------------------------------------------- 
  def chk_menu_bgm_on
    #シナリオ進行度によってファイル名の頭文字を変える
    chk_scenario_progress
    
    for x in 0..$max_set_menu_bgm
      
      if $max_menu_bgm >= x
        $menu_bgm_on[x] = true
      else
        $menu_bgm_on[x] = false
      end
      
    end
    
    if $game_variables[40] >= 0 || $game_switches[860] == true #ベジータ編
      $menu_bgm_on[51] = true #DBZ 超サイヤ伝説 民家(地球)
      $menu_bgm_on[61] = true #ZSA1 ちょっとひといき‥
      $menu_bgm_on[101] = true #ファミコンジャンプ1 英雄列伝
    end
    if $game_variables[40] >= 1 || $game_switches[860] == true #フリーザ編
      $menu_bgm_on[52] = true #DBZ 超サイヤ伝説 民家(ナメック星)
      $menu_bgm_on[62] = true #ZSA2 BGM00(GB音源Ver)
    end
    if $game_variables[40] >= 2 || $game_switches[860] == true #人造人間編
      $menu_bgm_on[56] = true #ZSB1 キャラセレクト
    end
    
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $menu_user_name + "1.ogg") 
      $menu_bgm_on[$bgm_no_menu_Original1] = true
    end
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $menu_user_name + "2.ogg") 
      $menu_bgm_on[$bgm_no_menu_Original2] = true
    end
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $menu_user_name + "3.ogg") 
      $menu_bgm_on[$bgm_no_menu_Original3] = true
    end
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $menu_user_name + "4.ogg") 
      $menu_bgm_on[$bgm_no_menu_Original4] = true
    end
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $menu_user_name + "5.ogg") 
      $menu_bgm_on[$bgm_no_menu_Original5] = true
    end
  end
  #--------------------------------------------------------------------------
  # ● バトルＢＧＭ使用可能かチェック
  #-------------------------------------------------------------------------- 
  def chk_battle_bgm_on
    
    #シナリオ進行度によってファイル名の頭文字を変える
    chk_scenario_progress
    
    for x in 0..$max_set_battle_bgm
      
      if $max_battle_bgm >= x
        $battle_bgm_on[x] = true
      else
        $battle_bgm_on[x] = false
      end
      
    end
    
    #Z1
    if $game_switches[45] == false #ラディッツ撃破前であれば、ガーリックとボス戦の曲をオフ
       $battle_bgm_on[9] = false
       $battle_bgm_on[10] = false
    end
    if $game_switches[68] == false #ベジータ撃破前であれば、ベジータ戦の曲をオフ
       $battle_bgm_on[11] = false
    end
    #GBZ1
    if $game_variables[40] >= 0 || $game_switches[860] == true
      for x in 31..35
        $battle_bgm_on[x] = true
      end
    end
    #GBZ2
    if $game_variables[40] >= 1 || $game_switches[860] == true
      for x in 36..40
        $battle_bgm_on[x] = true
      end
    end
    
    if $game_switches[109] || $game_switches[860] == true #バーダック仲間にした(ターレススラッグ倒した)
      $battle_bgm_on[20] = true #ZGボス戦2
    end
    
    if $game_switches[599] == true || $game_switches[586] == true || $game_switches[860] == true #ZG初回のザコ撃破
      $battle_bgm_on[19] = true #ZGボス戦1
    end
    
    if $game_switches[598] == true || $game_switches[586] == true || $game_switches[860] == true #ZGバーダック一味編フリーザ倒した
      $battle_bgm_on[17] = true #ZG通常戦闘
      $battle_bgm_on[18] = true #ZG通常戦闘2
    end
    
    if $game_switches[846] == true || $game_switches[586] == true || $game_switches[860] == true #ZGライチー倒したまたは外伝クリアした
      $battle_bgm_on[21] = true #ZGボス戦3
    end
    
    if $game_switches[151] #超サイヤ通常
      $battle_bgm_on[$bgm_no_ZSSD_battle1] = true
    end
    
    if $game_switches[152] #超サイヤボス
      $battle_bgm_on[$bgm_no_ZSSD_battle2] = true
    end
    
    if $game_switches[153] #ソリッド
      $battle_bgm_on[$bgm_no_ZTVSP_sorid] = true
    end
    
    if $game_switches[154] #劇場版BGM1
      $battle_bgm_on[$bgm_no_ZMove_bgm1] = true
    end
    if $game_switches[713] #劇場版BGM1_ver2
      $battle_bgm_on[$bgm_no_ZMove_bgm1_2] = true
    end
    
    
    if $game_switches[155] #めざせ天下一
      $battle_bgm_on[$bgm_no_DB_mezatenka] = true
    end
    
    if $game_switches[731] #Z2通常戦闘1(VRC6)
      $battle_bgm_on[$bgm_no_Z2_battle1_arrange1] = true
    end   
    
    if $game_switches[156] #超サイヤ通常(GB音源)
      $battle_bgm_on[$bgm_no_ZSSD_battle1_for_gb] = true
    end
    
    if $game_switches[157] #超サイヤ修行(GB音源)
      $battle_bgm_on[$bgm_no_ZSSD_training_for_gb] = true
    end
    
    if $game_switches[158] #超武闘伝ピッコロのテーマ(GB音源)
      $battle_bgm_on[$bgm_no_ZSB1_pikkoro_for_gb] = true
    end
    
    if $game_switches[162] #超武闘伝フリーザのテーマ(GXSCC音源)
      $battle_bgm_on[$bgm_no_ZSB1_freezer_for_gxscc] = true
    end
    
    if $game_switches[159] #超武闘伝20号のテーマ(GXSCC音源)
      $battle_bgm_on[$bgm_no_ZSB1_20gou_for_gxscc] = true
    end
    
    if $game_switches[160] #超武闘伝18号のテーマ(GXSCC音源)
      $battle_bgm_on[$bgm_no_ZSB1_18gou_for_gxscc] = true
    end
    
    if $game_switches[732] #超武闘伝セルのテーマ
      $battle_bgm_on[$bgm_no_ZSB1_cell] = true
    end
    
    if $game_switches[161] #超武闘伝16号のテーマ(GB音源)
      $battle_bgm_on[$bgm_no_ZSB1_16gou_for_gb] = true
    end
    
    if $game_switches[163] #超武闘伝2ピッコロのテーマ(GB音源)
      $battle_bgm_on[$bgm_no_ZSB2_pikkoro_for_gb] = true
    end
    
    if $game_switches[164] #ファミコンジャンプ1 戦闘1
      $battle_bgm_on[$bgm_no_FCJ1_battle1] = true
    end
    
    if $game_switches[165] #ファミコンジャンプ1 戦闘2
      $battle_bgm_on[$bgm_no_FCJ1_battle2] = true
    end
    
    if $game_switches[166] #ファミコンジャンプ1 戦闘3
      $battle_bgm_on[$bgm_no_FCJ1_battle3] = true
    end
    
    if $game_switches[167] #ファミコンジャンプ1 戦闘4
      $battle_bgm_on[$bgm_no_FCJ1_battle4] = true
    end
    
    if $game_switches[168] #ファミコンジャンプ1 戦闘1
      $battle_bgm_on[$bgm_no_FCJ2_battle1] = true
    end
    
    if $game_switches[169] #ファミコンジャンプ2 戦闘2
      $battle_bgm_on[$bgm_no_FCJ2_battle2] = true
    end
    
    if $game_switches[170] #劇場版BGM1(Full
      $battle_bgm_on[$bgm_no_ZMove_bgm1_full] = true
    end
    
    if $game_switches[171] #ソリッド_Full
      $battle_bgm_on[$bgm_no_ZTVSP_sorid_full] = true
    end
    
    if $game_switches[172] #ソリッド_Full2
      $battle_bgm_on[$bgm_no_ZTVSP_sorid_full2] = true
    end

    if $game_switches[718] #ソリッド_2
      $battle_bgm_on[$bgm_no_ZTVSP_sorid_2] = true
    end
    
    if $game_switches[719] #ソリッド_Full3
      $battle_bgm_on[$bgm_no_ZTVSP_sorid_full3] = true
    end
    
    if $game_switches[722] #死を呼ぶセルゲーム
      $battle_bgm_on[$bgm_no_ZTV_cellgame] = true
    end
    
    if $game_switches[726] #運命の日 魂vs魂
      $battle_bgm_on[$bgm_no_ZTV_tamashiivs1] = true
    end
    
    if $game_switches[727] #運命の日 魂vs魂2
      $battle_bgm_on[$bgm_no_ZTV_tamashiivs2] = true
    end
    
    if $game_switches[173] #超武闘伝2ベジータのテーマ(GB音源)
      $battle_bgm_on[$bgm_no_ZSB2_bejita_for_gb] = true
    end
    
    if $game_switches[174] #超超悟空伝1ビッグファイト(GB)
      $battle_bgm_on[$bgm_no_ZSA1_big_fight_for_gb] = true
    end
    
    if $game_switches[175] #超超悟空伝2_bgm01(GB)
      $battle_bgm_on[$bgm_no_ZSA2_bgm01_for_gb] = true
    end
    
    if $game_switches[176] #超超悟空伝2_bgm02(GB)
      $battle_bgm_on[$bgm_no_ZSA2_bgm02_for_gb] = true
    end
    
    if $game_switches[177] #超超悟空伝2_bgm06(GB)
      $battle_bgm_on[$bgm_no_ZSA2_bgm06_for_gb] = true
    end
    
    if $game_switches[178] #超超悟空伝2_bgm16(GB)
      $battle_bgm_on[$bgm_no_ZSA2_bgm16_for_gb] = true
    end

    if $game_switches[179] #超武闘伝2悟飯のテーマ(gxscc音源)
      $battle_bgm_on[$bgm_no_ZSB2_gohan_for_gxscc] = true
    end
    if $game_switches[721] #超武闘伝3悟空のテーマ
      $battle_bgm_on[$bgm_no_ZSB3_goku] = true
    end
    
    if $game_switches[180] #UB22ロイヤルガード
      $battle_bgm_on[$bgm_no_ZUB_royal_guard] = true
    end
    
    if $game_switches[181] #UB22光のWILL POWER
      $battle_bgm_on[$bgm_no_ZUB_will_power] = true
    end
    
    if $game_switches[733] #UB22絶体絶命
      $battle_bgm_on[$bgm_no_ZUB_zetumei] = true
    end
    
    if $game_switches[736] #UB22絶体絶命2
      $battle_bgm_on[$bgm_no_ZUB_zetumei2] = true
    end
    
    if $game_switches[182] #偉大なるドラゴンボール伝説 BGM01
      $battle_bgm_on[$bgm_no_ZID_bgm01] = true
    end
    
    if $game_switches[183] #偉大なるドラゴンボール伝説 BGM02
      $battle_bgm_on[$bgm_no_ZID_bgm02] = true
    end
    if $game_switches[184] #最強対最強
      $battle_bgm_on[$bgm_no_ZMove_saikyo] = true
      $battle_bgm_on[$bgm_no_ZMove_saikyo_btl] = true
    end
    if $game_switches[185] #戦 IKUSA
      $battle_bgm_on[$bgm_no_ZMove_ikusa] = true
      $battle_bgm_on[$bgm_no_ZMove_ikusa_btl] = true
    end
    if $game_switches[186] #メタルクウラ戦
      $battle_bgm_on[$bgm_no_ZMove_metarukuura_battlebgm] = true
    end
    if $game_switches[725] #メタルクウラ戦2
      $battle_bgm_on[$bgm_no_ZMove_metarukuura_battlebgm2] = true
    end
    if $game_switches[735] #メタルクウラ戦3
      $battle_bgm_on[$bgm_no_ZMove_metarukuura_battlebgm3] = true
    end
    if $game_switches[187] #HEROキミがヒーロー
      $battle_bgm_on[$bgm_no_ZMove_hero] = true
      $battle_bgm_on[$bgm_no_ZMove_hero_btl] = true
    end
    if $game_switches[188] #GIRIGIRI-世界極限-
      $battle_bgm_on[$bgm_no_ZMove_girigiri] = true
      $battle_bgm_on[$bgm_no_ZMove_girigiri_btl] = true
    end
    if $game_switches[189] #バーニング･ファイト-熱戦･烈戦･超激戦-
      $battle_bgm_on[$bgm_no_ZMove_nessen] = true
      $battle_bgm_on[$bgm_no_ZMove_nessen_btl] = true
      
    end
    
    if $game_switches[724] #バーニング･ファイト-熱戦･烈戦･超激戦- ver2
      $battle_bgm_on[$bgm_no_ZMove_nessen_btl2] = true
    end
    
    if $game_switches[190] #銀河を超えてライジング･ハイ
      $battle_bgm_on[$bgm_no_ZMove_raizing] = true
      $battle_bgm_on[$bgm_no_ZMove_raizing_btl] = true
    end
    if $game_switches[714] #ボージャック一味戦 命がけのベジータ
      $battle_bgm_on[$bgm_no_ZMove_M1619] = true
      $battle_bgm_on[$bgm_no_ZMove_M1619_btl] = true
    end
    if $game_switches[191] #まるごと
      $battle_bgm_on[$bgm_no_ZMove_marugoto] = true
      $battle_bgm_on[$bgm_no_ZMove_marugoto_btl] = true
    end
    if $game_switches[192] #「ヤ」なことには元気玉!!
      $battle_bgm_on[$bgm_no_ZMove_genkidama] = true
      $battle_bgm_on[$bgm_no_ZMove_genkidama_btl] = true
    end
    if $game_switches[734] #「ヤ」なことには元気玉!!2
      $battle_bgm_on[$bgm_no_ZMove_genkidama2] = true
      $battle_bgm_on[$bgm_no_ZMove_genkidama_btl2] = true
    end
    if $game_switches[193] #13号戦
      $battle_bgm_on[$bgm_no_ZMove_zinzouningen_battlebgm] = true
    end
    if $game_switches[194] #ドラゴンボール伝説
      $battle_bgm_on[$bgm_no_DB_dbdensetu] = true
    end
    if $game_switches[195] #くすぶるハートに火をつけろ
      $battle_bgm_on[$bgm_no_ZPS2_Z2_heart] = true
      $battle_bgm_on[$bgm_no_ZPS2_Z2_heart_btl] = true
    end
    
    if $game_switches[196] #俺はとことん止まらない
      $battle_bgm_on[$bgm_no_ZPS2_Z3_ore] = true
      $battle_bgm_on[$bgm_no_ZPS2_Z3_ore_btl] = true
    end
    
    if $game_switches[728] #俺はとことん止まらないbtl2
      $battle_bgm_on[$bgm_no_ZPS2_Z3_ore_btl2] = true
    end
    
    if $game_switches[197] #超サバイバー
      $battle_bgm_on[$bgm_no_ZSPM_SSurvivor] = true
      $battle_bgm_on[$bgm_no_ZSPM_SSurvivor_btl] = true
    end
    
    if $game_switches[729] #超サバイバーbtl ver2
      $battle_bgm_on[$bgm_no_ZSPM_SSurvivor_btl2] = true
    end
    
    if $game_switches[198] #奇跡の炎よ燃え上れ
      $battle_bgm_on[$bgm_no_ZPS3_BR_kiseki] = true
      $battle_bgm_on[$bgm_no_ZPS3_BR_kiseki_btl] = true
    end
    
    if $game_switches[199] #battleofomega
      $battle_bgm_on[$bgm_no_ZPS3_RB2_boo] = true
      $battle_bgm_on[$bgm_no_ZPS3_RB2_boo_btl] = true
    end
    
    if $game_switches[200] #ブロリー戦
      $battle_bgm_on[$bgm_no_ZMove_brori_battlebgm] = true
      $battle_bgm_on[$bgm_no_ZMove_brori_battlebgm_btl] = true
    end
    
    if $game_switches[702] #ウルフハリケーン
      $battle_bgm_on[$bgm_no_DB_wolf] = true
      $battle_bgm_on[$bgm_no_DB_wolf2] = true
      $battle_bgm_on[$bgm_no_DB_wolf3] = true
      $battle_bgm_on[$bgm_no_DB_wolf_btl] = true
    end
    
    if $game_switches[703] #レッドリボン軍戦
      $battle_bgm_on[$bgm_no_DB_m109] = true
    end
    
    if $game_switches[704] #不明(戦闘)
      $battle_bgm_on[$bgm_no_DB_m422] = true
    end
    
    if $game_switches[705] #テンシンハン戦
      $battle_bgm_on[$bgm_no_DB_m441] = true
    end
    
    if $game_switches[706] #クウラ戦
      $battle_bgm_on[$bgm_no_ZMove_M1216] = true
    end

    if $game_switches[707] #ガーリック戦
      $battle_bgm_on[$bgm_no_ZMove_M814A] = true
    end

    if $game_switches[708] #戦 IKUSA2
      $battle_bgm_on[$bgm_no_ZMove_ikusa2] = true
      $battle_bgm_on[$bgm_no_ZMove_ikusa_btl2] = true
    end
    
    if $game_switches[709] #まるごと2
      $battle_bgm_on[$bgm_no_ZMove_marugoto2] = true
    end
    if $game_switches[710] #HEROキミがヒーロー
      $battle_bgm_on[$bgm_no_ZMove_hero2] = true
      $battle_bgm_on[$bgm_no_ZMove_hero_btl2] = true
    end
    if $game_switches[711] #銀河を超えてライジング･ハイ
      $battle_bgm_on[$bgm_no_ZMove_raizing2] = true
    end
    if $game_switches[712] #戦 IKUSA3
      $battle_bgm_on[$bgm_no_ZMove_ikusa3] = true
    end
    
    if $game_switches[716] #ドラゴンボールファイターズナメック星ノテーマ
      $battle_bgm_on[$bgm_no_ZFZ1_namek_btl] = true
    end
    if $game_switches[717] #ドラゴンボールファイターズバーダックのテーマ
      $battle_bgm_on[$bgm_no_ZFZ1_bardak_btl] = true
    end
    if $game_switches[715] #DKN バーダック(超サイヤ人)
      $battle_bgm_on[$bgm_no_DKN_tyoubardak_btl] = true
    end
    if $game_switches[720] #恐怖のギニュー特戦隊!!
      $battle_bgm_on[$bgm_no_ZTV_kyouhug2] = true
    end
    if $game_switches[730] #ワイワイワールド
      $battle_bgm_on[$bgm_no_waiwai] = true
    end
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $btl_user_name + "1.ogg") 
      $battle_bgm_on[$bgm_no_battle_Original1] = true
    end
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $btl_user_name + "2.ogg") 
      $battle_bgm_on[$bgm_no_battle_Original2] = true
    end
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $btl_user_name + "3.ogg") 
      $battle_bgm_on[$bgm_no_battle_Original3] = true
    end
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $btl_user_name + "4.ogg") 
      $battle_bgm_on[$bgm_no_battle_Original4] = true
    end
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $btl_user_name + "5.ogg") 
      $battle_bgm_on[$bgm_no_battle_Original5] = true
    end
  
  end
  
 #--------------------------------------------------------------------------
  # ● バトル前ＢＧＭ使用可能かチェック
  #-------------------------------------------------------------------------- 
  def chk_battle_ready_bgm_on
    
    #シナリオ進行度によってファイル名の頭文字を変える
    chk_scenario_progress
    
    #フラグをすべて無効か
    for x in 0..$max_btl_ready_bgm
      $battle_ready_bgm_on[x] = false
    end
    
    #デフォルト～DBZ 伝説の超戦士たちまで 
    $battle_ready_bgm_on[0] = true
    $battle_ready_bgm_on[1] = false
    $battle_ready_bgm_on[2] = true
    $battle_ready_bgm_on[3] = true
    $battle_ready_bgm_on[4] = true
    $battle_ready_bgm_on[5] = true
    
    if $game_switches[702] #ウルフハリケーン
      $battle_ready_bgm_on[$bgm_no_ready_DB_wolf] = true
    end
    
    if $game_switches[184] #最強対最強
      $battle_ready_bgm_on[$bgm_no_ready_ZMove_saikyo] = true
    end
    if $game_switches[185] #戦 IKUSA
      $battle_ready_bgm_on[$bgm_no_ready_ZMove_ikusa] = true
    end
    if $game_switches[187] #HEROキミがヒーロー
      $battle_ready_bgm_on[$bgm_no_ready_ZMove_hero] = true
    end
    if $game_switches[188] #GIRIGIRI-世界極限-
      $battle_ready_bgm_on[$bgm_no_ready_ZMove_girigiri] = true
    end
    if $game_switches[189] #バーニング･ファイト-熱戦･烈戦･超激戦-
      $battle_ready_bgm_on[$bgm_no_ready_ZMove_nessen] = true
    end
    
    if $game_switches[724] #バーニング･ファイト-熱戦･烈戦･超激戦- ver2
      $battle_ready_bgm_on[$bgm_no_ready_ZMove_nessen2] = true
      $battle_ready_bgm_on[$bgm_no_ready_ZMove_nessen3] = true
    end
    
    if $game_switches[190] #銀河を超えてライジング･ハイ
      $battle_ready_bgm_on[$bgm_no_ready_ZMove_raizing] = true
    end
    
    if $game_switches[191] #まるごと
      $battle_ready_bgm_on[$bgm_no_ready_ZMove_marugoto] = true
    end

    if $game_switches[192] #「ヤ」なことには元気玉!!
      $battle_ready_bgm_on[$bgm_no_ready_ZMove_genkidama] = true
    end
    
    if $game_switches[195] #くすぶるハートに火をつけろ
      $battle_ready_bgm_on[$bgm_no_ready_ZPS2_Z2_heart] = true
    end
    
    if $game_switches[196] #俺はとことん止まらない
      $battle_ready_bgm_on[$bgm_no_ready_ZPS2_Z3_ore] = true
    end
    
    if $game_switches[197] #超サバイバー
      $battle_ready_bgm_on[$bgm_no_ready_ZSPM_SSurvivor] = true
    end
    
    if $game_switches[729] #超サバイバーver2
      $battle_ready_bgm_on[$bgm_no_ready_ZSPM_SSurvivor2] = true
    end
    if $game_switches[198] #奇跡の炎よ燃え上れ
      $battle_ready_bgm_on[$bgm_no_ready_ZPS3_BR_kiseki] = true
    end
    
    if $game_switches[199] #battleofomega
      $battle_ready_bgm_on[$bgm_no_ready_ZPS3_RB2_boo] = true
    end
    
    if $game_switches[200] #ブロリー戦
      $battle_ready_bgm_on[$bgm_no_ready_ZMove_brori_battlebgm] = true
    end
    
    if $game_switches[723] #ブロリー戦ver2
      $battle_ready_bgm_on[$bgm_no_ready_ZMove_brori_battlebgm2] = true
    end
    
    if $game_switches[710] #HEROキミがヒーロー
      $battle_ready_bgm_on[$bgm_no_ready_ZMove_hero2] = true
      $battle_ready_bgm_on[$bgm_no_ready_ZMove_hero3] = true
    end
    
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $btl_ready_user_name + "1.ogg") 
      $battle_ready_bgm_on[$bgm_no_battle_ready_Original1] = true
    end
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $btl_ready_user_name + "2.ogg") 
      $battle_ready_bgm_on[$bgm_no_battle_ready_Original2] = true
    end
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $btl_ready_user_name + "3.ogg") 
      $battle_ready_bgm_on[$bgm_no_battle_ready_Original3] = true
    end
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $btl_ready_user_name + "4.ogg") 
      $battle_ready_bgm_on[$bgm_no_battle_ready_Original4] = true
    end
    if FileTest.exist?(Dir.pwd + "/Audio/MYBGM/" + $btl_ready_user_name + "5.ogg") 
      $battle_ready_bgm_on[$bgm_no_battle_ready_Original5] = true
    end
  
  end
  #--------------------------------------------------------------------------
  # ● 戦闘高速化ＯＮＯＦＦ管理
  #--------------------------------------------------------------------------
  def input_battle_fast_fps
    if $fast_fps == false
      
      if $game_variables[303] == 0
        if Input.press?(Input::C)
          if $game_variables[40] >= 2
            Graphics.frame_rate = 100 #90
            $fast_fps_count += 1
            if $fast_fps_count == 5
              $fast_fps_count = 0
              Graphics.frame_count -= 2 
            end
          else
            Graphics.frame_rate = 90
            $fast_fps_count += 1
            if $fast_fps_count == 3
              $fast_fps_count = 0
              Graphics.frame_count -= 1 
            end
          end
        else
          Graphics.frame_rate = 60
          $fast_fps_count = 0
        end
      else
        if Input.press?(Input::C)
          Graphics.frame_rate = 60
          $fast_fps_count = 0
        else
          if $game_variables[40] >= 2
            Graphics.frame_rate = 100 #90
            $fast_fps_count += 1
            if $fast_fps_count == 5
              $fast_fps_count = 0
              Graphics.frame_count -= 2 
            end
          else
            Graphics.frame_rate = 90
            $fast_fps_count += 1
            if $fast_fps_count == 3
              $fast_fps_count = 0
              Graphics.frame_count -= 1 
            end
          end
        end
      end
    end
    
  end
  
  #カード値変更
  def allcardexchange
    for x in 0..$Cardmaxnum
      $create_card_num = x #未使用生成するカードの位置 create_card_iの光の旅で必要で今更引数を増やせないのでここで変数を作る
      $carda[x]=rand(8)
      $cardg[x]=rand(8)
      $cardi[x]=create_card_i 0
      #if (createcardval_chk x) == true
      #  redo #ジャンプ元
      #end
    end

  end
  #--------------------------------------------------------------------------
  # ● カード生成
  # x:カード何枚目か
  #--------------------------------------------------------------------------
  # カード値生成
  def createcardval x = nil

      if x == nil
        x = $Cardmaxnum+1
      end
      for i in 1..1
        $create_card_num = x #未使用生成するカードの位置 create_card_iの光の旅で必要で今更引数を増やせないのでここで変数を作る
        $carda[x]=rand(8)
        $cardg[x]=rand(8)
        $cardi[x]=create_card_i 0
        
        
        #一か八か
        #マップの時はxが6になるので、その時は処理を除外するため
        if x != 6 && $cardset_cha_no[x] != 99
          chkchano = $partyc[$cardset_cha_no[x]]
          #p chkchano,$cardset_cha_no[x],x
          #指定のターン戦闘に参加してたら流派一致する
          if chk_itikabatikarun(chkchano) == true
            #p "処理実行",x
            #p chkchano,i
            if rand(2) == 0
              $carda[x]=0
              $cardg[x]=0
            else
              $carda[x]=7
              $cardg[x]=7
            end
          end
        end
        
        #戦闘練習中は常に星Zと気カードとする
        if $game_switches[1305] == true
          $carda[x]=7
          $cardg[x]=7
          $cardi[x]=16
        end
        
        #if (createcardval_chk x)
        #  redo #ジャンプ元
        #end
      end
  end
  
  #--------------------------------------------------------------------------
  # ● 敵カードの初期化
  #引数:[x:何枚目を作成するか,all:全て作成するフラグ]
  #-------------------------------------------------------------------------- 
  def create_enemy_card x=0,all=true
    
    #カードの最小
    min_enecarda = 0 
    if all == true
      for x in 0..8#$Cardmaxnum
        min_enecarda = 0 
        #ボスの攻撃の星を必ず5以上にする
        if $battleenemy[x] != nil
          if $data_enemies[$battleenemy[x]].element_ranks[53] == 1
            min_enecarda = 4 
          end
        end
        #一定以上になっているかチェック
        begin
          $enecarda[x]=rand(8)
        end while $enecarda[x] < min_enecarda
        $enecardg[x]=rand(8)
        
        #強制的に攻防の星1
        if $battleenemy[x] != nil
          if $data_enemies[$battleenemy[x]].element_ranks[55] == 1
            $enecarda[x]= 0
            $enecardg[x]= 0
          end
        end
        $enecardi[x]=create_card_i 1
        #if (createcardval_chk x,true)
        #  redo #ジャンプ元
        #end
      end
    else

      #ボスの攻撃の星を必ず5以上にする
      if $battleenemy[x] != nil
        if $data_enemies[$battleenemy[x]].element_ranks[53] == 1
          min_enecarda = 4 
        end
      end
      #一定以上になっているかチェック
      begin
        $enecarda[x]=rand(8)
      end while $enecarda[x] < min_enecarda
      $enecardg[x]=rand(8)
      $enecardi[x]=create_card_i 1
      #if (createcardval_chk x,true)
      #  redo #ジャンプ元
      #end
    end
  end
=begin
  #--------------------------------------------------------------------------
  # ● カード流派チェック
  #引数:[x:何枚目をチェックするか,ene_flag:敵のカードかチェック]
  #-------------------------------------------------------------------------- 
  def createcardval_chk x,ene_flag=false  #カード流派チェック
    if ene_flag == false#味方カード
      if $game_variables[40] == 0
        case $game_variables[43]
        when 51..80
          if $cardi[x] == 2 || $cardi[x] == 3
            return true
          end
        else
          if $cardi[x] == 5 || $game_variables[43] >= 11 && $cardi[x] == 2 || $game_variables[43] <= 10 && $cardi[x] == 3
            return true
          end
        end
      elsif $game_variables[40] == 1
        if $cardi[x] == 2 || $cardi[x] == 6 || $cardi[x] == 7 || $super_saiyazin_flag[1] == true && $cardi[x] == 3
          return true
        end
      elsif $game_variables[40] == 2
        if $cardi[x] == 2 || $cardi[x] == 6 || $cardi[x] == 7 || $cardi[x] == 8 || $cardi[x] == 9 || $cardi[x] == 10 || $super_saiyazin_flag[1] == true && $cardi[x] == 3
          return true
        end
      end
    else #敵カード
      if $game_variables[40] == 0
        if $game_variables[43] >= 11 && $enecardi[x] == 2 || $game_variables[43] <= 10 && $enecardi[x] == 3
          return true
        end
      elsif $game_variables[40] == 1
        if $enecardi[x] == 2 || $enecardi[x] == 7 || $super_saiyazin_flag[1] == true && $enecardi[x] == 3
          return true
        end
      elsif $game_variables[40] == 2
        if $enecardi[x] == 2 || $enecardi[x] == 6 || $enecardi[x] == 7 || $super_saiyazin_flag[1] == true && $enecardi[x] == 3
          return true
        end
      end
    end
  end
=end
  #--------------------------------------------------------------------------
  # ○ 指定位置のイベント ID 取得
  #     x : マップの X 座標
  #     y : マップの Y 座標
  #     variable_id : 取得したイベント ID を代入する変数の ID
  #--------------------------------------------------------------------------
  def get_event_id_and_graphic(x, y)
    event_id = 0
    # 該当するイベントを検索
    events   = $game_map.events.values.find_all { |e| e.x == x && e.y == y }
    event_id = (events.max { |a, b| a.id <=> b.id }).id unless events.empty?
    
    #p $game_map.events[event_id].character_name,$game_map.events[event_id].character_index,$game_map.events[event_id].direction
    if event_id != 2
      return $game_map.events[event_id].character_name,$game_map.events[event_id].character_index,$game_map.events[event_id].direction
    end
  end
  
  # カード値スライド
  def cardvalslide
    $carda[$CardCursorState] = $carda[$CardCursorState+1]
    $cardg[$CardCursorState] = $cardg[$CardCursorState+1]
    $cardi[$CardCursorState] = $cardi[$CardCursorState+1]
  end
  #--------------------------------------------------------------------------
  # ● 高速化ＯＮＯＦＦ管理
  #--------------------------------------------------------------------------
  def input_fast_fps
    
    if Input.trigger?(Input::CTRL) || Input.trigger?(Input::Z)
      if $fast_fps == false
        $fast_fps = true
      else
        $fast_fps = false
        
      end
    end
    
    if $game_switches[492] == true #オプション設定で不可のため、元に戻す
      $fast_fps = false 
    end
    
    if $game_switches[489] == true #倍速不可フラグがONなら強制的に倍速を戻す
       $fast_fps = false 
    end
    
    if $fast_fps == false 
      Graphics.frame_rate = 60
      $fast_fps_count = 0
    else
      Graphics.frame_rate = 120
      $fast_fps_count += 1
      if $fast_fps_count == 2
        $fast_fps_count = 0
        Graphics.frame_count -= 1 
      end
    end
    
    
  end
  #--------------------------------------------------------------------------
  # ● カード所持数が最大値を超えていたら自動的に売却する
  #--------------------------------------------------------------------------
  def set_max_item_card
    #カードランク変更
    chg_card_rank
    
    for x in 1..$data_items.size-1

      
      if $data_items[x].element_set.index(5)
        #Sランク
        tmp_max_item_card_num = $game_variables[224]
      elsif $data_items[x].element_set.index(6)
        #Aランク
        tmp_max_item_card_num = $game_variables[225]
      elsif $data_items[x].element_set.index(7)
        #Bランク
        tmp_max_item_card_num = $game_variables[226]
      elsif $data_items[x].element_set.index(8)
        #Cランク
        tmp_max_item_card_num = $game_variables[227]
      else
        tmp_max_item_card_num = 1
      end
      
      #カード数調整 最大値にあわせる
      if $game_party.item_number($data_items[x]) > tmp_max_item_card_num
        #p ($game_party.item_number($data_items[x]) - $max_item_card_num)*$data_items[x].price / 2
        $game_variables[221] += 1 #カード売却回数
        $game_party.gain_gold(($game_party.item_number($data_items[x]) - tmp_max_item_card_num)*$data_items[x].price / 2)
        $game_variables[211] += (($game_party.item_number($data_items[x]) - tmp_max_item_card_num)*$data_items[x].price / 2)
        $game_party.lose_item ($data_items[x], $game_party.item_number($data_items[x]) - tmp_max_item_card_num) #カード減らす
      end

    end
  end
  

  
  # 文字列を変換
def convert(value)
  return true if value == "true"
  return false if value == "false"
  return value.to_i if value[/^\d+$/]
  return value
end
  
  #--------------------------------------------------------------------------
  # ● カードの最大所持数を更新する
  #--------------------------------------------------------------------------
  def update_max_item_card_num
    
    #まず初期化(7枚になる想定)
    $max_item_card_num = $max_item_card_num_syokiti
    
    #プラス1一回目
    if $game_switches[494] == true
      $max_item_card_num += 1
    end
    
    #プラス1二回目
    if $game_switches[495] == true
      $max_item_card_num += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● 閃きスキルを設定する
  #--------------------------------------------------------------------------
  def set_tecspark
      
      $tecspark_count = 0
      $tecspark_get_flag = []
      $tecspark_new_flag = []
      $tecspark_no = []
      $tecspark_cha = []
      $tecspark_flag_tec = []
      $tecspark_skill_level_num = []
      $tecspark_card_attack_num = []
      $tecspark_card_gard_num = []
      $tecspark_chk_flag = [] #Sコンボ有効 フラグ0:なし 1:スイッチ 2:変数
      $tecspark_chk_flag_no = [] #Sコンボフラグナンバー
      $tecspark_chk_flag_process = [] #チェック方法 0:一致 1:以上 2:以下
      $tecspark_chk_flag_value = [] #チェック値
      $tecspark_chk_acquisition_rate = [] #取得確率
      $tecspark_chk_scenario_progress = [] #シナリオ進行度(以上で取得)
      v_count = 0
      fname = "Data/_tecspark.rvdata" #ファイル順を上にしたから_残す
      
      kugiri = "`"
      obj = load_data(fname)#("Data/_tecspark.rvdata")
      obj.each_with_index do |s,i|
          
          for v in 1..s.size-1
            if s[v].to_s.index(kugiri) != nil
              tmp_arr = []
              for arr in s[v].gsub(kugiri,",").chomp.split(",")
                tmp_arr.push(arr.to_i)
                
              end
              #p tmp_arr
            else
              tmp_arr = s[v]
            end
            #p tmp_arr
            if i > 0
              case v

                when 1 #スキル番号
                  $tecspark_no[i-1] = tmp_arr
                when 2 #取得済みか参照するフラグ
                  $tecspark_get_flag[i-1] = tmp_arr
                when 3 #初取得取得済みか参照するフラグ
                  $tecspark_new_flag[i-1] = tmp_arr
                when 4 #スキル参加者
                  $tecspark_cha[i-1] = tmp_arr
                when 5 #スキル対象技
                  $tecspark_flag_tec[i-1] = tmp_arr
                when 6 #スキル使用回数
                  $tecspark_skill_level_num[i-1] = tmp_arr
                when 7 #カードの攻撃星
                  $tecspark_card_attack_num[i-1] = tmp_arr
                when 8 #カードの防御星
                  $tecspark_card_gard_num[i-1] = tmp_arr
                when 9 #スキルコンボ有効フラグ
                  $tecspark_chk_flag[i-1] = tmp_arr
                when 10 #Sコンボフラグナンバー
                  $tecspark_chk_flag_no[i-1] = tmp_arr
                when 11 #チェック方法
                  $tecspark_chk_flag_process[i-1] = tmp_arr
                when 12 #チェック値
                  $tecspark_chk_flag_value[i-1] = tmp_arr
                when 13 #取得確率
                  $tecspark_chk_acquisition_rate[i-1] = tmp_arr
                when 14 #シナリオ進行度
                  $tecspark_chk_scenario_progress[i-1] = tmp_arr
              end
            end
          end
           #p $tecspark_no[i-1],$tecspark_get_flag[i-1],$tecspark_new_flag[i-1],$tecspark_cha_count[i-1],$tecspark_cha[i-1],$tecspark_flag_tec[i-1],$tecspark_skill_level_num[i-1],$tecspark_card_attack_num[i-1],$tecspark_card_gard_num[i-1],$tecspark_chk_flag[i-1],$tecspark_chk_flag_no[i-1],$tecspark_chk_flag_process[i-1],$tecspark_chk_flag_value[i-1]
           $tecspark_count += 1 
      end
    $tecspark_count -= 2
  end
  #--------------------------------------------------------------------------
  # ● スパーキングコンボを設定する
  #--------------------------------------------------------------------------
  def set_scombo
      
      $scombo_count = 0
      $scombo_renban = [] #連番
      $scombo_cha_count = []
      $scombo_get_flag = []
      $scombo_new_flag = []
      $scombo_no = []
      $scombo_cha = []
      $scombo_flag_tec = []
      $scombo_skill_level_num = []
      $scombo_card_attack_num = []
      $scombo_card_gard_num = []
      $scombo_chk_flag = [] #Sコンボ有効 フラグ0:なし 1:スイッチ 2:変数
      $scombo_chk_flag_no = [] #Sコンボフラグナンバー
      $scombo_chk_flag_process = [] #チェック方法 0:一致 1:以上 2:以下
      $scombo_chk_flag_value = [] #チェック値
      $scombo_chk_flag_ssaiya = [] #超サイヤ人フラグを見るかどうか
      $scombo_chk_flag_ssaiya_cha = [] #超サイヤ人フラグキャラ
      $scombo_chk_flag_ssaiya_put = [] #超サイヤ人一致で表示か非表示か 0:一致で表示 1:一致で非表示
      $scombo_chk_flag_oozaru_put = [] #大ざる時に表示化
      $scombo_chk_scenario_progress = [] #シナリオ進行度
      v_count = 0
      fname = "Data/_scombo.rvdata" #ファイル順を上にしたから_残す
      
      kugiri = "`"
      obj = load_data(fname)#("Data/_scombo.rvdata")
      obj.each_with_index do |s,i|
          
          for v in 1..s.size-1
            if s[v].to_s.index(kugiri) != nil
              tmp_arr = []
              for arr in s[v].gsub(kugiri,",").chomp.split(",")
                tmp_arr.push(arr.to_i)
                
              end
              #p tmp_arr
            else
              tmp_arr = s[v]
            end
            #p tmp_arr
            if i > 0
              case v

                when 1 #スキル番号
                  $scombo_no[i-1] = tmp_arr
                when 2 #取得済みか参照するフラグ
                  $scombo_get_flag[i-1] = tmp_arr
                when 3 #初取得取得済みか参照するフラグ
                  $scombo_new_flag[i-1] = tmp_arr
                when 4 #参加人数
                  $scombo_cha_count[i-1] = tmp_arr
                when 5 #スキル参加者
                  $scombo_cha[i-1] = tmp_arr
                when 6 #スキル対象技
                  $scombo_flag_tec[i-1] = tmp_arr
                when 7 #スキル使用回数
                  $scombo_skill_level_num[i-1] = tmp_arr
                when 8 #カードの攻撃星
                  $scombo_card_attack_num[i-1] = tmp_arr
                when 9 #カードの防御星
                  $scombo_card_gard_num[i-1] = tmp_arr
                when 10 #スキルコンボ有効フラグ
                  $scombo_chk_flag[i-1] = tmp_arr
                when 11 #Sコンボフラグナンバー
                  $scombo_chk_flag_no[i-1] = tmp_arr
                when 12 #チェック方法
                  $scombo_chk_flag_process[i-1] = tmp_arr
                when 13 #チェック値
                  $scombo_chk_flag_value[i-1] = tmp_arr
                when 14 #超サイヤ人フラグを見るかどうか
                  $scombo_chk_flag_ssaiya[i-1] = tmp_arr
                when 15 #超サイヤ人フラグキャラ
                  $scombo_chk_flag_ssaiya_cha[i-1] = tmp_arr
                when 16 #超サイヤ人一致で表示か非表示か 0:一致で表示 1:一致で非表示
                  $scombo_chk_flag_ssaiya_put[i-1] = tmp_arr
                when 17 #大ざる時で表示か非表示か 0:通常で表示 1:大猿で非表示
                  $scombo_chk_flag_oozaru_put[i-1] = tmp_arr
                when 18 #シナリオ進行度(以上で対象)
                  $scombo_chk_scenario_progress[i-1] = tmp_arr
              end
            end
          end
          #連番をカウントにセット
          $scombo_renban << $scombo_count
           #p $scombo_no[i-1],$scombo_get_flag[i-1],$scombo_new_flag[i-1],$scombo_cha_count[i-1],$scombo_cha[i-1],$scombo_flag_tec[i-1],$scombo_skill_level_num[i-1],$scombo_card_attack_num[i-1],$scombo_card_gard_num[i-1],$scombo_chk_flag[i-1],$scombo_chk_flag_no[i-1],$scombo_chk_flag_process[i-1],$scombo_chk_flag_value[i-1]
           $scombo_count += 1 
      end
    $scombo_count -= 2

  end

  #--------------------------------------------------------------------------
  # ● セル戦で抜けた分のキャラを追加する
  #--------------------------------------------------------------------------
  def add_cha_last_cellbtl
    
    partymax = 9
    addparty = partymax - $partyc.size
    tempchano = 0
    tempchano2 = 0
    #悟飯
    tempchano = 5
    tempchano2 = 18
    if $partyc.index(tempchano) == nil && $partyc.index(tempchano2) == nil && addparty >= 1
      $partyc << tempchano
      addparty -= 1
    end
    
    #ピッコロ
    tempchano = 4
    if $partyc.index(tempchano) == nil && addparty >= 1
      $partyc << tempchano
      addparty -= 1
    end 
    
    #ベジータ
    tempchano = 12
    tempchano2 = 19
    if $partyc.index(tempchano) == nil && $partyc.index(tempchano2) == nil && addparty >= 1
      if $super_saiyazin_flag[3] == false
        $partyc << tempchano
      else
        $partyc << tempchano2
      end
      addparty -= 1
    end
    
    #トランクス
    tempchano = 17
    tempchano2 = 20
    if $partyc.index(tempchano) == nil && $partyc.index(tempchano2) == nil && addparty >= 1
      if $super_saiyazin_flag[4] == false
        $partyc << tempchano
      else
        $partyc << tempchano2
      end
      addparty -= 1
    end 

    #クリリン
    tempchano = 6
    if $partyc.index(tempchano) == nil && addparty >= 1
      $partyc << tempchano
      addparty -= 1
    end
    
    #ヤムチャ
    tempchano = 7
    if $partyc.index(tempchano) == nil && addparty >= 1
      $partyc << tempchano
      addparty -= 1
    end
    
    #チャオズ
    tempchano = 8
    if $partyc.index(tempchano) == nil && addparty >= 1
      $partyc << tempchano
      addparty -= 1
    end
    
    #天津飯
    tempchano = 9
    if $partyc.index(tempchano) == nil && addparty >= 1
      $partyc << tempchano
      addparty -= 1
    end
    
    #チチ
    tempchano = 10
    if $partyc.index(tempchano) == nil && addparty >= 1
      $partyc << tempchano
      addparty -= 1
    end
    
    #亀仙人
    tempchano = 24
    if $partyc.index(tempchano) == nil && addparty >= 1
      $partyc << tempchano
      addparty -= 1
    end
    
    for x in 0..$partyc.size - 1
      $chadead[x] = false
    end
    
    all_charecter_recovery
    #[5,18,4,6,7,8,9,12,19,17,20,10,24]
  end
  
  #--------------------------------------------------------------------------
  # ● 超サイヤ人変身を解く
  #--------------------------------------------------------------------------
  def off_super_saiyazin_all
    off_super_saiyazin(1) if $super_saiyazin_flag[1] == true && $cha_tactics[3][3] == 1
    #5は例外で前に持ってくる(悟飯が5から2の流れで解除しないとバグるため)
    off_super_saiyazin(5) if $super_saiyazin_flag[5] == true && $cha_tactics[3][18] == 1
    off_super_saiyazin(2) if $super_saiyazin_flag[2] == true && $cha_tactics[3][5] == 1
    off_super_saiyazin(3) if $super_saiyazin_flag[3] == true && $cha_tactics[3][12] == 1
    off_super_saiyazin(4) if $super_saiyazin_flag[4] == true && $cha_tactics[3][17] == 1
    off_super_saiyazin(6) if $super_saiyazin_flag[6] == true && $cha_tactics[3][25] == 1
    off_super_saiyazin(7) if $super_saiyazin_flag[7] == true && $cha_tactics[3][16] == 1
  end
  
  #--------------------------------------------------------------------------
  # ● 超サイヤ人変身を解く
  #--------------------------------------------------------------------------
  def off_super_saiyazin no
    on_off_super_saiyazin(no,1)
  end
  
  #--------------------------------------------------------------------------
  # ● 超サイヤ人に変身する
  #--------------------------------------------------------------------------
  def on_super_saiyazin no
    on_off_super_saiyazin(no,0)
  end
  #--------------------------------------------------------------------------
  # ● 超サイヤ人ON OFF
  #  no:キャラ on_off:0オン 1オフ 2
  #--------------------------------------------------------------------------
  def on_off_super_saiyazin(no,on_off=1)
    saiyanotitama = nil

    #本当に処理が必要かチェック
    temp_super_saiyazin_flag = false
    case no
    when 1 #悟空
      chg_cha=3
      chg_cha_spr=14
      saiyanotitama = 0
    when 2 #悟飯(超1)
      chg_cha=5
      chg_cha_spr=18
      saiyanotitama = 1

      #悟飯が超2状態で超1をオフにされたら
      if $super_saiyazin_flag[5] == true && on_off == 1
        #超2悟飯 作戦の指定の技を変数に格納
        $game_variables[451] = $cha_tactics[7][chg_cha_spr]
        #超1悟飯 作戦の指定の技を変数からセット
        $cha_tactics[7][chg_cha_spr] = $game_variables[450]
      end
    when 3 #ベジータ
      chg_cha=12
      chg_cha_spr=19
      saiyanotitama = 1
    when 4 #トランクス
      chg_cha=17
      chg_cha_spr=20
      saiyanotitama = 1
    when 5 #悟飯(超2)使わないかも
      chg_cha=18
      chg_cha_spr=18
      saiyanotitama = 1
      if on_off == 0 #onの場合変換は行わない
        saiyanotitama = nil
      else #offの場合
        chg_cha = 5 #通常悟飯に戻す
        gohan_mzenkaiskillno = $cha_typical_skill[chg_cha][0] #ミラクル前回パワーのスキルを取得
      end
      
      if on_off == 0 #超1から超2に変身
        #超1悟飯 作戦の指定の技を変数に格納
        $game_variables[450] = $cha_tactics[7][chg_cha_spr]
        #超2悟飯 作戦の指定の技を変数からセット
        $cha_tactics[7][chg_cha_spr] = $game_variables[451]
      else #超2から超1へ変身
        #超2悟飯 作戦の指定の技を変数に格納
        $game_variables[451] = $cha_tactics[7][chg_cha_spr]
        #超1悟飯 作戦の指定の技を変数からセット
        $cha_tactics[7][chg_cha_spr] = $game_variables[450]
      end

    when 6 #未来悟飯
      chg_cha=25
      chg_cha_spr=26
      saiyanotitama = 1
    when 7 #バーダック
      chg_cha=16
      chg_cha_spr=32
      saiyanotitama = nil
    else
        #puts "Good evening !"
    end
    
    temp_super_saiyazin_flag = $super_saiyazin_flag[no]
    temp_super_saiyazin_flag = false if temp_super_saiyazin_flag == nil
    #超サイヤ人ON
    if on_off == 0
      chg_moto = chg_cha
      chg_gawa = chg_cha_spr
      $super_saiyazin_flag[no] = true
    else
      #超サイヤ人OFF
      
      chg_moto = chg_cha_spr
      chg_gawa = chg_cha
      
      $super_saiyazin_flag[no] = false
      $super_saiyazin_flag[2] = false if no == 5 #例外で超悟飯がOFFの場合は最初に戻す
    end
    
    #p temp_super_saiyazin_flag,$super_saiyazin_flag[no]
    #本当に処理が必要かチェックし、必要な場合のみ処理
    if temp_super_saiyazin_flag != $super_saiyazin_flag[no]
      $partyc[$partyc.index(chg_moto)] = chg_gawa if $partyc.index(chg_moto) != nil
      
      #一応変身前の方が経験値が高いかみる
      if $game_actors[chg_gawa].exp <= $game_actors[chg_moto].exp
        $game_actors[chg_gawa].change_exp($game_actors[chg_moto].exp,false)
        $game_actors[chg_gawa].change_equip_by_id(0, $game_actors[chg_moto].weapon_id)
        
        #数値が戻る対策で変身前後の値が大きいかチェックする(暫定対策のためここが原因ではないかもしれない)
        if $game_actors[chg_gawa].maxhp < $game_actors[chg_moto].maxhp
          $game_actors[chg_gawa].maxhp = $game_actors[chg_moto].maxhp
        end
        
        if $game_actors[chg_gawa].maxmp < $game_actors[chg_moto].maxmp
          $game_actors[chg_gawa].maxmp = $game_actors[chg_moto].maxmp
        end
        
        if $game_actors[chg_gawa].atk < $game_actors[chg_moto].atk
          $game_actors[chg_gawa].atk = $game_actors[chg_moto].atk
        end
        
        if $game_actors[chg_gawa].def < $game_actors[chg_moto].def
          $game_actors[chg_gawa].def = $game_actors[chg_moto].def
        end
        
        if $game_actors[chg_gawa].agi < $game_actors[chg_moto].agi
          $game_actors[chg_gawa].agi = $game_actors[chg_moto].agi
        end
        
        $game_actors[chg_gawa].hp = $game_actors[chg_moto].hp
        $game_actors[chg_gawa].mp = $game_actors[chg_moto].mp
      end
      
      #スキル
      $cha_typical_skill[chg_gawa] = Marshal.load(Marshal.dump($cha_typical_skill[chg_moto]))
      
      #$cha_typical_skill[chg_gawa] = $cha_typical_skill[chg_moto]
      #超2の場合
      if no == 5
        if on_off == 0 #ON
          #真の力に変更
          skill_sinnotikarano = 38
          
          if $cha_typical_skill[chg_gawa] == nil
            $cha_typical_skill[chg_gawa] = [0]
          end
          $cha_typical_skill[chg_gawa][0] = skill_sinnotikarano
          if $cha_skill_set_flag[chg_gawa] == nil
            $cha_skill_set_flag[chg_gawa] = [0]
          end
          $cha_skill_set_flag[chg_gawa][skill_sinnotikarano] = 1
          
          if $cha_skill_spval[chg_gawa] == nil
            $cha_skill_spval[chg_gawa] = [0]
          end
          #取得済み状態にする
          $cha_skill_spval[chg_gawa][skill_sinnotikarano] = $cha_skill_get_val[skill_sinnotikarano]
          $game_switches[388] = true
          #下の処理のコモンイベントで実行
          ##超かめはめ波使用可であれば
          #if $game_switches[593] == true
          #  $game_actors[chg_gawa].learn_skill(54) #超かめはめ波
          #  $game_actors[chg_gawa].forget_skill(53) #激烈魔閃光
          #else
          #  $game_actors[chg_gawa].learn_skill(53) #激烈魔閃光
          #  $game_actors[chg_gawa].forget_skill(54) #超かめはめ波
          #end
        else #OFF
          #悟飯のスキルをミラクル全開パワーに戻す
          $cha_typical_skill[chg_gawa][0] = gohan_mzenkaiskillno
          $game_switches[388] = false
          
          #超かめはめ波を激烈魔閃光に戻す
          #$game_actors[chg_gawa].learn_skill(53) #激烈魔閃光
          #$game_actors[chg_gawa].forget_skill(54) #超かめはめ波
        end
      end
      $cha_add_skill[chg_gawa] = Marshal.load(Marshal.dump($cha_add_skill[chg_moto]))
      $cha_skill_spval[chg_gawa] = Marshal.load(Marshal.dump($cha_skill_spval[chg_moto]))
      $cha_skill_set_flag[chg_gawa] = Marshal.load(Marshal.dump($cha_skill_set_flag[chg_moto]))
      $cha_skill_get_flag[chg_gawa] = Marshal.load(Marshal.dump($cha_skill_get_flag[chg_moto]))
      $cha_add_skill_set_num[chg_gawa] = Marshal.load(Marshal.dump($cha_add_skill_set_num[chg_moto]))
      
      #$cha_add_skill[chg_gawa] = $cha_add_skill[chg_moto]
      #$cha_skill_spval[chg_gawa] = $cha_skill_spval[chg_moto]
      #$cha_skill_set_flag[chg_gawa] = $cha_skill_set_flag[chg_moto]
      #$cha_skill_get_flag[chg_gawa] = $cha_skill_get_flag[chg_moto]
      #$cha_add_skill_set_num[chg_gawa] = $cha_add_skill_set_num[chg_moto]
      
      #サイヤ人の血を覚えていてかつ超サイヤ人に変身するとき
      #サイヤ人魂に変える
      #サイヤ人の血スキルNo
      saiyati = [2,3,4,89,90,91,92,93,94]
      #サイヤ人魂スキルNo
      saiyatama = [5,6,7,95,96,97,98,99,100]
      saiyaskillno = 0
      if saiyanotitama != nil
        
        if on_off == 0 #超サイヤ人変身
          for y in 0..saiyati.size - 1
            if $cha_typical_skill[chg_gawa][saiyanotitama] == saiyati[y]
              saiyaskillno = saiyatama[y]
              break
            end
          end
        else #変身解除
          for y in 0..saiyatama.size - 1
            if $cha_typical_skill[chg_gawa][saiyanotitama] == saiyatama[y]
              saiyaskillno = saiyati[y]
              break
            end
          end
          
        end
        
        #スキル0うめ、エラー回避
        set_skill_nil_to_zero chg_moto
        set_skill_nil_to_zero chg_gawa
        
      
        #スキルをセット
        $cha_typical_skill[chg_gawa][saiyanotitama] = saiyaskillno
        
        #スキル取得フラグ
        $cha_skill_set_flag[chg_gawa][saiyaskillno] = 1
        #SPもセット
        $cha_skill_spval[chg_gawa][saiyaskillno] = $cha_skill_get_val[saiyaskillno]
        
        #お気に入りキャラも変更
        #判定時に元のキャラNoを取得できるようにしているので変更は不要
        #if $game_variables[104] == chg_moto
        #  $game_variables[104] = chg_gawa
        #end
        
        #戦闘時のパワーアップとディフェンスアップと戦闘連続参加ターン数
        $full_cha_power_up[chg_gawa] = $full_cha_power_up[chg_moto]        #界王様か最長老が使われているか？
        $full_cha_defense_up[chg_gawa] = $full_cha_defense_up[chg_moto]      #ディフェンスアップ
        $full_cha_btl_cont_part_turn[chg_gawa] = $full_cha_btl_cont_part_turn[chg_moto] #戦闘連続参加ターン数

      end

      #ZP
      #元の方が使用回数が正しいのであれば
      if $runzp[chg_gawa] <= $runzp[chg_moto]
        $zp[chg_gawa] = $zp[chg_moto]
        $runzp[chg_gawa] = $runzp[chg_moto]
      end
      
      #撃破数
      $cha_defeat_num[chg_gawa] = $cha_defeat_num[chg_moto]
    end

    #超悟飯の技設定
    run_common_event 64
    
  end
=begin
  #--------------------------------------------------------------------------
  # ● 超サイヤ人変身
  #  no:キャラ　on_off:0がON 1がOFF force:強制的にするか
  #--------------------------------------------------------------------------
  def chg_super_saiyazin(no,on_off=0,force=false)
      
    case no
    when 1 #悟空
      chg_cha=3
      chg_cha_spr=14
    when 2 #悟飯(超1)
      chg_cha=5
      chg_cha_spr=18
    when 3 #ベジータ
      chg_cha=12
      chg_cha_spr=19
    when 4 #トランクス
      chg_cha=17
      chg_cha_spr=20
    when 5 #悟飯(超2)使わないかも
      chg_cha=18
      chg_cha_spr=18
    when 6 #未来悟飯
      chg_cha=25
      chg_cha_spr=26
    else
        puts "Good evening !"
    end

    
    #超サイヤ人ON
    if $super_saiyazin_flag[no] != true || on_off == 1 and force == true
      $partyc[$partyc.index(chg_cha)] = chg_cha_spr if $partyc.index(chg_cha) != nil
      $game_actors[chg_cha_spr].change_exp($game_actors[chg_cha].exp,false)
      $game_actors[chg_cha_spr].change_equip_by_id(0, $game_actors[chg_cha].weapon_id)
      $super_saiyazin_flag[no] = true
    else
      #超サイヤ人OFF
      $partyc[$partyc.index(chg_cha_spr)] = chg_cha if $partyc.index(chg_cha_spr) != nil
      $game_actors[chg_cha].change_exp($game_actors[chg_cha_spr].exp,false)
      $game_actors[chg_cha].change_equip_by_id(0, $game_actors[chg_cha_spr].weapon_id)
      $super_saiyazin_flag[no] = false
    end
  end
=end
  #--------------------------------------------------------------------------
  # ● 大猿変身を解く
  #--------------------------------------------------------------------------
  def off_oozaru_all
    #p $oozaru_flag
    off_oozaru(1) if $oozaru_flag[1] == true && $cha_tactics[3][27] == 1
    off_oozaru(2) if $oozaru_flag[2] == true && $cha_tactics[3][28] == 1
    off_oozaru(3) if $oozaru_flag[3] == true && $cha_tactics[3][29] == 1
    off_oozaru(4) if $oozaru_flag[4] == true && $cha_tactics[3][30] == 1
    off_oozaru(5) if $oozaru_flag[5] == true && $cha_tactics[3][5] == 1
  end
  
  #--------------------------------------------------------------------------
  # ● 大猿変身を解く
  #--------------------------------------------------------------------------
  def off_oozaru no
    on_off_oozaru(no,1)
  end
  
  #--------------------------------------------------------------------------
  # ● 大猿に変身する
  #--------------------------------------------------------------------------
  def on_oozaru no
    on_off_oozaru(no,0)
  end
  #--------------------------------------------------------------------------
  # ● 大猿OFF
  #  no:キャラ on_off:0オン 1オフ force:強制的にするか
  #--------------------------------------------------------------------------
  def on_off_oozaru(no,on_off=1)
    
    #if $cha_bigsize_on == nil
    #  $cha_bigsize_on = [false,false,false,false,false,false,false,false,false]  #キャラ巨大化
    #end
    #onoff処理実行しないフラグ
    onoffnotrun = false
    case no
    when 1 #トーマ
      chg_cha = 27
      on_off_skill = [247,249,251]
      #on_off_skill = [247,249,250,251]
      oozaru_flag = 364
      tacgvar = [442,443]
    when 2 #セリパ
      chg_cha = 28
      on_off_skill = [256,259,262]
      #on_off_skill = [256,259,260,262]
      oozaru_flag = 365
      tacgvar = [444,445]
    when 3 #トテッポ
      chg_cha = 29
      on_off_skill = [266,268,270]
      #on_off_skill = [266,268,269,270]
      oozaru_flag = 366
      tacgvar = [446,447]
    when 4 #パンブーキン
      chg_cha = 30
      on_off_skill = [274,276,278]
      #on_off_skill = [274,276,277,278]
      oozaru_flag = 367
      tacgvar = [448,449]
    when 5 #悟飯
      chg_cha = 5
      on_off_skill = [47,51]
      oozaru_flag = 368
      tacgvar = [452,453]
    else
      onoffnotrun = true
    end
    
    
    if onoffnotrun == false
      #大猿ON
      if on_off == 0
        #chg_moto = chg_cha
        #chg_gawa = chg_cha_spr
        $game_switches[oozaru_flag] = true
        #スキルを忘れる
        for x in 0..on_off_skill.size - 1 
          $game_actors[chg_cha].forget_skill(on_off_skill[x])
        end
        
        if $oozaru_flag[no] == false
          #変身前の作戦の指定の技を変数に格納
          $game_variables[tacgvar[0]] = $cha_tactics[7][chg_cha]
          #変身後の作戦の指定の技を変数からセット
          $cha_tactics[7][chg_cha] = $game_variables[tacgvar[1]]
        end
        $oozaru_flag[no] = true
      else
        #大猿OFF
        
        $cha_bigsize_on[$partyc.index(chg_cha)] = false if $partyc.index(chg_cha) != nil
        $game_switches[oozaru_flag] = false
        #スキルを覚える
        for x in 0..on_off_skill.size - 1 
          #悟飯の大猿変身のときだけチェックする、
          if on_off_skill[x] == 51 && $game_variables[40] >= 1 || on_off_skill[x] == 51 && $game_variables[40] == 0 && $game_switches[70] == false
        
          else
            $game_actors[chg_cha].learn_skill(on_off_skill[x])
          end
        end

        if $oozaru_flag[no] == true
          #変身前の作戦の指定の技を変数に格納
          $game_variables[tacgvar[1]] = $cha_tactics[7][chg_cha]
          #変身後の作戦の指定の技を変数からセット
          $cha_tactics[7][chg_cha] = $game_variables[tacgvar[0]]
        end
        $oozaru_flag[no] = false
      end
    end
      
    #$partyc[$partyc.index(chg_moto)] = chg_gawa if $partyc.index(chg_moto) != nil
    #$game_actors[chg_gawa].hp = $game_actors[chg_moto].hp
    #$game_actors[chg_gawa].mp = $game_actors[chg_moto].mp
    #$game_actors[chg_gawa].change_exp($game_actors[chg_moto].exp,false)
    #$game_actors[chg_gawa].change_equip_by_id(0, $game_actors[chg_moto].weapon_id)
    
    #スキル
    #$cha_typical_skill[chg_gawa] = $cha_typical_skill[chg_moto]
    #$cha_add_skill[chg_gawa] = $cha_add_skill[chg_moto]
    #$cha_skill_spval[chg_gawa] = $cha_skill_spval[chg_moto]
    #$cha_skill_set_flag[chg_gawa] = $cha_skill_set_flag[chg_moto]
    #$zp[chg_gawa] = $zp[chg_moto]
    #ここでも必殺技を再調整する(トーマたちの大猿解除対策のため)
    run_common_event 9
  end
  #--------------------------------------------------------------------------
  # ● キャラの必殺技回数がnullの場合は0にする
  # target_tec:必殺技No
  #--------------------------------------------------------------------------
  def set_cha_tec_null_to_zero(target_tec)
    if $cha_skill_level[target_tec] == nil
      $cha_skill_level[target_tec] = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● キャラ必殺技nil解除
  # puls_type 0：単純に足す 1:かける 2:割る 3:puls_parを足す
  #--------------------------------------------------------------------------
  def cha_tec_puls(target_tec,puls_tec,puls_type=0,puls_par=0)
    
    #エラー回避のため対象がnilじゃないかチェックしnilなら0を格納
    if $cha_skill_level[target_tec] == nil
      $cha_skill_level[target_tec] = 0
    end
    
    if $cha_skill_level[puls_tec] == nil
      $cha_skill_level[puls_tec] = 0
    end
    
    case puls_type
    
    when 0 #足す
      $cha_skill_level[target_tec] += ($cha_skill_level[puls_tec]).ceil
    when 1 #掛ける
      $cha_skill_level[target_tec] += ($cha_skill_level[puls_tec]*puls_par).ceil
    when 2 #割る
      $cha_skill_level[target_tec] += ($cha_skill_level[puls_tec]/puls_par).ceil
    when 3 #puls_parを足す
      $cha_skill_level[target_tec] += (puls_par).ceil
    end
    
    #最大値を超えたら最大値にあわせる
    $cha_skill_level[target_tec] = $cha_skill_level_max if $cha_skill_level[target_tec] > $cha_skill_level_max
  end
  #--------------------------------------------------------------------------
  # ● エンカウント音設定
  # 0：Z1 1:Z3 2:超サイヤ 3:GB2
  #--------------------------------------------------------------------------
  
  def set_encount_se
    
    case $game_variables[28]
    
    when 1
      $BGM_encount = "Z3 敵発見"
    when 2
      $BGM_encount = "ZSSD 敵発見(GXSCC音源Ver)"
      #$BGM_encount = "ZSSD 敵発見(GB音源Ver)"
    when 3
      $BGM_encount = "GBZ2 戦闘開始"
    else
      $BGM_encount = "Z1 敵発見"
    end
  end

  #--------------------------------------------------------------------------
  # ● 横カーソル点滅制御
  #--------------------------------------------------------------------------
  def set_yoko_cursor_blink tenmetu=1,n=1,blink=0
    
    #if $cursor_blink_count <= 8
    #  return Rect.new(x, 0, 16, 16) # アイコン
    #elsif $cursor_blink_count <= 16
    #  return Rect.new(xx, 0, 16, 16) # アイコン
    #else
    #  $cursor_blink_count = 0
    #  return Rect.new(x, 0, 16, 16) # アイコン
    #end
    set_tate_cursor_blink tenmetu,n,blink
  end
  
  #--------------------------------------------------------------------------
  # ● 戦闘関係のフラグ初期化
  #--------------------------------------------------------------------------
  def reset_battle_flag
    #先手カードフラグ
    $cha_sente_card_flag = [false,false,false,false,false,false,false,false,false] #先手スキル有効フラグ
    $run_alow_card = false                      #ゴズカードを使用したか？
    $run_glow_card = false                      #メズカードを使用したか？
    
    $game_switches[25] = false #１人で攻撃回数増加チェックフラグ
    $game_switches[26] = false #HP30％以下で攻撃回数増加チェックフラグ
    $game_switches[27] = false #HP40％以下で攻撃回数増加チェックフラグ
    $game_switches[28] = false #2人で攻撃回数増加チェックフラグ
    $game_switches[29] = false #HP50％以下で攻撃回数増加チェックフラグ
    $game_variables[81] = 0 #味方攻撃ダメージn倍
    $game_variables[82] = 0 #敵攻撃ダメージn倍
    $game_variables[96] = 0 #戦闘イベントNo
    $game_switches[17] = false #味方必ず回避
    $game_switches[18] = false #敵必ず回避
    $game_switches[40] = false #1回しか攻撃しないフラグ初期化
    #戦いの記録関係
    $game_switches[121] = false #戦いの記録に追記しない
    $game_switches[122] = false #撃破後カード取得しない
    $game_switches[123] = false #撃破数追加しない
    $game_switches[124] = false #経験値取得しない
    $game_switches[125] = false #最大ダメージ記録しない
    $game_switches[126] = false #ドラゴンボールカード取得しない
    $game_switches[127] = false #ポルンガカード取得しない
    #$game_switches[128] = false #戦闘終了後イベントNo追加
    $game_switches[129] = false #味方の攻撃必ず当たる
    $game_switches[130] = false #敵の攻撃必ず当たる
    #$game_switches[133] = false
    #$game_switches[134] = false
    $game_switches[135] = false #エンカウント音鳴らさない
    #$game_switches[136] = false #別ので使用しているためOFFにしない
    $game_switches[137] = false #撃破時倒したではなく大ダメージと表示(敵キャラにもフラグ立っていると有効)
    #$game_switches[138] = false
    #$game_switches[140] = false
    #$game_switches[140] = false
    $game_switches[141] = false #戦闘終了後全回復フラグ
    $game_switches[148] = false #戦闘勝利時BGMを鳴らさないフラグ
    $game_switches[475] = false #MAPから戦闘イベント実行
    $game_switches[477] = false #時の間特殊カード落とす
    $game_variables[241] = 0 #時の間特殊カードドロップ率1
    $game_variables[242] = 0 
    $game_variables[243] = 0
    $game_variables[244] = 0
    $game_variables[245] = 0
    $game_variables[246] = 0 #時の間特殊カード種類1
    $game_variables[247] = 0
    $game_variables[248] = 0
    $game_variables[249] = 0
    $game_variables[250] = 0
    $game_variables[306] = 0 #時の間用共有経験値の取得値
    $game_variables[317] = 0 #時の間用CAPの取得値
    $game_variables[318] = 0 #時の間用SPの取得値
    $cha_hikari_turn = [] #光の旅ターン数

  end
  #--------------------------------------------------------------------------
  # ● 縦カーソル点滅制御
  # n:マイナス調整分 tenmetu: 0チェックなし 1:チェックあり blink: 0:x,1:xxを取得
  #--------------------------------------------------------------------------
  def set_tate_cursor_blink tenmetu=1,n=0,blink=0
    
    x = 0
    xx = 0
    case $skin_kanri
    
    when "Z1_","Z2_"
      x = 12*16
      xx = 14*16
    when "Z3_"
      x = 16*16
      xx = 18*16
    when "ZG_"
      #x = 1*16
      #xx = 10*16
      x = 24*16
      xx = 26*16
    when "ZSSD_"
      x = 20*16
      xx = 22*16
    when "DB2_"
      x = 33*16
      xx = 35*16
    when "DB3_"
      x = 37*16
      xx = 39*16
    else
      x = 12*16
      xx = 14*16
    end
    
    x -= 16*n 
    xx -= 16*n
    
    #ショップ内だと何故か点滅が早すぎるのでその対策
    #
    case $game_variables[421]
    
    when 0 #ショップ以外
      tenmetubairitu = 1
    when 1..3 #ショップ内
      tenmetubairitu = 3
    end
    
    #MSG選択肢選択中でも何故か点滅が早すぎるのでその対策
    #Window_Selectable,Window_Message
    #上記の処理で回カウントがされているため
    if $game_switches[493] == true 
      tenmetubairitu = 2
    end
    if blink == 1 
      return Rect.new(xx, 0, 16, 16) # アイコン
    elsif $cursor_blink_count <= 8 * tenmetubairitu || tenmetu==0
      return Rect.new(x, 0, 16, 16) # アイコン
    elsif $cursor_blink_count <= 16 * tenmetubairitu
      return Rect.new(xx, 0, 16, 16) # アイコン
    else
      $cursor_blink_count = 0
      return Rect.new(x, 0, 16, 16) # アイコン
    end
  end

  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     call_state : どのプログラムから呼ばれたか 1:戦闘 2:マップ 3:カード 4:修行
  #--------------------------------------------------------------------------

  def update_inparty_detail_status(call_state = 1)
      
    for x in 0..$partyc.size - 1
      
      if call_state  == 1
        #ミラクル全開パワー
        $cha_mzenkai_num[x] = $full_cha_mzenkai_num[$partyc[x]] if $full_cha_mzenkai_num[$partyc[x]] != nil
        #必殺技カード使用
        $cha_ki_zero[x] = $full_cha_ki_zero[$partyc[x]] if $full_cha_ki_zero[$partyc[x]] != nil
        
        #湧き出る力
        $cha_wakideru_rand[x] = $full_cha_wakideru_rand[$partyc[x]] if $full_cha_wakideru_rand[$partyc[x]] != nil  
        $cha_wakideru_flag[x] = $full_cha_wakideru_flag[$partyc[x]] if $full_cha_wakideru_flag[$partyc[x]] != nil
        
        #気を溜める
        $cha_ki_tameru_rand[x] = $full_cha_ki_tameru_rand[$partyc[x]] if $full_cha_ki_tameru_rand[$partyc[x]] != nil
        $cha_ki_tameru_flag[x] = $full_cha_ki_tameru_flag[$partyc[x]] if $full_cha_ki_tameru_flag[$partyc[x]] != nil
        
        #先手必勝
        $cha_sente_rand[x] = $full_cha_sente_rand[$partyc[x]] if $full_cha_sente_rand[$partyc[x]] != nil
        $cha_sente_flag[x] = $full_cha_sente_flag[$partyc[x]] if $full_cha_sente_flag[$partyc[x]] != nil
        
        #先手カード
        if $full_cha_sente_card_flag[$partyc[x]] != nil
          $cha_sente_card_flag[x] = $full_cha_sente_card_flag[$partyc[x]] 
        else
          $cha_sente_card_flag[x] = false
        end
        
        #回避カード
        if $full_cha_kaihi_card_flag[$partyc[x]] != nil
          $cha_kaihi_card_flag[x] = $full_cha_kaihi_card_flag[$partyc[x]] 
        else
          $cha_kaihi_card_flag[x] = false
        end
          
        #パワーアップカード
        if $full_cha_power_up[$partyc[x]] != nil
          $cha_power_up[x] = $full_cha_power_up[$partyc[x]]
        else
          $cha_power_up[x] = false
        end
          
        #ディフェンスアップカード
        if $full_cha_defense_up[$partyc[x]] != nil
          $cha_defense_up[x] = $full_cha_defense_up[$partyc[x]]
        else
          $cha_defense_up[x] = false
        end
        
        #戦闘継続回数
        if $full_cha_btl_cont_part_turn[$partyc[x]] != nil
          $cha_btl_cont_part_turn[x] = $full_cha_btl_cont_part_turn[$partyc[x]] 
        else
          $cha_btl_cont_part_turn[x] = 0
        end
        
        #かなしばりターン数
        if $full_cha_stop_num[$partyc[x]] != nil
          $cha_stop_num[x] = $full_cha_stop_num[$partyc[x]]
        else
          $cha_stop_num[x] = 0
        end
      end

      #大猿状態
      #まず初期化
      $cha_bigsize_on = [false,false,false,false,false,false,false,false,false]  #キャラ巨大化

      #トーマ
      if $oozaru_flag[1] == true
        chano = 27
        if $partyc.index(chano) != nil
          $cha_bigsize_on[$partyc.index(chano)] = true
        end
      end
      
      #セリパ
      if $oozaru_flag[2] == true
        chano = 28
        if $partyc.index(chano) != nil
          $cha_bigsize_on[$partyc.index(chano)] = true
        end
      end
      #トテッポ
      if $oozaru_flag[3] == true
        chano = 29
        if $partyc.index(chano) != nil
          $cha_bigsize_on[$partyc.index(chano)] = true
        end
      end
      
      #パンブーキン
      if $oozaru_flag[4] == true
        chano = 30
        if $partyc.index(chano) != nil
          $cha_bigsize_on[$partyc.index(chano)] = true
        end
      end
      
      #悟飯
      if $oozaru_flag[5] == true
        chano = 5
        if $partyc.index(chano) != nil
          $cha_bigsize_on[$partyc.index(chano)] = true
        end
      end
      
      if call_state == 5 #メンバーチェンジの時のみ実行
        #生きているか
        if $full_chadead[$partyc[x]] != nil
          #p x,$full_chadead[$partyc[x]],$chadeadchk[x]
          $chadead[x] = $full_chadead[$partyc[x]]
          $chadeadchk[x] = $full_chadead[$partyc[x]] 
          #p x,$full_chadead[$partyc[x]],$chadeadchk[x]
        else
          $chadead[x] = false
          $chadeadchk[x] = false
        end
      end
      
    end
  end
  
  #--------------------------------------------------------------------------
  # ● パーティー入れ替え時に詳細情報を更新する(入れ替えは別でやる予定)
  #     call_state : どのプログラムから呼ばれたか 1:戦闘 2:マップ 3:カード 4:修行
  #--------------------------------------------------------------------------
  def update_party_detail_status(call_state = 2)
  
  get_sinario_full_party
  for x in 0..$partyc.size - 1
    
    if call_state == 1
      $full_cha_mzenkai_num[$partyc[x]]         = $cha_mzenkai_num[x]
      $full_cha_ki_zero[$partyc[x]]             = $cha_ki_zero[x]
      $full_cha_wakideru_rand[$partyc[x]]       = $cha_wakideru_rand[x]
      $full_cha_wakideru_flag[$partyc[x]]       = $cha_wakideru_flag[x]
      $full_cha_ki_tameru_rand[$partyc[x]]      = $cha_ki_tameru_rand[x]
      $full_cha_ki_tameru_flag[$partyc[x]]      = $cha_ki_tameru_flag[x]
      $full_cha_sente_rand[$partyc[x]]          = $cha_sente_rand[x]
      $full_cha_sente_flag[$partyc[x]]          = $cha_sente_flag[x]
      $full_cha_sente_card_flag[$partyc[x]]     = $cha_sente_card_flag[x]
      $full_cha_kaihi_card_flag[$partyc[x]]     = $cha_kaihi_card_flag[x]
      $full_cha_power_up[$partyc[x]]            = $cha_power_up[x]
      $full_cha_defense_up[$partyc[x]]          = $cha_defense_up[x]
      $full_cha_btl_cont_part_turn[$partyc[x]]  = $cha_btl_cont_part_turn[x]
      $full_cha_stop_num[$partyc[x]]  = $cha_stop_num[x]
    end
    
    $full_chadead[$partyc[x]]                 = $chadead[x]
    
    
  end
  
  for x in 0..$MAX_ACTOR_NUM
    #p "$full_chadead:" + $full_chadead,"x:" + x,"$partyc[x]:" + $partyc[x],"$full_chadead[$partyc[x]]:" + $full_chadead[$partyc[x]]
    
    #死亡フラグ初期化
    #フル死亡フラグがブランク(パーティー内に居ない)かつ、パーティー編成内であれば生きているとする
    if $full_chadead[x] == nil && $full_party_menber.index(x) != nil
      $full_chadead[x] = false
    end
  end
=begin
        #M全開パワーと気まぐれようループ
      for x in 0..$cha_mzenkai_num.size - 1
        $cha_mzenkai_num[x] = rand(100) + 1
        #$cha_carda_rand[x] = rand(8)　カードの方なので不要
        #$cha_cardg_rand[x] = rand(8)　カードの方なので不要
        #$cha_cardi_rand[x] = create_card_i 0　カードの方なので不要
        $cha_wakideru_flag[x] = false #湧き出る力フラグ初期化
        $cha_wakideru_rand[x] = rand(100)+1      #湧き出る力スキル用乱数
        $cha_ki_tameru_flag[x] = false #気を溜めるフラグ初期化
        $cha_ki_tameru_rand[x] = rand(100)+1      #気を溜めるスキル用乱数
        $cha_sente_flag[x] = false #先手フラグ初期化
        $cha_sente_rand[x] = rand(100)+1      #先手スキル用乱数
        if x <= $partyc.size - 1
          set_skill_nil_to_zero $partyc[x]
          get_mp_cost $partyc[x],1 #湧き出る力フラグ更新のためチェックを実行
          get_skill_kiup $partyc[x] #気を溜めるフラグ更新のためチェックを実行
          get_skill_sente $partyc[x] #先手フラグ更新のためチェックを実行
        end
        
        
      end
=end
=begin
    #戦闘中入れ替え用
    $full_cha_mzenkai_num = []        #M全快パワー乱数
    $full_cha_carda_rand = []         #気まぐれスキルようカード攻撃の星乱数
    $full_cha_cardg_rand = []         #気まぐれスキルようカード防御の星乱数
    $full_cha_cardi_rand = []         #気まぐれスキルようカード流派乱数
    $full_cha_ki_zero = []  #KIの消費0
    $full_cha_wakideru_rand = []      #湧き出る力スキル用乱数
    $full_cha_wakideru_flag = [] #湧き出る力スキル有効フラグ
    $full_cha_ki_tameru_rand = []      #気を溜めるスキル用乱数
    $full_cha_ki_tameru_flag = [] #気を溜めるスキル有効フラグ
    $full_cha_sente_rand = []      #先手スキル用乱数
    $full_cha_sente_flag = [] #先手スキル有効フラグ
    $full_cha_sente_card_flag = [] #先手スキル有効フラグ
    $full_cha_kaihi_card_flag = [] #回避有効フラグ
    $full_cha_power_up = []        #界王様か最長老が使われているか？
    $full_cha_defense_up = []      #ディフェンスアップ
    $full_cha_btl_cont_part_turn = [] #戦闘連続参加ターン数
    $full_chadead = [] #全パーティーの死亡状態(戦闘中交代する事を考慮し、追加)
=end
end

  #--------------------------------------------------------------------------
  # ● パーティー全体の配列を初期化する
  #--------------------------------------------------------------------------
  def reset_full_party_list
    $full_cha_mzenkai_num = []        #M全快パワー乱数
    $full_cha_carda_rand = []         #気まぐれスキルようカード攻撃の星乱数
    $full_cha_cardg_rand = []         #気まぐれスキルようカード防御の星乱数
    $full_cha_cardi_rand = []         #気まぐれスキルようカード流派乱数
    $full_cha_ki_zero = []  #KIの消費0
    $full_cha_wakideru_rand = []      #湧き出る力スキル用乱数
    $full_cha_wakideru_flag = [] #湧き出る力スキル有効フラグ
    $full_cha_ki_tameru_rand = []      #気を溜めるスキル用乱数
    $full_cha_ki_tameru_flag = [] #気を溜めるスキル有効フラグ
    $full_cha_sente_rand = []      #先手スキル用乱数
    $full_cha_sente_flag = [] #先手スキル有効フラグ
    $full_cha_sente_card_flag = [] #先手スキル有効フラグ
    $full_cha_kaihi_card_flag = [] #回避有効フラグ
    $full_cha_power_up = []        #界王様か最長老が使われているか？
    $full_cha_defense_up = []      #ディフェンスアップ
    $full_cha_btl_cont_part_turn = [] #戦闘連続参加ターン数
    $full_cha_stop_num = [] #かなしばりターン数
  end
  #--------------------------------------------------------------------------
  # ● パーティー入れ替え時に使用する
  #--------------------------------------------------------------------------
  def update_party_del_list
    $party_del_list=[]
    get_sinario_full_party
    
    #時の間以外なら実行
    if $game_variables[43] != 999
      for x in 3..$MAX_ACTOR_NUM
        if $full_party_menber.index(x) == nil
          $party_del_list.push(x)
        end
      end
    end

  end
  #--------------------------------------------------------------------------
  # ● シナリオ時の全パーティー
  # 9人を超える場合は、ここから取得する
  #--------------------------------------------------------------------------
  def get_sinario_full_party
    
    #フルパーティーメンバー
    $full_party_menber = []
    
    case $game_variables[43] #あらすじNo
    
      when 90..91 #メタルクウラ編
        $full_party_menber = [3,14,4,5,18,6,7,8,9,10,24,12,19,17,20,15]
        #ヤジロベー、ネイル、バーダック、16号～18号、未来悟飯、トーマ、セリパ、トテッポ、パンブーキン、サタン以外
      when 92..93,95..96 #13号編、セルゲーム編
        $full_party_menber = [3,14,4,5,18,6,7,8,9,10,24,12,19,17,20,23]
        #ヤジロベー、ネイル、若者、バーダック、17号～18号未来悟飯、トーマ、セリパ、トテッポ、パンブーキン、サタン以外
      when 97 #セルゲーム編(悟空と16号除外)
        $full_party_menber = [4,5,18,6,7,8,9,10,24,12,19,17,20]
        #悟空、ヤジロベー、ネイル、若者、バーダック、16号、17号～18号未来悟飯、トーマ、セリパ、トテッポ、パンブーキン、サタン以外
      when 121 #ブロリー編
        $full_party_menber = [3,14,4,5,18,6,7,8,9,10,24,12,19,17,20]
        #ヤジロベー、ネイル、若者、バーダック、16号～18号、未来悟飯、トーマ、セリパ、トテッポ、パンブーキン、サタン以外
      when 126,127,128 #ボージャック編
        $full_party_menber = [4,5,18,6,7,8,9,10,24,12,19,17,20]
        #悟空、ヤジロベー、ネイル、若者、バーダック、16号～18号、未来悟飯、トーマ、セリパ、トテッポ、パンブーキン、サタン以外
      when 171..200 #外伝全員集合後
        $full_party_menber = [3,14,4,5,18,12,19,17,20,25,26,6,7,8,9,16,32,27,28,29,30,10,24,15,21,22,23]
        #ヤジロベー、ネイル、サタン以外
      when 801 #パイクーハン、ブウ、アラレ戦用
        $full_party_menber = [3,14,4,5,18,12,19,17,20,25,26,6,7,8,9,16,32,27,28,29,30,10,24,15,21,22,23]
        #ヤジロベー、ネイル、サタン以外
        
    end
      
  end
  #--------------------------------------------------------------------------
  # ● フルパーティー配列作成処理
  #--------------------------------------------------------------------------
  def get_full_party
    
    get_sinario_full_party
    #パーティー外メンバー
    temp_out_party = Marshal.load(Marshal.dump($full_party_menber))
    #パーティー内メンバー
    temp_in_party = Marshal.load(Marshal.dump($partyc))
    #パーティーフルメンバー
    temp_full_party = []
    temp_cha1 = 0 #処理対象No1
    temp_cha2 = 0 #処理対象No2
    
    for x in 0..$partyc.size - 1

      case $partyc[x]
      
      when 3,14 #悟空
        temp_cha1 = 3
        temp_cha2 = 14
      when 5,18 #悟飯
        temp_cha1 = 5
        temp_cha2 = 18
      when 12,19 #ベジータ
        temp_cha1 = 12
        temp_cha2 = 19
      when 17,20 #トランクス
        temp_cha1 = 17
        temp_cha2 = 20
     when 25,26 #未来悟飯
        temp_cha1 = 25
        temp_cha2 = 26
      when 16,32 #バーダック
        temp_cha1 = 16
        temp_cha2 = 32
      else #その他のキャラはそのまま格納
        temp_cha1 = $partyc[x]
        temp_cha2 = 0
      end
      
      #1人目のキャラが居るかチェックいたら外れているメンバーから消す
      if temp_out_party.index(temp_cha1) != nil
        temp_out_party.delete_at(temp_out_party.index(temp_cha1))
      end
      
      #2人目のキャラが居るかチェックいたら外れているメンバーから消す
      if temp_out_party.index(temp_cha2) != nil
        temp_out_party.delete_at(temp_out_party.index(temp_cha2))
      end
      #p $partyc[x],temp_out_party
    end
    

    #悟空
    temp_cha1 = 3
    temp_cha2 = 14
    if $super_saiyazin_flag[1] == true
      temp_out_party.delete_at(temp_out_party.index(temp_cha1)) if temp_out_party.index(temp_cha1) != nil
    else
      temp_out_party.delete_at(temp_out_party.index(temp_cha2)) if temp_out_party.index(temp_cha2) != nil
    end
    #悟飯
    temp_cha1 = 5
    temp_cha2 = 18
    if $super_saiyazin_flag[2] == true || $super_saiyazin_flag[5] == true
      temp_out_party.delete_at(temp_out_party.index(temp_cha1)) if temp_out_party.index(temp_cha1) != nil
    else
      temp_out_party.delete_at(temp_out_party.index(temp_cha2)) if temp_out_party.index(temp_cha2) != nil
    end
    #ベジータ
    temp_cha1 = 12
    temp_cha2 = 19
    if $super_saiyazin_flag[3] == true
      temp_out_party.delete_at(temp_out_party.index(temp_cha1)) if temp_out_party.index(temp_cha1) != nil
    else
      temp_out_party.delete_at(temp_out_party.index(temp_cha2)) if temp_out_party.index(temp_cha2) != nil
    end
    #悟飯
    temp_cha1 = 17
    temp_cha2 = 20
    if $super_saiyazin_flag[4] == true
      temp_out_party.delete_at(temp_out_party.index(temp_cha1)) if temp_out_party.index(temp_cha1) != nil
    else
      temp_out_party.delete_at(temp_out_party.index(temp_cha2)) if temp_out_party.index(temp_cha2) != nil
    end
    #未来悟飯
    temp_cha1 = 25
    temp_cha2 = 26
    if $super_saiyazin_flag[6] == true
      temp_out_party.delete_at(temp_out_party.index(temp_cha1)) if temp_out_party.index(temp_cha1) != nil
    else
      temp_out_party.delete_at(temp_out_party.index(temp_cha2)) if temp_out_party.index(temp_cha2) != nil
    end
    #バーダック
    temp_cha1 = 16
    temp_cha2 = 32
    if $super_saiyazin_flag[7] == true
      temp_out_party.delete_at(temp_out_party.index(temp_cha1)) if temp_out_party.index(temp_cha1) != nil
    else
      temp_out_party.delete_at(temp_out_party.index(temp_cha2)) if temp_out_party.index(temp_cha2) != nil
    end
    
    #フルパーティー配列にパーティー内にいるメンバーを追加
    temp_full_party.push(temp_in_party)
    #フルパーティー配列にパーティー外のメンバーを追加
    temp_full_party.push(temp_out_party)
    #配列を使える状態にする
    temp_full_party.flatten!
    #p temp_full_party
    
    return temp_full_party
  end
  

  #--------------------------------------------------------------------------
  # ● カード使用回数追加
  #--------------------------------------------------------------------------
  def card_run_num_add x
    $card_run_num[x] = 0 if $card_run_num[x] == nil
    $card_run_num[x] += 1
  end
  #--------------------------------------------------------------------------
  # ● 味方敵キャラ撃破数
  #--------------------------------------------------------------------------
  def cha_defeat_num_add x
    $cha_defeat_num[x] = 0 if $cha_defeat_num[x] == nil
    $cha_defeat_num[x] += 1
    
    #亀仙人の魔封波ひらめき可能チェック
    run_common_event 38
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラ個別撃破数
  #--------------------------------------------------------------------------
  def ene_defeat_num_add x
    $ene_defeat_num[x] = 0 if $ene_defeat_num[x] == nil
    $ene_defeat_num[x] += 1
  end

  #--------------------------------------------------------------------------
  # ● スキンの設定
  #--------------------------------------------------------------------------
  def set_skn
    if $game_variables[83] == 0                   # スキンがデフォルトなら
      if $game_variables[43] >= 151 && $game_variables[43] <= 200
        chk_scenario_progress 3,1   # スキン設定 #外伝シナリオ中なら外伝スキル
      else
        chk_scenario_progress $game_variables[40],1   # スキン設定
      end
    else
      chk_scenario_progress $game_variables[83]-1,1
    end
  end
  #--------------------------------------------------------------------------
  # ● 初期値など最初に設定するもの
  # n:スタートかコンティニュー 0:スタート 1:コンティニユー
  #--------------------------------------------------------------------------
  def set_start_val n=0
    
    get_item                                      # アイテム取得
    set_tecspark                                  # 閃きスキル設定
    set_scombo                                    # スパーキングコンボ設定
    set_card_compo                                # カード合成設定
    set_cha_skill                                 # スキルセット
    set_typical_skill_first                           # 固有スキルセット
    set_skn                                       # スキンのセット
    

    
    $game_variables[228] = $okiniiri_btlnum
    
=begin
    #敵の追加パラメータ取得
    get_add_ene_pra
    
    #敵のステータス調整(画面からセットできない数値)
    #パイクーハン
    $data_enemies[215].atk = 1200
    #ブウ
    $data_enemies[254].atk = 1450
    #アラレ
    $data_enemies[153].atk = 1800
=end
    #バトルアリーナアラレのランク(if分で使っている)
    $game_variables[343] = 69
    #メッセージ高速化無効フラグを解除
    $game_switches[71] = false
    case n
    
    when 0
      #if $bar_mode_flag == false
        $game_variables[41] = 1                       # イベント自動実行用に変数格納
      #else
      #  $game_variables[41] = 800
      #end
      
    when 1
      #撃破数初期化
      for x in 1..$data_actors.size - 1
        $cha_defeat_num[x] = 0 if $cha_defeat_num[x] == nil  
      end
      $game_actors[1].name = ""
      $game_actors[3].name = "ゴクウ"
      $game_actors[5].name = "ゴハン"
      #$game_variables[39] = 0 #バブルス使用ターンを初期化
      
      #界王以降は超武闘伝修行テーマ追加
      if $game_variables[43] > 10
        $game_switches[157] = true
      end
      
      #シナリオの進行状態を見て
      case $game_variables[40]
      
      when 0 
        $cardi_max = 6           #流派種類最大数
      when 1
        $cardi_max = 7
      when 2
        $cardi_max = 10
        $game_switches[381] = true #悟空流派ボロボロフラグ
      end
      $game_variables[21] = 0
      set_encount_se #エンカウント音設定
      get_item
      
      if $game_variables[224] == 0 #カード所持枚数初期化
        $game_variables[224] = 1
        $game_variables[225] = 1
        $game_variables[226] = 2
        $game_variables[227] = 3
        
      end
      chk_cha_get_skill_adjust
      
    when 2 #ZPの使用量を計算
      #p $data_actors[3].parameters[0, 1]
      #過去Verのため1回のみ
      if $game_switches[484] == false
         
        
        $runzp = []
        for x in 1..$data_actors.size - 1
          upnum = 0
          tempzp = 0
          temppluszp = 0
          
          chalv = $game_actors[x].level
          #HP
          upnum = 4
          temppluszp = $game_actors[x].maxhp - $data_actors[x].parameters[0, chalv]
          temppluszp = temppluszp / upnum
          tempzp += temppluszp
          
          #MP
          upnum = 3
          temppluszp = $game_actors[x].maxmp - $data_actors[x].parameters[1, chalv]
          temppluszp = temppluszp / upnum
          tempzp += temppluszp
          
          #攻撃力
          upnum = 1
          temppluszp = $game_actors[x].atk - $data_actors[x].parameters[2, chalv]
          temppluszp = temppluszp / upnum
          tempzp += temppluszp
          
          #防御力
          upnum = 1
          temppluszp = $game_actors[x].def - $data_actors[x].parameters[3, chalv]
          temppluszp = temppluszp / upnum
          tempzp += temppluszp
          
          #スピード
          upnum = 1
          temppluszp = $game_actors[x].agi - $data_actors[x].parameters[5, chalv]
          temppluszp = temppluszp / upnum
          tempzp += temppluszp
          
          #格納
          $runzp[x] = tempzp.to_i
          #p x,$runzp[x]
        end
        
        #計算済みフラグ
        $game_switches[484] = true
      end
      
    when 3 #キャラのmaxlvチェック

      #過去Verのため1回のみ
      if $cha_maxlv.size == 0
         
        for x in 1..$data_actors.size - 1
          $cha_maxlv[x] = $game_actors[x].level
          
        end
        #$cha_maxlv[3] = 3
      end
    end
    
  end
  #--------------------------------------------------------------------------
  # ● カードのフレームセット
  # n:何をセットするか 0:表 1:裏 2:攻撃 3防御
  #--------------------------------------------------------------------------
  def set_card_frame_tyousei
    
    case $game_variables[83] #ウインドウコモン設定
    
    when 0 #デフォルト
      if $game_variables[40] == 0
        set_no = 1
      elsif $game_variables[40] == 1
        set_no = 2
      elsif $game_variables[40] >= 2
        set_no = 3
      end
    else
      set_no = $game_variables[83]
    end
    
    case set_no
    
    when 3,4
      $output_card_tyousei_x = -2
      $output_card_tyousei_y = -2
    #when 6 #大魔王復活
    #  $output_card_tyousei_x = 10
    #  $output_card_tyousei_y = 8
    end
  end
  #--------------------------------------------------------------------------
  # ● カードのフレームセット
  # n:何をセットするか 0:表 1:裏 2:攻撃 3防御 4:流派枠 5:点滅攻撃 6:点滅防御 7:点滅攻防 8:点滅流派 9:点滅全て 10:マップバトル 11:ランク
  #--------------------------------------------------------------------------
  def set_card_frame n=0,x=0
    #初期化
    #$output_carda_tyousei_x = 0
    #$output_carda_tyousei_y = 0
    #$output_cardg_tyousei_x = 0
    #$output_cardg_tyousei_y = 0
    #$output_cardi_tyousei_x = 0
    #$output_cardi_tyousei_y = 0
    case $game_variables[83] #ウインドウコモン設定
    
    when 0 #デフォルト
      if $game_variables[40] == 0
        set_no = 1
      elsif $game_variables[40] == 1
        set_no = 2
      elsif $game_variables[40] >= 2
        if $game_variables[43] >= 151 && $game_variables[43] <= 200
          set_no = 4
        else
          set_no = 3
        end
      end
    else
      set_no = $game_variables[83]
    end
    
    #n:何をセットするか 0:表 1:裏 2:攻撃 3:防御 4:流派枠
    case set_no
    
    when 1 #Z1
      $output_carda_tyousei_x = 0
      $output_carda_tyousei_y = 0
      $output_cardg_tyousei_x = 0
      $output_cardg_tyousei_y = 0
      $output_cardi_tyousei_x = 0
      $output_cardi_tyousei_y = 0

      return Rect.new(0, 96, 64, 96) if n == 0
      return Rect.new(64, 96, 64, 96) if n == 1
      return Rect.new(0 + 32 * x, 0, 32, 32) if n == 2
      return Rect.new(0 + 32 * x, 32, 32, 32) if n == 3
      return Rect.new(0+64*0, 192, 64, 32) if n == 4
      return Rect.new(64*2, 96, 64, 96) if n == 5
      return Rect.new(64*3, 96, 64, 96) if n == 6
      return Rect.new(64*4, 96, 64, 96) if n == 7
      return Rect.new(64*5, 96, 64, 96) if n == 8
      return Rect.new(64*6, 96, 64, 96) if n == 9
      return Rect.new(0, 224, 96, 16) if n == 10
      return Rect.new(256+x*16, 16, 16, 16) if n == 11
    when 2 #Z2
      $output_carda_tyousei_x = 0
      $output_carda_tyousei_y = 0
      $output_cardg_tyousei_x = 0
      $output_cardg_tyousei_y = 0
      $output_cardi_tyousei_x = 0
      $output_cardi_tyousei_y = 0

      return Rect.new(448, 96, 64, 96) if n == 0
      return Rect.new(64, 96, 64, 96) if n == 1
      return Rect.new(0 + 32 * x, 0, 32, 32) if n == 2
      return Rect.new(0 + 32 * x, 32, 32, 32) if n == 3
      return Rect.new(0+64*0, 192, 64, 32) if n == 4
      return Rect.new(64*2, 96, 64, 96) if n == 5
      return Rect.new(64*3, 96, 64, 96) if n == 6
      return Rect.new(64*4, 96, 64, 96) if n == 7
      return Rect.new(64*5, 96, 64, 96) if n == 8
      return Rect.new(64*6, 96, 64, 96) if n == 9
      return Rect.new(0, 224, 96, 16) if n == 10
      return Rect.new(256+x*16, 16, 16, 16) if n == 11
    when 3 #Z3
      $output_carda_tyousei_x = 0
      $output_carda_tyousei_y = 0
      $output_cardg_tyousei_x = 0
      $output_cardg_tyousei_y = 0
      $output_cardi_tyousei_x = 0
      $output_cardi_tyousei_y = 0

      return Rect.new(512, 96, 64, 96) if n == 0
      #Z4時は裏面のみ変更する
      return Rect.new(384, 272, 64, 96) if n == 1 && $game_switches[431] == true
      return Rect.new(576, 96, 64, 96) if n == 1
      return Rect.new(0 + 32 * x, 272, 32, 32) if n == 2
      return Rect.new(0 + 32 * x, 32, 32, 32) if n == 3
      return Rect.new(0+64*1, 192, 64, 32) if n == 4
      return Rect.new(64*14, 96, 64, 96) if n == 5
      return Rect.new(64*3, 96, 64, 96) if n == 6
      return Rect.new(64*16, 96, 64, 96) if n == 7
      return Rect.new(64*5, 96, 64, 96) if n == 8
      return Rect.new(64*18, 96, 64, 96) if n == 9
      return Rect.new(0, 224, 96, 16) if n == 10
      return Rect.new(256+x*16, 16, 16, 16) if n == 11
    when 4 #Z外伝
      $output_carda_tyousei_x = 0
      $output_carda_tyousei_y = 0
      $output_cardg_tyousei_x = 0
      $output_cardg_tyousei_y = 0
      $output_cardi_tyousei_x = 0
      $output_cardi_tyousei_y = 0

      return Rect.new(640, 96, 64, 96) if n == 0
      return Rect.new(704, 96, 64, 96) if n == 1
      return Rect.new(0 + 32 * x, 304, 32, 32) if n == 2
      return Rect.new(0 + 32 * x, 32, 32, 32) if n == 3
      return Rect.new(0+64*2, 192, 64, 32) if n == 4
      return Rect.new(64*14, 96, 64, 96) if n == 5
      return Rect.new(64*3, 96, 64, 96) if n == 6
      return Rect.new(64*16, 96, 64, 96) if n == 7
      return Rect.new(64*19, 96, 64, 96) if n == 8
      return Rect.new(64*20, 96, 64, 96) if n == 9
      return Rect.new(0, 224, 96, 16) if n == 10
      return Rect.new(256+x*16, 16, 16, 16) if n == 11
    when 5 #超サイヤ伝説
      $output_carda_tyousei_x = 0
      $output_carda_tyousei_y = 0
      $output_cardg_tyousei_x = 0
      $output_cardg_tyousei_y = 0
      $output_cardi_tyousei_x = 0
      $output_cardi_tyousei_y = 0

      return Rect.new(768, 96, 64, 96) if n == 0
      return Rect.new(832, 96, 64, 96) if n == 1
      return Rect.new(0 + 32 * x, 336, 32, 32) if n == 2
      return Rect.new(0 + 32 * x, 368, 32, 32) if n == 3
      return Rect.new(0+64*3, 192, 64, 32) if n == 4
      return Rect.new(64*21, 96, 64, 96) if n == 5
      return Rect.new(64*22, 96, 64, 96) if n == 6
      return Rect.new(64*23, 96, 64, 96) if n == 7
      return Rect.new(64*5, 96, 64, 96) if n == 8
      return Rect.new(64*24, 96, 64, 96) if n == 9
      return Rect.new(96, 224, 96, 16) if n == 10
      return Rect.new(192+x*16, 16, 16, 16) if n == 11
    when 6 #大魔王復活
      #n:何をセットするか 0:表 1:裏 2:攻撃 3防御 4:流派枠 5:点滅攻撃 6:点滅防御 7:点滅攻防 8:点滅流派 9:点滅全て 10:マップバトル 11:ランク
      return Rect.new(512, 272, 64, 96) if n == 0
      return Rect.new(576, 272, 64, 96) if n == 1
      if n == 2
        $output_carda_tyousei_x = 18
        $output_carda_tyousei_y = 6
        return Rect.new(254 + 24 * x, 400, 24, 20) 
      end
      
      if n == 3
        $output_cardg_tyousei_x = -10
        $output_cardg_tyousei_y = 8
        return Rect.new(254 + 24 * x, 420, 24, 20) 
      end
      return Rect.new(0+64*4, 192, 64, 32) if n == 4
      return Rect.new(64*25, 96, 64, 96) if n == 5
      return Rect.new(64*26, 96, 64, 96) if n == 6
      return Rect.new(64*27, 96, 64, 96) if n == 7
      return Rect.new(64*28, 96, 64, 96) if n == 8
      return Rect.new(64*29, 96, 64, 96) if n == 9
      return Rect.new(96, 224, 96, 16) if n == 10
      return Rect.new(192+x*16, 16, 16, 16) if n == 11
    when 7 #悟空伝
      #n:何をセットするか 0:表 1:裏 2:攻撃 3防御 4:流派枠 5:点滅攻撃 6:点滅防御 7:点滅攻防 8:点滅流派 9:点滅全て 10:マップバトル 11:ランク
      return Rect.new(640, 272, 64, 96) if n == 0
      return Rect.new(704, 272, 64, 96) if n == 1
      if n == 2
        $output_carda_tyousei_x = 2
        $output_carda_tyousei_y = 2
        return Rect.new(446 + 28 * x, 400, 28, 24) 
      end
      
      if n == 3
        $output_cardg_tyousei_x = 2
        $output_cardg_tyousei_y = 6
        return Rect.new(446 + 28 * x, 424, 28, 24) 
      end
      return Rect.new(0+64*5, 192, 64, 32) if n == 4
      return Rect.new(64*30, 96, 64, 96) if n == 5
      return Rect.new(64*31, 96, 64, 96) if n == 6
      return Rect.new(64*32, 96, 64, 96) if n == 7
      return Rect.new(64*33, 96, 64, 96) if n == 8
      return Rect.new(64*34, 96, 64, 96) if n == 9
      return Rect.new(96, 224, 96, 16) if n == 10
      return Rect.new(192+x*16, 16, 16, 16) if n == 11
    when 8 #悟空伝
      #n:何をセットするか 0:表 1:裏 2:攻撃 3防御 4:流派枠 5:点滅攻撃 6:点滅防御 7:点滅攻防 8:点滅流派 9:点滅全て 10:マップバトル 11:ランク
      return Rect.new(768, 272, 64, 96) if n == 0
      return Rect.new(832, 272, 64, 96) if n == 1
      if n == 2
        $output_carda_tyousei_x = 2
        $output_carda_tyousei_y = 2
        return Rect.new(670 + 28 * x, 400, 28, 24) 
      end
      
      if n == 3
        $output_cardg_tyousei_x = 2
        $output_cardg_tyousei_y = 6
        return Rect.new(670 + 28 * x, 424, 28, 24) 
      end
      return Rect.new(0+64*5, 192, 64, 32) if n == 4
      return Rect.new(64*30, 96, 64, 96) if n == 5
      return Rect.new(64*31, 96, 64, 96) if n == 6
      return Rect.new(64*32, 96, 64, 96) if n == 7
      return Rect.new(64*33, 96, 64, 96) if n == 8
      return Rect.new(64*34, 96, 64, 96) if n == 9
      return Rect.new(96, 224, 96, 16) if n == 10
      return Rect.new(192+x*16, 16, 16, 16) if n == 11
    end
      
  end
  
  #--------------------------------------------------------------------------
  # ● スキンのデフォルト色をセット
  # n:何をセットするか 0:背景 1:ウインドウ内背景
  #--------------------------------------------------------------------------
  def set_skn_color n=0
    
    if $skin_kanri != nil
      windowskin = Cache.system($skin_kanri + "Window")
    else
      windowskin = Cache.system("Window")
    end
    
    case n
    
    when 0 #背景
      result = windowskin.get_pixel(127, 127)
    when 1 #ウインドウ内背景
      result = windowskin.get_pixel(0, 0)
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # ● 超サイヤ人の時に元キャラが何番かを返す
  # cha_no:キャラクターNo exp:経験値
  #--------------------------------------------------------------------------
  def get_ori_cha_no cha_no
    
    temp_cha_no = cha_no
    
    case temp_cha_no
    
    when 14 #悟空(超)
      temp_cha_no = 3
    when 18 #悟飯(超)
      temp_cha_no = 5
    when 19 #ベジータ(超)
      temp_cha_no = 12
    when 20 #トランクス(超)
      temp_cha_no = 17
    when 26 #未来悟飯(超)
      temp_cha_no = 25
    when 32 #バーダック(超)
      temp_cha_no = 16
    end
    
    return temp_cha_no
  end
  
  #--------------------------------------------------------------------------
  # ● さくせんのしょきか
  # cha_no:キャラクターNo 
  #--------------------------------------------------------------------------
  def set_cha_tactics_nil_to_zero cha_no
    #敵の選択
    $cha_tactics[0][cha_no] = 0 if $cha_tactics[0][cha_no] == nil
    
    #必殺技の選択
    $cha_tactics[1][cha_no] = 0 if $cha_tactics[1][cha_no] == nil
    
    #変身技使用有無
    $cha_tactics[2][cha_no] = 0 if $cha_tactics[2][cha_no] == nil
    
    #超サイヤ人状態維持
    $cha_tactics[3][cha_no] = 1 if $cha_tactics[3][cha_no] == nil
    
    #EXP取得
    $cha_tactics[4][cha_no] = 0 if $cha_tactics[4][cha_no] == nil
    
    #気が足りないとき
    $cha_tactics[5][cha_no] = 0 if $cha_tactics[5][cha_no] == nil
    #気が減っている
    $cha_tactics[6][cha_no] = 0 if $cha_tactics[6][cha_no] == nil
    #指定の技ID
    $cha_tactics[7][cha_no] = 0 if $cha_tactics[7][cha_no] == nil
    #KIが減っているとき%
    $cha_tactics[8] = [] if $cha_tactics[8] == nil
    $cha_tactics[8][cha_no] = 1 if $cha_tactics[8][cha_no] == nil
    $cha_tactics[9] = [] if $cha_tactics[9] == nil
    $cha_tactics[9][cha_no] = 0 if $cha_tactics[9][cha_no] == nil
    $cha_tactics[10] = [] if $cha_tactics[10] == nil
    $cha_tactics[10][cha_no] = 0 if $cha_tactics[10][cha_no] == nil
    $cha_tactics[11] = [] if $cha_tactics[11] == nil
    $cha_tactics[11][cha_no] = 0 if $cha_tactics[11][cha_no] == nil
  end

  #--------------------------------------------------------------------------
  # ● ダメージ加算値計算(差分ではなく合計)
  # cha_no:キャラクターNo ene_no:敵キャラNo add:0与える 1:食らう tec_no:必殺No 11以上なら必殺 ene_left_num:敵何番目か
  #--------------------------------------------------------------------------
  def set_damage_add cha_no,ene_no,damage,add,tec_no = 0,ene_left_num = 0
    
    temp_damage = damage.prec_f
    #temp_cha_no = get_ori_cha_no cha_no
    #temp_cha_no = cha_no
    temp_cha_no = []
    temp_ene_no = ene_no
    temp_cha_skill = []
    temp_nakama_skill = []
    temp_skill_no = 0
    temp_nakama_skill_no = 0
    temp_ene_left_num = ene_left_num
    temp_card_no = $cardset_cha_no.index($partyc.index(cha_no))
    $tmp_run_skill = [] #発動したスキルを格納の初期化
    kizuna_num = 0
    kakuritu = 0
    bairitu = 0.prec_f
    skill_effect_flag = false
    

    if $data_skills[tec_no-10].element_set.index(33) != nil
      #使用技がSコンボだった
      #p "Sコンボである"
      temp_cha_no.concat($tmp_btl_ani_scombo_cha)
    else
      #通常攻撃または一人の必殺技だった
      #p "Sコンボじゃない"
      temp_cha_no.concat([cha_no])
    end
    
    #経験値を上げるスキルなどが付いていないかチェック
    for y in 0..temp_cha_no.size - 1
      #配列なるべく0に
      set_skill_nil_to_zero temp_cha_no[y]
      #tempに所持スキルを追加
      if $cha_typical_skill != []
        for x in 0..$cha_typical_skill[temp_cha_no[y]].size
          temp_cha_skill << $cha_typical_skill[temp_cha_no[y]][x]
        end
      end
      
      if $cha_add_skill != []
        for x in 0..$cha_add_skill[temp_cha_no[y]].size
          #取得できているかチェック
          #nilと0はからにする
          if $cha_add_skill[temp_cha_no[y]][x] != nil && $cha_add_skill[temp_cha_no[y]][x] != 0 && 
            $cha_skill_spval[temp_cha_no[y]][$cha_add_skill[temp_cha_no[y]][x]] >= $cha_skill_get_val[$cha_add_skill[temp_cha_no[y]][x]]
            #取得できている(スキルNoを追加)
            temp_cha_skill << $cha_add_skill[temp_cha_no[y]][x]
          else
            #取得できていない(0を追加)
            temp_cha_skill << 0
          end
        end
      end      
    end
      
      #スキルまとめ
      #p temp_cha_skill

      
      cha_cardag_sum = ($carda[temp_card_no] + $cardg[temp_card_no])
      ene_cardag_sum = ($enecarda[temp_ene_left_num] + $enecardg[temp_ene_left_num])
      
      if add == 0 #与えるダメージ
        #様子見====================================================
        #ダメージには関係ないが、発動判定はここで行う。
        #敵の方が攻防の星の合計が大きければ発動
        if temp_cha_skill.index(633) != nil && #様子見9
          cha_cardag_sum < ene_cardag_sum
          $tmp_run_skill << 633
          bairitu += 1.00
          skill_effect_flag = true
          $skill_yousumi_runflag = true
        elsif temp_cha_skill.index(632) != nil && #様子見8
          cha_cardag_sum < ene_cardag_sum
          $tmp_run_skill << 632
          bairitu += 1.00
          skill_effect_flag = true
          $skill_yousumi_runflag = true
        elsif temp_cha_skill.index(631) != nil && #様子見7
          cha_cardag_sum < ene_cardag_sum
          $tmp_run_skill << 631
          bairitu += 1.00
          skill_effect_flag = true
          $skill_yousumi_runflag = true
        elsif temp_cha_skill.index(630) != nil && #様子見6
          cha_cardag_sum < ene_cardag_sum
          $tmp_run_skill << 630
          bairitu += 1.00
          skill_effect_flag = true
          $skill_yousumi_runflag = true
        elsif temp_cha_skill.index(629) != nil && #様子見5
          cha_cardag_sum < ene_cardag_sum
          $tmp_run_skill << 629
          bairitu += 1.00
          skill_effect_flag = true
          $skill_yousumi_runflag = true
        elsif temp_cha_skill.index(628) != nil && #様子見4
          cha_cardag_sum < ene_cardag_sum
          $tmp_run_skill << 628
          bairitu += 1.00
          skill_effect_flag = true
          $skill_yousumi_runflag = true
        elsif temp_cha_skill.index(627) != nil && #様子見3
          cha_cardag_sum < ene_cardag_sum
          $tmp_run_skill << 627
          bairitu += 1.00
          skill_effect_flag = true
          $skill_yousumi_runflag = true
        elsif temp_cha_skill.index(626) != nil && #様子見2
          cha_cardag_sum < ene_cardag_sum
          $tmp_run_skill << 626
          bairitu += 1.00
          skill_effect_flag = true
          $skill_yousumi_runflag = true
        elsif temp_cha_skill.index(625) != nil && #様子見1
          cha_cardag_sum < ene_cardag_sum
          $tmp_run_skill << 625
          bairitu += 1.00
          skill_effect_flag = true
          $skill_yousumi_runflag = true
        end
        #見下す====================================================
        if temp_cha_skill.index(401) != nil && #見下す9
          cha_cardag_sum > ene_cardag_sum
          bairitu += 1.35
          $tmp_run_skill << 401
          skill_effect_flag = true
        elsif temp_cha_skill.index(400) != nil && #見下す8
          cha_cardag_sum > ene_cardag_sum
          bairitu += 1.29
          $tmp_run_skill << 400
          skill_effect_flag = true
        elsif temp_cha_skill.index(399) != nil && #見下す7
          cha_cardag_sum > ene_cardag_sum
          bairitu += 1.27
          $tmp_run_skill << 399
          skill_effect_flag = true
        elsif temp_cha_skill.index(398) != nil && #見下す6
          cha_cardag_sum > ene_cardag_sum
          bairitu += 1.25
          $tmp_run_skill << 398
          skill_effect_flag = true
        elsif temp_cha_skill.index(397) != nil && #見下す5
          cha_cardag_sum > ene_cardag_sum
          bairitu += 1.23
          $tmp_run_skill << 397
          skill_effect_flag = true
        elsif temp_cha_skill.index(396) != nil && #見下す4
          cha_cardag_sum > ene_cardag_sum
          bairitu += 1.21
          $tmp_run_skill << 396
          skill_effect_flag = true
        elsif temp_cha_skill.index(395) != nil && #見下す3
          cha_cardag_sum > ene_cardag_sum
          bairitu += 1.19
          $tmp_run_skill << 395
          skill_effect_flag = true
        elsif temp_cha_skill.index(394) != nil && #見下す2
          cha_cardag_sum > ene_cardag_sum
          bairitu += 1.17
          $tmp_run_skill << 394
          skill_effect_flag = true
        elsif temp_cha_skill.index(393) != nil && #見下す1
          cha_cardag_sum > ene_cardag_sum
          bairitu += 1.15
          $tmp_run_skill << 393
          skill_effect_flag = true
        end
 
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end        
        
        #剛腕==========================================================
        if tec_no == 1 #通常攻撃
          if chk_skill_learn(705,temp_cha_no[0])[0] == true #剛腕9
            temp_skillno = 705
            bairitu += $cha_skill_a_kouka[temp_skillno].to_f
            $tmp_run_skill << temp_skillno
            skill_effect_flag = true
          elsif chk_skill_learn(704,temp_cha_no[0])[0] == true #剛腕8
            temp_skillno = 704
            bairitu += $cha_skill_a_kouka[temp_skillno].to_f
            $tmp_run_skill << temp_skillno
            skill_effect_flag = true
          elsif chk_skill_learn(703,temp_cha_no[0])[0] == true #剛腕7
            temp_skillno = 703
            bairitu += $cha_skill_a_kouka[temp_skillno].to_f
            $tmp_run_skill << temp_skillno
            skill_effect_flag = true
          elsif chk_skill_learn(702,temp_cha_no[0])[0] == true #剛腕6
            temp_skillno = 702
            bairitu += $cha_skill_a_kouka[temp_skillno].to_f
            $tmp_run_skill << temp_skillno
            skill_effect_flag = true
          elsif chk_skill_learn(701,temp_cha_no[0])[0] == true #剛腕5
            temp_skillno = 701
            bairitu += $cha_skill_a_kouka[temp_skillno].to_f
            $tmp_run_skill << temp_skillno
            skill_effect_flag = true
          elsif chk_skill_learn(700,temp_cha_no[0])[0] == true #剛腕4
            temp_skillno = 700
            bairitu += $cha_skill_a_kouka[temp_skillno].to_f
            $tmp_run_skill << temp_skillno
            skill_effect_flag = true
          elsif chk_skill_learn(699,temp_cha_no[0])[0] == true #剛腕3
            temp_skillno = 699
            bairitu += $cha_skill_a_kouka[temp_skillno].to_f
            $tmp_run_skill << temp_skillno
            skill_effect_flag = true
          elsif chk_skill_learn(698,temp_cha_no[0])[0] == true #剛腕2
            temp_skillno = 698
            bairitu += $cha_skill_a_kouka[temp_skillno].to_f
            $tmp_run_skill << temp_skillno
            skill_effect_flag = true
          elsif chk_skill_learn(697,temp_cha_no[0])[0] == true #剛腕1
            temp_skillno = 697
            bairitu += $cha_skill_a_kouka[temp_skillno].to_f
            $tmp_run_skill << temp_skillno
            skill_effect_flag = true
          end
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        #サイヤ人魂====================================================
        if temp_cha_skill.index(100) != nil #100:サイヤ人魂9
          bairitu += 1.25
          $tmp_run_skill << 100
          skill_effect_flag = true
        elsif temp_cha_skill.index(99) != nil #5:サイヤ人魂8
          bairitu += 1.19
          $tmp_run_skill << 99
          skill_effect_flag = true
        elsif temp_cha_skill.index(98) != nil #5:サイヤ人魂7
          bairitu += 1.17
          $tmp_run_skill << 98
          skill_effect_flag = true
        elsif temp_cha_skill.index(97) != nil #5:サイヤ人魂6
          bairitu += 1.15
          $tmp_run_skill << 97
          skill_effect_flag = true
        elsif temp_cha_skill.index(96) != nil #5:サイヤ人魂5
          bairitu += 1.13
          $tmp_run_skill << 96
          skill_effect_flag = true
        elsif temp_cha_skill.index(95) != nil #5:サイヤ人魂4
          bairitu += 1.11
          $tmp_run_skill << 95
          skill_effect_flag = true
        elsif temp_cha_skill.index(7) != nil #5:サイヤ人魂3
          bairitu += 1.09
          $tmp_run_skill << 7
          skill_effect_flag = true
        elsif temp_cha_skill.index(6) != nil #5:サイヤ人魂2
          bairitu += 1.07
          $tmp_run_skill << 6
          skill_effect_flag = true
        elsif temp_cha_skill.index(5) != nil #5:サイヤ人魂1
          bairitu += 1.05
          $tmp_run_skill << 5
          skill_effect_flag = true
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        #鋼鉄の拳====================================================
        if temp_cha_skill.index(154) != nil #鋼鉄の拳9
          bairitu += 1.16
          $tmp_run_skill << 154
          skill_effect_flag = true 
        elsif temp_cha_skill.index(153) != nil #鋼鉄の拳8
          bairitu += 1.135
          $tmp_run_skill << 153
          skill_effect_flag = true 
        elsif temp_cha_skill.index(152) != nil #鋼鉄の拳7
          bairitu += 1.12
          $tmp_run_skill << 152
          skill_effect_flag = true 
        elsif temp_cha_skill.index(151) != nil #鋼鉄の拳6
          bairitu += 1.105
          $tmp_run_skill << 151
          skill_effect_flag = true 
        elsif temp_cha_skill.index(150) != nil #鋼鉄の拳5
          bairitu += 1.09
          $tmp_run_skill << 150
          skill_effect_flag = true 
        elsif temp_cha_skill.index(149) != nil #鋼鉄の拳4
          bairitu += 1.075
          $tmp_run_skill << 149
          skill_effect_flag = true 
        elsif temp_cha_skill.index(50) != nil #鋼鉄の拳3
          bairitu += 1.06
          $tmp_run_skill << 50
          skill_effect_flag = true 
        elsif temp_cha_skill.index(49) != nil #鋼鉄の拳2
          bairitu += 1.045
          $tmp_run_skill << 49
          skill_effect_flag = true 
        elsif temp_cha_skill.index(48) != nil #鋼鉄の拳1
          bairitu += 1.03
          $tmp_run_skill << 48
          skill_effect_flag = true 
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        #最終決戦====================================================
        if temp_cha_skill.index(8) != nil && #8:最終決戦
          $data_enemies[temp_ene_no].element_ranks[22] == 1
          #もしボス扱いならダメージ増加をチェック
          $tmp_run_skill << 8
          skill_effect_flag = true
          bairitu += 1.25
          
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        #最終決戦改====================================================
        if temp_cha_skill.index(670) != nil && #670:最終決戦改
          $data_enemies[temp_ene_no].element_ranks[22] == 1
          #もしボス扱いならダメージ増加をチェック
          $tmp_run_skill << 670
          skill_effect_flag = true
          bairitu += 1.25
          
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        #王子の誇り====================================================
        if temp_cha_skill.index(429) != nil && #王子の誇り3
          battle_join_count == 1
          bairitu += 1.5
          $tmp_run_skill << 429
          skill_effect_flag = true 
        elsif temp_cha_skill.index(428) != nil && #王子の誇り2
          battle_join_count == 1
          bairitu += 1.3
          $tmp_run_skill << 428
          skill_effect_flag = true  
        elsif temp_cha_skill.index(9) != nil && #王子の誇り3
          battle_join_count == 1
          bairitu += 1.15
          $tmp_run_skill << 9
          skill_effect_flag = true 
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
               
        #Z戦士の絆====================================================
        if temp_cha_skill.index(13) != nil || temp_cha_skill.index(14) != nil || temp_cha_skill.index(15) != nil || temp_cha_skill.index(101) != nil || temp_cha_skill.index(102) != nil || temp_cha_skill.index(103) != nil || temp_cha_skill.index(104) != nil || temp_cha_skill.index(105) != nil || temp_cha_skill.index(106) != nil ||#13～15:Z戦士の絆1～3
           temp_cha_skill.index(678) != nil || temp_cha_skill.index(679) != nil || temp_cha_skill.index(680) != nil || temp_cha_skill.index(681) != nil || temp_cha_skill.index(682) != nil || temp_cha_skill.index(683) != nil || temp_cha_skill.index(684) != nil || temp_cha_skill.index(685) != nil || temp_cha_skill.index(686) != nil #地球育ちのサイヤ人

          if temp_cha_skill.index(686) != nil
            temp_skill_no = 686
          elsif temp_cha_skill.index(106) != nil
            temp_skill_no = 106
          elsif temp_cha_skill.index(685) != nil
            temp_skill_no = 685
          elsif temp_cha_skill.index(105) != nil
            temp_skill_no = 105
          elsif temp_cha_skill.index(684) != nil
            temp_skill_no = 684
          elsif temp_cha_skill.index(104) != nil
            temp_skill_no = 104
          elsif temp_cha_skill.index(683) != nil
            temp_skill_no = 683
          elsif temp_cha_skill.index(103) != nil
            temp_skill_no = 103
          elsif temp_cha_skill.index(682) != nil
            temp_skill_no = 682
          elsif temp_cha_skill.index(102) != nil
            temp_skill_no = 102
          elsif temp_cha_skill.index(681) != nil
            temp_skill_no = 681
          elsif temp_cha_skill.index(101) != nil
            temp_skill_no = 101
          elsif temp_cha_skill.index(680) != nil
            temp_skill_no = 680
          elsif temp_cha_skill.index(15) != nil
            temp_skill_no = 15
          elsif temp_cha_skill.index(679) != nil
            temp_skill_no = 679
          elsif temp_cha_skill.index(14) != nil
            temp_skill_no = 14
          elsif temp_cha_skill.index(678) != nil
            temp_skill_no = 678
          else
            temp_skill_no = 13
          end

            #kizuna_num += 1
            
            kizuna_run_cha_no = 0
            for y in 0..temp_cha_no.size - 1
              #配列なるべく0に
              set_skill_nil_to_zero temp_cha_no[y]
              #tempに所持スキルを追加
              if $cha_typical_skill != []
                for x in 0..$cha_typical_skill[temp_cha_no[y]].size
                  if $cha_typical_skill[temp_cha_no[y]][x] == temp_skill_no
                    kizuna_run_cha_no = temp_cha_no[y]
                  end
                end
              end
              
              if $cha_add_skill != []
                for x in 0..$cha_add_skill[temp_cha_no[y]].size
                  #取得できているかチェック
                  #nilと0はからにする
                  if $cha_add_skill[temp_cha_no[y]][x] != nil && $cha_add_skill[temp_cha_no[y]][x] != 0 && 
                    $cha_skill_spval[temp_cha_no[y]][$cha_add_skill[temp_cha_no[y]][x]] >= $cha_skill_get_val[$cha_add_skill[temp_cha_no[y]][x]]
                    #取得できている(スキルNoを追加)
                    if $cha_add_skill[temp_cha_no[y]][x] == temp_skill_no
                      kizuna_run_cha_no = temp_cha_no[y]
                    end
                  else
                    
                  end
                end
              end      
            end
        
            for y in 0..$cardset_cha_no.size - 1
              if $cardset_cha_no[y] != 99 #99はセットしていないということなので無視
                
                #攻撃者じゃないかつ生きてればチェック
                if $partyc[$cardset_cha_no[y]] != kizuna_run_cha_no && $chadeadchk[$cardset_cha_no[y]] == false

                  set_skill_nil_to_zero $partyc[$cardset_cha_no[y]]
                  temp_nakama_skill = []
                  #tempに仲間の所持スキルを追加
                  if $cha_typical_skill != []
                    for x in 0..$cha_typical_skill[$partyc[$cardset_cha_no[y]]].size
                      temp_nakama_skill << $cha_typical_skill[$partyc[$cardset_cha_no[y]]][x]
                    end
                  end
                  if $cha_add_skill != []
                    for x in 0..$cha_add_skill[$partyc[$cardset_cha_no[y]]].size
                      temp_nakama_skill << $cha_add_skill[$partyc[$cardset_cha_no[y]]][x]
                    end
                  end
                  if temp_nakama_skill.index(13) != nil || temp_nakama_skill.index(14) != nil || temp_nakama_skill.index(15) != nil || temp_nakama_skill.index(101) != nil || temp_nakama_skill.index(102) != nil || temp_nakama_skill.index(103) != nil || temp_nakama_skill.index(104) != nil || temp_nakama_skill.index(105) != nil || temp_nakama_skill.index(106) != nil ||
                    temp_nakama_skill.index(678) != nil || temp_nakama_skill.index(679) != nil || temp_nakama_skill.index(680) != nil || temp_nakama_skill.index(681) != nil || temp_nakama_skill.index(682) != nil || temp_nakama_skill.index(683) != nil || temp_nakama_skill.index(684) != nil || temp_nakama_skill.index(685) != nil || temp_nakama_skill.index(686) != nil #地球育ちのサイヤ人

                    temp_nakama_skill_no = 13
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 14
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 15
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 101
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 102
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 103
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 104
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 105
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 106
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 678
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 679
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 680
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 681
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 682
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 683
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 684
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 685
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 686
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                  end
                end
              end
            end

            if kizuna_num > 0
              skill_effect_flag = true
              $tmp_run_skill << temp_skill_no
            end
            
            if skill_effect_flag == true
              
              bairitu = 0.prec_f
              
              if temp_skill_no == 13 || temp_skill_no == 678 #Z戦士の絆1 or 地球育ちのサイヤ人1
                bairitu = 0.01
              elsif temp_skill_no == 14 || temp_skill_no == 679 #Z戦士の絆2 or 地球育ちのサイヤ人2
                bairitu = 0.02
              elsif temp_skill_no == 15 || temp_skill_no == 680 #Z戦士の絆3 or 地球育ちのサイヤ人3
                bairitu = 0.03
              elsif temp_skill_no == 101 || temp_skill_no == 681 #Z戦士の絆4 or 地球育ちのサイヤ人4
                bairitu = 0.04
              elsif temp_skill_no == 102 || temp_skill_no == 682 #Z戦士の絆5 or 地球育ちのサイヤ人5
                bairitu = 0.05
              elsif temp_skill_no == 103 || temp_skill_no == 683 #Z戦士の絆6 or 地球育ちのサイヤ人6
                bairitu = 0.06
              elsif temp_skill_no == 104 || temp_skill_no == 684 #Z戦士の絆7 or 地球育ちのサイヤ人7
                bairitu = 0.07
              elsif temp_skill_no == 105 || temp_skill_no == 685 #Z戦士の絆8 or 地球育ちのサイヤ人8
                bairitu = 0.08
              else #Z戦士の絆9 or 地球育ちのサイヤ人9
                bairitu = 0.09
              end
              
              #p temp_damage,temp_damage * (1.00 + (bairitu * kizuna_num))
              temp_damage = temp_damage * (1.00 + (bairitu * kizuna_num))
              skill_effect_flag = false
              kizuna_num = 0
              bairitu = 0.prec_f #毎回倍率を初期化する
            end
        end
        
        #サイヤ人の結束====================================================
        if temp_cha_skill.index(80) != nil || temp_cha_skill.index(81) != nil || temp_cha_skill.index(82) != nil || temp_cha_skill.index(83) != nil || temp_cha_skill.index(84) != nil || temp_cha_skill.index(85) != nil || temp_cha_skill.index(86) != nil || temp_cha_skill.index(87) != nil || temp_cha_skill.index(88) != nil#13～15:サイヤ人の結束1～3
          
          
          if temp_cha_skill.index(88) != nil
            temp_skill_no = 88
          elsif temp_cha_skill.index(87) != nil
            temp_skill_no = 87
          elsif temp_cha_skill.index(86) != nil
            temp_skill_no = 86
          elsif temp_cha_skill.index(85) != nil
            temp_skill_no = 85
          elsif temp_cha_skill.index(84) != nil
            temp_skill_no = 84
          elsif temp_cha_skill.index(83) != nil
            temp_skill_no = 83
          elsif temp_cha_skill.index(82) != nil
            temp_skill_no = 82
          elsif temp_cha_skill.index(81) != nil
            temp_skill_no = 81
          else
            temp_skill_no = 80
          end
          
            #kizuna_num += 1
          
            kizuna_run_cha_no = 0
            for y in 0..temp_cha_no.size - 1
              #配列なるべく0に
              set_skill_nil_to_zero temp_cha_no[y]
              #tempに所持スキルを追加
              if $cha_typical_skill != []
                for x in 0..$cha_typical_skill[temp_cha_no[y]].size
                  if $cha_typical_skill[temp_cha_no[y]][x] == temp_skill_no
                    kizuna_run_cha_no = temp_cha_no[y]
                  end
                end
              end
              
              if $cha_add_skill != []
                for x in 0..$cha_add_skill[temp_cha_no[y]].size
                  #取得できているかチェック
                  #nilと0はからにする
                  if $cha_add_skill[temp_cha_no[y]][x] != nil && $cha_add_skill[temp_cha_no[y]][x] != 0 && 
                    $cha_skill_spval[temp_cha_no[y]][$cha_add_skill[temp_cha_no[y]][x]] >= $cha_skill_get_val[$cha_add_skill[temp_cha_no[y]][x]]
                    #取得できている(スキルNoを追加)
                    if $cha_add_skill[temp_cha_no[y]][x] == temp_skill_no
                      kizuna_run_cha_no = temp_cha_no[y]
                    end
                  else
                    
                  end
                end
              end      
            end
        
            for y in 0..$cardset_cha_no.size - 1
              if $cardset_cha_no[y] != 99 #99はセットしていないということなので無視
                
                #攻撃者じゃないかつ生きてればチェック
                if $partyc[$cardset_cha_no[y]] != kizuna_run_cha_no && $chadeadchk[$cardset_cha_no[y]] == false

                  set_skill_nil_to_zero $partyc[$cardset_cha_no[y]]
                  temp_nakama_skill = []
                  #tempに仲間の所持スキルを追加
                  if $cha_typical_skill != []
                    for x in 0..$cha_typical_skill[$partyc[$cardset_cha_no[y]]].size
                      temp_nakama_skill << $cha_typical_skill[$partyc[$cardset_cha_no[y]]][x]
                    end
                  end
                  if $cha_add_skill != []
                    for x in 0..$cha_add_skill[$partyc[$cardset_cha_no[y]]].size
                      temp_nakama_skill << $cha_add_skill[$partyc[$cardset_cha_no[y]]][x]
                    end
                  end
                  if temp_nakama_skill.index(80) != nil || temp_nakama_skill.index(81) != nil || temp_nakama_skill.index(82) != nil || temp_nakama_skill.index(83) != nil || temp_nakama_skill.index(84) != nil || temp_nakama_skill.index(85) != nil || temp_nakama_skill.index(86) != nil || temp_nakama_skill.index(87) != nil || temp_nakama_skill.index(88) != nil || temp_nakama_skill.index(670) != nil
                    temp_nakama_skill_no = 80
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 81
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 82
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 83
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 84
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 85
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 86
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 87
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 88
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 670 #最終決戦改
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    
                  end
                end
              end
            end
            
            if kizuna_num > 0
              skill_effect_flag = true
              $tmp_run_skill << temp_skill_no
            end
            
            if skill_effect_flag == true
              
              bairitu = 0.prec_f
              
              if temp_skill_no == 80 #サイヤ人の結束1
                bairitu = 0.01
              elsif temp_skill_no == 81 #サイヤ人の結束2
                bairitu = 0.02
              elsif temp_skill_no == 82 #サイヤ人の結束3
                bairitu = 0.03
              elsif temp_skill_no == 83 #サイヤ人の結束4
                bairitu = 0.04
              elsif temp_skill_no == 84 #サイヤ人の結束5
                bairitu = 0.05
              elsif temp_skill_no == 85 #サイヤ人の結束6
                bairitu = 0.06
              elsif temp_skill_no == 86 #サイヤ人の結束7
                bairitu = 0.07
              elsif temp_skill_no == 87 #サイヤ人の結束8
                bairitu = 0.08
              else #サイヤ人の結束9
                bairitu = 0.09
              end

              #p temp_damage,temp_damage * (1.00 + (bairitu * kizuna_num))
              temp_damage = temp_damage * (1.00 + (bairitu * kizuna_num))
              skill_effect_flag = false
              kizuna_num = 0
              bairitu = 0.prec_f #毎回倍率を初期化する
            end
                  
        end
        
        #激怒====================================================
        if temp_cha_skill.index(22) != nil #22:激怒
          for y in 0..$cardset_cha_no.size - 1
            if $cardset_cha_no[y] != 99 #99はセットしていないということなので無視
              
              #攻撃者じゃなければチェック (Sコンボの場合は発動者でチェックする)
              if $partyc[$cardset_cha_no[y]] != cha_no
                if ($game_actors[$partyc[$cardset_cha_no[y]]].hp.prec_f / $game_actors[$partyc[$cardset_cha_no[y]]].maxhp.prec_f * 100).prec_i < $hinshi_hp
                  $tmp_run_skill << 22
                  bairitu += 0.35
                  skill_effect_flag = true
                end
              end
            end
          end
          
          bairitu += 1.00
        end
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        #慈愛の心====================================================
        if temp_cha_skill.index(57) != nil || temp_cha_skill.index(426) != nil || temp_cha_skill.index(427) != nil #57:慈愛の心
          nakamahp = 100
          for y in 0..$cardset_cha_no.size - 1
            if $cardset_cha_no[y] != 99 #99はセットしていないということなので無視
              
              #攻撃者じゃなければチェック (Sコンボの場合は発動者でチェックする)
              #かつチェック対象が死んでいない
              if $partyc[$cardset_cha_no[y]] != cha_no && $chadeadchk[$cardset_cha_no[y]] == false || get_battle_sankaninzu == 1
                #p nakamahp,($game_actors[$partyc[$cardset_cha_no[y]]].hp.prec_f / $game_actors[$partyc[$cardset_cha_no[y]]].maxhp.prec_f * 100).prec_i
                if nakamahp > ($game_actors[$partyc[$cardset_cha_no[y]]].hp.prec_f / $game_actors[$partyc[$cardset_cha_no[y]]].maxhp.prec_f * 100).prec_i
                  #p nakamahp
                  nakamahp = ($game_actors[$partyc[$cardset_cha_no[y]]].hp.prec_f / $game_actors[$partyc[$cardset_cha_no[y]]].maxhp.prec_f * 100).prec_i
                  #p nakamahp
                end
                skill_effect_flag = true
                
              end
            end
          end

          if battle_join_count == 1
          #if $partyc.size == 1
             skill_effect_flag = true
             #nakamahp = 1
          end
          
        end
        if skill_effect_flag == true
          nakamahp = (100 - nakamahp)
          if temp_cha_skill.index(427) != nil
            bairitu = 0.6
            $tmp_run_skill << 427
          elsif temp_cha_skill.index(426) != nil
            bairitu = 0.4
            $tmp_run_skill << 426
          elsif temp_cha_skill.index(57) != nil
            bairitu = 0.2
            $tmp_run_skill << 57
          end
          
          #p nakamahp,bairitu
          #p temp_damage,(temp_damage * (1 + (bairitu * nakamahp / 100)).prec_f).prec_i
          #p nakamahp,(1 + (bairitu * nakamahp / 100)).prec_f
          if battle_join_count != 1
            temp_damage = (temp_damage * (1 + (bairitu * nakamahp / 100)).prec_f).prec_i
          else
            temp_damage = (temp_damage * (1 + bairitu).prec_f).prec_i
          end
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end


        #果て無き死闘====================================================
        if temp_cha_skill.index(55) != nil #55:果て無き死闘
          #4ターン以上なら
          if $battle_turn_num >= 4
            $tmp_run_skill << 55
            skill_effect_flag = true
            bairitu += 1.25
          end
          
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        #おうえん==================================================================
        for y in 0..$cardset_cha_no.size - 1
          if $cardset_cha_no[y] != 99 #99はセットしていないということなので無視
            
            #生きてればチェック
            if $chadeadchk[$cardset_cha_no[y]] == false

              set_skill_nil_to_zero $partyc[$cardset_cha_no[y]]
              temp_nakama_skill = []
              #tempに仲間の所持スキルを追加
              if $cha_typical_skill != []
                for x in 0..$cha_typical_skill[$partyc[$cardset_cha_no[y]]].size
                  temp_nakama_skill << $cha_typical_skill[$partyc[$cardset_cha_no[y]]][x]
                end
              end
              if $cha_add_skill != []
                for x in 0..$cha_add_skill[$partyc[$cardset_cha_no[y]]].size
                  temp_nakama_skill << $cha_add_skill[$partyc[$cardset_cha_no[y]]][x]
                end
              end
              if temp_nakama_skill.index(77) != nil || temp_nakama_skill.index(78) != nil || temp_nakama_skill.index(79) != nil || temp_nakama_skill.index(197) != nil || temp_nakama_skill.index(198) != nil || temp_nakama_skill.index(199) != nil || temp_nakama_skill.index(200) != nil || temp_nakama_skill.index(201) != nil || temp_nakama_skill.index(202) != nil
                temp_nakama_skill_no = 202
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 1.13
                  $tmp_run_skill << 202
                  skill_effect_flag = true
                  break
                end
                temp_nakama_skill_no = 201
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 1.1
                  $tmp_run_skill << 201
                  skill_effect_flag = true
                  break
                end
                temp_nakama_skill_no = 200
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 1.09
                  $tmp_run_skill << 200
                  skill_effect_flag = true
                  break
                end
                temp_nakama_skill_no = 199
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 1.08
                  $tmp_run_skill << 199
                  skill_effect_flag = true
                  break
                end
                temp_nakama_skill_no = 198
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 1.07
                  $tmp_run_skill << 198
                  skill_effect_flag = true
                  break
                end
                temp_nakama_skill_no = 197
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 1.06
                  $tmp_run_skill << 197
                  skill_effect_flag = true
                  break
                end
                temp_nakama_skill_no = 79
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 1.05
                  $tmp_run_skill << 79
                  skill_effect_flag = true
                  break
                end
                temp_nakama_skill_no = 78
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 1.04
                  $tmp_run_skill << 78
                  skill_effect_flag = true
                  break
                end
                
                temp_nakama_skill_no = 77
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 1.03
                  $tmp_run_skill << 77
                  skill_effect_flag = true
                  break
                end
              end
            end
          end
        end
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        
        #連撃====================================================
        if temp_cha_skill.index(247) != nil && #連撃9
          $cha_biattack_count > 1
          bairitu = 0.14
          $tmp_run_skill << 247
          skill_effect_flag = true 
        elsif temp_cha_skill.index(246) != nil && #連撃8
          $cha_biattack_count > 1
          bairitu = 0.095
          $tmp_run_skill << 246
          skill_effect_flag = true 
        elsif temp_cha_skill.index(245) != nil && #連撃7
          $cha_biattack_count > 1
          bairitu = 0.09
          $tmp_run_skill << 245
          skill_effect_flag = true 
        elsif temp_cha_skill.index(244) != nil && #連撃6
          $cha_biattack_count > 1
          bairitu = 0.085
          $tmp_run_skill << 244
          skill_effect_flag = true 
        elsif temp_cha_skill.index(243) != nil && #連撃5
          $cha_biattack_count > 1
          bairitu = 0.08
          $tmp_run_skill << 243
          skill_effect_flag = true 
        elsif temp_cha_skill.index(242) != nil && #連撃4
          $cha_biattack_count > 1
          bairitu = 0.075
          $tmp_run_skill << 242
          skill_effect_flag = true 
        elsif temp_cha_skill.index(241) != nil && #連撃3
          $cha_biattack_count > 1
          bairitu = 0.07
          $tmp_run_skill << 241
          skill_effect_flag = true 
        elsif temp_cha_skill.index(240) != nil && #連撃2
          $cha_biattack_count > 1
          bairitu = 0.065
          $tmp_run_skill << 240
          skill_effect_flag = true 
        elsif temp_cha_skill.index(239) != nil && #連撃1
          $cha_biattack_count > 1
          bairitu = 0.06
          $tmp_run_skill << 239
          skill_effect_flag = true 
        end

        if skill_effect_flag == true
          if $cha_biattack_count > 1
            ren_bairitu = (1 + bairitu * ($cha_biattack_count - 1))
            #p ren_bairitu,$cha_biattack_count - 1
            temp_damage = temp_damage * ren_bairitu
          end
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        
        
        #限界を超えたパワー====================================================
        if temp_cha_skill.index(258) != nil #限界を超えたパワー9
          bairitu = 1.3
          $tmp_run_skill << 258
          skill_effect_flag = true
        elsif temp_cha_skill.index(257) != nil #限界を超えたパワー8
          bairitu = 1.26
          $tmp_run_skill << 257
          skill_effect_flag = true
        elsif temp_cha_skill.index(256) != nil #限界を超えたパワー7
          bairitu = 1.24
          $tmp_run_skill << 256
          skill_effect_flag = true
        elsif temp_cha_skill.index(255) != nil #限界を超えたパワー6
          bairitu = 1.22
          $tmp_run_skill << 255
          skill_effect_flag = true
        elsif temp_cha_skill.index(254) != nil #限界を超えたパワー5
          bairitu = 1.2
          $tmp_run_skill << 254
          skill_effect_flag = true
        elsif temp_cha_skill.index(253) != nil #限界を超えたパワー4
          bairitu = 1.18
          $tmp_run_skill << 253
          skill_effect_flag = true
        elsif temp_cha_skill.index(252) != nil #限界を超えたパワー3
          bairitu = 1.16
          $tmp_run_skill << 252
          skill_effect_flag = true
        elsif temp_cha_skill.index(251) != nil #限界を超えたパワー2
          bairitu = 1.14
          $tmp_run_skill << 251
          skill_effect_flag = true
        elsif temp_cha_skill.index(250) != nil #限界を超えたパワー1
          bairitu = 1.12
          $tmp_run_skill << 250
          skill_effect_flag = true
        end
        
        if skill_effect_flag == true
          #残りKIが10%以上なら (Sコンボの場合は発動者でチェックする)
          tec_mp_cost = 0
          if $cha_set_action[$partyc.index(cha_no)] > 10
            tec_mp_cost = get_mp_cost cha_no,$data_skills[$cha_set_action[$partyc.index(cha_no)] - 10].id,1
          end
          
          if ($game_actors[cha_no].maxmp / 10) <= ($game_actors[cha_no].mp - tec_mp_cost)
            temp_damage = temp_damage * bairitu
            
            if $fullpower_on_flag.index(cha_no) == nil
              $fullpower_on_flag << cha_no
            end
          end
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end

        
        #必殺の一撃====================================================
        if temp_cha_skill.index(288) != nil #必殺の一撃9
          bairitu = 1.25
          $tmp_run_skill << 288
          skill_effect_flag = true 
        elsif temp_cha_skill.index(287) != nil #必殺の一撃8
          bairitu = 1.20
          $tmp_run_skill << 287
          skill_effect_flag = true 
        elsif temp_cha_skill.index(286) != nil #必殺の一撃7
          bairitu = 1.18
          $tmp_run_skill << 286
          skill_effect_flag = true 
        elsif temp_cha_skill.index(285) != nil #必殺の一撃6
          bairitu = 1.16
          $tmp_run_skill << 285
          skill_effect_flag = true 
        elsif temp_cha_skill.index(284) != nil #必殺の一撃5
          bairitu = 1.14
          $tmp_run_skill << 284
          skill_effect_flag = true 
        elsif temp_cha_skill.index(283) != nil #必殺の一撃4
          bairitu = 1.12
          $tmp_run_skill << 283
          skill_effect_flag = true 
        elsif temp_cha_skill.index(282) != nil #必殺の一撃3
          bairitu = 1.10
          $tmp_run_skill << 282
          skill_effect_flag = true 
        elsif temp_cha_skill.index(281) != nil #必殺の一撃2
          bairitu = 1.08
          $tmp_run_skill << 281
          skill_effect_flag = true 
        elsif temp_cha_skill.index(280) != nil #必殺の一撃1
          bairitu = 1.06
          $tmp_run_skill << 280
          skill_effect_flag = true 
        end

        if skill_effect_flag == true
          if tec_no >= 11
            temp_damage = temp_damage * bairitu
          end
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        #トランクス用の技なのでトランクスの位置を確認
        toraindex = nil
        if $partyc.index(17) != nil 
          toraindex = $partyc.index(17)
        elsif $partyc.index(20) != nil
          toraindex = $partyc.index(20)
        end
        #p "未来への希望前",toraindex
        #トランクスがいるかチェック
        if toraindex != nil
          if $battle_turn_num >= 1 #2ターン以上連続で戦闘に参加しているか
            #未来への希望====================================================
            if temp_cha_skill.index(344) != nil #未来への希望9
              bairitu = 1.06
              bairitu += 0.01 if $battle_turn_num >= 2
              bairitu += 0.01 if $battle_turn_num >= 3
              bairitu += 0.01 if $battle_turn_num >= 4
              bairitu += 0.01 if $battle_turn_num >= 5
              bairitu += 0.01 if $battle_turn_num >= 6
              bairitu += 0.01 if $battle_turn_num >= 7
              bairitu += 0.01 if $battle_turn_num >= 8
              bairitu += 0.01 if $battle_turn_num >= 9
              $tmp_run_skill << 344
              skill_effect_flag = true 
            elsif temp_cha_skill.index(343) != nil #未来への希望8
              bairitu = 1.05
              bairitu += 0.01 if $battle_turn_num >= 2
              bairitu += 0.01 if $battle_turn_num >= 3
              bairitu += 0.01 if $battle_turn_num >= 4
              bairitu += 0.01 if $battle_turn_num >= 5
              bairitu += 0.01 if $battle_turn_num >= 6
              bairitu += 0.01 if $battle_turn_num >= 7
              bairitu += 0.01 if $battle_turn_num >= 8
              $tmp_run_skill << 343
              skill_effect_flag = true 
            elsif temp_cha_skill.index(342) != nil #未来への希望7
              bairitu = 1.03
              bairitu += 0.01 if $battle_turn_num >= 2
              bairitu += 0.01 if $battle_turn_num >= 3
              bairitu += 0.01 if $battle_turn_num >= 4
              bairitu += 0.01 if $battle_turn_num >= 5
              bairitu += 0.01 if $battle_turn_num >= 6
              bairitu += 0.01 if $battle_turn_num >= 7
              $tmp_run_skill << 342
              skill_effect_flag = true 
            elsif temp_cha_skill.index(341) != nil #未来への希望6
              bairitu = 1.03
              bairitu += 0.01 if $battle_turn_num >= 2
              bairitu += 0.01 if $battle_turn_num >= 3
              bairitu += 0.01 if $battle_turn_num >= 4
              bairitu += 0.01 if $battle_turn_num >= 5
              bairitu += 0.01 if $battle_turn_num >= 6
              $tmp_run_skill << 341
              skill_effect_flag = true 
            elsif temp_cha_skill.index(340) != nil #未来への希望5
              bairitu = 1.03
              bairitu += 0.01 if $battle_turn_num >= 2
              bairitu += 0.01 if $battle_turn_num >= 3
              bairitu += 0.01 if $battle_turn_num >= 4
              bairitu += 0.01 if $battle_turn_num >= 5
              $tmp_run_skill << 340
              skill_effect_flag = true 
            elsif temp_cha_skill.index(339) != nil #未来への希望4
              bairitu = 1.03
              bairitu += 0.01 if $battle_turn_num >= 2
              bairitu += 0.01 if $battle_turn_num >= 3
              bairitu += 0.01 if $battle_turn_num >= 4
              $tmp_run_skill << 339
              skill_effect_flag = true 
            elsif temp_cha_skill.index(338) != nil #未来への希望3
              bairitu = 1.03
              bairitu += 0.01 if $battle_turn_num >= 2
              bairitu += 0.01 if $battle_turn_num >= 3
              $tmp_run_skill << 338
              skill_effect_flag = true 
            elsif temp_cha_skill.index(337) != nil #未来への希望2
              bairitu = 1.03
              bairitu += 0.01 if $battle_turn_num >= 2
              $tmp_run_skill << 337
              skill_effect_flag = true 
            elsif temp_cha_skill.index(336) != nil #未来への希望1
              bairitu = 1.03
              $tmp_run_skill << 336
              skill_effect_flag = true 
            end
          end
        end
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end    
        
        bairitu = 1.5
        if temp_cha_skill.index(380) != nil #スタートダッシュ3
          if $battle_turn_num <= 3
            $tmp_run_skill << 380
            skill_effect_flag = true
          end
        elsif temp_cha_skill.index(379) != nil #スタートダッシュ2
          if $battle_turn_num <= 2
            $tmp_run_skill << 379
            skill_effect_flag = true
          end
        elsif temp_cha_skill.index(378) != nil #スタートダッシュ1
          if $battle_turn_num <= 1
            $tmp_run_skill << 378
            skill_effect_flag = true
          end
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        #傍若無人====================================================
        if temp_cha_skill.index(484) != nil #傍若無人9
          $tmp_run_skill << 484
          bairitu = 1.5
          skill_effect_flag = true
        elsif temp_cha_skill.index(483) != nil #傍若無人8
          $tmp_run_skill << 483
          bairitu = 1.45
          skill_effect_flag = true
        elsif temp_cha_skill.index(482) != nil #傍若無人7
          $tmp_run_skill << 482
          bairitu = 1.4
          skill_effect_flag = true
        elsif temp_cha_skill.index(481) != nil #傍若無人6
          $tmp_run_skill << 481
          bairitu = 1.35
          skill_effect_flag = true
        elsif temp_cha_skill.index(480) != nil #傍若無人5
          $tmp_run_skill << 480
          bairitu = 1.3
          skill_effect_flag = true
        elsif temp_cha_skill.index(479) != nil #傍若無人4
          $tmp_run_skill << 479
          bairitu = 1.25
          skill_effect_flag = true
        elsif temp_cha_skill.index(478) != nil #傍若無人3
          $tmp_run_skill << 478
          bairitu = 1.2
          skill_effect_flag = true
        elsif temp_cha_skill.index(477) != nil #傍若無人2
          $tmp_run_skill << 477
          bairitu = 1.15
          skill_effect_flag = true
        elsif temp_cha_skill.index(476) != nil #傍若無人1
          $tmp_run_skill << 476
          bairitu = 1.1
          skill_effect_flag = true
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        #征服====================================================
        if temp_cha_skill.index(546) != nil && #征服9
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 546
          bairitu = 1.5
          skill_effect_flag = true
        elsif temp_cha_skill.index(545) != nil && #征服8
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 545
          bairitu = 1.44
          skill_effect_flag = true
        elsif temp_cha_skill.index(544) != nil && #征服7
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 544
          bairitu = 1.38
          skill_effect_flag = true
        elsif temp_cha_skill.index(543) != nil && #征服6
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 543
          bairitu = 1.35
          skill_effect_flag = true
        elsif temp_cha_skill.index(542) != nil && #征服5
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 542
          bairitu = 1.32
          skill_effect_flag = true
        elsif temp_cha_skill.index(541) != nil && #征服4
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 541
          bairitu = 1.29
          skill_effect_flag = true
        elsif temp_cha_skill.index(540) != nil && #征服3
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 540
          bairitu = 1.26
          skill_effect_flag = true
        elsif temp_cha_skill.index(539) != nil && #征服2
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 539
          bairitu = 1.23
          skill_effect_flag = true
        elsif temp_cha_skill.index(538) != nil && #征服1
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 538
          bairitu = 1.2
          skill_effect_flag = true
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        #刺し違える覚悟====================================================
        if temp_cha_skill.index(642) != nil #刺し違える覚悟9
          run_skill = 642
          $tmp_run_skill << run_skill
          bairitu = $cha_skill_a_kouka[run_skill].to_f
          skill_effect_flag = true
        elsif temp_cha_skill.index(641) != nil #刺し違える覚悟8
          run_skill = 641
          $tmp_run_skill << run_skill
          bairitu = $cha_skill_a_kouka[run_skill].to_f
          skill_effect_flag = true
        elsif temp_cha_skill.index(640) != nil #刺し違える覚悟7
          run_skill = 640
          $tmp_run_skill << run_skill
          bairitu = $cha_skill_a_kouka[run_skill].to_f
          skill_effect_flag = true
        elsif temp_cha_skill.index(639) != nil #刺し違える覚悟6
          run_skill = 639
          $tmp_run_skill << run_skill
          bairitu = $cha_skill_a_kouka[run_skill].to_f
          skill_effect_flag = true
        elsif temp_cha_skill.index(638) != nil #刺し違える覚悟5
          run_skill = 638
          $tmp_run_skill << run_skill
          bairitu = $cha_skill_a_kouka[run_skill].to_f
          skill_effect_flag = true
        elsif temp_cha_skill.index(637) != nil #刺し違える覚悟4
          run_skill = 637
          $tmp_run_skill << run_skill
          bairitu = $cha_skill_a_kouka[run_skill].to_f
          skill_effect_flag = true
        elsif temp_cha_skill.index(636) != nil #刺し違える覚悟3
          run_skill = 636
          $tmp_run_skill << run_skill
          bairitu = $cha_skill_a_kouka[run_skill].to_f
          skill_effect_flag = true
        elsif temp_cha_skill.index(635) != nil #刺し違える覚悟2
          run_skill = 635
          $tmp_run_skill << run_skill
          bairitu = $cha_skill_a_kouka[run_skill].to_f
          skill_effect_flag = true
        elsif temp_cha_skill.index(634) != nil #刺し違える覚悟1
          run_skill = 634
          $tmp_run_skill << run_skill
          bairitu = $cha_skill_a_kouka[run_skill].to_f
          skill_effect_flag = true
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
      else 
      #========================================================================
      #食らうダメージ
      #========================================================================
        #p $partyc.index(temp_cha_no) #.index(temp_cha_no)
        #p $cardset_cha_no.index($partyc.index(temp_cha_no))
        #p $one_turn_cha_hit_num[$cardset_cha_no.index($partyc.index(temp_cha_no))]
        #かばう====================================================
        #最初にないと発動表示がされにくくなるため、最初に行う。
        if $battle_kabau_runskill != nil
          $tmp_run_skill << $battle_kabau_runskill
          $tmp_run_kabau_skill << $battle_kabau_runskill
          bairitu += $cha_skill_g_kouka[$battle_kabau_runskill].to_f
          skill_effect_flag = true
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        #タフネス====================================================
        if chk_skill_learn(526,temp_cha_no[0])[0] == true && #タフネス9
          $one_turn_cha_hit_num[$cardset_cha_no.index($partyc.index(temp_cha_no[0]))] < 2
          bairitu += 0.30
          $tmp_run_skill << 526
          skill_effect_flag = true
        elsif chk_skill_learn(525,temp_cha_no[0])[0] == true && #タフネス8
          $one_turn_cha_hit_num[$cardset_cha_no.index($partyc.index(temp_cha_no[0]))] == 0
          bairitu += 0.35
          $tmp_run_skill << 525
          skill_effect_flag = true
        elsif chk_skill_learn(524,temp_cha_no[0])[0] == true && #タフネス7
          $one_turn_cha_hit_num[$cardset_cha_no.index($partyc.index(temp_cha_no[0]))] == 0
          bairitu += 0.40
          $tmp_run_skill << 524
          skill_effect_flag = true
        elsif chk_skill_learn(523,temp_cha_no[0])[0] == true && #タフネス6
          $one_turn_cha_hit_num[$cardset_cha_no.index($partyc.index(temp_cha_no[0]))] == 0
          bairitu += 0.45
          $tmp_run_skill << 523
          skill_effect_flag = true
        elsif chk_skill_learn(522,temp_cha_no[0])[0] == true && #タフネス5
          $one_turn_cha_hit_num[$cardset_cha_no.index($partyc.index(temp_cha_no[0]))] == 0
          bairitu += 0.50
          $tmp_run_skill << 522
          skill_effect_flag = true
        elsif chk_skill_learn(521,temp_cha_no[0])[0] == true && #タフネス4
          $one_turn_cha_hit_num[$cardset_cha_no.index($partyc.index(temp_cha_no[0]))] == 0
          bairitu += 0.55
          $tmp_run_skill << 521
          skill_effect_flag = true
        elsif chk_skill_learn(520,temp_cha_no[0])[0] == true && #タフネス3
          $one_turn_cha_hit_num[$cardset_cha_no.index($partyc.index(temp_cha_no[0]))] == 0
          bairitu += 0.60
          $tmp_run_skill << 520
          skill_effect_flag = true
        elsif chk_skill_learn(519,temp_cha_no[0])[0] == true && #タフネス2
          $one_turn_cha_hit_num[$cardset_cha_no.index($partyc.index(temp_cha_no[0]))] == 0
          bairitu += 0.65
          $tmp_run_skill << 519
          skill_effect_flag = true
        elsif chk_skill_learn(518,temp_cha_no[0])[0] == true && #タフネス1
          $one_turn_cha_hit_num[$cardset_cha_no.index($partyc.index(temp_cha_no[0]))] == 0
          bairitu += 0.70
          $tmp_run_skill << 518
          skill_effect_flag = true
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
      
        #見下す====================================================
        if chk_skill_learn(401,temp_cha_no[0])[0] == true && #見下す9
          cha_cardag_sum > ene_cardag_sum
          bairitu += 0.70
          $tmp_run_skill << 401
          skill_effect_flag = true
        elsif chk_skill_learn(400,temp_cha_no[0])[0] == true && #見下す8
          cha_cardag_sum > ene_cardag_sum
          bairitu += 0.76
          $tmp_run_skill << 400
          skill_effect_flag = true
        elsif chk_skill_learn(399,temp_cha_no[0])[0] == true && #見下す7
          cha_cardag_sum > ene_cardag_sum
          bairitu += 0.78
          $tmp_run_skill << 399
          skill_effect_flag = true
        elsif chk_skill_learn(398,temp_cha_no[0])[0] == true && #見下す6
          cha_cardag_sum > ene_cardag_sum
          bairitu += 0.80
          $tmp_run_skill << 398
          skill_effect_flag = true
        elsif chk_skill_learn(397,temp_cha_no[0])[0] == true && #見下す5
          cha_cardag_sum > ene_cardag_sum
          bairitu += 0.82
          $tmp_run_skill << 397
          skill_effect_flag = true
        elsif chk_skill_learn(396,temp_cha_no[0])[0] == true && #見下す4
          cha_cardag_sum > ene_cardag_sum
          bairitu += 0.84
          $tmp_run_skill << 396
          skill_effect_flag = true
        elsif chk_skill_learn(395,temp_cha_no[0])[0] == true && #見下す3
          cha_cardag_sum > ene_cardag_sum
          bairitu += 0.86
          $tmp_run_skill << 395
          skill_effect_flag = true
        elsif chk_skill_learn(394,temp_cha_no[0])[0] == true && #見下す2
          cha_cardag_sum > ene_cardag_sum
          bairitu += 0.88
          $tmp_run_skill << 394
          skill_effect_flag = true
        elsif chk_skill_learn(393,temp_cha_no[0])[0] == true && #見下す1
          cha_cardag_sum > ene_cardag_sum
          bairitu += 0.90
          $tmp_run_skill << 393
          skill_effect_flag = true
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        #サイヤ人魂====================================================
        if temp_cha_skill.index(5) != nil #5:サイヤ人魂1
          temp_skill_no = 5
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.95
            $tmp_run_skill << 5
            skill_effect_flag = true
          end
        elsif temp_cha_skill.index(6) != nil #6:サイヤ人魂2
          temp_skill_no = 6
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.93
            $tmp_run_skill << 6
            skill_effect_flag = true
          end
        elsif temp_cha_skill.index(7) != nil #7:サイヤ人魂3
          temp_skill_no = 7
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.91
            $tmp_run_skill << 7
            skill_effect_flag = true
          end
        elsif temp_cha_skill.index(95) != nil #7:サイヤ人魂4
          temp_skill_no = 95
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.89
            $tmp_run_skill << 95
            skill_effect_flag = true
          end
        elsif temp_cha_skill.index(96) != nil #7:サイヤ人魂5
          temp_skill_no = 96
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.87
            $tmp_run_skill << 96
            skill_effect_flag = true
          end
        elsif temp_cha_skill.index(97) != nil #7:サイヤ人魂6
          temp_skill_no = 97
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.85
            $tmp_run_skill << 97
            skill_effect_flag = true
          end
        elsif temp_cha_skill.index(98) != nil #7:サイヤ人魂7
          temp_skill_no = 98
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.83
            $tmp_run_skill << 98
            skill_effect_flag = true
          end
        elsif temp_cha_skill.index(99) != nil #7:サイヤ人魂8
          temp_skill_no = 99
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.81
            $tmp_run_skill << 99
            skill_effect_flag = true
          end
        elsif temp_cha_skill.index(100) != nil #7:サイヤ人魂9
          temp_skill_no = 100
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.75
            $tmp_run_skill << 100
            skill_effect_flag = true
          end
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        #鋼鉄の身体====================================================
        if temp_cha_skill.index(51) != nil #鋼鉄の身体1
          temp_skill_no = 51
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.95
            $tmp_run_skill << 51
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(52) != nil #鋼鉄の身体2
          temp_skill_no = 52
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.935
            $tmp_run_skill << 52
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(53) != nil #鋼鉄の身体3
          temp_skill_no = 53
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.92
            $tmp_run_skill << 53
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(155) != nil #鋼鉄の身体4
          temp_skill_no = 155
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.905
            $tmp_run_skill << 155
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(156) != nil #鋼鉄の身体5
          temp_skill_no = 156
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.89
            $tmp_run_skill << 156
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(157) != nil #鋼鉄の身体6
          temp_skill_no = 157
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.875
            $tmp_run_skill << 157
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(158) != nil #鋼鉄の身体7
          temp_skill_no = 158
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.86
            $tmp_run_skill << 158
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(159) != nil #鋼鉄の身体8
          temp_skill_no = 159
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.845
            $tmp_run_skill << 159
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(160) != nil #鋼鉄の身体9
          temp_skill_no = 160
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.80
            $tmp_run_skill << 160
            skill_effect_flag = true 
          end
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        #最終決戦====================================================
        if temp_cha_skill.index(8) != nil #8:最終決戦
          temp_skill_no = 8
          #もしボス扱いならダメージ増加をチェック
          if $data_enemies[temp_ene_no].element_ranks[22] == 1
            if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              $tmp_run_skill << 8
              skill_effect_flag = true 
            end
          end
          
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * 0.85
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        #最終決戦改====================================================
        if temp_cha_skill.index(670) != nil #8:最終決戦改
          temp_skill_no = 670
          #もしボス扱いならダメージ増加をチェック
          if $data_enemies[temp_ene_no].element_ranks[22] == 1
            if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              $tmp_run_skill << 670
              skill_effect_flag = true 
            end
          end
          
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * 0.85
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        #王子の誇り====================================================
        if chk_skill_learn(9,temp_cha_no[0])[0] == true || chk_skill_learn(428,temp_cha_no[0])[0] == true || chk_skill_learn(429,temp_cha_no[0])[0] == true #9:王子の誇り
          temp_skill_no = 9
          #もしパーティーが1人ならダメージ増加
          if battle_join_count == 1
            skill_effect_flag = true if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0
            skill_effect_flag = true
            if chk_skill_learn(9,temp_cha_no[0])[0] == true
              bairitu = 0.9
              $tmp_run_skill << 9
            elsif chk_skill_learn(428,temp_cha_no[0])[0] == true
              bairitu = 0.8
              $tmp_run_skill << 428
            elsif chk_skill_learn(429,temp_cha_no[0])[0] == true
              bairitu = 0.65
              $tmp_run_skill << 429
            end
          end
          
        end
        
        if skill_effect_flag == true
          #p temp_damage,bairitu,temp_damage * bairitu
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        #Z戦士の絆====================================================
        if temp_cha_skill.index(13) != nil || temp_cha_skill.index(14) != nil || temp_cha_skill.index(15) != nil || temp_cha_skill.index(101) != nil || temp_cha_skill.index(102) != nil || temp_cha_skill.index(103) != nil || temp_cha_skill.index(104) != nil || temp_cha_skill.index(105) != nil || temp_cha_skill.index(106) != nil ||#13～15:Z戦士の絆1～3
           temp_cha_skill.index(678) != nil || temp_cha_skill.index(679) != nil || temp_cha_skill.index(680) != nil || temp_cha_skill.index(681) != nil || temp_cha_skill.index(682) != nil || temp_cha_skill.index(683) != nil || temp_cha_skill.index(684) != nil || temp_cha_skill.index(685) != nil || temp_cha_skill.index(686) != nil #地球育ちのサイヤ人

          if temp_cha_skill.index(686) != nil
            temp_skill_no = 686
          elsif temp_cha_skill.index(106) != nil
            temp_skill_no = 106
          elsif temp_cha_skill.index(685) != nil
            temp_skill_no = 685
          elsif temp_cha_skill.index(105) != nil
            temp_skill_no = 105
          elsif temp_cha_skill.index(684) != nil
            temp_skill_no = 684
          elsif temp_cha_skill.index(104) != nil
            temp_skill_no = 104
          elsif temp_cha_skill.index(683) != nil
            temp_skill_no = 683
          elsif temp_cha_skill.index(103) != nil
            temp_skill_no = 103
          elsif temp_cha_skill.index(682) != nil
            temp_skill_no = 682
          elsif temp_cha_skill.index(102) != nil
            temp_skill_no = 102
          elsif temp_cha_skill.index(681) != nil
            temp_skill_no = 681
          elsif temp_cha_skill.index(101) != nil
            temp_skill_no = 101
          elsif temp_cha_skill.index(680) != nil
            temp_skill_no = 680
          elsif temp_cha_skill.index(15) != nil
            temp_skill_no = 15
          elsif temp_cha_skill.index(679) != nil
            temp_skill_no = 679
          elsif temp_cha_skill.index(14) != nil
            temp_skill_no = 14
          elsif temp_cha_skill.index(678) != nil
            temp_skill_no = 678
          else
            temp_skill_no = 13
          end
          
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            #kizuna_num += 1
          
        
            for y in 0..$cardset_cha_no.size - 1
              if $cardset_cha_no[y] != 99 #99はセットしていないということなので無視
                
                #攻撃者じゃないかつ生きてればチェック
                if $partyc[$cardset_cha_no[y]] != temp_cha_no[0] && $chadeadchk[$cardset_cha_no[y]] == false
                  set_skill_nil_to_zero $partyc[$cardset_cha_no[y]]
                  temp_nakama_skill = []
                  #tempに仲間の所持スキルを追加
                  if $cha_typical_skill != []
                    for x in 0..$cha_typical_skill[$partyc[$cardset_cha_no[y]]].size
                      temp_nakama_skill << $cha_typical_skill[$partyc[$cardset_cha_no[y]]][x]
                    end
                  end
                  if $cha_add_skill != []
                    for x in 0..$cha_add_skill[$partyc[$cardset_cha_no[y]]].size
                      temp_nakama_skill << $cha_add_skill[$partyc[$cardset_cha_no[y]]][x]
                    end
                  end
                  if temp_nakama_skill.index(13) != nil || temp_nakama_skill.index(14) != nil || temp_nakama_skill.index(15) != nil || temp_nakama_skill.index(101) != nil || temp_nakama_skill.index(102) != nil || temp_nakama_skill.index(103) != nil || temp_nakama_skill.index(104) != nil || temp_nakama_skill.index(105) != nil || temp_nakama_skill.index(106) != nil ||
                    temp_nakama_skill.index(678) != nil || temp_nakama_skill.index(679) != nil || temp_nakama_skill.index(680) != nil || temp_nakama_skill.index(681) != nil || temp_nakama_skill.index(682) != nil || temp_nakama_skill.index(683) != nil || temp_nakama_skill.index(684) != nil || temp_nakama_skill.index(685) != nil || temp_nakama_skill.index(686) != nil #地球育ちのサイヤ人
                    temp_nakama_skill_no = 13
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 14
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 15
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 101
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 102
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 103
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 104
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 105
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 106
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 678
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 679
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 680
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 681
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 682
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 683
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 684
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 685
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 686
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end

                  end
                end
              end
            end
          
            if kizuna_num > 0
              skill_effect_flag = true
              $tmp_run_skill << temp_skill_no
            end
            
            if skill_effect_flag == true
              
              bairitu = 0.prec_f
              
              if temp_skill_no == 13 || temp_skill_no == 678 #Z戦士の絆1 or 地球育ちのサイヤ人1
                bairitu = 0.01
              elsif temp_skill_no == 14 || temp_skill_no == 679 #Z戦士の絆2 or 地球育ちのサイヤ人2
                bairitu = 0.015
              elsif temp_skill_no == 15 || temp_skill_no == 680 #Z戦士の絆3 or 地球育ちのサイヤ人3
                bairitu = 0.02
              elsif temp_skill_no == 101 || temp_skill_no == 681 #Z戦士の絆4 or 地球育ちのサイヤ人4
                bairitu = 0.025
              elsif temp_skill_no == 102 || temp_skill_no == 682 #Z戦士の絆5 or 地球育ちのサイヤ人5
                bairitu = 0.03
              elsif temp_skill_no == 103 || temp_skill_no == 683 #Z戦士の絆6 or 地球育ちのサイヤ人6
                bairitu = 0.035
              elsif temp_skill_no == 104 || temp_skill_no == 684 #Z戦士の絆7 or 地球育ちのサイヤ人7
                bairitu = 0.04
              elsif temp_skill_no == 105 || temp_skill_no == 685 #Z戦士の絆8 or 地球育ちのサイヤ人8
                bairitu = 0.045
              else #Z戦士の絆9 or 地球育ちのサイヤ人9
                bairitu = 0.06
              end
              
              #p temp_damage,temp_damage * (1.00 + (bairitu * kizuna_num))
              
              temp_damage = temp_damage * (1.00 - (bairitu * kizuna_num))
              
              skill_effect_flag = false
              kizuna_num = 0
              bairitu = 0.prec_f #毎回倍率を初期化する
            end
          end        
        
        end
        
        #サイヤ人の結束====================================================
        if temp_cha_skill.index(80) != nil || temp_cha_skill.index(81) != nil || temp_cha_skill.index(82) != nil || temp_cha_skill.index(83) != nil || temp_cha_skill.index(84) != nil || temp_cha_skill.index(85) != nil || temp_cha_skill.index(86) != nil || temp_cha_skill.index(87) != nil || temp_cha_skill.index(88) != nil#13～15:サイヤ人の結束1～3
          
          if temp_cha_skill.index(88) != nil
            temp_skill_no = 88
          elsif temp_cha_skill.index(87) != nil
            temp_skill_no = 87
          elsif temp_cha_skill.index(86) != nil
            temp_skill_no = 86
          elsif temp_cha_skill.index(85) != nil
            temp_skill_no = 85
          elsif temp_cha_skill.index(84) != nil
            temp_skill_no = 84
          elsif temp_cha_skill.index(83) != nil
            temp_skill_no = 83
          elsif temp_cha_skill.index(82) != nil
            temp_skill_no = 82
          elsif temp_cha_skill.index(81) != nil
            temp_skill_no = 81
          else
            temp_skill_no = 80
          end
          
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            #kizuna_num += 1
          
            for y in 0..$cardset_cha_no.size - 1
              if $cardset_cha_no[y] != 99 #99はセットしていないということなので無視
                
                #攻撃者じゃないかつ生きてればチェック
                if $partyc[$cardset_cha_no[y]] != temp_cha_no[0] && $chadeadchk[$cardset_cha_no[y]] == false

                  set_skill_nil_to_zero $partyc[$cardset_cha_no[y]]
                  temp_nakama_skill = []
                  #tempに仲間の所持スキルを追加
                  if $cha_typical_skill != []
                    for x in 0..$cha_typical_skill[$partyc[$cardset_cha_no[y]]].size
                      temp_nakama_skill << $cha_typical_skill[$partyc[$cardset_cha_no[y]]][x]
                    end
                  end
                  if $cha_add_skill != []
                    for x in 0..$cha_add_skill[$partyc[$cardset_cha_no[y]]].size
                      temp_nakama_skill << $cha_add_skill[$partyc[$cardset_cha_no[y]]][x]
                    end
                  end
                  if temp_nakama_skill.index(80) != nil || temp_nakama_skill.index(81) != nil || temp_nakama_skill.index(82) != nil || temp_nakama_skill.index(83) != nil || temp_nakama_skill.index(84) != nil || temp_nakama_skill.index(85) != nil || temp_nakama_skill.index(86) != nil || temp_nakama_skill.index(87) != nil || temp_nakama_skill.index(88) != nil || temp_nakama_skill.index(670) != nil
                    temp_nakama_skill_no = 80
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 81
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 82
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 83
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 84
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 85
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 86
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 87
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    temp_nakama_skill_no = 88
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                    
                    temp_nakama_skill_no = 670 #最終決戦改
                    if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                      kizuna_num += 1
                      next
                    end
                  end
                end
              end
            end
          
            if kizuna_num > 0
              skill_effect_flag = true
              $tmp_run_skill << temp_skill_no
            end
            
            if skill_effect_flag == true
              
              bairitu = 0.prec_f
              
              if temp_skill_no == 80 #サイヤ人の結束1
                bairitu = 0.01
              elsif temp_skill_no == 81 #サイヤ人の結束2
                bairitu = 0.015
              elsif temp_skill_no == 82 #サイヤ人の結束3
                bairitu = 0.02
              elsif temp_skill_no == 83 #サイヤ人の結束4
                bairitu = 0.025
              elsif temp_skill_no == 84 #サイヤ人の結束5
                bairitu = 0.03
              elsif temp_skill_no == 85 #サイヤ人の結束6
                bairitu = 0.035
              elsif temp_skill_no == 86 #サイヤ人の結束7
                bairitu = 0.04
              elsif temp_skill_no == 87 #サイヤ人の結束8
                bairitu = 0.045
              else #サイヤ人の結束9
                bairitu = 0.06
              end
              
              #p temp_damage,temp_damage * (1.00 + (bairitu * kizuna_num))
              temp_damage = temp_damage * (1.00 - (bairitu * kizuna_num))
              skill_effect_flag = false
              kizuna_num = 0
              bairitu = 0.prec_f #毎回倍率を初期化する
            end
          end        
        
        end
        #激怒====================================================
        if temp_cha_skill.index(22) != nil #22:激怒
          temp_skill_no = 22
          
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            
            for y in 0..$cardset_cha_no.size - 1
              if $cardset_cha_no[y] != 99 #99はセットしていないということなので無視
                
                #攻撃者じゃなければチェック
                if $partyc[$cardset_cha_no[y]] != temp_cha_no[0]
                  if ($game_actors[$partyc[$cardset_cha_no[y]]].hp.prec_f / $game_actors[$partyc[$cardset_cha_no[y]]].maxhp.prec_f * 100).prec_i < $hinshi_hp
                    $tmp_run_skill << 22
                    skill_effect_flag = true
                  end
                end
              end
            end
          end
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * 0.8
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end

        #慈愛の心====================================================
        if chk_skill_learn(57,temp_cha_no[0])[0] == true || chk_skill_learn(426,temp_cha_no[0])[0] == true || chk_skill_learn(427,temp_cha_no[0])[0] == true #57:慈愛の心
          nakamahp = 100
          for y in 0..$cardset_cha_no.size - 1
            if $cardset_cha_no[y] != 99 #99はセットしていないということなので無視

              #攻撃者じゃなければチェック
              #かつ対象者が死んでなければ
              if $partyc[$cardset_cha_no[y]] != temp_cha_no[0] && $chadeadchk[$cardset_cha_no[y]] == false || get_battle_sankaninzu == 1
                
                if nakamahp > ($game_actors[$partyc[$cardset_cha_no[y]]].hp.prec_f / $game_actors[$partyc[$cardset_cha_no[y]]].maxhp.prec_f * 100).prec_i
                  #p nakamahp
                  nakamahp = ($game_actors[$partyc[$cardset_cha_no[y]]].hp.prec_f / $game_actors[$partyc[$cardset_cha_no[y]]].maxhp.prec_f * 100).prec_i
                  #p nakamahp
                end
                skill_effect_flag = true
                
              end
            end
          end
        end
        
        #デバッグ用
        #if $partyc.size == 1
        #   skill_effect_flag = true
        #   nakamahp = 1
        #end
        
        if skill_effect_flag == true
          #nakamahp = (100 - nakamahp)
          if chk_skill_learn(57,temp_cha_no[0])[0] == true
            bairitu = 0.2 #他のと逆転している 他のでいう0.8
            $tmp_run_skill << 57
          elsif chk_skill_learn(426,temp_cha_no[0])[0] == true
            bairitu = 0.3
            $tmp_run_skill << 426
          elsif chk_skill_learn(427,temp_cha_no[0])[0] == true
            bairitu = 0.4
            $tmp_run_skill << 427
          else

          end
          #p nakamahp,bairitu
          #p  (1 - (bairitu * (100 - nakamahp) / 100).prec_f)
          #p temp_damage,(temp_damage * (1 - (bairitu * (100 - nakamahp) / 100).prec_f)).prec_i
          if battle_join_count != 1
            temp_damage = (temp_damage * (1 - (bairitu * (100 - nakamahp) / 100).prec_f)).prec_i
          else
            temp_damage = (temp_damage * (1 - bairitu).prec_f).prec_i
          end
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end

        #果て無き死闘====================================================
        if temp_cha_skill.index(55) != nil #51:果て無き死闘
          temp_skill_no = 55
          #5ターン以上なら
          if $battle_turn_num >= 5
            if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              $tmp_run_skill << 55
              skill_effect_flag = true 
            end
          end
          
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * 0.85
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end

        #負けん気====================================================
        if temp_cha_skill.index(70) != nil #負けん気1
          temp_skill_no = 70
          kakuritu = 25
          if rand(100)+1 < kakuritu
            $tmp_run_skill << 70
            skill_effect_flag = true
          end
        elsif temp_cha_skill.index(71) != nil #負けん気2
          temp_skill_no = 71
          kakuritu = 28
          if rand(100)+1 < kakuritu
            $tmp_run_skill << 71
            skill_effect_flag = true
          end
        elsif temp_cha_skill.index(72) != nil #負けん気3
          temp_skill_no = 72
          kakuritu = 31
          if rand(100)+1 < kakuritu
            $tmp_run_skill << 72
            skill_effect_flag = true
          end 
        elsif temp_cha_skill.index(185) != nil #負けん気4
          temp_skill_no = 185
          kakuritu = 34
          if rand(100)+1 < kakuritu
            $tmp_run_skill << 185
            skill_effect_flag = true
          end 
        elsif temp_cha_skill.index(186) != nil #負けん気5
          temp_skill_no = 186
          kakuritu = 37
          if rand(100)+1 < kakuritu
            $tmp_run_skill << 186
            skill_effect_flag = true
          end 
        elsif temp_cha_skill.index(187) != nil #負けん気6
          temp_skill_no = 187
          kakuritu = 40
          if rand(100)+1 < kakuritu
            $tmp_run_skill << 187
            skill_effect_flag = true
          end 
        elsif temp_cha_skill.index(188) != nil #負けん気7
          temp_skill_no = 188
          kakuritu = 43
          if rand(100)+1 < kakuritu
            $tmp_run_skill << 188
            skill_effect_flag = true
          end 
        elsif temp_cha_skill.index(189) != nil #負けん気8
          temp_skill_no = 189
          kakuritu = 46
          if rand(100)+1 < kakuritu
            $tmp_run_skill << 189
            skill_effect_flag = true
          end 
        elsif temp_cha_skill.index(190) != nil #負けん気9
          temp_skill_no = 190
          kakuritu = 50
          if rand(100)+1 < kakuritu
            $tmp_run_skill << 190
            skill_effect_flag = true
          end 
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * 0.6
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end

        #おうえん==================================================================
        for y in 0..$cardset_cha_no.size - 1
          if $cardset_cha_no[y] != 99 #99はセットしていないということなので無視
            
            #生きてればチェック
            if $chadeadchk[$cardset_cha_no[y]] == false

              set_skill_nil_to_zero $partyc[$cardset_cha_no[y]]
              temp_nakama_skill = []
              #tempに仲間の所持スキルを追加
              if $cha_typical_skill != []
                for x in 0..$cha_typical_skill[$partyc[$cardset_cha_no[y]]].size
                  temp_nakama_skill << $cha_typical_skill[$partyc[$cardset_cha_no[y]]][x]
                end
              end
              if $cha_add_skill != []
                for x in 0..$cha_add_skill[$partyc[$cardset_cha_no[y]]].size
                  temp_nakama_skill << $cha_add_skill[$partyc[$cardset_cha_no[y]]][x]
                end
              end
              if temp_nakama_skill.index(77) != nil || temp_nakama_skill.index(78) != nil || temp_nakama_skill.index(79) != nil || temp_nakama_skill.index(197) != nil || temp_nakama_skill.index(198) != nil || temp_nakama_skill.index(199) != nil || temp_nakama_skill.index(200) != nil || temp_nakama_skill.index(201) != nil || temp_nakama_skill.index(202) != nil
                temp_nakama_skill_no = 202
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 0.85
                  $tmp_run_skill << 202
                  skill_effect_flag = true
                  break
                end
                temp_nakama_skill_no = 201
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 0.88
                  $tmp_run_skill << 201
                  skill_effect_flag = true
                  break
                end
                temp_nakama_skill_no = 200
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 0.89
                  $tmp_run_skill << 200
                  skill_effect_flag = true
                  break
                end
                temp_nakama_skill_no = 199
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 0.9
                  $tmp_run_skill << 199
                  skill_effect_flag = true
                  break
                end
                temp_nakama_skill_no = 198
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 0.91
                  $tmp_run_skill << 198
                  skill_effect_flag = true
                  break
                end
                temp_nakama_skill_no = 197
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 0.92
                  $tmp_run_skill << 197
                  skill_effect_flag = true
                  break
                end
                temp_nakama_skill_no = 79
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 0.93
                  $tmp_run_skill << 79
                  skill_effect_flag = true
                  break
                end
                temp_nakama_skill_no = 78
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 0.94
                  $tmp_run_skill << 78
                  skill_effect_flag = true
                  break
                end
                
                temp_nakama_skill_no = 77
                if $cha_skill_spval[$partyc[$cardset_cha_no[y]]][temp_nakama_skill_no] >= $cha_skill_get_val[temp_nakama_skill_no]
                  bairitu = 0.95
                  $tmp_run_skill << 77
                  skill_effect_flag = true
                  break
                end
              end
            end
          end
        end
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end

        bairitu = 0.7
        if chk_skill_learn(380,temp_cha_no[0])[0] == true #スタートダッシュ3
          if $battle_turn_num <= 3
            $tmp_run_skill << 380
            skill_effect_flag = true
          end
        elsif chk_skill_learn(379,temp_cha_no[0])[0] == true #スタートダッシュ2
          if $battle_turn_num <= 2
            $tmp_run_skill << 379
            skill_effect_flag = true
          end
        elsif chk_skill_learn(378,temp_cha_no[0])[0] == true #スタートダッシュ1
          if $battle_turn_num <= 1
            $tmp_run_skill << 378
            skill_effect_flag = true
          end
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        if $battle_turn_num >= 1 #2ターン以上連続で戦闘に参加しているか
          #未来への希望====================================================
          if temp_cha_skill.index(336) != nil #未来への希望1
            temp_skill_no = 336
            if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.97
              $tmp_run_skill << 336
              skill_effect_flag = true 
            end
          elsif temp_cha_skill.index(337) != nil #未来への希望2
            temp_skill_no = 337
            if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.97
              bairitu -= 0.01 if $battle_turn_num >= 2
              $tmp_run_skill << 337
              skill_effect_flag = true 
            end
          elsif temp_cha_skill.index(338) != nil #未来への希望3
            temp_skill_no = 338
            if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.97
              bairitu -= 0.01 if $battle_turn_num >= 2
              bairitu -= 0.01 if $battle_turn_num >= 3
              $tmp_run_skill << 338
              skill_effect_flag = true 
            end
          elsif temp_cha_skill.index(339) != nil #未来への希望4
            temp_skill_no = 339
            if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.97
              bairitu -= 0.01 if $battle_turn_num >= 2
              bairitu -= 0.01 if $battle_turn_num >= 3
              bairitu -= 0.01 if $battle_turn_num >= 4
              $tmp_run_skill << 339
              skill_effect_flag = true 
            end
          elsif temp_cha_skill.index(340) != nil #未来への希望5
            temp_skill_no = 340
            if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.97
              bairitu -= 0.01 if $battle_turn_num >= 2
              bairitu -= 0.01 if $battle_turn_num >= 3
              bairitu -= 0.01 if $battle_turn_num >= 4
              bairitu -= 0.01 if $battle_turn_num >= 5
              $tmp_run_skill << 340
              skill_effect_flag = true 
            end
          elsif temp_cha_skill.index(341) != nil #未来への希望6
            temp_skill_no = 341
            if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.97
              bairitu -= 0.01 if $battle_turn_num >= 2
              bairitu -= 0.01 if $battle_turn_num >= 3
              bairitu -= 0.01 if $battle_turn_num >= 4
              bairitu -= 0.01 if $battle_turn_num >= 5
              bairitu -= 0.01 if $battle_turn_num >= 6
              $tmp_run_skill << 341
              skill_effect_flag = true 
            end
          elsif temp_cha_skill.index(342) != nil #未来への希望7
            temp_skill_no = 342
            if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.97
              bairitu -= 0.01 if $battle_turn_num >= 2
              bairitu -= 0.01 if $battle_turn_num >= 3
              bairitu -= 0.01 if $battle_turn_num >= 4
              bairitu -= 0.01 if $battle_turn_num >= 5
              bairitu -= 0.01 if $battle_turn_num >= 6
              bairitu -= 0.01 if $battle_turn_num >= 7
              $tmp_run_skill << 342
              skill_effect_flag = true 
            end
          elsif temp_cha_skill.index(343) != nil #未来への希望8
            temp_skill_no = 343
            if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.97
              bairitu -= 0.01 if $battle_turn_num >= 2
              bairitu -= 0.01 if $battle_turn_num >= 3
              bairitu -= 0.01 if $battle_turn_num >= 4
              bairitu -= 0.01 if $battle_turn_num >= 5
              bairitu -= 0.01 if $battle_turn_num >= 6
              bairitu -= 0.01 if $battle_turn_num >= 7
              bairitu -= 0.01 if $battle_turn_num >= 8
              $tmp_run_skill << 343
              skill_effect_flag = true 
            end
          elsif temp_cha_skill.index(344) != nil #未来への希望9
            temp_skill_no = 344
            if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.97
              bairitu -= 0.01 if $battle_turn_num >= 2
              bairitu -= 0.01 if $battle_turn_num >= 3
              bairitu -= 0.01 if $battle_turn_num >= 4
              bairitu -= 0.01 if $battle_turn_num >= 5
              bairitu -= 0.01 if $battle_turn_num >= 6
              bairitu -= 0.01 if $battle_turn_num >= 7
              bairitu -= 0.01 if $battle_turn_num >= 8
              bairitu -= 0.01 if $battle_turn_num >= 9
              $tmp_run_skill << 344
              skill_effect_flag = true 
            end
          end
        end
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        #限界を超えたパワー====================================================
        if temp_cha_skill.index(250) != nil #限界を超えたパワー1
          temp_skill_no = 250
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.9
            $tmp_run_skill << 250
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(251) != nil #限界を超えたパワー2
          temp_skill_no = 251
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.88
            $tmp_run_skill << 251
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(252) != nil #限界を超えたパワー3
          temp_skill_no = 252
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.86
            $tmp_run_skill << 252
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(253) != nil #限界を超えたパワー4
          temp_skill_no = 253
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.84
            $tmp_run_skill << 253
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(254) != nil #限界を超えたパワー5
          temp_skill_no = 254
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.82
            $tmp_run_skill << 254
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(255) != nil #限界を超えたパワー6
          temp_skill_no = 255
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.8
            $tmp_run_skill << 255
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(256) != nil #限界を超えたパワー7
          temp_skill_no = 256
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.78
            $tmp_run_skill << 256
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(257) != nil #限界を超えたパワー8
          temp_skill_no = 257
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.76
            $tmp_run_skill << 257
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(258) != nil #限界を超えたパワー9
          temp_skill_no = 258
          if $cha_skill_spval[temp_cha_no[0]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            bairitu = 0.70
            $tmp_run_skill << 258
            skill_effect_flag = true 
          end
        end
        
        
        
        #p $cardset_cha_no
        #p $attack_order,$btl_attack_count,$attack_order.index($cardset_cha_no.index($partyc.index(temp_cha_no[0])))
        if skill_effect_flag == true
          #残りKIが10%以上なら
          tec_mp_cost = 0

          if $cha_set_action[$partyc.index(temp_cha_no[0])] > 10 && $btl_attack_count < $attack_order.index($cardset_cha_no.index($partyc.index(temp_cha_no[0])))
            tec_mp_cost = get_mp_cost temp_cha_no[0],$data_skills[$cha_set_action[$partyc.index(temp_cha_no[0])] - 10].id,1
          end
          
          if ($game_actors[temp_cha_no[0]].maxmp / 10) <= ($game_actors[temp_cha_no[0]].mp - tec_mp_cost)
            temp_damage = temp_damage * bairitu
            
            if $fullpower_on_flag.index(temp_cha_no[0]) == nil
              $fullpower_on_flag << temp_cha_no[0]
            end
          end
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        #傍若無人====================================================
        if chk_skill_learn(484,temp_cha_no[0])[0] == true #傍若無人9
          $tmp_run_skill << 484
          bairitu = 0.75
          skill_effect_flag = true
        elsif chk_skill_learn(483,temp_cha_no[0])[0] == true #傍若無人8
          $tmp_run_skill << 483
          bairitu = 0.8
          skill_effect_flag = true
        elsif chk_skill_learn(482,temp_cha_no[0])[0] == true #傍若無人7
          $tmp_run_skill << 482
          bairitu = 0.83
          skill_effect_flag = true
        elsif chk_skill_learn(481,temp_cha_no[0])[0] == true #傍若無人6
          $tmp_run_skill << 481
          bairitu = 0.85
          skill_effect_flag = true
        elsif chk_skill_learn(480,temp_cha_no[0])[0] == true #傍若無人5
          $tmp_run_skill << 480
          bairitu = 0.87
          skill_effect_flag = true
        elsif chk_skill_learn(479,temp_cha_no[0])[0] == true #傍若無人4
          $tmp_run_skill << 479
          bairitu = 0.89
          skill_effect_flag = true
        elsif chk_skill_learn(478,temp_cha_no[0])[0] == true #傍若無人3
          $tmp_run_skill << 478
          bairitu = 0.91
          skill_effect_flag = true
        elsif chk_skill_learn(477,temp_cha_no[0])[0] == true #傍若無人2
          $tmp_run_skill << 477
          bairitu = 0.93
          skill_effect_flag = true
        elsif chk_skill_learn(476,temp_cha_no[0])[0] == true #傍若無人1
          $tmp_run_skill << 476
          bairitu = 0.95
          skill_effect_flag = true
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        #征服====================================================
        if chk_skill_learn(546,temp_cha_no[0])[0] == true && #征服9
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 546
          bairitu = 0.65
          skill_effect_flag = true
        elsif chk_skill_learn(545,temp_cha_no[0])[0] == true && #征服8
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 545
          bairitu = 0.69
          skill_effect_flag = true
        elsif chk_skill_learn(544,temp_cha_no[0])[0] == true && #征服7
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 544
          bairitu = 0.72
          skill_effect_flag = true
        elsif chk_skill_learn(543,temp_cha_no[0])[0] == true && #征服6
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 543
          bairitu = 0.75
          skill_effect_flag = true
        elsif chk_skill_learn(542,temp_cha_no[0])[0] == true && #征服5
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 542
          bairitu = 0.78
          skill_effect_flag = true
        elsif chk_skill_learn(541,temp_cha_no[0])[0] == true && #征服4
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 541
          bairitu = 0.81
          skill_effect_flag = true
        elsif chk_skill_learn(540,temp_cha_no[0])[0] == true && #征服3
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 540
          bairitu = 0.84
          skill_effect_flag = true
        elsif chk_skill_learn(539,temp_cha_no[0])[0] == true && #征服2
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 539
          bairitu = 0.87
          skill_effect_flag = true
        elsif chk_skill_learn(538,temp_cha_no[0])[0] == true && #征服1
          $data_enemies[temp_ene_no].element_ranks[22] == 3 #通常の敵
          $tmp_run_skill << 538
          bairitu = 0.9
          skill_effect_flag = true
        end
                
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
        
        bairitu = 1.3
        #刺違える覚悟====================================================
        if chk_skill_learn(642,temp_cha_no[0])[0] == true #差し違える覚悟9
          $tmp_run_skill << 642
          #bairitu = 0.75
          skill_effect_flag = true
        elsif chk_skill_learn(641,temp_cha_no[0])[0] == true #差し違える覚悟8
          $tmp_run_skill << 641
          #bairitu = 0.8
          skill_effect_flag = true
        elsif chk_skill_learn(640,temp_cha_no[0])[0] == true #差し違える覚悟7
          $tmp_run_skill << 640
          #bairitu = 0.83
          skill_effect_flag = true
        elsif chk_skill_learn(639,temp_cha_no[0])[0] == true #差し違える覚悟6
          $tmp_run_skill << 639
          #bairitu = 0.85
          skill_effect_flag = true
        elsif chk_skill_learn(638,temp_cha_no[0])[0] == true #差し違える覚悟5
          $tmp_run_skill << 638
          #bairitu = 0.87
          skill_effect_flag = true
        elsif chk_skill_learn(637,temp_cha_no[0])[0] == true #差し違える覚悟4
          $tmp_run_skill << 637
          #bairitu = 0.89
          skill_effect_flag = true
        elsif chk_skill_learn(636,temp_cha_no[0])[0] == true #差し違える覚悟3
          $tmp_run_skill << 636
          #bairitu = 0.91
          skill_effect_flag = true
        elsif chk_skill_learn(635,temp_cha_no[0])[0] == true #差し違える覚悟2
          $tmp_run_skill << 635
          #bairitu = 0.93
          skill_effect_flag = true
        elsif chk_skill_learn(634,temp_cha_no[0])[0] == true #差し違える覚悟1
          $tmp_run_skill << 634
          #bairitu = 0.95
          skill_effect_flag = true
        end
        
        if skill_effect_flag == true
          temp_damage = temp_damage * bairitu
          skill_effect_flag = false
          bairitu = 0.prec_f #毎回倍率を初期化する
        end
      end
      
      #発動スキル
      #p $tmp_run_skill
    
    return temp_damage.to_i.ceil
  end
  #--------------------------------------------------------------------------
  # ● 攻撃ヒットまたは回避時のスキル
  # cha_no:キャラクターNo ene_no:敵キャラNo attack_hit:攻撃があたったか attackcourse:攻撃方向
  # tec_no:攻撃種類No
  # battledamage:食らうダメージ
  #--------------------------------------------------------------------------
  def get_attack_hit_skill cha_no,ene_no,attack_hit,attackcourse,tec_no,battledamage
    
    #temp_cha_no = $partyc[cha_no]
    temp_cha_no = []
    temp_ene_no = ene_no
    temp_cha_skill = []
    temp_skill_no = 0
    bairitu = 0
    cha_attack_num = 0 #味方のカード調整量
    cha_guard_num = 0
    ene_attack_num = 0 #敵のカード調整量
    ene_guard_num = 0
    stop_turn = 0 #ストップターン
    kakuritu = 0 #発動する確立
    skill_effect_flag = false
    
    if $data_skills[tec_no-10].element_set.index(33) != nil
      #使用技がSコンボだった
      #p "Sコンボである"
      temp_cha_no.concat($tmp_btl_ani_scombo_cha)
    else
      #通常攻撃または一人の必殺技だった
      #p "Sコンボじゃない"
      temp_cha_no.concat([$partyc[cha_no]])
    end
    
    
    
      #経験値を上げるスキルなどが付いていないかチェック

    for y in 0..temp_cha_no.size - 1
      #配列なるべく0に
      set_skill_nil_to_zero temp_cha_no[y]
      
      #tempに所持スキルを追加
      if $cha_typical_skill != []
        for x in 0..$cha_typical_skill[temp_cha_no[y]].size
          temp_cha_skill << $cha_typical_skill[temp_cha_no[y]][x]
        end
      end
      
      if $cha_add_skill != []
        for x in 0..$cha_add_skill[temp_cha_no[y]].size
          temp_cha_skill << $cha_add_skill[temp_cha_no[y]][x]
        end
      end

      if attackcourse == 0 #味方が攻撃
        #攻防の星調整
        #挑発========================================================
        if temp_cha_skill.index(130) != nil #33:挑発9
          temp_skill_no = 130
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              ene_attack_num += -5
              ene_guard_num += -5
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(129) != nil #33:挑発8
          temp_skill_no = 129
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              ene_attack_num += -4
              ene_guard_num += -4
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(128) != nil #33:挑発7
          temp_skill_no = 128
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              ene_attack_num += -4
              ene_guard_num += -3
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(127) != nil #33:挑発6
          temp_skill_no = 127
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              ene_attack_num += -3
              ene_guard_num += -3
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(126) != nil #33:挑発5
          temp_skill_no = 126
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              ene_attack_num += -3
              ene_guard_num += -2
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(125) != nil #33:挑発4
          temp_skill_no = 125
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              ene_attack_num += -2
              ene_guard_num += -2
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(33) != nil #33:挑発3
          temp_skill_no = 33
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              ene_attack_num += -2
              ene_guard_num += -1
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(32) != nil #32:挑発2
          temp_skill_no = 32
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              ene_attack_num += -1
              ene_guard_num += -1
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        
        elsif temp_cha_skill.index(31) != nil #31:挑発1
          temp_skill_no = 31
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            
            if attack_hit == true
              ene_attack_num += -1
              ene_guard_num += -0
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end

          end
        end
        
        #いたずら(防御)=======================================================
        if temp_cha_skill.index(23) != nil #23:いたずら(防御)
          temp_skill_no = 23
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            
            if attack_hit == true && $enecardg[temp_ene_no] < $enecarda[temp_ene_no]
              #入れ替えをまとめで実装してないのでここで実行する
              $enecarda[temp_ene_no],$enecardg[temp_ene_no] = $enecardg[temp_ene_no],$enecarda[temp_ene_no]
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end

          end
        end
        
        #いたずら(攻撃)=======================================================
        if temp_cha_skill.index(259) != nil #23:いたずら(攻撃)
          temp_skill_no = 259
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            
            if attack_hit == true && $enecardg[temp_ene_no] > $enecarda[temp_ene_no]
              #入れ替えをまとめで実装してないのでここで実行する
              $enecarda[temp_ene_no],$enecardg[temp_ene_no] = $enecardg[temp_ene_no],$enecarda[temp_ene_no]
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end

          end
        end
        #いたずら(変更)=======================================================
        if chk_skill_learn(289,temp_cha_no[y])[0] == true #23:いたずら(変更)
          temp_skill_no = 289
          if attack_hit == true
            #入れ替えをまとめで実装してないのでここで実行する
            #ホシが5以上のときランダムで変更
            itahen_run = false
            if $enecarda[temp_ene_no] >= 4
              $enecarda[temp_ene_no] = rand(7)
              itahen_run = true
            end
            
            if $enecardg[temp_ene_no] >= 4
              $enecardg[temp_ene_no] = rand(7)
              itahen_run = true
            end
            
            if itahen_run == true
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        end
        #取替え=======================================================
        if chk_skill_learn(421,temp_cha_no[y])[0] == true #421:とりかえ
          #p $cha_sente_flag,$cha_sente_card_flag
          temp_skill_no = 421
          
          if attack_hit == true && $cha_sente_flag[$partyc.index(temp_cha_no[y])] == false && $cha_sente_card_flag[$partyc.index(temp_cha_no[y])] == false
            #入れ替えをまとめで実装してないのでここで実行する
            #ホシが5以上のときランダムで変更

            for x in 0..$Cardmaxnum
              if $partyc[$cardset_cha_no[x]] == temp_cha_no[y]
                $enecarda[temp_ene_no],$carda[x] = $carda[x],$enecarda[temp_ene_no]
                $enecardg[temp_ene_no],$cardg[x] = $cardg[x],$enecardg[temp_ene_no]
                $enecardi[temp_ene_no],$cardi[x] = $cardi[x],$enecardi[temp_ene_no]
              end
            end
            $tmp_run_hit_skill << temp_skill_no
            skill_effect_flag = true
          end
        end
        
        #吸収(攻撃)=======================================================
        if temp_cha_skill.index(260) != nil #260:吸収(攻撃)
          temp_skill_no = 260
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              #テキの攻撃の星を自分に
              ene_attack_num += -1
              cha_attack_num += 1
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        end
        
        #吸収(防御)=======================================================
        if temp_cha_skill.index(261) != nil #261:吸収(防御)
          temp_skill_no = 261
          kakuritu = 65
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                #テキの攻撃の星を自分に
                ene_guard_num += -1
                cha_guard_num += 1
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        end
        #吸収(攻防)=======================================================
        if temp_cha_skill.index(290) != nil #290:吸収(攻防)
          temp_skill_no = 290
          kakuritu = 40
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            
              if attack_hit == true
                if rand(100)+1 < kakuritu
                  #テキの攻撃の星を自分に
                  ene_attack_num += -1
                  ene_guard_num += -1
                  cha_attack_num += 1
                  cha_guard_num += 1
                  $tmp_run_hit_skill << temp_skill_no
                  skill_effect_flag = true
                end
              end

          end
        end
        #ヒットアンドアウェイ
        if temp_cha_skill.index(221) != nil #31:ヒットアンドアウェイ1
          temp_skill_no = 221
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            
            if attack_hit == true
              cha_guard_num += 1
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end

          end
        elsif temp_cha_skill.index(222) != nil #32:ヒットアンドアウェイ2
          temp_skill_no = 222
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              cha_guard_num += 2
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(223) != nil #33:ヒットアンドアウェイ3
          temp_skill_no = 223
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              cha_guard_num += 3
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(224) != nil #33:ヒットアンドアウェイ4
          temp_skill_no = 224
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              cha_guard_num += 4
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(225) != nil #33:ヒットアンドアウェイ5
          temp_skill_no = 225
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              cha_guard_num += 5
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(226) != nil #33:ヒットアンドアウェイ6
          temp_skill_no = 226
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              cha_guard_num += 6
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(227) != nil #33:ヒットアンドアウェイ7
          temp_skill_no = 227
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              cha_guard_num += 7
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(228) != nil #33:ヒットアンドアウェイ8
          temp_skill_no = 228
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              cha_guard_num += 8
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(229) != nil #33:ヒットアンドアウェイ9
          temp_skill_no = 229
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              cha_guard_num += 9
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        end
        
        #とっさの機転
        if temp_cha_skill.index(56) != nil #56:とっさの機転
          temp_skill_no = 56
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            
            if attack_hit == true
              #テキのカードが必殺または流派一致の場合
              if ($enecardi[temp_ene_no] == 0 || $enecardi[temp_ene_no] == $data_enemies[$battleenemy[temp_ene_no]].hit - 1) && $data_enemies[$battleenemy[temp_ene_no]].element_ranks[45] != 1
                #入れ替えをまとめで実装してないのでここで実行する
                $enecardi[temp_ene_no] = create_card_i(1,true,$data_enemies[$battleenemy[temp_ene_no]].hit - 1)
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end

          end
        end
      else #味方がダメージ
        #たぎる闘志===============================================
        if temp_cha_skill.index(42) != nil #たぎる闘志1
          temp_skill_no = 42
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            
            if attack_hit == true
              cha_attack_num += 1
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end

          end
        elsif temp_cha_skill.index(43) != nil #たぎる闘志2
          temp_skill_no = 43
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              cha_attack_num += 2
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(44) != nil #たぎる闘志3
          temp_skill_no = 44
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              cha_attack_num += 3
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        end
        if temp_cha_skill.index(45) != nil #不屈の闘志1
          temp_skill_no = 45
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            
            if attack_hit == true
              cha_guard_num += 1
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end

          end
        elsif temp_cha_skill.index(46) != nil #不屈の闘志2
          temp_skill_no = 46
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              cha_guard_num += 2
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(47) != nil #不屈の闘志3
          temp_skill_no = 47
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              cha_guard_num += 3
              $tmp_run_hit_skill << temp_skill_no
              skill_effect_flag = true
            end
          end
        end
      end
      
      if skill_effect_flag == true && cha_no != nil

        for x in 0..$Cardmaxnum
          if $partyc[$cardset_cha_no[x]] == temp_cha_no[y]
            $carda[x] += cha_attack_num
            $cardg[x] += cha_guard_num
            $carda[x] = 7 if $carda[x] > 7
            $cardg[x] = 7 if $cardg[x] > 7
            $carda[x] = 0 if $carda[x] < 0
            $cardg[x] = 0 if $cardg[x] < 0
          end
        end

        #if $carda[cha_no] != nil
          #$carda[cha_no] += cha_attack_num
          #$cardg[cha_no] += cha_guard_num
          #$carda[cha_no] = 7 if $carda[cha_no] > 7
          #$cardg[cha_no] = 7 if $cardg[cha_no] > 7
          #$carda[cha_no] = 0 if $carda[cha_no] < 0
          #$cardg[cha_no] = 0 if $cardg[cha_no] < 0
          $enecarda[temp_ene_no] += ene_attack_num
          $enecardg[temp_ene_no] += ene_guard_num
          $enecarda[temp_ene_no] = 7 if $enecarda[temp_ene_no] > 7
          $enecardg[temp_ene_no] = 7 if $enecardg[temp_ene_no] > 7
          $enecarda[temp_ene_no] = 0 if $enecarda[temp_ene_no] < 0
          $enecardg[temp_ene_no] = 0 if $enecardg[temp_ene_no] < 0
          skill_effect_flag = false
        #else
        #  p cha_no
        #end

      end
      #かなしばり===============================================
      if attackcourse == 0 #味方が攻撃
        if temp_cha_skill.index(39) != nil #39:かなしばり1
          temp_skill_no = 39
          kakuritu = 5
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                stop_turn += 1
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        elsif temp_cha_skill.index(40) != nil #40:かなしばり2
          temp_skill_no = 40
          kakuritu = 7
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                stop_turn += 1
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        elsif temp_cha_skill.index(41) != nil #41:かなしばり3
          temp_skill_no = 41
          kakuritu = 9
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                stop_turn += 1
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        elsif temp_cha_skill.index(131) != nil #41:かなしばり4
          temp_skill_no = 131
          kakuritu = 11
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                stop_turn += 1
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        elsif temp_cha_skill.index(132) != nil #41:かなしばり5
          temp_skill_no = 132
          kakuritu = 13
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                stop_turn += 1
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        elsif temp_cha_skill.index(133) != nil #41:かなしばり6
          temp_skill_no = 133
          kakuritu = 15
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                stop_turn += 1
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        elsif temp_cha_skill.index(134) != nil #41:かなしばり7
          temp_skill_no = 134
          kakuritu = 17
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                stop_turn += 1
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        elsif temp_cha_skill.index(135) != nil #41:かなしばり8
          temp_skill_no = 135
          kakuritu = 19
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                stop_turn += 1
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        elsif temp_cha_skill.index(136) != nil #41:かなしばり9
          temp_skill_no = 136
          kakuritu = 25
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                stop_turn += 1
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        end
        
        if skill_effect_flag == true
          $ene_stop_num[temp_ene_no] += stop_turn
          skill_effect_flag = false
        end

        #一定確率でかなしばり===============================================
        if y == 0 #Sコンボの時のために1回だけ実行
          if attackcourse == 0 #味方が攻撃
            if $data_skills[tec_no - 10].element_set.index(61) != nil
              kakuritu = $data_skills[tec_no - 10].variance.to_i
              if rand(100)+1 < kakuritu
                stop_turn += 1
                $tmp_run_hit_skill << 706
                skill_effect_flag = true
              end
            end
            
            if skill_effect_flag == true
              $ene_stop_num[temp_ene_no] += stop_turn
              skill_effect_flag = false
            end
          end
        end
      else #味方がダメージ
        #回避が出来なかった事を示すため表示のみさせる
        #不惜身命====================================================
        if chk_skill_learn(642,temp_cha_no[0])[0] == true #不惜身命9
          run_skill = 642
          $tmp_run_hit_skill << run_skill
        elsif chk_skill_learn(641,temp_cha_no[0])[0] == true #不惜身命8
          run_skill = 641
          $tmp_run_hit_skill << run_skill
        elsif chk_skill_learn(640,temp_cha_no[0])[0] == true #不惜身命7
          run_skill = 640
          $tmp_run_hit_skill << run_skill
        elsif chk_skill_learn(639,temp_cha_no[0])[0] == true #不惜身命6
          run_skill = 639
          $tmp_run_hit_skill << run_skill
        elsif chk_skill_learn(638,temp_cha_no[0])[0] == true #不惜身命5
          run_skill = 638
          $tmp_run_hit_skill << run_skill
        elsif chk_skill_learn(637,temp_cha_no[0])[0] == true #不惜身命4
          run_skill = 637
          $tmp_run_hit_skill << run_skill
        elsif chk_skill_learn(636,temp_cha_no[0])[0] == true #不惜身命3
          run_skill = 636
          $tmp_run_hit_skill << run_skill
        elsif chk_skill_learn(635,temp_cha_no[0])[0] == true #不惜身命2
          run_skill = 635
          $tmp_run_hit_skill << run_skill
        elsif chk_skill_learn(634,temp_cha_no[0])[0] == true #不惜身命1
          run_skill = 634
          $tmp_run_hit_skill << run_skill
        end
      end

      #やせがまん===============================================
      if attackcourse == 0 #味方が攻撃

      else #味方がダメージ
        if temp_cha_skill.index(67) != nil #やせがまん1
          temp_skill_no = 67
          kakuritu = 25
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                #$tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        elsif temp_cha_skill.index(68) != nil #やせがまん2
          temp_skill_no = 68
          kakuritu = 28
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                #$tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        elsif temp_cha_skill.index(69) != nil #やせがまん3
          temp_skill_no = 69
          kakuritu = 31
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                #$tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        elsif temp_cha_skill.index(179) != nil #やせがまん4
          temp_skill_no = 179
          kakuritu = 34
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                #$tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        elsif temp_cha_skill.index(180) != nil #やせがまん5
          temp_skill_no = 180
          kakuritu = 37
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                #$tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        elsif temp_cha_skill.index(181) != nil #やせがまん6
          temp_skill_no = 181
          kakuritu = 40
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                #$tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        elsif temp_cha_skill.index(182) != nil #やせがまん7
          temp_skill_no = 182
          kakuritu = 43
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                #$tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        elsif temp_cha_skill.index(183) != nil #やせがまん8
          temp_skill_no = 183
          kakuritu = 46
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                #$tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
              end
            end
          end
        elsif temp_cha_skill.index(184) != nil #やせがまん9
          temp_skill_no = 184
          kakuritu = 50
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
              if rand(100)+1 < kakuritu
                skill_effect_flag = true
              end
            end
          end
        end
        
      end

      if skill_effect_flag == true
        if $game_actors[temp_cha_no[y]].hp <= battledamage
          $tmp_run_hit_skill << temp_skill_no
          $btl_yasegaman_on_flag = true
          #$game_actors[temp_cha_no[y]].hp = 1
        end
        skill_effect_flag = false
      end
      
      #不屈の精神===============================================
      if attackcourse == 0 #味方が攻撃

      else #味方がダメージ
        if temp_cha_skill.index(212) != nil #不屈の精神1
          temp_skill_no = 212
          kakuritu = 1
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(213) != nil #不屈の精神2
          temp_skill_no = 213
          kakuritu = 2
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(214) != nil #不屈の精神3
          temp_skill_no = 214
          kakuritu = 3
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(215) != nil #不屈の精神4
          temp_skill_no = 215
          kakuritu = 4
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(216) != nil #不屈の精神5
          temp_skill_no = 216
          kakuritu = 5
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(217) != nil #不屈の精神6
          temp_skill_no = 217
          kakuritu = 6
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(218) != nil #不屈の精神7
          temp_skill_no = 218
          kakuritu = 7
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(219) != nil #不屈の精神8
          temp_skill_no = 219
          kakuritu = 8
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(220) != nil #不屈の精神9
          temp_skill_no = 220
          kakuritu = 10
          if $cha_skill_spval[temp_cha_no[y]][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            if attack_hit == true
                $tmp_run_hit_skill << temp_skill_no
                skill_effect_flag = true
            end
          end
        end
        
        if skill_effect_flag == true

          $game_actors[temp_cha_no[y]].mp += kakuritu.to_i
          skill_effect_flag = false
        end
        
        #鋼の意思取得処理は関数内で行う、また実際の処理はBattleanimeSceneにて処理している
        #ここは表示を出すためのみの処理
        if attackcourse == 0 #味方が攻撃

        else #味方がダメージ
          
          if attack_hit == true
            #動きとめる系の技の時のみ表示する
            if $data_skills[tec_no-10].element_set.index(12) != nil ||
              $data_skills[tec_no-10].element_set.index(13) != nil ||
              $data_skills[tec_no-10].element_set.index(14) != nil
              
              #鋼の意思
              if chk_haganenoishirun(temp_cha_no[0]) == true
                $tmp_run_hit_skill << 619
              end
              
              #慈愛の心
              if chk_skill_learn(427,temp_cha_no[0])[0] == true
                $tmp_run_hit_skill << 427
              elsif chk_skill_learn(426,temp_cha_no[0])[0] == true
                $tmp_run_hit_skill << 426
              elsif chk_skill_learn(57,temp_cha_no[0])[0] == true
                $tmp_run_hit_skill << 57
              end
            end
          end
        end
      end
    end
    #return temp_avoid.to_i.ceil
  end
  #--------------------------------------------------------------------------
  # ● 回避率加算値計算(差分ではなく合計)
  # cha_no:キャラクターNo avoid:回避値
  #--------------------------------------------------------------------------
  def get_avoid_add cha_no,avoid
    
    temp_avoid = avoid.prec_f
    temp_cha_no = cha_no
    temp_cha_skill = []
    temp_skill_no = 0
    bairitu = 0
    skill_effect_flag = false
    
    #配列なるべく0に
    set_skill_nil_to_zero temp_cha_no
    
      #経験値を上げるスキルなどが付いていないかチェック
      
      #tempに所持スキルを追加
      if $cha_typical_skill != []
        for x in 0..$cha_typical_skill[temp_cha_no].size
          temp_cha_skill << $cha_typical_skill[temp_cha_no][x]
        end
      end
      
      if $cha_add_skill != []
        for x in 0..$cha_add_skill[temp_cha_no].size
          temp_cha_skill << $cha_add_skill[temp_cha_no][x]
        end
      end

      if temp_cha_skill.index(19) != nil #19:残像拳1
        temp_skill_no = 19
        skill_effect_flag = true if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
        bairitu = $cha_skill_hatudouritu[temp_skill_no]
      elsif temp_cha_skill.index(20) != nil #20:残像拳2
        temp_skill_no = 20
        skill_effect_flag = true if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
        bairitu = $cha_skill_hatudouritu[temp_skill_no]
      elsif temp_cha_skill.index(21) != nil #21:残像拳3
        temp_skill_no = 21
        skill_effect_flag = true if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
        bairitu = $cha_skill_hatudouritu[temp_skill_no]
      elsif temp_cha_skill.index(113) != nil #21:残像拳4
        temp_skill_no = 113
        skill_effect_flag = true if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
        bairitu = $cha_skill_hatudouritu[temp_skill_no]
      elsif temp_cha_skill.index(114) != nil #21:残像拳5
        temp_skill_no = 114
        skill_effect_flag = true if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
        bairitu = $cha_skill_hatudouritu[temp_skill_no]
      elsif temp_cha_skill.index(115) != nil #21:残像拳6
        temp_skill_no = 115
        skill_effect_flag = true if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
        bairitu = $cha_skill_hatudouritu[temp_skill_no]
      elsif temp_cha_skill.index(116) != nil #21:残像拳7
        temp_skill_no = 116
        skill_effect_flag = true if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
        bairitu = $cha_skill_hatudouritu[temp_skill_no]
      elsif temp_cha_skill.index(117) != nil #21:残像拳8
        temp_skill_no = 117
        skill_effect_flag = true if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
        bairitu = $cha_skill_hatudouritu[temp_skill_no]
      elsif temp_cha_skill.index(118) != nil #21:残像拳9
        temp_skill_no = 118
        skill_effect_flag = true if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
        bairitu = $cha_skill_hatudouritu[temp_skill_no]
      end
      
      if chk_skill_learn(687,temp_cha_no)[0] == true #武泰斗の教え1
        temp_skill_no = 687
        skill_effect_flag = true
        bairitu += $cha_skill_hatudouritu[temp_skill_no]
      elsif chk_skill_learn(688,temp_cha_no)[0] == true #武泰斗の教え2
        temp_skill_no = 688
        skill_effect_flag = true
        bairitu += $cha_skill_hatudouritu[temp_skill_no]
      elsif chk_skill_learn(689,temp_cha_no)[0] == true #武泰斗の教え3
        temp_skill_no = 689
        skill_effect_flag = true
        bairitu += $cha_skill_hatudouritu[temp_skill_no]
      elsif chk_skill_learn(690,temp_cha_no)[0] == true #武泰斗の教え4
        temp_skill_no = 690
        skill_effect_flag = true
        bairitu += $cha_skill_hatudouritu[temp_skill_no]
      elsif chk_skill_learn(691,temp_cha_no)[0] == true #武泰斗の教え5
        temp_skill_no = 691
        skill_effect_flag = true
        bairitu += $cha_skill_hatudouritu[temp_skill_no]
      elsif chk_skill_learn(692,temp_cha_no)[0] == true #武泰斗の教え6
        temp_skill_no = 692
        skill_effect_flag = true
        bairitu += $cha_skill_hatudouritu[temp_skill_no]
      elsif chk_skill_learn(693,temp_cha_no)[0] == true #武泰斗の教え7
        temp_skill_no = 693
        skill_effect_flag = true
        bairitu += $cha_skill_hatudouritu[temp_skill_no]
      elsif chk_skill_learn(694,temp_cha_no)[0] == true #武泰斗の教え8
        temp_skill_no = 694
        skill_effect_flag = true
        bairitu += $cha_skill_hatudouritu[temp_skill_no]
      elsif chk_skill_learn(695,temp_cha_no)[0] == true #武泰斗の教え9
        temp_skill_no = 695
        skill_effect_flag = true
        bairitu += $cha_skill_hatudouritu[temp_skill_no]
      end
      
      if chk_skill_learn(392,temp_cha_no)[0] == true && #緊急回避
        ($game_actors[temp_cha_no].hp.prec_f / $game_actors[temp_cha_no].maxhp.prec_f * 100).prec_i < $hinshi_hp
        skill_effect_flag = true
        bairitu += 35
      end
      
      if skill_effect_flag == true
        temp_avoid += bairitu
        skill_effect_flag = false
      end
    return temp_avoid.to_i.ceil
  end
  #--------------------------------------------------------------------------
  # ● カードドロップ計算(差分ではなく合計)
  # cha_no:キャラクターNo drop_proba:カードドロップ率
  #--------------------------------------------------------------------------
  def get_card_drop_add drop_proba
    
    temp_drop_proba = drop_proba.prec_f
    temp_cha_no = 0
    temp_cha_skill = []
    temp_skill_no = 0
    bairitu = 0.prec_f
    skill_effect_flag = false
    
      for y in 0..$partyc.size - 1
          
        #生きてればチェック
        if $chadead[y] == false

          set_skill_nil_to_zero $partyc[y]
  
          #経験値を上げるスキルなどが付いていないかチェック
          temp_cha_no = $partyc[y]
          #tempに所持スキルを追加
          if $cha_typical_skill != []
            for x in 0..$cha_typical_skill[temp_cha_no].size
              temp_cha_skill << $cha_typical_skill[temp_cha_no][x]
            end
          end
          
          if $cha_add_skill != []
            for x in 0..$cha_add_skill[temp_cha_no].size
              temp_cha_skill << $cha_add_skill[temp_cha_no][x]
            end
          end

          if temp_cha_skill.index(74) != nil #カードドロップ1
            temp_skill_no = 74
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.95
              skill_effect_flag = true
              break
            end
          elsif temp_cha_skill.index(75) != nil #カードドロップ2
            temp_skill_no = 75
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.92
              skill_effect_flag = true
              break
            end
          elsif temp_cha_skill.index(76) != nil #カードドロップ3
            temp_skill_no = 76
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.89
              skill_effect_flag = true
              break
            end
          elsif temp_cha_skill.index(191) != nil #カードドロップ4
            temp_skill_no = 191
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.86
              skill_effect_flag = true
              break
            end
          elsif temp_cha_skill.index(192) != nil #カードドロップ5
            temp_skill_no = 192
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.83
              skill_effect_flag = true
              break
            end
          elsif temp_cha_skill.index(193) != nil #カードドロップ6
            temp_skill_no = 193
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.8
              skill_effect_flag = true
              break
            end
          elsif temp_cha_skill.index(194) != nil #カードドロップ7
            temp_skill_no = 194
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.77
              skill_effect_flag = true
              break
            end
          elsif temp_cha_skill.index(195) != nil #カードドロップ8
            temp_skill_no = 195
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.74
              skill_effect_flag = true
              break
            end
          elsif temp_cha_skill.index(196) != nil #カードドロップ9
            temp_skill_no = 196
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              bairitu = 0.7
              skill_effect_flag = true
              break
            end
          end
        end
      end
      
      if skill_effect_flag == true
        temp_drop_proba = temp_drop_proba * bairitu
        skill_effect_flag = false
      end
    return temp_drop_proba.to_i.ceil
  end
  #--------------------------------------------------------------------------
  # ● SP加算値計算(差分ではなく合計)
  # cha_no:キャラクターNo sp:sp
  #--------------------------------------------------------------------------
  def get_sp_add cha_no,sp
    
    temp_sp = sp.prec_f
    temp_cha_no = get_ori_cha_no cha_no
    temp_cha_skill = []
    temp_skill_no = 0
    bairitu = 0.prec_f
    skill_effect_flag = false
    
    #配列なるべく0に
    set_skill_nil_to_zero temp_cha_no
    
      #キャラがお気に入りキャラかチェック
      if $game_variables[104] == temp_cha_no
        temp_sp = temp_sp * 1.5
      end
      #経験値を上げるスキルなどが付いていないかチェック
      temp_cha_no = cha_no
      #tempに所持スキルを追加
      if $cha_typical_skill != []
        for x in 0..$cha_typical_skill[temp_cha_no].size
          temp_cha_skill << $cha_typical_skill[temp_cha_no][x]
        end
      end
      
      if $cha_add_skill != []
        for x in 0..$cha_add_skill[temp_cha_no].size
          temp_cha_skill << $cha_add_skill[temp_cha_no][x]
        end
      end

      if temp_cha_skill.index(2) != nil #2:サイヤ人の血1
        temp_skill_no = 2
        
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.1
          skill_effect_flag = true 
        end
      elsif temp_cha_skill.index(3) != nil #3:サイヤ人の血2
        temp_skill_no = 3
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.15
          skill_effect_flag = true 
        end
      elsif temp_cha_skill.index(4) != nil #4:サイヤ人の血3
        temp_skill_no = 4
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.2
          skill_effect_flag = true 
        end
      elsif temp_cha_skill.index(89) != nil #4:サイヤ人の血4
        temp_skill_no = 89
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.25
          skill_effect_flag = true 
        end
      elsif temp_cha_skill.index(90) != nil #4:サイヤ人の血5
        temp_skill_no = 90
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.3
          skill_effect_flag = true 
        end
      elsif temp_cha_skill.index(91) != nil #4:サイヤ人の血6
        temp_skill_no = 91
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.35
          skill_effect_flag = true 
        end
      elsif temp_cha_skill.index(92) != nil #4:サイヤ人の血7
        temp_skill_no = 92
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.4
          skill_effect_flag = true 
        end
      elsif temp_cha_skill.index(93) != nil #4:サイヤ人の血8
        temp_skill_no = 93
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.45
          skill_effect_flag = true 
        end
      elsif temp_cha_skill.index(94) != nil #4:サイヤ人の血9
        temp_skill_no = 94
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.5
          skill_effect_flag = true 
        end
      end
      
      if skill_effect_flag == true
        temp_sp = temp_sp * bairitu
        skill_effect_flag = false
      end
    return temp_sp.to_i.ceil
  end
  #--------------------------------------------------------------------------
  # ● 経験値加算値計算(差分ではなく合計)
  # cha_no:キャラクターNo exp:経験値
  #--------------------------------------------------------------------------
  def get_exp_add cha_no,exp
    
    temp_exp = exp.prec_f
    temp_cha_no = get_ori_cha_no cha_no
    temp_cha_skill = []
    temp_skill_no = 0
    bairitu = 0.prec_f
    
    skill_effect_flag = false
    #配列なるべく0に
    set_skill_nil_to_zero temp_cha_no
    
      #キャラがお気に入りキャラかチェック
      if $game_variables[104] == temp_cha_no
        temp_exp = temp_exp * 1.15
      end
      #経験値を上げるスキルなどが付いていないかチェック
      temp_cha_no = cha_no
      #tempに所持スキルを追加
      if $cha_typical_skill != []
      
        for x in 0..$cha_typical_skill[temp_cha_no].size
          temp_cha_skill << $cha_typical_skill[temp_cha_no][x]
        end
      end
      
      if $cha_add_skill != []
        for x in 0..$cha_add_skill[temp_cha_no].size
          temp_cha_skill << $cha_add_skill[temp_cha_no][x]
        end
      end

      
      if temp_cha_skill.index(2) != nil #2:サイヤ人の血1
        temp_skill_no = 2
        
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.1
          skill_effect_flag = true 
        end
      elsif temp_cha_skill.index(3) != nil #3:サイヤ人の血2
        temp_skill_no = 3
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.12
          skill_effect_flag = true 
        end
      elsif temp_cha_skill.index(4) != nil #4:サイヤ人の血3
        temp_skill_no = 4
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.14
          skill_effect_flag = true 
        end
      elsif temp_cha_skill.index(89) != nil #4:サイヤ人の血4
        temp_skill_no = 89
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.16
          skill_effect_flag = true 
        end
      elsif temp_cha_skill.index(90) != nil #4:サイヤ人の血5
        temp_skill_no = 90
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.18
          skill_effect_flag = true 
        end
      elsif temp_cha_skill.index(91) != nil #4:サイヤ人の血6
        temp_skill_no = 91
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.2
          skill_effect_flag = true 
        end
      elsif temp_cha_skill.index(92) != nil #4:サイヤ人の血7
        temp_skill_no = 92
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.22
          skill_effect_flag = true 
        end
      elsif temp_cha_skill.index(93) != nil #4:サイヤ人の血8
        temp_skill_no = 93
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.24
          skill_effect_flag = true 
        end
      elsif temp_cha_skill.index(94) != nil #4:サイヤ人の血9
        temp_skill_no = 94
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          bairitu = 1.30
          skill_effect_flag = true 
        end
      end
      
      if skill_effect_flag == true
        temp_exp = temp_exp * bairitu
        skill_effect_flag = false
      end
      
      if temp_cha_skill.index(9) != nil #2:王子の誇り
        temp_skill_no = 9
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          for x in 0..$partyc.size-1
            if temp_cha_no != $partyc.size-1
              if $game_actors[$partyc[x]].level > $game_actors[temp_cha_no].level
                skill_effect_flag = true
              end
            end
          end
        end
      elsif temp_cha_skill.index(428) != nil #2:王子の誇り2
        temp_skill_no = 428
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          for x in 0..$partyc.size-1
            if temp_cha_no != $partyc.size-1
              if $game_actors[$partyc[x]].level > $game_actors[temp_cha_no].level
                skill_effect_flag = true
              end
            end
          end
        end
      elsif temp_cha_skill.index(429) != nil #2:王子の誇り3
        temp_skill_no = 429
        if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          for x in 0..$partyc.size-1
            if temp_cha_no != $partyc.size-1
              if $game_actors[$partyc[x]].level > $game_actors[temp_cha_no].level
                skill_effect_flag = true
              end
            end
          end
        end
      end
      
      if skill_effect_flag == true
        temp_exp = temp_exp * 1.3
        skill_effect_flag = false
      end
      
    return temp_exp.to_i.ceil
  end
  
  #--------------------------------------------------------------------------
  # ● スキルを覚えているかチェック
  # cha_no:チェック対象キャラ 0は全部それ以外は対象のみ
  # skillno:対象スキル
  #-------------------------------------------------------------------------- 
  def chk_skill_learn skillno,cha_no=0
    
    temp_cha_skill = []
    temp_skill_no = skillno
    
    temp_skill_cha_no = []
    if cha_no != 0
      
      temp_cha_no = cha_no
      #temp_cha_no = $partyc[$partyc.index(cha_no)] #この処理は不要な処理をしていたため、コメントアウト
      if $cha_typical_skill != []
      
        for y in 0..$cha_typical_skill[temp_cha_no].size - 1
          temp_cha_skill << $cha_typical_skill[temp_cha_no][y]
          temp_skill_cha_no << temp_cha_no
        end
      end
      if $cha_add_skill != []
        
        for y in 0..$cha_add_skill[temp_cha_no].size - 1
          $cha_add_skill[temp_cha_no][y] = 0 if $cha_add_skill[temp_cha_no][y] == nil
          temp_skill_no = $cha_add_skill[temp_cha_no][y]
          temp_cha_skill << temp_skill_no
          temp_skill_cha_no << temp_cha_no
          #前Verのバグ調整
          #追加スキルのゲットフラグを調整
          #初回はエラーが出るため調整
          $cha_skill_spval[temp_cha_no] = [0] if $cha_skill_spval[temp_cha_no] == nil || $cha_skill_spval[temp_cha_no] == [nil]
          $cha_skill_spval[temp_cha_no][temp_skill_no] = 0 if $cha_skill_spval[temp_cha_no][temp_skill_no] == nil

          if $cha_skill_spval[temp_cha_no][temp_skill_no] < $cha_skill_get_val[temp_skill_no]
            #p temp_cha_no,$cha_skill_get_flag
            #p $cha_skill_get_flag[temp_cha_no]
            $cha_skill_get_flag[temp_cha_no][temp_skill_no] = 0

          end
        end
      end
      
      #p temp_cha_skill.index(skillno),skillno
      #スキルを覚えていてかつ、取得状態
      temp_skill_no = skillno
      
      if temp_cha_skill.index(temp_skill_no) != nil && $cha_skill_get_flag[temp_cha_no][temp_skill_no] == 1 #&& $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
        #覚えてた
        return true,temp_skill_cha_no[temp_cha_skill.index(temp_skill_no)]
      else
        #覚えていない
        return false,0
      end
      
    else
      for x in 0..$partyc.size - 1
        temp_cha_no = $partyc[x] 
      
        
        if $cha_typical_skill != []
        
          for y in 0..$cha_typical_skill[temp_cha_no].size - 1
            temp_cha_skill << $cha_typical_skill[temp_cha_no][y]
            temp_skill_cha_no << temp_cha_no
          end
        end
        
        if $cha_add_skill != []
          for y in 0..$cha_add_skill[temp_cha_no].size - 1
            $cha_add_skill[temp_cha_no][y] = 0 if $cha_add_skill[temp_cha_no][y] == nil
            temp_skill_no = $cha_add_skill[temp_cha_no][y]
            temp_cha_skill << temp_skill_no
            temp_skill_cha_no << temp_cha_no
            #前Verのバグ調整
            #追加スキルのゲットフラグを調整
            #初回はエラーが出るため調整
            $cha_skill_spval[temp_cha_no] = [0] if $cha_skill_spval[temp_cha_no] == nil || $cha_skill_spval[temp_cha_no] == [nil]
            $cha_skill_spval[temp_cha_no][temp_skill_no] = 0 if $cha_skill_spval[temp_cha_no][temp_skill_no] == nil
            
            if $cha_skill_spval[temp_cha_no][temp_skill_no] < $cha_skill_get_val[temp_skill_no]
              $cha_skill_get_flag[temp_cha_no][temp_skill_no] = 0
            end
          end
        end
        
        #p temp_cha_skill.index(skillno),skillno
        #スキルを覚えていてかつ、取得状態
        temp_skill_no = skillno

        if temp_cha_skill.index(temp_skill_no) != nil && $cha_skill_get_flag[temp_cha_no][temp_skill_no] == 1 #&& $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          #覚えてた
          return true,temp_skill_cha_no[temp_cha_skill.index(temp_skill_no)]
        end
      end
      #覚えていたで処理を返さなければ結果覚えていないとする
      return false,0
    end
    
  end
 #--------------------------------------------------------------------------
  # ● 1ターンに1回Kiを自動回復 #生きているキャラのみ
  #-------------------------------------------------------------------------- 
  def turn_recover_hpki
    
    
    for x in 0..$partyc.size - 1
      recover_hpki_num = 0 #回復する気の値
      temp_cha_skill = []
      temp_skill_no = 0
      skill_effect_flag = false
      useimei_skill = false #究極生命体スキルを覚えているか
      useimei_fukkatupar = 0 #究極生命体スキルで復活する量
        
        #スキル対象者回復====================================
        set_skill_nil_to_zero $partyc[x]
        temp_cha_no = $partyc[x]
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
        
        #自動全キャラHp回復====================================
        recover_hpki_per = $turn_recover_hp #回復する気のパーセント
        #大猿など巨大化している場合回復量をアップ
        recover_hpki_per = recover_hpki_per * 1.3 if $cha_bigsize_on[x] == true
        #対象キャラの計算(繰上げ
        if $chadead[x] == false && $chadeadchk[x] == false
          #生きている
          recover_hpki_num =((($game_actors[$partyc[x]].maxhp * recover_hpki_per).prec_f / 100).ceil).prec_i
          
        else
          #死んでる
          recover_hpki_num =((($game_actors[$partyc[x]].maxhp * (recover_hpki_per * 2.5)).prec_f / 100).ceil).prec_i
        end
        #対象キャラの計算(繰下げ 念の為用意
        #recover_hpki_num =((($game_actors[$partyc[x]].maxhp * recover_hpki_per).prec_f / 100).floor).prec_i
        
        #p $game_actors[$partyc[x]].hp,recover_hpki_num,$game_actors[$partyc[x]].hp+recover_hpki_num
        #p recover_hpki_num
        #対称キャラHP回復
        
        
        $game_actors[$partyc[x]].hp += recover_hpki_num if $chadeadchk[x] == $chadead[x]
        
        
        
        
        #HPがMAX または　対象％を超えたかチェック
        if $game_actors[$partyc[x]].hp >= $game_actors[$partyc[x]].maxhp
          $game_actors[$partyc[x]].hp = $game_actors[$partyc[x]].maxhp
          $chadeadchk[x] = false #復活
          $chadead[x] = false #復活  
        end
        
        #スキルHP====================================================
        recover_hpki_per_temp = 0
        if chk_skill_learn(10,temp_cha_no)[0] == true #10:再生(HP)
          temp_skill_no = 10
          skill_effect_flag = true
          recover_hpki_per_temp += 5
        elsif chk_skill_learn(12,temp_cha_no)[0] == true #12:再生(HPKI)
          temp_skill_no = 12
          skill_effect_flag = true
          recover_hpki_per_temp += 5
        elsif chk_skill_learn(35,temp_cha_no)[0] == true #35:魔族の力
          temp_skill_no = 35
          skill_effect_flag = true
          recover_hpki_per_temp += 5
        elsif chk_skill_learn(248,temp_cha_no)[0] == true #248:ネイルと同化
          temp_skill_no = 248
          skill_effect_flag = true
          recover_hpki_per_temp += 7
        elsif chk_skill_learn(249,temp_cha_no)[0] == true #249:神と融合
          temp_skill_no = 249
          skill_effect_flag = true
          recover_hpki_per_temp += 8
        elsif chk_skill_learn(423,temp_cha_no)[0] == true #423:Pエネルギーろl1
          temp_skill_no = 423
          skill_effect_flag = true
          recover_hpki_per_temp += 4
        elsif chk_skill_learn(424,temp_cha_no)[0] == true #424:Pエネルギーろl2
          temp_skill_no = 424
          skill_effect_flag = true
          recover_hpki_per_temp += 7
        elsif chk_skill_learn(425,temp_cha_no)[0] == true #425:Pエネルギーろl3
          temp_skill_no = 425
          skill_effect_flag = true
          recover_hpki_per_temp += 10
        end
        
        if chk_skill_learn(309,temp_cha_no)[0] == true && #力の温存1
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 309
          skill_effect_flag = true 
          recover_hpki_per_temp += 3
        elsif chk_skill_learn(310,temp_cha_no)[0] == true && #力の温存2
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 310
          skill_effect_flag = true
          recover_hpki_per_temp += 3.5
        elsif chk_skill_learn(311,temp_cha_no)[0] == true && #力の温存3
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 311
          skill_effect_flag = true
          recover_hpki_per_temp += 4
        elsif chk_skill_learn(312,temp_cha_no)[0] == true && #力の温存4
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 312
          skill_effect_flag = true
          recover_hpki_per_temp += 4.5
        elsif chk_skill_learn(313,temp_cha_no)[0] == true && #力の温存5
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 313
          skill_effect_flag = true
          recover_hpki_per_temp += 5
        elsif chk_skill_learn(314,temp_cha_no)[0] == true && #力の温存6
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 314
          skill_effect_flag = true
          recover_hpki_per_temp += 5.5
        elsif chk_skill_learn(315,temp_cha_no)[0] == true && #力の温存7
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 315
          skill_effect_flag = true
          recover_hpki_per_temp += 6
        elsif chk_skill_learn(316,temp_cha_no)[0] == true && #力の温存8
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 316
          skill_effect_flag = true
          recover_hpki_per_temp += 6.5
        elsif chk_skill_learn(317,temp_cha_no)[0] == true && #力の温存9
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 317
          skill_effect_flag = true
          recover_hpki_per_temp += 8
        end
        
        if chk_skill_learn(300,temp_cha_no)[0] == true && #心身一如1
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 300
          skill_effect_flag = true
          recover_hpki_per_temp += 3 / 2
        elsif chk_skill_learn(301,temp_cha_no)[0] == true && #心身一如2
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 301
          skill_effect_flag = true
          recover_hpki_per_temp += 3.5 / 2
        elsif chk_skill_learn(302,temp_cha_no)[0] == true && #心身一如3
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 302
          skill_effect_flag = true
          recover_hpki_per_temp += 4 / 2
        elsif chk_skill_learn(303,temp_cha_no)[0] == true && #心身一如4
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 303
          skill_effect_flag = true
          recover_hpki_per_temp += 4.5 / 2
        elsif chk_skill_learn(304,temp_cha_no)[0] == true && #心身一如5
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 304
          skill_effect_flag = true
          recover_hpki_per_temp += 5 / 2
        elsif chk_skill_learn(305,temp_cha_no)[0] == true && #心身一如6
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 305
          skill_effect_flag = true
          recover_hpki_per_temp += 5.5 / 2
        elsif chk_skill_learn(306,temp_cha_no)[0] == true && #心身一如7
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 306
          skill_effect_flag = true
          recover_hpki_per_temp += 6 / 2
        elsif chk_skill_learn(307,temp_cha_no)[0] == true && #心身一如8
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 307
          skill_effect_flag = true
          recover_hpki_per_temp += 6.5 / 2
        elsif chk_skill_learn(308,temp_cha_no)[0] == true && #心身一如9
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          temp_skill_no = 308
          skill_effect_flag = true
          recover_hpki_per_temp += 8 / 2
        end
        
        #rskill,rch_no = chk_skill_learn(377) #時間稼ぎ
        if chk_skill_learn(377)[0] == true #時間稼ぎ9
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(377)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 2.4
          end
        elsif chk_skill_learn(376)[0] == true #時間稼ぎ8
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(376)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 2.05
          end
        elsif chk_skill_learn(375)[0] == true #時間稼ぎ7
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(375)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 1.9
          end
        elsif chk_skill_learn(374)[0] == true #時間稼ぎ6
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(374)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 1.75
          end
        elsif chk_skill_learn(373)[0] == true #時間稼ぎ5
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(373)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 1.6
          end
        elsif chk_skill_learn(372)[0] == true #時間稼ぎ4
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(372)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 1.45
          end
        elsif chk_skill_learn(371)[0] == true #時間稼ぎ3
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(371)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 1.3
          end
        elsif chk_skill_learn(370)[0] == true #時間稼ぎ2
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(370)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 1.15
          end
        elsif chk_skill_learn(369)[0] == true #時間稼ぎ1
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(369)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 1.0
          end
        end
        
        #p "temp_cha_no:" + temp_cha_no.to_s,
        #  "skill_effect_flag:" + skill_effect_flag.to_s,
        #  "recover_hpki_per:" + recover_hpki_per.to_s,
        #  "recover_hpki_per_temp:" + recover_hpki_per_temp.to_s,
        #  "recover_hpki_num:" + recover_hpki_num.to_s
        
        if skill_effect_flag == true
          recover_hpki_per = recover_hpki_per_temp
          recover_hpki_num =((($game_actors[temp_cha_no].maxhp * recover_hpki_per).prec_f / 100).ceil).prec_i
          
          #対称キャラHP回復
          $game_actors[temp_cha_no].hp += recover_hpki_num if $chadeadchk[x] == $chadead[x]
          #HPがMAXを超えたかチェック
          if $game_actors[temp_cha_no].hp >= $game_actors[temp_cha_no].maxhp
            $game_actors[temp_cha_no].hp = $game_actors[temp_cha_no].maxhp
            $chadeadchk[x] = false #復活
            $chadead[x] = false
          end
          skill_effect_flag = false
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
        
        #rskill,rch_no = chk_skill_learn(420) #究極生命体
        if chk_skill_learn(537,temp_cha_no)[0] == true #究極生命体9
          useimei_skill = true
          useimei_fukkatupar = 10
        elsif chk_skill_learn(536,temp_cha_no)[0] == true #究極生命体8
          useimei_skill = true
          useimei_fukkatupar = 8
        elsif chk_skill_learn(535,temp_cha_no)[0] == true #究極生命体7
          useimei_skill = true
          useimei_fukkatupar = 7
        elsif chk_skill_learn(534,temp_cha_no)[0] == true #究極生命体6
          useimei_skill = true
          useimei_fukkatupar = 6
        elsif chk_skill_learn(533,temp_cha_no)[0] == true #究極生命体5
          useimei_skill = true
          useimei_fukkatupar = 5
        elsif chk_skill_learn(532,temp_cha_no)[0] == true #究極生命体4
          useimei_skill = true
          useimei_fukkatupar = 4
        elsif chk_skill_learn(531,temp_cha_no)[0] == true #究極生命体3
          useimei_skill = true
          useimei_fukkatupar = 3
        elsif chk_skill_learn(530,temp_cha_no)[0] == true #究極生命体2
          useimei_skill = true
          useimei_fukkatupar = 2
        elsif chk_skill_learn(529,temp_cha_no)[0] == true #究極生命体1
          useimei_skill = true
          useimei_fukkatupar = 1
        end
        
        #究極生命体スキルがあるので必ず復活する、味方が全滅時は発動しない
        if $chadead[x] == true && useimei_skill == true && $chadeadchk.index(false) != nil
          $chadeadchk[x] = false #復活
          $chadead[x] = false       
          $game_actors[temp_cha_no].hp += ((($game_actors[temp_cha_no].maxhp * useimei_fukkatupar).prec_f / 100).ceil).prec_i
        end
        
        if skill_effect_flag == true
          if $game_actors[temp_cha_no].hp >= ($game_actors[temp_cha_no].maxhp * fukkatuhosei) 
            #$game_actors[temp_cha_no].hp = $game_actors[temp_cha_no].maxhp
            $chadeadchk[x] = false #復活
            $chadead[x] = false
          end
          skill_effect_flag = false
        end
        #HPが指定割合を超えたか
      if $chadead[x] == false && $chadeadchk[x] == false  
        skill_effect_flag = false
        #自動全キャラKi回復====================================
        recover_hpki_per = $turn_recover_ki #回復する気のパーセント
        
        #大猿など巨大化している場合回復量をアップ
        recover_hpki_per = recover_hpki_per * 1.2 if $cha_bigsize_on[x] == true
        #対象キャラの計算(繰上げ
        recover_hpki_num =((($game_actors[$partyc[x]].maxmp * recover_hpki_per).prec_f / 100).ceil).prec_i
        
        #対象キャラの計算(繰下げ 念の為用意
        #recover_hpki_num =((($game_actors[$partyc[x]].maxmp * recover_hpki_per).prec_f / 100).floor).prec_i
        
        #p recover_hpki_num
        #対称キャラKI回復
        $game_actors[$partyc[x]].mp += recover_hpki_num
        #KIがMAXを超えたかチェック
        if $game_actors[$partyc[x]].mp > $game_actors[$partyc[x]].maxmp
          $game_actors[$partyc[x]].mp = $game_actors[$partyc[x]].maxmp
        end
        
        
        #KI====================================================
        recover_hpki_per_temp = 0

        if chk_skill_learn(11,temp_cha_no)[0] == true #11:再生(KI)
          skill_effect_flag = true
          recover_hpki_per_temp += 5
        elsif chk_skill_learn(12,temp_cha_no)[0] == true  #12:再生(HPKI)
          skill_effect_flag = true
          recover_hpki_per_temp += 5
        elsif chk_skill_learn(248,temp_cha_no)[0] == true #ネイルと同化
          skill_effect_flag = true
          recover_hpki_per_temp += 3
        elsif chk_skill_learn(249,temp_cha_no)[0] == true #249:神と融合
          skill_effect_flag = true
          recover_hpki_per_temp += 5
        elsif chk_skill_learn(423,temp_cha_no)[0] == true #423:Pエネルギーろl1
          skill_effect_flag = true
          recover_hpki_per_temp += 4
        elsif chk_skill_learn(424,temp_cha_no)[0] == true #424:Pエネルギーろl2
          skill_effect_flag = true
          recover_hpki_per_temp += 8
        elsif chk_skill_learn(425,temp_cha_no)[0] == true #425:Pエネルギーろl3
          skill_effect_flag = true
          recover_hpki_per_temp += 12
        end
        
        if chk_skill_learn(318,temp_cha_no)[0] == true && #精神統一1
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 2
        elsif chk_skill_learn(319,temp_cha_no)[0] == true && #精神統一2
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 2.3
        elsif chk_skill_learn(320,temp_cha_no)[0] == true && #精神統一3
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 2.6
        elsif chk_skill_learn(321,temp_cha_no)[0] == true && #精神統一4
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 2.9
        elsif chk_skill_learn(322,temp_cha_no)[0] == true && #精神統一5
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 3.2
        elsif chk_skill_learn(323,temp_cha_no)[0] == true && #精神統一6
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 3.5
        elsif chk_skill_learn(324,temp_cha_no)[0] == true && #精神統一7
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 3.8
        elsif chk_skill_learn(325,temp_cha_no)[0] == true && #精神統一8
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 4.1
        elsif chk_skill_learn(326,temp_cha_no)[0] == true && #精神統一9
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 5
        end
        
        if  chk_skill_learn(300,temp_cha_no)[0] == true && #心身一如1
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 2 / 2
        elsif  chk_skill_learn(301,temp_cha_no)[0] == true && #心身一如2
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 2.3 / 2
        elsif  chk_skill_learn(302,temp_cha_no)[0] == true && #心身一如3
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 2.6 / 2
        elsif  chk_skill_learn(303,temp_cha_no)[0] == true && #心身一如4
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 2.9 / 2
        elsif  chk_skill_learn(304,temp_cha_no)[0] == true && #心身一如5
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 3.2 / 2
        elsif  chk_skill_learn(305,temp_cha_no)[0] == true && #心身一如6
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 3.5 / 2
        elsif  chk_skill_learn(306,temp_cha_no)[0] == true && #心身一如7
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 3.8 / 2
        elsif  chk_skill_learn(307,temp_cha_no)[0] == true && #心身一如8
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 4.1 / 2
        elsif  chk_skill_learn(308,temp_cha_no)[0] == true && #心身一如9
          $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
          skill_effect_flag = true
          recover_hpki_per_temp += 5 / 2
        end
        
        if chk_skill_learn(377)[0] == true #時間稼ぎ9
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(377)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 1.4
          end
        elsif chk_skill_learn(376)[0] == true #時間稼ぎ8
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(376)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 1.2
          end
        elsif chk_skill_learn(375)[0] == true #時間稼ぎ7
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(375)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 1.1
          end
        elsif chk_skill_learn(374)[0] == true #時間稼ぎ6
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(374)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 1
          end
        elsif chk_skill_learn(373)[0] == true #時間稼ぎ5
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(373)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 0.9
          end
        elsif chk_skill_learn(372)[0] == true #時間稼ぎ4
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(372)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 0.8
          end
        elsif chk_skill_learn(371)[0] == true #時間稼ぎ3
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(371)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 0.7
          end
        elsif chk_skill_learn(370)[0] == true #時間稼ぎ2
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(370)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 0.6
          end
        elsif chk_skill_learn(369)[0] == true #時間稼ぎ1
          if $cha_btl_cont_part_turn[$partyc.index(chk_skill_learn(369)[1])] != 0 &&
            $cha_btl_cont_part_turn[$partyc.index(temp_cha_no)] == 0
            skill_effect_flag = true
            recover_hpki_per_temp += 0.5
          end
        end
        
        if skill_effect_flag == true
          recover_hpki_per = recover_hpki_per_temp
          recover_hpki_num =((($game_actors[temp_cha_no].maxmp * recover_hpki_per).prec_f / 100).ceil).prec_i
          #対称キャラKI回復
          $game_actors[temp_cha_no].mp += recover_hpki_num
          #KIがMAXを超えたかチェック
          if $game_actors[temp_cha_no].mp > $game_actors[temp_cha_no].maxmp
            $game_actors[temp_cha_no].mp = $game_actors[temp_cha_no].maxmp
          end
          skill_effect_flag = false
        end
        
        #気を練る
        if chk_skill_learn(299,temp_cha_no)[0] == true #299:気を練る9
          temp_skill_no = 299
          
          recover_hpki_per_temp = 9
          recover_hpki_num =((($game_actors[temp_cha_no].maxhp * recover_hpki_per_temp).prec_f / 100).ceil).prec_i
          if $game_actors[temp_cha_no].hp > recover_hpki_num && $game_actors[temp_cha_no].mp != $game_actors[temp_cha_no].maxmp
            skill_effect_flag = true
          end
        elsif chk_skill_learn(298,temp_cha_no)[0] == true #298:気を練る8
          temp_skill_no = 298
          recover_hpki_per_temp = 8
          recover_hpki_num =((($game_actors[temp_cha_no].maxhp * recover_hpki_per_temp).prec_f / 100).ceil).prec_i
          if $game_actors[temp_cha_no].hp > recover_hpki_num && $game_actors[temp_cha_no].mp != $game_actors[temp_cha_no].maxmp
            skill_effect_flag = true
          end
        elsif chk_skill_learn(297,temp_cha_no)[0] == true #297:気を練る7
          temp_skill_no = 297
          recover_hpki_per_temp = 7
          recover_hpki_num =((($game_actors[temp_cha_no].maxhp * recover_hpki_per_temp).prec_f / 100).ceil).prec_i
          if $game_actors[temp_cha_no].hp > recover_hpki_num && $game_actors[temp_cha_no].mp != $game_actors[temp_cha_no].maxmp
            skill_effect_flag = true
          end
        elsif chk_skill_learn(296,temp_cha_no)[0] == true #296:気を練る6
          temp_skill_no = 296
          recover_hpki_per_temp = 6
          recover_hpki_num =((($game_actors[temp_cha_no].maxhp * recover_hpki_per_temp).prec_f / 100).ceil).prec_i
          if $game_actors[temp_cha_no].hp > recover_hpki_num && $game_actors[temp_cha_no].mp != $game_actors[temp_cha_no].maxmp
            skill_effect_flag = true
          end
        elsif chk_skill_learn(295,temp_cha_no)[0] == true #295:気を練る5
          temp_skill_no = 295
          recover_hpki_per_temp = 5
          recover_hpki_num =((($game_actors[temp_cha_no].maxhp * recover_hpki_per_temp).prec_f / 100).ceil).prec_i
          if $game_actors[temp_cha_no].hp > recover_hpki_num && $game_actors[temp_cha_no].mp != $game_actors[temp_cha_no].maxmp
            skill_effect_flag = true
          end
        elsif chk_skill_learn(294,temp_cha_no)[0] == true #294:気を練る4
          temp_skill_no = 294
          recover_hpki_per_temp = 4
          recover_hpki_num =((($game_actors[temp_cha_no].maxhp * recover_hpki_per_temp).prec_f / 100).ceil).prec_i
          if $game_actors[temp_cha_no].hp > recover_hpki_num && $game_actors[temp_cha_no].mp != $game_actors[temp_cha_no].maxmp
            skill_effect_flag = true
          end
        elsif chk_skill_learn(293,temp_cha_no)[0] == true #293:気を練る3
          temp_skill_no = 293
          recover_hpki_per_temp = 3
          recover_hpki_num =((($game_actors[temp_cha_no].maxhp * recover_hpki_per_temp).prec_f / 100).ceil).prec_i
          if $game_actors[temp_cha_no].hp > recover_hpki_num && $game_actors[temp_cha_no].mp != $game_actors[temp_cha_no].maxmp
            skill_effect_flag = true
          end
        elsif chk_skill_learn(292,temp_cha_no)[0] == true #298:気を練る2
          temp_skill_no = 292
          recover_hpki_per_temp = 2
          recover_hpki_num =((($game_actors[temp_cha_no].maxhp * recover_hpki_per_temp).prec_f / 100).ceil).prec_i
          if $game_actors[temp_cha_no].hp > recover_hpki_num && $game_actors[temp_cha_no].mp != $game_actors[temp_cha_no].maxmp
            skill_effect_flag = true
          end
        elsif chk_skill_learn(291,temp_cha_no)[0] == true #298:気を練る1
          temp_skill_no = 291
          recover_hpki_per_temp = 1
          recover_hpki_num =((($game_actors[temp_cha_no].maxhp * recover_hpki_per_temp).prec_f / 100).ceil).prec_i
          if $game_actors[temp_cha_no].hp > recover_hpki_num && $game_actors[temp_cha_no].mp != $game_actors[temp_cha_no].maxmp
            skill_effect_flag = true
          end
        
        end
        
        if skill_effect_flag == true

          
          recover_hpki_per = recover_hpki_per_temp
          recover_hpki_num =((($game_actors[temp_cha_no].maxmp * recover_hpki_per).prec_f / 100).ceil).prec_i

          #p "KI回復前",
          #  "temp_cha_no:" + temp_cha_no.to_s,
          #  "skill_effect_flag:" + skill_effect_flag.to_s,
          #  "recover_hpki_per:" + recover_hpki_per.to_s,
          #  "recover_hpki_per_temp:" + recover_hpki_per_temp.to_s,
          #  "recover_hpki_num:" + recover_hpki_num.to_s,
          #  "$game_actors[temp_cha_no].hp:" + $game_actors[temp_cha_no].hp.to_s,
          #  "$game_actors[temp_cha_no].mp:" + $game_actors[temp_cha_no].mp.to_s
          #対称キャラKI回復
          $game_actors[temp_cha_no].mp += recover_hpki_num
          
          #p "KI回復後、HP回復前",
          #  "temp_cha_no:" + temp_cha_no.to_s,
          #  "skill_effect_flag:" + skill_effect_flag.to_s,
          #  "recover_hpki_per:" + recover_hpki_per.to_s,
          #  "recover_hpki_per_temp:" + recover_hpki_per_temp.to_s,
          #  "recover_hpki_num:" + recover_hpki_num.to_s,
          #  "$game_actors[temp_cha_no].hp:" + $game_actors[temp_cha_no].hp.to_s,
          #  "$game_actors[temp_cha_no].mp:" + $game_actors[temp_cha_no].mp.to_s
          #対象キャラHP消費
          recover_hpki_num =((($game_actors[temp_cha_no].maxhp * recover_hpki_per).prec_f / 100).ceil).prec_i
          $game_actors[temp_cha_no].hp -= recover_hpki_num
          
          #p "KI回復後、HP回復後",
          #  "temp_cha_no:" + temp_cha_no.to_s,
          #  "skill_effect_flag:" + skill_effect_flag.to_s,
          #  "recover_hpki_per:" + recover_hpki_per.to_s,
          #  "recover_hpki_per_temp:" + recover_hpki_per_temp.to_s,
          #  "recover_hpki_num:" + recover_hpki_num.to_s,
          #  "$game_actors[temp_cha_no].hp:" + $game_actors[temp_cha_no].hp.to_s,
          #  "$game_actors[temp_cha_no].mp:" + $game_actors[temp_cha_no].mp.to_s
          
          #KIがMAXを超えたかチェック
          if $game_actors[temp_cha_no].mp > $game_actors[temp_cha_no].maxmp
            $game_actors[temp_cha_no].mp = $game_actors[temp_cha_no].maxmp
          end
          skill_effect_flag = false
        end
        
        #限界を超えたパワー
        #p $fullpower_on_flag
        if $fullpower_on_flag.index(temp_cha_no) != nil
          recover_hpki_per_temp = -8
          
          recover_hpki_per = recover_hpki_per_temp
          recover_hpki_num =((($game_actors[temp_cha_no].maxmp * recover_hpki_per).prec_f / 100).ceil).prec_i
          #対称キャラKI回復
          $game_actors[temp_cha_no].mp += recover_hpki_num
          #KIが0以下かチェック
          if $game_actors[temp_cha_no].mp < 0
            $game_actors[temp_cha_no].mp = 0
          end
          skill_effect_flag = false
          
          #ここで初期化すると2キャラ目以降の消費がされないので、他で初期化
          #$fullpower_on_flag = []
        end
        
        
      end
    end

    
  end
  

  #--------------------------------------------------------------------------
  # ● 戦闘カットイン
  # cha_no:キャラクターNo
  #--------------------------------------------------------------------------
  def set_battle_cutin_name cha_no
    
    cutin_name = $top_file_name + "味方カットイン"
    
    top = ""

    if $top_file_name != "Z3_"
      rect = Rect.new(0, 64*(cha_no-3), 640, 64)
    else
      rect = Rect.new(0, 64*(cha_no-3), 640, 64)
    end
    
    #亀仙人普段着
    if cha_no == 24 && $game_switches[363] == true
      
      if $game_variables[40] == 1
        top = "Z3_"
        name = "味方カットイン"
        rect = Rect.new(2*640, 64*21, 640, 64)
      else
        top = "Z3_"
        name = "味方カットイン"
        rect = Rect.new(2*640, 64*21, 640, 64)
      end
    end

    #32
    #バーダックスカウターなし
    if cha_no == 16 && $game_variables[175] == 1
      top = "ZG_"
      name = "味方カットイン"
      rect = Rect.new(0, 64*(8), 640, 64)
    end
    #超バーダックスカウターなし
    if cha_no == 32 && $game_variables[175] == 1
      top = "ZG_"
      name = "味方カットイン"
      rect = Rect.new(0, 64*(9), 640, 64)
    end    
    #トランクスバトルスーツならば
    if cha_no == 17 && $game_variables[173] == 1
      top = "ZG_"
      name = "味方カットイン"
      rect = Rect.new(0, 64*(5), 640, 64)
    end
    
    #トランクス(超)とバトルスーツならば
    if cha_no == 20 && $game_variables[173] == 1
      top = "ZG_"
      name = "味方カットイン"
      rect = Rect.new(0, 64*(4), 640, 64)
    end
    #トランクスとタンクトップ長髪、私服長髪
    if cha_no == 17 && $game_variables[173] == 3 || cha_no == 17 && $game_variables[173] == 4
      top = "ZG_"
      name = "味方カットイン"
      rect = Rect.new(0, 64*(7), 640, 64)
    end
    
    #トランクス(超)とタンクトップ長髪、私服長髪
    if cha_no == 20 && $game_variables[173] == 3 || cha_no == 20 && $game_variables[173] == 4
      top = "ZG_"
      name = "味方カットイン"
      rect = Rect.new(0, 64*(4), 640, 64)
    end
    
    #Z3悟空
    if cha_no == 14 && $game_variables[171] == 2 && $game_variables[40] == 2
        top = "ZG_"
        name = "味方カットイン"
        rect = Rect.new(0, 64*(10), 640, 64)
    end
    
    #Z3悟飯短髪
    if cha_no == 5 && $game_switches[445] == true && $game_variables[40] == 2
        top = "ZG_"
        name = "味方カットイン"
        rect = Rect.new(0, 64*(6), 640, 64)
    end
    
    #Z3悟飯超サイヤ人2
    if cha_no == 18 && $super_saiyazin_flag[5] == true && $game_variables[40] == 2
        top = "ZG_"
        name = "味方カットイン"
        rect = Rect.new(0, 64*(2), 640, 64)
      end
    #Z2トーマ大猿
    if cha_no == 27 && $oozaru_flag[1] == true && $game_variables[40] == 1
      top = "Z2_"
      name = "バーダック一味大猿カットイン"
      rect = Rect.new(0, 64*0, 640, 64)
    end
    
    #Z2セリパ大猿
    if cha_no == 28 && $oozaru_flag[2] == true && $game_variables[40] == 1
      top = "Z2_"
      name = "バーダック一味大猿カットイン"
      rect = Rect.new(0, 64*0, 640, 64)
    end
    
    #Z2トテッポ大猿
    if cha_no == 29 && $oozaru_flag[3] == true && $game_variables[40] == 1
      top = "Z2_"
      name = "バーダック一味大猿カットイン"
      rect = Rect.new(0, 64*0, 640, 64)
    end
    
    #Z2パンブーキン大猿
    if cha_no == 30 && $oozaru_flag[4] == true && $game_variables[40] == 1
      top = "Z2_"
      name = "バーダック一味大猿カットイン"
      rect = Rect.new(0, 64*0, 640, 64)
    end
    
    #Z3トーマ大猿
    if cha_no == 27 && $oozaru_flag[1] == true && $game_variables[40] == 2
      top = "Z3_"
      name = "バーダック一味大猿カットイン"
      rect = Rect.new(0, 64*0, 640, 64)
    end
    
    #Z3セリパ大猿
    if cha_no == 28 && $oozaru_flag[2] == true && $game_variables[40] == 2
      top = "Z3_"
      name = "バーダック一味大猿カットイン"
      rect = Rect.new(0, 64*0, 640, 64)
    end
    
    #Z3トテッポ大猿
    if cha_no == 29 && $oozaru_flag[3] == true && $game_variables[40] == 2
      top = "Z3_"
      name = "バーダック一味大猿カットイン"
      rect = Rect.new(0, 64*0, 640, 64)
    end
    
    #Z3パンブーキン大猿
    if cha_no == 30 && $oozaru_flag[4] == true && $game_variables[40] == 2
      top = "Z3_"
      name = "バーダック一味大猿カットイン"
      rect = Rect.new(0, 64*0, 640, 64)
    end
    if top != ""
      cutin_name = top
      cutin_name += name
    end
    
    picture = Cache.picture(cutin_name)
    return rect,picture
  end

  #--------------------------------------------------------------------------
  # ● 回復カードの効果アップスキルの効果パーセントを取得
  # 引数 cha_no:キャラクターNo
  # 戻値 1,HP効果アップ量、2KI効果アップ量
  #--------------------------------------------------------------------------
  def get_recovery_hpki_skill_par cha_no

      #HP効果アップ量
      recovery_hp_skill_par = 0
      #KI効果アップ量
      recovery_mp_skill_par = 0
    
      if chk_skill_learn(431,cha_no)[0] == true
        recovery_hp_skill_par += 10
      end
      if chk_skill_learn(432,cha_no)[0] == true
        recovery_hp_skill_par += 11
      end
      if chk_skill_learn(433,cha_no)[0] == true
        recovery_hp_skill_par += 12
      end     
      if chk_skill_learn(434,cha_no)[0] == true
        recovery_hp_skill_par += 13
      end     
      if chk_skill_learn(435,cha_no)[0] == true
        recovery_hp_skill_par += 14
      end     
      if chk_skill_learn(436,cha_no)[0] == true
        recovery_hp_skill_par += 15
      end     
      if chk_skill_learn(437,cha_no)[0] == true
        recovery_hp_skill_par += 16
      end     
      if chk_skill_learn(438,cha_no)[0] == true
        recovery_hp_skill_par += 17
      end     
      if chk_skill_learn(439,cha_no)[0] == true
        recovery_hp_skill_par += 20
      end

     #KI効果アップ
      if chk_skill_learn(440,cha_no)[0] == true
        recovery_mp_skill_par += 10
      end
      if chk_skill_learn(441,cha_no)[0] == true
        recovery_mp_skill_par += 11
      end
      if chk_skill_learn(442,cha_no)[0] == true
        recovery_mp_skill_par += 12
      end     
      if chk_skill_learn(443,cha_no)[0] == true
        recovery_mp_skill_par += 13
      end     
      if chk_skill_learn(444,cha_no)[0] == true
        recovery_mp_skill_par += 14
      end     
      if chk_skill_learn(445,cha_no)[0] == true
        recovery_mp_skill_par += 15
      end     
      if chk_skill_learn(446,cha_no)[0] == true
        recovery_mp_skill_par += 16
      end     
      if chk_skill_learn(447,cha_no)[0] == true
        recovery_mp_skill_par += 17
      end     
      if chk_skill_learn(448,cha_no)[0] == true
        recovery_mp_skill_par += 20
      end
      
      #HPKI効果アップ
      if chk_skill_learn(449,cha_no)[0] == true
        recovery_hp_skill_par += 5
        recovery_mp_skill_par += 5
      end
      if chk_skill_learn(450,cha_no)[0] == true
        recovery_hp_skill_par += 5.5
        recovery_mp_skill_par += 5.5
      end
      if chk_skill_learn(451,cha_no)[0] == true
        recovery_hp_skill_par += 6
        recovery_mp_skill_par += 6
      end     
      if chk_skill_learn(452,cha_no)[0] == true
        recovery_hp_skill_par += 6.5
        recovery_mp_skill_par += 6.5
      end     
      if chk_skill_learn(453,cha_no)[0] == true
        recovery_hp_skill_par += 7
        recovery_mp_skill_par += 7
      end     
      if chk_skill_learn(454,cha_no)[0] == true
        recovery_hp_skill_par += 7.5
        recovery_mp_skill_par += 7.5
      end     
      if chk_skill_learn(455,cha_no)[0] == true
        recovery_hp_skill_par += 8
        recovery_mp_skill_par += 8
      end     
      if chk_skill_learn(456,cha_no)[0] == true
        recovery_hp_skill_par += 8.5
        recovery_mp_skill_par += 8.5
      end     
      if chk_skill_learn(457,cha_no)[0] == true
        recovery_hp_skill_par += 10
        recovery_mp_skill_par += 10
      end

      #検証用 小数点を足しても問題なく計算されることを確認
      #recovery_hp_skill_par += 10.5
      #recovery_mp_skill_par += 5.5
    
      return recovery_hp_skill_par,recovery_mp_skill_par
  end
  #--------------------------------------------------------------------------
  # ● 戦闘グラセット
  # cha_no:キャラクターNo pic_mode:通常か必殺技か 0:通常 1:必殺技
  #--------------------------------------------------------------------------
  def set_battle_character_name cha_no,pic_mode = 0
    
    if pic_mode == 0
      btl_cha_name = $top_file_name + "戦闘_" + $data_actors[cha_no].name
    else
      btl_cha_name = $top_file_name + "戦闘_必殺技_" + $data_actors[cha_no].name
    end
    
    top = ""
    
    #Z1悟飯大猿
    if cha_no == 5 && $game_variables[40] == 0 && $oozaru_flag[5] == true
        top = "Z1_"
        name = "ゴハン(大猿)96×96"
    end
    
    #亀仙人普段着
    if cha_no == 24 && $game_switches[363] == true
      
      if $game_variables[40] == 0
        top = "Z1_"
      elsif $game_variables[40] == 1
        top = "Z2_"
      else
        top = "Z3_"
      end
      name = "かめせんにん(普段着)"
    end
    
    #Z2悟空さらにボロボロ
    if cha_no == 14 && $game_variables[40] == 1 && $game_variables[171] == 2
        top = "Z3_"
        name = "ゴクウ(超・さらにボロボロ)"
    end
    #Z2悟飯バトルスーツ
    if cha_no == 5 && $game_variables[40] == 1 && $game_variables[161] == 1
        top = "Z2_"
        name = "ゴハン_バトルスーツ"
    end
    #Z2クリリンバトルスーツ
    if cha_no == 6 && $game_variables[40] == 1 && $game_variables[162] == 1
        top = "Z2_"
        name = "クリリン_バトルスーツ"
    end
      
    
    #Z2トーマ大猿
    if cha_no == 27 && $game_variables[40] == 1 && $oozaru_flag[1] == true
        top = "Z2_"
        name = "トーマ(大猿)96×96"
    end
      
    #Z2セリパ大猿
    if cha_no == 28 && $game_variables[40] == 1 && $oozaru_flag[2] == true
        top = "Z2_"
        name = "セリパ(大猿)96×96"
    end
      
    #Z2トテッポ大猿
    if cha_no == 29 && $game_variables[40] == 1 && $oozaru_flag[3] == true
        top = "Z2_"
        name = "トテッポ(大猿)96×96"
    end
    
    #Z2パンブーキン大猿
    if cha_no == 30 && $game_variables[40] == 1 && $oozaru_flag[4] == true
        top = "Z2_"
        name = "パンブーキン(大猿)96×96"
    end
      
    
    #Z3悟空ボロボロ
    if cha_no == 3 && $game_variables[40] == 2 && $game_variables[171] == 1
        top = "Z3_"
        name = "ゴクウ(ボロボロ)"
    #Z3悟空さらにボロボロ(素材がないのでボロボロのままにする)
    elsif cha_no == 3 && $game_variables[40] == 2 && $game_variables[171] == 2
        top = "Z3_"
        name = "ゴクウ(ボロボロ)"
    #Z3悟空バトルスーツ
    elsif cha_no == 3 && $game_variables[40] == 2 && $game_variables[171] == 3
        top = "Z3_"
        name = "ゴクウ(バトルスーツ)"
    end
    
    #Z3超悟空ボロボロ
    if cha_no == 14 && $game_variables[40] == 2 && $game_variables[171] == 1
        top = "Z3_"
        name = "ゴクウ(超・ボロボロ)"
    #Z3悟空さらにボロボロ
    elsif cha_no == 14 && $game_variables[40] == 2 && $game_variables[171] == 2
        top = "Z3_"
        name = "ゴクウ(超・さらにボロボロ)"
    #Z3超悟空バトルスーツ
    elsif cha_no == 14 && $game_variables[40] == 2 && $game_variables[171] == 3
        top = "Z3_"
        name = "ゴクウ(超・バトルスーツ)"
    end
    
    #Z3超悟空3大必殺
    if cha_no == 14 && $game_variables[40] == 2 && $game_variables[171] == 1 && $goku3dai == true
        top = "Z3_"
        name = "ゴクウ(超・ボロボロ)_元気玉吸収"
    elsif cha_no == 14 && $game_variables[40] == 2 && $game_variables[171] == 2 && $goku3dai == true
        top = "Z3_"
        name = "ゴクウ(超・さらにボロボロ)_元気玉吸収"
    #Z3悟空バトルスーツ
    elsif cha_no == 14 && $game_variables[40] == 2 && $game_variables[171] == 3 && $goku3dai == true
        top = "Z3_"
        name = "ゴクウ(超・バトルスーツ)元気玉吸収"
    elsif cha_no == 14 && $game_variables[40] == 2 && $goku3dai == true
        top = "Z3_"
        name = "ゴクウ(超)元気玉吸収"
    end

    #Z3トーマ大猿
    if cha_no == 27 && $game_variables[40] == 2 && $oozaru_flag[1] == true
        top = "Z3_"
        name = "トーマ(大猿)96×96"
    end
    
    #Z3セリパ大猿
    if cha_no == 28 && $game_variables[40] == 2 && $oozaru_flag[2] == true
        top = "Z3_"
        name = "セリパ(大猿)96×96"
    end
      
    #Z3トテッポ大猿
    if cha_no == 29 && $game_variables[40] == 2 && $oozaru_flag[3] == true
        top = "Z3_"
        name = "トテッポ(大猿)96×96"
    end
    
    #Z3パンブーキン大猿
    if cha_no == 30 && $game_variables[40] == 2 && $oozaru_flag[4] == true
        top = "Z3_"
        name = "パンブーキン(大猿)96×96"
    end
    #ベジータ超で精神と時の部屋修行が終わったのならば
    if cha_no == 19 && $game_variables[40] == 2 && $game_switches[110] == true
        top = "ZG_"
        name = "ベジータ(超)"
    end
    
    #トランクスバトルスーツならば
    if cha_no == 17 && $game_variables[173] == 1
      top = "ZG_"
      name = "トランクス"
    end
    
    #トランクス(超)とバトルスーツならば
    if cha_no == 20 && $game_variables[173] == 1
      top = "ZG_"
      name = "トランクス(超)"
    end
    
    #トランクスタンクトップならば
    if cha_no == 17 && $game_variables[173] == 2
      top = "Z3_"
      name = "トランクス(タンクトップ)"
    end
    
    #トランクス(超)とタンクトップならば
    if cha_no == 20 && $game_variables[173] == 2
      top = "Z3_"
      name = "トランクス(超)(タンクトップ)"
    end
    #トランクスタンクトップ長髪
    if cha_no == 17 && $game_variables[173] == 3
      top = "Z3_"
      name = "トランクス(剣なし・タンクトップ・長髪)"
    end
    
    #トランクス(超)とタンクトップ長髪
    if cha_no == 20 && $game_variables[173] == 3
      top = "Z3_"
      name = "トランクス(超)(剣なし・タンクトップ・長髪)"
    end    
    #トランクス私服長髪ならば
    if cha_no == 17 && $game_variables[173] == 4
      top = "Z3_"
      name = "トランクス(剣持ち長髪)"
    end
    
    #トランクス(超)と私服長髪ならば
    if cha_no == 20 && $game_variables[173] == 4
      top = "Z3_"
      name = "トランクス(超)(剣持ち長髪)"
    end
    
    #Z318号着せ替え
    if cha_no == 21 && $game_variables[40] == 2 && $game_variables[177] == 1
        top = "Z3_"
        name = "18号(着替)"
      end
      
    #Z3悟飯バトルスーツ
    if cha_no == 5 && $game_variables[40] == 2 && $game_variables[172] == 1 && $game_switches[445] == false
        top = "Z3_"
        name = "ゴハン(バトルスーツ)"
    end
    #ZG悟飯サイヤ人
    if cha_no == 5 && $game_variables[40] == 2 && $game_switches[445] == true
        top = "ZG_"
        name = "ゴハン"
    end
      
    #ZG悟飯超サイヤ人
    if cha_no == 18 && $game_variables[40] == 2 # && $game_variables[161] == 1
        top = "ZG_"
        name = "ゴハン(超)"
    end
    #Z3悟飯超サイヤ人2
    if cha_no == 18 && $super_saiyazin_flag[5] == true && $game_variables[40] == 2
        top = "ZG_"
        name = "ゴハン(超2)"
    end
    #ZG悟飯サイヤ人(赤道着)
    if cha_no == 5 && $game_variables[40] == 2 && $game_switches[445] == true && $game_variables[172] == 2
        top = "ZG_"
        name = "ゴハン_赤道着"
    end
      
    #ZG悟飯超サイヤ人(赤道着)
    if cha_no == 18 && $game_variables[40] == 2 && $game_variables[172] == 2
        top = "ZG_"
        name = "ゴハン(超)_赤道着"
    end
    #Z3悟飯超サイヤ人2(赤道着)
    if cha_no == 18 && $super_saiyazin_flag[5] == true && $game_variables[40] == 2 && $game_variables[172] == 2
        top = "ZG_"
        name = "ゴハン(超2)_赤道着"
    end
    if top != ""
      btl_cha_name = top
      if pic_mode == 0
        btl_cha_name += "戦闘_"
      else
        btl_cha_name += "戦闘_必殺技_"
      end
      
      btl_cha_name += name
    end
    
    return btl_cha_name
  end
  
  #--------------------------------------------------------------------------
  # ● 味方顔グラセット
  # column:列 row:行 pic_mode:戻り値をキャッシュにするか文字列にするか 0:キャッシュ 1:文字列
  #--------------------------------------------------------------------------
  def set_character_face column,row,pic_mode = 0,game_switches = [0] , game_variables = [0] , oozaru_flag = [0]
    rect = Rect.new(column*64 , 64*row, 64, 64)
    
    pic = $top_file_name + "顔味方"

    #p game_switches
    
    #Z1
    if game_variables[40] == 0 || $game_variables[40] == 0
      
      #Z1悟飯(大猿)
      if game_switches[0] == 0 && row == 2 && $oozaru_flag[5] == true ||  row == 2 && oozaru_flag[5] == true
        pic = "Z1_顔大猿"
        rect = Rect.new(column *64, 64*2, 64, 64)
      end
      
      
      #Z1亀仙人普段着
      if game_switches[0] == 0 && row == 21 && $game_switches[363] == true ||  row == 21 && game_switches[363] == true
        pic = "Z3_顔味方_亀仙人"
        rect = Rect.new(column *64, 64*0, 64, 64)
      end
    end

    
    #Z2
    if game_variables[40] == 1 || $game_variables[40] == 1
      #Z2悟空さらにボロボロ(超)
      if game_switches[0] == 0 && row == 11 && $game_variables[171] == 2 || row == 11 && game_variables[171] == 1 && $super_saiyazin_flag[1] == true
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column *64, 64*22, 64, 64)
      end      
      
      #Z2悟飯バトルスーツ
      if game_switches[0] == 0 && row == 2 && $game_variables[161] == 1 ||  row == 2 && game_variables[161] == 1
        pic = "Z2_顔味方_衣替"
        rect = Rect.new(column *64, 64*0, 64, 64)
      end
      
      #Z2クリリンバトルスーツ
      if game_switches[0] == 0 && row == 3 && $game_variables[162] == 1 ||  row == 3 && game_variables[162] == 1
        pic = "Z2_顔味方_衣替"
        rect = Rect.new(column *64, 64*1, 64, 64)
      end
      
      #Z2バーダックはちまきなし
      if game_switches[0] == 0 && row == 13 && $game_variables[163] == 1 ||  row == 13 && game_variables[163] == 1
        pic = "Z2_顔味方_衣替"
        rect = Rect.new(column *64, 64*2, 64, 64)
      end
      
      #Z2亀仙人普段着
      if game_switches[0] == 0 && row == 21 && $game_switches[363] == true ||  row == 21 && game_switches[363] == true
        pic = "Z3_顔味方_亀仙人"
        rect = Rect.new(column *64, 64*1, 64, 64)
      end
      
      #Z2トーマ(大猿)
      if game_switches[0] == 0 && row == 24 && $oozaru_flag[1] == true ||  row == 24 && oozaru_flag[1] == true
        pic = "Z1_顔大猿"
        rect = Rect.new(column *64, 64*5, 64, 64)
      end
      
      #Z2セリパ(大猿)
      if game_switches[0] == 0 && row == 25 && $oozaru_flag[2] == true ||  row == 25 && oozaru_flag[2] == true
        pic = "Z1_顔大猿"
        rect = Rect.new(column *64, 64*6, 64, 64)
      end
      
      #Z2トテッポ(大猿)
      if game_switches[0] == 0 && row == 26 && $oozaru_flag[3] == true ||  row == 26 && oozaru_flag[3] == true
        pic = "Z1_顔大猿"
        rect = Rect.new(column *64, 64*7, 64, 64)
      end
      
      #Z2パンブーキン(大猿)
      if game_switches[0] == 0 && row == 27 && $oozaru_flag[4] == true ||  row == 27 && oozaru_flag[4] == true
        pic = "Z1_顔大猿"
        rect = Rect.new(column *64, 64*8, 64, 64)
      end
    end
    
    
    #Z3
    if game_variables[40] == 2 || $game_variables[40] == 2
      #Z3悟空ボロボロ
      if game_switches[0] == 0 && row == 0 && $game_variables[171] == 1 || row == 0 && game_variables[171] == 1
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column *64, 64*3, 64, 64)
      end
      
      #Z3悟空さらにボロボロ(素材がないのでボロボロのままで)
      if game_switches[0] == 0 && row == 0 && $game_variables[171] == 2 || row == 0 && game_variables[171] == 2
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column *64, 64*3, 64, 64)
      end
      
      #Z3悟空バトルスーツ
      if game_switches[0] == 0 && row == 0 && $game_variables[171] == 3 || row == 0 && game_variables[171] == 3
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column *64, 64*0, 64, 64)
      end
      
      #Z3悟空ボロボロ(超)
      if game_switches[0] == 0 && row == 11 && $game_variables[171] == 1 || row == 11 && game_variables[171] == 1 && $super_saiyazin_flag[1] == true
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column *64, 64*4, 64, 64)
      end
      
      #Z3悟空さらにボロボロ(超)
      if game_switches[0] == 0 && row == 11 && $game_variables[171] == 2 || row == 11 && game_variables[171] == 2 && $super_saiyazin_flag[1] == true
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column *64, 64*22, 64, 64)
      end
      
      #Z3悟空バトルスーツ(超)
      if game_switches[0] == 0 && row == 11 && $game_variables[171] == 3 || row == 11 && game_variables[171] == 3 && $super_saiyazin_flag[1] == true
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column *64, 64*1, 64, 64)
      end

      #Z3悟飯バトルスーツ
      if game_switches[0] == 0 && row == 2 && $game_switches[445] == false && $game_variables[172] == 1 || row == 2 && game_switches[445] == false && game_variables[172] == 1
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column *64, 64*6, 64, 64)
      end

      #Z3悟飯短髪
      if game_switches[0] == 0 && row == 2 && $game_switches[445] == true || row == 2 && game_switches[445] == true
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column *64, 64*8, 64, 64)
      end
      
      #Z3悟飯超サイヤ人2
      if game_switches[0] == 0 && row == 15 && $game_switches[388] == true || row == 15 && game_switches[388] == true
        pic = "ZG_顔グラ(ゴハン超1_2)"
        rect = Rect.new(column *64, 64*2, 64, 64)
      end
      
      #Z3チチ
      if game_switches[0] == 0 && row == 7 && $game_variables[176] == 1 || row == 7 && game_variables[176] == 1
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column *64, 64*21, 64, 64)
      end
      
      #バーダックスカウターなし
      if game_switches[0] == 0 && row == 13 && $game_variables[175] == 1 || row == 13 && game_variables[175] == 1
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column*64 , 64*11, 64, 64)
      end
      
      #バーダックスカウターなし
      if game_switches[0] == 0 && row == 29 && $game_variables[175] == 1 || row == 29 && game_variables[175] == 1
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column*64 , 64*12, 64, 64)
      end
      #トランクスタンクトップ長髪(剣無し)
      if game_switches[0] == 0 && row == 14 && $game_variables[173] == 3 || row == 14 && game_variables[173] == 3
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column*64 , 64*16, 64, 64)
      end
      
      #トランクス(超)タンクトップ長髪(剣無し)
      if game_switches[0] == 0 && row == 17 && $game_variables[173] == 3 || row == 17 && game_variables[173] == 3
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column*64 , 64*17, 64, 64)
      end
      #トランクス私服剣あり長髪ならば
      if game_switches[0] == 0 && row == 14 && $game_variables[173] == 4 || row == 14 && game_variables[173] == 4
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column*64 , 64*18, 64, 64)
      end
      
      #トランクス(超)私服剣あり長髪ならば
      if game_switches[0] == 0 && row == 17 && $game_variables[173] == 4 || row == 17 && game_variables[173] == 4
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column*64 , 64*19, 64, 64)
      end
      
      #トランクスと長髪バトルスーツならば
      if game_switches[0] == 0 && row == 14 && $game_variables[173] == 1 || row == 14 && game_variables[173] == 1
        pic = "Z3_顔味方_トランクス長髪"
        rect = Rect.new(column*64 , 64*1, 64, 64)
      end
      
      #トランクス(超)とバトルスーツならば
      if game_switches[0] == 0 && row == 17 && $game_variables[173] == 1 || row == 17 && game_variables[173] == 1
        pic = "ZG_顔味方"
        rect = Rect.new(column*64 , 64*row, 64, 64)
      end
      
      #トランクスとタンクトップならば
      if game_switches[0] == 0 && row == 14 && $game_variables[173] == 2 || row == 14 && game_variables[173] == 2
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column*64 , 64*13, 64, 64)
      end
      #トランクス(超)とタンクトップならば
      if game_switches[0] == 0 && row == 17 && $game_variables[173] == 2 || row == 17 && game_variables[173] == 2
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column*64 , 64*14, 64, 64)
      end
      
      #18号着せ替え
      if game_switches[0] == 0 && row == 18 && $game_variables[177] == 1 || row == 18 && game_variables[177] == 1
        pic = "Z3_顔味方_衣替え"
        rect = Rect.new(column *64, 64*20, 64, 64)
      end
      
      #Z2亀仙人普段着
      if game_switches[0] == 0 && row == 21 && $game_switches[363] == true ||  row == 21 && game_switches[363] == true
        pic = "Z3_顔味方_亀仙人"
        rect = Rect.new(column *64, 64*2, 64, 64)
      end
      
      #Z2トーマ(大猿)
      if game_switches[0] == 0 && row == 24 && $oozaru_flag[1] == true ||  row == 24 && oozaru_flag[1] == true
        pic = "Z1_顔大猿"
        rect = Rect.new(column *64, 64*5, 64, 64)
      end
      
      #Z2セリパ(大猿)
      if game_switches[0] == 0 && row == 25 && $oozaru_flag[2] == true ||  row == 25 && oozaru_flag[2] == true
        pic = "Z1_顔大猿"
        rect = Rect.new(column *64, 64*6, 64, 64)
      end
      
      #Z2トテッポ(大猿)
      if game_switches[0] == 0 && row == 26 && $oozaru_flag[3] == true ||  row == 26 && oozaru_flag[3] == true
        pic = "Z1_顔大猿"
        rect = Rect.new(column *64, 64*7, 64, 64)
      end
      
      #Z2パンブーキン(大猿)
      if game_switches[0] == 0 && row == 27 && $oozaru_flag[4] == true ||  row == 27 && oozaru_flag[4] == true
        pic = "Z1_顔大猿"
        rect = Rect.new(column *64, 64*8, 64, 64)
      end
      
      #Z3サタン
      if game_switches[0] == 0 && row == 28 || row == 28
        #p $game_switches[2311],$game_variables[911]
        #マップイベント中
        if $game_switches[2311] == true
          pic = "Z3_顔味方_サタン表情パターン"
          rect = Rect.new(0 *64, 64*$game_variables[911], 64, 64)
        end
      end
    end
    #キャッシュで渡すか文字列で渡すか
    if pic_mode == 0
      picture = Cache.picture(pic)
    else
      picture = pic
    end
    return rect,picture
  end
  #--------------------------------------------------------------------------
  # ● キャラクター衣替えの設定
  #-------------------------------------------------------------------------- 
  def set_dress add = 1,chano = 0,dressno = nil
    
    onse= false
    #p $Z1chadressNo[$partyc[@@cursorstate]-3],$Z2chadressNo[$partyc[@@cursorstate]-3],$Z3chadressNo[$partyc[@@cursorstate]-3],$ZGchadressNo[$partyc[@@cursorstate]-3]
    
    if $game_switches[360] == false
      if $game_variables[40] == 0
        #亀仙人
        if chano == 24
          onse = true
          if $game_switches[363] == false #普段着
            $game_switches[363] = true
          else
            $game_switches[363] = false
          end
        end
      elsif $game_variables[40] == 1

          #悟飯
          if chano == 5
              varino = 161
              if $game_switches[439] == true
                onse = true
                if $game_variables[varino] == 0
                  $game_variables[varino] = 1
                else
                  $game_variables[varino] = 0
                end
              end
          #クリリン    
          elsif chano == 6
            varino = 162
            if $game_switches[439] == true
              onse = true
              
              if $game_variables[varino] == 0
                $game_variables[varino] = 1
              else
                $game_variables[varino] = 0
              end
            end
          #亀仙人
          elsif chano == 24
            onse = true
            if $game_switches[363] == false #普段着
              $game_switches[363] = true
            else
              $game_switches[363] = false
            end
          else

          end
      elsif $game_variables[40] == 2
          #悟空
          if chano == 3 || chano == 14
            varino = 171
            
            onse = true
            $game_variables[varino] += add
            
            $game_variables[varino] = 0 if $game_variables[varino] == 4
            $game_variables[varino] = 3 if $game_variables[varino] == -1
            
            if $game_variables[varino] == 1
              #ぼろぼろ
              if $game_switches[381] == false
                $game_variables[varino] += add
              end
            end
            
            if $game_variables[varino] == 2
              #さらにぼろぼろ
              if $game_switches[381] == false
                $game_variables[varino] += add
              end
            end
            
            if $game_variables[varino] == 3
              #バトルスーツ
              if $game_switches[444] == false
                $game_variables[varino] += add
              end
            end
            
             $game_variables[varino] = 0 if $game_variables[varino] == 4
             $game_variables[varino] = 3 if $game_variables[varino] == -1           
          #悟飯
          elsif chano == 5 && $game_switches[445] == false || chano == 5 && $game_switches[445] == true && $game_switches[447] == true || chano == 18 && $game_switches[445] == true && $game_switches[447] == true
            #長髪の時のみバトルスーツ可
            varino = 172
            
            if $game_switches[445] == false #長髪状態
              if $game_switches[443] == true #バトルスーツ
                onse = true
                
                if $game_variables[varino] == 0
                  $game_variables[varino] = 1
                else
                  $game_variables[varino] = 0
                end
              end
            else
              if $game_switches[447] == true #赤道着
                onse = true
                
                if $game_variables[varino] == 0
                  $game_variables[varino] = 2
                else
                  $game_variables[varino] = 0
                end
              end
            end
            
          #バーダック
          elsif chano == 16 || chano == 32
            onse = true
            varino = 175
            dresmax = 0
            if $game_switches[594] == true #スカウターなし
              dresmax = 1
            end            
            
            $game_variables[varino] += add
            if $game_variables[varino] == (dresmax + 1)
              $game_variables[varino] = 0
            elsif $game_variables[varino] == -1
              $game_variables[varino] = dresmax
            end
          #トランクス
          elsif chano == 17 || chano == 20
            onse = true
            varino = 173
            dresmax = 0
            if $game_switches[110] == true #精神と時の部屋修行完了(バトルスーツ)
              dresmax = 1
            end
            if $game_switches[570] == true #絶望への反抗(タンクトップ)
              dresmax = 2
            end
            if $game_switches[580] == true #ブロリー撃破(私服、長髪刀なし)
              dresmax = 3
            end
            if $game_switches[581] == true || #ボージャック撃破(私服、長髪刀あり)
              $game_switches[860] == true #またはクリアした場合
              dresmax = 4
            end
            
            
            $game_variables[varino] += add
            if $game_variables[varino] == (dresmax + 1)
              $game_variables[varino] = 0
            elsif $game_variables[varino] == -1
              $game_variables[varino] = dresmax
            end
            
            case $game_variables[173]
            
              when 0 #短髪私服            
                run_common_event 211 #トランクスの服フラグ変更(私服)
              when 1 #バトルスーツ
                run_common_event 212 #トランクスの服フラグ変更(バトルスーツ)      
              when 2 #タンクトップ
                run_common_event 213 #トランクスの服フラグ変更(タンクトップ)
              when 3 #長髪私服
                run_common_event 214 #トランクスの服フラグ変更(長髪私服刀なし)
              when 4 #長髪私服
                run_common_event 215 #トランクスの服フラグ変更(長髪私服刀あり)
              end
              
              run_common_event 61 #トランクスの技を再設定
          #18号
          elsif chano == 21
            onse = true
            varino = 177
            dresmax = 1
            
            $game_variables[varino] += add
            if $game_variables[varino] == (dresmax + 1)
              $game_variables[varino] = 0
            elsif $game_variables[varino] == -1
              $game_variables[varino] = dresmax
            end
          #亀仙人
          elsif chano == 24
            onse = true
            if $game_switches[363] == false #普段着
              $game_switches[363] = true
            else
              $game_switches[363] = false
            end
          end
          
          #作戦の必殺技の有無確認
          set_tactec_learn chano,$cha_tactics[7][chano],$game_actors[chano].skills[0].id
          
      else
        
      end

      $game_variables[varino] = dressno if dressno != nil

      if onse == true && dressno == nil
        Audio.se_play("Audio/SE/" + $BGM_CursorOn) # 効果音を再生する
      end
      #p $Z1chadressNo[$partyc[@@cursorstate]-3],$Z2chadressNo[$partyc[@@cursorstate]-3],$Z3chadressNo[$partyc[@@cursorstate]-3],$ZGchadressNo[$partyc[@@cursorstate]-3]
      set_map_cha
    end
  end
  #--------------------------------------------------------------------------
  # ● 任意のコモンイベントの実行
  # 引数:event_no(実行するコモンイベントの番号)
  #--------------------------------------------------------------------------
  def run_common_event(event_no)

    #$game_temp.reserve_common_event(event_no)

    common_event = $data_common_events[event_no]
    if common_event != nil
      @child_interpreter = Game_Interpreter.new(0)
      #@child_interpreter.setup(common_event.list, @event_id)
      @child_interpreter.setup(common_event.list, event_no)
      #p event_no,@depth
      while @child_interpreter.running?
        @child_interpreter.update
      end
    end

  end
    
  #--------------------------------------------------------------------------
  # ● マップ表示歩行飛行キャラ管理用
  #--------------------------------------------------------------------------
  def set_map_cha
    
    #Z1
    if $game_variables[40] == 0 
    
    #Z2
    elsif $game_variables[40] == 1  
      
      #悟飯バトルスーツ
      if $game_variables[161] == 1 && $game_variables[42] == 5
        $game_switches[361] = true
      else
        $game_switches[361] = false
      end
      
      #クリリンバトルスーツ
      if $game_variables[162] == 1 && $game_variables[42] == 6
        $game_switches[362] = true
      else
        $game_switches[362] = false
      end
    
    #Z3  
    elsif $game_variables[40] == 2
      #悟空バトルスーツ
      if $game_variables[171] == 3 && $game_variables[42] == 3 || $game_variables[171] == 3 && $game_variables[42] == 14 
        $game_switches[382] = true
      else
        $game_switches[382] = false
      end
      
      #悟飯バトルスーツ
      if $game_variables[172] == 1 && $game_variables[42] == 5 #|| $game_variables[172] == 1 && $game_variables[42] == 18 
        $game_switches[386] = true
      else
        $game_switches[386] = false
      end
    else
      
    end
  end
  #--------------------------------------------------------------------------
  # ● シナリオ進行度チェック
  #--------------------------------------------------------------------------
  def chk_scenario_progress chkprogress=nil,mode=0

    if mode == 0
      if chkprogress == nil
        #シナリオ進行度によってファイル名の頭文字を変える
        if $game_variables[40] == 0
          $top_file_name = "Z1_"
          $max_battle_bgm = 11 #戦闘BGM数
          $max_menu_bgm = 5 #メニューBGM数
        elsif $game_variables[40] == 1
          $top_file_name = "Z2_"
          $max_battle_bgm = 13
          $max_menu_bgm = 6
        elsif $game_variables[40] == 2
          $top_file_name = "Z3_"
          $max_battle_bgm = 16
          $max_menu_bgm = 7
          if $game_switches[598] == true #ZGバーダック一味編フリーザ倒した
            $max_menu_bgm = 8
          end
        elsif $game_variables[40] == 3
          $top_file_name = "ZG_"
          $max_battle_bgm = 22
          $max_menu_bgm = 8
        end
        
        #2021 5/9 不要な気がするのでコメントアウト
        #if $game_switches[585] == true #エピソードオブバーダッククリアしたら
        #  $max_battle_bgm = 16
        #  $max_menu_bgm = 7
        #end
        #クリア済みであれば データックも有効にする
        if $game_switches[860] == true
          $max_battle_bgm = 22
          $max_menu_bgm = 8
        end
      else
        if chkprogress == 0
          $top_file_name = "Z1_"
          $max_battle_bgm = 11 #戦闘BGM数
          $max_menu_bgm = 5 #メニューBGM数
        elsif chkprogress == 1
          $top_file_name = "Z2_"
          $max_battle_bgm = 13
          $max_menu_bgm = 6
        elsif chkprogress == 2
          $top_file_name = "Z3_"
          $max_battle_bgm = 16
          $max_menu_bgm = 7
        elsif chkprogress == 3
          $top_file_name = "ZG_"
          $max_battle_bgm = 22
          $max_menu_bgm = 8
        end
      end
      
      #クリア済みであれば データックも有効にする
      if $game_switches[860] == true
        $max_battle_bgm = 22
        $max_menu_bgm = 8
      end
    end
    
    if mode == 1
      case chkprogress
      
      when 0
        $skin_kanri = "Z1_"
      when 1
        $skin_kanri = "Z2_"
      when 2
        $skin_kanri = "Z3_"
      when 3
        $skin_kanri = "ZG_"
      when 4
        $skin_kanri = "ZSSD_"
      when 5
        $skin_kanri = "DB2_"
      when 6,7
        $skin_kanri = "DB3_"
      else
        $skin_kanri = "Z1_"
      end
    end
    
    if mode == 2 #戦闘用画像よう
      case chkprogress
      
      when 0
        $btl_top_file_name = "Z1_"
        
      when 1
        $btl_top_file_name = "Z2_"
      when 2
        $btl_top_file_name = "Z3_"
      when 3
        $btl_top_file_name = "ZG_"
      when 4
        #$skin_kanri = "ZD_"
        $btl_top_file_name = "ZSSD_"
      else
        $btl_top_file_name = "Z1_"
      end
    end
    
    if mode == 3 #戦闘背景用画像

      case chkprogress
      
      when 0
        $btl_map_top_file_name = "Z1_"
        
      when 1
        $btl_map_top_file_name = "Z2_"
      when 2
        $btl_map_top_file_name = "Z3_"
      when 3
        $btl_map_top_file_name = "ZG_"
      when 4
        #$skin_kanri = "ZD_"
        $btl_map_top_file_name = "ZSSD_"
      else
        $btl_map_top_file_name = "Z1_"
      end
    end
    $max_btl_end_bgm = 13 
  end
  #--------------------------------------------------------------------------
  # ● 同じスキルがないかチェック cha_no:キャラナンバー skill_no:スキルナンバー add_no:追加スキルの設定位置 9の場合は全チェック
  #-------------------------------------------------------------------------- 
  def chk_same_skill cha_no,skill_no,add_no=9
    #p cha_no,skill_no,add_no
    result = false
    $same_skill_type = 0 #固有スキル:1 フリースキル2
    $same_skill_no = 0 #単純に上から何番目か 1番目なら0
    #固定スキル

    $same_skill_type = 1
    for x in 0..$cha_typical_skill[cha_no].size-1
      $same_skill_no = x
      if $cha_typical_skill[cha_no][x] == skill_no
        result = true
        
        break
      end
      
      #同一効果のスキルが配列かどうかチェックする
      #p $cha_typical_skill[cha_no][x],$cha_skill_same_no[$cha_typical_skill[cha_no][x]],$cha_skill_same_no[$cha_typical_skill[cha_no][x]].instance_of?(Array)
      if $cha_skill_same_no[$cha_typical_skill[cha_no][x]].instance_of?(Array) == false
        
        if $cha_skill_same_no[$cha_typical_skill[cha_no][x]] == skill_no && $cha_skill_same_no[$cha_typical_skill[cha_no][x]] != 0
          result = true
          break
        end
      else
        
        #p $cha_typical_skill[cha_no][x],$cha_skill_same_no[$cha_typical_skill[cha_no][x]]
        for y in 0..$cha_skill_same_no[$cha_typical_skill[cha_no][x]].size-1
          
          #p $cha_skill_same_no[$cha_typical_skill[cha_no][x]],$cha_skill_same_no[$cha_typical_skill[cha_no][x]][y]
          if $cha_skill_same_no[$cha_typical_skill[cha_no][x]][y] == skill_no
            result = true
            break
          end
        end
      end
      
      #同じのを見つけたら抜ける
      return result if result == true
    end
    
    #同じのを見つけたら抜ける
    return result if result == true
    #追加スキル
    
    add_loop_s = 0
    add_loop_e = 0

    if add_no == 9
      add_loop_s = 0
      add_loop_e = $cha_add_skill[cha_no].size-1
    elsif add_no == 1
      add_loop_s = 1
      add_loop_e = $cha_add_skill[cha_no].size-1
    elsif add_no == 2
      add_loop_s = 0
      add_loop_e = $cha_add_skill[cha_no].size-1
    elsif add_no == 3
      add_loop_s = 0
      add_loop_e = 1
    end
    
    $same_skill_type = 2
    for x in add_loop_s..add_loop_e
      $same_skill_no = x
      #真ん中のスキルの対策(処理を飛ばす)
      x += 1 if x == 1 && add_no == 2 
      if $cha_add_skill[cha_no][x] == skill_no
        result = true
        break
      end
      
      #同一効果のスキルが配列かどうかチェックする
      if $cha_skill_same_no[$cha_add_skill[cha_no][x]].instance_of?(Array) == false
        
        if $cha_skill_same_no[$cha_add_skill[cha_no][x]] == skill_no && $cha_skill_same_no[$cha_typical_skill[cha_no][x]] != 0
          result = true
          break
        end
      else
        #p skill_no,$cha_skill_same_no[$cha_add_skill[cha_no][x]]
        for y in 0..$cha_skill_same_no[$cha_add_skill[cha_no][x]].size-1
          #p skill_no,$cha_skill_same_no[$cha_add_skill[cha_no][x]],$cha_skill_same_no[$cha_add_skill[cha_no][x]][y]
          if $cha_skill_same_no[$cha_add_skill[cha_no][x]][y] == skill_no
            result = true
            break
          end
        end
      end
        
      #同じのを見つけたら抜ける
      return result if result == true
    end
    
    #p result,$same_skill_type,$same_skill_no
    #同じのがなければ初期化(同一のがあってもここに処理がはいるので初期化はコメントアウト)
    #$same_skill_type = 0 #固有スキル:1 フリースキル2
    #$same_skill_no = 0 #単純に上から何番目か 1番目なら0
    return result
  end
  #--------------------------------------------------------------------------
  # ● 敵キャラスタートNo
  #--------------------------------------------------------------------------
  def set_ene_str_no chkno
    if chkno < $ene_str_no[1]
      return "Z1_"
    elsif chkno < $ene_str_no[2]
      return "Z2_"
    else
      return "Z3_"
    #else
    #  return "ZG_"
    end
  end
  #--------------------------------------------------------------------------
  # ● 画像シェイク計算 #shake_dot シェイクの強さ
  #--------------------------------------------------------------------------
  def pic_shake_cal shake_dot
    shake_houkou = rand(9)+1
    shake_x = 0
    shake_y = 0
    
    case shake_houkou
      
    when 1 #左下
      shake_x = -shake_dot
      shake_y = shake_dot
      
    when 2 #下
      shake_x = 0
      shake_y = shake_dot 
    
    when 3 #右下
      shake_x = shake_dot
      shake_y = shake_dot 
      
    when 4 #左
      shake_x = -shake_dot
      shake_y = 0 
      
    when 5 #中央
      shake_x = 0
      shake_y = 0 
      
    when 6 #右
      shake_x = shake_dot
      shake_y = 0 
      
    when 7 #左上
      shake_x = -shake_dot
      shake_y = -shake_dot 
      
    when 8 #上
      shake_x = 0
      shake_y = -shake_dot 
      
    when 9 #右上
      shake_x = shake_dot
      shake_y = -shake_dot 
    end
      
    return shake_x,shake_y
  end

end


  #--------------------------------------------------------------------------
  # ● 取得カードの生成
  # get_pattern:カード取得パターン
  #--------------------------------------------------------------------------
  def create_get_card get_pattern = 0
    card_id_z1 = [9,10,11,12,13,14,15,17,18,19,20,21,22,23,24,25,26,27,28,29,30,32,34,49,50,51,52,64,70,75,80,82,83,84,87,88,106,121,197]
    card_id_z2 = [16,33,40,41,53,54,79,97,110]
    card_id_z3 = [93,98,104,105,16,40,41,69,79,97,110,63,68,171]
    card_id_z4 = [17,33,46,51,52,61,104,145] #140は芭蕉扇のためはずす
    card_id_zg = [18,93,98,105,106,156]
    #ランクアップカードを外す
    
    card_id = []
    card_id.concat(card_id_z1)
    case get_pattern
    
    when 0,10 #Z1ってことかも

    when 1,20 #Z2ってことかも
      card_id.concat(card_id_z2)
    when 2,30 #Z3ってことかも
      card_id.concat(card_id_z2)
      card_id.concat(card_id_z3)
    when 3,40 #Z4ってことかも
      card_id.concat(card_id_z2)
      card_id.concat(card_id_z3)
      card_id.concat(card_id_z4)
    when 4,50 #ZGってことかも
      card_id.concat(card_id_z2)
      card_id.concat(card_id_z3)
      card_id.concat(card_id_z4)
      card_id.concat(card_id_zg)
    when 5 #ZG特殊ってことかも
      card_id.concat(card_id_z2)
      card_id.concat(card_id_z3)
      card_id.concat(card_id_z4)
      card_id.concat(card_id_zg)
    end
    result = card_id[rand(card_id.size-1)]
    return result
  end
  #--------------------------------------------------------------------------
  # ● スキルの取得状態を調整する
  #    過去Verのバグ対策用
  #--------------------------------------------------------------------------
  def chk_cha_get_skill_adjust
    for x in 1..$data_actors.size - 1
      chano = x
      if $cha_typical_skill[x] == nil
        #$cha_typical_skill[x] = [nil]
        $cha_typical_skill[x] = [0]
      end
      
      for y in 0..$cha_typical_skill[x].size - 1
        if [nil,0].include?($cha_typical_skill[x][y]) == false
          
          skillno = $cha_typical_skill[x][y]

          chk_cha_get_skill_adjust_set chano,skillno,0
        end
      end
      
      if $cha_add_skill[x] == nil
        #$cha_add_skill[x] = [nil]
        $cha_add_skill[x] = [0]
      end
      
      for y in 0..$cha_add_skill[x].size - 1
        if [nil,0].include?($cha_add_skill[x][y]) == false
          skillno = $cha_add_skill[x][y]
          chk_cha_get_skill_adjust_set chano,skillno,1
        end
      end

    end
  end
  
  #--------------------------------------------------------------------------
  # ● 進行状態を見てスキル名を変更する
  #    後から仲間になる分を隠す対策
  #--------------------------------------------------------------------------
  def skill_name_chg
    
    #ダブル魔観光殺法(ピッコロ＆若者)
    if $game_switches[569] == false #未来悟飯のイベント実行済み
      $data_skills[760].description = $data_skills[760].description.sub('(ピ＆わ)', '')
    end
    
    #ダブル魔閃光(悟飯＆トランクス)
    if $game_switches[569] == false #未来悟飯のイベント実行済み
      $data_skills[726].description = $data_skills[726].description.sub('(ゴ＆ト)', '')
    end
    
    #師弟アタック(悟飯＆ピッコロ)
    if $game_switches[569] == false #未来悟飯のイベント実行済み
      $data_skills[701].description = $data_skills[701].description.sub('(ゴ＆ピ)', '')
    end
    
  end
    
  #--------------------------------------------------------------------------
  # ● スキルの取得状態を調整する
  #    過去Verのバグ対策用
  #    skilltype:0固有,1追加
  #--------------------------------------------------------------------------
  def chk_cha_get_skill_adjust_set chano,skillno,skilltype
    
    
    if skilltype == 1 #追加スキル
      if $cha_skill_spval[chano][skillno] < $cha_skill_get_val[skillno]
        #取得フラグ解除
        $cha_skill_get_flag[chano][skillno] = 0
      else
        result = true
      end
      
    else #固有スキル
      result = true
    end
  
    if result == true 
      $cha_skill_set_flag[chano][skillno] = 1
      $cha_skill_get_flag[chano][skillno] = 1
      $cha_skill_spval[chano][skillno] = $cha_skill_get_val[skillno]
      $skill_set_get_num[0][skillno] = 1
      $skill_set_get_num[1][skillno] = 1
    end
  end

  #--------------------------------------------------------------------------
  # ● カード生成時の流派選択 
  #     n：味方か敵か 0:味方,1:敵
  #     not_tec：必殺カードを生成しない     false：生成する true：生成しない
  #     i_num：  流派のNo
  #     not_cre_num: 作成しない流派を追加
  #--------------------------------------------------------------------------
  def create_card_i n=0,not_tec=false,i_num = 0,not_cre_num = nil

    begin
    result = true
    cardi = rand($cardi_max)
      if n == 0
        if $game_variables[40] == 0
          case $game_variables[43]
          
          when 101 #バーダック編
            noncardi = [2,3,6,7,8,9,10]
            
          when 51..80
            noncardi = [2,3]
            #if cardi == 2 || cardi == 3
            #  result = false
            #end
          else
            noncardi = [5,6,7,8,9,10]
            noncardi << 2 if $game_variables[43] >= 11
            noncardi << 3 if $game_variables[43] <= 10
            #if cardi == 5 || $game_variables[43] >= 11 && cardi == 2 || $game_variables[43] <= 10 && cardi == 3
            #  result = false
            #end
          end
        elsif $game_variables[40] == 1
          noncardi = [2,6,7]
          noncardi << 3 if $super_saiyazin_flag[1] == true
          #if cardi == 2 || cardi == 6 || cardi == 7 || $super_saiyazin_flag[1] == true && cardi == 3
          #  result = false
          #end
          
          case $game_variables[43]
          
          when 41 #Z2たった一人の最終決戦
            noncardi << 1 #亀
            noncardi << 3 #界
            noncardi << 4 #魔
            noncardi << 8 #超
            noncardi << 9 #造
          when 143..149 #ZGバーダック一味編
            noncardi << 1 #亀
            noncardi << 3 #界
            noncardi << 4 #魔
            noncardi << 8 #超
            noncardi << 9 #造
          end
          
        elsif $game_variables[40] >= 2
          noncardi = [2,6,7,9]
          
          for x in 0..$partyc.size-1
            if $game_actors[$partyc[x]].class_id-1 == 9
              #p $partyc[x]
              noncardi = [2,6,7] #人造人間が居たら
            end
          end

          if $game_variables[43] == 81 #Z4Dr.ゲロの研究所
            noncardi << 3 #界
            noncardi << 4 #魔
            if $super_saiyazin_flag[4] == true
              noncardi << 5 #惑
            end
          end
          
          if $game_variables[43] == 83 #ピッコロ対セル(テンシンハン向かう)
            noncardi << 3 #界
            noncardi << 5 #惑
          end
          
          if $game_variables[43] == 85 #Z4セル第二形態
            noncardi << 3 #界
            noncardi << 4 #魔
            #ベジータとトランクスの両方が超サイヤ人だったら
            if $super_saiyazin_flag[3] == true && $super_saiyazin_flag[4] == true
              noncardi << 5 #惑
            end
          end
          
          case $game_variables[43]
          when 143..149 #ZGバーダック一味編
            noncardi << 1 #亀
            noncardi << 3 #界
            noncardi << 4 #魔
            #noncardi << 8 #超
            noncardi << 9 #造
          end
          
          if $game_variables[43] == 92 || $game_variables[43] == 93 || $game_variables[43] == 95 || $game_variables[43] == 96 || #Z413号編 セルゲーム
            $game_variables[43] == 121 || $game_variables[43] == 126 || $game_variables[43] == 127 || $game_variables[43] == 128
            noncardi << 3 if $partyc.index(3) == nil #悟空が居ない場合は、界カードを出さない
            #ベジータとトランクスの両方が超サイヤ人だったら
            if $super_saiyazin_flag[3] == true && $super_saiyazin_flag[4] == true
              noncardi << 5 #惑
            end
          end
          #悟空がスーパーサイヤ人ならば界はなし
          noncardi << 3 if $super_saiyazin_flag[1] == true
          #スーパーサイヤ人が1人もいなければ超はなし
          
          noncardi << 8 if $super_saiyazin_flag.index(true) == nil

          if $partyc.size == 1 #1人のみ
            #必、自分の流派、もう一つ　1/3の確立にする
            noncardi = [2,6,7]
            
            #天津飯たちがセルのもとについた
            if $game_switches[435] == false
              noncardi << 9 #造
            end
            for x in 1..$cardi_max
              if $game_actors[$partyc[0]].class_id-1 != x
                noncardi << x
              end
            end
            noncardi.delete_at(rand(noncardi.size-1-2)+2)
          end
        end

        #光の旅で強制的に自分の流派のカードにする
        for x in 0..$partyc.size - 1
          #
          if $cardset_cha_no.index(x) != nil
            chkchano = $partyc[x]
            if $cha_hikari_turn[chkchano] != nil && $cha_hikari_turn[chkchano] > 0
              
              #光の旅ゲージ表示
              hikaritrun = 0 #0なら取得していないという判定で
              meterdot = 0 #メーターの増加量
                    
              hikaritrun,meterdot = chk_hikarinotabirun(chkchano)
              
              #指定のターン戦闘に参加してたら流派一致する
              if hikaritrun <= $cha_hikari_turn[chkchano]
                cardi = $game_actors[chkchano].class_id-1
                #p x,noncardi
                $cha_hikari_turn[chkchano] = 0
                break
              end
            end
          end
          
        end
=begin
        #自分の使ったカードの流派を変更
        if $cardset_cha_no[$create_card_num] != nil && $cardset_cha_no[$create_card_num] != 99
          chkchano = $partyc[$cardset_cha_no[$create_card_num]]
          #p chkchano
          if $cha_hikari_turn[chkchano] != nil && $cha_hikari_turn[chkchano] > 0
            
            #光の旅ゲージ表示
            hikaritrun = 0 #0なら取得していないという判定で
            meterdot = 0 #メーターの増加量
                  
            hikaritrun,meterdot = chk_hikarinotabirun(chkchano)
            
            #指定のターン戦闘に参加してたら流派一致する
            if hikaritrun <= $cha_hikari_turn[chkchano]
              cardi = $game_actors[chkchano].class_id-1
              #p x,noncardi
              $cha_hikari_turn[chkchano] = 0
            end
          end

        end
=end
=begin
        for x in 0..$cha_hikari_turn.size - 1
          $cha_hikari_turn[x] = 0 if $cha_hikari_turn[x] == nil
          
          #ターンが1以上が対象かつ、現在作ろうとしているカードを使った
          if $cha_hikari_turn[x] != nil && $cha_hikari_turn[x] > 0
            p $partyc[$cardset_cha_no[$create_card_num]],$cardset_cha_no[$create_card_num]
            #ループとカード使ったキャラが同じか
            if $partyc[$cardset_cha_no[$create_card_num]] == x
            
              #光の旅ゲージ表示
              hikaritrun = 0 #0なら取得していないという判定で
              meterdot = 0 #メーターの増加量
                    
              hikaritrun,meterdot = chk_hikarinotabirun(x)
              
              #指定のターン戦闘に参加してたら流派一致する
              if hikaritrun <= $cha_hikari_turn[x]
                cardi = $game_actors[x].class_id-1
                #p x,noncardi
                $cha_hikari_turn[x] = 0
                break
              end
            end
          end
        end
=end
      else #敵カード

        if $game_variables[40] == 0
          noncardi = []
          noncardi << 2 if $game_variables[43] >= 11
          noncardi << 3 if $game_variables[43] <= 10
          noncardi << 6
          #if $game_variables[43] >= 11 && cardi == 2 || $game_variables[43] <= 10 && cardi == 3
          #  result = false
          #end
        elsif $game_variables[40] == 1
          
          noncardi = [2,7]
          noncardi << 3 if $super_saiyazin_flag[1] == true
          
          #if cardi == 2 || cardi == 7 || $super_saiyazin_flag[1] == true && cardi == 3

        elsif $game_variables[40] == 2
          noncardi = [2,3,6,7]
          #noncardi << 8 if $super_saiyazin_flag[1] != true
          #noncardi << 3 if $super_saiyazin_flag[1] == true
          
          case $game_variables[43]
          when 903 #カイオウエリア
            noncardi.delete(3) #カイオウ
            noncardi << 8 #超
            noncardi << 9 #造
          when 914 #ギニューエリア
            noncardi.delete(6) #ギニュー
            noncardi << 8 #超
            noncardi << 9 #造
          when 58..96,925 #人造人間編
            
          when 151..200 #ZG
            cardi = rand(12)
            noncardi << 1 #亀
            noncardi << 5 #惑
            noncardi << 9 #造
            noncardi << 8 #超
            noncardi << 11 #術
          else
            noncardi << 9 #造
          end
          #if cardi == 2 || cardi == 6 || cardi == 7 || $super_saiyazin_flag[1] == true && cardi == 3
          #  result = false
          #end
        end
      end

      #必殺と流派一致を生成しない
      if not_tec == true
        noncardi << 0
        noncardi << i_num
      end
      
      #作らない流派がある場合除外に追加
      if not_cre_num != nil
        noncardi << not_cre_num
      end
      
      if noncardi.index(cardi) != nil
        result = false
      end
    end while result == false

    return cardi
  end
  #--------------------------------------------------------------------------
  # ● 進行度によって敵の出力フラグを管理する
  #--------------------------------------------------------------------------
  def update_eneput_flag
    flag_result = false
    for z in 1..$data_enemies.size - 1
      #true = 出力しない
      flag_result = true
      
      #Z1,Z2,Z2 バーダック編は初期表示
      #Z2バーダック編は後で表示したかったがフラグがなかったのでとりあえず初期表示に
      if $data_enemies[z].element_ranks[34] == 1 ||
        $data_enemies[z].element_ranks[35] == 1 ||
        $data_enemies[z].element_ranks[36] == 1
        flag_result = $data_enemies[z].levitate
      end

      #Z3の敵
      if $data_enemies[z].element_ranks[37] == 1
        #フリーザ完全体と戦ったか周回プレイ中か
        if $game_switches[119] == true || $game_switches[860] == true #クリアしたのであれば出力にする
          flag_result = $data_enemies[z].levitate
        end
      end
      
      #Z4の敵
      if $data_enemies[z].element_ranks[38] == 1
        #セルと戦ったか周回プレイ中か
        if $game_switches[431] == true || $game_switches[860] == true #クリア
          flag_result = $data_enemies[z].levitate
        end
      end
      
      #Z4クリア後(ブロリー、ボージャック、チルド)
      if $data_enemies[z].element_ranks[39] == 1
        if $game_switches[570] == false || $game_switches[459] == false #セルを全員で倒した、未来トランクス編クリア
          flag_result = true
          flag_result = false if $game_switches[860] == true #クリアしたのであれば出力にする
        else
          flag_result = false
        end
      end
      
      #ZG本編、ZGバーダック一味編
      if $data_enemies[z].element_ranks[40] == 1 || $data_enemies[z].element_ranks[41] == 1
        if $game_switches[599] == false && $game_switches[850] == false && $game_switches[586] == false #Z外伝始めてない(最初のザコ倒した) かつ クリアしていない かつ 途中でもない
          flag_result = true
          flag_result = false if $game_switches[860] == true #クリアしたのであれば出力にする
        else
          flag_result = false
        end
      end
      
      #ZG本編オゾット
      if $data_enemies[z].element_ranks[42] == 1 || $data_enemies[z].element_ranks[43] == 1
        if $game_switches[586] == false  #Z外伝クリアした
          flag_result = true
          flag_result = false if $game_switches[860] == true #クリアしたのであれば出力にする
        else
          flag_result = false
        end
      end
      
      #ZG本編アラレとかの隠し
      if $data_enemies[z].element_ranks[44] == 1
        if $game_switches[586] == false #Z外伝クリアした
          flag_result = true
          flag_result = false if $game_switches[860] == true #クリアしたのであれば出力にする
        else
          flag_result = false
        end
      end
      
      #周回プレイ用ボス
      #撃破した敵の分だけ表示したいので個別処理にする
      if $data_enemies[z].element_ranks[51] == 1
        if $game_switches[860] == false #Z周回プレイ中
          flag_result = true
        else
          flag_result = true
          
          case $data_enemies[z].id
          
          when 256 #覚醒ガーリック
            flag_result = false if $btl_arena_fight_rank[69] == true
          when 257 #覚醒ウィロー
            flag_result = false if $btl_arena_fight_rank[70] == true
          when 258 #覚醒ターレス
            flag_result = false if $btl_arena_fight_rank[71] == true
          when 259 #覚醒スラッグ
            flag_result = false if $btl_arena_fight_rank[72] == true
          when 260 #覚醒フリーザ
            flag_result = false if $btl_arena_fight_rank[73] == true
          when 261 #覚醒クウラ
            flag_result = false if $btl_arena_fight_rank[74] == true
          when 262 #覚醒20号
            flag_result = false if $btl_arena_fight_rank[75] == true
          when 263 #覚醒19号
            flag_result = false if $btl_arena_fight_rank[75] == true
          when 264 #覚醒セル1
            flag_result = false if $btl_arena_fight_rank[76] == true
          when 268 #覚醒セル2
            flag_result = false if $btl_arena_fight_rank[77] == true
          when 266 #覚醒メタルクウラコア
            flag_result = false if $btl_arena_fight_rank[78] == true
          when 267 #覚醒13号
            flag_result = false if $btl_arena_fight_rank[79] == true
          when 269 #覚醒セルパーフェクト
            flag_result = false if $btl_arena_fight_rank[80] == true
          when 270 #覚醒ブロリー
            flag_result = false if $btl_arena_fight_rank[81] == true
          when 271 #覚醒ボージャック
            flag_result = false if $btl_arena_fight_rank[82] == true
          when 272 #覚醒チルド
            flag_result = false if $btl_arena_fight_rank[83] == true
          when 273 #覚醒ゴーストライチー
            flag_result = false if $btl_arena_fight_rank[84] == true
          when 274 #覚醒ハッチヒャック
            flag_result = false if $btl_arena_fight_rank[85] == true
          when 276 #覚醒オゾット変身
            flag_result = false if $btl_arena_fight_rank[86] == true
          when 277 #覚醒パイクーハン
            flag_result = false if $btl_arena_fight_rank[87] == true
          when 278 #覚醒ブウ
            flag_result = false if $btl_arena_fight_rank[88] == true
          when 279 #覚醒フルパワーフリーザ
            flag_result = false if $btl_arena_fight_rank[89] == true
          when 280 #覚醒スーパーベジータ
            flag_result = false if $btl_arena_fight_rank[90] == true
          end
        end
      end      
      
      #p $data_enemies[z].levitate
      $data_enemies[z].levitate = flag_result
      #p $data_enemies[z].levitate
    end
  end
  #--------------------------------------------------------------------------
  # ● 敵の図鑑用リスト
  #--------------------------------------------------------------------------
  def get_ene_history_list
    #変数初期化
    $tmp_ene_order = []
    for z in 1..$data_enemies.size - 1
      if $data_enemies[z].name != "" && $data_enemies[z].levitate == false
        $tmp_ene_order[$data_enemies[z].spi] = z
      end
      #$tmp_ene_order_layer[z] = true if $data_enemies[z].has_critical == true
    end
    $tmp_ene_order = $tmp_ene_order.compact
    $ene_order_count = $tmp_ene_order.size
    for z in 1..$data_enemies.size - 1
      $ene_defeat_num[z] = 0 if $ene_defeat_num[z] == nil
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 敵の一定確率で流派一致処理
  #--------------------------------------------------------------------------
  def ryuhakakuritu_keisan narabi,enenum
    ryuhakakuritu = 0
    #流派でも必でもない
    #p narabi,enenum
    if $data_enemies[enenum].hit-1 != $enecardi[narabi] && 0 != $enecardi[narabi] 
      if $data_enemies[enenum].element_ranks[45] == 1 #100
        ryuhakakuritu = 100
      elsif $data_enemies[enenum].element_ranks[46] == 1 #75
        ryuhakakuritu = 75
      elsif $data_enemies[enenum].element_ranks[47] == 1 #50
        ryuhakakuritu = 50
      elsif $data_enemies[enenum].element_ranks[48] == 1 #25
        ryuhakakuritu = 25
      else
        
      end
      
      if ryuhakakuritu != 0 #いずれかの一致の属性を持っていたら実行
        if ryuhakakuritu >= rand(100) + 1
          #流派一致させる
          if (rand(2) + 1) == 1  #流派か必か
            $enecardi[narabi] = $data_enemies[enenum].hit-1 #流派
          else
            $enecardi[narabi] = 0 #必
          end
        end
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 敵の追加パラメータ取得
  #--------------------------------------------------------------------------
  def get_add_ene_pra
    for x in 1..$data_enemies.size-1
      #毎ターンHPリカバー率
      if $data_enemies[x].note.match(/\*PARAM_HPRECOVER\[(\d+)([%])?\]/i)
        $ene_add_para_hprecover[x] = $1.to_i
      else
        $ene_add_para_hprecover[x] = 0
      end
      
      #if $ene_add_para_hprecover[x] != 0
      #  p (($ene_add_para_hprecover[x].to_f / 100) * 200.to_f).to_i,$ene_add_para_hprecover[x]
      #end
    end
  end
  #--------------------------------------------------------------------------
  # ● リングアナのCAP増加量をシナリオ進行度で変更
  #--------------------------------------------------------------------------
  def set_ringana_card_kouka
    
    #リングアナのCAP増加量をシナリオ進行度で変更
    case $game_variables[40]
    
    when 0 #ベジータ編
      $game_variables[384] = 30
    when 1 #フリーザ編
      $game_variables[384] = 40
    when 2 #Z3以降
      
      #セルを倒すまで(Z3
      if $game_switches[431] == false
        $game_variables[384] = 50
      else
        #Z4以降
        $game_variables[384] = 60
      end
    else
      $game_variables[384] = 30
    end
  end
  
  #--------------------------------------------------------------------------
  # ● 味方の最終レベル取得
  #--------------------------------------------------------------------------
  def set_actor_final_level
    
    if $game_switches[860] == true
      
      #$game_laps = 11
      
      #最終的に足すレベル
      puls_final_level = 0
      
      #周回数で1～9までは100で、10以降は1000にする。
      
      if $game_laps <= 9
        puls1st_level = $game_laps
      else
        puls1st_level = 9
      end
      puls_final_level += puls1st_level * 100
      
      #p puls_final_level,puls1st_level,$game_laps
      
      #10周以上は1周で1000
      
      if $game_laps > 9
        puls_final_level += ($game_laps - 9) * 1000
      end
      
      #p puls_final_level,puls1st_level,$game_laps
      
      $actor_final_level_default += puls_final_level
      
      #レベル上限が999なので、999より大きければ999に調整する
      if $actor_final_level_default > 9999
        $actor_final_level_default = 9999
      end
    end
    #p $actor_final_level_default
  end
  #--------------------------------------------------------------------------
  # ● 味方の全必殺技の熟練度増加(全て固定値)
  # chano:指定キャラNo addnum:追加回数
  #--------------------------------------------------------------------------
  def add_actor_all_tec_level chano,addnum
      #必殺技回数追加
    for x in 0..$game_actors[chano].skills.size - 1
      
      target_tec = $game_actors[chano].skills[x].id
      #指定の必殺技がnullだったら0をセット(エラー回避)
      set_cha_tec_null_to_zero target_tec
      $cha_skill_level[target_tec] += addnum
      
      #最大値を超えたら最大値にあわせる
      $cha_skill_level[target_tec] = $cha_skill_level_max if $cha_skill_level[target_tec] > $cha_skill_level_max

    end
  end
  #--------------------------------------------------------------------------
  # ● 一部カードのランク変更(ポルンガ)
  #--------------------------------------------------------------------------
  def chg_card_rank
    #p $data_items[38].element_set
    if $game_switches[491] == true #シェンロンで願いを選択した時はポルンガカードをSランクに
      if $data_items[38].element_set.index(5) != 0 #Sランク処理が未処理なら実行
        $data_items[38].element_set << 5
      end
    end

  end
  #--------------------------------------------------------------------------
  # ● スキルを覚える
  # chano:キャラクターno skillno:スキルNo
  #--------------------------------------------------------------------------
  def get_skill chano,skillno
    
    #nilで落ちる対策
    if $cha_skill_get_flag[chano] == nil
      $cha_skill_get_flag[chano] = [0]
    end
    
    #nilで落ちる対策
    if $cha_skill_set_flag[chano] == nil
      $cha_skill_set_flag[chano] = [0]
    end

    #nilで落ちる対策
    if $cha_skill_spval[chano] == nil
      $cha_skill_spval[chano] = [0]
    end
    
    $cha_skill_get_flag[chano][skillno] = 1 #取得フラグ
    $cha_skill_set_flag[chano][skillno] = 1 #セットフラグ
    $cha_skill_spval[chano][skillno] = $cha_skill_get_val[skillno] #SPを最大値にする
  end
  #--------------------------------------------------------------------------
  # ● 引継ぎ設定をもとに各データベース、変数の再設定
  #--------------------------------------------------------------------------
  def new_game_plus_db_var_refresh
    
    run_common_event 159 #超サイヤ人状態の解除
    
    #この後の処理用にスイッチと変数をTEMPに格納
    tmp_game_switches =      Marshal.load(Marshal.dump($game_switches))
    tmp_game_variables =      Marshal.load(Marshal.dump($game_variables))
    
    #スイッチと変数を初期化
    $game_switches      = Game_Switches.new
    $game_variables     = Game_Variables.new
    $game_self_switches = Game_SelfSwitches.new
    
    #必殺技を全て忘れる(Z1で超元気玉とかを覚えたままで都合が悪いため)
    for n in 1..$MAX_ACTOR_NUM
      for i in 1..$data_skills.size
        $game_actors[n].forget_skill(i)
      end
    end
    
    $game_variables[41] = 1
    
    #周回数の追加
    if tmp_game_switches[860] == false
      $game_laps = 1
    else
      #周回数追加
      $game_laps += 1
    end
    $game_switches[860] = true #周回プレイスイッチをONに
    $game_switches[484] = true #ZP割り振り計算済みフラグ
    take_over_variables = [] #引継ぎ変数No
    take_over_switches = [] #引継ぎスイッチNo
    
    $cha_bigsize_on = [] #巨大化状態
    $oozaru_flag = [] #大猿状態
    $super_saiyazin_flag = [] #超サイヤ人状態
    $story_partyc = [] #時の間用ストーリーパーティー
    #バトルアリーナの初回報酬はあえてクリアする
    $btl_arena_first_item_get = [] #バトルアリーナ初回報酬取得フラグ
    #バーダック関連は自作変数のため、そのまま引き継げる
    
    #特殊エリア移動用
    $tmp_partyc = []
    $tmp_chadead = []
    $tmp_cb = []
    $tmp_oz_fg = []
    $tmp_sp_saiya_flag = [] #超サイヤ人状態
    $story_sp_saiya = [] #時の間用ストーリーサイヤ人フラグ
    
    #シェンロン関係
    take_over_switches.push(490) #ゴッドスカウター
    take_over_switches.push(491) #ポルンガカードをSランク
    take_over_switches.push(494) #カードの最大所持数1回目
    take_over_switches.push(495) #カードの最大所持数2回目
    take_over_switches.push(496) #ZP取得増加1回目
    take_over_switches.push(497) #ZP取得増加2回目
    take_over_switches.push(498) #ZP取得増加3回目
    take_over_switches.push(499) #ZP取得増加4回目
    take_over_switches.push(1320) #移動8マス
    
    #オプション関連
    take_over_variables.push(38) #バトルメッセージ
    take_over_variables.push(30) #バトルモード
    take_over_variables.push(29) #ダメージ表示
    take_over_variables.push(351) #発動スキル表示
    take_over_variables.push(352) #スキル表示方法
    take_over_variables.push(37) #バトルBGMNO
    take_over_variables.push(319) #戦闘前BGMNO
    take_over_variables.push(103) #戦闘終了BGMNO
    take_over_variables.push(36) #メニューBGMNO
    
    take_over_variables.push(35) #戦闘背景スクロール
    take_over_variables.push(31) #エンカウント頻度
    take_over_variables.push(28) #エンカウント音
    take_over_switches.push(461) #歩行モード
    take_over_switches.push(463) #爆発割合変化
    take_over_variables.push(83) #ウインドウカードスキン
    take_over_variables.push(302) #オープニングカット
    take_over_variables.push(303) #バトルスピード
    take_over_switches.push(482) #メッセージウェイト
    take_over_switches.push(492) #高速化使用
    take_over_variables.push(353) #敵の強さ(戦闘難易度)
    take_over_variables.push(354) #スキル一覧表示
    take_over_variables.push(355) #あらすじカット
    take_over_variables.push(356) #かなしばり表示
    take_over_switches.push(881) #メッセージ高速化
    take_over_variables.push(357) #オプションメッセージページ送り
    take_over_switches.push(882) #イベントウェイト
    take_over_switches.push(883) #イベント戦闘、Sコンボ
    take_over_variables.push(358) #Sコンボ発動優先度
    take_over_variables.push(427) #レベルアップSE
    take_over_variables.push(428) #イベント戦闘BGM
    take_over_variables.push(429) #イベント戦闘前BGM
    take_over_variables.push(462) #カード合成レシピから選択するのデフォ表示画面
    take_over_variables.push(463) #カード合成レシピから選択するで合成語に戻る画面
    take_over_variables.push(464) #CAPZP変換量
    for x in 0..$scene.option_no.size-2
      
      case $scene.option_no[x]
      
      when "op_status"  #能力
        if $scene.op_flag[x] != 1 #引き継がない場合の処理
          #能力と覚えている必殺技
          $game_actors = Game_Actors.new
          $cha_maxlv = []
          
          #初期レベル分のZP追加
          for x in 1..$MAX_ACTOR_NUM
            $zp[x] = 0 if $zp[x] == nil #nil対策
            $runzp[x] = 0 if $runzp[x] == nil #nil対策
            $zp[x] += ($game_actors[x].level - 1) * $levelup_add_zp
          end
          
          #最大レベルの取得
          set_start_val 3
          
          #使ったZP未使用状態にする
          for x in 0..$zp.size-1
            $zp[x] = 0 if $zp[x] == nil #nil対策
            $runzp[x] = 0 if $runzp[x] == nil #nil対策
            $zp[x] += $statusup_zp * $runzp[x]
            $runzp[x] = 0 #使ったZPを初期化
          end
        else
          take_over_variables.push(305) #共有経験値
          take_over_variables.push(324) #共有経験値基準レベル
          
          #最大レベルの取得
          set_start_val 3
        end
      when "op_skill"    #スキル
        if $scene.op_flag[x] != 1 #引き継がない場合の処理
          $cha_typical_skill = []     #キャラクター固有スキルセット
          $cha_add_skill = []         #キャラクター追加スキルセット
          $cha_add_skill_set_num = [] #キャラクター追加スキルセット可能数
          $cha_skill_set_flag = []    #キャラクタースキルセットしたことがあるかフラグ
          $cha_skill_get_flag = []    #キャラクタースキル取得したかフラグ
          $cha_skill_spval = []       #キャラクタースキルsp取得
          $skill_set_get_num = []     #スキルセット可能数と取得数
          $cha_set_free_skill = []    #スキルフリーを他のスキルに変えたか
        else
          take_over_variables.push(25) #CAP
        end
      #when "op_zp"          #ZP
      #  if $scene.op_flag[x] != 1 #引き継がない場合の処理
      #    $zp = []
      #    $runzp = []
      #  end
      when "op_dress"    #ドレス(衣装替え)
        if $scene.op_flag[x] != 1 #引き継がない場合の処理
          
        else #引き継ぐ場合
          take_over_switches.push(439) #Z2 悟飯、クリリンバトルスーツ 
          take_over_switches.push(381) #Z3悟空武道着ボロボロ
          take_over_switches.push(444) #Z3悟空バトルスーツ
          take_over_switches.push(443) #Z3悟飯バトルスーツ
          take_over_switches.push(447) #Z3悟飯赤道着
          take_over_switches.push(594) #バーダックスカウターなし可
          
          #トランクスは、個別フラグがないが一括管理できるので、
          #クリア済みフラグで判定するため、引継ぎなし
        end
      when "op_card"      #カード
        if $scene.op_flag[x] != 1 #引き継がない場合の処理
          #アイテムのみのはず
          $game_party = Game_Party.new
        else
          
          for x in 224..227 #カードランクS～C
            take_over_variables.push(x)
          end
          
          for x in 311..313 #ブリーフとかUP系
            take_over_variables.push(x)
          end
          take_over_variables.push(420) #移動量増加回数
        end
      when "op_tec"        #必殺技
        if $scene.op_flag[x] != 1 #引き継がない場合の処理
          
        else
          $game_switches[861] = true #必殺技引継ぎを選んだフラグ(新気功法とかイベントで覚える技用)
          take_over_switches.push(70) #悟飯大猿変身覚えた
          for x in 0..$tecspark_get_flag.size-1
            take_over_switches.push($tecspark_get_flag[x]) #ひらめき技の取得フラグ
            
            #Sコンボ有効 フラグ0:なし 1:スイッチ 2:変数
            if $tecspark_chk_flag[x] == 1 && $tecspark_chk_flag_no[x] != 0
              take_over_switches.push($tecspark_chk_flag_no[x])
            elsif $tecspark_chk_flag[x] == 2 && $tecspark_chk_flag_no[x] != 0
              take_over_variables.push($tecspark_chk_flag_no[x])
            end
          end
        end
      when "op_skill_lv" #熟練度
        if $scene.op_flag[x] != 1 #引き継がない場合の処理
          $cha_skill_level = [] #必殺技使用回数
          $cha_normal_attack_level = [] #通常攻撃使用回数
        else
          for x in 61..66 #Z1バーダック編 ピッコロ必殺技使用回数
            take_over_variables.push(x)
          end
          for x in 71..76 #Z1バーダック編 バーダック必殺技使用回数
            take_over_variables.push(x)
          end
        end
      when "op_scombo"  #Sコンボ
        if $scene.op_flag[x] != 1 #引き継がない場合の処理
        
        else
          
          #油断してやがったの超サイヤ人用フラグを通常時のフラグに変換する
          tmp_game_switches[553],tmp_game_switches[796] = tmp_game_switches[796],tmp_game_switches[553]
          #絶好のチャンス
          tmp_game_switches[1108],tmp_game_switches[1109] = tmp_game_switches[1109],tmp_game_switches[1108]
          #ダブル魔閃光(悟飯トランクス)
          tmp_game_switches[445],tmp_game_switches[512] = tmp_game_switches[512],tmp_game_switches[445]
          
          
          for x in 0..$scombo_get_flag.size-1
            take_over_switches.push($scombo_get_flag[x]) #Sコンボの取得フラグ
            
            #Sコンボ有効 フラグ0:なし 1:スイッチ 2:変数
            if $scombo_chk_flag[x] == 1 && $scombo_chk_flag_no[x] != 0
              take_over_switches.push($scombo_chk_flag_no[x])
            elsif $scombo_chk_flag[x] == 2 && $scombo_chk_flag_no[x] != 0
              take_over_variables.push($scombo_chk_flag_no[x])
            end
          end
        end
      when "op_btlhis"  #戦いの記録／バトルアリーナ
        if $scene.op_flag[x] != 1 #引き継がない場合の処理
          $cha_defeat_num = [] #撃破数
          $card_run_num = [] #カード使用回数
          $cha_attack_damege = [] #与えたダメージ
          $cha_gard_damege = [] #食らったダメージ
          $cha_attack_count = [] #与えた回数
          $cha_gard_count = [] #食らった回数
          $btl_arena_fight_rank = [] #バトルアリーナエントリー可能フラグ
          $btl_arena_fight_rank_clear_num = [] #バトルアリーナランククリア回数
        else
          take_over_variables.push(202) #戦闘勝利回数
          take_over_variables.push(204) #味方最大ダメージ味方の名前
          take_over_variables.push(214) #味方最大ダメージ敵の名前
          take_over_variables.push(203) #味方最大ダメージ値
          take_over_variables.push(208) #敵最大ダメージ敵の名前
          take_over_variables.push(216) #敵最大ダメージ味方の名前
          take_over_variables.push(207) #敵最大ダメージ値
          take_over_variables.push(211) #全獲得クレジット
          take_over_variables.push(212) #全使用クレジット
          take_over_variables.push(218) #歩数合計
          take_over_variables.push(219) #宿合計
          take_over_variables.push(220) #カード購入合計
          take_over_variables.push(221) #カード売却合計
          take_over_variables.push(222) #修行マス売却合計
          take_over_variables.push(223) #カードマス売却合計
          take_over_variables.push(213) #逃走回数
          take_over_variables.push(423) #１ターンの最高ダメージ
        end
      when "op_enehis"  #敵の情報
        if $scene.op_flag[x] != 1 #引き継がない場合の処理
          $ene_enc_history_flag = [] #敵との遭遇
          $ene_defeat_num = [] #敵撃破数
          $ene_crd_history_flag = [] #カード取得フラグ
          $ene_sco_history_flag = [] #スカウター使用フラグ
        end
      when "op_bgm"        #BGM
        if $scene.op_flag[x] != 1 #引き継がない場合の処理
          
        else
          for x in 151..200 #BGMフラグ1つめ
            take_over_switches.push(x)
          end
          
          for x in 702..740 #BGMフラグ2つめ
            take_over_switches.push(x)
          end
        end
        
      when "op_end"        #完了
        
      end
    end

    #変数の引継ぎ
    if take_over_variables.size > 0
      for x in 0..take_over_variables.size-1
        $game_variables[take_over_variables[x]] = tmp_game_variables[take_over_variables[x]]
      end
    end
    
    #スイッチの引継ぎ
    if take_over_switches.size > 0
      for x in 0..take_over_switches.size-1
        $game_switches[take_over_switches[x]] = tmp_game_switches[take_over_switches[x]]
      end
    end

  end