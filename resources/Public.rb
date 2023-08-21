#ウインドウ状態
#メニュー 0:メインメニュー 1:カード選択前 2:カード選択済み(移動前)2:メニュー詳細 3:マップ 4:移動
#戦闘中   0:メインメニュー 1:味方キャラ選択前 2:カード選択前 3:敵キャラ選択前
$WinState = 0

$title_option_open = false #タイトル画面でオプション画面を開いたか

$actor_final_level_default = 199

$Cardmaxnum = 5 #カード最大枚数 6枚ということ
$CursorState = 0 #カーソル位置
$CardCursorState = 0 #カードカーソル位置
$MenuCursorState = 0 #メニューカーソル位置
$Battle_MapID = 0 #戦闘マップID
$battleenenum = 0 #敵キャラ数

$top_file_name = "Z1_" #ピクチャーファイル頭文字
$btl_top_file_name = "Z1_" #戦闘用ファイル頭文字
$btl_map_top_file_name = "Z1_" #戦闘背景用進行度(あとでZ1などに戻るために使用)
$btl_progress = 0 #戦闘用進行度(敵と味方で違うために使用)

$map_bgm = nil #マップの曲RPG::BGM.last
$set_btlarn_bgm = nil #バトルアリーナ用BGM
$set_btlarn_ready_bgm = nil #バトルアリーナ用戦闘前BGM

#曲名関係
$BGM_CursorOn = "Z3 決定" #決定時
$BGM_CursorMove = "Z3 カーソル移動" #カーソル移動
$BGM_Error = "Z3 エラー" #カーソル移動
$BGM_Menu = "Z1 メニュー" #メニュー_カード画面BGM
$BGM_Card_shop = "DB3 メニュー" #カードショップBGM
$BGM_encount = "Z1 敵発見" #エンカウントSE
$BGM_levelup_se = "Z3 レベルアップ" #レベルアップSE

$map_on = true #マップ表示
#バトル関係
$test_normalattackpattern = 0 #テスト用通常攻撃にアニメパターン
$normalattackpattern = 0 #通常攻撃にアニメパターン
$battle_bgm = 0         #戦闘曲
$battle_ready_bgm = 0         #戦闘前曲
$battle_escape = nil      #逃走可能か
$cha_power_up = []        #界王様か最長老が使われているか？
$ene_power_up = []        #界王様か最長老が使われているか？
$cha_defense_up = []      #ディフェンスアップ
$one_turn_cha_defense_up = false   #ヤジロベーが使われているか？
$ene_defense_up = false   #ヤジロベーが使われているか？
$cha_stop_num = [0,0,0,0,0,0,0,0,0]        #動けないターン数
$ene_stop_num = [0,0,0,0,0,0,0,0,0]        #動けないターン数
$cha_btl_cont_part_turn = [0,0,0,0,0,0,0,0,0] #戦闘連続参加ターン数
$run_stop_card = false                      #じいちゃんカードを使用したか？
$run_alow_card = false                      #ゴズカードを使用したか？
$run_glow_card = false                      #メズカードを使用したか？
$run_scouter = false                        #スカウターを使用したか？
$run_godscouter_card = false                #ゴッドスカウターなのか
$run_scouter_ene = [false,false,false,false,false,false,false,false,false] #スカウターで誰を測定したか？
$turn_recover_hp = 3           #毎ターン自動回復するHPのパー
$turn_recover_ki = 2.5          #毎ターン自動回復する気のパーセント
$hinshi_hp = 31           #瀕死顔表示パーセント(未満)25 なら　MHP100で24から瀕死顔
$enehp = []               #敵現在HP
$enemp = []               #敵現在MP
$tec_move_pattern = 7     #必殺技発動時の移動パターン数
$attack_pattern_max = 18   #攻撃パターンのMAX値
$attack_anime = []   #通常攻撃エフェクトパターン
$attack_anime_max = 4#通常攻撃エフェクトパターン数
$enedead = [] #敵死亡状態
$chadeadchk = [] #味方死亡状態チェック用
$enedeadchk = [] #敵死亡状態チェック用
$eneselfdeadchk = [] #敵自爆死亡チェック用
$battleenemy = [] #戦闘時敵キャラNo
#$cha_set_action = [0,0,0,0,0,0,0,0,0]  #攻撃no 0:は未設定1:攻撃 後は考え中
$cha_set_action = [0,0,0,0,0,0,0,0,0]  #攻撃アクションno 0:は未設定1:攻撃 後は考え中
$attack_order = [] #攻撃順番
$fullpower_on_flag = [] #攻撃したかチェック
$cardset_cha_no = [99,99,99,99,99,99] #カードをセットしたキャラNo(Noは表示順)
$card_run_num = [] #カード使用回数
$cha_mzenkai_num = [0,0,0,0,0,0,0,0,0]        #M全快パワー乱数
$cha_carda_rand = [0,0,0,0,0,0,0,0,0]         #気まぐれスキルようカード攻撃の星乱数
$cha_cardg_rand = [0,0,0,0,0,0,0,0,0]         #気まぐれスキルようカード防御の星乱数
$cha_cardi_rand = [0,0,0,0,0,0,0,0,0]         #気まぐれスキルようカード流派乱数
$cha_ki_zero = [false,false,false,false,false,false,false,false,false]  #KIの消費0
$cha_wakideru_rand = [999,999,999,999,999,999,999,999,999]      #湧き出る力スキル用乱数
$cha_wakideru_flag = [false,false,false,false,false,false,false,false,false] #湧き出る力スキル有効フラグ
$cha_ki_tameru_rand = [0,0,0,0,0,0,0,0,0]      #気を溜めるスキル用乱数
$cha_ki_tameru_flag = [false,false,false,false,false,false,false,false,false] #気を溜めるスキル有効フラグ
$cha_sente_rand = [0,0,0,0,0,0,0,0,0]      #先手スキル用乱数
$cha_sente_flag = [false,false,false,false,false,false,false,false,false] #先手スキル有効フラグ
$cha_sente_card_flag = [false,false,false,false,false,false,false,false,false] #先手スキル有効フラグ
$cha_kaihi_card_flag = [false,false,false,false,false,false,false,false,false] #回避有効フラグ
$cha_single_attack = [false,false,false,false,false,false,false,false,false] #Sコンボ使わないフラグ

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
$full_cha_stop_num = [] #かなしばりターン数

