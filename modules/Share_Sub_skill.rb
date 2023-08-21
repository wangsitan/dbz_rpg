module Share_Sub_skill
  
  #--------------------------------------------------------------------------
  # ● スキルの説明や効果詳細を取得
  # temp_skillno:対象スキルNo
  #--------------------------------------------------------------------------
  def get_cha_skill_manual temp_skillno
    tikanmozi = "＊＊置換用＊＊"
    mozi = $cha_skill_manual[temp_skillno]
    
    #以下発動率などの効果詳細
    #mozi += "\n＊＊　しょうさい　＊＊"
    tmp_add_skill_d = false #スキル詳細を追加したか
    mozi += tikanmozi.to_s
    #表示行数が少ないので一行にまとめられるものはなるべくまとめる
    if $cha_skill_a_kouka[temp_skillno] != 0
      tmp_add_skill_d = true
      mozi += "\nよダメ：" + $cha_skill_a_kouka[temp_skillno].to_s + "ばい"
    end

    if $cha_skill_g_kouka[temp_skillno] != 0
      tmp_add_skill_d = true
      if $cha_skill_a_kouka[temp_skillno] != 0
        mozi += "／"
      else
        mozi += "\n"
      end
        mozi += "ひダメ：" + $cha_skill_g_kouka[temp_skillno].to_s + "ばい"
    end
    if $cha_skill_hp_kaihuku[temp_skillno] != 0
      tmp_add_skill_d = true
      
      if $cha_skill_hp_kaihuku_mozi[temp_skillno] == 0
        last_mozi = "％"
      else
        last_mozi = $cha_skill_hp_kaihuku_mozi[temp_skillno].to_s
      end
      mozi += "\nHP：" + $cha_skill_hp_kaihuku[temp_skillno].to_s + last_mozi
    end
    if $cha_skill_ki_kaihuku[temp_skillno] != 0
      tmp_add_skill_d = true
      if $cha_skill_hp_kaihuku[temp_skillno] != 0
        mozi += "／"
      else
        mozi += "\n"
      end
      
      if $cha_skill_ki_kaihuku_mozi[temp_skillno] == 0
        last_mozi = "％"
      else
        last_mozi = $cha_skill_ki_kaihuku_mozi[temp_skillno].to_s
      end
      
      mozi += "KI：" + $cha_skill_ki_kaihuku[temp_skillno].to_s + last_mozi
    end
    if $cha_skill_hp_shohi[temp_skillno] != 0
      tmp_add_skill_d = true
      
      if $cha_skill_hp_shohi_mozi[temp_skillno] == 0
        last_mozi = "％"
      else
        last_mozi = $cha_skill_hp_shohi_mozi[temp_skillno].to_s
      end
      
      mozi += "\nHP：" + $cha_skill_hp_shohi[temp_skillno].to_s + last_mozi
    end
    if $cha_skill_ki_shohi[temp_skillno] != 0
      tmp_add_skill_d = true
      if $cha_skill_hp_shohi[temp_skillno] != 0
        mozi += "／"
      else
        mozi += "\n"
      end
      
      if $cha_skill_ki_shohi_mozi[temp_skillno] == 0
        last_mozi = "％"
      else
        last_mozi = $cha_skill_ki_shohi_mozi[temp_skillno].to_s
      end
      
      mozi += "KI：" + $cha_skill_ki_shohi[temp_skillno].to_s + last_mozi
    end
    if $cha_skill_a_hoshi[temp_skillno] != 0
      tmp_add_skill_d = true
      mozi += "\nこうげきホシ：" + $cha_skill_a_hoshi[temp_skillno].to_s + "こ"
    end
    if $cha_skill_g_hoshi[temp_skillno] != 0
      tmp_add_skill_d = true
      if $cha_skill_a_hoshi[temp_skillno] != 0
        mozi += "／"
      else
        mozi += "\n"
      end 
      mozi += "ぼうぎょホシ：" + $cha_skill_g_hoshi[temp_skillno].to_s + "こ"
    end
    if $cha_skill_bairitu[temp_skillno] != 0
      tmp_add_skill_d = true
      if $cha_skill_bairitu_mozi[temp_skillno] == 0
        last_mozi = "％"
      else
        #p $cha_skill_bairitu_mozi[temp_skillno]
        last_mozi = $cha_skill_bairitu_mozi[temp_skillno].to_s
      end
      mozi += "\nばいりつ：" + $cha_skill_bairitu[temp_skillno].to_s + last_mozi
    end
    if $cha_skill_hatudouritu[temp_skillno] != 0
      tmp_add_skill_d = true
      mozi += "\nかくりつ：" + $cha_skill_hatudouritu[temp_skillno].to_s + "％"
    end
    if tmp_add_skill_d == true
      mozi = mozi.gsub(tikanmozi.to_s,'\n＊＊　こうかしょうさい　＊＊')
    else
      mozi = mozi.gsub(tikanmozi.to_s,'')
    end
    
    return mozi
  end
  #--------------------------------------------------------------------------
  # ● 追加スキルの取得状態のデータ補正
  # temp_chano:キャラのNo(悟空3) nilならすべてをチェック
  # temp_skillno:対象スキルNo
  # chk_get_flag:取得済みのフラグを見るか(チェックする場合:OFFの場合取得してよいと判断
  #--------------------------------------------------------------------------
  def chk_correction_addskill temp_chano=nil
    loop_s = 3
    loop_e = 0
    
    #ループ回数(全キャラチェックなのか格納)
    if temp_chano == nil
      loop_e = $data_actors.size - 1
    else
      loop_s = temp_chano
      loop_e = temp_chano
    end
    for x in loop_s..loop_e
      #Nilの場合取得フラグを初期化
      $cha_skill_get_flag[x] = [0] if $cha_skill_get_flag[x] == nil
      #p $cha_skill_get_flag[x][0]
      for y in 0..$cha_skill_get_flag[x].size - 1
        #nilで落ちる対策
        if $cha_skill_get_flag[x][y] == nil
          $cha_skill_get_flag[x][y] = 0
        end
      
        if $cha_skill_get_flag[x][y] == 1
          #スキルの取得数とセット数 使わない予定だけど取得したか判断のため数は増やしておく
          $skill_set_get_num = Array.new(2).map{Array.new(1,0)} if $skill_set_get_num == []
          $skill_set_get_num[0][y] = 0 if $skill_set_get_num[0][y] == nil
          $skill_set_get_num[1][y] = 0 if $skill_set_get_num[1][y] == nil
          if $skill_set_get_num[1][y] < $skill_get_max  
            $skill_set_get_num[0][y] += 1 
            $skill_set_get_num[1][y] += 1 
          end
          
          #取得しているのでセット済みにもする
          $cha_skill_set_flag[x][y] = 1
          
          #次のスキルも共有スキルであればset済みにする
          if chk_run_next_add_skill(x,y) == true
            $cha_skill_set_flag[x][$cha_upgrade_skill_no[y]] = 1
          end
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 次のスキルを取得してよいかチェックする
  # temp_chano:キャラのNo(悟空3)
  # temp_skillno:対象スキルNo
  # chk_get_flag:取得済みのフラグを見るか(チェックする場合:OFFの場合取得してよいと判断
  #--------------------------------------------------------------------------
  def chk_run_next_add_skill temp_chano,temp_skillno,chk_get_flag = false

    #Nilの場合取得フラグを初期化
    if $cha_skill_get_flag[temp_chano][$cha_upgrade_skill_no[temp_skillno]] == nil
      $cha_skill_get_flag[temp_chano][$cha_upgrade_skill_no[temp_skillno]] = 0
    end
    
    chk_result = false
    #キャラが現在のスキルを取得している
    #スキルのレベルアップが可能
    #次のスキルが共有スキル
    if $cha_skill_get_flag[temp_chano][temp_skillno] == 1 &&
      $cha_skill_share[$cha_upgrade_skill_no[temp_skillno]] == "TRUE"
      
      #取得済みチェックフラグがfalseかtrueなら未取得でtrueを返す
      if chk_get_flag == false || chk_get_flag == true && $cha_skill_get_flag[temp_chano][$cha_upgrade_skill_no[temp_skillno]] == 0
        chk_result = true
      end
    end
    
    return chk_result
  end
  
  
  #--------------------------------------------------------------------------
  # ● 味方スキルセット
  #--------------------------------------------------------------------------
  def set_cha_skill
    $cha_skill_count = 0
    $cha_skill_No = [] #スキルのNo
    $cha_skill_mozi_set = [] #文字取得位置
    $cha_skill_get_val = [] #覚える(効果が実装)に必要なSP値
    $cha_skill_set_get_val = [] #セットするのに必要なCAP値
    $cha_skill_order_no = [] #並び順
    $cha_skill_same_no = [] #同じ効果のスキルナンバー(効果をかぶらせないためのチェック用)
    $cha_upgrade_skill_no = [] #レベルアップ時のスキルNo
    $cha_old_skill_no = [] #古いスキルのスキルNo
    $cha_add_lvup = []      #追加スキルでレベルアップ可能か
    $cha_skill_effect = [] #効果(たぶん使わないけど念のため)
    $cha_skill_share = [] #共有スキルかどうか
    $cha_skill_manual = [] #説明
    $cha_skill_chk_flag = [] #スキル有効 フラグ0:なし 1:スイッチ 2:変数
    $cha_skill_chk_flag_no = [] #スキルフラグナンバー
    $cha_skill_chk_flag_process = [] #チェック方法 0:一致 1:以上 2:以下
    $cha_skill_chk_flag_value = [] #チェック値
    $cha_skill_a_kouka = [] #攻撃アップ倍率
    $cha_skill_g_kouka = [] #防御アップ倍率
    $cha_skill_hp_kaihuku = [] #HP回復アップ倍率
    $cha_skill_hp_kaihuku_mozi = [] #HP回復アップ倍率
    $cha_skill_ki_kaihuku = [] #KI回復アップ倍率
    $cha_skill_ki_kaihuku_mozi = [] #KI回復アップ倍率
    $cha_skill_hatudouritu = [] #スキル発動率
    $cha_skill_hp_shohi = [] #HP消費倍率
    $cha_skill_hp_shohi_mozi = [] #HP消費倍率
    $cha_skill_ki_shohi = [] #KI消費倍率
    $cha_skill_ki_shohi_mozi = [] #KI消費倍率
    $cha_skill_a_hoshi = [] #攻撃星増加
    $cha_skill_g_hoshi = [] #防御星増加
    $cha_skill_bairitu = [] #汎用倍率
    $cha_skill_bairitu_mozi = [] #倍率表示時の文字(0だとデフォルトとみなし%)
    $cha_skill_botu_flag = [] #ボツフラグ

      v_count = 0
      fname = "Data/_chaskill.rvdata" #ファイル順を上にしたから_残す
      
      kugiri = "`"
      obj = load_data(fname)#("Data/_chaskill.rvdata")
      obj.each_with_index do |s,i|
          
          for v in 0..s.size-1
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
              #p tmp_arr
              case v
                #0はNo、1は漢字を含む名前
                when 0 #スキルNo
                  $cha_skill_No[i-1] = tmp_arr
                when 2 #スキル名
                  $cha_skill_mozi_set[i-1] = tmp_arr
                when 3 #スキルの説明
                  $cha_skill_manual[i-1] = tmp_arr
                when 4 #覚える(効果が実装)に必要なSP値
                  $cha_skill_get_val[i-1] = tmp_arr
                when 5 #セットするのに必要なCAP値
                  $cha_skill_set_get_val[i-1] = tmp_arr
                when 6 #並び順
                  $cha_skill_order_no[i-1] = tmp_arr
                when 7 #同じ効果のスキルナンバー(効果をかぶらせないためのチェック用)
                  $cha_skill_same_no[i-1] = tmp_arr
                when 8 #レベルアップ時のスキルNo
                  $cha_upgrade_skill_no[i-1] = tmp_arr
                when 9 #古いスキルのスキルNo
                  $cha_old_skill_no[i-1] = tmp_arr
                when 10 #追加スキルでレベルアップ可能か
                  $cha_add_lvup[i-1] = tmp_arr
                when 11 #効果(たぶん使わないけど念のため)
                  $cha_skill_effect[i-1] = tmp_arr
                when 12 #共有スキルかどうか
                  $cha_skill_share[i-1] = tmp_arr
                when 13 #スキルスキル有効 フラグ0:なし 1:スイッチ 2:変数
                  $cha_skill_chk_flag[i-1] = tmp_arr
                when 14 #スキルフラグナンバー
                  $cha_skill_chk_flag_no[i-1] = tmp_arr
                when 15 #チェック方法 0:一致 1:以上 2:以下
                  $cha_skill_chk_flag_process[i-1] = tmp_arr
                when 16 #チェック値  
                  $cha_skill_chk_flag_value[i-1] = tmp_arr
                when 17 #攻撃アップ倍率
                  $cha_skill_a_kouka[i-1] = tmp_arr
                when 18 #防御アップ倍率
                  $cha_skill_g_kouka[i-1] = tmp_arr
                when 19 #HP回復アップ倍率
                  $cha_skill_hp_kaihuku[i-1] = tmp_arr
                when 20 #HP回復アップ倍率文字
                  $cha_skill_hp_kaihuku_mozi[i-1] = tmp_arr
                when 21 #KI回復アップ倍率
                  $cha_skill_ki_kaihuku[i-1] = tmp_arr
                when 22 #KI回復アップ倍率文字
                  $cha_skill_ki_kaihuku_mozi[i-1] = tmp_arr
                when 23 #スキル発動率
                  $cha_skill_hatudouritu[i-1] = tmp_arr
                when 24 #HP消費倍率
                  $cha_skill_hp_shohi[i-1] = tmp_arr
                when 25 #HP消費倍率文字
                  $cha_skill_hp_shohi_mozi[i-1] = tmp_arr
                when 26 #KI消費倍率
                  $cha_skill_ki_shohi[i-1] = tmp_arr
                when 27 #KI消費倍率
                  $cha_skill_ki_shohi_mozi[i-1] = tmp_arr
                when 28 #攻撃星増加
                  $cha_skill_a_hoshi[i-1] = tmp_arr
                when 29 #防御星増加
                  $cha_skill_g_hoshi[i-1] = tmp_arr
                when 30 #汎用倍率
                  $cha_skill_bairitu[i-1] = tmp_arr
                when 31 #倍率表示時の文字(0だとデフォルトとみなし%)
                  $cha_skill_bairitu_mozi[i-1] = tmp_arr
                when 32 #ボツフラグ(出力しない)
                  $cha_skill_botu_flag[i-1] = tmp_arr
              end
            end
          end
          #p $cha_skill_a_kouka[i-1],
          #$cha_skill_g_kouka[i-1],
          #$cha_skill_hp_kaihuku[i-1],
          #$cha_skill_hatudouritu[i-1],
          #$cha_skill_hp_shohi[i-1],
          #$cha_skill_ki_shohi[i-1],
          #$cha_skill_a_hoshi[i-1],
          #$cha_skill_g_hoshi[i-1],
          #$cha_skill_bairitu[i-1]
           #p $scombo_no[i-1],$scombo_get_flag[i-1],$scombo_new_flag[i-1],$scombo_cha_count[i-1],$scombo_cha[i-1],$scombo_flag_tec[i-1],$scombo_skill_level_num[i-1],$scombo_card_attack_num[i-1],$scombo_card_gard_num[i-1],$scombo_chk_flag[i-1],$scombo_chk_flag_no[i-1],$scombo_chk_flag_process[i-1],$scombo_chk_flag_value[i-1]
           $cha_skill_count += 1 
         end
    $cha_skill_count -= 2
  end
  
  #--------------------------------------------------------------------------
  # ● 固有スキルセット(シナリオ時)
  #--------------------------------------------------------------------------
  def set_typical_skill(chano,skillrow,skillno)
    
    #初めて起動する場合はこちらで全キャラに0をセット
    if $cha_typical_skill[3] == nil
      
      for v in 1..$data_actors.size - 1 #ループ回数は手動で変更する必要がある
        #悟空
        $cha_typical_skill[v] = [0,0,0]
      end
    end
    
    $skill_set_get_num = Array.new(2).map{Array.new(1,0)} if $skill_set_get_num == []
    
    $cha_typical_skill[chano][skillrow] = skillno
    $cha_skill_set_flag[chano][skillno] = 1
    $cha_skill_get_flag[chano][skillno] = 1

    $cha_skill_spval[chano][skillno] = $cha_skill_get_val[skillno]
    
    
    $skill_set_get_num[0][skillno] = 0 if $skill_set_get_num[0][skillno] == nil
    $skill_set_get_num[1][skillno] = 0 if $skill_set_get_num[1][skillno] == nil 
    $skill_set_get_num[0][skillno] += 1
    $skill_set_get_num[1][skillno] += 1  
    
    
  end
  #--------------------------------------------------------------------------
  # ● 固有スキルセット
  #--------------------------------------------------------------------------
  def set_typical_skill_first
    
    #初めて起動する場合はこちらで全キャラに0をセット
    if $cha_typical_skill[3] == nil
      
      for v in 1..$data_actors.size - 1 #ループ回数は手動で変更する必要がある
        #悟空
        $cha_typical_skill[v] = [0,0,0]
      end
    end
    
    
    $skill_set_get_num = Array.new(2).map{Array.new(1,0)} if $skill_set_get_num == []
    #ここは後から調整用
    loopcount = -1 #ループ用
    cha_no=[]
    skill1no=[]
    skill2no=[]
    skill3no=[]

    #チチ
    chkcha = 10
    set_skill_nil_to_zero chkcha
    if $cha_typical_skill[chkcha][0] == 0
      loopcount += 1
      cha_no[loopcount] = chkcha
      #set_skill_nil_to_zero cha_no[loopcount]
      skill1no[loopcount] = 77
      skill2no[loopcount] = 70
      skill3no[loopcount] = 0
      
      #$cha_typical_skill[cha_no[loopcount]][0] = 77
      #$cha_typical_skill[cha_no[loopcount]][1] = 70
      #$cha_typical_skill[cha_no[loopcount]][2] = 0
    end
    
    #亀仙人
    chkcha = 24
    set_skill_nil_to_zero chkcha
    if $cha_typical_skill[chkcha][0] == 0
      loopcount += 1
      cha_no[loopcount] = chkcha
      #set_skill_nil_to_zero cha_no[loopcount]
      skill1no[loopcount] = 687
      skill2no[loopcount] = 14
      skill3no[loopcount] = 39
      
      #$cha_typical_skill[cha_no[loopcount]][0] = 14
      #$cha_typical_skill[cha_no[loopcount]][1] = 39
      #$cha_typical_skill[cha_no[loopcount]][2] = 19
    end
    
    #ベジータ
    chkcha = 12
    set_skill_nil_to_zero chkcha
    if $cha_typical_skill[chkcha][0] == 0
      loopcount += 1
      cha_no[loopcount] = chkcha
      #set_skill_nil_to_zero cha_no[loopcount]
      skill1no[loopcount] = 9
      skill2no[loopcount] = 3
      skill3no[loopcount] = 31
      
      #$cha_typical_skill[cha_no[loopcount]][0] = 9
      #$cha_typical_skill[cha_no[loopcount]][1] = 3
      #$cha_typical_skill[cha_no[loopcount]][2] = 31
    end
    #バーダック
    chkcha = 16
    set_skill_nil_to_zero chkcha
    if $cha_typical_skill[chkcha][0] == 0 && $game_variables[43] != 101
      loopcount += 1
      cha_no[loopcount] = chkcha
      #set_skill_nil_to_zero cha_no[loopcount]
      skill1no[loopcount] = 8
      skill2no[loopcount] = 7
      skill3no[loopcount] = 49
      
      #$cha_typical_skill[cha_no[loopcount]][0] = 8
      #$cha_typical_skill[cha_no[loopcount]][1] = 7
      #$cha_typical_skill[cha_no[loopcount]][2] = 49
    end 
    #トーマ
    chkcha = 27
    set_skill_nil_to_zero chkcha
    if $cha_typical_skill[chkcha][0] == 0
      loopcount += 1
      cha_no[loopcount] = chkcha
      skill1no[loopcount] = 7
      skill2no[loopcount] = 82
      skill3no[loopcount] = 49
    end 
    
    #セリパ
    chkcha = 28
    set_skill_nil_to_zero chkcha
    if $cha_typical_skill[chkcha][0] == 0
      loopcount += 1
      cha_no[loopcount] = chkcha
      skill1no[loopcount] = 7
      skill2no[loopcount] = 82
      skill3no[loopcount] = 33
    end
    #トテッポ
    chkcha = 29
    set_skill_nil_to_zero chkcha
    if $cha_typical_skill[chkcha][0] == 0
      loopcount += 1
      cha_no[loopcount] = chkcha
      skill1no[loopcount] = 7
      skill2no[loopcount] = 82
      skill3no[loopcount] = 49
    end
    #パンブーキン
    chkcha = 30
    set_skill_nil_to_zero chkcha
    if $cha_typical_skill[chkcha][0] == 0
      loopcount += 1
      cha_no[loopcount] = chkcha
      skill1no[loopcount] = 7
      skill2no[loopcount] = 82
      skill3no[loopcount] = 49
    end
    
    #トランクス
    chkcha = 17
    set_skill_nil_to_zero chkcha
    if $cha_typical_skill[chkcha][0] == 0
      loopcount += 1
      cha_no[loopcount] = chkcha
      skill1no[loopcount] = 339
      skill2no[loopcount] = 90
      skill3no[loopcount] = 102
    end
    
    #18号
    chkcha = 21
    set_skill_nil_to_zero chkcha
    if $cha_typical_skill[chkcha][0] == 0
      loopcount += 1
      cha_no[loopcount] = chkcha
      skill1no[loopcount] = 424
      skill2no[loopcount] = 33 #挑発
      skill3no[loopcount] = 34 #フリー
    end

    #17号
    chkcha = 22
    set_skill_nil_to_zero chkcha
    if $cha_typical_skill[chkcha][0] == 0
      loopcount += 1
      cha_no[loopcount] = chkcha
      skill1no[loopcount] = 424
      skill2no[loopcount] = 33
      skill3no[loopcount] = 34
    end
    
    #16号
    chkcha = 23
    set_skill_nil_to_zero chkcha
    if $cha_typical_skill[chkcha][0] == 0
      loopcount += 1
      cha_no[loopcount] = chkcha
      skill1no[loopcount] = 426
      skill2no[loopcount] = 425
      skill3no[loopcount] = 151
    end
    
    #未来悟飯
    chkcha = 25
    set_skill_nil_to_zero chkcha
    if $cha_typical_skill[chkcha][0] == 0
      loopcount += 1
      cha_no[loopcount] = chkcha
      skill1no[loopcount] = 358
      skill2no[loopcount] = 91
      skill3no[loopcount] = 103
    end
    for i in 0..loopcount
      #p cha_no[i]
      set_typical_skill cha_no[i],0,skill1no[i]
      set_typical_skill cha_no[i],1,skill2no[i]
      set_typical_skill cha_no[i],2,skill3no[i]
      
