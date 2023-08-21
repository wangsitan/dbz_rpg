module Share_Sub_battle_arena
  #--------------------------------------------------------------------------
  # ● メイン編とバトルアリーナ　カード入れ替え
  #--------------------------------------------------------------------------
  def main_btl_arena_cardchange
    $game_party_temp = Marshal.load(Marshal.dump($game_party)) if $game_party_temp == nil
    $game_party_temp , $game_party = $game_party , $game_party_temp
  end
   #--------------------------------------------------------------------------
  # ● バトルアリーナ名を返す
  # 引数　　fight_rank:バトルアリーナのランク
  # 戻り値　return:バトルアリーナ名
  #--------------------------------------------------------------------------
  def get_btl_arena_fight_name fight_rank = 0
    
    fight_name = ""
    case fight_rank

      when 1 #ラディッツ
        fight_name = "ラディッツ"
      when 2
        fight_name = "ガーリックいちみ1"
      when 3
        fight_name = "ガーリックいちみ2"
      when 4
        fight_name = "ガーリック"
      when 5
        fight_name = "カイオウさま"
      when 6
        fight_name = "ナッパ"
      when 7
        fight_name = "ベジータ"
      when 8
        fight_name = "バイオせんし"
      when 9
        fight_name = "ウィロー"
      when 10
        fight_name = "Z1ボスラッシュ"
      when 11
        fight_name = "キュイ"
      when 12
        fight_name = "ドドリア"
      when 13
        fight_name = "ザーボン"
      when 14
        fight_name = "ギニューとくせんたい"
      when 15
        fight_name = "フリーザいちみ"
      when 16
        fight_name = "フリーザ(だい1けいたい)"
      when 17
        fight_name = "フリーザ(だい2けいたい)"
      when 18
        fight_name = "フリーザ(だい3けいたい)"
      when 19
        fight_name = "ターレス／スラッグ"
      when 20
        fight_name = "フリーザ(さいしゅうけいたい)"
      when 21
        fight_name = "ベジータ(スーパー)"
      when 22
        fight_name = "フリーザ(フルパワー)"
      when 23
        fight_name = "クラズ"
      when 24
        fight_name = "ピラール"
      when 25
        fight_name = "ガーリックいちみ(Z3)"
      when 26
        fight_name = "カイズ"
      when 27
        fight_name = "Z3ボスラッシュ1"
      when 28
        fight_name = "フリーザ"
      when 29
        fight_name = "フリーザ(サイボーグ)"
      when 30
        fight_name = "クウラきこうせんたい"
      when 31
        fight_name = "クウラ"
      when 32
        fight_name = "19ごう／20ごう"
      when 33
        fight_name = "17ごう／18ごう"
      when 34
        fight_name = "16ごう"
      when 35
        fight_name = "Z3ボスラッシュ2"
      when 36
        fight_name = "Z3ボスラッシュ3"
      when 37
        fight_name = "Z3ボスラッシュ4"
      when 38
        fight_name = "ウィローいちみ(Z4)"
      when 39
        fight_name = "セル(だい1けいたい)"
      when 40
        fight_name = "セル(だい2けいたい)"
      when 41
        fight_name = "メタルクウラ"
      when 42
        fight_name = "メタルクウラ・コア"
      when 43
        fight_name = "13ごう／14ごう／15ごう"
      when 44
        fight_name = "タオパイパイ"
      when 45
        fight_name = "セル(かんぜんたい)"
      when 46
        fight_name = "Z4ボスラッシュ1"
      when 47
        fight_name = "Z4ボスラッシュ2"
      when 48
        fight_name = "Z4ボスラッシュ3"
      when 49
        fight_name = "ブロリー"
      when 50
        fight_name = "ボージャック"
      when 51
        fight_name = "チルド"
      when 52
        fight_name = "ターレスいちみ(Z2)"
      when 53
        fight_name = "スラッグいちみ(Z2)"
      when 54
        fight_name = "クウラいちみ(ZG)"
      when 55
        fight_name = "ターレスいちみ(ZG)"
      when 56
        fight_name = "スラッグいちみ(ZG)"
      when 57
        fight_name = "フリーザいちみ(ZG)"
      when 58
        fight_name = "ゴーストせんし"
      when 59
        fight_name = "ギニューとくせんたい(ZG)"
      when 60
        fight_name = "チルド(ZG)"
      when 61
        fight_name = "ゴッドガードン"
      when 62
        fight_name = "ライチー／ハッチヒャック"
      when 63
        fight_name = "ZGボスラッシュ1"
      when 64
        fight_name = "ZGボスラッシュ2"
      when 65
        fight_name = "ZGボスラッシュ3"
      when 66
        fight_name = "オゾット"
      when 67
        fight_name = "パイクーハン"
      when 68
        fight_name = "ブウ"
      when 69
        fight_name = "アラレ"
      when 70
        fight_name = "ガーリック(かくせい)"
      when 71
        fight_name = "ウィロー(かくせい)"
      when 72
        fight_name = "ターレス(かくせい)"
      when 73
        fight_name = "スラッグ(かくせい)"
      when 74
        fight_name = "フリーザ(かくせい)"
      when 75
        fight_name = "クウラ(かくせい)"
      when 76
        fight_name = "19ごう／20ごう(かくせい)"
      when 77
        fight_name = "セル(だい1・かくせい)"
      when 78
        fight_name = "セル(だい2・かくせい)"
      when 79
        fight_name = "メタルクウラ・コア(かくせい)"
      when 80
        fight_name = "13ごう(かくせい)"
      when 81
        fight_name = "セル(パーフェクト・かくせい)"
      when 82
        fight_name = "ブロリー(かくせい)"
      when 83
        fight_name = "ボージャック(かくせい)"
      when 84
        fight_name = "チルド(かくせい)"
      when 85
        fight_name = "ライチー(かくせい)"
      when 86
        fight_name = "ハッチヒャック(かくせい)"
      when 87
        fight_name = "オゾット(かくせい)"
      when 88
        fight_name = "パイクーハン(かくせい)"
      when 89
        fight_name = "ブウ(かくせい)"
      when 90
        fight_name = "フリーザ(フルパワー・かくせい)"
      when 91
        fight_name = "ベジータ(スーパー・かくせい)"
    end
    
    return fight_name
  end
  #--------------------------------------------------------------------------
  # ● バトルアリーナ敵のセット
  #--------------------------------------------------------------------------
  def set_btl_arena_fight_rank winrank = 0

    if winrank == 0
      #p $btl_arena_fight_rank_clear_num.size
      temp_winrank = $btl_arena_fight_rank_clear_num.size
    else
      temp_winrank = winrank
    end
    
    for x in winrank..temp_winrank
      
      #初期化
      #if $btl_arena_fight_rank[x] == nil
      #  $btl_arena_fight_rank[x] = false
      #end
      
      #if $btl_arena_fight_rank_clear_num[x] == nil
      #  $btl_arena_fight_rank_clear_num[x] = 0
      #end
      
      case x
      
      when 1..5
        #p $btl_arena_fight_rank,$btl_arena_fight_rank_clear_num
        $btl_arena_fight_rank[x] = true if $btl_arena_fight_rank_clear_num[x-1] > 0
      when 6 #ナッパ撃破
        $btl_arena_fight_rank[x] = true if $game_switches[68] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 7 #ベジータ撃破
        $btl_arena_fight_rank[x] = true if $game_switches[502] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 8 #ウィロー一味撃破
        #p $btl_arena_fight_rank_clear_num[x-2]
        $btl_arena_fight_rank[x] = true if $game_switches[520] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 9 #ウィロー撃破
        #Z1ボスラッシュ
        $btl_arena_fight_rank[x] = true if $game_switches[520] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
        #Z2キュイ
        $btl_arena_fight_rank[x+1] = true if $game_switches[87] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 10 #Z1ボスラッシュ1撃破
        
      when 11 #Z2キュイ撃破
        $btl_arena_fight_rank[x] = true if $game_switches[88] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 12 #Z2ドドリア撃破
        $btl_arena_fight_rank[x] = true if $game_switches[522] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 13 #Z2ザーボン撃破
        $btl_arena_fight_rank[x] = true if $game_switches[528] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 14 #Z2ギニュー特戦隊撃破
        #Z2フリーザ一味
        $btl_arena_fight_rank[x] = true if $btl_arena_fight_rank_clear_num[x-1] > 0
        #Z2フリーザ第一形態
        $btl_arena_fight_rank[x+1] = true if $game_switches[529] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 15 #Z2フリーザ一味撃破
        
      when 16 #Z2フリーザ第一形態撃破
        $btl_arena_fight_rank[x] = true if $game_switches[530] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 17 #Z2フリーザ第二形態撃破
        $btl_arena_fight_rank[x] = true if $game_switches[531] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 18 #Z2フリーザ第三形態撃破
        $btl_arena_fight_rank[x] = true if $game_switches[119] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 || $game_switches[109] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 19 #Z2ターレス、スラッグ撃破
        $btl_arena_fight_rank[x] = true if $game_switches[119] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 20 #Z2フリーザ第四形態撃破
        $btl_arena_fight_rank[x] = true if $game_switches[119] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
        $btl_arena_fight_rank[x+1] = true if $game_switches[119] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 21 #Z2超ベジータ撃破
        #Z3クラズ
        $btl_arena_fight_rank[x+1] = true if $game_switches[521] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 22 #Z2フリーザフルパワー撃破
        $btl_arena_fight_rank[x] = true if $game_switches[521] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 23 #Z3クラズ撃破
        $btl_arena_fight_rank[x] = true if $game_switches[532] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 24 #Z3ピラール撃破
        $btl_arena_fight_rank[x] = true if $game_switches[545] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 25 #Z3ガーリック撃破
        $btl_arena_fight_rank[x] = true if $game_switches[421] == true && $btl_arena_fight_rank_clear_num[x-1] > 0

      when 26 #Z3カイズ撃破
        $btl_arena_fight_rank[x] = true if $btl_arena_fight_rank_clear_num[x-1] > 0
        $btl_arena_fight_rank[x+1] = true if $btl_arena_fight_rank_clear_num[x-1] > 0
      when 27 #Z3クラズ～カイズ撃破
        
      when 28 #フリーザ撃破
        $btl_arena_fight_rank[x] = true if $btl_arena_fight_rank_clear_num[x-1] > 0
      when 29 #サイボーグフリーザ撃破
        $btl_arena_fight_rank[x] = true if $game_switches[534] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 30 #クウラ機甲戦隊撃破
        $btl_arena_fight_rank[x] = true if $game_switches[533] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 31 #クウラ撃破
        $btl_arena_fight_rank[x] = true if $game_switches[426] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 32 #20,19号撃破
        $btl_arena_fight_rank[x] = true if $game_switches[431] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 33 #18,17号撃破
        $btl_arena_fight_rank[x] = true if $game_switches[431] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 34 #16号撃破
        #Z3ボスラッシュ1
        $btl_arena_fight_rank[x] = true if $game_switches[431] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
        #Z3ボスラッシュ2
        $btl_arena_fight_rank[x+1] = true if $game_switches[431] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
        #Z3ボスラッシュ3
        $btl_arena_fight_rank[x+2] = true if $game_switches[431] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
        #Z4ウィロー
        $btl_arena_fight_rank[x+3] = true if $game_switches[561] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 35 #Z3ボスラッシュ1
        #Z4ウィロー
        $btl_arena_fight_rank[x+2] = true if $game_switches[561] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 36 #Z3ボスラッシュ2
        #Z4ウィロー
        $btl_arena_fight_rank[x+1] = true if $game_switches[561] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 37 #Z3ボスラッシュ3
        #Z4ウィロー
        $btl_arena_fight_rank[x] = true if $game_switches[561] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 38 #Z4ウィロー
        $btl_arena_fight_rank[x] = true if $game_switches[563] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 39 #Z4セル(第一形態)
        $btl_arena_fight_rank[x] = true if $game_switches[564] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 40 #Z4セル(第二形態)
        $btl_arena_fight_rank[x] = true if $game_switches[566] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 41 #Z4メタルクウラ
        $btl_arena_fight_rank[x] = true if $game_switches[567] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 42 #Z4メタルクウラ・コア
        $btl_arena_fight_rank[x] = true if $game_switches[568] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 43 #Z4人造人間13～15号
        $btl_arena_fight_rank[x] = true if $game_switches[568] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 44 #タオパイパイ
        $btl_arena_fight_rank[x] = true if $game_switches[459] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 45 #Z4セル(パーフェクト)／完全体
        $btl_arena_fight_rank[x] = true if $game_switches[459] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
        $btl_arena_fight_rank[x+1] = true if $game_switches[459] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
        $btl_arena_fight_rank[x+2] = true if $game_switches[459] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
        $btl_arena_fight_rank[x+3] = true if $game_switches[580] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 46 #Z4ボスラッシュ1
        #Z4ウィロー
        #$btl_arena_fight_rank[x+2] = true if $game_switches[580] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 47 #Z4ボスラッシュ2
        #Z4ウィロー
        #$btl_arena_fight_rank[x+1] = true if $game_switches[580] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 48 #Z4ボスラッシュ3
        #Z4ウィロー
        #$btl_arena_fight_rank[x] = true if $game_switches[580] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 49 #Z4ブロリー
        $btl_arena_fight_rank[x] = true if $game_switches[581] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 50 #Z4ボージャック
        $btl_arena_fight_rank[x] = true if $game_switches[585] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 51 #Z4チルド
        $btl_arena_fight_rank[x] = true if ($game_switches[598] == true || $game_switches[586] == true) && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 52 #Z2バーダック一味編(ターレス)
        $btl_arena_fight_rank[x] = true if ($game_switches[598] == true || $game_switches[586] == true) && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 53 #Z2バーダック一味編(スラッグ)
        $btl_arena_fight_rank[x] = true if ($game_switches[810] == true || $game_switches[586] == true) && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 54 #ZGクウラ一味
        $btl_arena_fight_rank[x] = true if ($game_switches[815] == true || $game_switches[586] == true) && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 55 #ZGターレス一味
        $btl_arena_fight_rank[x] = true if ($game_switches[822] == true || $game_switches[586] == true) && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 56 #ZGスラッグ一味
        $btl_arena_fight_rank[x] = true if ($game_switches[824] == true || $game_switches[586] == true) && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 57 #ZGフリーザ一味
        $btl_arena_fight_rank[x] = true if ($game_switches[825] == true || $game_switches[586] == true) && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 58 #ZGゴースト戦士
        $btl_arena_fight_rank[x] = true if ($game_switches[831] == true || $game_switches[586] == true) && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 59 #ZGギニュー特戦隊
        $btl_arena_fight_rank[x] = true if ($game_switches[839] == true || $game_switches[586] == true) && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 60 #ZGチルド
        $btl_arena_fight_rank[x] = true if ($game_switches[845] == true || $game_switches[586] == true) && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 61 #ZGゴッドガードン
        $btl_arena_fight_rank[x] = true if ($game_switches[847] == true || $game_switches[586] == true) && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 62 #ZGライチ／ハッチヒャック
        $btl_arena_fight_rank[x] = true if ($game_switches[847] == true || $game_switches[586] == true) && $btl_arena_fight_rank_clear_num[x-1] > 0
        $btl_arena_fight_rank[x+1] = true if ($game_switches[847] == true || $game_switches[586] == true) && $btl_arena_fight_rank_clear_num[x-1] > 0
        $btl_arena_fight_rank[x+2] = true if ($game_switches[847] == true || $game_switches[586] == true) && $btl_arena_fight_rank_clear_num[x-1] > 0
        $btl_arena_fight_rank[x+3] = true if ($game_switches[849] == true || $game_switches[586] == true) && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 63 #ZGボスラッシュ1
        
      when 64 #ZGボスラッシュ2
        
      when 65 #ZGボスラッシュ3
        #$btl_arena_fight_rank[x] = true if $game_switches[849] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 66 #ZGオゾット
        $btl_arena_fight_rank[x] = true if $game_switches[587] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 67 #ZGパイクーハン
        $btl_arena_fight_rank[x] = true if $game_switches[600] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 68 #ZGブウ
        #アラレと会ったか？
        #アラレと会うイベントの発声条件はバトルアリーナすべてクリア＆全ての敵の図鑑を埋める
        #DB3のエンディングでアラレ表示時に決定ボタンを押す
        $btl_arena_fight_rank[x] = true if $game_switches[852] == true && $btl_arena_fight_rank_clear_num[x-1] > 0
      when 69 #ZGアラレ
        #覚醒ガーリック
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 70 #覚醒ガーリック
        #覚醒ウィロー
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 71 #覚醒ウィロー
        #覚醒ターレス
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 72 #覚醒ターレス
        #覚醒スラッグ
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 73 #覚醒スラッグ
        #覚醒フリーザ
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 74 #覚醒フリーザ
        #覚醒クウラ
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 75 #覚醒クウラ
        #覚醒19/20号
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 76 #覚醒19/20号
        #覚醒セル1
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 77 #覚醒セル1
        #覚醒セル2
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 78 #覚醒セル2
        #覚醒メタルクウラ・コア
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 79 #覚醒メタルクウラ・コア
        #覚醒13号
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 80 #覚醒13号
        #覚醒セル完全体
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 81 #覚醒セル完全体
        #覚醒ブロリー
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 82 #覚醒ブロリー
        #覚醒ボージャック
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 83 #覚醒ボージャック
        #覚醒チルド
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 84 #覚醒チルド
        #覚醒ライチー
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 85 #覚醒ライチー
        #覚醒ハッチヒャック
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 86 #覚醒ハッチヒャック
        #覚醒オゾット
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 87 #覚醒オゾット
        #覚醒パイクーハン
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 88 #覚醒パイクーハン
        #覚醒ブウ
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 89 #覚醒ブウ
        #覚醒フルパワーフリーザ
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      when 90 #覚醒フルパワーフリーザ
        #覚醒超ベジータ
        #ゲーム周回プレイ(1週目以上) かつオゾット変身撃破(ZGクリア)
        $btl_arena_fight_rank[x] = true if $game_switches[860] == true && $btl_arena_fight_rank_clear_num[x-1] > 0 && $game_switches[849] == true && $game_laps >= 1
      end
    end
  end

  #--------------------------------------------------------------------------
  # ● バトルアリーナ敵のセット
  #-------------------------------------------------------------------------- 
  def battle_arena_ene_set
    
    #ランク毎に分岐し敵Noセット
    $game_variables[281] = rand(3)+1
    $game_variables[284] = $game_variables[282] #賞品Noセット
    
    #変数初期化
    $set_btlarn_bgm = 0 #戦闘曲
    $set_btlarn_ready_bgm = 0 #戦闘前曲
    
    case $game_variables[282]
    
    when 1 #ラディッツ
      $set_btlarn_bgm = 8
      if $game_variables[283] == 1
        #$game_variables[284] = 1 #賞品Noセット
        if $game_variables[281] == 1
          $battleenemy = [1,2,1,2,1]
        elsif $game_variables[281] == 2
          $battleenemy = [2,1,2,1,2]
        elsif $game_variables[281] == 3
          $battleenemy = [4,5,5,4]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1
          $battleenemy = [1,4,6,5,2]
        elsif $game_variables[281] == 2
          $battleenemy = [5,6,6,5]
        elsif $game_variables[281] == 3
          $battleenemy = [4,5,6,5,4]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 32
        $game_switches[26] = true
        $battleenemy = [10]
      end
      
    when 2 #サンショ,ニッキー,ジンジャー
      $set_btlarn_bgm = 9
      if $game_variables[283] == 1
        #$game_variables[284] = 2 #賞品Noセット
        $battleenemy = [15]
      elsif $game_variables[283] == 2
        $battleenemy = [14]
      elsif $game_variables[283] == 3
        #$set_btlarn_bgm = 10
        #$game_switches[26] = true
        $battleenemy = [13] 
      end
    when 3 #ガーリック一味
      $set_btlarn_bgm = 9
      if $game_variables[283] == 1
        #$game_variables[284] = 3 #賞品Noセット
        if $game_variables[281] == 1
          $battleenemy = [1,2,1,2,1]
        elsif $game_variables[281] == 2
          $battleenemy = [2,1,2,1,2]
        elsif $game_variables[281] == 3
          $battleenemy = [1,1,2,2,1,1]
        end
      elsif $game_variables[283] == 2
        $battleenemy = [7,7,8,8,9,9]
      elsif $game_variables[283] == 3
        #$set_btlarn_bgm = 10
        #$game_switches[26] = true
        $battleenemy = [13,14,15]
      end
    when 4 #ガーリック変身
      $set_btlarn_bgm = 9
      if $game_variables[283] == 1
        #$game_variables[284] = 4 #賞品Noセット
        if $game_variables[281] == 1
          $battleenemy = [1,1,2,2,1,1]
        elsif $game_variables[281] == 2
          $battleenemy = [7,7,8,8,9,9]
        elsif $game_variables[281] == 3
          $battleenemy = [13,14,15]
        end
      elsif $game_variables[283] == 2
        $battleenemy = [16]
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZMove_M814A
        $game_switches[26] = true
        if $game_variables[281] == 1
          $battleenemy = [17,13,14,15]
        elsif $game_variables[281] == 2
          $battleenemy = [17,13,14,15]
        elsif $game_variables[281] == 3
          $battleenemy = [17]
        end
      end
    when 5 #界王様
      $set_btlarn_bgm = 8
      if $game_variables[283] == 1
        #$game_variables[284] = 5 #賞品Noセット
        
        if $game_variables[281] == 1
          $battleenemy = [4,5,10,5,4]
        elsif $game_variables[281] == 2
          $battleenemy = [6,5,10,5,6]
        elsif $game_variables[281] == 3
          $battleenemy = [4,6,10,6,4]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1
          $battleenemy = [7,7,13,7,7]
        elsif $game_variables[281] == 2
          $battleenemy = [8,8,14,8,8]
        elsif $game_variables[281] == 3
          $battleenemy = [9,9,15,9,9]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZSSD_training_for_gb
        $battleenemy = [18]
      end
    when 6 #ナッパ
      $set_btlarn_bgm = 8
      if $game_variables[283] == 1
        #$game_variables[284] = 6 #賞品Noセット
        if $game_variables[281] == 1
          $battleenemy = [4,4,4,4,4]
        elsif $game_variables[281] == 2
          $battleenemy = [5,5,5,5,5]
        elsif $game_variables[281] == 3
          $battleenemy = [6,6,6,6,6]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1
          $battleenemy = [3,3,3,3,3,3]
        elsif $game_variables[281] == 2
          $battleenemy = [3,3,3,3,3]
        elsif $game_variables[281] == 3
          $battleenemy = [1,3,3,3,2]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 34
        $game_switches[27] = true
        $battleenemy = [11]
      end
    when 7 #ベジータ
      $set_btlarn_bgm = 8
      if $game_variables[283] == 1
        #$game_variables[284] = 7 #賞品Noセット
        if $game_variables[281] == 1
          $battleenemy = [4,4,4,4,4]
        elsif $game_variables[281] == 2
          $battleenemy = [5,5,5,5,5]
        elsif $game_variables[281] == 3
          $battleenemy = [6,6,6,6,6]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1
          $battleenemy = [3,3,3,3,3,3]
        elsif $game_variables[281] == 2
          $battleenemy = [3,3,3,3,3]
        elsif $game_variables[281] == 3
          $battleenemy = [1,3,3,3,2]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 35
        $game_switches[27] = true
        $battleenemy = [12]
      end
    when 8 #バイオ戦士
      $set_btlarn_bgm = 8
      if $game_variables[283] == 1
        #$game_variables[284] = 8 #賞品Noセット
        if $game_variables[281] == 1
          $battleenemy = [1,2,3,2,1]
        elsif $game_variables[281] == 2
          $battleenemy = [1,2,3,2,1]
        elsif $game_variables[281] == 3
          $battleenemy = [1,2,3,3,2,1]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1
          $battleenemy = [3,3,25,25,3,3]
        elsif $game_variables[281] == 2
          $battleenemy = [3,3,25,25,3,3]
        elsif $game_variables[281] == 3
          $battleenemy = [3,3,25,3,3]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZMove_M814A
        $battleenemy = [23,24,22]
      end
    when 9 #Drウィロー
      $set_btlarn_bgm = 8
      if $game_variables[283] == 1
        #$game_variables[284] = 9 #賞品Noセット
        $battleenemy = [3,3,3,3,3]
      elsif $game_variables[283] == 2
        $battleenemy = [25,25,25,25]
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZMove_ikusa_btl2
        $battleenemy = [20]
      end
    when 10 #Z1ボスセット
      if $game_variables[283] == 1
        #$game_variables[284] = 10 #賞品Noセット
        $set_btlarn_bgm = 9
        $battleenemy = [17,13,14,15]
      elsif $game_variables[283] == 2
        $set_btlarn_bgm = 11
        $battleenemy = [10,12,11]
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZMove_ikusa
        $battleenemy = [20,23,24,22]
      end
    when 11 #Z2キュイ
      $set_btlarn_bgm = 13
      if $game_variables[283] == 1
        #$game_variables[284] = 11 #賞品Noセット
        $battleenemy = [31,31,34,34,37,37]
      elsif $game_variables[283] == 2
        $battleenemy = [31,32,34,35,37,38]
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 38
        $battleenemy = [40,32,35,38]
      end
    when 12 #Z2ドドリア
      $set_btlarn_bgm = 13
      if $game_variables[283] == 1
        #$game_variables[284] = 11 #賞品Noセット
        $battleenemy = [31,32,34,35,37,38]
      elsif $game_variables[283] == 2
        $battleenemy = [32,32,35,35,38,38]
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 38
        $battleenemy = [43,35,32,32]
      end
    when 13 #Z2ザーボン
      $set_btlarn_bgm = 13
      if $game_variables[283] == 1
        #$game_variables[284] = 11 #賞品Noセット
        if $game_variables[281] == 1
          $battleenemy = [33,36,41,41,39,33]
        else
          $battleenemy = [33,33,36,36,39,39]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1
          $battleenemy = [45,33,36,39]
        else
          $battleenemy = [33,33,36,45,36,39,39]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 38
        if $game_variables[281] == 1
          $battleenemy = [33,33,36,46,36,39,39]
        else
          $battleenemy = [41,46,41]
        end
      end
    when 14 #Z2ギニュー特戦隊
      $set_btlarn_bgm = 13
      if $game_variables[283] == 1
        #$game_variables[284] = 11 #賞品Noセット
        if $game_variables[281] == 1
          $battleenemy = [33,36,41,41,39,33]
        else
          $battleenemy = [33,33,36,36,39,39]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1
          $battleenemy = [33,36,41,41,39,33]
        else
          $battleenemy = [33,33,36,36,39,39]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 39
        $battleenemy = [51,52,48,49,50]
      end
    when 15 #Z2フリーザ一味
      $set_btlarn_bgm = 37
      if $game_variables[283] == 1
        #$game_variables[284] = 11 #賞品Noセット
        if $game_variables[281] == 1
          $battleenemy = [33,36,41,41,39,33]
        elsif $game_variables[281] == 2
          $battleenemy = [33,33,36,36,41,41]
        elsif $game_variables[281] == 3
          $battleenemy = [33,33,36,36,39,39]
        end
      elsif $game_variables[283] == 2
        set_btlarn_bgm = 39
        $battleenemy = [51,52,49,50]
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZUB_royal_guard
        $battleenemy = [48,43,45,40]
      end
    when 16 #Z2フリーザ第一形態
      $set_btlarn_bgm = 36
      if $game_variables[283] == 1
        #$game_variables[284] = 11 #賞品Noセット
        if $game_variables[281] == 1
          $battleenemy = [41,41,41,41,41,41]
        elsif $game_variables[281] == 2
          $battleenemy = [33,36,41,41,39,33]
        elsif $game_variables[281] == 3
          $battleenemy = [33,33,36,36,39,39]
        end
      elsif $game_variables[283] == 2
        set_btlarn_bgm = 38
        $battleenemy = [43,46]
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 40
        $battleenemy = [53]
      end
    when 17 #Z2フリーザ第二形態
      $set_btlarn_bgm = 36
      if $game_variables[283] == 1
        #$game_variables[284] = 11 #賞品Noセット
        if $game_variables[281] == 1
          $battleenemy = [41,41,41,41,41,41]
        elsif $game_variables[281] == 2
          $battleenemy = [33,36,41,41,39,33]
        elsif $game_variables[281] == 3
          $battleenemy = [33,33,36,36,39,39]
        end
      elsif $game_variables[283] == 2
        set_btlarn_bgm = 39
        if $game_variables[281] == 1
          $battleenemy = [51,52]
        elsif $game_variables[281] == 2
          $battleenemy = [49,50]
        elsif $game_variables[281] == 3
          $battleenemy = [48]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 40
        $battleenemy = [54]
      end
    when 18 #Z2フリーザ第三形態
      $set_btlarn_bgm = 37
      if $game_variables[283] == 1
        #$game_variables[284] = 11 #賞品Noセット
        if $game_variables[281] == 1
          $battleenemy = [41,41,41,41,41,41]
        elsif $game_variables[281] == 2
          $battleenemy = [33,36,41,41,39,33]
        elsif $game_variables[281] == 3
          $battleenemy = [33,33,36,36,39,39]
        end
      elsif $game_variables[283] == 2
        set_btlarn_bgm = 39
        if $game_variables[281] == 1
          $battleenemy = [51,52]
        elsif $game_variables[281] == 2
          $battleenemy = [49,50]
        elsif $game_variables[281] == 3
          $battleenemy = [48]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 40
        $battleenemy = [55]
      end
    when 19 #Z2ターレス、スラッグ
      $set_btlarn_bgm = 37
      if $game_variables[283] == 1
        #$game_variables[284] = 11 #賞品Noセット
        if $game_variables[281] == 1
          $battleenemy = [41,42,44,47,41]
        elsif $game_variables[281] == 2
          $battleenemy = [33,36,42,42,39,33]
        elsif $game_variables[281] == 3
          $battleenemy = [33,33,36,36,39,39]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1
          $battleenemy = [42,42,42,42]
        elsif $game_variables[281] == 2
          $battleenemy = [44,44,44,44]
        elsif $game_variables[281] == 3
          $battleenemy = [47,47,47,47]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 20
        $battleenemy = [59,60]
      end
    when 20 #Z2フリーザ第四形態
      $set_btlarn_bgm = 38
      if $game_variables[283] == 1
        #$game_variables[284] = 11 #賞品Noセット
        if $game_variables[281] == 1
          $battleenemy = [41,42,44,47,41]
        elsif $game_variables[281] == 2
          $battleenemy = [33,36,44,47,39,33]
        elsif $game_variables[281] == 3
          $battleenemy = [33,44,47,42,36,39]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1
          $battleenemy = [42,42,44,47,42,42]
        elsif $game_variables[281] == 2
          $battleenemy = [44,44,47,44,42]
        elsif $game_variables[281] == 3
          $battleenemy = [47,47,44,47,42]
        end
      elsif $game_variables[283] == 3
        if $game_variables[42] != 16 #バーダックが先頭
          $set_btlarn_bgm = $bgm_no_ZSSD_battle2
        else
          $set_btlarn_bgm = $bgm_no_ZTVSP_sorid
        end
        $battleenemy = [56]
      end
    when 21 #Z2超ベジータ
      $set_btlarn_bgm = $bgm_no_ZSSD_battle1
      if $game_variables[283] == 1
        #$game_variables[284] = 11 #賞品Noセット
        if $game_variables[281] == 1
          $battleenemy = [41,42,44,47,41]
        elsif $game_variables[281] == 2
          $battleenemy = [33,36,44,47,39,33]
        elsif $game_variables[281] == 3
          $battleenemy = [33,44,47,42,36,39]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1
          $battleenemy = [42,42,44,47,42,42]
        elsif $game_variables[281] == 2
          $battleenemy = [44,44,47,44,42]
        elsif $game_variables[281] == 3
          $battleenemy = [47,47,44,47,42]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZSSD_battle1_for_gb
        $battleenemy = [58]
      end
    when 22 #Z2フリーザフルパワー
      $set_btlarn_bgm = 38
      if $game_variables[283] == 1
        #$game_variables[284] = 11 #賞品Noセット
        if $game_variables[281] == 1
          $battleenemy = [41,42,44,47,41]
        elsif $game_variables[281] == 2
          $battleenemy = [33,36,44,47,39,33]
        elsif $game_variables[281] == 3
          $battleenemy = [33,44,47,42,36,39]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1
          $battleenemy = [42,42,44,47,42,42]
        elsif $game_variables[281] == 2
          $battleenemy = [44,44,47,44,42]
        elsif $game_variables[281] == 3
          $battleenemy = [47,47,44,47,42]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZSA2_bgm16_for_gb
        $battleenemy = [57]
      end
