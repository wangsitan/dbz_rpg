module Share_Sub_card_compo
  
  #--------------------------------------------------------------------------
  # ● カード合成を設定する
  #--------------------------------------------------------------------------
  def set_card_compo
      $card_compo_count = 0 #カウント
      $card_compo_cha_count = [] #何枚で合成か
      #$card_compo_get_flag = [] #取得済みか
      $card_compo_cha = [] #合成元カード
      $card_compo_get_cha = [] #合成で完成するカード
      $card_compo_percent = [] #成功率
      $card_compo_chk_flag = [] #Sコンボ有効 フラグ0:なし 1:スイッチ 2:変数
      $card_compo_chk_flag_no = [] #Sコンボフラグナンバー
      $card_compo_chk_flag_process = [] #チェック方法 0:一致 1:以上 2:以下
      $card_compo_chk_flag_value = [] #チェック値
      

      v_count = 0
      fname = "Data/_card_compo.rvdata" #ファイル順を上にしたから_残す
      
      kugiri = "`"
      obj = load_data(fname)#("Data/_chaskill.rvdata")
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
              #p tmp_arr
              case v
                #0はNo、1は漢字を含む名前
                when 3 #合成元カード
                  $card_compo_cha[i-1] = tmp_arr
                when 4 #合成で完成するカード
                  $card_compo_get_cha[i-1] = tmp_arr
                when 5 #何枚で合成か
                  $card_compo_cha_count[i-1] = tmp_arr
                when 6 #成功率
                  $card_compo_percent[i-1] = tmp_arr
                when 7 #有効フラグ
                  $card_compo_chk_flag[i-1] = tmp_arr
                when 8 #フラグナンバー
                  $card_compo_chk_flag_no[i-1] = tmp_arr
                when 9 #チェック方法
                  $card_compo_chk_flag_process[i-1] = tmp_arr
                when 10 #チェック値
                  $card_compo_chk_flag_value[i-1] = tmp_arr
              end
            end
          end

           $card_compo_count += 1
         end
    $card_compo_count -= 1
  end
end