=begin
      $cha_skill_set_flag[cha_no[loopcount]][skill1no[loopcount]] = 1
      $cha_skill_set_flag[cha_no[loopcount]][skill2no[loopcount]] = 1
      $cha_skill_set_flag[cha_no[loopcount]][skill3no[loopcount]] = 1
      
      $cha_skill_get_flag[cha_no[loopcount]][skill1no[loopcount]] = 1
      $cha_skill_get_flag[cha_no[loopcount]][skill1no[loopcount]] = 1
      $cha_skill_get_flag[cha_no[loopcount]][skill1no[loopcount]] = 1
      
      $skill_set_get_num[0][skill1no[loopcount]] = 0 if $skill_set_get_num[0][skill1no[loopcount]] == nil
      $skill_set_get_num[1][skill1no[loopcount]] = 0 if $skill_set_get_num[1][skill1no[loopcount]] == nil 
      $skill_set_get_num[0][skill1no[loopcount]] += 1
      $skill_set_get_num[1][skill1no[loopcount]] += 1
      $skill_set_get_num[0][skill2no[loopcount]] = 0 if $skill_set_get_num[0][skill2no[loopcount]] == nil
      $skill_set_get_num[1][skill2no[loopcount]] = 0 if $skill_set_get_num[1][skill2no[loopcount]] == nil 
      $skill_set_get_num[0][skill2no[loopcount]] += 1
      $skill_set_get_num[1][skill2no[loopcount]] += 1
      $skill_set_get_num[0][skill2no[loopcount]] = 0 if $skill_set_get_num[0][skill3no[loopcount]] == nil
      $skill_set_get_num[1][skill2no[loopcount]] = 0 if $skill_set_get_num[1][skill3no[loopcount]] == nil 
      $skill_set_get_num[0][skill2no[loopcount]] += 1
      $skill_set_get_num[1][skill2no[loopcount]] += 1
      
      $cha_skill_spval[cha_no[loopcount]][skill1no[loopcount]] = $cha_skill_get_val[skill1no[loopcount]]
      $cha_skill_spval[cha_no[loopcount]][skill2no[loopcount]] = $cha_skill_get_val[skill2no[loopcount]]
      $cha_skill_spval[cha_no[loopcount]][skill3no[loopcount]] = $cha_skill_get_val[skill3no[loopcount]]