$cha_bigsize_on = [false,false,false,false,false,false,false,false,false]  #キャラ巨大化
$tmp_cb = [false,false,false,false,false,false,false,false,false] #キャラ巨大化(バックアップ)
$story_cha_bigsize_on = []  #時の間に入るときに現状のパーティーのバックアップを取る

$one_turn_cha_hit_num = [] #1ターン管理攻撃ヒット回数管理

$cha_hikari_turn = [] #仲間キャラが光の旅で溜まってるターン数

$oozaru_flag = [] #大ざるフラグ
$tmp_oz_fg = [] #大ざるフラグのバックアップ

$battle_begi_oozaru_run = false
$battle_tare_oozaru_run = false
$battle_sura_big_run = false
$cha_set_enemy = [99,99,99,99,99,99,99,99,99] #味方⇒敵攻撃先
#バトルカード
$carda = [7,7,2,3,4,7,7] #味方カード攻撃
$cardg = [5,4,3,7,1,0,2] #味方カード防御
$cardi = [5,6,1,2,3,0,3] #味方カード流派
$btldmgtmp_carda = [7,7,2,3,4,7,7] #味方カード攻撃一時保存
$btldmgtmp_cardg = [5,4,3,7,1,0,2] #味方カード防御一時保存
$btldmgtmp_cardi = [5,6,1,2,3,0,3] #味方カード流派一時保存
$cardi_max = 6           #流派種類最大数
$enecarda = [7,1,2,3,4,5] #敵カード攻撃
$enecardg = [5,4,3,7,1,0] #敵カード防御
$enecardi = [5,6,1,2,3,0] #敵カード流派
$output_card_tyousei_x = 0 #カード表示位置調整用
$output_card_tyousei_y = 0 #カード表示位置調整用

$battle_turn_num = 0 #戦闘ターン数
$battle_turn_num_chk_flag = false #ターン数チェックしたか
$battle_enedead_cha_no = [] #とどめを刺したキャラ

$battle_ribe_charge = false #リベンジャーチャージ管理用
$battle_ribe_charge_turn = false #リベンジャーチャージしたターンか？

$battle_icon_syurui = [nil,nil,nil,nil,nil,nil,nil,nil,nil]

