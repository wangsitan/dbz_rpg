#==============================================================================
# ■ Main
#------------------------------------------------------------------------------
# 　各クラスの定義が終わった後、ここから実際の処理が始まります。
#==============================================================================

Graphics.resize_screen 640,480

unless Font.exist?("UmePlus Gothic")
  print "UmePlus Gothic フォントが見つかりません。"
  exit
end

begin
  Graphics.freeze
  #$titaleani = Title_Anime.new
  #$titaleani.z1_op
  ini = Ini_File.new("game.ini")
  $game_progress = (ini.get_profile("Game","Progress")).to_i
  $skin_kanri = (ini.get_profile("Game","Game_skin")).to_i
  $op_change = (ini.get_profile("Game","Op_Change")).to_i
  $op_cut = (ini.get_profile("Game","Op_Cut")).to_i
  
  #アクターデータをCSV形式で出力します。
  #CsvOut.export_actors
  
  #CSV形式のアクターデータを取り込んで「Data/Actors.rvdata」に出力します。
  #CsvOut.import_actors
=begin
#データベースCSV出力
############################################################################
  # プロパティの定義
enemy = [ :id, :name, :maxhp, :maxmp, 
          :atk, :def, :spi, :agi, :hit, :eva, :exp, :gold ]
# データベースの読み込み
data = load_data("Data/Enemies.rvdata").compact
# CSV ファイルの書き出し
CSV.save_data("Enemies", data, enemy)
CSV.save_data("EElementRanks", data, :element_ranks)
CSV.save_data("EStateRanks", data, :state_ranks)

# プロパティの定義
base_item = [:id, :name, :icon_index, :description] #メモも出力すると改行がずれるので出力しない
#base_item = [:id, :name, :icon_index, :description, :note]
usable_item = [ :scope, :occasion, :speed, :animation_id, :common_event_id,
                :base_damage, :variance, :atk_f, :spi_f, :physical_attack,
                :damage_to_mp, :absorb_damage, :ignore_defense              ]
item = [:price, :consumable, :hp_recovery_rate, :hp_recovery,
        :mp_recovery_rate, :mp_recovery, :parameter_type, :parameter_points]
element_set = [:element_set]
plus_state_set = [:plus_state_set]
minus_state_set = [:minus_state_set]

# データベースの読み込み
data = load_data("Data/Items.rvdata").compact
# CSV ファイルの書き出し
CSV.save_data("Items", data, base_item + usable_item + item)
CSV.save_data("IElementSet", data, element_set)
CSV.save_data("IPlusStateSet", data, plus_state_set)
CSV.save_data("IMinusStateSet", data, minus_state_set)

#############################################################################
=end

#dp "まだ不安定だけど気にしたら負け"
#dprint("ループで")
#str="ウィンドウが開きまくり\n"
#option={:size=>20,:color=>[255,0,0]}
#option[:bold] = true
#option[:underline] = true
#dprint2(str,option)

  #進行度
  if $game_progress == nil
    $game_progress = 0
  end
  
  #スキン設定
  if $skin_kanri == nil || $skin_kanri == 0
    $skin_kanri = $game_progress
    if $op_change != 5 #外伝のOPでかつデフォルトなら外伝のスキンにする
      #デフォ
      chk_scenario_progress $game_progress,1
    else
      #外伝
      chk_scenario_progress 3,1
    end
  else
    chk_scenario_progress $skin_kanri-1,1
  end
  
  #OP変更
  if $op_change == nil
    $op_change = 0
  end

=begin
  #スキルの上限数変更
  $w = load_data("Data/Skills.rvdata")
  while $w.length <= 2000
  $w.push RPG::Skill.new
  end
  save_data($w,"Data/Skills.rvdata")
=end
  
  $scene = Scene_Title.new
  #$scene = Scene_stg_title.new
  #$scene = Scene_Db_Battle_Anime.new
  #$scene = Scene_Shooting.new
  
######################################################
##戦闘テスト開始
######################################################
=begin
    $data_actors        = load_data("Data/Actors.rvdata")
    $data_classes       = load_data("Data/Classes.rvdata")
    $data_skills        = load_data("Data/Skills.rvdata")
    $data_items         = load_data("Data/Items.rvdata")
    $data_weapons       = load_data("Data/Weapons.rvdata")
    $data_armors        = load_data("Data/Armors.rvdata")
    $data_enemies       = load_data("Data/Enemies.rvdata")
    $data_troops        = load_data("Data/Troops.rvdata")
    $data_states        = load_data("Data/States.rvdata")
    $data_animations    = load_data("Data/Animations.rvdata")
    $data_common_events = load_data("Data/CommonEvents.rvdata")
    $data_system        = load_data("Data/System.rvdata")
    $data_areas         = load_data("Data/Areas.rvdata")
    $game_temp          = Game_Temp.new
    $game_message       = Game_Message.new
    $game_system        = Game_System.new
    $game_switches      = Game_Switches.new
    $game_variables     = Game_Variables.new
    $game_self_switches = Game_SelfSwitches.new
    $game_actors        = Game_Actors.new
    $game_party         = Game_Party.new
    $game_troop         = Game_Troop.new
    $game_map           = Game_Map.new
    $game_player        = Game_Player.new
  set_start_val
  $scene = Scene_Db_Battle_Anime.new
=end
  
######################################################
##戦闘テスト終わり
######################################################

  $scene.main while $scene != nil
  Graphics.transition(30)
rescue Errno::ENOENT
  filename = $!.message.sub("No such file or directory - ", "")
  print("ファイル #{filename} が見つかりません。")
end