=end
    end
  end

  #--------------------------------------------------------------------------
  # ● レベルアップ時に固有スキル取得
  #     chano:キャラナンバー
  #--------------------------------------------------------------------------
  def get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
  #スキルセットをまとめて行う
    #配列か調べる
    if old_skillno.instance_of?(Array) == false
      #変数
      if old_skillno == $cha_typical_skill[chano][skillcol]
        skillinfo[1][skillinfo[0].size] = 0
        skillinfo[2][skillinfo[0].size] = skillcol
        skillinfo[0][skillinfo[0].size] = skillno
      end
      
    else old_skillno.index($cha_typical_skill[chano][skillcol]) != nil
      #配列
      skillinfo[1][skillinfo[0].size] = 0
      skillinfo[2][skillinfo[0].size] = skillcol
      skillinfo[0][skillinfo[0].size] = skillno
      #p "配列"
    end
    return skillinfo
  end
  
  #--------------------------------------------------------------------------
  # ● レベルアップ時に固有スキル取得
  #     chano:キャラナンバー
  #--------------------------------------------------------------------------
  def get_typical_skill(chano)
    
    chalv = $game_actors[chano].level
    skillinfo = [0,1]
    skillinfo[0] = [] #取得スキルNo
    skillinfo[1] = [] #スキルがセットか取得か
    skillinfo[2] = [] #何番目のスキルか
    $getnewskill_no = 1
    skillno = 0
    old_skillno = []
    if chano == 3 || chano == 14 #悟空,超悟空
      
      if chalv >= 3
        skillno = 2 #サイヤ人の血1
        skillno = 5 if chano == 14 #サイヤ人の魂1
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end

      if chalv >= 5
        skillno = 48 #鋼鉄のこぶし1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 8
        skillno = 3 #サイヤ人の血2
        skillno = 6 if chano == 14 #サイヤ人の魂2
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 10
        skillno = 49 #鋼鉄のこぶし2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 12
        skillno = 13 #Z戦士の絆1
        skillno = 678 if $game_switches[1312] == true #地球育ちのサイヤ人1
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 16
        skillno = 4 #サイヤ人の血3
        skillno = 7 if chano == 14 #サイヤ人の魂3
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 21
        skillno = 50 #鋼鉄のこぶし3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 24
        skillno = 14 #Z戦士の絆2
        skillno = 679 if $game_switches[1312] == true #地球育ちのサイヤ人2
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 27
        skillno = 89 #サイヤ人の血4
        skillno = 95 if chano == 14 #サイヤ人の魂4
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 35
        skillno = 149 #鋼鉄のこぶし4
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end

      if chalv >= 42
        skillno = 15 #Z戦士の絆3
        skillno = 680 if $game_switches[1312] == true #地球育ちのサイヤ人3
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 49
        skillno = 90 #サイヤ人の血5
        skillno = 96 if chano == 14 #サイヤ人の魂5
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 56
        skillno = 150 #鋼鉄のこぶし5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 63
        skillno = 101 #Z戦士の絆4
        skillno = 681 if $game_switches[1312] == true #地球育ちのサイヤ人4
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end

      if chalv >= 69
        skillno = 91 #サイヤ人の血6
        skillno = 97 if chano == 14 #サイヤ人の魂6
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 76
        skillno = 151 #鋼鉄のこぶし6
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 83
        skillno = 102 #Z戦士の絆5
        skillno = 682 if $game_switches[1312] == true #地球育ちのサイヤ人5
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 90
        skillno = 92 #サイヤ人の血7
        skillno = 98 if chano == 14 #サイヤ人の魂7
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 98
        skillno = 152 #鋼鉄のこぶし7
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 106
        skillno = 103 #Z戦士の絆6
        skillno = 683 if $game_switches[1312] == true #地球育ちのサイヤ人6
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 115
        skillno = 93 #サイヤ人の血8
        skillno = 99 if chano == 14 #サイヤ人の魂8
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 122
        skillno = 153 #鋼鉄のこぶし8
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 127
        skillno = 104 #Z戦士の絆7
        skillno = 684 if $game_switches[1312] == true #地球育ちのサイヤ人7
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 135
        skillno = 94 #サイヤ人の血9
        skillno = 100 if chano == 14 #サイヤ人の魂7
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 142
        skillno = 154 #鋼鉄のこぶし9
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 148
        skillno = 105 #Z戦士の絆8
        skillno = 685 if $game_switches[1312] == true #地球育ちのサイヤ人8
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 155
        skillno = 106 #Z戦士の絆9
        skillno = 686 if $game_switches[1312] == true #地球育ちのサイヤ人9
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
#========================================================================
    elsif chano == 4 #ピッコロ
      if chalv >= 3
        skillno = 35 #魔族の力
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 8
        skillno = 13 #Z戦士の絆1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 12
        skillno = 14 #Z戦士の絆2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 16
        skillno = 15 #Z戦士の絆3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 25
        skillno = 101 #Z戦士の絆4
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 34
        skillno = 102 #Z戦士の絆5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 43
        skillno = 34 #フリー
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 60
        skillno = 103 #Z戦士の絆6
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 77
        skillno = 104 #Z戦士の絆7
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 94
        skillno = 105 #Z戦士の絆8
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 116
        skillno = 106 #Z戦士の絆9
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
#========================================================================
    elsif chano == 5 || chano == 18 #悟飯
      
      if chalv >= 3
        skillno = 61 #ミラクル全快パワー1
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 5
        skillno = 2 #サイヤ人の血1
        skillno = 5 if chano == 18 #サイヤ人の魂1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 9
        skillno = 13 #Z戦士の絆1
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 12
        skillno = 62 #ミラクル全快パワー2
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 16
        skillno = 3 #サイヤ人の血2
        skillno = 6 if chano == 18 #サイヤ人の魂2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 20
        skillno = 14 #Z戦士の絆2
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 25
        skillno = 63 #ミラクル全快パワー3
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 32
        skillno = 4 #サイヤ人の血3
        skillno = 7 if chano == 18 #サイヤ人の魂3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 39
        skillno = 15 #Z戦士の絆3
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 46
        skillno = 167 #ミラクル全快パワー4
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 54
        skillno = 89 #サイヤ人の血4
        skillno = 95 if chano == 18 #サイヤ人の魂4
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 62
        skillno = 101 #Z戦士の絆4
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 70
        skillno = 168 #ミラクル全快パワー5
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 77
        skillno = 90 #サイヤ人の血5
        skillno = 96 if chano == 18 #サイヤ人の魂5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 84
        skillno = 102 #Z戦士の絆5
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 92
        skillno = 169 #ミラクル全快パワー6
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 99
        skillno = 91 #サイヤ人の血6
        skillno = 97 if chano == 18 #サイヤ人の魂6
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 106
        skillno = 103 #Z戦士の絆6
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 113
        skillno = 170 #ミラクル全快パワー7
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 120
        skillno = 92 #サイヤ人の血7
        skillno = 98 if chano == 18 #サイヤ人の魂7
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 127
        skillno = 104 #Z戦士の絆7
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 134
        skillno = 171 #ミラクル全快パワー8
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 141
        skillno = 93 #サイヤ人の血8
        skillno = 99 if chano == 18 #サイヤ人の魂8
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 148
        skillno = 105 #Z戦士の絆8
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 155
        skillno = 172 #ミラクル全快パワー9
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 162
        skillno = 94 #サイヤ人の血9
        skillno = 100 if chano == 18 #サイヤ人の魂9
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 169
        skillno = 106 #Z戦士の絆9
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
#========================================================================
    elsif chano == 6 #クリリン
      
      if chalv >= 3
        skillno = 13 #Z戦士の絆1
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end

      if chalv >= 5
        skillno = 25 #気のコントロール1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 9
        skillno = 14 #Z戦士の絆2
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      

      if chalv >= 13
        skillno = 26 #気のコントロール2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 17
        skillno = 15 #Z戦士の絆3
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 21
        skillno = 27 #気のコントロール3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 26
        skillno = 101 #Z戦士の絆4
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 30
        skillno = 119 #気のコントロール4
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 37
        skillno = 34 #フリー
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end

      
      if chalv >= 45
        skillno = 102 #Z戦士の絆5
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 52
        skillno = 120 #気のコントロール5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 60
        skillno = 103 #Z戦士の絆6
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 67
        skillno = 121 #気のコントロール6
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 74
        skillno = 104 #Z戦士の絆7
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 82
        skillno = 122 #気のコントロール7
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 90
        skillno = 105 #Z戦士の絆8
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 99
        skillno = 123 #気のコントロール8
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 108
        skillno = 106 #Z戦士の絆9
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 115
        skillno = 124 #気のコントロール9
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
#========================================================================
    elsif chano == 7 #ヤムチャ
      
      if chalv >= 3
        skillno = 13 #Z戦士の絆1
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end

      if chalv >= 5
        skillno = 16 #ムダのない動き1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 8
        skillno = 14 #Z戦士の絆2
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      

      if chalv >= 12
        skillno = 17 #ムダのない動き2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 16
        skillno = 15 #Z戦士の絆3
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      if chalv >= 20
        skillno = 18 #ムダのない動き3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end

      if chalv >= 24
        skillno = 101 #Z戦士の絆4
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      if chalv >= 27
        skillno = 107 #ムダのない動き4
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 30
        skillno = 34 #フリー
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 37
        skillno = 102 #Z戦士の絆5
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 44
        skillno = 108 #ムダのない動き5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 50
        skillno = 103 #Z戦士の絆6
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 58
        skillno = 109 #ムダのない動き6
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 65
        skillno = 104 #Z戦士の絆7
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 72
        skillno = 110 #ムダのない動き7
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 78
        skillno = 105 #Z戦士の絆8
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 85
        skillno = 111 #ムダのない動き8
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 92
        skillno = 106 #Z戦士の絆9
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 100
        skillno = 112 #ムダのない動き9
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
#========================================================================
    elsif chano == 8 #テンシンハン
      
      if chalv >= 3
        skillno = 13 #Z戦士の絆1
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end

      if chalv >= 5
        skillno = 58 #湧き出る力1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 9
        skillno = 14 #Z戦士の絆2
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      

      if chalv >= 13
        skillno = 59 #湧き出る力2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 17
        skillno = 60 #湧き出る力3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 21
        skillno = 15 #Z戦士の絆3
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 25
        skillno = 161 #湧き出る力4
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 30
        skillno = 101 #Z戦士の絆4
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 35
        skillno = 34 #フリー
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 43
        skillno = 162 #湧き出る力5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 50
        skillno = 102 #Z戦士の絆5
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 58
        skillno = 163 #湧き出る力6
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 65
        skillno = 103 #Z戦士の絆6
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 71
        skillno = 164 #湧き出る力7
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 79
        skillno = 104 #Z戦士の絆7
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
            
      if chalv >= 86
        skillno = 165 #湧き出る力8
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 94
        skillno = 105 #Z戦士の絆8
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 102
        skillno = 166 #湧き出る力9
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 111
        skillno = 106 #Z戦士の絆9
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
#========================================================================
    elsif chano == 9 #チャオズ
      
      if chalv >= 4
        skillno = 13 #Z戦士の絆1
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end

      if chalv >= 6
        skillno = 39 #かなしばり1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 10
        skillno = 14 #Z戦士の絆2
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      

      if chalv >= 14
        skillno = 40 #かなしばり2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 18
        skillno = 41 #かなしばり3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 22
        skillno = 15 #Z戦士の絆3
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 28
        skillno = 131 #かなしばり4
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 33
        skillno = 101 #Z戦士の絆4
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 38
        skillno = 34 #フリー
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 46
        skillno = 132 #かなしばり5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 53
        skillno = 102 #Z戦士の絆5
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 60
        skillno = 133 #かなしばり6
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 67
        skillno = 103 #Z戦士の絆6
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 73
        skillno = 134 #かなしばり7
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 80
        skillno = 104 #Z戦士の絆7
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 87
        skillno = 135 #かなしばり8
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 95
        skillno = 105 #Z戦士の絆8
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 104
        skillno = 136 #かなしばり9
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 110
        skillno = 106 #Z戦士の絆9
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
#========================================================================
    elsif chano == 10 #チチ
      if chalv >= 4
        skillno = 77 #応援1
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 8
        skillno = 70 #負けん気1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 13
        skillno = 78 #応援2
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 17
        skillno = 71 #負けん気2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 22
        skillno = 79 #応援3
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 27
        skillno = 72 #負けん気3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 31
        skillno = 197 #応援4
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 33
        skillno = 34 #フリー
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 41
        skillno = 185 #負けん気4
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 49
        skillno = 198 #応援5
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 56
        skillno = 186 #負けん気5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 63
        skillno = 199 #応援6
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 70
        skillno = 187 #負けん気6
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 77
        skillno = 200 #応援7
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 83
        skillno = 188 #負けん気7
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 89
        skillno = 201 #応援8
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 95
        skillno = 189 #負けん気8
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 101
        skillno = 202 #応援9
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 109
        skillno = 190 #負けん気9
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
#========================================================================
    elsif chano == 24 #亀仙人
      if chalv >= 3
        skillno = 13 #Z戦士の絆1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end

      if chalv >= 6
        skillno = 39 #かなしばり1
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 9
        skillno = 687 #武泰斗の教え1
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 13
        skillno = 14 #Z戦士の絆2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      if chalv >= 17
        skillno = 688 #武泰斗の教え2
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 21
        skillno = 40 #かなしばり2
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 26
        skillno = 15 #Z戦士の絆3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 33
        skillno = 41 #かなしばり3
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 39
        skillno = 689 #武泰斗の教え3
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 45
        skillno = 101 #Z戦士の絆4
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 51
        skillno = 131 #かなしばり4
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 57
        skillno = 690 #武泰斗の教え4
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 64
        skillno = 102 #Z戦士の絆5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 70
        skillno = 132 #かなしばり5
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 76
        skillno = 691 #武泰斗の教え5
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 82
        skillno = 103 #Z戦士の絆6
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 88
        skillno = 133 #かなしばり6
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 95
        skillno = 692 #武泰斗の教え6
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 101
        skillno = 104 #Z戦士の絆7
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 107
        skillno = 134 #かなしばり7
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 114
        skillno = 693 #武泰斗の教え7
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 121
        skillno = 105 #Z戦士の絆8
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 127
        skillno = 135 #かなしばり8
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 133
        skillno = 694 #武泰斗の教え8
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 139
        skillno = 106 #Z戦士の絆9
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 146
        skillno = 136 #かなしばり9
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 152
        skillno = 695 #武泰斗の教え9
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
    elsif chano == 15 #若者
      if chalv >= 10
        skillno = 10 #再生能力HP
        skillcol = 0
        old_skillno = 0#$cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 13
        skillno = 25 #気のコントロール1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      #if chalv >= 16
      #  skillno = 45 #a不屈の闘志1
      #  skillcol = 2
      #  old_skillno = $cha_old_skill_no[skillno]
      #  skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      #  
      #end
      
      if chalv >= 19
        skillno = 26 #気のコントロール2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end  
      
      #if chalv >= 23
      #  skillno = 46 #a不屈の闘志2
      #  skillcol = 2
      #  old_skillno = $cha_old_skill_no[skillno]
      #  skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      #end
      
      if chalv >= 28
        skillno = 27 #気のコントロール3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 32
        skillno = 34 #フリー
        skillcol = 2
        old_skillno = 0
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      #if chalv >= 32
      #  skillno = 47 #a不屈の闘志3
      #  skillcol = 2
      #  old_skillno = $cha_old_skill_no[skillno]
      #  skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      #end
      
      if chalv >= 38
        skillno = 119 #気のコントロール4
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 51
        skillno = 12 #再生能力HP・KI
        skillcol = 0
        old_skillno = 10#$cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 57
        skillno = 120 #気のコントロール5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 65
        skillno = 121 #気のコントロール6
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 73
        skillno = 122 #気のコントロール7
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 81
        skillno = 123 #気のコントロール8
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 90
        skillno = 124 #気のコントロール9
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
    elsif chano == 12 || chano == 19 #ベジータ
      if chalv >= 10
        skillno = 9 #王子の誇り
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 13
        skillno = 2 #サイヤ人の血1
        skillno = 5 if chano == 19 #サイヤ人の魂1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 16
        skillno = 31 #挑発1
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 19
        skillno = 3 #サイヤ人の血2
        skillno = 6 if chano == 19 #サイヤ人の魂2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 23
        skillno = 32 #挑発2
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 27
        skillno = 4 #サイヤ人の血3
        skillno = 7 if chano == 19 #サイヤ人の魂3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 34
        skillno = 33 #挑発3
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 40
        skillno = 428 #王子の誇り2
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 48
        skillno = 89 #サイヤ人の血4
        skillno = 95 if chano == 19 #サイヤ人の魂4
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 58
        skillno = 125 #挑発4
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 70
        skillno = 90 #サイヤ人の血5
        skillno = 96 if chano == 19 #サイヤ人の魂5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 81
        skillno = 126 #挑発5
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
  
      
      if chalv >= 90
        skillno = 91 #サイヤ人の血6
        skillno = 97 if chano == 19 #サイヤ人の魂6
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
       if chalv >= 99
        skillno = 429 #王子の誇り3
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end  
      
      if chalv >= 109
        skillno = 127 #挑発6
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 120
        skillno = 92 #サイヤ人の血7
        skillno = 98 if chano == 19 #サイヤ人の魂7
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 129
        skillno = 128 #挑発7
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 137
        skillno = 93 #サイヤ人の血8
        skillno = 99 if chano == 19 #サイヤ人の魂8
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 145
        skillno = 129 #挑発8
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 153
        skillno = 94 #サイヤ人の血9
        skillno = 100 if chano == 19 #サイヤ人の魂9
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 165
        skillno = 130 #挑発9
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
    elsif chano == 16 || chano == 32 #バーダック
      if chalv >= 3
        skillno = 8 #最終決戦
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 5
        skillno = 5 #サイヤ人の魂1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 16
        skillno = 48 #鋼鉄のこぶし1
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 19
        skillno = 6 #サイヤ魂2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 23
        skillno = 49 #鋼鉄のこぶし2
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 27
        skillno = 7 #サイヤ人魂3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 36
        skillno = 50 #鋼鉄のこぶし3
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 47
        skillno = 95 #サイヤ人魂4
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 55
        skillno = 149 #鋼鉄のこぶし4
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 62
        skillno = 96 #サイヤ人魂5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 71
        skillno = 150 #鋼鉄のこぶし5
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 80
        skillno = 97 #サイヤ人魂6
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 89
        skillno = 151 #鋼鉄のこぶし6
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 99
        skillno = 98 #サイヤ人魂7
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 110
        skillno = 152 #鋼鉄のこぶし7
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 119
        skillno = 99 #サイヤ人魂8
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 130
        skillno = 153 #鋼鉄のこぶし8
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 140
        skillno = 100 #サイヤ人魂9
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 150
        skillno = 154 #鋼鉄のこぶし9
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
    elsif chano == 27 || chano == 28 || chano == 29 || chano == 30 #トーマたち一括で設定
      if chalv >= 3
        skillno = 5 #サイヤ人魂1
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 7
        skillno = 80 #サイヤ人の結束1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 11
        skillno = 48 #鋼鉄のこぶし1
        skillno = 31 if chano == 28 #挑発1
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 15
        skillno = 6 #サイヤ人魂2
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 18
        skillno = 81 #サイヤ人の結束2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 21
        skillno = 49 #鋼鉄のこぶし2
        skillno = 32 if chano == 28 #挑発2
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 27
        skillno = 7 #サイヤ人魂3
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 33
        skillno = 82 #サイヤ人の結束3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 39
        skillno = 50 #鋼鉄のこぶし3
        skillno = 33 if chano == 28 #挑発3
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 45
        skillno = 95 #サイヤ人魂4
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 50
        skillno = 83 #サイヤ人の結束4
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 57
        skillno = 149 #鋼鉄のこぶし4
        skillno = 125 if chano == 28 #挑発4
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 64
        skillno = 96 #サイヤ人魂5
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 71
        skillno = 84 #サイヤ人の結束5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 78
        skillno = 150 #鋼鉄のこぶし5
        skillno = 126 if chano == 28 #挑発5
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 85
        skillno = 97 #サイヤ人魂6
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 92
        skillno = 85 #サイヤ人の結束6
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 99
        skillno = 151 #鋼鉄のこぶし6
        skillno = 127 if chano == 28 #挑発6
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 106
        skillno = 98 #サイヤ人魂7
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 113
        skillno = 86 #サイヤ人の結束7
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 120
        skillno = 152 #鋼鉄のこぶし7
        skillno = 128 if chano == 28 #挑発7
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 127
        skillno = 99 #サイヤ人魂8
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 134
        skillno = 87 #サイヤ人の結束8
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 141
        skillno = 153 #鋼鉄のこぶし8
        skillno = 129 if chano == 28 #挑発8
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 148
        skillno = 100 #サイヤ人魂9
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 155
        skillno = 88 #サイヤ人の結束9
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 160
        skillno = 154 #鋼鉄のこぶし9
        skillno = 130 if chano == 28 #挑発9
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
    elsif chano == 17 || chano == 20 #トランクス
      if chalv >= 4
        skillno = 336 #未来への希望1
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 7
        skillno = 2 #サイヤ人の血1
        skillno = 5 if chano == 19 #サイヤ人の魂1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 10
        skillno = 13 #Z戦士の絆1
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 14
        skillno = 337 #未来への希望2
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 19
        skillno = 3 #サイヤ人の血2
        skillno = 6 if chano == 20 #サイヤ人の魂2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 22
        skillno = 14 #Z戦士の絆2
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 26
        skillno = 4 #サイヤ人の血3
        skillno = 7 if chano == 20 #サイヤ人の魂3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 33
        skillno = 338 #未来への希望3
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 40
        skillno = 15 #Z戦士の絆3
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 47
        skillno = 89 #サイヤ人の血4
        skillno = 95 if chano == 20 #サイヤ人の魂4
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 54
        skillno = 339 #未来への希望4
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 61
        skillno = 101 #Z戦士の絆4
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 68
        skillno = 90 #サイヤ人の血5
        skillno = 96 if chano == 20 #サイヤ人の魂5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 74
        skillno = 340 #未来への希望5
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 82
        skillno = 102 #Z戦士の絆5
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 90
        skillno = 91 #サイヤ人の血6
        skillno = 97 if chano == 20 #サイヤ人の魂6
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 98
        skillno = 341 #未来への希望6
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 105
        skillno = 103 #Z戦士の絆6
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 110
        skillno = 92 #サイヤ人の血7
        skillno = 98 if chano == 20 #サイヤ人の魂7
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 120
        skillno = 342 #未来への希望7
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 127
        skillno = 104 #Z戦士の絆7
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 134
        skillno = 93 #サイヤ人の血8
        skillno = 99 if chano == 20 #サイヤ人の魂8
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 141
        skillno = 343 #未来への希望8
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 148
        skillno = 105 #Z戦士の絆8
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 155
        skillno = 94 #サイヤ人の血9
        skillno = 100 if chano == 20 #サイヤ人の魂9
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 160
        skillno = 344 #未来への希望9
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 168
        skillno = 106 #Z戦士の絆9
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
    elsif chano == 21 #18号
      if chalv >= 4
        skillno = 423 #永久エネルギー炉1
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 8
        skillno = 31 #挑発1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 12
