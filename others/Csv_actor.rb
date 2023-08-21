=begin
  CSV入出力テストforツクールVX (2010/07/19)
　　　　　　　　by 半生
http://www.tktkgame.com/
http://www11.atpages.jp/namahanka/
  
・CsvOut.export_actors
　アクターデータをCSVで出力
・CsvOut.import_actors
　CSVのアクターデータを"Data/Actors.rvdata"に取り込み
=end

module SimpleCSV
  module_function

  # ダブルクォーテーションのエスケープ他
  def csv_escape(param, dq=true)
    param = param.to_s unless param.is_a?(String)
    if param.include?("\"")
      dq = true
      param = param.gsub("\"","\001").gsub("\001","\"\"")
    elsif param.include?(",")
      dq = true
    end
    if dq
      return "\"#{param}\""
    else
      return "#{param}"
    end
  end
  
  # ダブルクォーテーションのアンエスケープ
  def csv_unescape(str)
    data = str.sub(/^\s*\"?/,"").sub(/\"?\s*$/,"")
    return data.gsub("\"\"","\001").gsub("\001","\"")
  end
  
  # 二次元配列をCSV文字列に変換
  def ary2csv(lines, sep=",")
    text = ""
    lines.each do |line|
      text += line.map{|param| csv_escape(param)}.join(sep)
      text += "\n"
    end
    return text
  end

  # CSV一行を一次元配列に分解
  def csv_split_line(str, sep=",")
    line_datas = []

    tmp_datas = str.split(sep)
    tmp = ""
    tmp_datas.each do |item|
      tmp += item
      if tmp.count("\"") % 2 == 0
        data = csv_unescape(tmp)
        line_datas.push(data)
        tmp = ""
      else
        tmp += sep
      end
    end
    if tmp != ""
      raise("CSV convert error: cols")
    end
    return line_datas
  end
  
  # CSVの文字列を二次元配列に変換
  def csv2ary(str)
    lines = []
    datas = []
    tmp_lines = str.split("\n")
    tmp_data = ""
    tmp_lines.each do |tmp_line|
      tmp_data += tmp_line
      if tmp_data.count("\"") % 2 == 0
        lines.push(tmp_data)
        tmp_data = ""
      else
        tmp_data += "\n"
      end
    end
    if tmp_data != ""
      raise("CSV convert error: rows")
    end
    lines.each do |line|
      datas.push(csv_split_line(line))
    end
    return datas
  end
end

module CsvOut
  ACTOR_PARAMS = ["最大HP","最大MP","攻撃力","防御力","精神力","敏捷性"]
  LABEL_LEVEL = ["\# レベル"] + (1..99).to_a
  
  module_function

  def load_csv(filename)
    file = open(filename,"r")
    str = file.read
    file.close
    data = NKF.nkf('-Sw --cp932', str)
    return SimpleCSV::csv2ary(data)
  end
  
  def save_csv(filename, ary)
    str = SimpleCSV::ary2csv(ary)
    str = NKF.nkf('-Ws --cp932', str)
    open(filename, "w") {|file|
      file.print(str)
    }
  end
  
  def export_actors
    actors = load_data("Data/Actors.rvdata")
    save_csv("Actors.csv", [["人数","#{actors.size - 1}"]])
    actors.each do |actor|
      next if actor.nil?
      filename = sprintf("Actor%03d.csv", actor.id)
      save_csv(filename, get_actor_datas(actor))
    end
  end
  def get_actor_datas(actor)
    lines = []
    lines.push(["ID", actor.id])
    lines.push(["名前", actor.name])
    lines.push(["クラスID", actor.class_id])
    lines.push(["初期レベル", actor.initial_level])
    lines.push(["Exp基本値", actor.exp_basis])
    lines.push(["Exp増加度", actor.exp_inflation])
    lines.push(["キャラ画像", actor.character_name])
    lines.push(["キャラインデックス", actor.character_index])
    lines.push(["顔画像", actor.face_name])
    lines.push(["顔インデックス", actor.face_index])
    lines.push(LABEL_LEVEL)
    for param_no in 0..5
      params = [ACTOR_PARAMS[param_no]]
      for lv in 1..99
        params.push(actor.parameters[param_no, lv])
      end
      lines.push(params)
    end
    lines.push(["武器ID", actor.weapon_id])
    lines.push(["盾ID", actor.armor1_id])
    lines.push(["兜ID", actor.armor2_id])
    lines.push(["鎧ID", actor.armor3_id])
    lines.push(["装飾ID", actor.armor4_id])
    lines.push(["二刀流フラグ", actor.two_swords_style])
    lines.push(["装備固定フラグ", actor.fix_equipment])
    lines.push(["自動戦闘フラグ", actor.auto_battle])
    lines.push(["強力防御フラグ", actor.super_guard])
    lines.push(["薬の知識フラグ", actor.pharmacology])
    lines.push(["クリティカル頻発フラグ", actor.critical_bonus])
  end
  
  def set_actor_datas(lines, actor=RPG::Actor.new)
    lines.each do |line|
      case line.first
      when "ID"
        actor.id = line[1].to_i
      when "名前"
        actor.name = line[1]
      when "クラスID"
        actor.class_id = line[1].to_i
      when "初期レベル"
        actor.initial_level = line[1].to_i
      when "Exp基本値"
        actor.exp_basis = line[1].to_i
      when "Exp増加度"
        actor.exp_inflation = line[1].to_i
      when "キャラ画像"
        actor.character_name = line[1]
      when "キャラインデックス"
        actor.character_index = line[1].to_i
      when "顔画像"
        actor.face_name = line[1]
      when "顔インデックス"
        actor.face_index = line[1].to_i
      when ACTOR_PARAMS[0]
        for level in 1..99
          actor.parameters[0, level] = line[level + 0].to_i
        end
      when ACTOR_PARAMS[1]
        for level in 1..99
          actor.parameters[1, level] = line[level + 0].to_i
        end
      when ACTOR_PARAMS[2]
        for level in 1..99
          actor.parameters[2, level] = line[level + 0].to_i
        end
      when ACTOR_PARAMS[3]
        for level in 1..99
          actor.parameters[3, level] = line[level + 0].to_i
        end
      when ACTOR_PARAMS[4]
        for level in 1..99
          actor.parameters[4, level] = line[level + 0].to_i
        end
      when ACTOR_PARAMS[5]
        for level in 1..99
          actor.parameters[5, level] = line[level + 0].to_i
        end
      when "武器ID"
        actor.weapon_id = line[1].to_i
      when "盾ID"
        actor.armor1_id = line[1].to_i
      when "兜ID"
        actor.armor2_id = line[1].to_i
      when "鎧ID"
        actor.armor3_id = line[1].to_i
      when "装飾ID"
        actor.armor4_id = line[1].to_i
      when "二刀流フラグ"
        actor.two_swords_style = (line[1].downcase == "true")
      when "装備固定フラグ"
        actor.fix_equipment = (line[1].downcase == "true")
      when "自動戦闘フラグ"
        actor.auto_battle = (line[1].downcase == "true")
      when "強力防御フラグ"
        actor.super_guard = (line[1].downcase == "true")
      when "薬の知識フラグ"
        actor.pharmacology = (line[1].downcase == "true")
      when "クリティカル頻発フラグ"
        actor.critical_bonus = (line[1].downcase == "true")
      end
    end
    return actor
  end
  
  def import_actors(filename="Actors.csv")
    unless FileTest.exist?(filename)
      p "CSVデータが見つかりませんでした。"
      return
    end
    actors = [nil]
    general = load_csv(filename)
    actor_size = general[0][1].to_i
    actor_size.times do |i|
      actor_id = i + 1
      datas = load_csv(sprintf("Actor%03d.csv", actor_id))
      actors.push(set_actor_datas(datas))
    end
    save_data(actors, "Data/Actors.rvdata")
  end
  
end