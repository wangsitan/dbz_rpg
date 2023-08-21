class Table
  #--------------------------------------------------------------------------
  # ● 配列に変換
  #--------------------------------------------------------------------------
  def to_a
    if self.xsize > 0 && self.ysize == 1 && self.zsize == 1
      return Array.new(self.xsize) {|x| self[x] }
    elsif self.xsize > 0 && self.ysize > 0 && self.zsize == 1
      return Array.new(self.xsize) do |x|
        Array.new(self.ysize) {|y| self[x, y] }
      end
    elsif self.xsize > 0 && self.ysize > 0 && self.zsize > 0
      return Array.new(self.xsize) do |x|
        Array.new(self.ysize) do |y|
          Array.new(self.zsize) {|z| self[x, y, z] }
        end
      end
    else
      raise "must not happen"
    end
  end
end

module CSV; class << self
  #--------------------------------------------------------------------------
  # ● データベースの書き出し
  #--------------------------------------------------------------------------
  def save_data(filename, data, methods)
    methods = [methods] unless methods.is_a?(Array)
    File.open("#{filename}.csv", "w") do |file|
      out = data.map {|o| methods.map {|m| Array(o.__send__(m)) }.join(",") }
      file.write out.join("\n")
    end
  end
  #--------------------------------------------------------------------------
  # ● アクターのパラメータの書き出し
  #--------------------------------------------------------------------------
  def save_parameter(filename, data, methods)
    for e in data
      property = e.__send__(methods[0])
      File.open("#{filename}.#{e.id}.csv", "w") do |file|
        for i in 0...property.xsize
          for j in 0...(property.ysize-1)
            file.write "#{property[i, j]},"
          end
          file.puts property[i, j+1]
        end
      end
    end
  end

  #--------------------------------------------------------------------------
  # ● データベースの読み込み
  #--------------------------------------------------------------------------
  def load_data(filename, data, methods)
    File.open("#{filename}.csv", "r") do |file|
      file.readlines.each_with_index do |s,i|
        s.chomp.split(",").each_with_index do |v,j|
          data[i].instance_variable_set("@#{methods[j]}", Data(v))
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 配列の読み込み
  #--------------------------------------------------------------------------
  def load_array(filename, data, methods)
    method = "@#{methods.is_a?(Array) ? methods[0] : methods}"
    File.open("#{filename}.csv", "r") do |file|
      file.readlines.each_with_index do |s,i|
        s.chomp.split(",").each_with_index do |v,j|
          data[i].instance_eval("#{method}[#{j}] = #{Data(v)}")
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● Table の読み込み
  #--------------------------------------------------------------------------
  def load_table(filename, data, methods)
    method = "@#{methods.is_a?(Array) ? methods[0] : methods}"
    File.open("#{filename}.csv", "r") do |file|
      file.readlines.each_with_index do |s,i|
        e = data[i].instance_variable_get(method)
        s.chomp.split(",").each_with_index {|v,j| e[j] = v }
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● アクターのパラメータの読み込み
  #--------------------------------------------------------------------------
  def load_parameter(filename, data, methods)
    method = "@#{methods.is_a?(Array) ? methods[0] : methods}"
    for e in data
      fn = "#{filename}.#{e.id}.csv"
      next unless File.exist?(fn)
      params = e.instance_variable_get(method)
      File.open(fn, "r") do |file|
        file.readlines.each_with_index do |s,i|
          s.chomp.split(",").each_with_index {|v,j| params[i, j] = Data(v) }
        end
      end
    end
  end
  
  private
  #--------------------------------------------------------------------------
  # ● 文字列からオブジェクトに変換
  #--------------------------------------------------------------------------
  def Data(str)
    case str
    when /^true$/i;   return true
    when /^false$/i;  return false
    when /^\d+$/;     return Integer(str)
    end
    return str
  end
end; end  # module CSV; class << self