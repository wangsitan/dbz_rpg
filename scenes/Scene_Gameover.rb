#==============================================================================
# ■ Scene_Gameover
#------------------------------------------------------------------------------
# 　ゲームオーバー画面の処理を行うクラスです。
#==============================================================================

class Scene_Gameover < Scene_Base #< Scene_Map #
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------  
  def initialize
    @frame_count = 0
    @temp_frame_count = 0
    @back_color = set_skn_color 0
    @back_color_white = Color.new(255, 255, 255,255)
    @z1_anime_no = 0
    @z1_anime_muki = 1
    set_z2_variable
    
    @endflag = true
    ##############ZGデバッグ用############
    #$game_variables[40] = 2
    #$game_variables[43] = 151
    #$partyc = [3,4,5,6,7,8,9,10,24]
    #$partyc = [3,5]
    #####################################
    #@put_frame = true
    #$game_variables[40] = 2
    #$game_variables[60] = 2
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    
    RPG::BGM.stop
    RPG::BGS.stop

    create_msg_window
    create_gameover_graphic
    if $game_variables[40] >= 2
      if $game_variables[43] >=151 && $game_variables[43] <= 200
        set_zg_variable
      else
        set_z3_variable
      end
    end
    set_bgm_msg
    set_grapihc
    
    #$data_system.gameover_me.play
    #Graphics.transition(20)
    #Graphics.freeze
    
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_gameover_graphic
    dispose_msg_window
    $scene = nil if $BTEST
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    if @put_frame == true
      @frame_count_sprite.bitmap.clear
      @frame_count_sprite.bitmap.draw_text(0,0,640,100,@frame_count)
    end
    
    @frame_count += 1 
    
    case $game_variables[40]
    when 0
      if @frame_count == 16
        @frame_count = 0

        @z1_anime_no += @z1_anime_muki
        if @z1_anime_no == 3 || @z1_anime_no == -1
          @z1_anime_muki = -@z1_anime_muki
          @z1_anime_no += @z1_anime_muki*2
        end
      end
    when 1
      
      case @frame_count
      
      when 110
        @temp_frame_count = @frame_count
        @z2_furi_anime_patten += 1
        @z2_gokuu_anime_temp_x = @sprite.x-2
        @z2_gokuu_anime_temp_y = @sprite.y
        @z2_furi_anime_temp_x = @sprite2.x
        @z2_furi_anime_temp_y = @sprite2.y
      when 181
        @temp_frame_count = @frame_count
        @z2_gokuu_anime_patten += 1
        @z2_gokuu_anime_temp_x = @sprite.x-10
        @z2_gokuu_anime_temp_y = @sprite.y
        @z2_furi_anime_temp_x = @sprite2.x
        @z2_furi_anime_temp_y = @sprite2.y
      when 230
        @temp_frame_count = @frame_count
        @z2_gokuu_anime_patten += 1
        @z2_furi_anime_patten += 1
        @z2_gokuu_anime_temp_x = @sprite.x
        @z2_gokuu_anime_temp_y = @sprite.y
        @z2_furi_anime_temp_x = @sprite2.x
        @z2_furi_anime_temp_y = @sprite2.y
      when 330
        @temp_frame_count = @frame_count
        @z2_gokuu_anime_patten += 1
        @z2_furi_anime_patten += 1
        @z2_gokuu_anime_temp_x = @sprite.x
        @z2_gokuu_anime_temp_y = @sprite.y
        @z2_furi_anime_temp_x = @sprite2.x
        @z2_furi_anime_temp_y = @sprite2.y
        @z2_furi_anime_no += 1
        @z2_gokuu_anime_no = 2
      when 338
        @z2_furi_anime_no -= 1
      when 350
        @temp_frame_count = @frame_count
        @z2_gokuu_anime_no = 1
        @z2_gokuu_anime_patten += 1
        @z2_furi_anime_patten += 1
        #@z2_furi_anime_no += 1
        @z2_gokuu_anime_temp_x = @sprite.x
        @z2_gokuu_anime_temp_y = @sprite.y
        @z2_furi_anime_temp_x = @sprite2.x
        @z2_furi_anime_temp_y = @sprite2.y
        @sprite2.x = -100
        @sprite2.y = -100
        #@sprite2.bitmap.clear
      when 390
        @temp_frame_count = @frame_count
        @z2_gokuu_anime_no = 0
        @z2_gokuu_anime_patten += 1
        @z2_gokuu_anime_temp_x = @sprite.x
        @z2_gokuu_anime_temp_y = @sprite.y
        @z2_furi_anime_temp_x = @sprite2.x
        @z2_furi_anime_temp_y = @sprite2.y
        #rect = Rect.new(0, 0, 640,480)
        #@back_sprite.bitmap.fill_rect(rect,@back_color)
      when 500
        @temp_frame_count = @frame_count
        @z2_gokuu_anime_patten += 1
        @z2_gokuri_anime_patten = 1
        @sprite2.x = @z2_gokuri_anime_temp_x 
        @sprite2.y = @z2_gokuri_anime_temp_y
      when 760
        @temp_frame_count = @frame_count
        @z2_gokuu_anime_patten += 1
        @z2_gokuri_anime_patten += 1
        @z2_gokuu_anime_temp_x = 384
        @z2_gokuu_anime_temp_y = -64
        @sprite.x = @z2_gokuu_anime_temp_x
        @sprite.y = @z2_gokuu_anime_temp_y
        @z2_gokuri_anime_temp_x = @sprite2.x
        @z2_gokuri_anime_temp_y = @sprite2.y
        @z2_gokuri_anime_no = 2
      when 900
        @temp_frame_count = @frame_count
        @z2_gokuu_anime_patten += 1
        @z2_gokuu_anime_temp_x = @sprite.x
        @z2_gokuu_anime_temp_y = @sprite.y
        @z2_gokuri_anime_temp_x = @sprite2.x
        @z2_gokuri_anime_temp_y = @sprite2.y
        @z2_gokuri_anime_patten -= 1
        @z2_gokuri_anime_no = 0
      when 1150
        @temp_frame_count = @frame_count
        @z2_gokuu_anime_patten += 1
        @z2_gokuu_anime_no = 0
        @z2_gokuri_anime_patten = 3
        @z2_gokuu_anime_temp_x = 640
        @z2_gokuu_anime_temp_y = 230
        @sprite.x = @z2_gokuu_anime_temp_x
        @sprite.y = @z2_gokuu_anime_temp_y
      when 1600
        @temp_frame_count = @frame_count
        @z2_gokuu_anime_patten += 1
        @z2_gokuu_anime_no = 0
        @z2_gokuu_anime_temp_x = -64
        @z2_gokuu_anime_temp_y = 160
        @sprite.x = @z2_gokuu_anime_temp_x
        @sprite.y = @z2_gokuu_anime_temp_y
      when 2000
        @frame_count = 0
        @temp_frame_count = 0
        @sprite.mirror = false
        set_z2_variable
      end
      
      case @z2_gokuu_anime_patten
      when 0
        if (@frame_count-@temp_frame_count) % 8 == 0
          if @z2_gokuu_anime_no == 0
            @z2_gokuu_anime_no = 1
          else
            @z2_gokuu_anime_no = 0
          end
        end
      when 1
        @z2_gokuu_anime_no = 2
      when 2
        if (@frame_count-@temp_frame_count)%8 == 0
          
          if @z2_gokuu_anime_up_flag == false
            @z2_gokuu_anime_no -= 1
          else
            @z2_gokuu_anime_no += 1
          end
          
          if @z2_gokuu_anime_no == 5
            @z2_gokuu_anime_up_flag = false
            @z2_gokuu_anime_no = 3
          elsif @z2_gokuu_anime_no == 1
            @z2_gokuu_anime_up_flag = true
            @z2_gokuu_anime_no = 3
          end
        end
      when 3
      
      when 4
        if (@frame_count-@temp_frame_count) % 4 == 0
          rect = Rect.new(0, 0, 640,480)
          if @z2_gokuu_anime_no == 1
            @back_sprite.bitmap.fill_rect(rect,@back_color_white)
          else
            @back_sprite.bitmap.fill_rect(rect,@back_color)
          end
        end
        
        if (@frame_count-@temp_frame_count+1) % 4 == 0
          if @z2_gokuu_anime_no == 1
            @z2_gokuu_anime_no = 0
          else
            @z2_gokuu_anime_no = 1
          end
        end
      when 9
        if (@frame_count-@temp_frame_count)%8 == 0
          
          if @z2_gokuu_anime_up_flag == false
            @z2_gokuu_anime_no -= 1
          else
            @z2_gokuu_anime_no += 1
          end
          
          if @z2_gokuu_anime_no == 3
            @z2_gokuu_anime_up_flag = false
            @z2_gokuu_anime_no = 1
          elsif @z2_gokuu_anime_no == -1
            @z2_gokuu_anime_up_flag = true
            @z2_gokuu_anime_no = 1
          end
        end
      when 10
        if (@frame_count-@temp_frame_count) % 8 == 0
          if @z2_gokuu_anime_no == 0
            @z2_gokuu_anime_no = 1
          else
            @z2_gokuu_anime_no = 0
          end
        end
      end 
      
      case @z2_gokuri_anime_patten
      
      when 1
        if (@frame_count-@temp_frame_count) % 16 == 0
          if @z2_gokuri_anime_no == 0
            @z2_gokuri_anime_no = 1
          else
            @z2_gokuri_anime_no = 0
          end
        end
      when 2
        
        
      end
      
    when 2
      
      
      if $game_variables[43] >=151 && $game_variables[43] <= 200
        #ZG
        
        #点滅管理
        tenmetusframe = 120
        case @frame_count
        
        when 120,126,136,142,148,151,154,159,162,168,174,176..177,181,184,189..192 #灰色
          @back_spritecor[1].visible = true
          @back_spritecor[2].visible = false
          @back_spritecor[3].visible = false
        when 121,124..125,127,129,140..141,143,147,152..153,157..158,161,165..166,169,172,175,178..179,188 #赤
          @back_spritecor[2].visible = true
          @back_spritecor[1].visible = false
          @back_spritecor[3].visible = false
        when 122..123,128,130,132..133,137..139,149,155,160,170,186..187 #白
          @back_spritecor[3].visible = true
          @back_spritecor[1].visible = false
          @back_spritecor[2].visible = false
        else #黒
          @back_spritecor[1].visible = false
          @back_spritecor[2].visible = false
          @back_spritecor[3].visible = false
        end
        
        #爆発管理
        bakuhatutusframe = tenmetusframe + 28
        case @frame_count
        
        when bakuhatutusframe
          @bakuanimey = 0
          @bakuanimex = 1
          @bakuanime_sprite.src_rect = Rect.new(176*@bakuanimex,144*@bakuanimey, 176, 144)
          @bakuanime_sprite.visible = true
        
        when bakuhatutusframe + 2
          @bakuanimey = 0
          @bakuanimex = 0
          @bakuanime_sprite.src_rect = Rect.new(176*@bakuanimex,144*@bakuanimey, 176, 144)
        when bakuhatutusframe + 6,bakuhatutusframe + 66,bakuhatutusframe + 74
          @bakuanimey = 1
          @bakuanimex = 0
          @bakuanime_sprite.src_rect = Rect.new(176*@bakuanimex,144*@bakuanimey, 176, 144)
        
        when bakuhatutusframe + 6,bakuhatutusframe + 62,bakuhatutusframe + 70
          @bakuanimey = 1
          @bakuanimex = 1
          @bakuanime_sprite.src_rect = Rect.new(176*@bakuanimex,144*@bakuanimey, 176, 144)
           
        when bakuhatutusframe + 10,bakuhatutusframe + 50,bakuhatutusframe + 58
          @bakuanimey = 2
          @bakuanimex = 0
          @bakuanime_sprite.src_rect = Rect.new(176*@bakuanimex,144*@bakuanimey, 176, 144)
        when bakuhatutusframe + 46,bakuhatutusframe + 54
          @bakuanimey = 2
          @bakuanimex = 1
          @bakuanime_sprite.src_rect = Rect.new(176*@bakuanimex,144*@bakuanimey, 176, 144)
            
        when bakuhatutusframe + 34,bakuhatutusframe + 42
          @bakuanimey = 3
          @bakuanimex = 0
          @bakuanime_sprite.src_rect = Rect.new(176*@bakuanimex,144*@bakuanimey, 176, 144)
          
        when bakuhatutusframe + 14,bakuhatutusframe + 30,bakuhatutusframe + 38
          @bakuanimey = 3
          @bakuanimex = 1
          @bakuanime_sprite.src_rect = Rect.new(176*@bakuanimex,144*@bakuanimey, 176, 144)
           
        when bakuhatutusframe + 18,bakuhatutusframe + 26
          @bakuanimey = 4
          @bakuanimex = 0
          @bakuanime_sprite.src_rect = Rect.new(176*@bakuanimex,144*@bakuanimey, 176, 144)
           
        when bakuhatutusframe + 22
          @bakuanimey = 4
          @bakuanimex = 1
          @bakuanime_sprite.src_rect = Rect.new(176*@bakuanimex,144*@bakuanimey, 176, 144)
        when bakuhatutusframe + 78
          @bakuanime_sprite.visible = false
        end
        #168からそれぞれ散る
        #防御状態に
        if @frame_count == 168
          for x in 0..$partyc.size - 1
            #@cha_sprite[x] = Sprite.new
            #@cha_sprite[x].bitmap = Cache.picture(set_battle_character_name $partyc[x],0) #パーティーキャラの必殺技グラを取得
            @cha_sprite[x].src_rect = Rect.new(0,96*16, 96, 96)
            #@cha_sprite[x].z = 200
            #@cha_sprite[x].visible = true
          end
        end
        
        if @frame_count >= 168 && @frame_count <= 333
          
          idouy = 12
          idoux = 16
          for x in 0..$partyc.size - 1
            case x
            
            when 0
              @cha_sprite[x].y -= idouy
            when 1
              @cha_sprite[x].x -= idoux
              @cha_sprite[x].y -= idouy
            when 2
              @cha_sprite[x].x += idoux
              @cha_sprite[x].y -= idouy
            when 3
              @cha_sprite[x].x -= idoux
              @cha_sprite[x].y -= idouy / 2
            when 4
              @cha_sprite[x].x += idoux
              @cha_sprite[x].y -= idouy / 2
            when 5
              @cha_sprite[x].x -= idoux
              @cha_sprite[x].y -= idouy / 3
            when 6
              @cha_sprite[x].x += idoux
              @cha_sprite[x].y -= idouy / 3
            when 7
              @cha_sprite[x].x -= idoux
            when 8
              @cha_sprite[x].x += idoux
            end
          end
        end
        
        #落ちてくる(28フレームで着く)
        otiru_y = 12
        otisframe = 334
        oti1fre = 27
        oti2fre = 23
        oti3fre = 19
        oti4fre = 13
        oti5fre = 9
        case @frame_count
        
        when otisframe..(otisframe+oti1fre) #28
          @cha_down_sprite[0].y += otiru_y
        when (otisframe+oti1fre+1)..(otisframe+oti1fre+oti2fre+1) # 24
          @cha_down_sprite[1].y += otiru_y if @cha_down_sprite[1] != nil
        when (otisframe+oti1fre+oti2fre+2)..(otisframe+oti1fre+oti2fre*2+2) # 24
          @cha_down_sprite[2].y += otiru_y if @cha_down_sprite[2] != nil
        when (otisframe+oti1fre+oti2fre*2+3)..(otisframe+oti1fre+oti2fre*2+oti3fre+3) # 20
          @cha_down_sprite[3].y += otiru_y if @cha_down_sprite[3] != nil
        when (otisframe+oti1fre+oti2fre*2+oti3fre+4)..(otisframe+oti1fre+oti2fre*2+oti3fre*2+4) # 20
          @cha_down_sprite[4].y += otiru_y if @cha_down_sprite[4] != nil
        when (otisframe+oti1fre+oti2fre*2+oti3fre*2+5)..(otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre+5) # 16
          @cha_down_sprite[5].y += otiru_y if @cha_down_sprite[5] != nil
        when (otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre+6)..(otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre*2+6) # 16
          @cha_down_sprite[6].y += otiru_y if @cha_down_sprite[6] != nil
        when (otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre*2+7)..(otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre*2+oti5fre+7) # 12
          @cha_down_sprite[7].y += otiru_y if @cha_down_sprite[7] != nil
        when (otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre*2+oti5fre+8)..(otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre*2+oti5fre*2+8) # 12
          @cha_down_sprite[8].y += otiru_y if @cha_down_sprite[8] != nil
        end
        
        #SE管理
        case @frame_count
        
        when (otisframe+oti1fre),(otisframe+oti1fre+oti2fre+1),(otisframe+oti1fre+oti2fre*2+2),(otisframe+oti1fre+oti2fre*2+oti3fre+3),(otisframe+oti1fre+oti2fre*2+oti3fre*2+4),(otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre+5),
          (otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre*2+6),(otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre*2+oti5fre+7),(otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre*2+oti5fre*2+8)
          
          Audio.se_play("Audio/SE/" + "ZG 打撃1")
          
          @shakeflag = true
          @grayflag = true
          #p @cha_down_sprite[@run_cha_sp_no],@run_cha_sp_no
          if @cha_down_sprite[@run_cha_sp_no + 1] == nil && @run_cha_sp_no < 8 #最後まで来たら無視するため8にする
            @frame_count = (otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre*2+oti5fre*2+8) + 0
          end

        end
        
        #グレースケール管理管理
        if @grayflag == true && @run_cha_sp_no < 9 #最後の人を処理するため、9にする
          @cha_down_sprite[@run_cha_sp_no].tone = Tone.new(0,0,0,255)
          @grayflag = false
          @run_cha_sp_no += 1
        end