=begin
        skillno = 13 #Z戦士の絆1
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end        
      end
      
      if chalv >= 20
        skillno = 32 #挑発2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 28
=begin
        skillno = 32 #Z戦士の絆2
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end
      end
      
      if chalv >= 36
        skillno = 33 #挑発3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 44
        skillno = 424 #永久エネルギー炉2
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 52
=begin
        skillno = 33 #Z戦士の絆3
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end
      end
      
      if chalv >= 60
        skillno = 125 #挑発4
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)

      end
      
      if chalv >= 68
=begin
        skillno = 339 #未来への希望4
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end
      end
      
      if chalv >= 75
        skillno = 126 #挑発5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 82
=begin
        skillno = 90 #サイヤ人の血5
        skillno = 96 if chano == 19 #サイヤ人の魂5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end
      end
      
      if chalv >= 90
        skillno = 127 #挑発6
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 98
=begin
        skillno = 126 #Z戦士の絆6
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end
      end
      
      if chalv >= 106
        skillno = 128 #挑発7
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      
      end
      
      if chalv >= 114
        skillno = 425 #永久エネルギー炉3
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
       
      end
      
      if chalv >= 122
=begin
        skillno = 127 #Z戦士の絆7
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end
      end
      
      if chalv >= 130
        skillno = 129 #挑発8
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      
      end
      
      if chalv >= 138
=begin
        skillno = 342 #未来への希望8
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end
      end
      
      if chalv >= 144
=begin
        skillno = 128 #Z戦士の絆9
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end
      end
      
      if chalv >= 150
        skillno = 130 #挑発9
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      
      end

   elsif chano == 22 #17号
      if chalv >= 4
        skillno = 423 #永久エネルギー炉1
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 8
        skillno = 31 #挑発1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 12
=begin
        skillno = 13 #Z戦士の絆1
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end        
      end
      
      if chalv >= 20
        skillno = 32 #挑発2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 28
=begin
        skillno = 32 #Z戦士の絆2
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end
      end
      
      if chalv >= 36
        skillno = 33 #挑発3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 43
        skillno = 424 #永久エネルギー炉2
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 50
=begin
        skillno = 33 #Z戦士の絆3
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end
      end
      
      if chalv >= 60
        skillno = 125 #挑発4
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)

      end
      
      if chalv >= 69
=begin
        skillno = 339 #未来への希望4
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end
      end
      
      if chalv >= 77
        skillno = 126 #挑発5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 85
=begin
        skillno = 90 #サイヤ人の血5
        skillno = 96 if chano == 19 #サイヤ人の魂5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end
      end
      
      if chalv >= 93
        skillno = 127 #挑発6
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 101
=begin
        skillno = 126 #Z戦士の絆6
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end
      end
      
      if chalv >= 111
        skillno = 128 #挑発7
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      
      end
      
      if chalv >= 120
        skillno = 425 #永久エネルギー炉3
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
       
      end
      
      if chalv >= 127
=begin
        skillno = 127 #Z戦士の絆7
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end
      end
      
      if chalv >= 134
        skillno = 129 #挑発8
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      
      end
      
      if chalv >= 141
=begin
        skillno = 342 #未来への希望8
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end
      end
      
      if chalv >= 149