$battle_kabawareru_runcha = nil #戦闘中かばわれるキャラ
$battle_kabau_runcha = nil #戦闘中かばうスキルを実行するキャラ
$battle_kabau_runskill = nil #戦闘中実行するかばうスキルNo
$battle_kabau_scenerun = false #かばう戦闘シーンを処理したか

$cursor_blink_count = 0   #カーソル点滅カウント用

$create_card_num = nil #生成する味方カードの位置

#アイテムカード
$run_item_card_id = 0           #使用アイテムカードID
$max_item_card_num_syokiti = 7  #アイテムカード最大所持数(初期値)
$max_item_card_num = $max_item_card_num_syokiti          #アイテムカード最大所持数(現在値)
#パーティー
$partyc = [3,4]
$tmp_partyc = []

$story_partyc = [] #時の間に入るときに現状のパーティーのバックアップを取る
$tokinoma_partyc = [] #時の間から各マップに入るときに現状のパーティーのバックアップを取る
$zp = [] #Zポイント(ステータスアップに使う予定)
$zp_first_deal = false #Zポイント初回配布
$party_del_list = []            #パーティー変更対象から削除

$tmp_ene_order = [] #図鑑などで使用する表示する敵のリスト
$ene_order_count = 0 #図鑑で利用するリストのカウント

$ene_add_para_hprecover = []

#1レベル毎に上がるZP
$levelup_add_zp = 50

#ステータスを際に使用するZP
$statusup_zp = 150

#1レベル毎に上がるZP
$cha_maxlv = []

#CAPZP変換率
$captozp_rate = 15

$cha_biattack_count = 0            #味方キャラ連続攻撃回数
$cha_defeat_num = []               #味方キャラ敵撃破数
$cha_attack_damege = []            #味方キャラ攻撃ダメージ合計
$tmp_cha_attack_damege = []        #一時味方キャラ攻撃ダメージ合計
$cha_gard_damege = []              #味方キャラ防御ダメージ合計
$tmp_cha_gard_damege = []          #一時味方キャラ防御ダメージ合計
$cha_attack_count = []            #味方キャラ攻撃回数
$tmp_cha_attack_count = []        #一時味方キャラ攻撃回数
$cha_gard_count = []              #味方キャラ防御回数
$tmp_cha_gard_count = []          #一時味方キャラ防御回数
$ene_defeat_num = []               #敵キャラ個別撃破数
$ene_enc_history_flag = []         #敵キャラ遭遇したかフラグ
$ene_sco_history_flag = []         #敵キャラ能力詳細_フラグ
$ene_crd_history_flag = []         #敵キャラカード取得_フラグ

$okiniiri_btlnum = 20               #お気に入りカード購入用 
#$partyc = [5,6,7,8,9,10]
#パーティーの死亡状態
$chadead = [false,false]
$tmp_chadead = []

#アクター処理の最大数現在バーダックの超32を最大としている
$MAX_ACTOR_NUM = 32

$skill_yousumi_runflag = false #様子見実行フラグ(実行時に条件の引継ぎが難しいので変数を作る

#キャラクター固有スキルセット
$cha_typical_skill = []#Array.new(2).map{Array.new(1,0)}
#キャラクター追加スキルセット
$cha_add_skill = []#Array.new(2).map{Array.new(1,0)}
#キャラクター追加スキルセット可能数
$cha_add_skill_set_num = []
#キャラクタースキルセットしたことがあるかフラグ
$cha_skill_set_flag = []
#キャラクタースキル取得したかフラグ
$cha_skill_get_flag = []
#キャラクタースキルsp取得
$cha_skill_spval = []#Array.new(2).map{Array.new(1,0)}
#スキルセット可能数と取得数
$skill_set_get_num = []#Array.new(2).map{Array.new(1,0)}
$skill_get_max = 9 #スキルの最高取得数

$favorite_card_no = [141] #お気に入りカードNo

$get_card_run = false #カード画面でカードを取得するか

$cha_set_free_skill = []