=begin
        #グレースケール管理管理
        case @frame_count
        
        when (otisframe+oti1fre)
          @cha_down_sprite[0].tone = Tone.new(0,0,0,255)
        when (otisframe+oti1fre+oti2fre+1)
          @cha_down_sprite[1].tone = Tone.new(0,0,0,255) if @cha_down_sprite[1] != nil
        when (otisframe+oti1fre+oti2fre*2+2)
          @cha_down_sprite[2].tone = Tone.new(0,0,0,255) if @cha_down_sprite[2] != nil
        when (otisframe+oti1fre+oti2fre*2+oti3fre+3)
          @cha_down_sprite[3].tone = Tone.new(0,0,0,255) if @cha_down_sprite[3] != nil
        when (otisframe+oti1fre+oti2fre*2+oti3fre*2+4)
          @cha_down_sprite[4].tone = Tone.new(0,0,0,255) if @cha_down_sprite[4] != nil
        when (otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre+5)
          @cha_down_sprite[5].tone = Tone.new(0,0,0,255) if @cha_down_sprite[5] != nil
        when (otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre*2+6)
          @cha_down_sprite[6].tone = Tone.new(0,0,0,255) if @cha_down_sprite[6] != nil
        when (otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre*2+oti5fre+7)
          @cha_down_sprite[7].tone = Tone.new(0,0,0,255) if @cha_down_sprite[7] != nil
        when (otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre*2+oti5fre*2+8)
          @cha_down_sprite[8].tone = Tone.new(0,0,0,255) if @cha_down_sprite[8] != nil
        end