=begin
        skillno = 128 #Z戦士の絆9
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
=end
      end
      
      if chalv >= 156
        skillno = 130 #挑発9
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      
      end

    elsif chano == 23 #16号
      if chalv >= 1
        skillno = 57 #慈愛の心
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      if chalv >= 4
        skillno = 423 #永久エネルギー炉1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 8
        skillno = 48 #鋼鉄のこぶし1
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 15
        skillno = 49 #鋼鉄のこぶし2
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      
      end
      
      if chalv >= 23
        skillno = 50 #鋼鉄のこぶし3
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      
      end
      
      if chalv >= 31
        skillno = 149 #鋼鉄のこぶし4
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      
      end
      
      if chalv >= 43
        skillno = 150 #鋼鉄のこぶし5
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 57
        skillno = 424 #永久エネルギー炉2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 70
        skillno = 151 #鋼鉄のこぶし6
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
      end
      
      if chalv >= 84
        skillno = 425 #永久エネルギー炉3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
 
      end
      
      if chalv >= 95
        skillno = 426 #慈愛の心2
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
     end
      
      if chalv >= 108
        skillno = 152 #鋼鉄のこぶし7
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)        
      end
      
      if chalv >= 120
        skillno = 153 #鋼鉄のこぶし8
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)        
      end
      
      if chalv >= 130
        skillno = 427 #慈愛の心3
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
     end
      
      if chalv >= 145
        skillno = 154 #鋼鉄のこぶし9
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)        

      end
    elsif chano == 25 || chano == 26 #未来悟飯
      if chalv >= 4
        skillno = 354 #絶望への反抗1
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 7
        skillno = 2 #サイヤ人の血1
        skillno = 5 if chano == 26 #サイヤ人の魂1
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 10
        skillno = 13 #Z戦士の絆1
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 14
        skillno = 355 #絶望への反抗2
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 19
        skillno = 3 #サイヤ人の血2
        skillno = 6 if chano == 26 #サイヤ人の魂2
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 24
        skillno = 32 #Z戦士の絆2
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 32
        skillno = 4 #サイヤ人の血3
        skillno = 7 if chano == 26 #サイヤ人の魂3
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 40
        skillno = 356 #絶望への反抗3
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 47
        skillno = 33 #Z戦士の絆3
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 55
        skillno = 89 #サイヤ人の血4
        skillno = 95 if chano == 26 #サイヤ人の魂4
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 63
        skillno = 357 #絶望への反抗4
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 71
        skillno = 101 #Z戦士の絆4
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 78
        skillno = 90 #サイヤ人の血5
        skillno = 96 if chano == 26 #サイヤ人の魂5
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 86
        skillno = 358 #絶望への反抗5
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 94
        skillno = 102 #Z戦士の絆5
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 101
        skillno = 91 #サイヤ人の血6
        skillno = 97 if chano == 26 #サイヤ人の魂6
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 109
        skillno = 359 #絶望への反抗6
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 117
        skillno = 103 #Z戦士の絆6
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 124
        skillno = 92 #サイヤ人の血7
        skillno = 98 if chano == 26 #サイヤ人の魂7
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 132
        skillno = 360 #絶望への反抗7
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 140
        skillno = 104 #Z戦士の絆7
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 146
        skillno = 93 #サイヤ人の血8
        skillno = 99 if chano == 26 #サイヤ人の魂8
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 152
        skillno = 361 #絶望への反抗8
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 158
        skillno = 105 #Z戦士の絆8
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 164
        skillno = 94 #サイヤ人の血9
        skillno = 100 if chano == 26 #サイヤ人の魂9
        skillcol = 1
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 170
        skillno = 362 #絶望への反抗9
        skillcol = 0
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
      
      if chalv >= 175
        skillno = 106 #Z戦士の絆9
        skillcol = 2
        old_skillno = $cha_old_skill_no[skillno]
        skillinfo = get_typical_skill_cha(chano,skillcol,skillno,old_skillno,skillinfo)
        
      end
    end

    return skillinfo
  end
 
  #--------------------------------------------------------------------------
  # ● スキルのnilを0で埋める
  # cha_no:キャラクターNo 
  #--------------------------------------------------------------------------
  def set_skill_nil_to_zero cha_no
    
    temp_cha_no = cha_no
    #p $cha_typical_skill[temp_cha_no],$cha_add_skill[temp_cha_no],$cha_skill_spval[temp_cha_no]
    if $cha_typical_skill == [] || $cha_typical_skill == nil
      $cha_typical_skill[temp_cha_no] = [0,0,0] if $cha_typical_skill[temp_cha_no] == nil
    end

    $cha_typical_skill[temp_cha_no] = [0,0,0] if $cha_typical_skill[temp_cha_no] == nil
    
    if $cha_add_skill == [] || $cha_add_skill == nil
      $cha_add_skill[temp_cha_no] = [0,0] if $cha_add_skill[temp_cha_no] == nil
    end
    $cha_add_skill[temp_cha_no] = [0,0] if $cha_add_skill[temp_cha_no] == nil
    
    if $cha_skill_spval == [] || $cha_skill_spval == nil
      $cha_skill_spval[temp_cha_no] = [0] if $cha_skill_spval[temp_cha_no] == nil
    end
    $cha_skill_spval[temp_cha_no] = [0] if $cha_skill_spval[temp_cha_no] == nil
    
    #p $cha_skill_count
    for x in 0..$cha_skill_count
      $cha_skill_spval[temp_cha_no][x] = 0 if $cha_skill_spval[temp_cha_no][x] == nil
    end
    
    if $cha_skill_set_flag == [] || $cha_skill_set_flag == nil
      $cha_skill_set_flag[temp_cha_no] = [0] if $cha_skill_set_flag[temp_cha_no] == nil
    end
    $cha_skill_set_flag[temp_cha_no] = [0] if $cha_skill_set_flag[temp_cha_no] == nil
    
    if $cha_skill_get_flag == [] || $cha_skill_get_flag == nil
      $cha_skill_get_flag[temp_cha_no] = [0] if $cha_skill_get_flag[temp_cha_no] == nil
    end
    $cha_skill_get_flag[temp_cha_no] = [0] if $cha_skill_get_flag[temp_cha_no] == nil
    
    
    for x in 0..$cha_skill_count
      $cha_skill_set_flag[temp_cha_no][x] = 0 if $cha_skill_set_flag[temp_cha_no][x] == nil
    end
    
    if $skill_set_get_num == [] || $skill_set_get_num == nil
      $skill_set_get_num[0] = [0] if $skill_set_get_num[0] == nil
      $skill_set_get_num[1] = [0] if $skill_set_get_num[1] == nil
    end
    $skill_set_get_num[0] = [0] if $skill_set_get_num[0] == nil
    $skill_set_get_num[1] = [0] if $skill_set_get_num[1] == nil
    
    for x in 0..$cha_skill_count
      $skill_set_get_num[0][x] = 0 if $skill_set_get_num[0][x] == nil
      $skill_set_get_num[1][x] = 0 if $skill_set_get_num[1][x] == nil
    end
    
    
    if $cha_add_skill_set_num[temp_cha_no] == nil
      $cha_add_skill_set_num[temp_cha_no] = 1
    end
    
    
    #p $cha_typical_skill[temp_cha_no],$cha_add_skill[temp_cha_no],$cha_skill_spval[temp_cha_no]
  end
  
    #--------------------------------------------------------------------------
  # ● スキルでカード攻防の星調整や順番変更など
  # cha_no:キャラクターNo card_no:カードNo random_skill_run:スキルを実行するか 0:実行しない
  # run_mpowerのみ実行用
  #--------------------------------------------------------------------------
  def get_battle_skill cha_no,card_no,random_skill_run=0,run_mpower = 0
    
    temp_cha_no = cha_no
    temp_card_no = card_no
    temp_cha_skill = []
    temp_skill_no = 0
    cha_attack_num = 0 #味方のカード調整量
    cha_guard_num = 0
    skill_effect_flag = false
    bairitu = 0
    kakuritu = 0


      #消費mpを下げるスキルなどが付いてるかチェック
      set_skill_nil_to_zero temp_cha_no
      
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
      if random_skill_run == 0 #通常、ランダムスキルどっちを実行するか

        if run_mpower == 0
          #きまぐれ=====================================================
          if chk_skill_learn(390,temp_cha_no)[0] == true #きまぐれ1
            $carda[temp_card_no] = $cha_carda_rand[$partyc.index(temp_cha_no)]
            $cardg[temp_card_no] = $cha_cardg_rand[$partyc.index(temp_cha_no)]
            #$cardi[temp_card_no] = $cha_cardi_rand[$partyc.index(temp_cha_no)]
          elsif chk_skill_learn(391,temp_cha_no)[0] == true #きまぐれ2
            $cardi[temp_card_no] = $cha_cardi_rand[$partyc.index(temp_cha_no)]
          elsif chk_skill_learn(402,temp_cha_no)[0] == true #きまぐれ3
            $carda[temp_card_no] = $cha_carda_rand[$partyc.index(temp_cha_no)]
            $cardg[temp_card_no] = $cha_cardg_rand[$partyc.index(temp_cha_no)]
            $cardi[temp_card_no] = $cha_cardi_rand[$partyc.index(temp_cha_no)]
          end
        end
        
        #ミラクル全開パワー================================================
        kakuritu = 0
        temp_skill_no = 0
        if temp_cha_skill.index(61) != nil #ミラクル全開パワー1
          temp_skill_no = 61
          kakuritu = 10
        elsif temp_cha_skill.index(62) != nil #ミラクル全開パワー2
          temp_skill_no = 62
          kakuritu = 12
        elsif temp_cha_skill.index(63) != nil #ミラクル全開パワー3
          temp_skill_no = 63
          kakuritu = 14
        elsif temp_cha_skill.index(167) != nil #ミラクル全開パワー4
          temp_skill_no = 167
          kakuritu = 16
        elsif temp_cha_skill.index(168) != nil #ミラクル全開パワー5
          temp_skill_no = 168
          kakuritu = 18
        elsif temp_cha_skill.index(169) != nil #ミラクル全開パワー6
          temp_skill_no = 169
          kakuritu = 20
        elsif temp_cha_skill.index(170) != nil #ミラクル全開パワー7
          temp_skill_no = 170
          kakuritu = 22
        elsif temp_cha_skill.index(171) != nil #ミラクル全開パワー8
          temp_skill_no = 171
          kakuritu = 24
        elsif temp_cha_skill.index(172) != nil #ミラクル全開パワー9
          temp_skill_no = 172
          kakuritu = 28
        end
        
        if kakuritu != 0 && $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
          if $cha_mzenkai_num[$partyc.index(temp_cha_no)] < kakuritu
            skill_effect_flag = true
          end

        end
        
        #ミラクル全開パワーのみ実行チェック
        if run_mpower == 1
          
          if skill_effect_flag == true
            return true
          else
            return false
          end
        end
        
        if skill_effect_flag == true
          $carda[temp_card_no] = 7
          $cardg[temp_card_no] = 7
          skill_effect_flag = false
        end
        
        #さかさま=================================================
        if chk_skill_learn(422,temp_cha_no)[0] == true #さかさま
            
            #攻撃
            case $carda[temp_card_no]
            
            when 0
              $carda[temp_card_no] = 7
            when 1
              $carda[temp_card_no] = 6
            when 2
              $carda[temp_card_no] = 5
            when 3
              $carda[temp_card_no] = 4
            when 4
              $carda[temp_card_no] = 3
            when 5
              $carda[temp_card_no] = 2
            when 6
              $carda[temp_card_no] = 1
            when 7
              $carda[temp_card_no] = 0
            end
            
            #防御
            case $cardg[temp_card_no]
            
            when 0
              $cardg[temp_card_no] = 7
            when 1
              $cardg[temp_card_no] = 6
            when 2
              $cardg[temp_card_no] = 5
            when 3
              $cardg[temp_card_no] = 4
            when 4
              $cardg[temp_card_no] = 3
            when 5
              $cardg[temp_card_no] = 2
            when 6
              $cardg[temp_card_no] = 1
            when 7
              $cardg[temp_card_no] = 0
            end           

        end
        
        #気を溜める====================================================
        #気を溜める実行分だけここで行う発動条件は別プロシージャ
        if $cha_ki_tameru_flag[$partyc.index(temp_cha_no)] == true && $cardi[temp_card_no] == 0
          $cardi[temp_card_no] = $game_actors[temp_cha_no].class_id-1
        end
        
        #起死回生1====================================================
        if temp_cha_skill.index(367) != nil #起死回生1
          temp_skill_no = 367
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            
            if $carda[temp_card_no] == 0 && $cardg[temp_card_no] == 0
              $carda[temp_card_no] = 7
              $cardg[temp_card_no] = 7
            end
          end
        elsif temp_cha_skill.index(368) != nil #起死回生2
          temp_skill_no = 368
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            
            if $carda[temp_card_no] == 0 && $cardg[temp_card_no] == 0
              $carda[temp_card_no] = 7
              $cardg[temp_card_no] = 7
            elsif $carda[temp_card_no] == 1 && $cardg[temp_card_no] == 1
              $carda[temp_card_no] = 6
              $cardg[temp_card_no] = 6
            end
            
          end
        end
        
        #攻守一体====================================================
        if chk_skill_learn(384,temp_cha_no)[0] == true && #攻守一体4
          $carda[temp_card_no] == $cardg[temp_card_no]
            $carda[temp_card_no] += 7
            $cardg[temp_card_no] += 7
            skill_effect_flag = true
        elsif chk_skill_learn(383,temp_cha_no)[0] == true && #攻守一体3
          $carda[temp_card_no] == $cardg[temp_card_no]
            $carda[temp_card_no] += 5
            $cardg[temp_card_no] += 5
            skill_effect_flag = true
        elsif chk_skill_learn(382,temp_cha_no)[0] == true && #攻守一体2
          $carda[temp_card_no] == $cardg[temp_card_no]
            $carda[temp_card_no] += 3
            $cardg[temp_card_no] += 3
            skill_effect_flag = true
        elsif chk_skill_learn(381,temp_cha_no)[0] == true && #攻守一体1
          $carda[temp_card_no] == $cardg[temp_card_no]
            $carda[temp_card_no] += 1
            $cardg[temp_card_no] += 1
            skill_effect_flag = true
        end
          
        #真の力(悟飯超2用)====================================================
        if temp_cha_skill.index(38) != nil #真の力(悟飯超2用)
          temp_skill_no = 38
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            
            #何以下を見るか4なら4以下(内部的には星は5)
            bairitu = 4
            if $carda[temp_card_no] < bairitu
              cha_attack_num += (bairitu - $carda[temp_card_no])
              skill_effect_flag = true 
            end
            
            if $cardg[temp_card_no] < bairitu
              cha_guard_num += (bairitu - $cardg[temp_card_no])
              skill_effect_flag = true 
            end
            
          end
        end
        
        #ムダのない動き====================================================
        if temp_cha_skill.index(16) != nil #ムダのない動き1
          temp_skill_no = 16
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            cha_attack_num += 1
            cha_guard_num += 1
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(17) != nil #ムダのない動き2
          temp_skill_no = 17
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            cha_attack_num += 2
            cha_guard_num += 1
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(18) != nil #ムダのない動き3
          temp_skill_no = 18
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            cha_attack_num += 2
            cha_guard_num += 2
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(107) != nil #ムダのない動き4
          temp_skill_no = 107
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            cha_attack_num += 3
            cha_guard_num += 2
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(108) != nil #ムダのない動き5
          temp_skill_no = 108
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            cha_attack_num += 3
            cha_guard_num += 3
            skill_effect_flag = true
          end
        elsif temp_cha_skill.index(109) != nil #ムダのない動き6
          temp_skill_no = 109
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            cha_attack_num += 4
            cha_guard_num += 3
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(110) != nil #ムダのない動き7
          temp_skill_no = 110
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            cha_attack_num += 4
            cha_guard_num += 4
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(111) != nil #ムダのない動き8
          temp_skill_no = 111
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            cha_attack_num += 5
            cha_guard_num += 5
            skill_effect_flag = true 
          end
        elsif temp_cha_skill.index(112) != nil #ムダのない動き9
          temp_skill_no = 112
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            cha_attack_num += 6
            cha_guard_num += 6
            skill_effect_flag = true 
          end
        end
        
        if $battle_turn_num >= 1 #2ターン以上連続で戦闘に参加しているか
          #未来への希望====================================================
          if temp_cha_skill.index(336) != nil #未来への希望1
            temp_skill_no = 336
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              cha_attack_num += 1
              cha_guard_num += 1
              skill_effect_flag = true 
            end
          elsif temp_cha_skill.index(337) != nil #未来への希望2
            temp_skill_no = 337
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              cha_attack_num += 1
              cha_guard_num += 1
              #cha_attack_num += 1 if $battle_turn_num >= 2
              skill_effect_flag = true 
            end
          elsif temp_cha_skill.index(338) != nil #未来への希望3
            temp_skill_no = 338
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              cha_attack_num += 1
              cha_guard_num += 1
              cha_attack_num += 1 if $battle_turn_num >= 3
              #cha_guard_num += 1 if $battle_turn_num >= 3
              skill_effect_flag = true 
            end
          elsif temp_cha_skill.index(339) != nil #未来への希望4
            temp_skill_no = 339
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              cha_attack_num += 1
              cha_guard_num += 1
              cha_attack_num += 1 if $battle_turn_num >= 3
              #cha_guard_num += 1 if $battle_turn_num >= 3
              #cha_attack_num += 1 if $battle_turn_num >= 4
              skill_effect_flag = true 
            end
          elsif temp_cha_skill.index(340) != nil #未来への希望5
            temp_skill_no = 340
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              cha_attack_num += 1
              cha_guard_num += 1
              cha_attack_num += 1 if $battle_turn_num >= 3
              cha_guard_num += 1 if $battle_turn_num >= 5
              #cha_attack_num += 1 if $battle_turn_num >= 4
              #cha_guard_num += 1 if $battle_turn_num >= 5
              skill_effect_flag = true 
            end
          elsif temp_cha_skill.index(341) != nil #未来への希望6
            temp_skill_no = 341
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              cha_attack_num += 1
              cha_guard_num += 1
              cha_attack_num += 1 if $battle_turn_num >= 3
              cha_guard_num += 1 if $battle_turn_num >= 5
              #cha_attack_num += 1 if $battle_turn_num >= 7
              #cha_guard_num += 1 if $battle_turn_num >= 5
              #cha_attack_num += 1 if $battle_turn_num >= 6
              skill_effect_flag = true 
            end
          elsif temp_cha_skill.index(342) != nil #未来への希望7
            temp_skill_no = 342
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              cha_attack_num += 1
              cha_guard_num += 1
              cha_attack_num += 1 if $battle_turn_num >= 3
              cha_guard_num += 1 if $battle_turn_num >= 5
              cha_attack_num += 1 if $battle_turn_num >= 7
              #cha_guard_num += 1 if $battle_turn_num >= 5
              #cha_attack_num += 1 if $battle_turn_num >= 6
              #cha_guard_num += 1 if $battle_turn_num >= 7
              skill_effect_flag = true 
            end
          elsif temp_cha_skill.index(343) != nil #未来への希望8
            temp_skill_no = 343
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              cha_attack_num += 1
              cha_guard_num += 1
              cha_attack_num += 1 if $battle_turn_num >= 3
              cha_guard_num += 1 if $battle_turn_num >= 5
              cha_attack_num += 1 if $battle_turn_num >= 7
              cha_guard_num += 1 if $battle_turn_num >= 9
              #cha_attack_num += 1 if $battle_turn_num >= 6
              #cha_guard_num += 1 if $battle_turn_num >= 7
              #cha_attack_num += 1 if $battle_turn_num >= 8
              skill_effect_flag = true 
            end
          elsif temp_cha_skill.index(344) != nil #未来への希望9
            temp_skill_no = 344
            if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
              cha_attack_num += 1
              cha_guard_num += 1
              cha_attack_num += 1 if $battle_turn_num >= 3
              cha_guard_num += 1 if $battle_turn_num >= 5
              cha_attack_num += 1 if $battle_turn_num >= 7
              cha_guard_num += 1 if $battle_turn_num >= 9
              cha_attack_num += 1 if $battle_turn_num >= 11
              cha_guard_num += 1 if $battle_turn_num >= 13
              #cha_attack_num += 1 if $battle_turn_num >= 8
              #cha_guard_num += 1 if $battle_turn_num >= 9
              skill_effect_flag = true 
            end
          end
        end
        

        
        #アタッカー====================================================
        if chk_skill_learn(506,temp_cha_no)[0] == true #アタッカー4
          $carda[temp_card_no] += 4
          skill_effect_flag = true 
        elsif chk_skill_learn(505,temp_cha_no)[0] == true #アタッカー3
          $carda[temp_card_no] += 3
          skill_effect_flag = true 
        elsif chk_skill_learn(504,temp_cha_no)[0] == true #アタッカー2
          $carda[temp_card_no] += 2
          skill_effect_flag = true 
        elsif chk_skill_learn(503,temp_cha_no)[0] == true #アタッカー1
          $carda[temp_card_no] += 1
          skill_effect_flag = true 
        end

        #ディフェンダー====================================================
        if chk_skill_learn(510,temp_cha_no)[0] == true #ディフェンダー4
          $cardg[temp_card_no] += 4
          skill_effect_flag = true
        elsif chk_skill_learn(509,temp_cha_no)[0] == true #ディフェンダー3
          $cardg[temp_card_no] += 3
          skill_effect_flag = true
        elsif chk_skill_learn(508,temp_cha_no)[0] == true #ディフェンダー2
          $cardg[temp_card_no] += 2
          skill_effect_flag = true
        elsif chk_skill_learn(507,temp_cha_no)[0] == true #ディフェンダー1
          $cardg[temp_card_no] += 1
          skill_effect_flag = true
        end
          
        #アウトサイダー====================================================
        #攻防の星を増加する
        if chk_skill_learn(651,temp_cha_no)[0] == true #アウトサイダー9
          $carda[temp_card_no] += 5
          $cardg[temp_card_no] += 5
          skill_effect_flag = true
        elsif chk_skill_learn(650,temp_cha_no)[0] == true #アウトサイダー8
          $carda[temp_card_no] += 5
          $cardg[temp_card_no] += 4
          skill_effect_flag = true
        elsif chk_skill_learn(649,temp_cha_no)[0] == true #アウトサイダー7
          $carda[temp_card_no] += 4
          $cardg[temp_card_no] += 4
          skill_effect_flag = true
        elsif chk_skill_learn(648,temp_cha_no)[0] == true #アウトサイダー6
          $carda[temp_card_no] += 4
          $cardg[temp_card_no] += 3
          skill_effect_flag = true
        elsif chk_skill_learn(647,temp_cha_no)[0] == true #アウトサイダー5
          $carda[temp_card_no] += 3
          $cardg[temp_card_no] += 3
          skill_effect_flag = true
        elsif chk_skill_learn(646,temp_cha_no)[0] == true #アウトサイダー4
          $carda[temp_card_no] += 3
          $cardg[temp_card_no] += 2
          skill_effect_flag = true
        elsif chk_skill_learn(645,temp_cha_no)[0] == true #アウトサイダー3
          $carda[temp_card_no] += 2
          $cardg[temp_card_no] += 2
          skill_effect_flag = true
        elsif chk_skill_learn(644,temp_cha_no)[0] == true #アウトサイダー2
          $carda[temp_card_no] += 2
          $cardg[temp_card_no] += 1
          skill_effect_flag = true
        elsif chk_skill_learn(430,temp_cha_no)[0] == true #アウトサイダー1
          $carda[temp_card_no] += 1
          $cardg[temp_card_no] += 1
          skill_effect_flag = true
        end
        
        #吸収(撃破)====================================================
        if chk_skill_learn(528,temp_cha_no)[0] == true && #吸収(撃破)9
          $enedead.include?(true) == true
          $carda[temp_card_no] += 5
          $cardg[temp_card_no] += 5
          skill_effect_flag = true
        elsif chk_skill_learn(527,temp_cha_no)[0] == true && #吸収(撃破)8
          $enedead.include?(true) == true
          $carda[temp_card_no] += 5
          $cardg[temp_card_no] += 4
          skill_effect_flag = true
        elsif chk_skill_learn(517,temp_cha_no)[0] == true && #吸収(撃破)7
          $enedead.include?(true) == true
          $carda[temp_card_no] += 4
          $cardg[temp_card_no] += 4
          skill_effect_flag = true
        elsif chk_skill_learn(516,temp_cha_no)[0] == true && #吸収(撃破)6
          $enedead.include?(true) == true
          $carda[temp_card_no] += 4
          $cardg[temp_card_no] += 3
          skill_effect_flag = true
        elsif chk_skill_learn(515,temp_cha_no)[0] == true && #吸収(撃破)5
          $enedead.include?(true) == true
          $carda[temp_card_no] += 3
          $cardg[temp_card_no] += 3
          skill_effect_flag = true
        elsif chk_skill_learn(514,temp_cha_no)[0] == true && #吸収(撃破)4
          $enedead.include?(true) == true
          $carda[temp_card_no] += 3
          $cardg[temp_card_no] += 2
          skill_effect_flag = true
        elsif chk_skill_learn(513,temp_cha_no)[0] == true && #吸収(撃破)3
          $enedead.include?(true) == true
          $carda[temp_card_no] += 2
          $cardg[temp_card_no] += 2
          skill_effect_flag = true
        elsif chk_skill_learn(512,temp_cha_no)[0] == true && #吸収(撃破)2
          $enedead.include?(true) == true
          $carda[temp_card_no] += 2
          $cardg[temp_card_no] += 1
          skill_effect_flag = true
        elsif chk_skill_learn(511,temp_cha_no)[0] == true && #吸収(撃破)1
          $enedead.include?(true) == true
          $carda[temp_card_no] += 1
          $cardg[temp_card_no] += 1
          skill_effect_flag = true
        end
          
        if skill_effect_flag == true
          $carda[temp_card_no] += cha_attack_num
          $cardg[temp_card_no] += cha_guard_num
          $carda[temp_card_no] = 7 if $carda[temp_card_no] > 7
          $cardg[temp_card_no] = 7 if $cardg[temp_card_no] > 7
          $carda[temp_card_no] = 0 if $carda[temp_card_no] < 0
          $cardg[temp_card_no] = 0 if $cardg[temp_card_no] < 0
          skill_effect_flag = false
        end
        
        #捨て身か鉄壁====================================================
        if temp_cha_skill.index(54) != nil #捨て身1
          temp_skill_no = 54
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            
            if $carda[temp_card_no] < $cardg[temp_card_no]
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(73) != nil #鉄壁1
          temp_skill_no = 73
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            
            if $carda[temp_card_no] > $cardg[temp_card_no]
              skill_effect_flag = true
            end
          end
        end
        
        if skill_effect_flag == true
          $carda[temp_card_no],$cardg[temp_card_no] = $cardg[temp_card_no],$carda[temp_card_no]
          skill_effect_flag = false
        end
        
        hosimax = 7
        temp_anum =  (hosimax - $carda[temp_card_no])
        temp_gnum =  (hosimax - $cardg[temp_card_no])
        if temp_cha_skill.index(365) != nil #捨て身2
          temp_skill_no = 365
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            
            if temp_anum != 0 && temp_gnum != hosimax
              
              for i in 0..temp_anum - 1
                $carda[temp_card_no] += 1
                $cardg[temp_card_no] -= 1
                break if $cardg[temp_card_no] == 0
              end
            end
          end
        elsif temp_cha_skill.index(366) != nil #鉄壁2
          temp_skill_no = 366
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            
            if temp_anum != hosimax && temp_gnum != 0
              
              for i in 0..temp_gnum - 1
                $carda[temp_card_no] -= 1
                $cardg[temp_card_no] += 1
                break if $carda[temp_card_no] == 0
              end
            end
          end
        end
        
        #大猿状態でかつ必ならば流派にする
        if $partyc.index(temp_cha_no) != nil
          if $cha_bigsize_on[$partyc.index(temp_cha_no)] == true
            if $cardi[temp_card_no] == 0
              $cardi[temp_card_no] = $game_actors[temp_cha_no].class_id-1
            end
          end
        end
        
        #スーパーベジータ
        #取得かつ必カードであれば、流派カードにする
        if chk_skill_learn(643,temp_cha_no)[0] == true && $cardi[temp_card_no] == 0 #スーパーベジータ
          $cardi[temp_card_no] = $game_actors[temp_cha_no].class_id-1
        end
        
        #アウトサイダー====================================================
        #取得かつ必カードであれば、流派カードにする(ただし、Sコンボが発動できなくなる それは別処理に記載)
        if chk_skill_learn(651,temp_cha_no)[0] == true && $cardi[temp_card_no] == 0 || #アウトサイダー9
          chk_skill_learn(650,temp_cha_no)[0] == true && $cardi[temp_card_no] == 0 || #アウトサイダー8
          chk_skill_learn(649,temp_cha_no)[0] == true && $cardi[temp_card_no] == 0 || #アウトサイダー7
          chk_skill_learn(648,temp_cha_no)[0] == true && $cardi[temp_card_no] == 0 || #アウトサイダー6
          chk_skill_learn(647,temp_cha_no)[0] == true && $cardi[temp_card_no] == 0 || #アウトサイダー5
          chk_skill_learn(646,temp_cha_no)[0] == true && $cardi[temp_card_no] == 0 || #アウトサイダー4
          chk_skill_learn(645,temp_cha_no)[0] == true && $cardi[temp_card_no] == 0 || #アウトサイダー3
          chk_skill_learn(644,temp_cha_no)[0] == true && $cardi[temp_card_no] == 0 || #アウトサイダー2
          chk_skill_learn(430,temp_cha_no)[0] == true && $cardi[temp_card_no] == 0 #アウトサイダー 
          $cardi[temp_card_no] = $game_actors[temp_cha_no].class_id-1
        end
        
        #気の暴走より前に流派変更系のスキルを処理する
        #そうしないと無駄に気を消費してしまうので
        
        #気の暴走
        chk_kinobousou_ran temp_cha_no,temp_card_no
        
        #絶望への反抗
        chk_zetubo_ran temp_cha_no,temp_card_no
        
      else#ランダムスキルのみ実行