$cha_tactics = [[],[],[],[],[],[],[],[],[],[],[],[]] #味方の作戦
#$cha_tactics = [0,1,2,3,4,5,6,7,8][0] #味方の作戦
#$chadead = [false,false,false,false,false,false]
#$chadead = [true,true,true,true,true,true,true,true,true]
#エンカウントしていないターン
$encounter_count = 0
$cha_normal_attack_level = [] #キャラクター通常攻撃熟練度(使用回数)
$cha_skill_level = []       #キャラクター必殺技熟練度
$cha_skill_level_max = 99999 #必殺技熟練度最大値
$cha_add_dmg_skill_level_max = 999 #ダメージ計算の追加最大回数
$cha_add_dmg_atk_ratio = 5 #999回を超えた時の攻撃力アップレート 4なら4回使うと1増える
#$cha_skill_level_mode_bada = [] #バーダック編一時格納
#修行
$training_chara_num = nil #修行するキャラNo

$background_bitmap = nil

#敵No開始位置
$ene_str_no = [1,31,101]

#曲ループ様
$bgm_str_time = nil           #再生中のBGMの開始時間
$bgm_name = nil               #再生中のBGM名
$training_no = 0          #修行No

#カード合成
$card_compo_no = []
$skin_kanri = nil
#OP判定用
$game_progress =nil          #ゲーム進行度 0:Z1 1:Z2 2:Z3
$put_battle_bgm = false         #戦闘BGMを再生するか
$option_menu_bgm_name = nil          #オプション設定のメニュー曲
$option_action_sel_bgm_name = nil          #オプション設定の行動選択画面曲
$option_battle_bgm_name = nil          #オプション設定の戦闘曲
$option_battle_ready_bgm_name = nil    #オプション設定の戦闘前曲
$option_evbattle_bgm_name = nil          #オプション設定のイベント戦闘曲
$option_evbattle_ready_bgm_name = nil    #オプション設定のイベント戦闘前曲
$option_msg_bgm_name = nil           #オプション画面の曲
$option_lvup_se_name = nil            #オプション設定のレベルアップSE
$option_msg_title = nil
$fast_fps = false               #高速化判定
$fast_fps_count = 0             #高速化フレームカウント
$max_set_battle_bgm = 1005         #戦闘曲セット数
$max_set_menu_bgm = 255         #メニュー曲セット数
$max_btl_ready_bgm = 255          #戦闘前曲数セット
$max_action_sel_bgm = 255       #行動選択曲数セット
$battle_bgm_on = []             #戦闘BGM使用可能か
$menu_bgm_on = []             #メニューBGM使用可能か
$action_sel_bgm_on = []             #行動選択BGM使用可能か
$battle_ready_bgm_on = []     #戦闘前BGM使用可能か
$btl_user_name = "btl_user"     #戦闘曲オリジナルファイル名
$menu_user_name = "menu_user"     #メニュー曲オリジナルファイル名
$btl_ready_user_name = "btl_ready_user"     #戦闘前曲オリジナルファイル名
$action_sel_user_name = "action_sel_user"     #行動選択画面曲オリジナルファイル名

#曲No
$bgm_no_Z2_battle1_arrange1 = 46       #Z2通常戦闘1(VRC6)
$bgm_no_ZSSD_battle1 = 51       #超サイヤ通常バトル
$bgm_no_ZSSD_battle2 = 52       #超サイヤラストバトル
$bgm_no_ZSSD_battle1_for_gb = 56       #超サイヤ通常バトル(GB)
$bgm_no_ZSSD_training_for_gb = 58       #超サイヤ修行(GB)
$bgm_no_ZSB1_pikkoro_for_gb = 75       #超武闘伝ピッコロ(GB)
$bgm_no_ZSB1_freezer_for_gxscc = 77    #超武闘伝フリーザ(gxscc)
$bgm_no_ZSB1_20gou_for_gxscc = 80      #超武闘伝20号(gxscc
$bgm_no_ZSB1_18gou_for_gxscc = 82      #超武闘伝18号(gxscc
$bgm_no_ZSB1_cell = 83      #超武闘伝セル
$bgm_no_ZSB1_16gou_for_gb = 84      #超武闘伝16号(gb
$bgm_no_ZSB2_pikkoro_for_gb = 91       #超武闘伝2ピッコロ(GB)
$bgm_no_ZSB2_bejita_for_gb = 93       #超武闘伝2ベジータ(GB)
$bgm_no_ZSB2_gohan_for_gxscc = 95       #超武闘伝2悟飯(gxscc)
$bgm_no_ZSB2_buro_for_gb = 97       #超武闘伝2ブロリー(gb)
$bgm_no_ZSB2_buro_for_gxscc = 99       #超武闘伝2ブロリー(gxscc)
$bgm_no_ZSB3_goku = 101       #超武闘伝3悟空のテーマ

