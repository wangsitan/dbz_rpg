#==============================================================================
# ■ Icon抽出
#------------------------------------------------------------------------------
# 　IDに対応するアイコンを返すように
#==============================================================================

module Icon
  #--------------------------------------------------------------------------
  # ● アイコン表示(詳細)
  #引数:(card_id:カードID) 
  #--------------------------------------------------------------------------   
  def put_icon card_id
    
    #picture = Cache.picture("顔カード")
    
    case card_id
    #並びが違うものだけ記載
=begin
    when 1 #ドラゴンレーダー
      rect = Rect.new($game_variables[40]*64, 64*0, 64, 64)
    when 2 #一星球
      rect = Rect.new($game_variables[40]*64, 64*1, 64, 64)
    when 3 #二星球
      rect = Rect.new($game_variables[40]*64, 64*2, 64, 64)
    when 4 #三星球
      rect = Rect.new($game_variables[40]*64, 64*3, 64, 64)
    when 5 #四星球
      rect = Rect.new($game_variables[40]*64, 64*4, 64, 64)
    when 6 #五星球
      rect = Rect.new($game_variables[40]*64, 64*5, 64, 64)
    when 7 #六星球
      rect = Rect.new($game_variables[40]*64, 64*6, 64, 64)
    when 8 #七星球
      rect = Rect.new($game_variables[40]*64, 64*7, 64, 64)
    when 9 #ブルマ
      rect = Rect.new($game_variables[40]*64, 64*8, 64, 64)
    when 10 #亀仙人
      rect = Rect.new($game_variables[40]*64, 64*9, 64, 64)
    when 11 #神様
      rect = Rect.new($game_variables[40]*64, 64*10, 64, 64)
    when 12 #プーアル
      rect = Rect.new($game_variables[40]*64, 64*11, 64, 64)
=end
    when 13 #ブルマの母
      rect = Rect.new($game_variables[40]*64, 64*37, 64, 64)
    when 14 #ミスターポポ
      rect = Rect.new($game_variables[40]*64, 64*12, 64, 64)
    when 15 #カリン様
      rect = Rect.new($game_variables[40]*64, 64*13, 64, 64)
    when 16 #デンデ
      rect = Rect.new($game_variables[40]*64, 64*14, 64, 64)
    when 17 #仙豆
      rect = Rect.new($game_variables[40]*64, 64*15, 64, 64)
    when 18 #シェンロン
      rect = Rect.new($game_variables[40]*64, 64*16, 64, 64)
    when 19 #エンマ様
      rect = Rect.new($game_variables[40]*64, 64*17, 64, 64)
    when 20 #占いババ
      rect = Rect.new($game_variables[40]*64, 64*18, 64, 64)
    when 21 #牛魔王
      rect = Rect.new($game_variables[40]*64, 64*35, 64, 64)
    when 22 #ランチ
      rect = Rect.new($game_variables[40]*64, 64*33, 64, 64)
    when 23 #チチ
      rect = Rect.new($game_variables[40]*64, 64*19, 64, 64)
    when 24 #ウーロン
      rect = Rect.new($game_variables[40]*64, 64*20, 64, 64)
    when 25 #グレゴリー
      rect = Rect.new($game_variables[40]*64, 64*21, 64, 64)
    when 26 #ランチ金髪
      rect = Rect.new($game_variables[40]*64, 64*34, 64, 64)
    when 27 #バブルス
      rect = Rect.new($game_variables[40]*64, 64*22, 64, 64)
    when 28 #ブリーフ博士
      rect = Rect.new($game_variables[40]*64, 64*36, 64, 64)
    when 29 #ヤジロベー
      rect = Rect.new($game_variables[40]*64, 64*23, 64, 64)
    when 30 #じいちゃん
      rect = Rect.new($game_variables[40]*64, 64*24, 64, 64)
    when 31 #ムーリ
      rect = Rect.new($game_variables[40]*64, 64*38, 64, 64)
    when 32 #界王様
      rect = Rect.new($game_variables[40]*64, 64*25, 64, 64)
    when 33 #最長老
      rect = Rect.new($game_variables[40]*64, 64*30, 64, 64)
    when 34 #スカウター
      rect = Rect.new($game_variables[40]*64, 64*26, 64, 64)
    when 35 #シッポ
      rect = Rect.new($game_variables[40]*64, 64*27, 64, 64)
    when 36 #月
      rect = Rect.new($game_variables[40]*64, 64*28, 64, 64)
    when 37 #舞空術
      rect = Rect.new($game_variables[40]*64, 64*29, 64, 64)
    when 38 #ポルンガ
      rect = Rect.new($game_variables[40]*64, 64*31, 64, 64)
    when 39 #カエル
      rect = Rect.new($game_variables[40]*64, 64*32, 64, 64)