=begin
        #ミラクル全開パワー================================================
        if temp_cha_skill.index(61) != nil #ミラクル全開パワー1
          temp_skill_no = 61
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 15
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(62) != nil #ミラクル全開パワー2
          temp_skill_no = 62
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 17
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(63) != nil #ミラクル全開パワー3
          temp_skill_no = 63
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 19
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(167) != nil #ミラクル全開パワー4
          temp_skill_no = 167
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 21
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(168) != nil #ミラクル全開パワー5
          temp_skill_no = 168
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 23
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(169) != nil #ミラクル全開パワー6
          temp_skill_no = 169
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 25
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(170) != nil #ミラクル全開パワー7
          temp_skill_no = 170
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 27
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(171) != nil #ミラクル全開パワー8
          temp_skill_no = 171
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 29
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(172) != nil #ミラクル全開パワー9
          temp_skill_no = 172
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 35
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        end

        if skill_effect_flag == true
          $carda[temp_card_no] = 7
          $cardg[temp_card_no] = 7
          skill_effect_flag = false
        end
        
        if temp_cha_skill.index(64) != nil #先手1
          temp_skill_no = 64
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 15
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(65) != nil #先手2
          temp_skill_no = 65
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 18
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(66) != nil #先手3
          temp_skill_no = 66
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 21
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(173) != nil #先手4
          temp_skill_no = 173
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 24
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(174) != nil #先手5
          temp_skill_no = 174
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 27
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(175) != nil #先手6
          temp_skill_no = 175
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 30
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(176) != nil #先手7
          temp_skill_no = 176
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 33
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(177) != nil #先手8
          temp_skill_no = 177
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 36
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(178) != nil #先手9
          temp_skill_no = 178
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 42
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        end
        
        
=end
      end
      
  end
  #--------------------------------------------------------------------------
  # ● 消費MP計算
  # cha_no:キャラクターNo tec_no:必殺技番号 random_skill_run:スキルを実行するか 0:実行しない 
  #--------------------------------------------------------------------------
  def get_mp_cost cha_no,tec_no,random_skill_run=0
    #p "cha_no:" + cha_no.to_s  + "tec_no:" + tec_no.to_s

    temp_mp_cost = $data_skills[tec_no].mp_cost
    temp_cha_no = cha_no#get_ori_cha_no cha_no
    temp_cha_skill = []
    temp_skill_no = 0
    skill_effect_flag = false
    bairitu = 1.prec_f
    kakuritu = 0
    mainasu = 0
    #$game_actors[cha_no].skills[x].mp_cost.to_s.size
    #消費KIが0かチェック0であれば計算しない
    if $cha_ki_zero[$partyc.index(temp_cha_no)] == true
      temp_mp_cost = 0
    end 

    #湧き出る力====================================================
    if chk_skill_learn(58,temp_cha_no)[0] == true #湧き出る力1
      kakuritu = 6
    elsif chk_skill_learn(59,temp_cha_no)[0] == true #湧き出る力2
      kakuritu = 7
    elsif chk_skill_learn(60,temp_cha_no)[0] == true #湧き出る力3
      kakuritu = 8
    elsif chk_skill_learn(161,temp_cha_no)[0] == true #湧き出る力4
      kakuritu = 9
    elsif chk_skill_learn(162,temp_cha_no)[0] == true #湧き出る力5
      kakuritu = 10
    elsif chk_skill_learn(163,temp_cha_no)[0] == true #湧き出る力6
      kakuritu = 11
    elsif chk_skill_learn(164,temp_cha_no)[0] == true #湧き出る力7
      kakuritu = 12
    elsif chk_skill_learn(165,temp_cha_no)[0] == true #湧き出る力8
      kakuritu = 13
    elsif chk_skill_learn(166,temp_cha_no)[0] == true #湧き出る力9
      kakuritu = 15
    end
    if $cha_wakideru_rand[$partyc.index(temp_cha_no)] < kakuritu
      skill_effect_flag = true
    end
    
    if skill_effect_flag == true
      
      temp_mp_cost = 0
      $cha_wakideru_flag[$partyc.index(temp_cha_no)] = true
      skill_effect_flag = false
    end
    
    if temp_mp_cost != 0
      
      #キャラがお気に入りキャラかチェック
      if $game_variables[104] == get_ori_cha_no(temp_cha_no)
        temp_mp_cost = temp_mp_cost * 0.8
      end
      
      #条件で消費を下げる必殺技かチェック
      #10回使用でマイナス1
      if $data_skills[tec_no].element_set.index(20)
        
        $cha_skill_level[tec_no] = 0 if $cha_skill_level[tec_no] == nil

        mainasu = $cha_skill_level[tec_no] / 10
        
        temp_mp_cost = temp_mp_cost - mainasu
        
        #マイナスになってしまったとき
        if temp_mp_cost < 0
          temp_mp_cost = 0
        end
      end
      #消費mpを下げるスキルなどが付いてるかチェック
      temp_cha_no = cha_no

        set_skill_nil_to_zero temp_cha_no
        
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
        
        #気のコントロール====================================================
        if chk_skill_learn(25,temp_cha_no)[0] == true #気のコントロール1
          bairitu = 0.95
          skill_effect_flag = true 
        elsif chk_skill_learn(26,temp_cha_no)[0] == true #気のコントロール2
          bairitu = 0.91
          skill_effect_flag = true 
        elsif chk_skill_learn(27,temp_cha_no)[0] == true #気のコントロール3
          bairitu = 0.87
          skill_effect_flag = true 
        elsif chk_skill_learn(119,temp_cha_no)[0] == true #気のコントロール4
          bairitu = 0.83
          skill_effect_flag = true 
        elsif chk_skill_learn(120,temp_cha_no)[0] == true #気のコントロール5
          bairitu = 0.79
          skill_effect_flag = true 
        elsif chk_skill_learn(121,temp_cha_no)[0] == true #気のコントロール6
          bairitu = 0.75
          skill_effect_flag = true 
        elsif chk_skill_learn(122,temp_cha_no)[0] == true #気のコントロール7
          bairitu = 0.71
          skill_effect_flag = true 
        elsif chk_skill_learn(123,temp_cha_no)[0] == true #気のコントロール8
          bairitu = 0.67
          skill_effect_flag = true 
        elsif chk_skill_learn(124,temp_cha_no)[0] == true #気のコントロール9
          bairitu = 0.6
          skill_effect_flag = true 
        end
        
        if skill_effect_flag == true
          temp_mp_cost = temp_mp_cost * bairitu
          skill_effect_flag = false
        end
        
        #必殺の一撃====================================================
        if chk_skill_learn(288,temp_cha_no)[0] == true #必殺の一撃9
          bairitu = 1.25
          skill_effect_flag = true
        elsif chk_skill_learn(287,temp_cha_no)[0] == true #必殺の一撃8
          bairitu = 1.2
          skill_effect_flag = true
        elsif chk_skill_learn(286,temp_cha_no)[0] == true #必殺の一撃7
          bairitu = 1.18
          skill_effect_flag = true
        elsif chk_skill_learn(285,temp_cha_no)[0] == true #必殺の一撃6
          bairitu = 1.16
          skill_effect_flag = true
        elsif chk_skill_learn(284,temp_cha_no)[0] == true #必殺の一撃5
          bairitu = 1.14
          skill_effect_flag = true
        elsif chk_skill_learn(283,temp_cha_no)[0] == true #必殺の一撃4
          bairitu = 1.12
          skill_effect_flag = true
        elsif chk_skill_learn(282,temp_cha_no)[0] == true #必殺の一撃3
          bairitu = 1.10
          skill_effect_flag = true
        elsif chk_skill_learn(281,temp_cha_no)[0] == true #必殺の一撃2
          bairitu = 1.08
          skill_effect_flag = true
        elsif chk_skill_learn(280,temp_cha_no)[0] == true #必殺の一撃1
          bairitu = 1.06
          skill_effect_flag = true
        end
        
        if skill_effect_flag == true
          temp_mp_cost = temp_mp_cost * bairitu
          skill_effect_flag = false
        end
        
        #スタートダッシュ
        bairitu = 1.2
        if chk_skill_learn(380,temp_cha_no)[0] == true &&#スタートダッシュ3
          $battle_turn_num <= 3 && $battle_turn_num >= 1
            skill_effect_flag = true
        elsif chk_skill_learn(379,temp_cha_no)[0] == true &&#スタートダッシュ2
          $battle_turn_num <= 2 && $battle_turn_num >= 1
            skill_effect_flag = true
        elsif chk_skill_learn(378,temp_cha_no)[0] == true &&#スタートダッシュ1
          $battle_turn_num <= 1 && $battle_turn_num >= 1
            skill_effect_flag = true
        end
        
        if skill_effect_flag == true
          temp_mp_cost = temp_mp_cost * bairitu
          skill_effect_flag = false
        end
        
        #手加減
        bairitu = 0.75
        #p $cardset_cha_no.index($partyc.index(temp_cha_no)),$cardset_cha_no,temp_cha_no
        if chk_skill_learn(388,temp_cha_no)[0] == true &&#手加減4
          $cardset_cha_no.index($partyc.index(temp_cha_no)) != nil
            if $carda[$cardset_cha_no.index($partyc.index(temp_cha_no))] <= 3
              skill_effect_flag = true
            end
        elsif chk_skill_learn(387,temp_cha_no)[0] == true &&#手加減3
          $cardset_cha_no.index($partyc.index(temp_cha_no)) != nil
            if $carda[$cardset_cha_no.index($partyc.index(temp_cha_no))] <= 2
              skill_effect_flag = true
            end
        elsif chk_skill_learn(386,temp_cha_no)[0] == true &&#手加減2
          $cardset_cha_no.index($partyc.index(temp_cha_no)) != nil
            if $carda[$cardset_cha_no.index($partyc.index(temp_cha_no))] <= 1
              skill_effect_flag = true
            end
        elsif chk_skill_learn(385,temp_cha_no)[0] == true && #手加減1
          $cardset_cha_no.index($partyc.index(temp_cha_no)) != nil
            if $carda[$cardset_cha_no.index($partyc.index(temp_cha_no))] <= 0
              skill_effect_flag = true
            end
        end
        
        if skill_effect_flag == true
          temp_mp_cost = temp_mp_cost * bairitu
          skill_effect_flag = false
        end
        
        #気の暴走
        bairitu = 1.75
        if chk_kinobousou_ran(temp_cha_no,0,true) == true &&
          $cardset_cha_no.index($partyc.index(temp_cha_no)) != nil
          #流派が異なる、気カード以外、絶望への反抗、気を溜めるが無効時のみ、お気に入り
          #p $temp_cardi,
          #   "temp_cha_no:" + temp_cha_no.to_s,
          #   "$partyc.index(temp_cha_no):" + $partyc.index(temp_cha_no).to_s,
          #   "$cardset_cha_no.index($partyc.index(temp_cha_no)):" + $cardset_cha_no.index($partyc.index(temp_cha_no)).to_s
          #p $cardset_cha_no.index($partyc.index(temp_cha_no))
          
          #p $full_cha_ki_tameru_flag[temp_cha_no],$full_cha_ki_tameru_flag
          
          #前の処理で流派を変えてしまっているので、tempを見る
          if $temp_cardi[$cardset_cha_no.index($partyc.index(temp_cha_no))] != $game_actors[temp_cha_no].class_id-1 &&
            $temp_cardi[$cardset_cha_no.index($partyc.index(temp_cha_no))] != 16 && #気カード
            chk_zetubo_ran(temp_cha_no,0,true) == false && #絶望への反抗
            ($cha_ki_tameru_flag[$partyc.index(temp_cha_no)] == false || $cha_ki_tameru_flag[$partyc.index(temp_cha_no)] == true && $temp_cardi[$cardset_cha_no.index($partyc.index(temp_cha_no))] != 0 ) && #気を溜める 有効かつ必カード
            ($game_variables[104] != get_ori_cha_no(temp_cha_no) || $game_variables[104] == get_ori_cha_no(temp_cha_no) && $temp_cardi[$cardset_cha_no.index($partyc.index(temp_cha_no))] != 0) && #お気に入りキャラ
            (chk_skill_learn(643,temp_cha_no)[0] == false || chk_skill_learn(643,temp_cha_no)[0] == true && $temp_cardi[$cardset_cha_no.index($partyc.index(temp_cha_no))] != 0) && #スーパーベジータ
            (chk_skill_learn(430,temp_cha_no)[0] == false || chk_skill_learn(430,temp_cha_no)[0] == true && $temp_cardi[$cardset_cha_no.index($partyc.index(temp_cha_no))] != 0) #アウトサイダー
            skill_effect_flag = true
          end
        end
        
        if skill_effect_flag == true
          temp_mp_cost = temp_mp_cost * bairitu
          skill_effect_flag = false
        end
        
        #様子見
        if $skill_yousumi_runflag == true #実行フラグがtrueなら覚えているかをチェックする
          
          if chk_skill_learn(633,temp_cha_no)[0] == true #様子見9
            bairitu = 0.5
            skill_effect_flag = true 
          elsif chk_skill_learn(632,temp_cha_no)[0] == true #様子見8
            bairitu = 0.55
            skill_effect_flag = true 
          elsif chk_skill_learn(631,temp_cha_no)[0] == true #様子見7
            bairitu = 0.6
            skill_effect_flag = true 
          elsif chk_skill_learn(630,temp_cha_no)[0] == true #様子見6
            bairitu = 0.65
            skill_effect_flag = true 
          elsif chk_skill_learn(629,temp_cha_no)[0] == true #様子見5
            bairitu = 0.7
            skill_effect_flag = true 
          elsif chk_skill_learn(628,temp_cha_no)[0] == true #様子見4
            bairitu = 0.75
            skill_effect_flag = true 
          elsif chk_skill_learn(627,temp_cha_no)[0] == true #様子見3
            bairitu = 0.8
            skill_effect_flag = true 
          elsif chk_skill_learn(626,temp_cha_no)[0] == true #様子見2
            bairitu = 0.85
            skill_effect_flag = true 
          elsif chk_skill_learn(625,temp_cha_no)[0] == true #様子見1
            bairitu = 0.9
            skill_effect_flag = true 
          end
        end
        
        if skill_effect_flag == true
          temp_mp_cost = temp_mp_cost * bairitu
          skill_effect_flag = false
        end
      if random_skill_run != 0 #ランダムで発動するスキルを実行するか