$bgm_no_ZSA1_big_fight_for_gb = 111       #超超悟空伝1ビッグファイト(GB)
$bgm_no_ZSA2_bgm01_for_gb = 121       #超超悟空伝2_bgm01(GB)
$bgm_no_ZSA2_bgm02_for_gb = 122       #超超悟空伝2_bgm02(GB)
$bgm_no_ZSA2_bgm06_for_gb = 126       #超超悟空伝2_bgm06(GB)
$bgm_no_ZSA2_bgm16_for_gb = 136       #超超悟空伝2_bgm16(GB)
$bgm_no_ZUB_royal_guard = 151     #アルティメットバトル22ロイヤルガード
$bgm_no_ZUB_will_power = 152      #アルティメットバトル22光のWILL POWER
$bgm_no_ZUB_zetumei = 156      #アルティメットバトル22絶体絶命
$bgm_no_ZUB_zetumei2 = 157      #アルティメットバトル22絶体絶命2
$bgm_no_ZID_bgm01 = 171           #偉大なるドラゴンボール伝説BGM01
$bgm_no_ZID_bgm02 = 172           #偉大なるドラゴンボール伝説BGM02
$bgm_no_ZPS2_Z2_heart = 201          #Z2くすぶるハート火をつけろ
$bgm_no_ZPS2_Z2_heart_btl = 206      #Z2くすぶるハート火をつけろ(バトル)
$bgm_no_ZPS2_Z3_ore = 211            #Z3俺はとことん止まらない
$bgm_no_ZPS2_Z3_ore_btl = 216        #Z3俺はとことん止まらない(バトル)
$bgm_no_ZPS2_Z3_ore_btl2 = 217        #Z3俺はとことん止まらない(バトル2)
$bgm_no_ZSPM_SSurvivor = 221      #スパーキングメテオ超サバイバー
$bgm_no_ZSPM_SSurvivor_btl = 226  #スパーキングメテオ超サバイバー(バトル)
$bgm_no_ZSPM_SSurvivor_btl2 = 227  #スパーキングメテオ超サバイバー(バトル2)
$bgm_no_ZPS3_BR_kiseki = 231   #バーストリミット奇跡の炎よ燃え上れ
$bgm_no_ZPS3_BR_kiseki_btl = 236   #バーストリミット奇跡の炎よ燃え上れ(バトル)
$bgm_no_ZPS3_RB2_boo = 251   #レイジングブラスト2BattleOfOmega
$bgm_no_ZPS3_RB2_boo_btl = 256   #レイジングブラスト2BattleOfOmega(バトル)
$bgm_no_ZFZ1_namek_btl = 303 #ファイターズ ナメック星のテーマ
$bgm_no_ZFZ1_bardak_btl = 305 #ファイターズ バーダックのテーマ

$bgm_no_DKN_tyoubardak_btl = 321 #DKNバーダック(超) 

$bgm_no_FCJ1_battle1 = 351        #ファミコンジャンプ1戦闘BGM1
$bgm_no_FCJ1_battle2 = 352        #ファミコンジャンプ1戦闘BGM2
$bgm_no_FCJ1_battle3 = 353        #ファミコンジャンプ1戦闘BGM3
$bgm_no_FCJ1_battle4 = 354        #ファミコンジャンプ1戦闘BGM4
$bgm_no_FCJ2_battle1 = 356        #ファミコンジャンプ2戦闘BGM1
$bgm_no_FCJ2_battle2 = 357        #ファミコンジャンプ2戦闘BGM2


$bgm_no_DB_dbdensetu = 361       #ドラゴンボール伝説
$bgm_no_DB_m109 = 363  #レッドリボン軍戦
$bgm_no_DB_m422 = 365  #不明(戦闘)
$bgm_no_DB_m441 = 367  #テンシンハン戦
$bgm_no_DB_mezatenka = 371       #DBめざせ天下一

$bgm_no_DB_wolf = 376       #ウルフハリケーン(ファミコン風 狼牙風風拳版)
$bgm_no_DB_wolf2 = 377       #ウルフハリケーン(綺麗な狼牙風風拳版)
$bgm_no_DB_wolf3 = 378       #ウルフハリケーン(Novoice 狼牙風風拳版)
$bgm_no_DB_wolf_btl = 379       #ウルフハリケーン(狼牙風風拳版(バトル))