=end
        
        #着地した時の振動管理
        if @shakeflag == true
          for x in 0..$partyc.size - 1
            if @cha_down_sprite[x].y > 0
              if @shakeend == true
                @cha_down_sprite[x].y -= 4
              else
                @cha_down_sprite[x].y += 4
              end
            end
          end
          
          if @shakeend == false
            @shakeend = true
          else
            @shakeend = false
            @shakeflag = false
          end
        end
        
        #GAME OVER表示
        #全部落ちて84フレーム後
        #8フレーム後に明るいやつ
        #60フレーム後終了する
        
        case @frame_count
        
        when (otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre*2+oti5fre*2+8) + 84
          Audio.se_play("Audio/SE/" + "ZG SE070") if @frame_count == (otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre*2+oti5fre*2+8) + 84
          @gameover_sprite.visible = true
        when (otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre*2+oti5fre*2+8) + 92  
          @gameover_sprite.src_rect = Rect.new(0, 16,140, 16)
        end
        if @frame_count >= (otisframe+oti1fre+oti2fre*2+oti3fre*2+oti4fre*2+oti5fre*2+8) + 150
          @endflag = true
        end
      else #Z3
        case @frame_count
        
        when @z3_strat_frame
          @z3_gokuu_anime_patten = 0
        when @z3_strat_frame + 2,@z3_strat_frame + 4,@z3_strat_frame + 6
          @z3_gokuu_anime_patten += 1
        end
        
        if @z3_gokuu_anime_patten == 3
          if @frame_count == (@z3_strat_frame + 6 + @z3_gokuu_anime_koteif)
            @z3_gokuu_anime_patten += 1
          end
        elsif @z3_gokuu_anime_patten >= 4 && (@frame_count - @z3_strat_frame + 6 + @z3_gokuu_anime_koteif) % 8 == 0
            
          if @z3_gokuu_anime_patten != 13
            @z3_gokuu_anime_patten += 1
          else
            @z3_gokuu_anime_patten = 3
            @frame_count = @z3_strat_frame + 8
          end
        end
      end
    end
      super
      if Input.trigger?(Input::C) && @endflag == true
        $game_progress = $game_variables[40]
        $scene = Scene_Title.new
        Graphics.fadeout(60)
      end
      