=begin
        #湧き出る力====================================================
        if temp_cha_skill.index(58) != nil #湧き出る力1
          temp_skill_no = 58
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 10
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        
        elsif temp_cha_skill.index(59) != nil #湧き出る力2
          temp_skill_no = 59
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 13
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(60) != nil #湧き出る力3
          temp_skill_no = 60
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 16
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(161) != nil #湧き出る力4
          temp_skill_no = 161
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 19
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(162) != nil #湧き出る力5
          temp_skill_no = 162
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 22
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(163) != nil #湧き出る力6
          temp_skill_no = 163
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 25
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(164) != nil #湧き出る力7
          temp_skill_no = 164
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 28
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(165) != nil #湧き出る力8
          temp_skill_no = 165
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 31
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        elsif temp_cha_skill.index(166) != nil #湧き出る力9
          temp_skill_no = 166
          if $cha_skill_spval[temp_cha_no][temp_skill_no] >= $cha_skill_get_val[temp_skill_no]
            kakuritu = 35
            if rand(100)+1 < kakuritu
              skill_effect_flag = true
            end
          end
        end
        
        if skill_effect_flag == true
          temp_mp_cost = 0
          skill_effect_flag = false
        end
=end
      end
    end
    
    return temp_mp_cost.to_i
  end

  
  
  #--------------------------------------------------------------------------
  # ● 先手チェック
  # cha_no:キャラクターNo tec_no:必殺技番号 random_skill_run:スキルを実行するか 0:実行しない
  #--------------------------------------------------------------------------
  def get_skill_sente cha_no
    
    #temp_mp_cost = $data_skills[tec_no].mp_cost
    temp_cha_no = get_ori_cha_no cha_no
    temp_cha_skill = []
    temp_skill_no = 0
    skill_effect_flag = false
    bairitu = 1.prec_f
    kakuritu = 0
    mainasu = 0

      #
      temp_cha_no = cha_no

        set_skill_nil_to_zero temp_cha_no
        
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
        
        #先手====================================================
        if chk_skill_learn(178,temp_cha_no)[0] == true #先手9
          kakuritu = 36
          skill_effect_flag = true
        elsif chk_skill_learn(177,temp_cha_no)[0] == true #先手8
          kakuritu = 33
          skill_effect_flag = true
        elsif chk_skill_learn(176,temp_cha_no)[0] == true #先手7
          kakuritu = 30
          skill_effect_flag = true
        elsif chk_skill_learn(175,temp_cha_no)[0] == true #先手6
          kakuritu = 27
          skill_effect_flag = true
        elsif chk_skill_learn(174,temp_cha_no)[0] == true #先手5
          kakuritu = 24
          skill_effect_flag = true
        elsif chk_skill_learn(173,temp_cha_no)[0] == true #先手4
          kakuritu = 21
          skill_effect_flag = true
        elsif chk_skill_learn(66,temp_cha_no)[0] == true #先手3
          kakuritu = 18
          skill_effect_flag = true
        elsif chk_skill_learn(65,temp_cha_no)[0] == true #先手2
          kakuritu = 15
          skill_effect_flag = true
        elsif chk_skill_learn(64,temp_cha_no)[0] == true #先手1
          kakuritu = 12
          skill_effect_flag = true
        end
        
        if skill_effect_flag == true
          if $cha_sente_rand[$partyc.index(temp_cha_no)] < kakuritu
            skill_effect_flag = false
            $cha_sente_flag[$partyc.index(temp_cha_no)] = true
          end
        end
  
        #スーパーベジータ
        if chk_skill_learn(643,temp_cha_no)[0] == true #スーパーベジータ
          kakuritu = 50
          skill_effect_flag = true
        end
        
        if skill_effect_flag == true
          if $cha_sente_rand[$partyc.index(temp_cha_no)] < kakuritu
            skill_effect_flag = false
            $cha_sente_flag[$partyc.index(temp_cha_no)] = true
          end
        end
    
    return skill_effect_flag
  end  
  #--------------------------------------------------------------------------
  # ● パワーアップチェック
  # cha_no:キャラクターNo tec_no:必殺技番号 random_skill_run:スキルを実行するか 0:実行しない
  #--------------------------------------------------------------------------
  def get_skill_kiup cha_no
    
    #temp_mp_cost = $data_skills[tec_no].mp_cost
    temp_cha_no = get_ori_cha_no cha_no
    temp_cha_skill = []
    temp_skill_no = 0
    skill_effect_flag = false
    bairitu = 1.prec_f
    kakuritu = 0
    mainasu = 0

      #
      temp_cha_no = cha_no

        set_skill_nil_to_zero temp_cha_no
        
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
        
        #気を溜める====================================================
        if chk_skill_learn(211,temp_cha_no)[0] == true #気を溜める9
          kakuritu = 33
          skill_effect_flag = true
        elsif chk_skill_learn(210,temp_cha_no)[0] == true #気を溜める8
          kakuritu = 29
          skill_effect_flag = true
        elsif chk_skill_learn(209,temp_cha_no)[0] == true #気を溜める7
          kakuritu = 27
          skill_effect_flag = true
        elsif chk_skill_learn(208,temp_cha_no)[0] == true #気を溜める6
          kakuritu = 25
          skill_effect_flag = true
        elsif chk_skill_learn(207,temp_cha_no)[0] == true #気を溜める5
          kakuritu = 23
          skill_effect_flag = true
        elsif chk_skill_learn(206,temp_cha_no)[0] == true #気を溜める4
          kakuritu = 21
          skill_effect_flag = true
        elsif chk_skill_learn(205,temp_cha_no)[0] == true #気を溜める3
          kakuritu = 19
          skill_effect_flag = true
        elsif chk_skill_learn(204,temp_cha_no)[0] == true #気を溜める2
          kakuritu = 17
          skill_effect_flag = true
        elsif chk_skill_learn(203,temp_cha_no)[0] == true #気を溜める1
          kakuritu = 15
          skill_effect_flag = true
        end
        
        if skill_effect_flag == true
          if $cha_ki_tameru_rand[$partyc.index(temp_cha_no)] < kakuritu
            skill_effect_flag = false
            $cha_ki_tameru_flag[$partyc.index(temp_cha_no)] = true
          end
        end
  

    
    return skill_effect_flag
  end
end

 #--------------------------------------------------------------------------
 # ● 同調チェック
 # temp_cha_no:キャラクターNo
 #--------------------------------------------------------------------------
def chk_doutyou_run temp_cha_no

  mainasu_a = 0
  mainasu_g = 0
  #同調6
  if chk_skill_learn(615,temp_cha_no)[0] == true
    mainasu_a = 3
    mainasu_g = 3
  elsif chk_skill_learn(614,temp_cha_no)[0] == true
    #同調5
    mainasu_a = 3
    mainasu_g = 2
  elsif chk_skill_learn(613,temp_cha_no)[0] == true
    #同調4
    mainasu_a = 2
    mainasu_g = 2
  elsif chk_skill_learn(612,temp_cha_no)[0] == true
    #同調3
    mainasu_a = 2
    mainasu_g = 1
  elsif chk_skill_learn(611,temp_cha_no)[0] == true
    #同調2
    mainasu_a = 1
    mainasu_g = 1
  elsif chk_skill_learn(610,temp_cha_no)[0] == true
    #同調1
    mainasu_a = 1
    mainasu_g = 0
  end

  #結果を返す
  return mainasu_a,mainasu_g
end
 #--------------------------------------------------------------------------
 # ● 気の暴走発動チェック
 # temp_cha_no:キャラクターNo
 # temp_card_no:カードNo
 # chkflag 結果を返すのみか
 #--------------------------------------------------------------------------