$bgm_no_ZTVSP_sorid = 381        #ソリッドステートスカウター
$bgm_no_ZTVSP_sorid_full = 382   #ソリッドステートスカウター(Full)
$bgm_no_ZTVSP_sorid_full2 = 383   #ソリッドステートスカウター(Full2)
$bgm_no_ZTVSP_sorid_2 = 384   #ソリッドステートスカウター2
$bgm_no_ZTVSP_sorid_full3 = 385   #ソリッドステートスカウター(Full3)

$bgm_no_ZTV_cellgame = 391        #死を呼ぶセルゲーム

$bgm_no_ZTV_tamashiivs1 = 396 #魂vs魂ver1
$bgm_no_ZTV_tamashiivs2 = 397 #魂vs魂ver2

$bgm_no_ZMove_M814A = 400         #劇場版ガーリック戦
$bgm_no_ZMove_bgm1 = 401         #劇場版BGM1
$bgm_no_ZMove_bgm1_full = 402    #劇場版BGM1(Full)
$bgm_no_ZMove_bgm1_2 = 403    #劇場版BGM1(Full) ver2
$bgm_no_ZTV_kyouhug2 = 405   #恐怖のギニュー特戦隊
$bgm_no_ZMove_M1216 = 408 #劇場版BGMクウラ戦
$bgm_no_ZMove_metarukuura_battlebgm = 411 #劇場版BGMメタルクウラ戦
$bgm_no_ZMove_metarukuura_battlebgm2 = 412 #劇場版BGMメタルクウラ戦2
$bgm_no_ZMove_metarukuura_battlebgm3 = 413 #劇場版BGMメタルクウラ戦3
$bgm_no_ZMove_zinzouningen_battlebgm = 415 #劇場版BGM人造人間戦

$bgm_no_ZMove_brori_battlebgm = 421 #劇場版BGMブロリー戦
$bgm_no_ZMove_brori_battlebgm_btl = 426 #劇場版BGMブロリー戦(バトル)

$bgm_no_ZMove_M1619 = 428 #劇場版BGMボージャック一味戦
$bgm_no_ZMove_M1619_btl = 429 #劇場版BGMボージャック一味戦(バトル)

$bgm_no_ZMove_ikusa = 431       #劇場版 戦 IKUSA
$bgm_no_ZMove_ikusa2 = 432       #劇場版 戦 IKUSAVer2
$bgm_no_ZMove_ikusa3 = 433       #劇場版 戦 IKUSAVer3
$bgm_no_ZMove_ikusa_btl = 436   #劇場版 戦 IKUSA(バトル)
$bgm_no_ZMove_ikusa_btl2 = 437  #劇場版 戦 IKUSA(バトル2)
$bgm_no_ZMove_marugoto = 441       #劇場版 まるごと
$bgm_no_ZMove_marugoto2 = 442       #劇場版 まるごと2
$bgm_no_ZMove_marugoto_btl = 446       #劇場版 まるごと(バトル)
$bgm_no_ZMove_genkidama = 451     #劇場版 「ヤ」なことには元気玉!!
$bgm_no_ZMove_genkidama2 = 452     #劇場版 「ヤ」なことには元気玉!!2
$bgm_no_ZMove_genkidama_btl = 456     #劇場版 「ヤ」なことには元気玉!!btl
$bgm_no_ZMove_genkidama_btl2 = 457     #劇場版 「ヤ」なことには元気玉!!btl2
$bgm_no_ZMove_saikyo = 461   #劇場版 最強対最強
$bgm_no_ZMove_saikyo_btl = 466   #劇場版 最強対最強(バトル)
$bgm_no_ZMove_hero = 471   #劇場版 HERO（キミがヒーロー）
$bgm_no_ZMove_hero2 = 472   #劇場版 HERO（キミがヒーロー）2
$bgm_no_ZMove_hero_btl = 476   #劇場版 HERO（キミがヒーロー）(バトル)
$bgm_no_ZMove_hero_btl2 = 477   #劇場版 HERO（キミがヒーロー）(バトル2)
$bgm_no_ZMove_girigiri = 481   #劇場版 GIRIGIRI-世界極限-
$bgm_no_ZMove_girigiri_btl = 486   #劇場版 GIRIGIRI-世界極限-(バトル)
$bgm_no_ZMove_nessen = 491   #劇場版 バーニング・ファイト-熱戦・烈戦・超激戦-
$bgm_no_ZMove_nessen_btl = 496   #劇場版 バーニング・ファイト-熱戦・烈戦・超激戦-(バトル)
$bgm_no_ZMove_nessen_btl2 = 497   #劇場版 バーニング・ファイト-熱戦・烈戦・超激戦-(バトル2)
$bgm_no_ZMove_raizing = 501   #劇場版 銀河を超えてライジング・ハイ
$bgm_no_ZMove_raizing2 = 502   #劇場版 銀河を超えてライジング・ハイ2
$bgm_no_ZMove_raizing_btl = 506   #劇場版 銀河を超えてライジング・ハイ(バトル)



