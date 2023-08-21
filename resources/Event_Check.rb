#==============================================================================
# ■ Event_Check
#------------------------------------------------------------------------------
# 　イベント発生位置チェック
#==============================================================================
class Event_Check
  
  #--------------------------------------------------------------------------
  # ● イベント発生位置チェック
  # 　 マップIDとXY座標を読みイベント対象位置であれば実行
  #    変数[41]:イベントNo [44]:ショップ商品No
  #-------------------------------------------------------------------------- 
  def event_check
    

    case $game_variables[13] #マップID
    
    when 58 #時の間出入り口
        
      if $game_variables[1] == 22 && $game_variables[2] == 14 #出口
        $game_variables[41] = 16
      elsif $game_variables[1] >= 5 && $game_variables[2] == 1 && #Z1
        $game_variables[1] <= 6 && $game_variables[2] == 1
        $game_variables[41] = 9001
      elsif $game_variables[1] >= 16 && $game_variables[2] == 1 && #Z2
        $game_variables[1] <= 17 && $game_variables[2] == 1
        $game_variables[41] = 9002
      elsif $game_variables[1] >= 27 && $game_variables[2] == 1 && #Z3
        $game_variables[1] <= 28 && $game_variables[2] == 1
        $game_variables[41] = 9003
      elsif $game_variables[1] >= 38 && $game_variables[2] == 1 && #Z4
        $game_variables[1] <= 39 && $game_variables[2] == 1
        $game_variables[41] = 9004
      elsif $game_variables[1] >= 49 && $game_variables[2] == 1 && #Z4
        $game_variables[1] <= 50 && $game_variables[2] == 1
        $game_variables[41] = 9005  
      elsif $game_variables[1] == 21 && $game_variables[2] == 6 #パーティー変更
        $game_variables[41] = 9051
      #elsif $game_variables[1] == 2 && $game_variables[2] == 13 #レシピ初期化
      #  $game_variables[41] = 9091
      elsif $game_variables[1] == 23 && $game_variables[2] == 6 && #カード
         $game_switches[860] == true
         $game_switches[866] = true #強制的にショップを出す
        chk_card
      elsif $game_variables[1] == 19 && $game_variables[2] == 13 #説明マス
        $game_variables[41] = 9021
      elsif $game_variables[1] == 25 && $game_variables[2] == 13 #戦闘練習
        $game_variables[41] = 9031
      elsif $game_variables[1] == 22 && $game_variables[2] == 5 #闘技場
        $game_variables[41] = 90001
        #$game_variables[41] = 90901
        #$game_variables[41] = 100001
        #$game_variables[41] = 100081
      else
        $game_variables[41] = 0
      end
      
    when 59 #時の間 Z1
        
      if $game_variables[1] == 15 && $game_variables[2] == 6 #パーティー変更
        $game_variables[41] = 9051
      elsif $game_variables[1] >= 15 && $game_variables[2] == 11 #出入り口に戻る
        $game_variables[1] <= 16 && $game_variables[2] == 11
        
        $game_variables[41] = 9101
      elsif $game_variables[1] == 3 && $game_variables[2] == 2 #ラディッツエリアに移動
        $game_variables[41] = 9102
      elsif $game_variables[1] == 8 && $game_variables[2] == 2 #ガーリックエリアに移動
        $game_variables[41] = 9111
      elsif $game_variables[1] == 13 && $game_variables[2] == 2 #界王エリアに移動
        $game_variables[41] = 9121
      elsif $game_variables[1] == 18 && $game_variables[2] == 2 #ベジータエリアに移動
        $game_variables[41] = 9131
      elsif $game_variables[1] == 23 && $game_variables[2] == 2 #ウィローエリアに移動
        $game_variables[41] = 9141
      elsif $game_variables[1] == 28 && $game_variables[2] == 2 #バーダック編エリアに移動
        $game_variables[41] = 9151
      elsif $game_variables[1] == 14 && $game_variables[2] == 10 #時の間出入り口に移動
        $game_variables[41] = 9011
      elsif $game_variables[1] == 30 && $game_variables[2] == 6 #時の間Z2に移動
        $game_variables[41] = 9299
      else
        $game_variables[41] = 0
      end
    when 66 #時の間 Z2
        
      if $game_variables[1] == 15 && $game_variables[2] == 6 #パーティー変更
        $game_variables[41] = 9051
      elsif $game_variables[1] >= 15 && $game_variables[2] == 11 && #出入り口に戻る
        $game_variables[1] <= 16 && $game_variables[2] == 11
        
        $game_variables[41] = 9301
      elsif $game_variables[1] == 3 && $game_variables[2] == 2 #キュイエリアに移動
        $game_variables[41] = 9302
      elsif $game_variables[1] == 8 && $game_variables[2] == 2 #ドドリアエリアに移動
        $game_variables[41] = 9311
      elsif $game_variables[1] == 13 && $game_variables[2] == 2 #ザーボンエリアに移動
        $game_variables[41] = 9321
      elsif $game_variables[1] == 18 && $game_variables[2] == 2 #ギニューエリアに移動
        $game_variables[41] = 9331
      elsif $game_variables[1] == 23 && $game_variables[2] == 2 #フリーザエリアに移動
        $game_variables[41] = 9341
      elsif $game_variables[1] == 28 && $game_variables[2] == 2 #Z2バーダック編エリアに移動
        $game_variables[41] = 9351
      elsif $game_variables[1] == 14 && $game_variables[2] == 10 #時の間出入り口に移動
        $game_variables[41] = 9011
      elsif $game_variables[1] == 1 && $game_variables[2] == 6 #時の間Z1に移動
        $game_variables[41] = 9498
      elsif $game_variables[1] == 30 && $game_variables[2] == 6 #時の間Z3に移動
        $game_variables[41] = 9499
      else
        $game_variables[41] = 0
      end
    when 72 #時の間 Z3
        
      if $game_variables[1] == 15 && $game_variables[2] == 6 #パーティー変更
        $game_variables[41] = 9051
      elsif $game_variables[1] >= 15 && $game_variables[2] == 11 && #出入り口に戻る
        $game_variables[1] <= 16 && $game_variables[2] == 11
        
        $game_variables[41] = 9501
      elsif $game_variables[1] == 3 && $game_variables[2] == 2 #クラズエリアに移動
        $game_variables[41] = 9502
      elsif $game_variables[1] == 8 && $game_variables[2] == 2 #ピラールエリアに移動
        $game_variables[41] = 9551
      elsif $game_variables[1] == 13 && $game_variables[2] == 2 #ピラールエリアに移動
        $game_variables[41] = 9511
      elsif $game_variables[1] == 18 && $game_variables[2] == 2 #カイズエリアに移動
        $game_variables[41] = 9521
      elsif $game_variables[1] == 23 && $game_variables[2] == 2 #クウラエリアに移動
        $game_variables[41] = 9531
      elsif $game_variables[1] == 28 && $game_variables[2] == 2 #人造人間エリアに移動
        $game_variables[41] = 9541
      elsif $game_variables[1] == 14 && $game_variables[2] == 10 #時の間出入り口に移動
        $game_variables[41] = 9011
      elsif $game_variables[1] == 1 && $game_variables[2] == 6 #時の間Z2に移動
        $game_variables[41] = 9698
      elsif $game_variables[1] == 30 && $game_variables[2] == 6 #時の間Z4に移動
        $game_variables[41] = 9699
      else
        $game_variables[41] = 0
      end
    when 85,86 #時の間 Z4
        
      if $game_variables[1] == 18 && $game_variables[2] == 6 && $game_variables[13] == 86 || #Z4クリア前 #パーティー変更
        $game_variables[1] == 23 && $game_variables[2] == 6 && $game_variables[13] == 85
        $game_variables[41] = 9051
      elsif $game_variables[1] >= 18 && $game_variables[2] == 11 && #出入り口に戻る
        $game_variables[1] <= 19 && $game_variables[2] == 11 && $game_variables[13] == 86 || #Z4クリア前
        $game_variables[1] >= 23 && $game_variables[2] == 11 && #出入り口に戻る
        $game_variables[1] <= 24 && $game_variables[2] == 11 && $game_variables[13] == 85 #Z4クリア後
        $game_variables[41] = 9701
      elsif $game_variables[1] == 3 && $game_variables[2] == 2 #Z4ウィローエリアに移動
        $game_variables[41] = 9702
      elsif $game_variables[1] == 8 && $game_variables[2] == 2 #Z4セル第一形態エリアに移動
        $game_variables[41] = 9711
      elsif $game_variables[1] == 13 && $game_variables[2] == 2 #Z4セル第二形態に移動
        $game_variables[41] = 9721
      elsif $game_variables[1] == 18 && $game_variables[2] == 2 #Z4メタルクウラに移動
        $game_variables[41] = 9731
      elsif $game_variables[1] == 23 && $game_variables[2] == 2 #Z4ビッグゲテスターに移動
        $game_variables[41] = 9741
      elsif $game_variables[1] == 28 && $game_variables[2] == 2 #Z413号人造人間エリアに移動
        $game_variables[41] = 9751
      elsif $game_variables[1] == 33 && $game_variables[2] == 2 #Z4セルゲームエリアに移動
        $game_variables[41] = 9771
      elsif $game_variables[1] == 38 && $game_variables[2] == 2 #Z4絶望への反抗エリアに移動
        $game_variables[41] = 9781
      elsif $game_variables[1] == 43 && $game_variables[2] == 2 #Z4もう一つの結末！！未来はオレが守るエリアに移動
        $game_variables[41] = 9791
      elsif $game_variables[1] == 17 && $game_variables[2] == 10 && $game_variables[13] == 86 || #Z4クリア前 時の間出入り口に移動
        $game_variables[1] == 22 && $game_variables[2] == 10 && $game_variables[13] == 85 #Z4クリア後 時の間出入り口に移動
        $game_variables[41] = 9011
      elsif $game_variables[1] == 1 && $game_variables[2] == 6 #時の間Z3に移動
        $game_variables[41] = 9898
      elsif $game_variables[1] == 45 && $game_variables[2] == 6 #時の間Z5に移動
        $game_variables[41] = 9899
      else
        $game_variables[41] = 0
      end
    when 96 #時の間 ZG
        
      if $game_variables[1] == 15 && $game_variables[2] == 6 #パーティー変更
        $game_variables[41] = 9051
      elsif $game_variables[1] >= 15 && $game_variables[2] == 11 && #出入り口に戻る
        $game_variables[1] <= 16 && $game_variables[2] == 11
        
        $game_variables[41] = 9901
      elsif $game_variables[1] == 3 && $game_variables[2] == 2 #ブロリーエリアに移動
        $game_variables[41] = 9902
      elsif $game_variables[1] == 8 && $game_variables[2] == 2 #ボージャックエリアに移動
        $game_variables[41] = 9911
      elsif $game_variables[1] == 13 && $game_variables[2] == 2 #エピソードオブバーダックエリアに移動
        $game_variables[41] = 9921
      elsif $game_variables[1] == 18 && $game_variables[2] == 2 #Z外伝エリアに移動
        $game_variables[41] = 9931
      elsif $game_variables[1] == 23 && $game_variables[2] == 2 #パイクーハンエリアに移動
        $game_variables[41] = 9941
      elsif $game_variables[1] == 28 && $game_variables[2] == 2 #ラスボスエリアに移動
        $game_variables[41] = 9951
      elsif $game_variables[1] == 14 && $game_variables[2] == 10 #時の間出入り口に移動
        $game_variables[41] = 9011
      elsif $game_variables[1] == 1 && $game_variables[2] == 6 #時の間Z4に移動
        $game_variables[41] = 9998
      #elsif $game_variables[1] == 30 && $game_variables[2] == 6 #時の間Z3に移動
      #  $game_variables[41] = 9999
      else
        $game_variables[41] = 0
      end
    when 60 #Z1フィールド1 時の間
      
      #[1]マップX [2]マップY
      if $game_variables[1] == 15 && $game_variables[2] == 16 #時の間に戻る
        $game_variables[41] = 9103
        
      elsif $game_variables[1] == 13 && $game_variables[2] == 21 || #宿
       $game_variables[1] == 30 && $game_variables[2] == 15 ||
       $game_variables[1] == 2 && $game_variables[2] == 11 ||
       $game_variables[1] == 19 && $game_variables[2] == 5 ||
       $game_variables[1] == 44 && $game_variables[2] == 11 ||
       $game_variables[1] == 53 && $game_variables[2] == 20
        $game_variables[41] = 11
        
      elsif $game_variables[1] == 7 && $game_variables[2] == 3 || #カード
        $game_variables[1] == 30 && $game_variables[2] == 9 ||
        $game_variables[1] == 57 && $game_variables[2] == 19 ||
        $game_variables[1] == 61 && $game_variables[2] == 27
        
        chk_card

      elsif $game_variables[1] == 30 && $game_variables[2] == 5 || #修行
        $game_variables[1] == 25 && $game_variables[2] == 20 ||
        $game_variables[1] == 52 && $game_variables[2] == 19 ||
        $game_variables[1] == 53 && $game_variables[2] == 19 ||
        $game_variables[1] == 54 && $game_variables[2] == 19 ||
        $game_variables[1] == 52 && $game_variables[2] == 20 ||
        $game_variables[1] == 54 && $game_variables[2] == 20 ||
        $game_variables[1] == 52 && $game_variables[2] == 21 ||
        $game_variables[1] == 53 && $game_variables[2] == 21 ||
        $game_variables[1] == 54 && $game_variables[2] == 21

        chk_training

      #ラディッツ
      elsif $game_variables[1] >= 57 && $game_variables[1] <= 59 &&
        $game_variables[2] >= 4 && $game_variables[2] <= 6
        
          $game_variables[41] = 9104
      
      else
        $game_variables[41] = 0
      end
    when 61 #Z1ガーリックエリア
      if $game_variables[1] == 5 && $game_variables[2] == 24 #時の間に戻る
        $game_variables[41] = 9112
        
      elsif $game_variables[1] == 3 && $game_variables[2] == 2 || #カード
        $game_variables[1] == 50 && $game_variables[2] == 11
        chk_card
      
      elsif $game_variables[1] == 6 && $game_variables[2] == 2 || #修行
        $game_variables[1] == 13 && $game_variables[2] == 22 ||
        $game_variables[1] == 37 && $game_variables[2] == 6 ||
        $game_variables[1] == 39 && $game_variables[2] == 20
        
        chk_training
        
      elsif $game_variables[1] == 3 && $game_variables[2] == 24 || #宿
       $game_variables[1] == 20 && $game_variables[2] == 3 ||
       $game_variables[1] == 46 && $game_variables[2] == 24
        $game_variables[41] = 11
        
      #elsif $game_variables[1] == 53 && $game_variables[2] == 14 && $game_switches[59] == false #ガーリック３人衆
      #  $game_variables[41] = 117
      elsif $game_variables[1] == 54 && $game_variables[2] == 5 #ガーリック
        $game_variables[41] = 9113
      else
        $game_variables[41] = 0
      end
    when 62 #Z1界王様修行
      if $game_variables[1] == 6 && $game_variables[2] == 3 #時の間に戻る
        $game_variables[41] = 9122  
      elsif $game_variables[1] == 6 && $game_variables[2] == 7 || #カード
        $game_variables[1] == 13 && $game_variables[2] == 5
        chk_card
        
      elsif $game_variables[1] == 7 && $game_variables[2] == 4 #宿
        $game_variables[41] = 11
        
      elsif $game_variables[1] == 6 && $game_variables[2] == 4 || #修行
        $game_variables[1] == 8 && $game_variables[2] == 3 ||
        $game_variables[1] == 10 && $game_variables[2] == 3 ||
        $game_variables[1] == 9 && $game_variables[2] == 8 ||
        $game_variables[1] == 11 && $game_variables[2] == 8
        
        $game_variables[41] = 9123
        
      else
        $game_variables[41] = 0
      end
    
    when 63 #Z1ベジータエリア
        
      if $game_variables[1] == 2 && $game_variables[2] == 34 #時の間に戻る
        $game_variables[41] = 9132  
      elsif $game_variables[1] == 18 && $game_variables[2] == 30 #カード
        chk_card
      elsif $game_variables[1] == 59 && $game_variables[2] == 18 #カード特殊
        $game_variables[44] = 10
        chk_card
      elsif $game_variables[1] == 4 && $game_variables[2] == 28 || #修行
        $game_variables[1] == 11 && $game_variables[2] == 32 ||
        $game_variables[1] == 31 && $game_variables[2] == 28 ||
        $game_variables[1] == 39 && $game_variables[2] == 20
        
        chk_training
        
      elsif $game_variables[1] == 5 && $game_variables[2] == 36 || #宿
       $game_variables[1] == 24 && $game_variables[2] == 4 ||
       $game_variables[1] == 48 && $game_variables[2] == 21
        $game_variables[41] = 11
      elsif $game_variables[1] == 55 && $game_variables[2] == 8 #ナッパ
        $game_variables[41] = 9133
      elsif $game_variables[1] == 55 && $game_variables[2] == 6 #ベジータ
        $game_variables[41] = 9134
      else
        $game_variables[41] = 0
      end
    when 64 #Z1ウィローエリア(要塞)
        
      if $game_variables[1] == 34 && $game_variables[2] == 34 #時の間に戻る
        $game_variables[41] = 9142  
      elsif $game_variables[1] == 27 && $game_variables[2] == 8 || #カード
        $game_variables[1] == 49 && $game_variables[2] == 32
        chk_card
      elsif $game_variables[1] == 3 && $game_variables[2] == 7 #カード特殊
        $game_variables[44] = 10
        chk_card
      elsif $game_variables[1] == 7 && $game_variables[2] == 26 || #修行
        $game_variables[1] == 42 && $game_variables[2] == 20
        chk_training
        
      elsif $game_variables[1] == 13 && $game_variables[2] == 15 || #宿
       $game_variables[1] == 40 && $game_variables[2] == 34
        $game_variables[41] = 11
      elsif $game_variables[1] == 5 && $game_variables[2] == 12 #バイオ戦士
        $game_variables[41] = 9143
      elsif $game_variables[1] == 5 && $game_variables[2] == 4 ||
        $game_variables[1] == 6 && $game_variables[2] == 5 ||
        $game_variables[1] == 7 && $game_variables[2] == 4
        $game_variables[41] = 9144
      else
        $game_variables[41] = 0
      end
    #Z2時の間
    when 67 #Z2キュイが居る洞窟
      if $game_variables[1] == 4 && $game_variables[2] == 7 || #カード
        $game_variables[1] == 1 && $game_variables[2] == 23 ||
        $game_variables[1] == 20 && $game_variables[2] == 24 ||
        $game_variables[1] == 38 && $game_variables[2] == 1
        chk_card
      elsif $game_variables[1] == 31 && $game_variables[2] == 6 #宿
        $game_variables[41] = 11
      elsif $game_variables[1] == 34 && $game_variables[2] == 6  #出入り口
        $game_variables[41] = 9303
      elsif $game_variables[1] == 5 && $game_variables[2] == 24 #キュイ
        $game_variables[41] = 9304
      else
        $game_variables[41] = 0
      end
    when 68 #Z2宇宙エリア　ドラゴンボールを集めろ！
      if $game_variables[1] == 14 && $game_variables[2] == 27 || #カード
        $game_variables[1] == 28 && $game_variables[2] == 67 ||
        $game_variables[1] == 63 && $game_variables[2] == 54 ||
        $game_variables[1] == 78 && $game_variables[2] == 71 ||
        $game_variables[1] == 75 && $game_variables[2] == 12 ||
        $game_variables[1] == 58 && $game_variables[2] == 26
        chk_card
        
      elsif $game_variables[1] == 9 && $game_variables[2] == 24 || #修行
        $game_variables[1] == 12 && $game_variables[2] == 57 ||
        $game_variables[1] == 82 && $game_variables[2] == 15
        chk_training
      elsif $game_variables[1] == 10 && $game_variables[2] == 29 || #宿
       $game_variables[1] == 15 && $game_variables[2] == 59 ||
       $game_variables[1] == 50 && $game_variables[2] == 48 ||
       $game_variables[1] == 71 && $game_variables[2] == 60 ||
       $game_variables[1] == 77 && $game_variables[2] == 21
        $game_variables[41] = 11
      elsif $game_variables[1] == 13 && $game_variables[2] == 33  #出入り口
        $game_variables[41] = 9312
      elsif $game_variables[1] == 11 && $game_variables[2] == 33 && $game_switches[97] == true #ドドリア
        $game_variables[41] = 9313
      #elsif $game_variables[1] == 63 && $game_variables[2] == 22  #ナメック星
        #$game_variables[41] = 401
      else
        $game_variables[41] = 0
      end
    when 69 #Z2ナメック星エリア２
      if $game_variables[1] == 29 && $game_variables[2] == 73 || #カード
        $game_variables[1] == 56 && $game_variables[2] == 45 ||
        $game_variables[1] == 20 && $game_variables[2] == 22 ||
        $game_variables[1] == 30 && $game_variables[2] == 2
        chk_card
      elsif $game_variables[1] == 24 && $game_variables[2] == 73 || #宿
       $game_variables[1] == 13 && $game_variables[2] == 24 ||
       $game_variables[1] == 37 && $game_variables[2] == 2 ||
       $game_variables[1] == 45 && $game_variables[2] == 48
        $game_variables[41] = 11
      elsif $game_variables[1] == 23 && $game_variables[2] == 22 || #修行
        $game_variables[1] == 26 && $game_variables[2] == 11||
       $game_variables[1] == 54 && $game_variables[2] == 52
        chk_training
      elsif $game_variables[1] == 8 && $game_variables[2] == 7 #最長老の家
        
        $game_variables[41] = 9323
      elsif $game_variables[1] == 26 && $game_variables[2] == 72  #出入り口
        $game_variables[41] = 9322
      else
        $game_variables[41] = 0
      end
    when 70 #Z2ナメック星エリア３
      if $game_variables[1] == 12 && $game_variables[2] == 12 || #カード
        $game_variables[1] == 36 && $game_variables[2] == 20
        chk_card
      elsif $game_variables[1] == 6 && $game_variables[2] == 7 || #宿
       $game_variables[1] == 54 && $game_variables[2] == 2 ||
       $game_variables[1] == 52 && $game_variables[2] == 21
        $game_variables[41] = 11
      elsif $game_variables[1] == 7 && $game_variables[2] == 16 || #修行
        $game_variables[1] == 32 && $game_variables[2] == 5 ||
        $game_variables[1] == 46 && $game_variables[2] == 11
        chk_training
      elsif $game_variables[1] == 57 && $game_variables[2] == 25 #池
        $game_variables[41] = 9333
      elsif $game_variables[1] == 4 && $game_variables[2] == 6  #出入り口
        $game_variables[41] = 9332
      else
        $game_variables[41] = 0
      end
    when 71 #Z2ナメック星エリア４
      if $game_variables[1] == 8 && $game_variables[2] == 7 || #カード
        $game_variables[1] == 10 && $game_variables[2] == 7 ||
        $game_variables[1] == 22 && $game_variables[2] == 36 ||
        $game_variables[1] == 14 && $game_variables[2] == 64 ||
        $game_variables[1] == 54 && $game_variables[2] == 62 ||
        $game_variables[1] == 45 && $game_variables[2] == 17
        chk_card
      elsif $game_variables[1] == 10 && $game_variables[2] == 69 #カード特殊
        $game_variables[44] = 20
        chk_card
      elsif $game_variables[1] == 10 && $game_variables[2] == 65 || #宿
        $game_variables[1] == 50 && $game_variables[2] == 68 ||
        $game_variables[1] == 19 && $game_variables[2] == 38 ||
        $game_variables[1] == 40 && $game_variables[2] == 23
        $game_variables[41] = 11
      elsif $game_variables[1] == 11 && $game_variables[2] == 71 || #修行
        $game_variables[1] == 48 && $game_variables[2] == 27
        chk_training
      elsif $game_variables[1] == 24 && $game_variables[2] == 4 && $game_switches[529] == true #フリーザ
        $game_variables[41] = 9343
      elsif $game_variables[1] == 23 && $game_variables[2] == 19 && $game_switches[530] == true #フリーザ第1形態
        $game_variables[41] = 9344
      elsif $game_variables[1] == 37 && $game_variables[2] == 59 && $game_switches[531] == true #フリーザ第2形態
        $game_variables[41] = 9345
      elsif $game_variables[1] == 39 && $game_variables[2] == 59 && $game_switches[119] == true #フリーザ第3形態
        $game_variables[41] = 9346
      elsif $game_variables[1] == 38 && $game_variables[2] == 58 && $game_switches[119] == true  #超ベジータ
        $game_variables[41] = 9348
      elsif $game_variables[1] == 11 && $game_variables[2] == 5 && ($game_switches[109] == true || $game_switches[119] == true) #ターレス＆スラッグ戦闘＆バーダック仲間 フリーザ撃破後であれば戦えるようにした
        $game_variables[41] = 9349 
        
      elsif $game_variables[1] == 11 && $game_variables[2] == 67 #時の間
        $game_variables[41] = 9342
      elsif $game_variables[1] == 12 && $game_variables[2] == 5 #ターレスからフリーザ2に移動
        $game_variables[41] = 9353
      elsif $game_variables[1] == 24 && $game_variables[2] == 5 #フリーザ1からフリーザ2に移動
        $game_variables[41] = 9354  
      elsif $game_variables[1] == 22 && $game_variables[2] == 17 #フリーザ2からターレスに移動
        $game_variables[41] = 9355
      elsif $game_variables[1] == 24 && $game_variables[2] == 17 #フリーザ2からフリーザ1に移動
        $game_variables[41] = 9356
      elsif $game_variables[1] == 22 && $game_variables[2] == 21 #フリーザ2から入り口に移動
        $game_variables[41] = 9357
      elsif $game_variables[1] == 24 && $game_variables[2] == 21 #フリーザ2からフリーザ4に移動
        $game_variables[41] = 9358
      elsif $game_variables[1] == 13 && $game_variables[2] == 64 #入り口からフリーザ2に移動
        $game_variables[41] = 9359
      elsif $game_variables[1] == 15 && $game_variables[2] == 66 #入り口からフリーザ4に移動
        $game_variables[41] = 9360
      elsif $game_variables[1] == 36 && $game_variables[2] == 57 #フリーザ4から入り口に移動
        $game_variables[41] = 9361
      elsif $game_variables[1] == 38 && $game_variables[2] == 56 #フリーザ4からフリーザ2に移動
        $game_variables[41] = 9362
      else
        $game_variables[41] = 0
      end
   when 73 #Z3ボールを集めろ！(時の間)
      if $game_variables[1] == 72 && $game_variables[2] == 25 || #カード
        $game_variables[1] == 36 && $game_variables[2] == 47 ||
        $game_variables[1] == 8 && $game_variables[2] == 77 ||
        $game_variables[1] == 58 && $game_variables[2] == 71
        chk_card
      elsif $game_variables[1] == 26 && $game_variables[2] == 83 || #宿
        $game_variables[1] == 17 && $game_variables[2] == 6 ||
        $game_variables[1] == 38 && $game_variables[2] == 42 ||
        $game_variables[1] == 90 && $game_variables[2] == 1
        $game_variables[41] = 11
      elsif $game_variables[1] == 61 && $game_variables[2] == 16 || #修行
        $game_variables[1] == 44 && $game_variables[2] == 48 ||
        $game_variables[1] == 69 && $game_variables[2] == 63
        chk_training
      
      elsif $game_variables[1] == 78 && $game_variables[2] == 82 #クラズ
        $game_variables[41] = 9504
      elsif $game_variables[1] == 47 && $game_variables[2] == 45 #時の間
        $game_variables[41] = 9503
      else
        $game_variables[41] = 0
      end
    when 83 #Z3魔凶星編(カリン塔 時の間)
      if $game_variables[1] == 40 && $game_variables[2] == 3 || #カード
        $game_variables[1] == 65 && $game_variables[2] == 20
        chk_card
      elsif $game_variables[1] == 4 && $game_variables[2] == 31 || #宿
        $game_variables[1] == 43 && $game_variables[2] == 40 ||
        $game_variables[1] == 65 && $game_variables[2] == 4
        $game_variables[41] = 11
      elsif $game_variables[1] == 10 && $game_variables[2] == 10 || #修行
        $game_variables[1] == 34 && $game_variables[2] == 10 ||
        $game_variables[1] == 40 && $game_variables[2] == 38 ||
        $game_variables[1] == 55 && $game_variables[2] == 13 ||
        $game_variables[1] == 67 && $game_variables[2] == 20
        chk_training
      elsif $game_variables[1] == 5 && $game_variables[2] == 1 #ガーリック
        $game_variables[41] = 9553
      elsif $game_variables[1] == 6 && $game_variables[2] == 1 #ガーリック(巨大)
        $game_variables[41] = 9554
      elsif $game_variables[1] == 46 && $game_variables[2] == 42 #時の間
        $game_variables[41] = 9552
      else
        $game_variables[41] = 0
      end
    when 74 #Z3ベジータ出撃(時の間)
      if $game_variables[1] == 51 && $game_variables[2] == 23 || #カード
        $game_variables[1] == 15 && $game_variables[2] == 2
        chk_card
      elsif $game_variables[1] == 4 && $game_variables[2] == 8 || #宿
        $game_variables[1] == 54 && $game_variables[2] == 3
        $game_variables[41] = 11
      elsif $game_variables[1] == 55 && $game_variables[2] == 16 || #修行
        $game_variables[1] == 8 && $game_variables[2] == 13
        chk_training
      elsif $game_variables[1] == 60 && $game_variables[2] == 22 #ピラール
        $game_variables[41] = 9513
      elsif $game_variables[1] == 8 && $game_variables[2] == 9 #時の間
        $game_variables[41] = 9512
      else
        $game_variables[41] = 0
      end
    when 75 #Z3ブルマ救出(時の間)
      if $game_variables[1] == 34 && $game_variables[2] == 7 || #カード
        $game_variables[1] == 58 && $game_variables[2] == 20 ||
        $game_variables[1] == 55 && $game_variables[2] == 42 ||
        $game_variables[1] == 9 && $game_variables[2] == 28
        chk_card
      elsif $game_variables[1] == 43 && $game_variables[2] == 16 || #宿
        $game_variables[1] == 23 && $game_variables[2] == 28
        $game_variables[41] = 11
      elsif $game_variables[1] == 29 && $game_variables[2] == 16 || #修行
        $game_variables[1] == 60 && $game_variables[2] == 12 ||
        $game_variables[1] == 10 && $game_variables[2] == 46 ||
        $game_variables[1] == 50 && $game_variables[2] == 34 ||
        $game_variables[1] == 32 && $game_variables[2] == 47
        chk_training
      elsif $game_variables[1] == 9 && $game_variables[2] == 16 #カイズ
        $game_variables[41] = 9523
      elsif $game_variables[1] == 30 && $game_variables[2] == 8 #時の間
        $game_variables[41] = 9522
      else
        $game_variables[41] = 0
      end
    when 76 #Z3クウラ到着(時の間)
      if $game_variables[1] == 14 && $game_variables[2] == 33 || #カード
        $game_variables[1] == 44 && $game_variables[2] == 21
        chk_card
      elsif $game_variables[1] == 12 && $game_variables[2] == 42 || #宿
        $game_variables[1] == 41 && $game_variables[2] == 45 ||
        $game_variables[1] == 51 && $game_variables[2] == 11
        $game_variables[41] = 11
      elsif $game_variables[1] == 43 && $game_variables[2] == 21 || #修行
        $game_variables[1] == 25 && $game_variables[2] == 43
        chk_training
      elsif $game_variables[1] == 16 && $game_variables[2] == 15  #クウラ
        $game_variables[41] = 9534
      elsif $game_variables[1] == 15 && $game_variables[2] == 15  #クウラきこうせんたい
        $game_variables[41] = 9533
      elsif $game_variables[1] == 45 && $game_variables[2] == 47 #時の間
        $game_variables[41] = 9532
      elsif $game_variables[1] == 53 && $game_variables[2] == 11 && #一星球
        $game_party.has_item?($data_items[2]) == false &&
        $game_switches[446] == false
        $game_variables[41] = 1431
        $game_variables[240] = 1
      elsif $game_variables[1] == 21 && $game_variables[2] == 33 && #二星球
        $game_party.has_item?($data_items[3]) == false &&
        $game_switches[446] == false
        $game_variables[41] = 1431
        $game_variables[240] = 2
      elsif $game_variables[1] == 19 && $game_variables[2] == 47 && #三星球
        $game_party.has_item?($data_items[4]) == false &&
        $game_switches[446] == false
        $game_variables[41] = 1431
        $game_variables[240] = 3
      elsif $game_variables[1] == 21 && $game_variables[2] == 11 && #四星球
        $game_party.has_item?($data_items[5]) == false &&
        $game_switches[446] == false
        $game_variables[41] = 1431
        $game_variables[240] = 4
      elsif $game_variables[1] == 25 && $game_variables[2] == 25 && #五星球
        $game_party.has_item?($data_items[6]) == false &&
        $game_switches[446] == false
        $game_variables[41] = 1431
        $game_variables[240] = 5
      elsif $game_variables[1] == 49 && $game_variables[2] == 50 && #六星球
        $game_party.has_item?($data_items[7]) == false &&
        $game_switches[446] == false
        $game_variables[41] = 1431
        $game_variables[240] = 6
      elsif $game_variables[1] == 14 && $game_variables[2] == 23 && #七星球
        $game_party.has_item?($data_items[8]) == false &&
        $game_switches[446] == false
        $game_variables[41] = 1431
        $game_variables[240] = 7
      else
        $game_variables[41] = 0
      end
    when 77 #Z3人造人間(時の間)
      if $game_variables[1] == 21 && $game_variables[2] == 19 || #カード
        $game_variables[1] == 8 && $game_variables[2] == 48 ||
        $game_variables[1] == 45 && $game_variables[2] == 45 ||
        $game_variables[1] == 59 && $game_variables[2] == 4
        chk_card
      elsif $game_variables[1] == 16 && $game_variables[2] == 21 #カード特殊
        $game_variables[44] = 30
        chk_card
      elsif $game_variables[1] == 9 && $game_variables[2] == 43 || #宿
        $game_variables[1] == 57 && $game_variables[2] == 36
        $game_variables[41] = 11
      elsif $game_variables[1] == 24 && $game_variables[2] == 44 || #修行
        $game_variables[1] == 52 && $game_variables[2] == 54 ||
        $game_variables[1] == 49 && $game_variables[2] == 6 ||
        $game_variables[1] == 21 && $game_variables[2] == 11
        chk_training
      elsif $game_variables[1] == $game_variables[308] && $game_variables[2] == $game_variables[309] #20号
        $game_variables[41] = 9543
      elsif $game_variables[1] == 9 && $game_variables[2] == 10 #17号たち
        $game_variables[41] = 9544
      elsif $game_variables[1] == 5 && $game_variables[2] == 56 #時の間
        $game_variables[41] = 9542
      elsif $game_variables[1] == 11 && $game_variables[2] == 10 #20号へ移動
        $game_variables[41] = 9545
      elsif $game_variables[1] == 61 && $game_variables[2] == 13 #18号へ移動
        $game_variables[41] = 9546
      elsif $game_variables[1] == 10 && $game_variables[2] == 9 #16号
        $game_variables[41] = 9547
      else
        $game_variables[41] = 0
      end
    when 87 #Z4セル誕生の秘密(時の間)
      if $game_variables[1] == 80 && $game_variables[2] == 3 || #カード
        $game_variables[1] == 5 && $game_variables[2] == 50 ||
        $game_variables[1] == 17 && $game_variables[2] == 2 ||
        $game_variables[1] == 77 && $game_variables[2] == 37
        chk_card
      elsif $game_variables[1] == 17 && $game_variables[2] == 43 || #宿
        $game_variables[1] == 52 && $game_variables[2] == 5 ||
        $game_variables[1] == 10 && $game_variables[2] == 2 ||
        $game_variables[1] == 61 && $game_variables[2] == 44
        $game_variables[41] = 11
      elsif $game_variables[1] == 5 && $game_variables[2] == 7 || #修行
        $game_variables[1] == 15 && $game_variables[2] == 37 ||
        $game_variables[1] == 66 && $game_variables[2] == 7 ||
        $game_variables[1] == 66 && $game_variables[2] == 36
        chk_training
      elsif $game_variables[1] == 19 && $game_variables[2] == 9 #ウィロー
        $game_variables[41] = 9704
      elsif $game_variables[1] == 67 && $game_variables[2] == 46 #時の間
        $game_variables[41] = 9703
      else
        $game_variables[41] = 0
      end
    when 88 #Z4忍び寄るセル！(時の間)
      if $game_variables[1] == 4 && $game_variables[2] == 8 || #カード
        $game_variables[1] == 51 && $game_variables[2] == 36 ||
        $game_variables[1] == 14 && $game_variables[2] == 42 ||
        $game_variables[1] == 77 && $game_variables[2] == 37
        chk_card
      elsif $game_variables[1] == 62 && $game_variables[2] == 11 || #宿
        $game_variables[1] == 10 && $game_variables[2] == 5 ||
        $game_variables[1] == 8 && $game_variables[2] == 46
        $game_variables[41] = 11
      elsif $game_variables[1] == 6 && $game_variables[2] == 11 || #修行
        $game_variables[1] == 4 && $game_variables[2] == 39 ||
        $game_variables[1] == 21 && $game_variables[2] == 25 ||
        $game_variables[1] == 48 && $game_variables[2] == 36
        chk_training
      elsif $game_variables[1] == 8 && $game_variables[2] == 41 #セル第一形態
        $game_variables[41] = 9713
      elsif $game_variables[1] == 59 && $game_variables[2] == 5 #時の間
        $game_variables[41] = 9712
      else
        $game_variables[41] = 0
      end
    when 89 #Z4新生ベジータ親子出撃！(時の間)
      if $game_variables[1] == 4 && $game_variables[2] == 43 || #カード
        $game_variables[1] == 66 && $game_variables[2] == 5 || 
        $game_variables[1] == 57 && $game_variables[2] == 46
        chk_card
      elsif $game_variables[1] == 11 && $game_variables[2] == 11 || #宿
        $game_variables[1] == 60 && $game_variables[2] == 44
        $game_variables[41] = 11
      elsif $game_variables[1] == 7 && $game_variables[2] == 15 || #修行
        $game_variables[1] == 38 && $game_variables[2] == 35 ||
        $game_variables[1] == 61 && $game_variables[2] == 4
        chk_training
      elsif $game_variables[1] == 40 && $game_variables[2] == 34 #セル第二形態
        $game_variables[41] = 9723
      elsif $game_variables[1] == 7 && $game_variables[2] == 9 #時の間
        $game_variables[41] = 9722
      else
        $game_variables[41] = 0
      end
    when 91 #Z4メタルクウラ編 ナメック星マップ(時の間)
      if $game_variables[1] == 6 && $game_variables[2] == 37 || #カード
        $game_variables[1] == 30 && $game_variables[2] == 10 ||
        $game_variables[1] == 28 && $game_variables[2] == 26 ||
        $game_variables[1] == 46 && $game_variables[2] == 32 ||
        $game_variables[1] == 58 && $game_variables[2] == 14 ||
        $game_variables[1] == 81 && $game_variables[2] == 27 ||
        $game_variables[1] == 52 && $game_variables[2] == 49
        chk_card
      elsif $game_variables[1] == 16 && $game_variables[2] == 49 || #宿
        $game_variables[1] == 43 && $game_variables[2] == 16 ||
        $game_variables[1] == 54 && $game_variables[2] == 51 ||
        $game_variables[1] == 74 && $game_variables[2] == 15 ||
        $game_variables[1] == 21 && $game_variables[2] == 8
        $game_variables[41] = 11
      elsif $game_variables[1] == 22 && $game_variables[2] == 47 || #修行
        $game_variables[1] == 8 && $game_variables[2] == 9 ||
        $game_variables[1] == 33 && $game_variables[2] == 17 ||
        $game_variables[1] == 56 && $game_variables[2] == 23 ||
        $game_variables[1] == 56 && $game_variables[2] == 53 ||
        $game_variables[1] == 78 && $game_variables[2] == 29
        chk_training
      elsif $game_variables[1] == 68 && $game_variables[2] == 3 #メタルクウラ
        $game_variables[41] = 9733
      elsif $game_variables[1] == 7 && $game_variables[2] == 48 #時の間
        $game_variables[41] = 9732
      else
        $game_variables[41] = 0
      end
    when 92 #Z4メタルクウラ編 ビッグゲテスター(時の間)
      if $game_variables[1] == 8 && $game_variables[2] == 47 || #カード
        $game_variables[1] == 50 && $game_variables[2] == 34 ||
        $game_variables[1] == 25 && $game_variables[2] == 8
        chk_card
      elsif $game_variables[1] == 3 && $game_variables[2] == 48 || #宿
        $game_variables[1] == 14 && $game_variables[2] == 12 ||
        $game_variables[1] == 37 && $game_variables[2] == 28 ||
        $game_variables[1] == 79 && $game_variables[2] == 40
        $game_variables[41] = 11
      elsif $game_variables[1] == 11 && $game_variables[2] == 53 || #修行
        $game_variables[1] == 61 && $game_variables[2] == 28 ||
        $game_variables[1] == 29 && $game_variables[2] == 17
        chk_training
      elsif $game_variables[1] == 49 && $game_variables[2] == 10 #メタルクウラコア
        $game_variables[41] = 9743
      elsif $game_variables[1] == 5 && $game_variables[2] == 51 #時の間
        $game_variables[41] = 9742
      else
        $game_variables[41] = 0
      end
    when 94 #Z4人造人間13号編(時の間)
      if $game_variables[1] == 18 && $game_variables[2] == 19 || #カード
        $game_variables[1] == 29 && $game_variables[2] == 16 ||
        $game_variables[1] == 28 && $game_variables[2] == 42 ||
        $game_variables[1] == 31 && $game_variables[2] == 14 ||
        $game_variables[1] == 46 && $game_variables[2] == 8 ||
        $game_variables[1] == 58 && $game_variables[2] == 25
        chk_card
      elsif $game_variables[1] == 13 && $game_variables[2] == 22 || #宿
        $game_variables[1] == 28 && $game_variables[2] == 18 ||
        $game_variables[1] == 38 && $game_variables[2] == 10 ||
        $game_variables[1] == 43 && $game_variables[2] == 7 ||
        $game_variables[1] == 62 && $game_variables[2] == 27
        $game_variables[41] = 11
      elsif $game_variables[1] == 11 && $game_variables[2] == 17 || #修行
        $game_variables[1] == 20 && $game_variables[2] == 38 ||
        $game_variables[1] == 27 && $game_variables[2] == 18 ||
        $game_variables[1] == 33 && $game_variables[2] == 4 ||
        $game_variables[1] == 57 && $game_variables[2] == 28 ||
        $game_variables[1] == 58 && $game_variables[2] == 15
        chk_training
      elsif $game_variables[1] == 10 && $game_variables[2] == 24 #15号
        $game_variables[41] = 9753
      elsif $game_variables[1] == 31 && $game_variables[2] == 22 #14号
        $game_variables[41] = 9754
      elsif $game_variables[1] == 65 && $game_variables[2] == 17 #13号
        $game_variables[41] = 9755
      elsif $game_variables[1] == 60 && $game_variables[2] == 29 #時の間
        $game_variables[41] = 9752
      elsif $game_variables[1] == 11 && $game_variables[2] == 23 #15から13へ移動
        $game_variables[41] = 9761
      elsif $game_variables[1] == 11 && $game_variables[2] == 25 #15から14へ移動
        $game_variables[41] = 9762
      elsif $game_variables[1] == 34 && $game_variables[2] == 21 #14から13へ移動
        $game_variables[41] = 9763
      elsif $game_variables[1] == 31 && $game_variables[2] == 21 #14から13へ移動
        $game_variables[41] = 9764
      elsif $game_variables[1] == 62 && $game_variables[2] == 17 #13から15へ移動
        $game_variables[41] = 9765
      elsif $game_variables[1] == 62 && $game_variables[2] == 19 #13から14へ移動
        $game_variables[41] = 9766
      else
        $game_variables[41] = 0
      end
   when 95 #Z4セルゲーム(時の間)
      if $game_variables[1] == 10 && $game_variables[2] == 13 || #カード
        $game_variables[1] == 8 && $game_variables[2] == 65 ||
        $game_variables[1] == 79 && $game_variables[2] == 32
        chk_card
      elsif $game_variables[1] == 38 && $game_variables[2] == 29 #カード特殊
        $game_variables[44] = 40
        chk_card
      elsif $game_variables[1] == 6 && $game_variables[2] == 42 || #宿
        $game_variables[1] == 80 && $game_variables[2] == 9 ||
        $game_variables[1] == 72 && $game_variables[2] == 66
        $game_variables[41] = 11
      elsif $game_variables[1] == 14 && $game_variables[2] == 50 || #修行
        $game_variables[1] == 30 && $game_variables[2] == 10 ||
        $game_variables[1] == 60 && $game_variables[2] == 11 ||
        $game_variables[1] == 55 && $game_variables[2] == 66
        chk_training
      elsif $game_variables[1] == 75 && $game_variables[2] == 63 #時の間
        $game_variables[41] = 9772
      elsif $game_variables[1] == 44 && $game_variables[2] == 35
        $game_variables[41] = 9773
      else
        $game_variables[41] = 0
      end
    when 1 #Z1フィールド1
      
      #[1]マップX [2]マップY
      if $game_variables[1] == 15 && $game_variables[2] == 16 #カメハウス
        $game_variables[41] = 51
      elsif $game_variables[1] == 33 && $game_variables[2] == 2 #村人A
        $game_variables[41] = 76
      elsif $game_variables[1] == 50 && $game_variables[2] == 12 #村人B
        $game_variables[41] = 77
      elsif $game_variables[1] == 26 && $game_variables[2] == 2 #村人C
        $game_variables[41] = 78
      elsif $game_variables[1] == 13 && $game_variables[2] == 21 || #宿
       $game_variables[1] == 30 && $game_variables[2] == 15 ||
       $game_variables[1] == 2 && $game_variables[2] == 11 ||
       $game_variables[1] == 19 && $game_variables[2] == 5 ||
       $game_variables[1] == 44 && $game_variables[2] == 11 ||
       $game_variables[1] == 53 && $game_variables[2] == 20
        $game_variables[41] = 11
        
      elsif $game_variables[1] == 7 && $game_variables[2] == 3 || #カード
        $game_variables[1] == 30 && $game_variables[2] == 9 ||
        $game_variables[1] == 57 && $game_variables[2] == 19 ||
        $game_variables[1] == 61 && $game_variables[2] == 27
        
        chk_card

      elsif $game_variables[1] == 30 && $game_variables[2] == 5 || #修行
        $game_variables[1] == 25 && $game_variables[2] == 20 ||
        $game_variables[1] == 52 && $game_variables[2] == 19 ||
        $game_variables[1] == 53 && $game_variables[2] == 19 ||
        $game_variables[1] == 54 && $game_variables[2] == 19 ||
        $game_variables[1] == 52 && $game_variables[2] == 20 ||
        $game_variables[1] == 54 && $game_variables[2] == 20 ||
        $game_variables[1] == 52 && $game_variables[2] == 21 ||
        $game_variables[1] == 53 && $game_variables[2] == 21 ||
        $game_variables[1] == 54 && $game_variables[2] == 21

        chk_training

      elsif $game_variables[1] == 2 && $game_variables[2] == 12 #ブルマ
        $game_variables[41] = 52
      elsif $game_variables[1] == 41 && $game_variables[2] == 21 #ウミガメ
        $game_variables[41] = 53
        
      #パンプキン(倒してないときのみ)
      elsif $game_variables[1] == 47 && $game_variables[2] == 11 && $game_switches[43] == false 
        $game_variables[41] = 54
        #$game_variables[41] = 55は戦闘処理用に使う
        
      #ブロッコ(倒してないときのみ)
      elsif $game_variables[1] == 50 && $game_variables[2] == 5 && $game_switches[44] == false
        $game_variables[41] = 56
        #$game_variables[41] = 57は戦闘処理用に使う
      
      #ラディッツ
      elsif $game_variables[1] >= 57 && $game_variables[1] <= 59 &&
        $game_variables[2] >= 4 && $game_variables[2] <= 6
        
          $game_variables[41] = 58
          #$game_variables[41] = 59は戦闘処理用に使う
      
      else
        $game_variables[41] = 0
      end
    
    when 5 #Z1蛇の道
      
      if $game_variables[1] == 12 && $game_variables[2] == 14 || #カード
        $game_variables[1] == 48 && $game_variables[2] == 31 ||
        $game_variables[1] == 62 && $game_variables[2] == 21
        
        chk_card
        
      elsif $game_variables[1] == 15 && $game_variables[2] == 24 || #修行
        $game_variables[1] == 32 && $game_variables[2] == 23 ||
        $game_variables[1] == 54 && $game_variables[2] == 16
        
        chk_training
        
      elsif $game_variables[1] == 25 && $game_variables[2] == 19 || #宿
       $game_variables[1] == 14 && $game_variables[2] == 8 ||
       $game_variables[1] == 57 && $game_variables[2] == 19
        $game_variables[41] = 11
        
      elsif $game_variables[1] == 17 && $game_variables[2] == 16 #じいちゃん
        $game_variables[41] = 80
      elsif $game_variables[1] == 41 && $game_variables[2] == 30 #ゴズ
        $game_variables[41] = 81
      elsif $game_variables[1] == 48 && $game_variables[2] == 19 #メズ
        $game_variables[41] = 82
      elsif $game_variables[1] == 71 && $game_variables[2] == 18 #蛇の尻尾
        $game_variables[41] = 83
      else
        $game_variables[41] = 0
      end
      
    when 8 #Z1サンショエリア
        
      if $game_variables[1] == 16 && $game_variables[2] == 3 || #カード
        $game_variables[1] == 24 && $game_variables[2] == 23 ||
        $game_variables[1] == 47 && $game_variables[2] == 34 ||
        $game_variables[1] == 51 && $game_variables[2] == 5 ||
        $game_variables[1] == 53 && $game_variables[2] == 5 ||
        $game_variables[1] == 55 && $game_variables[2] == 5
        
        chk_card
      
      elsif $game_variables[1] == 4 && $game_variables[2] == 17 || #修行
        $game_variables[1] == 52 && $game_variables[2] == 6 ||
        $game_variables[1] == 54 && $game_variables[2] == 6 ||
        $game_variables[1] == 57 && $game_variables[2] == 22
        
        chk_training
        
      elsif $game_variables[1] == 4 && $game_variables[2] == 4 || #宿
       $game_variables[1] == 4 && $game_variables[2] == 36 ||
       $game_variables[1] == 40 && $game_variables[2] == 21
        $game_variables[41] = 11
        
      elsif $game_variables[1] == 26 && $game_variables[2] == 17 #プーアル
        $game_variables[41] = 91
      elsif $game_variables[1] == 62 && $game_variables[2] == 31 #サンショ
        $game_variables[41] = 92
      else
        $game_variables[41] = 0
      end
        
    when 9 #Z1バブルス修行
        
      if $game_variables[1] == 7 && $game_variables[2] == 7  #カード
        
        chk_card
      
      elsif $game_variables[1] == 7 && $game_variables[2] == 4 || #修行
        $game_variables[1] == 10 && $game_variables[2] == 3 ||
        $game_variables[1] == 12 && $game_variables[2] == 6 ||
        $game_variables[1] == 9 && $game_variables[2] == 8
        
        $game_variables[41] = 36
        
      else
        $game_variables[41] = 0
        
      end
    when 10 #Z1ニッキーエリア
        
      if $game_variables[1] == 5 && $game_variables[2] == 17 || #カード
        $game_variables[1] == 62 && $game_variables[2] == 1
        
        chk_card
      
      elsif $game_variables[1] == 11 && $game_variables[2] == 3 || #修行
        $game_variables[1] == 29 && $game_variables[2] == 28
        
        chk_training
        
      elsif $game_variables[1] == 27 && $game_variables[2] == 13 || #宿
       $game_variables[1] == 54 && $game_variables[2] == 1 ||
       $game_variables[1] == 53 && $game_variables[2] ==32
        $game_variables[41] = 11
        
      elsif $game_variables[1] == 12 && $game_variables[2] == 33 #ウーロン
        $game_variables[41] = 101
      elsif $game_variables[1] == 42 && $game_variables[2] == 22 #ニッキー
        $game_variables[41] = 102
      else
        $game_variables[41] = 0
      end
    when 11 #Z1グレゴリー修行
        
      if $game_variables[1] == 6 && $game_variables[2] == 7 || #カード
        $game_variables[1] == 13 && $game_variables[2] == 5
        chk_card
      
      elsif $game_variables[1] == 6 && $game_variables[2] == 4 || #修行
        $game_variables[1] == 8 && $game_variables[2] == 3 ||
        $game_variables[1] == 10 && $game_variables[2] == 3 ||
        $game_variables[1] == 9 && $game_variables[2] == 8 ||
        $game_variables[1] == 11 && $game_variables[2] == 8
        
        $game_variables[41] = 37
        
      else
        $game_variables[41] = 0
        
      end
    when 12 #Z1ジンジャーエリア
        
      if $game_variables[1] == 5 && $game_variables[2] == 4 || #カード
        $game_variables[1] == 12 && $game_variables[2] == 19 ||
        $game_variables[1] == 39 && $game_variables[2] == 6
        chk_card
      
      elsif $game_variables[1] == 5 && $game_variables[2] == 32 || #修行
        $game_variables[1] == 28 && $game_variables[2] == 12 ||
        $game_variables[1] == 40 && $game_variables[2] == 19 ||
        $game_variables[1] == 54 && $game_variables[2] == 34
        
        chk_training
        
      elsif $game_variables[1] == 23 && $game_variables[2] == 6 || #宿
       $game_variables[1] == 39 && $game_variables[2] == 13 ||
       $game_variables[1] == 30 && $game_variables[2] == 25
        $game_variables[41] = 11
        
      elsif $game_variables[1] == 52 && $game_variables[2] == 3 #牛魔王
        $game_variables[41] = 111
      elsif $game_variables[1] == 58 && $game_variables[2] == 23 #ジンジャー
        $game_variables[41] = 112
      else
        $game_variables[41] = 0
      end
    when 13 #Z1ガーリックエリア
        
      if $game_variables[1] == 3 && $game_variables[2] == 2 || #カード
        $game_variables[1] == 50 && $game_variables[2] == 11
        chk_card
      
      elsif $game_variables[1] == 6 && $game_variables[2] == 2 || #修行
        $game_variables[1] == 13 && $game_variables[2] == 22 ||
        $game_variables[1] == 37 && $game_variables[2] == 6 ||
        $game_variables[1] == 39 && $game_variables[2] == 20
        
        chk_training
        
      elsif $game_variables[1] == 21 && $game_variables[2] == 15 #占いババ
        $game_variables[41] = 172
      elsif $game_variables[1] == 3 && $game_variables[2] == 24 || #宿
       $game_variables[1] == 20 && $game_variables[2] == 3 ||
       $game_variables[1] == 46 && $game_variables[2] == 24
        $game_variables[41] = 11
        
      elsif $game_variables[1] == 54 && $game_variables[2] == 17 && $game_switches[59] == false #ガーリック３人衆
        $game_variables[41] = 117
      elsif $game_variables[1] == 54 && $game_variables[2] == 5 #ガーリック
        $game_variables[41] = 121
      else
        $game_variables[41] = 0
      end
    when 14 #Z1界王様修行
        
      if $game_variables[1] == 6 && $game_variables[2] == 7 || #カード
        $game_variables[1] == 13 && $game_variables[2] == 5
        chk_card
      
      elsif $game_variables[1] == 6 && $game_variables[2] == 4 || #修行
        $game_variables[1] == 8 && $game_variables[2] == 3 ||
        $game_variables[1] == 10 && $game_variables[2] == 3 ||
        $game_variables[1] == 9 && $game_variables[2] == 8 ||
        $game_variables[1] == 11 && $game_variables[2] == 8
        
        $game_variables[41] = 130
        
      else
        $game_variables[41] = 0
      end
    when 15 #Z1ベジータエリア
        
      if $game_variables[1] == 18 && $game_variables[2] == 30 #カード
        chk_card
      elsif $game_variables[1] == 59 && $game_variables[2] == 18 #カード特殊
        $game_variables[44] = 10
        chk_card
      elsif $game_variables[1] == 4 && $game_variables[2] == 28 || #修行
        $game_variables[1] == 11 && $game_variables[2] == 32 ||
        $game_variables[1] == 31 && $game_variables[2] == 28 ||
        $game_variables[1] == 39 && $game_variables[2] == 20
        
        chk_training
        
      elsif $game_variables[1] == 5 && $game_variables[2] == 36 || #宿
       $game_variables[1] == 24 && $game_variables[2] == 4 ||
       $game_variables[1] == 48 && $game_variables[2] == 21
        $game_variables[41] = 11
      elsif $game_variables[1] == 5 && $game_variables[2] == 5 #チチ
        $game_variables[41] = 145
      elsif $game_variables[1] == 36 && $game_variables[2] == 7 #ミスターポポ
        $game_variables[41] = 146
      elsif $game_variables[1] == 25 && $game_variables[2] == 26 #ランチ
        $game_variables[41] = 171
      elsif $game_variables[1] == 12 && $game_variables[2] == 6 && $game_switches[66] == false #サイバイマン
        $game_variables[41] = 147
      elsif $game_variables[1] == 44 && $game_variables[2] == 29 && $game_switches[67] == false #ナッパ
        $game_variables[41] = 150
      elsif $game_variables[1] == 55 && $game_variables[2] == 6 #ベジータ
        $game_variables[41] = 154
      elsif $game_variables[1] == 58 && $game_variables[2] == 28 #時の間
        $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end

    when 50 #Z1ウィローエリア(雪原)
        
      if $game_variables[1] == 2 && $game_variables[2] == 25 || #カード
        $game_variables[1] == 28 && $game_variables[2] == 3 ||
        $game_variables[1] == 53 && $game_variables[2] == 18
        chk_card
      elsif $game_variables[1] == 2 && $game_variables[2] == 27 || #修行
        $game_variables[1] == 53 && $game_variables[2] == 16 ||
        $game_variables[1] == 16 && $game_variables[2] == 1
        
        chk_training
        
      elsif $game_variables[1] == 8 && $game_variables[2] == 31 || #宿
       $game_variables[1] == 61 && $game_variables[2] == 23 ||
       $game_variables[1] == 25 && $game_variables[2] == 3
        $game_variables[41] = 11
      elsif $game_variables[1] == 5 && $game_variables[2] == 3 || #ウィロー要塞
        $game_variables[1] == 6 && $game_variables[2] == 3 ||
        $game_variables[1] == 5 && $game_variables[2] == 4 ||
        $game_variables[1] == 6 && $game_variables[2] == 4
        $game_variables[41] = 931
      else
        $game_variables[41] = 0
      end
    when 51 #Z1ウィローエリア(要塞)
        
      if $game_variables[1] == 27 && $game_variables[2] == 8 || #カード
        $game_variables[1] == 49 && $game_variables[2] == 32
        chk_card
      elsif $game_variables[1] == 3 && $game_variables[2] == 7 #カード特殊
        $game_variables[44] = 10
        chk_card
      elsif $game_variables[1] == 7 && $game_variables[2] == 26 || #修行
        $game_variables[1] == 42 && $game_variables[2] == 20
        chk_training
        
      elsif $game_variables[1] == 13 && $game_variables[2] == 15 || #宿
       $game_variables[1] == 40 && $game_variables[2] == 34
        $game_variables[41] = 11
      elsif $game_variables[1] == 6 && $game_variables[2] == 17 && $game_switches[502] == false  #バイオ戦士
        $game_variables[41] = 941
      elsif $game_variables[1] == 5 && $game_variables[2] == 4 ||
        $game_variables[1] == 6 && $game_variables[2] == 5 ||
        $game_variables[1] == 7 && $game_variables[2] == 4
        $game_variables[41] = 951
      elsif $game_variables[1] == 10 && $game_variables[2] == 21 #時の間
        $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end
    when 31 #Z1ラディッツエリア(バーダック編)
        
      if $game_variables[1] == 32 && $game_variables[2] == 53 || #カード
        $game_variables[1] == 31 && $game_variables[2] == 30 ||
        $game_variables[1] == 20 && $game_variables[2] == 19 ||
        $game_variables[1] == 53 && $game_variables[2] == 2 ||
        $game_variables[1] == 54 && $game_variables[2] == 3
        chk_card
      
      elsif $game_variables[1] == 28 && $game_variables[2] == 55 || #修行
        $game_variables[1] == 19 && $game_variables[2] == 9 ||
        $game_variables[1] == 53 && $game_variables[2] == 3 ||
        $game_variables[1] == 54 && $game_variables[2] == 2
        chk_training
        
      elsif $game_variables[1] == 38 && $game_variables[2] == 60 || #宿
       $game_variables[1] == 14 && $game_variables[2] == 36 ||
       $game_variables[1] == 52 && $game_variables[2] == 30 ||
       $game_variables[1] == 10 && $game_variables[2] == 15 ||
       $game_variables[1] == 29 && $game_variables[2] == 4
        $game_variables[41] = 11
      elsif $game_variables[1] == 46 && $game_variables[2] == 72 #カメハウス
        $game_variables[41] = 841
      elsif $game_variables[1] == 15 && $game_variables[2] == 6 || #ラディッツ
        $game_variables[1] == 15 && $game_variables[2] == 7 ||
        $game_variables[1] == 16 && $game_variables[2] == 7
          $game_variables[41] = 831
      elsif $game_variables[1] == 33 && $game_variables[2] == 26 && $game_switches[526] == false #ポポ戦闘
        $game_variables[41] = 851
      elsif $game_variables[1] == 33 && $game_variables[2] == 26 && $game_switches[526] == true #ポポ救出後
        $game_variables[41] = 861
      elsif $game_variables[1] == 22 && $game_variables[2] == 17 #洞窟へ移動亀ハウス側
        $game_variables[41] = 871
      elsif $game_variables[1] == 18 && $game_variables[2] == 12 #洞窟へ移動ラディッツ側
        $game_variables[41] = 872
      else
        $game_variables[41] = 0
      end   
    when 65 #Z1コピーラディッツの洞窟(バーダック編)
        
      if $game_variables[1] == 13 && $game_variables[2] == 22 || #カード
        $game_variables[1] == 27 && $game_variables[2] == 7
        chk_card
      
      elsif $game_variables[1] == 5 && $game_variables[2] == 16 || #修行
        $game_variables[1] == 17 && $game_variables[2] == 14
        chk_training
      elsif $game_variables[1] == 7 && $game_variables[2] == 10 && $game_switches[527] == false && $game_switches[526] == true #ボス戦闘
        $game_variables[41] = 881
      elsif $game_variables[1] == 34 && $game_variables[2] == 23 #洞窟へ移動亀ハウス側
        $game_variables[41] = 873
      elsif $game_variables[1] == 5 && $game_variables[2] == 3 #洞窟へ移動ラディッツ側
        $game_variables[41] = 874
      else
        $game_variables[41] = 0
      end  
      
    when 17 #Z2宇宙エリア　いざナメック星へ
      if $game_variables[1] == 18 && $game_variables[2] == 3 || #カード
        $game_variables[1] == 14 && $game_variables[2] == 12 ||
        $game_variables[1] == 4 && $game_variables[2] == 40
        chk_card
        
      elsif $game_variables[1] == 22 && $game_variables[2] == 4 || #修行
        $game_variables[1] == 4 && $game_variables[2] == 21
        chk_training
      elsif $game_variables[1] == 14 && $game_variables[2] == 6 || #宿
       $game_variables[1] == 9 && $game_variables[2] == 14 ||
       $game_variables[1] == 19 && $game_variables[2] == 36
        $game_variables[41] = 11
      elsif $game_variables[1] == 26 && $game_variables[2] == 8 && $game_switches[81] == false #謎の宇宙船
        $game_variables[41] = 301
      elsif $game_variables[1] == 23 && $game_variables[2] == 21 && $game_switches[82] == false #謎の惑星
        $game_variables[41] = 305
      elsif $game_variables[1] == 33 && $game_variables[2] == 41  #ナメック星
        $game_variables[41] = 310
      else
        $game_variables[41] = 0
      end
    when 18 #Z2宇宙エリア　ドラゴンボールを集めろ！
      if $game_variables[1] == 14 && $game_variables[2] == 27 || #カード
        $game_variables[1] == 28 && $game_variables[2] == 67 ||
        $game_variables[1] == 63 && $game_variables[2] == 54 ||
        $game_variables[1] == 78 && $game_variables[2] == 71 ||
        $game_variables[1] == 75 && $game_variables[2] == 12 ||
        $game_variables[1] == 58 && $game_variables[2] == 26
        chk_card
        
      elsif $game_variables[1] == 9 && $game_variables[2] == 24 || #修行
        $game_variables[1] == 12 && $game_variables[2] == 57 ||
        $game_variables[1] == 82 && $game_variables[2] == 15
        chk_training
      elsif $game_variables[1] == 10 && $game_variables[2] == 29 || #宿
       $game_variables[1] == 15 && $game_variables[2] == 59 ||
       $game_variables[1] == 50 && $game_variables[2] == 48 ||
       $game_variables[1] == 71 && $game_variables[2] == 60 ||
       $game_variables[1] == 77 && $game_variables[2] == 21
        $game_variables[41] = 11
      elsif $game_variables[1] == 25 && $game_variables[2] == 58 #洞窟
        $game_variables[41] = 321
      elsif $game_variables[1] == 67 && $game_variables[2] == 20 || #村
        $game_variables[1] == 68 && $game_variables[2] == 20 ||
        $game_variables[1] == 67 && $game_variables[2] == 21 ||
        $game_variables[1] == 68 && $game_variables[2] == 21
        $game_variables[41] = 325
      elsif $game_variables[1] == 32 && $game_variables[2] == 16 && $game_switches[96] == false || #フリーザ一味
        $game_variables[1] == 31 && $game_variables[2] == 17 && $game_switches[96] == false ||
        $game_variables[1] == 33 && $game_variables[2] == 17 && $game_switches[96] == false ||
        $game_variables[1] == 32 && $game_variables[2] == 18 && $game_switches[96] == false
        $game_variables[41] = 326
      elsif $game_variables[1] == 11 && $game_variables[2] == 33 && $game_switches[97] == true #ドドリア
        $game_variables[41] = 339
      #elsif $game_variables[1] == 63 && $game_variables[2] == 22  #ナメック星
        #$game_variables[41] = 401
      elsif $game_variables[1] == 18 && $game_variables[2] == 39 || #時の間
        $game_variables[1] == 66 && $game_variables[2] == 59 ||
        $game_variables[1] == 61 && $game_variables[2] == 14
        $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end
    when 22 #Z2キュイが居る洞窟
      if $game_variables[1] == 4 && $game_variables[2] == 7 || #カード
        $game_variables[1] == 1 && $game_variables[2] == 23 ||
        $game_variables[1] == 20 && $game_variables[2] == 24 ||
        $game_variables[1] == 38 && $game_variables[2] == 1 ||
        $game_variables[1] == 75 && $game_variables[2] == 12 ||
        $game_variables[1] == 58 && $game_variables[2] == 26
        chk_card
      elsif $game_variables[1] == 34 && $game_variables[2] == 5 ||  #出入り口
        $game_variables[1] == 2 && $game_variables[2] == 26
        $game_variables[41] = 322
      elsif $game_variables[1] == 5 && $game_variables[2] == 24 && $game_switches[87] == false  #キュイ
        $game_variables[41] = 323
      else
        $game_variables[41] = 0
      end
    when 20 #Z2悟空重力修行
      if $game_variables[1] == 9 && $game_variables[2] == 3 #カード
        chk_card
      elsif $game_variables[1] == 11 && $game_variables[2] == 3 #宿
        $game_variables[41] = 11
      elsif $game_variables[1] == 10 && $game_variables[2] == 8 #修行
        $game_variables[41] = 32
      else
        $game_variables[41] = 0
      end
    when 21 #Z2界王修行
      #if $game_variables[1] == 9 && $game_variables[2] == 3 #カード
      #  chk_card
      if $game_variables[1] == 10 && $game_variables[2] == 2 #宿
        $game_variables[41] = 11
      elsif $game_variables[1] == 6 && $game_variables[2] == 5 || #修行
        $game_variables[1] == 13 && $game_variables[2] == 5 ||
        $game_variables[1] == 10 && $game_variables[2] == 9 
        $game_variables[41] = 32
      else
        $game_variables[41] = 0
      end
    when 23 #Z2宇宙エリア(悟空修行)
      if $game_variables[1] == 18 && $game_variables[2] == 3 || #カード
        $game_variables[1] == 14 && $game_variables[2] == 12 ||
        $game_variables[1] == 4 && $game_variables[2] == 40
        chk_card
      elsif $game_variables[1] == 14 && $game_variables[2] == 6 || #宿
       $game_variables[1] == 28 && $game_variables[2] == 12 ||
       $game_variables[1] == 4 && $game_variables[2] == 30 ||
       $game_variables[1] == 19 && $game_variables[2] == 36
        $game_variables[41] = 11
      elsif $game_variables[1] == 26 && $game_variables[2] == 9 || #修行
        $game_variables[1] == 11 && $game_variables[2] == 34 ||
        $game_variables[1] == 30 && $game_variables[2] == 39
        $game_variables[41] = 410
      elsif $game_variables[1] == 14 && $game_variables[2] == 39 && $game_switches[93] == false #謎の惑星
        $game_variables[41] = 422
      #elsif $game_variables[1] == 33 && $game_variables[2] == 41  #ナメック星
      #  $game_variables[41] = 310
      else
        $game_variables[41] = 0
      end
    when 24 #Z2ナメック星エリア２
      if $game_variables[1] == 29 && $game_variables[2] == 73 || #カード
        $game_variables[1] == 56 && $game_variables[2] == 45 ||
        $game_variables[1] == 20 && $game_variables[2] == 22 ||
        $game_variables[1] == 30 && $game_variables[2] == 2
        chk_card
      elsif $game_variables[1] == 24 && $game_variables[2] == 73 || #宿
       $game_variables[1] == 13 && $game_variables[2] == 24 ||
       $game_variables[1] == 37 && $game_variables[2] == 2 ||
       $game_variables[1] == 45 && $game_variables[2] == 48
        $game_variables[41] = 11
      elsif $game_variables[1] == 23 && $game_variables[2] == 22 || #修行
        $game_variables[1] == 26 && $game_variables[2] == 11||
       $game_variables[1] == 54 && $game_variables[2] == 52
        chk_training
      elsif $game_variables[1] == 25 && $game_variables[2] == 17 #機能説明ナメック星人
        $game_variables[41] = 601
      elsif $game_variables[1] == 11 && $game_variables[2] == 48 #池
        $game_variables[41] = 419
      elsif $game_variables[1] == 54 && $game_variables[2] == 4 || #村
       $game_variables[1] == 56 && $game_variables[2] == 4 ||
       $game_variables[1] == 55 && $game_variables[2] == 5 ||
       $game_variables[1] == 54 && $game_variables[2] == 6 ||
       $game_variables[1] == 56 && $game_variables[2] == 6
        $game_variables[41] = 413
      elsif $game_variables[1] == 7 && $game_variables[2] == 7 || #最長老の家
        $game_variables[1] == 8 && $game_variables[2] == 7
        $game_variables[41] = 435
      elsif $game_variables[1] == 10 && $game_variables[2] == 25 #時の間
        $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end
    when 26 #Z2ナメック星エリア３
      if $game_variables[1] == 12 && $game_variables[2] == 12 || #カード
        $game_variables[1] == 36 && $game_variables[2] == 20
        chk_card
      elsif $game_variables[1] == 6 && $game_variables[2] == 7 || #宿
       $game_variables[1] == 54 && $game_variables[2] == 2 ||
       $game_variables[1] == 52 && $game_variables[2] == 21
        $game_variables[41] = 11
      elsif $game_variables[1] == 7 && $game_variables[2] == 16 || #修行
        $game_variables[1] == 32 && $game_variables[2] == 5 ||
        $game_variables[1] == 46 && $game_variables[2] == 11
        chk_training
      elsif $game_variables[1] == 57 && $game_variables[2] == 25 #池
        $game_variables[41] = 445
      elsif $game_variables[1] == 48 && $game_variables[2] == 23 #時の間
        $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end
    when 29 #Z2ナメック星エリア４
      if $game_variables[1] == 8 && $game_variables[2] == 7 || #カード
        $game_variables[1] == 10 && $game_variables[2] == 7 ||
        $game_variables[1] == 22 && $game_variables[2] == 36 ||
        $game_variables[1] == 14 && $game_variables[2] == 64 ||
        $game_variables[1] == 54 && $game_variables[2] == 62 ||
        $game_variables[1] == 45 && $game_variables[2] == 17
        chk_card
      elsif $game_variables[1] == 10 && $game_variables[2] == 69 #カード特殊
        $game_variables[44] = 20
        chk_card
      elsif $game_variables[1] == 10 && $game_variables[2] == 65 || #宿
        $game_variables[1] == 50 && $game_variables[2] == 68 ||
        $game_variables[1] == 19 && $game_variables[2] == 38 ||
        $game_variables[1] == 40 && $game_variables[2] == 23
        $game_variables[41] = 11
      elsif $game_variables[1] == 11 && $game_variables[2] == 71 || #修行
        $game_variables[1] == 48 && $game_variables[2] == 27
        chk_training
      elsif $game_variables[1] == 24 && $game_variables[2] == 4 && $game_switches[101] == false #ポルンガ
        $game_variables[41] = 463
      elsif $game_variables[1] == 16 && $game_variables[2] == 65 && $game_switches[102] == false #ネイル
        $game_variables[41] = 476
      elsif $game_variables[1] == 22 && $game_variables[2] == 19 && $game_switches[102] == true && $game_variables[43] == 34|| #フリーザ第1形態
      $game_variables[1] == 23 && $game_variables[2] == 19 && $game_switches[102] == true && $game_variables[43] == 34
        $game_variables[41] = 478
      elsif $game_variables[1] == 37 && $game_variables[2] == 59 && $game_variables[43] == 35 #フリーザ第2形態
        $game_variables[41] = 484
      elsif $game_variables[1] == 37 && $game_variables[2] == 59 && $game_variables[43] == 36 #フリーザ第3形態
        $game_variables[41] = 492 #フリーザ
        #$game_variables[41] = 541 #超元気玉
        #$game_variables[41] = 3571
        #$game_variables[41] = 5001
        #$game_variables[41] = 2999 #ED
        #$game_variables[41] = 47
        #$game_variables[41] = 498 #対超ベジータ
        
      elsif $game_variables[1] == 26 && $game_variables[2] == 30 || #若者と同化
       $game_variables[1] == 27 && $game_variables[2] == 30
        $game_variables[41] = 506
      elsif $game_variables[1] == 11 && $game_variables[2] == 5 && $game_variables[43] == 36 && $game_switches[109] == false #ターレス＆スラッグ戦闘＆バーダック仲間
        $game_variables[41] = 514
        
      elsif $game_variables[1] >= 46 && $game_variables[1] <= 48 && #バトルスーツ取得
       $game_variables[2] >= 22 && $game_variables[2] <= 23
        $game_variables[41] = 521
      elsif $game_variables[1] == 7 && $game_variables[2] == 6 && $game_variables[43] == 36 || #時の間
        $game_variables[1] == 9 && $game_variables[2] == 68 && $game_variables[43] == 36 ||
        $game_variables[1] == 47 && $game_variables[2] == 65 && $game_variables[43] == 36 ||
        $game_variables[1] == 44 && $game_variables[2] == 26
        $game_variables[41] = 15
      elsif $game_variables[1] == 21 && $game_variables[2] == 61#スキル説明のナメック星人
        $game_variables[41] = 602
      else
        $game_variables[41] = 0
      end
    when 54 #Z2バーダック編
      if $game_variables[1] == 11 && $game_variables[2] == 31 || #宿
        $game_variables[1] == 23 && $game_variables[2] == 13
        $game_variables[41] = 11
      elsif $game_variables[1] == 16 && $game_variables[2] == 2 ||
        $game_variables[1] == 17 && $game_variables[2] == 2 ||
        $game_variables[1] == 18 && $game_variables[2] == 2 ||
        $game_variables[1] == 16 && $game_variables[2] == 3 ||
        $game_variables[1] == 17 && $game_variables[2] == 3 ||
        $game_variables[1] == 18 && $game_variables[2] == 3
        $game_variables[41] = 3161
      else
        $game_variables[41] = 0
      end
    when 33 #Z3ボールを集めろ！
      if $game_variables[1] == 72 && $game_variables[2] == 25 || #カード
        $game_variables[1] == 36 && $game_variables[2] == 47 ||
        $game_variables[1] == 8 && $game_variables[2] == 77 ||
        $game_variables[1] == 58 && $game_variables[2] == 71
        chk_card
      elsif $game_variables[1] == 26 && $game_variables[2] == 83 || #宿
        $game_variables[1] == 17 && $game_variables[2] == 6 ||
        $game_variables[1] == 38 && $game_variables[2] == 42 ||
        $game_variables[1] == 90 && $game_variables[2] == 1
        $game_variables[41] = 11
      elsif $game_variables[1] == 61 && $game_variables[2] == 16 || #修行
        $game_variables[1] == 44 && $game_variables[2] == 48 ||
        $game_variables[1] == 69 && $game_variables[2] == 63
        chk_training
      elsif $game_variables[1] == 42 && $game_variables[2] == 41 || #最初の街
        $game_variables[1] == 42 && $game_variables[2] == 42 ||
        $game_variables[1] == 43 && $game_variables[2] == 41 ||
        $game_variables[1] == 43 && $game_variables[2] == 42
        $game_variables[41] = 1160
      elsif $game_variables[1] == 30 && $game_variables[2] == 46 #ウミガメ
        $game_variables[41] = 1591
      elsif $game_variables[1] == 12 && $game_variables[2] == 71 #メガネ岩
        $game_variables[41] = 1170
      elsif $game_variables[1] == 6 && $game_variables[2] == 10 #薬草オジサン
        $game_variables[41] = 1180
      elsif $game_variables[1] == 9 && $game_variables[2] == 8 && $game_switches[405] == false || #恐竜
        $game_variables[1] == 10 && $game_variables[2] == 8 && $game_switches[405] == false
        $game_variables[41] = 1181
      elsif $game_variables[1] == 72 && $game_variables[2] == 67 && $game_switches[409] == false #ダイナマイト設置位置
        $game_variables[41] = 1182
      elsif $game_variables[1] == 77 && $game_variables[2] == 9 #鉱山
        $game_variables[41] = 1185
      elsif $game_variables[1] == 62 && $game_variables[2] == 64 && $game_switches[409] == false #少年門番
        $game_variables[41] = 1190
      elsif $game_variables[1] == 78 && $game_variables[2] == 82 || #最初の敵の基地
        $game_variables[1] == 78 && $game_variables[2] == 83 ||
        $game_variables[1] == 79 && $game_variables[2] == 82 ||
        $game_variables[1] == 79 && $game_variables[2] == 83
        $game_variables[41] = 1195
      elsif $game_variables[1] == 47 && $game_variables[2] == 45 #時の間
        $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end
    when 34 #Z3ベジータ登場
      if $game_variables[1] == 57 && $game_variables[2] == 17 || #カード
        $game_variables[1] == 20 && $game_variables[2] == 9
        chk_card
      elsif $game_variables[1] == 4 && $game_variables[2] == 11 || #宿
        $game_variables[1] == 46 && $game_variables[2] == 28
        $game_variables[41] = 11
      elsif $game_variables[1] == 30 && $game_variables[2] == 5 || #修行
        $game_variables[1] == 39 && $game_variables[2] == 26
        chk_training
      elsif $game_variables[1] == 13 && $game_variables[2] == 17 && $game_switches[414] == false || #バリアエリア
        $game_variables[1] == 14 && $game_variables[2] == 18 && $game_switches[414] == false ||
        $game_variables[1] == 15 && $game_variables[2] == 19 && $game_switches[414] == false ||
        $game_variables[1] == 16 && $game_variables[2] == 20 && $game_switches[414] == false ||
        $game_variables[1] == 17 && $game_variables[2] == 21 && $game_switches[414] == false ||
        $game_variables[1] == 18 && $game_variables[2] == 22 && $game_switches[414] == false ||
        $game_variables[1] == 19 && $game_variables[2] == 23 && $game_switches[414] == false ||
        $game_variables[1] == 20 && $game_variables[2] == 24 && $game_switches[414] == false ||
        $game_variables[1] == 21 && $game_variables[2] == 25 && $game_switches[414] == false ||
        $game_variables[1] == 22 && $game_variables[2] == 26 && $game_switches[414] == false
        $game_variables[41] = 1210
      elsif $game_variables[1] == 3 && $game_variables[2] == 6 && $game_switches[410] == true && $game_switches[411] == false #バリア発生装置１
        $game_variables[41] = 1211
      elsif $game_variables[1] == 37 && $game_variables[2] == 6 && $game_switches[410] == true && $game_switches[412] == false #バリア発生装置２
        $game_variables[41] = 1212
      elsif $game_variables[1] == 27 && $game_variables[2] == 32 && $game_switches[410] == true && $game_switches[413] == false #バリア発生装置３
        $game_variables[41] = 1213  
      elsif $game_variables[1] == 11 && $game_variables[2] == 24 || #最初の敵の基地
        $game_variables[1] == 11 && $game_variables[2] == 25 ||
        $game_variables[1] == 12 && $game_variables[2] == 24 ||
        $game_variables[1] == 12 && $game_variables[2] == 25
        $game_variables[41] = 1215
      #elsif $game_variables[1] == 25 && $game_variables[2] == 15 #時の間
      #  $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end
      
    when 78 #Z3魔凶星編東
      if $game_variables[1] == 7 && $game_variables[2] == 8 || #カード
        $game_variables[1] == 46 && $game_variables[2] == 5 ||
        $game_variables[1] == 51 && $game_variables[2] == 38 ||
        $game_variables[1] == 4 && $game_variables[2] == 36 ||
        $game_variables[1] == 27 && $game_variables[2] == 13
        chk_card
      elsif $game_variables[1] == 11 && $game_variables[2] == 6 || #宿
        $game_variables[1] == 40 && $game_variables[2] == 41 ||
        $game_variables[1] == 36 && $game_variables[2] == 15 ||
        $game_variables[1] == 61 && $game_variables[2] == 7
        $game_variables[41] = 11
      elsif $game_variables[1] == 9 && $game_variables[2] == 7 || #修行
        $game_variables[1] == 39 && $game_variables[2] == 19 ||
        $game_variables[1] == 66 && $game_variables[2] == 10 ||
        $game_variables[1] == 38 && $game_variables[2] == 41
        chk_training
      elsif $game_variables[1] == 29 && $game_variables[2] == 21 #ガッシュ
        $game_variables[41] = 1471

      #elsif $game_variables[1] == 18 && $game_variables[2] == 8 #時の間
      #  $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end
    when 79 #Z3魔凶星編西
      if $game_variables[1] == 17 && $game_variables[2] == 40 || #カード
        $game_variables[1] == 36 && $game_variables[2] == 20 ||
        $game_variables[1] == 45 && $game_variables[2] == 6
        chk_card
      elsif $game_variables[1] == 8 && $game_variables[2] == 33 || #宿
        $game_variables[1] == 23 && $game_variables[2] == 7 ||
        $game_variables[1] == 62 && $game_variables[2] == 38
        $game_variables[41] = 11
      elsif $game_variables[1] == 17 && $game_variables[2] == 21 || #修行
        $game_variables[1] == 38 && $game_variables[2] == 20 ||
        $game_variables[1] == 34 && $game_variables[2] == 42 ||
        $game_variables[1] == 62 && $game_variables[2] == 29 ||
        $game_variables[1] == 57 && $game_variables[2] == 14
        chk_training
      elsif $game_variables[1] == 60 && $game_variables[2] == 6 #ビネガー
        $game_variables[41] = 1491

      #elsif $game_variables[1] == 18 && $game_variables[2] == 8 #時の間
      #  $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end
    when 80 #Z3魔凶星編南
      if $game_variables[1] == 16 && $game_variables[2] == 37 || #カード
        $game_variables[1] == 20 && $game_variables[2] == 25 ||
        $game_variables[1] == 19 && $game_variables[2] == 5
        chk_card
      elsif $game_variables[1] == 26 && $game_variables[2] == 37 || #宿
        $game_variables[1] == 30 && $game_variables[2] == 12 ||
        $game_variables[1] == 33 && $game_variables[2] == 26
        $game_variables[41] = 11
      elsif $game_variables[1] == 19 && $game_variables[2] == 33 || #修行
        $game_variables[1] == 12 && $game_variables[2] == 4 ||
        $game_variables[1] == 21 && $game_variables[2] == 24 ||
        $game_variables[1] == 45 && $game_variables[2] == 31
        chk_training
      elsif $game_variables[1] == 23 && $game_variables[2] == 23 #ゾルド
        $game_variables[41] = 1511

      #elsif $game_variables[1] == 18 && $game_variables[2] == 8 #時の間
      #  $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end
    when 81 #Z3魔凶星編北
      if $game_variables[1] == 5 && $game_variables[2] == 43 || #カード
        $game_variables[1] == 44 && $game_variables[2] == 29 ||
        $game_variables[1] == 67 && $game_variables[2] == 1
        chk_card
      elsif $game_variables[1] == 61 && $game_variables[2] == 43 || #宿
        $game_variables[1] == 68 && $game_variables[2] == 2 ||
        $game_variables[1] == 37 && $game_variables[2] == 11
        $game_variables[41] = 11
      elsif $game_variables[1] == 58 && $game_variables[2] == 43 || #修行
        $game_variables[1] == 68 && $game_variables[2] == 1 ||
        $game_variables[1] == 21 && $game_variables[2] == 25 ||
        $game_variables[1] == 4 && $game_variables[2] == 42
        chk_training
      elsif $game_variables[1] == 6 && $game_variables[2] == 6 #タード
        $game_variables[41] = 1531

      #elsif $game_variables[1] == 18 && $game_variables[2] == 8 #時の間
      #  $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end
    when 82 #Z3魔凶星編(カリン塔)
      if $game_variables[1] == 40 && $game_variables[2] == 3 || #カード
        $game_variables[1] == 65 && $game_variables[2] == 20
        chk_card
      elsif $game_variables[1] == 4 && $game_variables[2] == 31 || #宿
        $game_variables[1] == 43 && $game_variables[2] == 40 ||
        $game_variables[1] == 65 && $game_variables[2] == 4
        $game_variables[41] = 11
      elsif $game_variables[1] == 10 && $game_variables[2] == 10 || #修行
        $game_variables[1] == 34 && $game_variables[2] == 10 ||
        $game_variables[1] == 40 && $game_variables[2] == 38 ||
        $game_variables[1] == 55 && $game_variables[2] == 13 ||
        $game_variables[1] == 67 && $game_variables[2] == 20
        chk_training
      elsif $game_variables[1] == 30 && $game_variables[2] == 26 #ヤジロベー
        $game_variables[41] = 1583
      elsif $game_variables[1] == 5 && $game_variables[2] == 1 || #カリン塔
        $game_variables[1] == 5 && $game_variables[2] == 2 ||
        $game_variables[1] == 5 && $game_variables[2] == 3 ||
        $game_variables[1] == 6 && $game_variables[2] == 1 ||
        $game_variables[1] == 6 && $game_variables[2] == 2 ||
        $game_variables[1] == 6 && $game_variables[2] == 3
        $game_variables[41] = 1551