=begin
      if Input.trigger?(Input::RIGHT)
        $game_variables[60] +=1
        @msg_window.contents.clear
        set_bgm_msg
      end
      
      if Input.trigger?(Input::LEFT)
        
        if $game_variables[60] != 1
          $game_variables[60] -=1
          @msg_window.contents.clear
          set_bgm_msg
        end
      end
=end
    set_grapihc
    
  end
  #--------------------------------------------------------------------------
  # ● トランジション実行
  #--------------------------------------------------------------------------
  def perform_transition
    Graphics.transition(20)
  end
  #--------------------------------------------------------------------------
  # ● ゲームオーバーグラフィックの作成
  #--------------------------------------------------------------------------
  def create_gameover_graphic
    @back_sprite = Sprite.new
    rect = Rect.new(0, 0, 640,480)
    @back_sprite.bitmap = Bitmap.new(640, 480)
    @back_sprite.bitmap.fill_rect(rect,@back_color)
    @sprite2 = Sprite.new
    @sprite = Sprite.new
    @sprite.z = 255
    @frame_count_sprite = Sprite.new
    @frame_count_sprite.bitmap = Bitmap.new(640, 480)
    
    if $game_variables[40] >= 2
      if $game_variables[43] >=151 && $game_variables[43] <= 200
        
        #背景色
        @back_spritecor = []
        @back_spritecor[0] = Sprite.new
        @back_spritecor[1] = Sprite.new
        @back_spritecor[2] = Sprite.new
        @back_spritecor[3] = Sprite.new
        
        color = Color.new(0, 0, 0,255)
        rect = Rect.new(0, 0, 640,480)
        @back_spritecor[0].bitmap = Bitmap.new(640, 480)
        @back_spritecor[0].bitmap.fill_rect(rect,color) #黒
        @back_spritecor[0].visible = true
        color = Color.new(127, 127, 127,255)
        @back_spritecor[1].bitmap = Bitmap.new(640, 480)
        @back_spritecor[1].bitmap.fill_rect(rect,color) #灰色
        @back_spritecor[1].visible = false
        color = Color.new(224, 80, 0,255)
        @back_spritecor[2].bitmap = Bitmap.new(640, 480)
        @back_spritecor[2].bitmap.fill_rect(rect,color) #赤
        @back_spritecor[2].visible = false
        color = Color.new(255, 255, 255,255)
        @back_spritecor[3].bitmap = Bitmap.new(640, 480)
        @back_spritecor[3].bitmap.fill_rect(rect,color) #白
        @back_spritecor[3].visible = false
        #@sprite2.y = @sprite.y-64
        
        @gameover_sprite = Sprite.new #ゲームオーバー文字
        @gameover_sprite.bitmap = Cache.picture("戦闘アニメ_ゲームオーバー用_文字")
        @gameover_sprite.src_rect = Rect.new(0, 0,140, 16)
        @gameover_sprite.z = 100
        @gameover_sprite.x = 250
        @gameover_sprite.y = 160
        @gameover_sprite.visible = false
        
        @bakuanimex = 1 #爆発アニメの読み込み位置
        @bakuanimey = 0 #爆発アニメの読み込み位置
        
        
        @bakuanime_sprite = Sprite.new
        @bakuanime_sprite.bitmap = Cache.picture("戦闘アニメ_ゲームオーバー用_爆発")
        @bakuanime_sprite.src_rect = Rect.new(@bakuanimex*176, @bakuanimey*144,176, 144)
        @bakuanime_sprite.z = 100
        @bakuanime_sprite.x = 240
        @bakuanime_sprite.y = 130
        @bakuanime_sprite.visible = false
        
        #パーティー内のキャラクター
        @cha_sprite = []
        @cha_down_sprite = []
      
        kaishi_x = 284
        kaishi_y = 24
        
        tyousei_x = 0
        tyousei_y = 0
        for x in 0..$partyc.size - 1
          @cha_sprite[x] = Sprite.new
          @cha_sprite[x].bitmap = Cache.picture(set_battle_character_name $partyc[x],0) #パーティーキャラの必殺技グラを取得
          @cha_sprite[x].src_rect = Rect.new(0,96*0, 96, 96)
          @cha_sprite[x].z = 200
          @cha_sprite[x].visible = true
          @cha_down_sprite[x] = Sprite.new
          @cha_down_sprite[x].bitmap = Cache.picture(set_battle_character_name $partyc[x],0) #パーティーキャラの必殺技グラを取得
          @cha_down_sprite[x].src_rect = Rect.new(0,96*17, 96, 96)
          @cha_down_sprite[x].z = 200
          @cha_down_sprite[x].visible = true
          @cha_down_sprite[x].y = - 96
          #位置調整
          case x
          
          when 0
            @cha_sprite[x].x = kaishi_x + tyousei_x - 16
            @cha_sprite[x].y = kaishi_y + tyousei_y
            @cha_sprite[x].mirror = true
            @cha_down_sprite[x].x = @cha_sprite[x].x
            @cha_down_sprite[x].mirror = true
          when 1
            @cha_sprite[x].x = kaishi_x - 80 + tyousei_x
            @cha_sprite[x].y = kaishi_y + 24 + tyousei_y
            @cha_down_sprite[x].x = @cha_sprite[x].x
          when 2
            @cha_sprite[x].x = kaishi_x + 80 + tyousei_x - 24
            @cha_sprite[x].y = kaishi_y + 24 + tyousei_y
            @cha_sprite[x].mirror = true
            @cha_down_sprite[x].x = @cha_sprite[x].x
            @cha_down_sprite[x].mirror = true
          when 3
            @cha_sprite[x].x = kaishi_x - 160 + tyousei_x
            @cha_sprite[x].y = kaishi_y + 48 + tyousei_y
            @cha_down_sprite[x].x = @cha_sprite[x].x
          when 4
            @cha_sprite[x].x = kaishi_x + 160 + tyousei_x - 24
            @cha_sprite[x].y = kaishi_y + 48 + tyousei_y
            @cha_sprite[x].mirror = true
            @cha_down_sprite[x].x = @cha_sprite[x].x
            @cha_down_sprite[x].mirror = true
          when 5
            @cha_sprite[x].x = kaishi_x - 160 + tyousei_x
            @cha_sprite[x].y = kaishi_y + 144 + tyousei_y
            @cha_down_sprite[x].x = @cha_sprite[x].x
          when 6
            @cha_sprite[x].x = kaishi_x + 160 + tyousei_x - 24
            @cha_sprite[x].y = kaishi_y + 144 + tyousei_y
            @cha_sprite[x].mirror = true
            @cha_down_sprite[x].x = @cha_sprite[x].x
            @cha_down_sprite[x].mirror = true
          when 7
            @cha_sprite[x].x = kaishi_x - 80 + tyousei_x
            #@cha_sprite[x].x = kaishi_x - 280 + tyousei_x
            @cha_sprite[x].y = kaishi_y + 192 + tyousei_y
            @cha_down_sprite[x].x = @cha_sprite[x].x
          when 8
            @cha_sprite[x].x = kaishi_x + 80 + tyousei_x - 24
            #@cha_sprite[x].x = kaishi_x + 280 + tyousei_x - 24
            @cha_sprite[x].y = kaishi_y + 192 + tyousei_y
            @cha_sprite[x].mirror = true
            @cha_down_sprite[x].x = @cha_sprite[x].x
            @cha_down_sprite[x].mirror = true
          end
        end
      end
    end
    #@back_sprite.color = @back_color
    #@sprite.bitmap = Cache.system("GameOver")
  end
  #--------------------------------------------------------------------------
  # ● ゲームオーバーグラフィックの解放
  #--------------------------------------------------------------------------
  def dispose_gameover_graphic
    if @sprite != nil
      #@sprite.bitmap.dispose
      @sprite.dispose
    end
    if @sprite2 != nil
      #@sprite2.bitmap.dispose
      @sprite2.dispose
    end
    if @back_sprite != nil
      #@back_sprite.bitmap.dispose
      @back_sprite.dispose
    end
    
    if @back_spritecor != nil
      for x in 0..@back_spritecor.size-1
        @back_spritecor[x].dispose
      end
    end
    
    if @cha_sprite != nil
      for x in 0..@cha_sprite.size-1
        @cha_sprite[x].dispose
      end
    end
    
    if @cha_down_sprite != nil
      for x in 0..@cha_down_sprite.size-1
        @cha_down_sprite[x].dispose
      end
    end
    
    if @gameover_sprite != nil
      @gameover_sprite.dispose
    end
  end
  #--------------------------------------------------------------------------
  # ● メッセージウインドウ開放
  #--------------------------------------------------------------------------   
  def dispose_msg_window
    @msg_window.dispose
    @msg_window = nil
    
    if @msg_window2 != nil
      @msg_window2.dispose
    end
  end 
  #--------------------------------------------------------------------------
  # ● メッセージウインドウ作成
  #--------------------------------------------------------------------------   
  def create_msg_window
    
    if $game_variables[40] == 0
      @msg_window = Window_Base.new(0,128-128,640,128)

    elsif $game_variables[40] == 1
      @msg_window = Window_Base.new(0,480-128,640,128)
    elsif $game_variables[40] == 2
      if $game_variables[43] >=151 && $game_variables[43] <= 200
        #ZG
        @msg_window = Window_Base.new(0,480-128,640,128)
        
      else #Z3
        @msg_window = Window_Base.new(0,480-128,640,128)
        @msg_window2 = Window_Base.new(0,128-128,640,128)
        @msg_window2.opacity=255
        @msg_window2.back_opacity=255
        @msg_window2.contents.font.color.set( 0, 0, 0)
      end
    end
      @msg_window.opacity=255
      @msg_window.back_opacity=255
      @msg_window.contents.font.color.set( 0, 0, 0)
  end
  #--------------------------------------------------------------------------
  # ● BGMとメッセージの設定
  #--------------------------------------------------------------------------
  def set_bgm_msg
    
    if $game_variables[40] == 0
      
      Audio.bgm_play("Audio/BGM/" + "Z1 メニュー")    # 効果音を再生する
      @msg_window.contents.draw_text(0,12, 600, 20, "　　　　　 　　　　　　　ゲームオーバー")
      @msg_window.contents.draw_text(0,50, 600, 20, "　　　　　　Ｚ戦士たちは　敢えなく　全滅してしまった！")
    elsif $game_variables[40] == 1
      Audio.bgm_play("Audio/BGM/" + "Z2 ゲームオーバー")    # 効果音を再生する
      @msg_window.contents.draw_text(0,25, 600, 20, "　　　　　　　　　　全員大怪我を　してしまった！！")
      @msg_window.contents.draw_text(0,50, 600, 20, "　　　　　　　これでは　もう　戦うことは　できない！！")
    elsif $game_variables[40] == 2
      if $game_variables[43] >=151 && $game_variables[43] <= 200
        Audio.se_play("Audio/SE/" + "ZG ゲームオーバー")    # 効果音を再生する
        @msg_window.contents.draw_text(0,25, 600, 20, " 　　　　　　　　　　　　　フハハハ…")
        @msg_window.contents.draw_text(0,50, 600, 20, " 　　　　　　　　　　我が恨み　思い知ったか！")

      else #Z3
        Audio.bgm_play("Audio/BGM/" + "Z3 ゲームオーバー")    # 効果音を再生する
        str_space = " "
        
        if ($data_enemies[$game_variables[60]].name.split(//).size) > 0 && ($data_enemies[$game_variables[60]].name.split(//).size) < 21
          str_space = str_space * (21 - $data_enemies[$game_variables[60]].name.split(//).size)
        else
          str_space = " "
        end
        @msg_window.contents.draw_text(0,25, 600, 20, str_space + $data_enemies[$game_variables[60]].name + "を　倒すことが出来ず")
        @msg_window.contents.draw_text(0,50, 600, 20, "　　　　　 Ｚ戦士たちは　戦闘不能に　なってしまった！！")
        @msg_window2.contents.draw_text(0,25, 600, 20, "　　　　　 　　　　　　　ゲームオーバー")
        #@msg_window2.contents.draw_text(0,50, 600, 20, "　　　　　　Ｚ戦士たちは　遭えなく　全滅してしまった！")
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 画像の設定
  #--------------------------------------------------------------------------  
  def set_grapihc
    if $game_variables[40] == 0
      picture = "Z1_ゲームオーバー"
      @sprite.bitmap = Cache.picture(picture)
      @sprite.src_rect = Rect.new(96*@z1_anime_no, 0, 96, 208) # 悟空とご飯
      @sprite.x = 640/2-48
      @sprite.y = 128+60
    elsif $game_variables[40] == 1
      
      sgokuu_def_y = 128
      picture = "Z2_ゲームオーバー小"
      picture2 = "Z2_ゲームオーバー大"
      @sprite.bitmap = Cache.picture(picture)
      @sprite2.bitmap = Cache.picture(picture)
      
      case @z2_gokuu_anime_patten
      when 0
        @sprite.src_rect = Rect.new(40*@z2_gokuu_anime_no,0, 40, 48) # 悟空
        @sprite.x = @z2_gokuu_anime_temp_x-(@frame_count - @temp_frame_count)*2
        @sprite.y = sgokuu_def_y
      when 1
        @sprite.src_rect = Rect.new(80+62*(@z2_gokuu_anime_no-2),0, 62, 48) # 悟空
        @sprite.x = @z2_gokuu_anime_temp_x-(@frame_count - @temp_frame_count)*2
        @sprite.y = sgokuu_def_y - @frame_count + @temp_frame_count
      when 2
        @sprite.src_rect = Rect.new(80+62*(@z2_gokuu_anime_no-2),0, 62, 48) # 悟空
        @sprite.x = @z2_gokuu_anime_temp_x+(@frame_count - @temp_frame_count)*1
        @sprite.y = @z2_gokuu_anime_temp_y+(@frame_count - @temp_frame_count)*1
      when 3
        @sprite.src_rect = Rect.new(80+62*(@z2_gokuu_anime_no-2),0, 62, 48) # 悟空
        @sprite.x = @z2_gokuu_anime_temp_x+(@frame_count - @temp_frame_count)*2
        @sprite.y = @z2_gokuu_anime_temp_y
      when 4
        @sprite.src_rect = Rect.new(50*(@z2_gokuu_anime_no),96,50, 48) # 炎
        @sprite.x = @z2_gokuu_anime_temp_x+12
        @sprite.y = @z2_gokuu_anime_temp_y
      when 5
        @sprite.src_rect = Rect.new(0,144,36, 48) # 悟空飛ぶ
        @sprite.x = @z2_gokuu_anime_temp_x+8
        @sprite.y = @z2_gokuu_anime_temp_y-(@frame_count - @temp_frame_count)*3
      when 7
        @sprite.bitmap = Cache.picture(picture2)
        @sprite.src_rect = Rect.new(0,432, 64, 78) # 悟空落ちる
        @sprite.x = @z2_gokuu_anime_temp_x
        @sprite.y = @z2_gokuu_anime_temp_y+(@frame_count - @temp_frame_count)*2
      when 8
        @sprite.bitmap = Cache.picture(picture2)
        @sprite.src_rect = Rect.new(64,432, 80, 60) # 悟空運ばれる
        @sprite.x = @z2_gokuu_anime_temp_x-12+(@frame_count - @temp_frame_count)*2
        @sprite.y = @z2_gokuu_anime_temp_y+46
      when 9
        @sprite.bitmap = Cache.picture(picture2)
        @sprite.src_rect = Rect.new(72*@z2_gokuu_anime_no,510, 72, 94) # 悟空大歩く
        @sprite.x = @z2_gokuu_anime_temp_x-(@frame_count - @temp_frame_count)*2
        @sprite.y = @z2_gokuu_anime_temp_y
      when 10
        @sprite.src_rect = Rect.new(40*@z2_gokuu_anime_no,0, 40, 48) # 悟空
        @sprite.mirror = true
        @sprite.x = @z2_gokuu_anime_temp_x+(@frame_count - @temp_frame_count)*2
        @sprite.y = @z2_gokuu_anime_temp_y
      end
      
      case @z2_furi_anime_patten
      when 0
        @sprite2.src_rect = Rect.new(64*@z2_furi_anime_no,48, 64, 48) # フリーザ
        @sprite2.x = 0-64-4+@frame_count*2
        @sprite2.y = sgokuu_def_y-48
      when 1 
        @sprite2.src_rect = Rect.new(64*@z2_furi_anime_no,48, 64, 48) # フリーザ
        @sprite2.x = @z2_furi_anime_temp_x
        @sprite2.y = @z2_furi_anime_temp_y
      when 2 
        @sprite2.src_rect = Rect.new(64*@z2_furi_anime_no,48, 64, 48) # フリーザ
        @sprite2.x = @z2_furi_anime_temp_x+(@frame_count - @temp_frame_count)*1
        @sprite2.y = @z2_furi_anime_temp_y+(@frame_count - @temp_frame_count)*1
      when 3 
        @sprite2.src_rect = Rect.new(64*@z2_furi_anime_no,48, 64, 48) # フリーザ
        @sprite2.x = @z2_furi_anime_temp_x
        @sprite2.y = @z2_furi_anime_temp_y
      end
      
      case @z2_gokuri_anime_patten
      when 1
        @sprite2.bitmap = Cache.picture(picture2)
        @sprite2.src_rect = Rect.new(0,144*@z2_gokuri_anime_no, 216, 144) # 栗りんご飯
        @sprite2.x = @z2_gokuri_anime_temp_x+(@frame_count - @temp_frame_count)*2
        @sprite2.y = @z2_gokuri_anime_temp_y
      when 2
        @sprite2.bitmap = Cache.picture(picture2)
        @sprite2.src_rect = Rect.new(0,144*@z2_gokuri_anime_no, 216, 144) # 栗りんご飯
        @sprite2.x = @z2_gokuri_anime_temp_x
        @sprite2.y = @z2_gokuri_anime_temp_y
      end
    elsif $game_variables[40] == 2
      if $game_variables[43] >=151 && $game_variables[43] <= 200

      else #Z3
        picture = "Z3_ゲームオーバー"
        @sprite.bitmap = Cache.picture(picture)
        @sprite.src_rect = Rect.new(0,96*@z3_gokuu_anime_patten, 240, 96)
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● Z2の変数の設定
  #--------------------------------------------------------------------------  
  def set_z2_variable
    @z2_gokuu_anime_no = 0
    @z2_gokuu_anime_no_up_flag = false
    @z2_furi_anime_no = 0
    @z2_hirou_anime_no = 0
    @z2_gokuu_anime_patten = 0
    @z2_furi_anime_patten = 0
    @z2_gokuu_anime_temp_x = 648
    @z2_gokuu_anime_temp_y = 0
    @z2_furi_anime_temp_x = 0
    @z2_furi_anime_temp_y = 0
    @z2_gokuri_anime_no = 0
    @z2_gokuri_anime_patten = 0
    @z2_gokuri_anime_temp_x = -212
    @z2_gokuri_anime_temp_y = 180
  end
  
  #--------------------------------------------------------------------------
  # ● Z3の変数の設定
  #--------------------------------------------------------------------------
  def set_z3_variable
    @z3_gokuu_anime_patten = 100
    @z3_strat_frame = 2
    @z3_gokuu_anime_koteif = 120
    @sprite.x = 200
    @sprite.y = 192
    #@sprite.zoom_x = 2
    #@sprite.zoom_y = 2
    color = Color.new(0, 0, 0,255)
    rect = Rect.new(0, 0, 640,224)
    @sprite2.bitmap = Bitmap.new(640, 224)
    @sprite2.bitmap.fill_rect(rect,color)
    @sprite2.y = @sprite.y-64
  end
  
  #--------------------------------------------------------------------------
  # ● ZGの変数の設定
  #--------------------------------------------------------------------------
  def set_zg_variable

    @z3_gokuu_anime_patten = 100
    @z3_strat_frame = 2
    @z3_gokuu_anime_koteif = 120
    @sprite.x = 200
    @sprite.y = 192
    #@sprite.zoom_x = 2
    #@sprite.zoom_y = 2
    @shakeflag = false #振動フラグ 落ちて来た時の振動を管理
    @shakeend = false #振動処理完了
    @grayflag = false #グレースケール処理フラグ
    @run_cha_sp_no = 0 #処理中のspriteNo(最後に終わるために使用
    @endflag = false

  end
  

end