=begin
    when 23 #Z2フリーザ4、超ベジータ、ターレス
      $set_btlarn_bgm = 40
      if $game_variables[283] == 1
        $set_btlarn_bgm = 20
        $battleenemy = [59,60]
      elsif $game_variables[283] == 2
        $set_btlarn_bgm = 40
        $battleenemy = [56]
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZSSD_battle1_for_gb
        $battleenemy = [58]
      end
=end
#================================================================
#                             Z3
#================================================================
    when 23 #Z3クラズ
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1
          $battleenemy = [103,106,109,111,114,117]
        elsif $game_variables[281] == 2
          $battleenemy = [103,106,109]
        elsif $game_variables[281] == 3
          $battleenemy = [111,114,117]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1
          $battleenemy = [103,106,109,109,106,103]
        elsif $game_variables[281] == 2
          $battleenemy = [111,114,117]
        elsif $game_variables[281] == 3
          $battleenemy = [103,106,109]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 15
        $battleenemy = [131]
      end
    when 24 #Z3ピラール
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1
          $battleenemy = [103,106,109,111,114,117]
        elsif $game_variables[281] == 2
          $battleenemy = [103,106,109]
        elsif $game_variables[281] == 3
          $battleenemy = [111,114,117]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1
          $battleenemy = [103,106,109,109,106,103]
        elsif $game_variables[281] == 2
          $battleenemy = [111,114,117]
        elsif $game_variables[281] == 3
          $battleenemy = [103,106,109]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 15
        $battleenemy = [132]
      end
    when 25 #Z3ガーリック一味
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1
          $battleenemy = [183,183,184,184,185,185]
        elsif $game_variables[281] == 2
          $battleenemy = [183,184,185]
        elsif $game_variables[281] == 3
          $battleenemy = [186,187,188]
        end
      elsif $game_variables[283] == 2
        $set_btlarn_bgm = $bgm_no_ZMove_M814A
        if $game_variables[281] == 1
          $battleenemy = [186,181,187,188]
        elsif $game_variables[281] == 2
          $battleenemy = [186,181,187,188]
        elsif $game_variables[281] == 3
          $battleenemy = [183,181,184,185]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZMove_bgm1_2
        $battleenemy = [177,178,182,179,180]
      end
    when 26 #Z3カイズ
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1
          $battleenemy = [104,107,110,112,115,118]
        elsif $game_variables[281] == 2
          $battleenemy = [104,107,110]
        elsif $game_variables[281] == 3
          $battleenemy = [112,115,118]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1
          $battleenemy = [112,115,118,118,115,112]
        elsif $game_variables[281] == 2
          $battleenemy = [112,115,118]
        elsif $game_variables[281] == 3
          $battleenemy = [104,107,110]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 15
        $battleenemy = [133]
      end
    when 27 #Z3クラズ～カイズ
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
          $battleenemy = [104,107,110,110,107,104]
      elsif $game_variables[283] == 2
          $battleenemy = [112,115,118,118,115,112]
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 15
        $battleenemy = [131,133,132]
      end
    when 28 #Z3フリーザ
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1
          $battleenemy = [41,42,44,47,41]
        elsif $game_variables[281] == 2
          $battleenemy = [33,36,44,47,39,33]
        elsif $game_variables[281] == 3
          $battleenemy = [33,44,47,42,36,39]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1
          $battleenemy = [42,42,44,47,42,42]
        elsif $game_variables[281] == 2
          $battleenemy = [44,44,47,44,42]
        elsif $game_variables[281] == 3
          $battleenemy = [47,47,44,47,42]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 15
        $battleenemy = [101]
      end
    when 29 #Z3フリーザ(サイボーグ)
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1
          $battleenemy = [41,42,44,47,41]
        elsif $game_variables[281] == 2
          $battleenemy = [33,36,44,47,39,33]
        elsif $game_variables[281] == 3
          $battleenemy = [33,44,47,42,36,39]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1
          $battleenemy = [42,42,44,47,42,42]
        elsif $game_variables[281] == 2
          $battleenemy = [44,44,47,44,42]
        elsif $game_variables[281] == 3
          $battleenemy = [47,47,44,47,42]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZID_bgm02
        $battleenemy = [102]
      end
    when 30 #Z3クウラ気甲戦隊
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1
          $battleenemy = [112,115,118]
        elsif $game_variables[281] == 2
          $battleenemy = [112,112,108,110,110]
        elsif $game_variables[281] == 3
          $battleenemy = [115,115,105,118,118]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1
          $battleenemy = [108,105,108]
        elsif $game_variables[281] == 2
          $battleenemy = [115,115,105,118,118]
        elsif $game_variables[281] == 3
          $battleenemy = [112,112,108,110,110]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 15
        $battleenemy = [116,119,113]
      end
    when 31 #Z3クウラ
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1
          $battleenemy = [105,105,108,108]
        elsif $game_variables[281] == 2
          $battleenemy = [112,112,108,110,110]
        elsif $game_variables[281] == 3
          $battleenemy = [115,115,105,118,118]
        end
      elsif $game_variables[283] == 2
        $set_btlarn_bgm = 15
        $battleenemy = [120]
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZMove_saikyo
        $battleenemy = [121]
      end
    when 32 #Z3 20,19号
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1
          $battleenemy = [137,174,137]
        elsif $game_variables[281] == 2
          $battleenemy = [174,175,174]
        elsif $game_variables[281] == 3
          $battleenemy = [137,137,137,137]
        end
      elsif $game_variables[283] == 2
        
        if $game_variables[281] == 1
          $battleenemy = [174,175,175,174]
        elsif $game_variables[281] == 2
          $battleenemy = [137,175,137]
        elsif $game_variables[281] == 3
          $battleenemy = [174,175,175,174]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZID_bgm01
        $battleenemy = [122,123]
      end
    when 33 #Z3 18,17号
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1
          $battleenemy = [137,174,174,137]
        elsif $game_variables[281] == 2
          $battleenemy = [174,175,175,174]
        elsif $game_variables[281] == 3
          $battleenemy = [137,137,137,137]
        end
      elsif $game_variables[283] == 2
        
        if $game_variables[281] == 1
          $battleenemy = [174,175,137,175,174]
        elsif $game_variables[281] == 2
          $battleenemy = [137,175,174,175,137]
        elsif $game_variables[281] == 3
          $battleenemy = [174,175,174,175,174]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZSB1_18gou_for_gxscc
        $battleenemy = [125,124]
      end
    when 34 #Z3 16号
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1
          $battleenemy = [137,174,175,174,137]
        elsif $game_variables[281] == 2
          $battleenemy = [174,175,175,175,174]
        elsif $game_variables[281] == 3
          $battleenemy = [137,137,174,174,137,137]
        end
      elsif $game_variables[283] == 2
        
        if $game_variables[281] == 1
          $battleenemy = [174,175,137,137,175,174]
        elsif $game_variables[281] == 2
          $battleenemy = [137,175,174,174,175,137]
        elsif $game_variables[281] == 3
          $battleenemy = [174,175,174,174,175,174]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZUB_zetumei
        $battleenemy = [126]
      end
    when 35 #Z3 ボスラッシュ1(ピラールなど)
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1
          $battleenemy = [105,131,105]
        elsif $game_variables[281] == 2
          $battleenemy = [108,132,108]
        elsif $game_variables[281] == 3
          $battleenemy = [110,133,110]
        end
      elsif $game_variables[283] == 2
        
        if $game_variables[281] == 1
          $battleenemy = [108,133,108]
        elsif $game_variables[281] == 2
          $battleenemy = [110,132,110]
        elsif $game_variables[281] == 3
          $battleenemy = [105,131,105]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = 15
        $battleenemy = [101,116,119,113]
      end
    when 36 #Z3 ボスラッシュ2(クウラ)
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1
          $battleenemy = [105,131,105]
        elsif $game_variables[281] == 2
          $battleenemy = [108,132,108]
        elsif $game_variables[281] == 3
          $battleenemy = [110,133,110]
        end
      elsif $game_variables[283] == 2
        $set_btlarn_bgm = 15
        $battleenemy = [120,118,115,112]
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZMove_M1216 #劇場版BGMクウラ戦
        $battleenemy = [102,121]
      end
    when 37 #Z3 ボスラッシュ3(人造人間)
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [122,123]
        elsif $game_variables[281] == 3
          $battleenemy = [102,121]
        end
      elsif $game_variables[283] == 2
        $set_btlarn_bgm = 15
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [125,124]
        elsif $game_variables[281] == 3
          $battleenemy = [122,123]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_DB_m109 #レッドリボン軍戦
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [126]
        elsif $game_variables[281] == 3
          $battleenemy = [125,124,126]
        end
      end