#$game_variables[41] = 1240
      #elsif $game_variables[1] == 18 && $game_variables[2] == 8 #時の間
      #  $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end
    when 37 #Z3ベジータ出撃
      if $game_variables[1] == 51 && $game_variables[2] == 23 || #カード
        $game_variables[1] == 15 && $game_variables[2] == 2
        chk_card
      elsif $game_variables[1] == 4 && $game_variables[2] == 8 || #宿
        $game_variables[1] == 54 && $game_variables[2] == 3
        $game_variables[41] = 11
      elsif $game_variables[1] == 55 && $game_variables[2] == 16 || #修行
        $game_variables[1] == 8 && $game_variables[2] == 13
        chk_training
      elsif $game_variables[1] == 60 && $game_variables[2] == 13 && $game_switches[419] == false #門番
        $game_variables[41] = 1270
      elsif $game_variables[1] == 60 && $game_variables[2] == 22 || #最初の敵の基地
        $game_variables[1] == 61 && $game_variables[2] == 22 ||
        $game_variables[1] == 60 && $game_variables[2] == 23 ||
        $game_variables[1] == 61 && $game_variables[2] == 23
        $game_variables[41] = 1272
      #elsif $game_variables[1] == 18 && $game_variables[2] == 8 #時の間
      #  $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end
    when 38 #Z3ブルマ救出
      if $game_variables[1] == 34 && $game_variables[2] == 7 || #カード
        $game_variables[1] == 58 && $game_variables[2] == 20 ||
        $game_variables[1] == 55 && $game_variables[2] == 42 ||
        $game_variables[1] == 9 && $game_variables[2] == 28
        chk_card
      elsif $game_variables[1] == 43 && $game_variables[2] == 16 || #宿
        $game_variables[1] == 23 && $game_variables[2] == 28
        $game_variables[41] = 11
      elsif $game_variables[1] == 29 && $game_variables[2] == 16 || #修行
        $game_variables[1] == 60 && $game_variables[2] == 12 ||
        $game_variables[1] == 10 && $game_variables[2] == 46 ||
        $game_variables[1] == 50 && $game_variables[2] == 34 ||
        $game_variables[1] == 32 && $game_variables[2] == 47
        chk_training
      elsif $game_variables[1] == 27 && $game_variables[2] == 6 && $game_switches[421] == false #門番
        $game_variables[41] = 1280
      elsif $game_variables[1] == 11 && $game_variables[2] == 21 #救出指示
        $game_variables[41] = 1281
      elsif $game_variables[1] == 46 && $game_variables[2] == 29 && $game_switches[423] == false #救出A
        $game_variables[41] = 1282
      elsif $game_variables[1] == 51 && $game_variables[2] == 47 && $game_switches[424] == false #救出B
        $game_variables[41] = 1285
      elsif $game_variables[1] == 14 && $game_variables[2] == 40 && $game_switches[425] == false #救出C
        $game_variables[41] = 1288
      elsif $game_variables[1] == 8 && $game_variables[2] == 7 || #最初の敵の基地
        $game_variables[1] == 9 && $game_variables[2] == 7 ||
        $game_variables[1] == 8 && $game_variables[2] == 8 ||
        $game_variables[1] == 9 && $game_variables[2] == 8
        $game_variables[41] = 1298
      elsif $game_variables[1] == 9 && $game_variables[2] == 17 && $game_switches[421] == false
        $game_variables[41] = 1295
      elsif $game_variables[1] == 11 && $game_variables[2] == 25 #時の間
        $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end
    when 39 #Z3クウラ到着
      if $game_variables[1] == 14 && $game_variables[2] == 33 || #カード
        $game_variables[1] == 44 && $game_variables[2] == 21
        chk_card
      elsif $game_variables[1] == 12 && $game_variables[2] == 42 || #宿
        $game_variables[1] == 41 && $game_variables[2] == 45 ||
        $game_variables[1] == 51 && $game_variables[2] == 11
        $game_variables[41] = 11
      elsif $game_variables[1] == 43 && $game_variables[2] == 21 || #修行
        $game_variables[1] == 25 && $game_variables[2] == 43
        chk_training
      elsif $game_variables[1] == 15 && $game_variables[2] == 14 || #クウラの基地
        $game_variables[1] == 16 && $game_variables[2] == 14 ||
        $game_variables[1] == 15 && $game_variables[2] == 15 ||
        $game_variables[1] == 16 && $game_variables[2] == 15
        $game_variables[41] = 1316
      elsif $game_variables[1] == 34 && $game_variables[2] == 41 #ランチ(金髪)
        $game_variables[41] = 1581
      elsif $game_variables[1] == 53 && $game_variables[2] == 11 && #一星球
        $game_party.has_item?($data_items[2]) == false &&
        $game_switches[446] == false
        $game_variables[41] = 1431
        $game_variables[240] = 1
      elsif $game_variables[1] == 21 && $game_variables[2] == 33 && #二星球
        $game_party.has_item?($data_items[3]) == false &&
        $game_switches[446] == false
        $game_variables[41] = 1431
        $game_variables[240] = 2
      elsif $game_variables[1] == 19 && $game_variables[2] == 47 && #三星球
        $game_party.has_item?($data_items[4]) == false &&
        $game_switches[446] == false
        $game_variables[41] = 1431
        $game_variables[240] = 3
      elsif $game_variables[1] == 21 && $game_variables[2] == 11 && #四星球
        $game_party.has_item?($data_items[5]) == false &&
        $game_switches[446] == false
        $game_variables[41] = 1431
        $game_variables[240] = 4
      elsif $game_variables[1] == 25 && $game_variables[2] == 25 && #五星球
        $game_party.has_item?($data_items[6]) == false &&
        $game_switches[446] == false
        $game_variables[41] = 1431
        $game_variables[240] = 5
      elsif $game_variables[1] == 49 && $game_variables[2] == 50 && #六星球
        $game_party.has_item?($data_items[7]) == false &&
        $game_switches[446] == false
        $game_variables[41] = 1431
        $game_variables[240] = 6
      elsif $game_variables[1] == 14 && $game_variables[2] == 23 && #七星球
        $game_party.has_item?($data_items[8]) == false &&
        $game_switches[446] == false
        $game_variables[41] = 1431
        $game_variables[240] = 7
      elsif $game_variables[1] == 37 && $game_variables[2] == 21 #時の間
        $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end
    when 40 #Z3人造人間
      if $game_variables[1] == 21 && $game_variables[2] == 19 || #カード
        $game_variables[1] == 8 && $game_variables[2] == 48 ||
        $game_variables[1] == 45 && $game_variables[2] == 45 ||
        $game_variables[1] == 59 && $game_variables[2] == 4
        chk_card
      elsif $game_variables[1] == 16 && $game_variables[2] == 21 #カード特殊
        $game_variables[44] = 30
        chk_card
      elsif $game_variables[1] == 18 && $game_variables[2] == 13 #ウーロン
        $game_variables[41] = 1582
      elsif $game_variables[1] == 9 && $game_variables[2] == 43 || #宿
        $game_variables[1] == 57 && $game_variables[2] == 36
        $game_variables[41] = 11
      elsif $game_variables[1] == 24 && $game_variables[2] == 44 || #修行
        $game_variables[1] == 52 && $game_variables[2] == 54 ||
        $game_variables[1] == 49 && $game_variables[2] == 6 ||
        $game_variables[1] == 21 && $game_variables[2] == 11
        chk_training
      elsif $game_variables[1] == $game_variables[308] && $game_variables[2] == $game_variables[309] && $game_switches[426] == false #20号
        $game_variables[41] = 1341
      elsif $game_variables[1] == 61 && $game_variables[2] == 33 && $game_switches[426] == true && $game_switches[427] == false #研究所
        $game_variables[41] = 1356
      elsif $game_variables[1] == 9 && $game_variables[2] == 10 && $game_switches[427] == true && $game_switches[431] == false #17号たち
        $game_variables[41] = 1361
        #$game_variables[41] = 2001
      elsif $game_variables[1] == 24 && $game_variables[2] == 10 || #時の間
        $game_variables[1] == 10 && $game_variables[2] == 54 ||
        $game_variables[1] == 68 && $game_variables[2] == 15
        $game_variables[41] = 15
      else
        $game_variables[41] = 0
        if $game_switches[426] == false #人造人間見つける前
          $game_variables[41] = 1421 if rand(3) + 1 == 1 #一定確率で方角イベント発生
        end

        if $game_switches[428] == false && $game_switches[434] == false #未来の薬を使ってないかつ心臓病イベントが発生していない
          $game_variables[41] = 1335
        end
      end
    when 42 #Z4セル誕生の秘密
      if $game_variables[1] == 80 && $game_variables[2] == 3 || #カード
        $game_variables[1] == 5 && $game_variables[2] == 50 ||
        $game_variables[1] == 17 && $game_variables[2] == 2 ||
        $game_variables[1] == 77 && $game_variables[2] == 37
        chk_card
      elsif $game_variables[1] == 17 && $game_variables[2] == 43 || #宿
        $game_variables[1] == 52 && $game_variables[2] == 5 ||
        $game_variables[1] == 10 && $game_variables[2] == 2 ||
        $game_variables[1] == 61 && $game_variables[2] == 44
        $game_variables[41] = 11
      elsif $game_variables[1] == 5 && $game_variables[2] == 7 || #修行
        $game_variables[1] == 15 && $game_variables[2] == 37 ||
        $game_variables[1] == 66 && $game_variables[2] == 7 ||
        $game_variables[1] == 66 && $game_variables[2] == 36
        chk_training
      elsif $game_variables[1] == 19 && $game_variables[2] == 9 #研究所地下
        $game_variables[41] = 2011
      else
        $game_variables[41] = 0
      end
    when 44 #Z4精神と時の部屋ベジータトランクス
      if $game_variables[1] == 11 && $game_variables[2] == 8 #カード
        chk_card
      elsif $game_variables[1] == 4 && $game_variables[2] == 4 #宿
        $game_variables[41] = 11
      elsif $game_variables[1] == 15 && $game_variables[2] == 4 #修行開始
        if $game_variables[121] == 1 #ベジータとトランクス
          $game_variables[41] = 2071
        elsif $game_variables[121] == 2 #悟空と悟飯
          $game_variables[41] = 2331
        elsif $game_variables[121] == 3 #地球人
          $game_variables[41] = 2951
        end
      else
        $game_variables[41] = 0
      end
    when 43 #Z4忍び寄るセル！
      if $game_variables[1] == 4 && $game_variables[2] == 8 || #カード
        $game_variables[1] == 51 && $game_variables[2] == 36 ||
        $game_variables[1] == 14 && $game_variables[2] == 42 ||
        $game_variables[1] == 77 && $game_variables[2] == 37
        chk_card
      elsif $game_variables[1] == 62 && $game_variables[2] == 11 || #宿
        $game_variables[1] == 10 && $game_variables[2] == 5 ||
        $game_variables[1] == 8 && $game_variables[2] == 46
        $game_variables[41] = 11
      elsif $game_variables[1] == 6 && $game_variables[2] == 11 || #修行
        $game_variables[1] == 4 && $game_variables[2] == 39 ||
        $game_variables[1] == 21 && $game_variables[2] == 25 ||
        $game_variables[1] == 48 && $game_variables[2] == 36
        chk_training
      elsif $game_variables[1] == 8 && $game_variables[2] == 40 && $game_switches[435] == false || #ピッコロとセル
        $game_variables[1] == 8 && $game_variables[2] == 41
        
        if $game_switches[435] == false
          $game_variables[41] = 2121
        else
          $game_variables[41] = 2151#2191#2161
        end
      else
        $game_variables[41] = 0
      end
    when 46 #Z4新生ベジータ親子出撃！
      if $game_variables[1] == 4 && $game_variables[2] == 43 || #カード
        $game_variables[1] == 66 && $game_variables[2] == 5 || 
        $game_variables[1] == 57 && $game_variables[2] == 46
        chk_card
      elsif $game_variables[1] == 11 && $game_variables[2] == 11 || #宿
        $game_variables[1] == 60 && $game_variables[2] == 44
        $game_variables[41] = 11
      elsif $game_variables[1] == 7 && $game_variables[2] == 15 || #修行
        $game_variables[1] == 38 && $game_variables[2] == 35 ||
        $game_variables[1] == 61 && $game_variables[2] == 4
        chk_training
      elsif $game_variables[1] == 40 && $game_variables[2] == 34
        $game_variables[41] = 2251
        #$game_variables[41] = 2691 #スタッフロール
      else
        $game_variables[41] = 0
      end
    when 84 #Z4メタルクウラ編 ナメック星マップ
      if $game_variables[1] == 6 && $game_variables[2] == 37 || #カード
        $game_variables[1] == 30 && $game_variables[2] == 10 ||
        $game_variables[1] == 28 && $game_variables[2] == 26 ||
        $game_variables[1] == 46 && $game_variables[2] == 32 ||
        $game_variables[1] == 58 && $game_variables[2] == 14 ||
        $game_variables[1] == 81 && $game_variables[2] == 27 ||
        $game_variables[1] == 52 && $game_variables[2] == 49
        chk_card
      elsif $game_variables[1] == 16 && $game_variables[2] == 49 || #宿
        $game_variables[1] == 43 && $game_variables[2] == 16 ||
        $game_variables[1] == 54 && $game_variables[2] == 51 ||
        $game_variables[1] == 74 && $game_variables[2] == 15 ||
        $game_variables[1] == 21 && $game_variables[2] == 8
        $game_variables[41] = 11
      elsif $game_variables[1] == 22 && $game_variables[2] == 47 || #修行
        $game_variables[1] == 8 && $game_variables[2] == 9 ||
        $game_variables[1] == 33 && $game_variables[2] == 17 ||
        $game_variables[1] == 56 && $game_variables[2] == 23 ||
        $game_variables[1] == 56 && $game_variables[2] == 53 ||
        $game_variables[1] == 78 && $game_variables[2] == 29
        chk_training
      elsif $game_variables[1] == 6 && $game_variables[2] == 49 || #最長老の村
        $game_variables[1] == 6 && $game_variables[2] == 50 ||
        $game_variables[1] == 7 && $game_variables[2] == 49 ||
        $game_variables[1] == 7 && $game_variables[2] == 50
        $game_variables[41] = 2711
      elsif $game_variables[1] == 68 && $game_variables[2] == 2 || #メタルクウラ
        $game_variables[1] == 69 && $game_variables[2] == 2 ||
        $game_variables[1] == 68 && $game_variables[2] == 3 ||
        $game_variables[1] == 69 && $game_variables[2] == 3
        $game_variables[41] = 2721 #2721
      elsif $game_variables[1] == 13 && $game_variables[2] == 53 || #時の間
        $game_variables[1] == 25 && $game_variables[2] == 2 ||
        $game_variables[1] == 52 && $game_variables[2] == 53
        $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end
    when 90 #Z4メタルクウラ編 ビッグゲテスター
      if $game_variables[1] == 8 && $game_variables[2] == 47 || #カード
        $game_variables[1] == 50 && $game_variables[2] == 34 ||
        $game_variables[1] == 25 && $game_variables[2] == 8
        chk_card
      elsif $game_variables[1] == 3 && $game_variables[2] == 48 || #宿
        $game_variables[1] == 14 && $game_variables[2] == 12 ||
        $game_variables[1] == 37 && $game_variables[2] == 28 ||
        $game_variables[1] == 79 && $game_variables[2] == 40
        $game_variables[41] = 11
      elsif $game_variables[1] == 11 && $game_variables[2] == 53 || #修行
        $game_variables[1] == 61 && $game_variables[2] == 28 ||
        $game_variables[1] == 29 && $game_variables[2] == 17
        chk_training
      elsif $game_variables[1] == 7 && $game_variables[2] == 7 && $game_switches[571] == false #ロボット兵A
        $game_variables[41] = 2761
      elsif $game_variables[1] == 43 && $game_variables[2] == 48 && $game_switches[572] == false #ロボット兵B
        $game_variables[41] = 2762
      elsif $game_variables[1] == 69 && $game_variables[2] == 9 && $game_switches[573] == false #ロボット兵C
        $game_variables[41] = 2763
      elsif $game_variables[1] == 73 && $game_variables[2] == 49 && $game_switches[574] == false #ロボット兵D
        $game_variables[41] = 2764
      elsif $game_variables[1] == 30 && $game_variables[2] == 14 && $game_switches[575] == false #ドア
        $game_variables[41] = 2771
      elsif $game_variables[1] == 49 && $game_variables[2] == 10 #メタルクウラコア
        $game_variables[41] = 2781
      elsif $game_variables[1] == 29 && $game_variables[2] == 22 #時の間
        $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end
    when 93 #Z4人造人間13号編
      if $game_variables[1] == 18 && $game_variables[2] == 19 || #カード
        $game_variables[1] == 29 && $game_variables[2] == 16 ||
        $game_variables[1] == 28 && $game_variables[2] == 42 ||
        $game_variables[1] == 31 && $game_variables[2] == 14 ||
        $game_variables[1] == 46 && $game_variables[2] == 8 ||
        $game_variables[1] == 58 && $game_variables[2] == 25
        chk_card
      elsif $game_variables[1] == 13 && $game_variables[2] == 22 || #宿
        $game_variables[1] == 28 && $game_variables[2] == 18 ||
        $game_variables[1] == 38 && $game_variables[2] == 10 ||
        $game_variables[1] == 43 && $game_variables[2] == 7 ||
        $game_variables[1] == 62 && $game_variables[2] == 27
        $game_variables[41] = 11
      elsif $game_variables[1] == 11 && $game_variables[2] == 17 || #修行
        $game_variables[1] == 20 && $game_variables[2] == 38 ||
        $game_variables[1] == 27 && $game_variables[2] == 18 ||
        $game_variables[1] == 33 && $game_variables[2] == 4 ||
        $game_variables[1] == 57 && $game_variables[2] == 28 ||
        $game_variables[1] == 58 && $game_variables[2] == 15
        chk_training
      elsif $game_variables[1] == 10 && $game_variables[2] == 24 && $game_switches[579] == false #15号
        $game_variables[41] = 2831
      elsif $game_variables[1] == 31 && $game_variables[2] == 22 && $game_switches[578] == false #14号
        $game_variables[41] = 2841
      elsif $game_variables[1] == 65 && $game_variables[2] == 17 #13号
        $game_variables[41] = 2851 #2991 #2851
      elsif $game_variables[1] == 39 && $game_variables[2] == 25 || #時の間
        $game_variables[1] == 55 && $game_variables[2] == 35
        $game_variables[41] = 15
      else
        $game_variables[41] = 0
      end
    when 47 #Z4ドラゴンボールを見つけ出せ！
      if $game_variables[1] == 39 && $game_variables[2] == 25 || #カード
        $game_variables[1] == 65 && $game_variables[2] == 17
        chk_card
      elsif $game_variables[1] == 19 && $game_variables[2] == 17 || #宿
        $game_variables[1] == 55 && $game_variables[2] == 43
        $game_variables[41] = 11
      elsif $game_variables[1] == 20 && $game_variables[2] == 34 || #修行
        $game_variables[1] == 56 && $game_variables[2] == 25 ||
        $game_variables[1] == 63 && $game_variables[2] == 45
        chk_training
      elsif $game_variables[1] == 65 && $game_variables[2] == 23
        $game_variables[41] = 2381
      elsif $game_variables[1] == 26 && $game_variables[2] == 44
        $game_variables[41] = 2391
      elsif $game_variables[1] == 51 && $game_variables[2] == 36 && $game_switches[452] == true && $game_switches[453] == false ||
        $game_variables[1] == 52 && $game_variables[2] == 36 && $game_switches[452] == true && $game_switches[453] == false ||
        $game_variables[1] == 51 && $game_variables[2] == 37 && $game_switches[452] == true && $game_switches[453] == false ||
        $game_variables[1] == 52 && $game_variables[2] == 37 && $game_switches[452] == true && $game_switches[453] == false
        $game_variables[41] = 2401
      else
        $game_variables[41] = 0
      end
    when 48 #Z4セルゲーム
      if $game_variables[1] == 10 && $game_variables[2] == 13 || #カード
        $game_variables[1] == 8 && $game_variables[2] == 65 ||
        $game_variables[1] == 79 && $game_variables[2] == 32
        chk_card
      elsif $game_variables[1] == 38 && $game_variables[2] == 29 #カード特殊
        $game_variables[44] = 40
        chk_card
      elsif $game_variables[1] == 6 && $game_variables[2] == 42 || #宿
        $game_variables[1] == 80 && $game_variables[2] == 9 ||
        $game_variables[1] == 72 && $game_variables[2] == 66
        $game_variables[41] = 11
      elsif $game_variables[1] == 14 && $game_variables[2] == 50 || #修行
        $game_variables[1] == 30 && $game_variables[2] == 10 ||
        $game_variables[1] == 60 && $game_variables[2] == 11 ||
        $game_variables[1] == 55 && $game_variables[2] == 66
        chk_training
      elsif $game_variables[1] == 17 && $game_variables[2] == 10 || #時の間
        $game_variables[1] == 21 && $game_variables[2] == 55 ||
        $game_variables[1] == 65 && $game_variables[2] == 12 ||
        $game_variables[1] == 69 && $game_variables[2] == 63 ||
        $game_variables[1] == 44 && $game_variables[2] == 28 && $game_switches[458] == true
        $game_variables[41] = 15
      elsif $game_variables[1] == 44 && $game_variables[2] == 35
        
        if $game_switches[457] == false #セルとサタン戦った
          $game_variables[41] = 2441
        else
          $game_variables[41] = 2461 #2541 #2571 #2591 #2602   #2611
          #2461 (通常はこれ)
        end
      else
        $game_variables[41] = 0
      end
    when 55 #Z4未来悟飯編
      if $game_variables[1] == 56 && $game_variables[2] == 6 ||
        $game_variables[1] == 57 && $game_variables[2] == 6 ||
        $game_variables[1] == 56 && $game_variables[2] == 5 ||
        $game_variables[1] == 57 && $game_variables[2] == 5
          $game_variables[41] = 3621
      else
        $game_variables[41] = 0
      end
    when 56 #Z4ブロリー編
      if $game_variables[1] == 54 && $game_variables[2] == 10 #カード
        chk_card
      elsif $game_variables[1] == 16 && $game_variables[2] == 10 || #宿
        $game_variables[1] == 56 && $game_variables[2] == 44 ||
        $game_variables[1] == 71 && $game_variables[2] == 12
        $game_variables[41] = 11
      elsif $game_variables[1] == 4 && $game_variables[2] == 30 || #修行
        $game_variables[1] == 41 && $game_variables[2] == 28 ||
        $game_variables[1] == 73 && $game_variables[2] == 33
        chk_training
      elsif $game_variables[1] == 7 && $game_variables[2] == 9 || #パラガスとブロリー
        $game_variables[1] == 8 && $game_variables[2] == 9
          $game_variables[41] = 5101
      elsif $game_variables[1] == 66 && $game_variables[2] == 41 #時の間に戻る
        $game_variables[41] = 9903
      else
        $game_variables[41] = 0
      end
    when 97 #Z4 ボージャック編1
      if $game_variables[1] == 10 && $game_variables[2] == 5 || #カード
        $game_variables[1] == 18 && $game_variables[2] == 26 ||
        $game_variables[1] == 46 && $game_variables[2] == 6 ||
        $game_variables[1] == 34 && $game_variables[2] == 37 ||
        $game_variables[1] == 62 && $game_variables[2] == 41
        chk_card
      elsif $game_variables[1] == 16 && $game_variables[2] == 10 || #宿
        $game_variables[1] == 12 && $game_variables[2] == 30 ||
        $game_variables[1] == 46 && $game_variables[2] == 9 ||
        $game_variables[1] == 32 && $game_variables[2] == 39
        $game_variables[41] = 11
      elsif $game_variables[1] == 7 && $game_variables[2] == 8 || #修行
        $game_variables[1] == 13 && $game_variables[2] == 24 ||
        $game_variables[1] == 53 && $game_variables[2] == 7 ||
        $game_variables[1] == 31 && $game_variables[2] == 37 ||
        $game_variables[1] == 65 && $game_variables[2] == 40
        chk_training
      elsif $game_variables[1] == 61 && $game_variables[2] == 11 && #ブージンとゴクア
        $game_switches[591] == false
        $game_variables[41] = 5511
      elsif $game_variables[1] == 12 && $game_variables[2] == 8 #ザンギャエリア左
        $game_variables[41] = 5561
      elsif $game_variables[1] == 63 && $game_variables[2] == 36 #ザンギャエリア右
        $game_variables[41] = 5562
      elsif $game_variables[1] == 7 && $game_variables[2] == 34 #時の間に戻る
        $game_variables[41] = 9912
      else
        $game_variables[41] = 0
      end
    when 98 #Z4 ボージャック編2
      if $game_variables[1] == 6 && $game_variables[2] == 6 || #カード
        $game_variables[1] == 23 && $game_variables[2] == 2 ||
        $game_variables[1] == 25 && $game_variables[2] == 27 ||
        $game_variables[1] == 24 && $game_variables[2] == 42 ||
        $game_variables[1] == 36 && $game_variables[2] == 40 ||
        $game_variables[1] == 49 && $game_variables[2] == 8 ||
        $game_variables[1] == 46 && $game_variables[2] == 19 ||
        $game_variables[1] == 49 && $game_variables[2] == 32
        chk_card
      elsif $game_variables[1] == 3 && $game_variables[2] == 11 || #宿
        $game_variables[1] == 3 && $game_variables[2] == 39 ||
        $game_variables[1] == 28 && $game_variables[2] == 30 ||
        $game_variables[1] == 32 && $game_variables[2] == 22 ||
        $game_variables[1] == 40 && $game_variables[2] == 11 ||
        $game_variables[1] == 40 && $game_variables[2] == 21 ||
        $game_variables[1] == 58 && $game_variables[2] == 3 ||
        $game_variables[1] == 68 && $game_variables[2] == 38
        $game_variables[41] = 11
      elsif $game_variables[1] == 8 && $game_variables[2] == 11 || #修行
        $game_variables[1] == 9 && $game_variables[2] == 43 ||
        $game_variables[1] == 26 && $game_variables[2] == 15 ||
        $game_variables[1] == 26 && $game_variables[2] == 32 ||
        $game_variables[1] == 33 && $game_variables[2] == 15 ||
        $game_variables[1] == 41 && $game_variables[2] == 32 ||
        $game_variables[1] == 43 && $game_variables[2] == 27 ||
        $game_variables[1] == 57 && $game_variables[2] == 9
        chk_training
      elsif $game_variables[1] == 35 && $game_variables[2] == 22 && #ザンギャとビドー
        $game_switches[592] == false
        $game_variables[41] = 5531
      elsif $game_variables[1] == 29 && $game_variables[2] == 21 #ブージンエリア左
        $game_variables[41] = 5563
      elsif $game_variables[1] == 46 && $game_variables[2] == 21 #ブージンエリア右
        $game_variables[41] = 5564
      #elsif $game_variables[1] == 66 && $game_variables[2] == 41 #時の間に戻る
      #  $game_variables[41] = 9912
      else
        $game_variables[41] = 0
      end
    when 99 #Z4 ボージャック編3
      if $game_variables[1] == 15 && $game_variables[2] == 3 || #カード
        $game_variables[1] == 27 && $game_variables[2] == 21 ||
        $game_variables[1] == 32 && $game_variables[2] == 3 ||
        $game_variables[1] == 35 && $game_variables[2] == 11
        chk_card
      elsif $game_variables[1] == 47 && $game_variables[2] == 15 #カード特殊
        $game_variables[44] = 40
        chk_card
      elsif $game_variables[1] == 7 && $game_variables[2] == 10 || #宿
        $game_variables[1] == 22 && $game_variables[2] == 13 ||
        $game_variables[1] == 34 && $game_variables[2] == 8 ||
        $game_variables[1] == 36 && $game_variables[2] == 9 ||
        $game_variables[1] == 43 && $game_variables[2] == 21
        $game_variables[41] = 11
      elsif $game_variables[1] == 17 && $game_variables[2] == 3 || #修行
        $game_variables[1] == 28 && $game_variables[2] == 17 ||
        $game_variables[1] == 32 && $game_variables[2] == 6 ||
        $game_variables[1] == 38 && $game_variables[2] == 17
        chk_training
      elsif $game_variables[1] == 26 && $game_variables[2] == 2 #ボージャック
        #$game_switches[581] == false
        $game_variables[41] = 5571
      elsif $game_variables[1] == 47 && $game_variables[2] == 20 #時の間に戻る
        $game_variables[41] = 9912
      else
        $game_variables[41] = 0
      end
    when 100 #ZG宇宙エリア(バーダック一味)
        
      if $game_variables[1] == 14 && $game_variables[2] == 13 || #カード
        $game_variables[1] == 8 && $game_variables[2] == 26 ||
        $game_variables[1] == 26 && $game_variables[2] == 19
        chk_card
      
      #elsif $game_variables[1] == 4 && $game_variables[2] == 26 || #修行
      #  $game_variables[1] == 13 && $game_variables[2] == 9 ||
      #  $game_variables[1] == 20 && $game_variables[2] == 17
      #  chk_training
        
      elsif $game_variables[1] == 4 && $game_variables[2] == 13 || #宿
       $game_variables[1] == 4 && $game_variables[2] == 22 ||
       $game_variables[1] == 34 && $game_variables[2] == 17
        $game_variables[41] = 11
        
      elsif $game_variables[1] == 5 && $game_variables[2] == 4 && #ターレスの居る星
        $game_switches[597] == false
        $game_variables[41] = 6071
      elsif $game_variables[1] == 5 && $game_variables[2] == 27 && #フリーザの居る星
        $game_switches[597] == true
        $game_variables[41] = 6131
        #$game_variables[41] = 6151
      else
        $game_variables[41] = 0
      end
    when 101 #ZGターレスエリア(バーダック一味)
        
      if $game_variables[1] == 4 && $game_variables[2] == 7 || #カード
        $game_variables[1] == 22 && $game_variables[2] == 25 ||
        $game_variables[1] == 28 && $game_variables[2] == 27 ||
        $game_variables[1] == 43 && $game_variables[2] == 10
        
        chk_card
      
      #elsif $game_variables[1] == 4 && $game_variables[2] == 26 || #修行
      #  $game_variables[1] == 13 && $game_variables[2] == 9 ||
      #  $game_variables[1] == 20 && $game_variables[2] == 17
      #  chk_training
        
      elsif $game_variables[1] == 12 && $game_variables[2] == 7 || #宿
       $game_variables[1] == 26 && $game_variables[2] == 6 ||
       $game_variables[1] == 29 && $game_variables[2] == 20
        $game_variables[41] = 11
        
      elsif $game_variables[1] == 34 && $game_variables[2] == 21 #ターレス
        $game_variables[41] = 6081
      else
        $game_variables[41] = 0
      end
    when 102 #ZGスラッグエリア(バーダック一味)
        
      if $game_variables[1] == 8 && $game_variables[2] == 14 || #カード
        $game_variables[1] == 14 && $game_variables[2] == 28 ||
        $game_variables[1] == 27 && $game_variables[2] == 11 ||
        $game_variables[1] == 28 && $game_variables[2] == 16 ||
        $game_variables[1] == 50 && $game_variables[2] == 3 ||
        $game_variables[1] == 50 && $game_variables[2] == 27
        
        chk_card
      
      #elsif $game_variables[1] == 4 && $game_variables[2] == 26 || #修行
      #  $game_variables[1] == 13 && $game_variables[2] == 9 ||
      #  $game_variables[1] == 20 && $game_variables[2] == 17
      #  chk_training
        
      elsif $game_variables[1] == 3 && $game_variables[2] == 13 || #宿
       $game_variables[1] == 24 && $game_variables[2] == 11 ||
       $game_variables[1] == 22 && $game_variables[2] == 30 ||
       $game_variables[1] == 30 && $game_variables[2] == 19 ||
       $game_variables[1] == 51 && $game_variables[2] == 24
        $game_variables[41] = 11
        
      elsif $game_variables[1] == 51 && $game_variables[2] == 13 #スラッグ
        $game_variables[41] = 6111
      else
        $game_variables[41] = 0
      end
    when 103 #ZGグランドアポロンエリア
        
      if $game_variables[1] == 12 && $game_variables[2] == 4 || #カード
        $game_variables[1] == 1 && $game_variables[2] == 37 ||
        $game_variables[1] == 22 && $game_variables[2] == 26 ||
        $game_variables[1] == 23 && $game_variables[2] == 43 ||
        $game_variables[1] == 46 && $game_variables[2] == 1
        
        chk_card
      
      elsif $game_variables[1] == 9 && $game_variables[2] == 11 || #修行
        $game_variables[1] == 1 && $game_variables[2] == 44 ||
        $game_variables[1] == 27 && $game_variables[2] == 27 ||
        $game_variables[1] == 25 && $game_variables[2] == 42 ||
        $game_variables[1] == 49 && $game_variables[2] == 2 ||
        $game_variables[1] == 55 && $game_variables[2] == 23
        chk_training
        
      elsif $game_variables[1] == 4 && $game_variables[2] == 14 || #宿
       $game_variables[1] == 27 && $game_variables[2] == 24 ||
       $game_variables[1] == 55 && $game_variables[2] == 1 ||
       $game_variables[1] == 46 && $game_variables[2] == 27
        $game_variables[41] = 11
      elsif $game_variables[1] == 22 && $game_variables[2] == 20 || #村
        $game_variables[1] == 22 && $game_variables[2] == 21 ||
        $game_variables[1] == 23 && $game_variables[2] == 20 ||
        $game_variables[1] == 23 && $game_variables[2] == 21
        $game_variables[41] = 6181
      elsif ($game_variables[1] >= 25 && $game_variables[2] >= 18 && #村の近くの鳥
        $game_variables[1] <= 29 && $game_variables[2] <= 22) &&
        $game_switches[804] == true && $game_switches[805] == false #村の近くの鳥の処理をしていない
        $game_switches[805] = true
        $game_variables[39] += 1
        $game_variables[41] = 0
      elsif ($game_variables[1] >= 39 && $game_variables[2] >= 26 && #巣の近くの鳥
        $game_variables[1] <= 43 && $game_variables[2] <= 30) &&
        $game_switches[806] == true && $game_switches[807] == false #巣の近くの鳥の処理をしていない
        $game_switches[807] = true
        $game_variables[39] += 1
        $game_variables[41] = 0
      elsif $game_variables[1] == 4 && $game_variables[2] == 3 || #岩山(デストロン発生装置)
        $game_variables[1] == 4 && $game_variables[2] == 4 ||
        $game_variables[1] == 5 && $game_variables[2] == 3 ||
        $game_variables[1] == 5 && $game_variables[2] == 4
        $game_variables[41] = 6201
      elsif $game_variables[1] == 50 && $game_variables[2] == 40 #鳥の巣
        $game_variables[41] = 6211
      else
        $game_variables[41] = 0
      end
    when 104 #ZG西の砂漠エリア
        
      if $game_variables[1] == 6 && $game_variables[2] == 9 || #カード
        $game_variables[1] == 1 && $game_variables[2] == 30 ||
        $game_variables[1] == 28 && $game_variables[2] == 14 ||
        $game_variables[1] == 28 && $game_variables[2] == 36 ||
        $game_variables[1] == 52 && $game_variables[2] == 10
        chk_card
      
      elsif $game_variables[1] == 7 && $game_variables[2] == 8 || #修行
        $game_variables[1] == 2 && $game_variables[2] == 28 ||
        $game_variables[1] == 23 && $game_variables[2] == 20 ||
        $game_variables[1] == 41 && $game_variables[2] == 6 ||
        $game_variables[1] == 51 && $game_variables[2] == 30
        chk_training
        
      elsif $game_variables[1] == 5 && $game_variables[2] == 5 || #宿
        $game_variables[1] == 15 && $game_variables[2] == 39 ||
        $game_variables[1] == 35 && $game_variables[2] == 19 ||
        $game_variables[1] == 41 && $game_variables[2] == 41 ||
        $game_variables[1] == 47 && $game_variables[2] == 7
        $game_variables[41] = 11
      elsif $game_variables[1] == 37 && $game_variables[2] == 16 || #村
       $game_variables[1] == 37 && $game_variables[2] == 17 ||
       $game_variables[1] == 38 && $game_variables[2] == 16 ||
       $game_variables[1] == 38 && $game_variables[2] == 17
        $game_variables[41] = 6231
      elsif $game_variables[1] == 43 && $game_variables[2] == 30 || #ピラミッド
       $game_variables[1] == 43 && $game_variables[2] == 31 ||
       $game_variables[1] == 44 && $game_variables[2] == 30 ||
       $game_variables[1] == 44 && $game_variables[2] == 31
        $game_variables[41] = 6241
      elsif $game_variables[1] == 7 && $game_variables[2] == 35 || #本物のピラミッド
       $game_variables[1] == 7 && $game_variables[2] == 36 ||
       $game_variables[1] == 8 && $game_variables[2] == 35 ||
       $game_variables[1] == 8 && $game_variables[2] == 36
       
        if $game_switches[814] == true && $game_switches[816] == false
          $game_variables[39] += 1
          $game_variables[41] = 0
          $game_switches[817] = true 
        else
          $game_variables[41] = 6251
          #$game_variables[41] = 6411
        end
      else
        $game_variables[41] = 0
      end
    when 105 #ZGブンブク島エリア
        
      if $game_variables[1] == 8 && $game_variables[2] == 5 || #カード
        $game_variables[1] == 6 && $game_variables[2] == 23 ||
        $game_variables[1] == 35 && $game_variables[2] == 32 ||
        $game_variables[1] == 48 && $game_variables[2] == 9
        chk_card
      
      elsif $game_variables[1] == 8 && $game_variables[2] == 4 || #修行
        $game_variables[1] == 16 && $game_variables[2] == 28 ||
        $game_variables[1] == 36 && $game_variables[2] == 3 ||
        $game_variables[1] == 41 && $game_variables[2] == 23
        chk_training
        
      elsif $game_variables[1] == 8 && $game_variables[2] == 1 || #宿
        $game_variables[1] == 11 && $game_variables[2] == 26 ||
        $game_variables[1] == 29 && $game_variables[2] == 14 ||
        $game_variables[1] == 53 && $game_variables[2] == 22
        $game_variables[41] = 11
      elsif $game_variables[1] == 7 && $game_variables[2] == 31 || #村
       $game_variables[1] == 7 && $game_variables[2] == 32 ||
       $game_variables[1] == 8 && $game_variables[2] == 31 ||
       $game_variables[1] == 8 && $game_variables[2] == 32
        $game_variables[41] = 6281
        $game_variables[41] = 6431 if $game_variables[43] == 173 #シナリオがリキニュウム
      elsif $game_variables[1] == 5 && $game_variables[2] == 3 && #洞穴
        $game_switches[818] == true
        $game_variables[41] = 6291
        $game_variables[41] = 6441 if $game_variables[43] == 173 #シナリオがリキニュウム
      elsif $game_variables[1] == 53 && $game_variables[2] == 2 || #鉱山
       $game_variables[1] == 53 && $game_variables[2] == 3 ||
       $game_variables[1] == 54 && $game_variables[2] == 2 ||
       $game_variables[1] == 54 && $game_variables[2] == 3
        $game_variables[41] = 6296
        $game_variables[41] = 6451 if $game_variables[43] == 173 #シナリオがリキニュウム
      elsif $game_variables[1] == 39 && $game_variables[2] == 12 || #火山
       $game_variables[1] == 39 && $game_variables[2] == 13 ||
       $game_variables[1] == 40 && $game_variables[2] == 12 ||
       $game_variables[1] == 40 && $game_variables[2] == 13
        $game_variables[41] = 6311
        $game_variables[41] = 6471 if $game_variables[43] == 173 #シナリオがリキニュウム
      elsif $game_variables[1] == 53 && $game_variables[2] == 27 || #ピラフの別荘
       $game_variables[1] == 53 && $game_variables[2] == 28 ||
       $game_variables[1] == 54 && $game_variables[2] == 27 ||
       $game_variables[1] == 54 && $game_variables[2] == 28
        $game_variables[41] = 6301
        $game_variables[41] = 6461 if $game_variables[43] == 173 #シナリオがリキニュウム
      elsif $game_variables[1] == 4 && $game_variables[2] == 34 && $game_variables[43] == 173 #時の間へ移動 シナリオがリキニュウム
        #ZGのマップ情報取得
        run_common_event 171
        $game_variables[372] -= 1 #Y座標調整
        $game_variables[41] = 9932
      else
        $game_variables[41] = 0
      end
    when 106 #ZG氷の大陸エリア
        
      if $game_variables[1] == 7 && $game_variables[2] == 3 || #カード
        $game_variables[1] == 15 && $game_variables[2] == 27 ||
        $game_variables[1] == 41 && $game_variables[2] == 11 ||
        $game_variables[1] == 44 && $game_variables[2] == 38
        chk_card
      
      elsif $game_variables[1] == 5 && $game_variables[2] == 5 || #修行
        $game_variables[1] == 3 && $game_variables[2] == 28 ||
        $game_variables[1] == 46 && $game_variables[2] == 4 ||
        $game_variables[1] == 41 && $game_variables[2] == 31
        chk_training
        
      elsif $game_variables[1] == 9 && $game_variables[2] == 5 || #宿
        $game_variables[1] == 21 && $game_variables[2] == 18 ||
        $game_variables[1] == 47 && $game_variables[2] == 35
        $game_variables[41] = 11
        
      elsif ($game_variables[1] == 28 && $game_variables[2] == 4 || #氷破壊装置
       $game_variables[1] == 28 && $game_variables[2] == 5 ||
       $game_variables[1] == 29 && $game_variables[2] == 4 ||
       $game_variables[1] == 29 && $game_variables[2] == 5 ) &&
       $game_switches[823] == false
        $game_variables[41] = 6341
      elsif $game_variables[1] == 7 && $game_variables[2] == 33 || #デストロンガス発生装置
       $game_variables[1] == 7 && $game_variables[2] == 34 ||
       $game_variables[1] == 8 && $game_variables[2] == 33 ||
       $game_variables[1] == 8 && $game_variables[2] == 34
        $game_variables[41] = 6361

      else
        $game_variables[41] = 0
      end
    when 107 #ZG西の都エリア
        
      if $game_variables[1] == 17 && $game_variables[2] == 38 || #カード
        $game_variables[1] == 24 && $game_variables[2] == 10 ||
        $game_variables[1] == 28 && $game_variables[2] == 40 ||
        $game_variables[1] == 46 && $game_variables[2] == 5 ||
        $game_variables[1] == 53 && $game_variables[2] == 39
        chk_card
      
      elsif $game_variables[1] == 4 && $game_variables[2] == 28 || #修行
        $game_variables[1] == 29 && $game_variables[2] == 32 ||
        $game_variables[1] == 32 && $game_variables[2] == 13 ||
        $game_variables[1] == 53 && $game_variables[2] == 11 ||
        $game_variables[1] == 55 && $game_variables[2] ==39
        chk_training
        
      elsif $game_variables[1] == 16 && $game_variables[2] == 18 || #宿
        $game_variables[1] == 23 && $game_variables[2] == 4 ||
        $game_variables[1] == 38 && $game_variables[2] == 28 ||
        $game_variables[1] == 48 && $game_variables[2] == 9 ||
        $game_variables[1] == 54 && $game_variables[2] == 40
        $game_variables[41] = 11
      elsif $game_variables[1] == 5 && $game_variables[2] == 22 || #西の都(トンガリタワー)
       $game_variables[1] == 5 && $game_variables[2] == 23 ||
       $game_variables[1] == 6 && $game_variables[2] == 22 ||
       $game_variables[1] == 6 && $game_variables[2] == 23
        $game_variables[41] = 6401
        #$game_variables[41] = 6491
      elsif $game_variables[1] == 51 && $game_variables[2] == 4 #時の間へ移動
        #ZGのマップ情報取得
        run_common_event 171
        $game_variables[372] -= 1 #Y座標調整
        $game_variables[41] = 9932
      else
        $game_variables[41] = 0
      end
    when 108 #ZGクーン星エリア
        
      if $game_variables[1] == 3 && $game_variables[2] == 8 || #カード
        $game_variables[1] == 6 && $game_variables[2] == 40 ||
        $game_variables[1] == 29 && $game_variables[2] == 12 ||
        $game_variables[1] == 49 && $game_variables[2] == 2 ||
        $game_variables[1] == 53 && $game_variables[2] == 34
        chk_card
      
      elsif $game_variables[1] == 5 && $game_variables[2] == 21 || #修行
        $game_variables[1] == 9 && $game_variables[2] == 40 ||
        $game_variables[1] == 19 && $game_variables[2] == 4 ||
        $game_variables[1] == 29 && $game_variables[2] == 33 ||
        $game_variables[1] == 47 && $game_variables[2] == 2 ||
        $game_variables[1] == 39 && $game_variables[2] == 13 ||
        $game_variables[1] == 51 && $game_variables[2] ==28
        chk_training
        
      elsif $game_variables[1] == 9 && $game_variables[2] == 16 || #宿
        $game_variables[1] == 31 && $game_variables[2] == 21 ||
        $game_variables[1] == 45 && $game_variables[2] == 2 ||
        $game_variables[1] == 47 && $game_variables[2] == 39
        $game_variables[41] = 11
      elsif $game_variables[1] == 24 && $game_variables[2] == 12 #預言者
        $game_variables[41] = 6501
      elsif $game_variables[1] == 5 && $game_variables[2] == 3 && #洞穴
        $game_switches[830] == true
        $game_variables[41] = 6511

      elsif $game_variables[1] == 45 && $game_variables[2] == 32 || #パイレの都
       $game_variables[1] == 45 && $game_variables[2] == 33 ||
       $game_variables[1] == 46 && $game_variables[2] == 32 ||
       $game_variables[1] == 46 && $game_variables[2] == 33
        $game_variables[41] = 6491
      elsif $game_variables[1] == 52 && $game_variables[2] == 40 #時の間へ移動
        #ZGのマップ情報取得
        run_common_event 171
        $game_variables[372] -= 1 #Y座標調整
        $game_variables[41] = 9932
      else
        $game_variables[41] = 0
      end
    when 109 #ZGオウター星エリア
        
      if $game_variables[1] == 29 && $game_variables[2] == 12 || #カード
        $game_variables[1] == 49 && $game_variables[2] == 7 ||
        $game_variables[1] == 51 && $game_variables[2] == 7 ||
        $game_variables[1] == 49 && $game_variables[2] == 36
        chk_card
      
      elsif $game_variables[1] == 11 && $game_variables[2] == 12 || #修行
        $game_variables[1] == 50 && $game_variables[2] == 8 ||
        $game_variables[1] == 10 && $game_variables[2] == 39 ||
        $game_variables[1] == 46 && $game_variables[2] == 36
        chk_training
        
      elsif $game_variables[1] == 17 && $game_variables[2] == 22 || #宿
        $game_variables[1] == 6 && $game_variables[2] == 39 ||
        $game_variables[1] == 50 && $game_variables[2] == 6
        $game_variables[41] = 11
      elsif $game_variables[1] == 31 && $game_variables[2] == 11 || #海賊船
       $game_variables[1] == 32 && $game_variables[2] == 11
        $game_variables[41] = 6541
      elsif $game_variables[1] == 13 && $game_variables[2] == 16 && #クアーの町
        $game_switches[835] == true
        $game_variables[41] = 6551

      elsif $game_variables[1] == 49 && $game_variables[2] == 28 || #渦潮
       $game_variables[1] == 49 && $game_variables[2] == 29 ||
       $game_variables[1] == 50 && $game_variables[2] == 28 ||
       $game_variables[1] == 50 && $game_variables[2] == 29
        $game_variables[41] = 6561

      elsif $game_variables[1] == 5 && $game_variables[2] == 4 #時の間へ移動
        #ZGのマップ情報取得
        run_common_event 171
        $game_variables[372] += 1 #Y座標調整
        $game_variables[41] = 9932
      else
        $game_variables[41] = 0
      end
    when 110 #ZG暗黒惑星エリア
        
      if $game_variables[1] == 8 && $game_variables[2] == 25 || #カード
        $game_variables[1] == 46 && $game_variables[2] == 16
        chk_card
      elsif $game_variables[1] == 26 && $game_variables[2] == 13 #カード特殊
        $game_variables[1] == 46 && $game_variables[2] == 16
        $game_variables[44] = 50
        chk_card
      
      elsif $game_variables[1] == 10 && $game_variables[2] == 25 || #修行
        $game_variables[1] == 46 && $game_variables[2] == 14
        chk_training
        
      elsif $game_variables[1] == 9 && $game_variables[2] == 26 || #宿
        $game_variables[1] == 47 && $game_variables[2] == 15
        $game_variables[41] = 11
        
      elsif $game_variables[1] == 12 && $game_variables[2] == 4 && #護衛ロボA
        $game_switches[840] == false
        $game_variables[41] = 6611
      elsif $game_variables[1] == 13 && $game_variables[2] == 30 && #護衛ロボB
        $game_switches[841] == false
        $game_variables[41] = 6612
      elsif $game_variables[1] == 50 && $game_variables[2] == 4 && #護衛ロボC
        $game_switches[842] == false
        $game_variables[41] = 6613
      elsif $game_variables[1] == 31 && $game_variables[2] == 35 && #護衛ロボD
        $game_switches[843] == false
        $game_variables[41] = 6614
      elsif $game_variables[1] == 49 && $game_variables[2] == 39 && #護衛ロボE
        $game_switches[844] == false
        $game_variables[41] = 6615
        
      elsif $game_variables[1] == 28 && $game_variables[2] == 18 && #扉
        $game_switches[845] == false
        $game_variables[41] = 6601

      elsif $game_variables[1] == 28 && $game_variables[2] == 14 || #怨念増幅装置
       $game_variables[1] == 28 && $game_variables[2] == 15 ||
       $game_variables[1] == 29 && $game_variables[2] == 14 ||
       $game_variables[1] == 29 && $game_variables[2] == 15
        $game_variables[41] = 6631 #ライチーとの戦闘(正しい)
        #$game_variables[41] = 6651 #ハッチヒャックとの戦闘
        #$game_variables[41] = 6681 #オゾットとの戦闘
        #$game_variables[41] = 6711 #オゾット変身との戦闘
        #$game_variables[41] = 6761 #エンディング
        #$game_variables[41] = 2691 #スタッフロール
      elsif $game_variables[1] == 1 && $game_variables[2] == 21 #時の間へ移動
        #ZGのマップ情報取得
        run_common_event 171
        $game_variables[371] += 1 #X座標調整
        $game_variables[41] = 9932
      else
        $game_variables[41] = 0
      end
    else
      $game_variables[41] = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 修行イベントチェック
  #-------------------------------------------------------------------------- 
  def chk_training n = 1
    
    if $game_variables[40] == 0 || $game_variables[40] == 1
      n = 1
    else
      n = 4      
    end

    event_no = rand(n) #カードマスにとまった際のイベント
    $game_variables[222] += 1 #修行マスに止まった回数増加
    #event_no = 3
    case event_no 
   
    when 0 # スピード・敏捷
     $game_variables[41] = 31
    when 1 # ポポ
      $game_variables[41] = 34
    when 2 # ダジャレ
      $game_variables[41] = 33
    when 3 # チチ
      $game_variables[41] = 35
    end
  end
  #--------------------------------------------------------------------------
  # ● カードイベントチェック
  #-------------------------------------------------------------------------- 
  def chk_card n = 3
    event_no = rand(3) #カードマスにとまった際のイベント
    $game_variables[223] += 1 #カードマスに止まった回数増加
    $game_switches[73] = true
    #event_no = 0
    case event_no 
   
    when 0 # ショップ
      $game_variables[41] = 21
    when 1 # カードスピードくじ
      $game_variables[41] = 22
    when 2 # 神経衰弱
      $game_variables[41] = 23
    end
    
    #強制ショップフラグ
    if $game_switches[866] == true
      $game_variables[41] = 21
    end
    
    #強制神経衰弱フラグ
    if $game_switches[867] == true
      $game_variables[41] = 23
    end

    #強制くじフラグ
    if $game_switches[868] == true
      $game_variables[41] = 22
    end

    #強制フラグ初期化
    $game_switches[866] = false
    $game_switches[867] = false
    $game_switches[868] = false
    
    #扱うカードの指定処理
    if $game_variables[44] == 0
      $game_variables[44] = $game_variables[40]
      #神と融合したピッコロとセルが闘っていたらZ4編として扱う
      if $game_switches[431] == true
        $game_variables[44] += 1
      end
      
      #ZG編にいたら
      case $game_variables[43]
      
      when 151..199
        $game_variables[44] += 1
      end
    end
  end
end