$bgm_no_waiwai = 951   #O_ワイワイワールド_倍速(GXSCCVer)

$bgm_no_ready_DB_wolf = 11          #DBウルフハリケーン
$bgm_no_ready_ZPS2_Z2_heart = 21          #Z2くすぶるハート火をつけろ
$bgm_no_ready_ZPS2_Z3_ore = 26            #Z3俺はとことん止まらない
$bgm_no_ready_ZSPM_SSurvivor = 31  #スパーキングメテオ超サバイバー
$bgm_no_ready_ZSPM_SSurvivor2 = 32  #スパーキングメテオ超サバイバー2
$bgm_no_ready_ZPS3_BR_kiseki = 36   #バーストリミット奇跡の炎よ燃え上れ
$bgm_no_ready_ZPS3_RB2_boo = 41   #レイジングブラスト2BattleOfOmega

$bgm_no_ready_ZMove_brori_battlebgm = 71 #劇場版BGMブロリー戦
$bgm_no_ready_ZMove_brori_battlebgm2 = 72 #劇場版BGMブロリー戦ver2

$bgm_no_ready_ZMove_ikusa = 101       #劇場版 戦 IKUSA
$bgm_no_ready_ZMove_marugoto = 106       #劇場版 まるごと
$bgm_no_ready_ZMove_genkidama = 111     #劇場版 「ヤ」なことには元気玉!!
$bgm_no_ready_ZMove_saikyo = 116   #劇場版 最強対最強
$bgm_no_ready_ZMove_hero = 121   #劇場版 HERO（キミがヒーロー）
$bgm_no_ready_ZMove_hero2 = 122   #劇場版 HERO（キミがヒーロー）2
$bgm_no_ready_ZMove_hero3 = 123   #劇場版 HERO（キミがヒーロー）2
$bgm_no_ready_ZMove_girigiri = 126   #劇場版 GIRIGIRI-世界極限-
$bgm_no_ready_ZMove_nessen = 131   #劇場版 バーニング・ファイト-熱戦・烈戦・超激戦-
$bgm_no_ready_ZMove_nessen2 = 132   #劇場版 バーニング・ファイト-熱戦・烈戦・超激戦-
$bgm_no_ready_ZMove_nessen3 = 133   #劇場版 バーニング・ファイト-熱戦・烈戦・超激戦-
$bgm_no_ready_ZMove_raizing = 136   #劇場版 銀河を超えてライジング・ハイ

$bgm_no_battle_Original1 = 1001  #戦闘曲オリジナル1
$bgm_no_battle_Original2 = 1002  #戦闘曲オリジナル2
$bgm_no_battle_Original3 = 1003  #戦闘曲オリジナル3
$bgm_no_battle_Original4 = 1004  #戦闘曲オリジナル4
$bgm_no_battle_Original5 = 1005  #戦闘曲オリジナル5
$bgm_no_menu_Original1 = 251  #メニューオリジナル1
$bgm_no_menu_Original2 = 252  #メニューオリジナル2
$bgm_no_menu_Original3 = 253  #メニューオリジナル3
$bgm_no_menu_Original4 = 254  #メニューオリジナル4
$bgm_no_menu_Original5 = 255  #メニューオリジナル5
$bgm_no_battle_ready_Original1 = 251  #戦闘前オリジナル1
$bgm_no_battle_ready_Original2 = 252  #戦闘前オリジナル2
$bgm_no_battle_ready_Original3 = 253  #戦闘前オリジナル3
$bgm_no_battle_ready_Original4 = 254  #戦闘前オリジナル4
$bgm_no_battle_ready_Original5 = 255  #戦闘前オリジナル5
$bgm_no_action_sel_Original1 = 251  #行動選択画面オリジナル1
$bgm_no_action_sel_Original2 = 252  #行動選択画面オリジナル2
$bgm_no_action_sel_Original3 = 253  #行動選択画面オリジナル3
$bgm_no_action_sel_Original4 = 254  #行動選択画面オリジナル4
$bgm_no_action_sel_Original5 = 255  #行動選択画面オリジナル5
$bgm_btl_random_flag = []     #戦闘BGMランダム時の再生フラグ
$bgm_evbtl_random_flag = []   #イベント戦闘BGMランダム時の再生フラグ
$bgm_menu_random_flag = []     #メニューBGMランダム時の再生フラグ
$msg_cursor_blink = 0.60
#超サイヤ人判定
$super_saiyazin_flag = [] #スーパーサイヤ人判定フラグ #スーパーサイヤ人フラグ 1：悟空、2：悟飯、3：ベジータ、4：トランクス、5：悟飯(超2)、6：未来悟飯、7：バーダック
$tmp_sp_saiya_flag = []
#攻撃ループ回数(スキルで何番目のキャラが攻撃してるかチェック用)
$btl_attack_count = 0