=begin
    when 40 #超神水
      rect = Rect.new($game_variables[40]*64, 64*39, 64, 64)
    when 41 #バトルスーツ
      rect = Rect.new($game_variables[40]*64, 64*40, 64, 64)
    when 42 #Sランク
      rect = Rect.new($game_variables[40]*64, 64*41, 64, 64)
    when 43 #Aランク
      rect = Rect.new($game_variables[40]*64, 64*42, 64, 64)
    when 44 #Bランク
      rect = Rect.new($game_variables[40]*64, 64*43, 64, 64)
    when 45 #Cランク
      rect = Rect.new($game_variables[40]*64, 64*44, 64, 64)
    when 46 #ホイポイカプセル
      rect = Rect.new($game_variables[40]*64, 64*45, 64, 64)
    when 47 #回復カプセル
      rect = Rect.new($game_variables[40]*64, 64*46, 64, 64)
    when 48 #未来の薬
      rect = Rect.new($game_variables[40]*64, 64*47, 64, 64)
    when 49 #蛇姫
      rect = Rect.new($game_variables[40]*64, 64*48, 64, 64)
    when 50 #ウミガメ
      rect = Rect.new($game_variables[40]*64, 64*49, 64, 64)
    when 51 #ゴズ
      rect = Rect.new($game_variables[40]*64, 64*50, 64, 64)
    when 52 #メズ
      rect = Rect.new($game_variables[40]*64, 64*51, 64, 64)
    when 53 #少年
      rect = Rect.new($game_variables[40]*64, 64*52, 64, 64)
    when 54 #カナッサ星人
      rect = Rect.new($game_variables[40]*64, 64*53, 64, 64)
    when 55 #月とシッポ
      rect = Rect.new($game_variables[40]*64, 64*54, 64, 64)
    when 56 #玉手箱
      rect = Rect.new($game_variables[40]*64, 64*55, 64, 64)
    when 57 #薬草
      rect = Rect.new($game_variables[40]*64, 64*56, 64, 64)
    when 58 #下剤
      rect = Rect.new($game_variables[40]*64, 64*57, 64, 64)
    when 59 #ダイナマイト
      rect = Rect.new($game_variables[40]*64, 64*58, 64, 64)
    when 60 #ちょっと回復
      rect = Rect.new($game_variables[40]*64, 64*59, 64, 64)
    when 61 #全回
      rect = Rect.new($game_variables[40]*64, 64*60, 64, 64)
    when 62 #ルーレット
      rect = Rect.new($game_variables[40]*64, 64*61, 64, 64)
    when 63 #取り換え
      rect = Rect.new($game_variables[40]*64, 64*62, 64, 64)
    when 64 #必殺技
      rect = Rect.new($game_variables[40]*64, 64*63, 64, 64)
    when 65 #追い払う
      rect = Rect.new($game_variables[40]*64, 64*64, 64, 64)
    when 66 #テレポート
      rect = Rect.new($game_variables[40]*64, 64*65, 64, 64)
    when 67 #インフォメーション
      rect = Rect.new($game_variables[40]*64, 64*66, 64, 64)
    when 68 #逆さま
      rect = Rect.new($game_variables[40]*64, 64*67, 64, 64)
    when 69 #全員回復
      rect = Rect.new($game_variables[40]*64, 64*68, 64, 64)
    when 70 #リングアナ
      rect = Rect.new($game_variables[40]*64, 64*69, 64, 64)
=end
    else
      rect = Rect.new($game_variables[40]*64, 64*(card_id-1), 64, 64)
    end
    
    return rect
  end
end
