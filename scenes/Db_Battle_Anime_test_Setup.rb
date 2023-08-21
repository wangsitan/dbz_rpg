#==============================================================================
# ■ 色々共有して使用できるメソッド
#------------------------------------------------------------------------------
# 　IDに対応するアイコンを返すように
#==============================================================================
module Db_Battle_Anime_test_Setup
  
  #--------------------------------------------------------------------------
  # ● 戦闘テストモードにするか
  #--------------------------------------------------------------------------
  def chk_battle_test
    #$battle_test_flag = true
  end
  
  #--------------------------------------------------------------------------
  # ● 戦闘テスト初期化
  #--------------------------------------------------------------------------
  def battle_anime_test_setup
    if $battle_test_flag == true
      
      #戦闘テスト用
      #================================================================
      #$oozaru_flag = [true,true,true,true,true,true]
      #$cha_bigsize_on = [true,true,true,true,true,true]
      #$super_saiyazin_flag[1] = true #スーパーサイヤ人フラグ 1：悟空、2：悟飯、3：ベジータ、4：トランクス、5：悟飯(超2)、6：未来悟飯、7：バーダック
      #$super_saiyazin_flag[2] = true #悟飯超1
      $super_saiyazin_flag[3] = true #ベジータ
      $super_saiyazin_flag[4] = true #トランクス
      $super_saiyazin_flag[5] = true #悟飯超2
      $super_saiyazin_flag[6] = true #未来悟飯
      $super_saiyazin_flag[7] = true #バーダック
      #$game_switches[131] = true #トランクス長髪ON
      #$game_switches[132] = true #トランクスバトルスーツON
      $game_switches[395] = true
      $game_switches[445] = true #悟飯短髪
      #$game_switches[438] = true #トランクス剣なし
      $game_switches[504] = true #スピリッツキャノンカットイン表示
      $game_variables[171] = 2 #悟空衣装No 
      #$game_variables[172] = 1 #悟飯衣装No 
      $game_variables[173] = 0 #トランクス衣装No
      $game_variables[175] = 1 #バーダック衣装No
      $game_variables[177] = 1 #18号衣装No
      $game_switches[363] = true #亀仙人普段着
      $game_variables[40] = 1 #シナリオ進行度 
      $cha_set_action[0] = 705 #攻撃アクションNo #＋10 #通常攻撃は1 にする
      $test_normalattackpattern = 2 #通常攻撃のアニメパターンをセット
      $cardset_cha_no[0] = 0  #ここはそのまま　
      $cha_set_enemy[0] = 0   #ここもそのまま
      #$attack_order=[0,10]    #攻撃順番(味方、敵)
      $attack_order=[10,0]    #攻撃順番(敵、味方)
      $cardi[0] = 0           #ここもそのまま
      $cardg[7] = 0           #
      $carda[7] = 0           #
      
      $partyc = [14] #23          #味方キャラNo
      $battleenemy = [58] #154,253 239   #敵キャラNo
      $chadeadchk[0] = false  #ここもそのまま
      $enedeadchk[0] = false  #ここもそのまま
      $enehp[0] = 6000        #ここもそのまま
      #@test_damage_pattern = 41 #テスト用ダメージパターン
      #$battle_test_flag = true #戦闘テストフラグ
      #@scombo_flag = true #合体攻撃フラグ
      $run_scouter_ene[0] = true #スカウター使用フラグ
      #@attack_hit = false #攻撃が回避される
      #$game_variables[96] = 17 #固定戦闘シーン
    end
  end
end