module Share_Sub_procedure

#==============================================================================
# ■ 戦闘参加人数カウント
#------------------------------------------------------------------------------
# 　mode:0 #味方 , :1 #敵
#==============================================================================
  def battle_join_count mode = 0
    #戦闘参加人数カウント
    tmp_battle_join_count = 0
    
    if mode == 0
      #味方
      for y in 0..$cardset_cha_no.size - 1
        if $cardset_cha_no[y] != 99 #99はセットしていないということなので無視
          tmp_battle_join_count += 1
        end
      end
    else
      
    end
    
    return tmp_battle_join_count
  end
#==============================================================================
# ■ 文字列の調整
#------------------------------------------------------------------------------
# 　引数　mozi:調整したい文字
#   戻値　text_list:位置行ごとの配列状態の文字
#==============================================================================
  def text_Adjust mozi = ""
    
    temp_mozi = mozi
    temp_mozi = temp_mozi.gsub("\\n","\n")
    #temp_mozi = convert_special_characters temp_mozi
    text_list=[]
    x = 0
    temp_mozi.each_line {|line| #改行を読み取り複数行表示する
          line.sub!("￥n", "") # ￥は半角に直す
          line = line.gsub("\r", "")#改行コード？が文字化けするので削除
          line = line.gsub("\n", "")#
          line = line.gsub(" ", "")#半角スペースも削除
          text_list[x]=line
          #p text,text_list[x]
          x += 1
          
    }
    #p text_list.size,text_list
    return text_list
  end
end