def chk_kinobousou_ran temp_cha_no,temp_card_no,chkflag = false
  
  kinobousourunflag = false
  
#  #最初にチェック処理を入れないと重複して動作するので対策として入れる
#  if $cardi[temp_card_no] != $game_actors[temp_cha_no].class_id-1
    #気の暴走====================================================
    #KIの残りが一定以上なら全て流派に
    if chk_skill_learn(466,temp_cha_no)[0] == true && 
      ($game_actors[temp_cha_no].mp >= (($game_actors[temp_cha_no].maxmp * 60.prec_f / 100).ceil).prec_i)
      kinobousourunflag = true
    elsif chk_skill_learn(465,temp_cha_no)[0] == true && 
      ($game_actors[temp_cha_no].mp >= (($game_actors[temp_cha_no].maxmp * 64.prec_f / 100).ceil).prec_i)
      kinobousourunflag = true
    elsif chk_skill_learn(464,temp_cha_no)[0] == true && 
      ($game_actors[temp_cha_no].mp >= (($game_actors[temp_cha_no].maxmp * 68.prec_f / 100).ceil).prec_i)
      kinobousourunflag = true
    elsif chk_skill_learn(463,temp_cha_no)[0] == true && 
      ($game_actors[temp_cha_no].mp >= (($game_actors[temp_cha_no].maxmp * 70.prec_f / 100).ceil).prec_i)
      kinobousourunflag = true
    elsif chk_skill_learn(462,temp_cha_no)[0] == true && 
      ($game_actors[temp_cha_no].mp >= (($game_actors[temp_cha_no].maxmp * 72.prec_f / 100).ceil).prec_i)
      kinobousourunflag = true
    elsif chk_skill_learn(461,temp_cha_no)[0] == true && 
      ($game_actors[temp_cha_no].mp >= (($game_actors[temp_cha_no].maxmp * 74.prec_f / 100).ceil).prec_i)
      kinobousourunflag = true
    elsif chk_skill_learn(460,temp_cha_no)[0] == true && 
      ($game_actors[temp_cha_no].mp >= (($game_actors[temp_cha_no].maxmp * 76.prec_f / 100).ceil).prec_i)
      kinobousourunflag = true
    elsif chk_skill_learn(459,temp_cha_no)[0] == true && 
      ($game_actors[temp_cha_no].mp >= (($game_actors[temp_cha_no].maxmp * 78.prec_f / 100).ceil).prec_i)
      kinobousourunflag = true
    elsif chk_skill_learn(458,temp_cha_no)[0] == true && 
      ($game_actors[temp_cha_no].mp >= (($game_actors[temp_cha_no].maxmp * 80.prec_f / 100).ceil).prec_i)
      kinobousourunflag = true
    end
#  end
  
  if kinobousourunflag == true #発動条件を満たした
    if chkflag == false #チェックじゃない場合はカードを更新
      $cardi[temp_card_no] = $game_actors[temp_cha_no].class_id-1
    end
  end
  
  if chkflag == true #チェックフラグがONなら結果を返す
    return kinobousourunflag
  end
end


 #--------------------------------------------------------------------------
 # ● 絶望への反抗発動チェック
 # temp_cha_no:キャラクターNo
 # temp_card_no:カードNo
 # chkflag 結果を返すのみか
 #--------------------------------------------------------------------------
def chk_zetubo_ran temp_cha_no,temp_card_no,chkflag = false
  
  zetuborunflag = false
  #絶望への反抗====================================================
  #HPの残りが一定以上なら全て流派に
  if chk_skill_learn(362,temp_cha_no)[0] == true && 
    ($game_actors[temp_cha_no].hp >= (($game_actors[temp_cha_no].maxhp * 70.prec_f / 100).ceil).prec_i ||
    $game_actors[temp_cha_no].hp <= (($game_actors[temp_cha_no].maxhp * 35.prec_f / 100).ceil).prec_i)
      
    zetuborunflag = true
  elsif chk_skill_learn(361,temp_cha_no)[0] == true && 
    ($game_actors[temp_cha_no].hp >= (($game_actors[temp_cha_no].maxhp * 75.prec_f / 100).ceil).prec_i ||
    $game_actors[temp_cha_no].hp <= (($game_actors[temp_cha_no].maxhp * 30.prec_f / 100).ceil).prec_i)
      
    zetuborunflag = true
  elsif chk_skill_learn(360,temp_cha_no)[0] == true && 
    ($game_actors[temp_cha_no].hp >= (($game_actors[temp_cha_no].maxhp * 78.prec_f / 100).ceil).prec_i ||
    $game_actors[temp_cha_no].hp <= (($game_actors[temp_cha_no].maxhp * 27.prec_f / 100).ceil).prec_i)
      
    zetuborunflag = true
  elsif chk_skill_learn(359,temp_cha_no)[0] == true && 
    ($game_actors[temp_cha_no].hp >= (($game_actors[temp_cha_no].maxhp * 80.prec_f / 100).ceil).prec_i ||
    $game_actors[temp_cha_no].hp <= (($game_actors[temp_cha_no].maxhp * 25.prec_f / 100).ceil).prec_i)
      
    zetuborunflag = true
  elsif chk_skill_learn(358,temp_cha_no)[0] == true && 
    ($game_actors[temp_cha_no].hp >= (($game_actors[temp_cha_no].maxhp * 82.prec_f / 100).ceil).prec_i ||
    $game_actors[temp_cha_no].hp <= (($game_actors[temp_cha_no].maxhp * 23.prec_f / 100).ceil).prec_i)
      
    zetuborunflag = true
  elsif chk_skill_learn(357,temp_cha_no)[0] == true && 
    ($game_actors[temp_cha_no].hp >= (($game_actors[temp_cha_no].maxhp * 84.prec_f / 100).ceil).prec_i ||
    $game_actors[temp_cha_no].hp <= (($game_actors[temp_cha_no].maxhp * 21.prec_f / 100).ceil).prec_i)
      
    zetuborunflag = true
  elsif chk_skill_learn(356,temp_cha_no)[0] == true && 
    ($game_actors[temp_cha_no].hp >= (($game_actors[temp_cha_no].maxhp * 86.prec_f / 100).ceil).prec_i ||
    $game_actors[temp_cha_no].hp <= (($game_actors[temp_cha_no].maxhp * 19.prec_f / 100).ceil).prec_i)
      
    zetuborunflag = true
  elsif chk_skill_learn(355,temp_cha_no)[0] == true && 
    ($game_actors[temp_cha_no].hp >= (($game_actors[temp_cha_no].maxhp * 88.prec_f / 100).ceil).prec_i ||
    $game_actors[temp_cha_no].hp <= (($game_actors[temp_cha_no].maxhp * 17.prec_f / 100).ceil).prec_i)
      
    zetuborunflag = true
  elsif chk_skill_learn(354,temp_cha_no)[0] == true && 
    ($game_actors[temp_cha_no].hp >= (($game_actors[temp_cha_no].maxhp * 90.prec_f / 100).ceil).prec_i ||
    $game_actors[temp_cha_no].hp <= (($game_actors[temp_cha_no].maxhp * 15.prec_f / 100).ceil).prec_i)
      
    zetuborunflag = true
  end
  
  if zetuborunflag == true #発動条件を満たした
    if chkflag == false #チェックじゃない場合はカードを更新
      $cardi[temp_card_no] = $game_actors[temp_cha_no].class_id-1
    end
  end
  
  if chkflag == true #チェックフラグがONなら結果を返す
    return zetuborunflag
  end
end
 #--------------------------------------------------------------------------
 # ● 光の旅チェック
 # temp_cha_no:キャラクターNo
 #--------------------------------------------------------------------------
def chk_hikarinotabirun temp_cha_no
  
  hikaritrun = 0 #0なら取得していないという判定で
  meterdot = 0 #メーターの増加量
  #光の旅====================================================
  #HPの残りが一定以上なら全て流派に
  if chk_skill_learn(620,temp_cha_no)[0] == true
    hikaritrun = 6
    meterdot = 10
  elsif chk_skill_learn(621,temp_cha_no)[0] == true
    hikaritrun = 5
    meterdot = 12
  elsif chk_skill_learn(622,temp_cha_no)[0] == true
    hikaritrun = 4
    meterdot = 16
  elsif chk_skill_learn(623,temp_cha_no)[0] == true
    hikaritrun = 3
    meterdot = 20
  elsif chk_skill_learn(624,temp_cha_no)[0] == true
    hikaritrun = 2
    meterdot = 32
  end

  return hikaritrun,meterdot

end

 #--------------------------------------------------------------------------
 # ● 慈愛の心
 # temp_cha_no:キャラクターNo
 #--------------------------------------------------------------------------
def chk_ziairun temp_cha_no
  
  ziairunflag = false
  #慈愛の心====================================================
  #覚えていれば発動
  
  if chk_skill_learn(427,temp_cha_no)[0] == true
    ziairunflag = true
  elsif chk_skill_learn(426,temp_cha_no)[0] == true
    ziairunflag = true
  elsif chk_skill_learn(57,temp_cha_no)[0] == true
    ziairunflag = true
  end

  return ziairunflag

end

 #--------------------------------------------------------------------------
 # ● 鋼の意思
 # temp_cha_no:キャラクターNo
 #--------------------------------------------------------------------------
def chk_haganenoishirun temp_cha_no
  
  haganerunflag = false
  #鋼の意思====================================================
  #覚えていれば発動
  if chk_skill_learn(619,temp_cha_no)[0] == true
    haganerunflag = true
  end

  return haganerunflag

end

 #--------------------------------------------------------------------------
 # ● 一か八か
 # temp_cha_no:キャラクターNo
 #--------------------------------------------------------------------------
def chk_itikabatikarun temp_cha_no
  
  itibatirunflag = false
  #一か八か====================================================
  #覚えていれば発動
  if chk_skill_learn(618,temp_cha_no)[0] == true
    itibatirunflag = true
   end

  return itibatirunflag

end

 #--------------------------------------------------------------------------
 # ● かばう
 # temp_cha_no:ターゲットキャラクターNo
 #--------------------------------------------------------------------------
def chk_kabau temp_cha_no
  $battle_kabau_runcha = nil #初期化
  $battle_kabau_runskill = nil
  $battle_kabawareru_runcha = nil
  kabaurunflag = false
  sort_cardset_cha_no = [] #並び順で発動優先度を指定したいので、ソートようの変数
  kabauruncha_no = [] #かばう実行条件を満たしたキャラ(さらに条件を組むかもしれないので、とりあえず配列)
  kabaurunskill_no = [] #実行するかばうスキルNo
  #かばわれる対象のHPが瀕死状態か
  if ($game_actors[temp_cha_no].hp.prec_f / $game_actors[temp_cha_no].maxhp.prec_f * 100).prec_i < $hinshi_hp
    
    #カードを元に戦闘参加キャラを特定する
    for x in 0..$cardset_cha_no.size - 1
      if $cardset_cha_no[x] != 99 #選択されているカードである
        sort_cardset_cha_no << $cardset_cha_no[x]
      end
    end
    
    #並びの昇順にソート
    sort_cardset_cha_no.sort

    for x in 0..sort_cardset_cha_no.size - 1
      temp_kabaucha_no = $partyc[sort_cardset_cha_no[x]]
      #ターゲット自身ではない
      #そのキャラのHPはピンチ状態になっていない
      #かつかなしばりになっていない
      if temp_cha_no != temp_kabaucha_no &&
        ($game_actors[temp_kabaucha_no].hp.prec_f / $game_actors[temp_kabaucha_no].maxhp.prec_f * 100).prec_i >= $hinshi_hp &&
        $cha_stop_num[sort_cardset_cha_no[x]] == 0

        if chk_skill_learn(279,temp_kabaucha_no)[0] == true
          kabauruncha_no << sort_cardset_cha_no[x]
          kabaurunskill_no << 279
        elsif chk_skill_learn(278,temp_kabaucha_no)[0] == true
          kabauruncha_no << sort_cardset_cha_no[x]
          kabaurunskill_no << 278
        elsif chk_skill_learn(277,temp_kabaucha_no)[0] == true
          kabauruncha_no << sort_cardset_cha_no[x]
          kabaurunskill_no << 277
        elsif chk_skill_learn(276,temp_kabaucha_no)[0] == true
          kabauruncha_no << sort_cardset_cha_no[x]
          kabaurunskill_no << 276
        elsif chk_skill_learn(275,temp_kabaucha_no)[0] == true
          kabauruncha_no << sort_cardset_cha_no[x]
          kabaurunskill_no << 275
        elsif chk_skill_learn(274,temp_kabaucha_no)[0] == true
          kabauruncha_no << sort_cardset_cha_no[x]
          kabaurunskill_no << 274
        elsif chk_skill_learn(273,temp_kabaucha_no)[0] == true
          kabauruncha_no << sort_cardset_cha_no[x]
          kabaurunskill_no << 273
        elsif chk_skill_learn(272,temp_kabaucha_no)[0] == true
          kabauruncha_no << sort_cardset_cha_no[x]
          kabaurunskill_no << 272
        elsif chk_skill_learn(271,temp_kabaucha_no)[0] == true
          kabauruncha_no << sort_cardset_cha_no[x]
          kabaurunskill_no << 271
        end
      end
    end

    if kabauruncha_no != nil
      kabaurunflag = true
      $battle_kabau_runcha = kabauruncha_no[0]
      $battle_kabau_runskill =  kabaurunskill_no[0]
      $battle_kabawareru_runcha = temp_cha_no
    end

  end
  return kabaurunflag

end

 #--------------------------------------------------------------------------
 # ● 剛腕
 # temp_cha_no:キャラクターNo
 #--------------------------------------------------------------------------
def chk_gouwanrun temp_cha_no
  
  gouwanflag = false
  #剛腕====================================================
  #覚えていれば発動
  if chk_skill_learn(705,temp_cha_no)[0] == true #剛腕9
    gouwanflag = true
  elsif chk_skill_learn(704,temp_cha_no)[0] == true #剛腕8
    gouwanflag = true
  elsif chk_skill_learn(703,temp_cha_no)[0] == true #剛腕7
    gouwanflag = true
  elsif chk_skill_learn(702,temp_cha_no)[0] == true #剛腕6
    gouwanflag = true
  elsif chk_skill_learn(701,temp_cha_no)[0] == true #剛腕5
    gouwanflag = true
  elsif chk_skill_learn(700,temp_cha_no)[0] == true #剛腕4
    gouwanflag = true
  elsif chk_skill_learn(699,temp_cha_no)[0] == true #剛腕3
    gouwanflag = true
  elsif chk_skill_learn(698,temp_cha_no)[0] == true #剛腕2
    gouwanflag = true
  elsif chk_skill_learn(697,temp_cha_no)[0] == true #剛腕1
    gouwanflag = true
  end
  return gouwanflag

end