#z1バーダック編用能力保存
$cha_typical_skill_z1bar = []
$cha_add_skill_z1bar = []
$cha_skill_set_flag_z1bar = []
$cha_skill_get_flag_z1bar = []
$cha_add_skill_set_num_z1bar = []
$cha_skill_spval_z1bar = []
$zp_z1bar = []
$game_actors_z1bar = []
$cha_defeat_num_z1bar = []
$game_party_z1bar = []

#バトルアリーナ関連
$btl_arena_fight_rank = [] #バトルアリーナで戦えるランク
$btl_arena_fight_rank_clear_num = [] #クリアした回数
$btl_arena_first_item_get = [] #初回報酬取得済みか
$game_party_temp = nil #カード保持用

#戦闘練習合計ダメージ表示フラグ
$btl_put_sumdamage_flag = false

#経験値補正関連
$expup_lv = [28,61,100]  #補正をかけはじめるレベル
$expup_num = [2500,4500,6500] #補正量

#クリア回数
$game_laps = 0

#Sコンボの参加キャラ一時格納用
$tmp_btl_ani_scombo_cha = []

#優先表示カード
$priority_card_no = []

#攻撃、防御時に発動スキルの格納
$tmp_run_skill = [] #発動したスキルを格納

#ヒット時に発動スキルの格納
$tmp_run_hit_skill = [] #発動したスキルを格納

#かばう時の発動スキルの格納
$tmp_run_kabau_skill = [] #発動したスキルを格納

#セーブデータ数
$ini_savedata_num = 0

#ショップのアイテム出力時のループカウンタ
$put_item_loop_count = 0

#Sコンボのヒントを出す追加回数
$all_scombo_skill_level_add_num = 25

#プレイヤー側でのSコンボ優先度
$player_scombo_priority = []

#レシピの表示位置の一時保存用
$temp_card_compo_cursorstate = nil
$temp_card_compo_put_start = nil
$temp_card_compo_recipe_mode = 0 #一覧と作りたいカードどちらか

#カードレシピの解放用
$get_card_compo_recipe = []
$card_compo_recipe_run_num = []

#説明リスト用
$runinfolistmsg = ""

#スキルをセットした際に同様のスキルがどこにあったかチェック用(主にフリーセット用)
$same_skill_type = 0 #固有スキル:1 フリースキル2
$same_skill_no = 0 #単純に上から何番目か 1番目なら0

#フルパーティーメンバー(9人を超える場合はここに一時的に格納することがある)
$full_party_menber = []
#戦闘テストフラグ
$battle_test_flag = false

#メニューカーソル位置管理
$menu_cursor_putx = 0
$menu_cursor_puty = 0

#やせがまん実行フラグ
$btl_yasegaman_on_flag = false

#エラー処理用
#実行中の処理
$err_run_process_msg = ""
$err_run_process = ""
#実行中の詳細
$err_run_process_d = ""
$err_run_process_d2 = ""
$err_run_process_d3 = ""
#↑の使い方イメージ
#$err_run_process = "戦闘アニメシーン"
#$err_run_process_d = "ダメージ計算処理"
#$err_run_process_d2 = "超サイヤ人補正"