#================================================================
#                             Z4
#================================================================
    when 38 #Z4 ウィロー一味(Z4)
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [137,137,174,174,175,175]
        elsif $game_variables[281] == 3
          $battleenemy = [137,174,175,176,189,193]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [176,176,189,189,193,193]
        elsif $game_variables[281] == 3
          $battleenemy = [193,189,176,175,174,137]
        end
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZMove_ikusa3
        $battleenemy = [208,209,210,211]
      end
    when 39 #Z4 セル第一形態
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        $battleenemy = [137,137,137,174,174,174]
      elsif $game_variables[283] == 2
        $battleenemy = [175,175,175,175,175,175]
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZSB1_cell
        $battleenemy = [127]
      end
    when 40 #Z4 セル第二形態
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        $battleenemy = [176,176,176,189,189,189]
      elsif $game_variables[283] == 2
        $battleenemy = [193,193,193,193,193,193]
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZSB2_bejita_for_gb
        $battleenemy = [128]
      end
    when 41 #Z4 メタルクウラ
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        $battleenemy = [229,229,229,229,229]
      elsif $game_variables[283] == 2
        $battleenemy = [230,230,230,230,230]
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_ZMove_metarukuura_battlebgm2
        $battleenemy = [136,136,136]
      end

    when 42 #Z4 メタルクウラ・コア
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        $battleenemy = [231,231,231,231,231]
      elsif $game_variables[283] == 2
        $battleenemy = [232,232,232,232,232]
      elsif $game_variables[283] == 3
        
        if $game_variables[319] == 0 #戦闘前の曲をかけていない
          $set_btlarn_bgm = $bgm_no_ZMove_hero2
        else
          $set_btlarn_bgm = $bgm_no_ZMove_hero_btl2
          $set_btlarn_ready_bgm = $bgm_no_ready_ZMove_hero3
        end
        $battleenemy = [213,214,213]
      end
    when 43 #Z4 13号／14号／15号
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [234,235,236,237]
        elsif $game_variables[281] == 3
          $battleenemy = [234,235,236,237]
        end
      elsif $game_variables[283] == 2
        $set_btlarn_bgm = $bgm_no_ZMove_zinzouningen_battlebgm
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [140,138,141]
        elsif $game_variables[281] == 3
          $battleenemy = [234,235,138,236,237]
        end
      elsif $game_variables[283] == 3
        if $game_variables[319] == 0 #戦闘前の曲をかけていない
          $set_btlarn_bgm = $bgm_no_ZMove_girigiri
        else
          $set_btlarn_bgm = $bgm_no_ZMove_girigiri_btl
          $set_btlarn_ready_bgm = $bgm_no_ready_ZMove_girigiri
        end
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [139]
        elsif $game_variables[281] == 3
          $battleenemy = [140,139,141]
        end
      end
    when 44 #タオパイパイ
      $set_btlarn_bgm = 15
      if $game_variables[283] == 1
        $battleenemy = [102] #フリーザ(サイボーグ)
      elsif $game_variables[283] == 2
        $battleenemy = [136] #メタルクウラ
      elsif $game_variables[283] == 3
        $set_btlarn_bgm = $bgm_no_DB_m441
        $battleenemy = [216]
      end
    when 45 #セル(パーフェクト)
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [197,199,201,203,205]
        elsif $game_variables[281] == 3
          $battleenemy = [197,199,201,203,205]
        end
      elsif $game_variables[283] == 2
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [130,130,130,130]
        elsif $game_variables[281] == 3
          $battleenemy = [130,130,130,130]
        end
      elsif $game_variables[283] == 3
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [130,130,130,130,135,130,130,130,130]
          $set_btlarn_bgm = $bgm_no_ZTV_tamashiivs1
        elsif $game_variables[281] == 3
          $battleenemy = [130,130,130,130,129,130,130,130,130]
          $set_btlarn_bgm = $bgm_no_ZTV_tamashiivs1
        end
      end
    when 46 #Z4 ボスラッシュ1 ウィロー一味、人造人間13号
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        $set_btlarn_bgm = $bgm_no_ZMove_ikusa3
        $battleenemy = [208,209,210,211] #ウィロー一味
      elsif $game_variables[283] == 2 #人造人間13号一味
        $set_btlarn_bgm = $bgm_no_ZMove_zinzouningen_battlebgm
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [140,138,141]
        elsif $game_variables[281] == 3
          $battleenemy = [234,235,138,236,237]
        end
      elsif $game_variables[283] == 3 #人造人間13号一味
        if $game_variables[319] == 0 #戦闘前の曲をかけていない
          $set_btlarn_bgm = $bgm_no_ZMove_girigiri
        else
          $set_btlarn_bgm = $bgm_no_ZMove_girigiri_btl
          $set_btlarn_ready_bgm = $bgm_no_ready_ZMove_girigiri
        end
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [139]
        elsif $game_variables[281] == 3
          $battleenemy = [140,139,141]
        end
      end
    when 47 #Z4 ボスラッシュ2 タオパイパイ、メタルクウラ
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        $set_btlarn_bgm = $bgm_no_DB_m441
        $battleenemy = [216]
      elsif $game_variables[283] == 2 #メタルクウラ
        $set_btlarn_bgm = $bgm_no_ZMove_metarukuura_battlebgm
        $battleenemy = [136,136,136]
      elsif $game_variables[283] == 3 #メタルクウラコア
        if $game_variables[319] == 0 #戦闘前の曲をかけていない
          $set_btlarn_bgm = $bgm_no_ZMove_hero2
        else
          $set_btlarn_bgm = $bgm_no_ZMove_hero_btl2
          $set_btlarn_ready_bgm = $bgm_no_ready_ZMove_hero3
        end
        $battleenemy = [213,214,213]
      end
    when 48 #Z4 ボスラッシュ3 セル1～3
      $set_btlarn_bgm = 15
      if $game_variables[283] == 1 #セル1
        $set_btlarn_bgm = $bgm_no_ZSB1_cell
        $battleenemy = [127]
      elsif $game_variables[283] == 2 #セル2
        $set_btlarn_bgm = $bgm_no_ZSB2_bejita_for_gb
        $battleenemy = [128]
      elsif $game_variables[283] == 3 #セル3
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [130,130,130,130,135,130,130,130,130]
          $set_btlarn_bgm = $bgm_no_ZSB2_gohan_for_gxscc
        elsif $game_variables[281] == 3
          $battleenemy = [130,130,130,130,129,130,130,130,130]
          $set_btlarn_bgm = $bgm_no_ZTV_cellgame
        end
      end
    when 49 #Z4 ブロリー
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1 #戦闘員
        $battleenemy = [148,148,148,148,148,148]
      elsif $game_variables[283] == 2 #ブロリー(超)
        if $game_variables[319] == 0 #戦闘前の曲をかけていない
          $set_btlarn_bgm = $bgm_no_ZMove_brori_battlebgm
        else
          $set_btlarn_bgm = $bgm_no_ZMove_brori_battlebgm_btl
          $set_btlarn_ready_bgm = $bgm_no_ready_ZMove_brori_battlebgm2
        end
        $battleenemy = [151]
      elsif $game_variables[283] == 3 #ブロリー(フルパワー)
        if $game_variables[319] == 0 #戦闘前の曲をかけていない
          $set_btlarn_bgm = $bgm_no_ZMove_nessen
        else
          $set_btlarn_bgm = $bgm_no_ZMove_nessen_btl2
          $set_btlarn_ready_bgm = $bgm_no_ready_ZMove_nessen3
        end
        $game_switches[29] = true
        $game_switches[26] = true
        $battleenemy = [152]
      end
    when 50 #Z4 ボージャック一味
      $set_btlarn_bgm = 14
      if $game_variables[283] == 1
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [198,200,202,204,206] #ボージャックザコ的
        else
          $battleenemy = [206,206,206,206,206,206] #ボージャックザコ的
        end
      elsif $game_variables[283] == 2 #ボージャック一味
        if $game_variables[319] == 0 #戦闘前の曲をかけていない
          $set_btlarn_bgm = $bgm_no_ZMove_M1619
        else
          $set_btlarn_bgm = $bgm_no_ZMove_M1619_btl
        end
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [144,145,142,146,147]
        elsif $game_variables[281] == 3
          $battleenemy = [142]
        end
      elsif $game_variables[283] == 3 #ボージャック一味
        if $game_variables[319] == 0 #戦闘前の曲をかけていない
          $set_btlarn_bgm = $bgm_no_ZMove_raizing2
        else
          $set_btlarn_bgm = $bgm_no_ZMove_raizing_btl
          $set_btlarn_ready_bgm = $bgm_no_ready_ZMove_raizing
        end
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $game_switches[27] = true
          $battleenemy = [143]
        elsif $game_variables[281] == 3
          $battleenemy = [144,145,143,146,147]
        end
      end
    when 51 #Z4 チルド
      $set_btlarn_bgm = 15
      if $game_variables[283] == 1 #フリーザ
        $battleenemy = [101]
      elsif $game_variables[283] == 2 #クウラ
        $set_btlarn_bgm = $bgm_no_ZMove_M1216
        $battleenemy = [120]
      elsif $game_variables[283] == 3 #チルド
        $set_btlarn_bgm = $bgm_no_DKN_tyoubardak_btl
        $battleenemy = [238]
      end
    when 52 #Z2バーダック一味編 ターレス
      $set_btlarn_bgm = 12
      if $game_variables[283] == 1 #ザコ的1
        $battleenemy = [33,36,39,39,36,33]
      elsif $game_variables[283] == 2 #ザコ的2
        $battleenemy = [42,44,47,47,44,42]
      elsif $game_variables[283] == 3 #ターレス一味
        if $game_variables[319] == 0 #戦闘前の曲をかけていない
          $set_btlarn_bgm = $bgm_no_ZMove_marugoto2
        else
          $set_btlarn_bgm = $bgm_no_ZMove_marugoto_btl
          $set_btlarn_ready_bgm = $bgm_no_ready_ZMove_marugoto
        end
        $battleenemy = [69,65,59,66,67,68]
      end
    when 53 #Z2バーダック一味編 スラッグ
      $set_btlarn_bgm = 12
      if $game_variables[283] == 1 #ザコ的1
        $battleenemy = [33,36,39,42,44,47]
      elsif $game_variables[283] == 2 #ザコ的2
        $battleenemy = [76,76,76,76,76,76]
      elsif $game_variables[283] == 3 #スラッグ一味
        if $game_variables[319] == 0 #戦闘前の曲をかけていない
          $set_btlarn_bgm = $bgm_no_ZMove_genkidama2
        else
          $set_btlarn_bgm = $bgm_no_ZMove_genkidama_btl2
          $set_btlarn_ready_bgm = $bgm_no_ready_ZMove_genkidama
        end
        $battleenemy = [72,73,60,74,75]
      end
    when 54 #ZGクウラ一味
      $set_btlarn_bgm = 17 #ZG通常
      if $game_variables[283] == 1 #ザコ的1
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [155,159,162]
        else
          $battleenemy = [155,155,159,159,162,162]
        end
      elsif $game_variables[283] == 2 #ザコ的2
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [155,159,162]
        else
          $battleenemy = [155,155,159,159,162,162]
        end
      elsif $game_variables[283] == 3 #ZGクウラ一味
        $set_btlarn_bgm = 19
        $battleenemy = [239,240,241,242]
      end
    when 55 #ZGターレス一味
      $set_btlarn_bgm = 17 #ZG通常
      if $game_variables[283] == 1 #ザコ的1
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [155,159,162]
        else
          $battleenemy = [155,155,159,159,162,162]
        end
      elsif $game_variables[283] == 2 #ザコ的2
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [155,159,162]
        else
          $battleenemy = [155,155,159,159,162,162]
        end
      elsif $game_variables[283] == 3 #ZGターレス一味
        $set_btlarn_bgm = 19
        $battleenemy = [221,217,233,218,219,220]
      end
    when 56 #ZGスラッグ一味
      $set_btlarn_bgm = 17 #ZG通常
      if $game_variables[283] == 1 #ザコ的1
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [155,159,162]
        else
          $battleenemy = [155,155,159,159,162,162]
        end
      elsif $game_variables[283] == 2 #カワーズと一般兵強
        $set_btlarn_bgm = 19
        $battleenemy = [228,228,158,228,228]
      elsif $game_variables[283] == 3 #ZGスラッグ一味
        $set_btlarn_bgm = 19
        $battleenemy = [224,225,255,226,227]
      end
    when 57 #ZGフリーザ一味
      $set_btlarn_bgm = 17 #ZG通常
      if $game_variables[283] == 1 #ザコ的1
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [155,159,162]
        else
          $battleenemy = [155,155,159,159,162,162]
        end
      elsif $game_variables[283] == 2 #キュイ
        $set_btlarn_bgm = 19
        $battleenemy = [246]
      elsif $game_variables[283] == 3 #ZGフリーザ一味
        $set_btlarn_bgm = 19
        $battleenemy = [244,243,245]
      end
    when 58 #ZGゴースト戦士
      $set_btlarn_bgm = 17 #ZG通常
      if $game_variables[283] == 1 #ザコ敵1
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [156,160,163]
        else
          $battleenemy = [156,156,160,160,163,163]
        end
      elsif $game_variables[283] == 2 #ザコ敵2
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [156,160,163]
        else
          $battleenemy = [156,156,160,160,163,163]
        end
      elsif $game_variables[283] == 3 #ZGゴースト戦士
        $set_btlarn_bgm = 20
        $battleenemy = [233,243,255,239]
      end
    when 59 #ZGギニュー特戦隊
      $set_btlarn_bgm = 17 #ZG通常
      if $game_variables[283] == 1 #ザコ敵1
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [157,161,164]
        else
          $battleenemy = [157,161,164,165,167]
        end
      elsif $game_variables[283] == 2 #ザコ敵2
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [165,165,167,167]
        else
          $battleenemy = [157,161,164,165,167]
        end
      elsif $game_variables[283] == 3 #ZGギニュー特戦隊
        $set_btlarn_bgm = $bgm_no_ZTV_kyouhug2 #ZG ギニュー特戦隊
        $battleenemy = [250,251,247,248,249]
      end
    when 60 #ZGチルド
      $set_btlarn_bgm = 17 #ZG通常
      if $game_variables[283] == 1 #ザコ敵1
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [157,161,164]
        else
          $battleenemy = [157,161,164,165,166,167,168]
        end
      elsif $game_variables[283] == 2 #ザコ敵2
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [165,166,167,168]
        else
          $battleenemy = [157,161,164,165,166,167,168]
        end
      elsif $game_variables[283] == 3 #ZGチルド
        $set_btlarn_bgm = $bgm_no_ZTVSP_sorid_2 #ソリッドステートスカウターver2
        $battleenemy = [252]
      end
    when 61 #ZGゴッドガードン
      $set_btlarn_bgm = 17 #ZG通常
      if $game_variables[283] == 1 #ザコ敵1
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [157,161,164]
        else
          $battleenemy = [165,166,167,168,169,170]
        end
      elsif $game_variables[283] == 2 #ザコ敵2
        if $game_variables[281] == 1 || $game_variables[281] == 2
          $battleenemy = [165,166,167,168]
        else
          $battleenemy = [168,169,170]
        end
      elsif $game_variables[283] == 3 #ZGゴッドガードン
        $set_btlarn_bgm = 20 #ZG ボス戦
        $battleenemy = [213,171,213]
      end
    when 62 #ZGライチー／ハッチヒャック
      $set_btlarn_bgm = 17 #ZG通常
      if $game_variables[283] == 1 #ゴッドガードン
        $set_btlarn_bgm = 20 #ZG ボス戦
        $battleenemy = [171]
      elsif $game_variables[283] == 2 #ライチー
        $set_btlarn_bgm = 21 #ZG 大ボス戦
        $battleenemy = [172]
      elsif $game_variables[283] == 3 #ハッチヒャック
        if $game_variables[319] == 0 #戦闘前の曲をかけていない
          $set_btlarn_bgm = $bgm_no_ZPS3_RB2_boo
        else
          $set_btlarn_bgm = $bgm_no_ZPS3_RB2_boo_btl
          $set_btlarn_ready_bgm = $bgm_no_ready_ZPS3_RB2_boo
        end
        $battleenemy = [173]
      end
    when 63 #ZGボスラッシュ1
      $set_btlarn_bgm = 19 #中ボス戦
      if $game_variables[283] == 1 #一回戦
        $battleenemy = [158] #カワーズ
      elsif $game_variables[283] == 2 #二回戦
        $battleenemy = [246] #キュイ
      elsif $game_variables[283] == 3 #三回戦
        $battleenemy = [244,243,245] #フリーザ一味
      end

    when 64 #ZGボスラッシュ2
      $set_btlarn_bgm = 19 #中ボス戦
      if $game_variables[283] == 1 #一回戦
        $battleenemy = [221,217,233,218,219,220] #ターレス
      elsif $game_variables[283] == 2 #二回戦
        $battleenemy = [224,225,255,226,227] #スラッグ
      elsif $game_variables[283] == 3 #三回戦
        $battleenemy = [239,240,241,242] #クウラ
      end
    
    when 65 #ZGボスラッシュ3
      $set_btlarn_bgm = 20 #ボス戦
      if $game_variables[283] == 1 #一回戦
        $battleenemy = [233,243,255,239] #ゴースト戦士
      elsif $game_variables[283] == 2 #二回戦
        $set_btlarn_bgm = $bgm_no_ZTV_kyouhug2 #ZG ギニュー特戦隊
          $battleenemy = [250,251,247,248,249] #ギニュー
      elsif $game_variables[283] == 3 #三回戦
        $set_btlarn_bgm = $bgm_no_ZTVSP_sorid_2 #ソリッドステートスカウターver2
        $battleenemy = [252] #チルド
      end
    
    when 66 #ZGオゾット
      $set_btlarn_bgm = 17 #ZG通常
      if $game_variables[283] == 1 #ゴッドガードン
        $set_btlarn_bgm = 20 #ZG ボス戦
        $battleenemy = [171]
      elsif $game_variables[283] == 2 #オゾット
        if $game_variables[319] == 0 #戦闘前の曲をかけていない
          $set_btlarn_bgm = $bgm_no_ZPS2_Z2_heart
        else
          $set_btlarn_bgm = $bgm_no_ZPS2_Z2_heart_btl
          $set_btlarn_ready_bgm = $bgm_no_ready_ZPS2_Z2_heart
        end
        $battleenemy = [154]
      elsif $game_variables[283] == 3 #オゾット(変身)
        if $game_variables[319] == 0 #戦闘前の曲をかけていない
          $set_btlarn_bgm = $bgm_no_ZPS3_BR_kiseki
        else
          $set_btlarn_bgm = $bgm_no_ZPS3_BR_kiseki_btl
          $set_btlarn_ready_bgm = $bgm_no_ready_ZPS3_BR_kiseki
        end
        $battleenemy = [253]
      end
    when 67 #ZGパイクーハン
      $set_btlarn_bgm = 17 #ZG通常
      if $game_variables[283] == 1 #フリーザ
        $set_btlarn_bgm = $bgm_no_ZSSD_battle2
        $battleenemy = [243]
      elsif $game_variables[283] == 2 #セル(パーフェクト)
        $set_btlarn_bgm = $bgm_no_ZSB2_gohan_for_gxscc
        $battleenemy = [135]
      elsif $game_variables[283] == 3 #パイクーハン
        $set_btlarn_bgm = 19
        if $game_variables[319] == 0 #戦闘前の曲をかけていない
          $set_btlarn_bgm = $bgm_no_ZPS2_Z3_ore
        else
          $set_btlarn_bgm = $bgm_no_ZPS2_Z3_ore_btl2
          $set_btlarn_ready_bgm = $bgm_no_ready_ZPS2_Z3_ore
        end
        $battleenemy = [215]
      end
    when 68 #ZGブウ
      $set_btlarn_bgm = 17 #ZG通常
      if $game_variables[283] == 1 #ギニュー特戦隊
        $set_btlarn_bgm = $bgm_no_ZTV_kyouhug2 #ZG ギニュー特戦隊
          $battleenemy = [250,251,247,248,249] #ギニュー
      elsif $game_variables[283] == 2 #ゴースト戦士
        $set_btlarn_bgm = 20 #ZGボス戦
        $battleenemy = [233,243,255,239]
      elsif $game_variables[283] == 3 #ブウ
        $set_btlarn_bgm = 19
        if $game_variables[319] == 0 #戦闘前の曲をかけていない
          $set_btlarn_bgm = $bgm_no_ZSPM_SSurvivor
        else
          $set_btlarn_bgm = $bgm_no_ZSPM_SSurvivor_btl2
          $set_btlarn_ready_bgm = $bgm_no_ready_ZSPM_SSurvivor2
        end
        $battleenemy = [254]
      end
    when 69 #ZGアラレ
      $set_btlarn_bgm = 17 #ZG通常
      if $game_variables[283] == 1 #アラレ
        if $game_variables[319] == 0 #戦闘前の曲をかけていない
          $set_btlarn_bgm = $bgm_no_waiwai #ワイワイワールド
        else
          $set_btlarn_bgm = 24 #DB3 カメハウス
          $set_btlarn_ready_bgm = 2 #DB3 戦闘前
        end
        $battleenemy = [153] #アラレ
      elsif $game_variables[283] == 2 #ゴースト戦士
        #$set_btlarn_bgm = 20 #ZGボス戦
        #$battleenemy = [233,243,255,239]
      elsif $game_variables[283] == 3 #ブウ
        #$set_btlarn_bgm = 19
        #if $game_variables[319] == 0 #戦闘前の曲をかけていない
        #  $set_btlarn_bgm = $bgm_no_ZSPM_SSurvivor
        #else
        #  $set_btlarn_bgm = $bgm_no_ZSPM_SSurvivor_btl2
        #  $set_btlarn_ready_bgm = $bgm_no_ready_ZSPM_SSurvivor2
        #end
        #$battleenemy = [254]
      end
    when 70 #暴走ガーリック
      $set_btlarn_bgm = $bgm_no_ZMove_M814A #恐怖のギニュー特戦隊
      if $game_variables[283] == 1
        $battleenemy = [256]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 71 #暴走ウィロー
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        $set_btlarn_bgm = $bgm_no_ZMove_ikusa
      else
        $set_btlarn_bgm = $bgm_no_ZMove_ikusa_btl
        $set_btlarn_ready_bgm = $bgm_no_ready_ZMove_ikusa
      end
      if $game_variables[283] == 1
        $battleenemy = [257]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 72 #暴走ターレス
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        $set_btlarn_bgm = $bgm_no_ZMove_marugoto
      else
        $set_btlarn_bgm = $bgm_no_ZMove_marugoto_btl
        $set_btlarn_ready_bgm = $bgm_no_ready_ZMove_marugoto
      end
      if $game_variables[283] == 1
        $battleenemy = [258]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 73 #暴走スラッグ
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        $set_btlarn_bgm = $bgm_no_ZMove_genkidama
      else
        $set_btlarn_bgm = $bgm_no_ZMove_genkidama_btl
        $set_btlarn_ready_bgm = $bgm_no_ready_ZMove_genkidama
      end
      if $game_variables[283] == 1
        $battleenemy = [259]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 74 #暴走フリーザ
      $set_btlarn_bgm = $bgm_no_ZUB_zetumei2
      if $game_variables[283] == 1
        $battleenemy = [260]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 75 #暴走クウラ
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        $set_btlarn_bgm = $bgm_no_ZMove_saikyo
      else
        $set_btlarn_bgm = $bgm_no_ZMove_saikyo_btl
        $set_btlarn_ready_bgm = $bgm_no_ready_ZMove_saikyo
      end
      if $game_variables[283] == 1
        $battleenemy = [261]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 76 #暴走20/19
      $set_btlarn_bgm = $bgm_no_ZSB1_20gou_for_gxscc
      if $game_variables[283] == 1
        $battleenemy = [262,263]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 77 #暴走セル1
      $set_btlarn_bgm = $bgm_no_ZSB1_cell
      if $game_variables[283] == 1
        $battleenemy = [264]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 78 #暴走セル2
      $set_btlarn_bgm = $bgm_no_ZSB2_bejita_for_gb
      if $game_variables[283] == 1
        $battleenemy = [268]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 79 #暴走メタルクウラ・コア
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        $set_btlarn_bgm = $bgm_no_ZMove_hero
      else
        $set_btlarn_bgm = $bgm_no_ZMove_hero_btl
        $set_btlarn_ready_bgm = $bgm_no_ready_ZMove_hero
      end
      if $game_variables[283] == 1
        $battleenemy = [266]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 80 #暴走13号
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        $set_btlarn_bgm = $bgm_no_ZMove_girigiri
      else
        $set_btlarn_bgm = $bgm_no_ZMove_girigiri_btl
        $set_btlarn_ready_bgm = $bgm_no_ready_ZMove_girigiri
      end
      if $game_variables[283] == 1
        $battleenemy = [267]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 81 #暴走セル完全体
      $set_btlarn_bgm = $bgm_no_ZSB2_gohan_for_gxscc
      if $game_variables[283] == 1
        $battleenemy = [269]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 82 #暴走ブロリー
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        $set_btlarn_bgm = $bgm_no_ZMove_nessen
      else
        $set_btlarn_bgm = $bgm_no_ZMove_nessen_btl
        $set_btlarn_ready_bgm = $bgm_no_ready_ZMove_nessen
      end
      if $game_variables[283] == 1
        $battleenemy = [270]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 83 #暴走ボージャック
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        $set_btlarn_bgm = $bgm_no_ZMove_raizing
      else
        $set_btlarn_bgm = $bgm_no_ZMove_raizing_btl
        $set_btlarn_ready_bgm = $bgm_no_ready_ZMove_raizing
      end
      if $game_variables[283] == 1
        $battleenemy = [271]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 84 #暴走チルド
      $set_btlarn_bgm = $bgm_no_ZTVSP_sorid_2 #ソリッドステートスカウターver2
      if $game_variables[283] == 1
        $battleenemy = [272]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 85 #暴走ライチー
      $set_btlarn_bgm = 21 #ZG 大ボス戦
      if $game_variables[283] == 1
        $battleenemy = [273]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 86 #暴走ハッチヒャック
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        $set_btlarn_bgm = $bgm_no_ZPS3_RB2_boo
      else
        $set_btlarn_bgm = $bgm_no_ZPS3_RB2_boo_btl
        $set_btlarn_ready_bgm = $bgm_no_ready_ZPS3_RB2_boo
      end
      if $game_variables[283] == 1
        $battleenemy = [274]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 87 #暴走オゾット
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        $set_btlarn_bgm = $bgm_no_ZPS3_BR_kiseki
      else
        $set_btlarn_bgm = $bgm_no_ZPS3_BR_kiseki_btl
        $set_btlarn_ready_bgm = $bgm_no_ready_ZPS3_BR_kiseki
      end
      if $game_variables[283] == 1
        $battleenemy = [276]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 88 #暴走パイクーハン
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        $set_btlarn_bgm = $bgm_no_ZPS2_Z3_ore
      else
        $set_btlarn_bgm = $bgm_no_ZPS2_Z3_ore_btl
        $set_btlarn_ready_bgm = $bgm_no_ready_ZPS2_Z3_ore
      end
      if $game_variables[283] == 1
        $battleenemy = [277]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 89 #暴走ブウ
      if $game_variables[319] == 0 #戦闘前の曲をかけていない
        $set_btlarn_bgm = $bgm_no_ZSPM_SSurvivor
      else
        $set_btlarn_bgm = $bgm_no_ZSPM_SSurvivor_btl
        $set_btlarn_ready_bgm = $bgm_no_ready_ZSPM_SSurvivor
      end
      
      if $game_variables[283] == 1
        $battleenemy = [278]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 90 #暴走フルパワーフリーザ
      $set_btlarn_bgm = $bgm_no_ZUB_zetumei2
      if $game_variables[283] == 1
        $battleenemy = [279]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    when 91 #暴走スーパーベジータ
      $set_btlarn_bgm = $bgm_no_ZSSD_battle1_for_gb
      if $game_variables[283] == 1
        $battleenemy = [280]
      elsif $game_variables[283] == 2

      elsif $game_variables[283] == 3

      end
    else
      
    end
    #進行度によって背景を変える
    if $game_variables[40] == 0
      $game_variables[301] = 0
      $Battle_MapID = 9
      #set_bgm = $bgm_no_ZSB2_buro_for_gb
    elsif $game_variables[40] == 1
      $game_variables[301] = 1
      $Battle_MapID = 6
    elsif $game_variables[40] == 2
      $game_variables[301] = 2
      $Battle_MapID = 10
    else
      $Battle_MapID = 10
    end
    

  end
  
end