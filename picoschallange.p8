pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
--main

function _init()
 debug = true
 frame = 0
 offset_x = 0
 offset_y = 0
 final_door_x = 0
 final_door_y = 0
 player = new_player()
 set_up_level()
end

function _update()
 if debug then
  if btnp(4) then
   next_level()
  end
 end
 move_player()
 update_player()
 update_level()
 update_frames()
end

function _draw()
 cls()
 map(0,0)
 spr(player.spr_current,
     player.x, player.y)
 oxg = 0
 if player.key_gold then
  spr(32, oxg+offset_x, 0+offset_y)
  oxg += 8
 end
 if player.key_green then
  spr(33, oxg+offset_x, 0+offset_y)
  oxg += 8
 end
 if player.key_gray then
  spr(34, oxg+offset_x, 0+offset_y)
  oxg += 8
 end
 if player.key_white then
  spr(35, oxg+offset_x, 0+offset_y)
  oxg += 8
 end
 if debug then
  print(player.x, 50+offset_x, 0+offset_y)
  print(player.y, 70+offset_x, 0+offset_y)
 end
 if player.level == 1 then
  print_level_1_info()
 elseif player.level == 3 then
  print_level_3_info()
 end
end

-->8
--player


function new_player()
 local player = {}
 player.x = 0
 player.y = 0
 player.level = 1
 player.spr_idle = 1
 player.spr_left = 2
 player.spr_right = 3
 player.spr_up = 4
 player.spr_down = 5
 player.spr_current = 1
 player.idle = 0
 player.key_gold = false
 player.key_green = false
 player.key_gray = false
 player.key_white = false
 return player
end


function update_player()
 player.idle += 1
 if player.idle > 45 then
  player.spr_current = player.spr_idle
  player.idle = 0
 end
end  


function move_player()
 local x = player.x
 local y = player.y
 
 if btnp(0) then
  x -= 8
  player.idle = 0
  player.spr_current = player.spr_left
 end   
 if btnp(1) then
  x += 8
  player.idle = 0
  player.spr_current = player.spr_right
 end
 if btnp(2) then
  y -= 8
  player.idle = 0
  player.spr_current = player.spr_up
 end
 if btnp(3) then
  y += 8
  player.idle = 0
  player.spr_current = player.spr_down
 end
 
 local sprite = detect_sprite(x, y)
 local flags = detect_flags(sprite) 
 if not flags.obstacle then
  if flags.key then
   if sprite == 32 then
    player.key_gold = true
   elseif sprite == 33 then
    player.key_green = true
   elseif sprite == 34 then
    player.key_gray = true
   elseif sprite == 35 then
    player.key_white = true
   end
   remove_sprite(x, y)
  end
  player.x = x
  player.y = y
  if flags.dead then
   restart_level()
   return
  end
  if sprite == 21 then
   next_level()
  elseif sprite == 26 then
   remove_sprite(x, y)
  elseif sprite == 56 then
   if (mod(2)) player.y += 8
  elseif sprite == 57 then
   if (mod(2)) player.x += 8
  elseif sprite == 58 then
   if (mod(2)) player.y -= 8
  elseif sprite == 59 then
   if (mod(2)) player.x -= 8
  end
 elseif flags.door then 
  if ((sprite == 17 and player.key_gold) or
      (sprite == 18 and player.key_green) or
      (sprite == 19 and player.key_gray) or
      (sprite == 20 and player.key_white)) then
   player.x = x
   player.y = y
   remove_sprite(x, y)
   if sprite == 17 then
    player.key_gold = false
   elseif sprite == 18 then
    player.key_green = false
   elseif sprite == 19 then
    player.key_gray = false
   else
    player.key_white = false
   end
  end
 elseif sprite == 27 then
  replace_sprite(x, y, 28)
  toggle_final_door()
 end
end

-->8
--map and collisions


function toggle_final_door()
 local x = final_door_x
 local y = final_door_y
 local sprite = detect_sprite(x, y)
 if sprite == 22 then
  replace_sprite(x, y, 23)
 elseif sprite == 23 then
  replace_sprite(x, y, 24)
 elseif sprite == 24 then
  replace_sprite(x, y, 25)
 elseif sprite == 25 then
  replace_sprite(x, y, 26)
 end
end


function detect_sprite(x, y)
 local i, j = flr(x/8), flr(y/8)
 local sprite = mget(i, j)
 return sprite
end 


function detect_flags(sprite)
 local flags = {}
 flags.obstacle = fget(sprite, 1)
 flags.key = fget(sprite, 2)
 flags.door = fget(sprite, 3)
 flags.dead = fget(sprite, 4)
 return flags
end


function remove_sprite(x, y)
 local i, j = flr(x/8), flr(y/8)
 mset(i, j, 0)
end


function replace_sprite(x, y, sprite)
 local i, j = flr(x/8), flr(y/8)
 mset(i, j, sprite)
end

-->8
--levels


function next_level()
 player.level += 1
 set_up_level(false)
end


function restart_level()
 set_up_level(true)
end


function level_1()
 camera(0,0)
 player = new_player()
 player.level = 1
 player.x = 4*8
 player.y = 7*8
 final_door_x = 7*8
 final_door_y = 7*8
end


function level_2()
 camera(offset_x, 0)
 player = new_player()
 player.level = 2
 player.x = (8*8)+offset_x
 player.y = 2*8
	final_door_x = (8*8)+offset_x
	final_door_y = 64
end


function level_3()
 camera(offset_x, 0)
 player = new_player()
 player.level = 3
 player.x = (12*8)+offset_x
 player.y = 2*8
 final_door_x = 360
 final_door_y = 16
end


function level_4()
 camera(offset_x, 0)
 player = new_player()
 player.level = 4
 player.x = 8+offset_x
 player.y = 16
end


function set_up_level(restart)
 if player.level == 1 then
  level_1()
 elseif player.level == 2 then
  if not restart then
   offset_x += 128
  end
  level_2()
 elseif player.level == 3 then
  if not restart then
   offset_x += 128
  end
  level_3()
 elseif player.level == 4 then
  if not restart then
   offset_x += 128
  end
  level_4()
 end
end


function update_level()
 for x = offset_x, offset_x+128, 8 do
  for y = offset_y, offset_y+128, 8 do
   local sprite = detect_sprite(x, y)
   if (sprite == 50 or sprite == 51 or
       sprite == 52 or sprite == 53 or
       sprite == 54) then
    update_fire(x, y, sprite)
   end
  end
 end
end


function update_fire(x, y, sprite)
 local nsprite = 0
 if frame % 8 == 0 then
  if sprite == 50 then
   nsprite = 51
  elseif sprite == 51 then
   nsprite = 52
  elseif sprite == 52 then
   nsprite = 53
  elseif sprite == 53 then
   nsprite = 54
  elseif sprite == 54 then
   nsprite = 50
  end
 replace_sprite(x, y, nsprite)
 end
end

-->8
--misc


function update_frames()
 frame += 1
 if frame > 100 then
  frame = 0
 end
end


function mod(modulo)
 if frame % modulo == 0 then
  return true
 end
 return false
end

-->8
--levels' info


function print_level_3_info()
 print("avoid the ", 12+offset_x, 105, 7)
 print("f", 52+offset_x, 105, 8)
 print("i", 56+offset_x, 105, 9)
 print("r", 60+offset_x, 105, 10)
 print("e", 64+offset_x, 105, 7)
end


function print_level_1_info()
 print("take a ", 12, 89, 7)
 print("golden key, ", 40, 89, 10)
 print("then", 88, 89, 7)
 print("open the door with the", 12, 89+6, 7) 
 print("golden knob, ", 12, 89+12, 10)
 print("handle the ", 64, 89+12, 7)
 print("lever, ", 12, 89+18, 8)
 print("and go to the", 40, 89+18, 7)
 print("n", 12, 89+24, 5)
 print("e", 16, 89+24, 6)
 print("x", 20, 89+24, 5)
 print("t", 24, 89+24, 6)
 print(" ", 28, 89+24)
 print("l", 32, 89+24, 5)
 print("e", 36, 89+24, 6)
 print("v", 40, 89+24, 5)
 print("e", 44, 89+24, 6)
 print("l", 48, 89+24, 5)
end
__gfx__
00000000066666600666660000666660066666600666666000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000600000066000006006000006603003066000000600000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700603003066303006006003036600000066000000600000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000600000066000006006000006600000066030030600000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000555555555555555005555555555555555555555500000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700555775555775550000555775555775555557755500000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000055555505555500000055555055555500555555000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000550000555000000005550000550000005500000000000000000000000000000000000000000000000000000000000000000000000000000000000
66656665444444444444444444444444444444445577557744444444444444444444444444444444444444440008000000000000000000000000000000000000
55555555400000044000000440000004400000045577557740000004400000044000000440000004400000040085800000666000000000000000000000000000
65666566404444044044440440444404404444047755775540444404404444044044440440444404404000040068600000666000000000000000000000000000
55555555404444044044440440444404404444047755775566644666404446664044466640444404404000040065600000656000000000000000000000000000
666566654044a4044044340440445404404474045577557740444404404444044044440440444404404000040065600000656000000000000000000000000000
555555554044a4044044340440445404404474045577557766644666666446664044466640444666404000040066600000686000000000000000000000000000
65666566404444044044440440444404404444047755775540444404404444044044440440444404404000040066600000858000000000000000000000000000
55555555404444044044440440444404404444047755775540444404404444044044440440444404404000040000000000080000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
aaa00000333000005550000077700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a0aaaaa0303333305055555070777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a0a0a0a0303030305050505070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
aaa000a0333000305550005077700070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccc0000700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c111cccccccccccc000a9a0000000000000000000000000000000000006000600900009009009000000990000009009000000000000000000000000000000000
cccccccccc111ccc009999a000000000000000000000000000000000067606760090090000900900009009000090090000000000000000000000000000000000
cccc111ccccccccc0a98999000000000000000000000000000000000677767770009900000090090090000900900900000000000000000000000000000000000
cccccccccccc111c9998889a00080000000080000009000000009000000000000900009000090090000990000900900000000000000000000000000000000000
cc111ccccccccccc9888889900009000000900000000800000080000060006000090090000900900009009000090090000000000000000000000000000000000
ccccccccc111cccc888aaa8900000000000000000000000000000000676067600009900009009000090000900009009000000000000000000000000000000000
cccccccccccccccc8aaaaa8800000000000000000000000000000000777677760000000000000000000000000000000000000000000000000000000000000000
__gff__
00000000000000000000000000000000020a0a0a0a000a0a0a0a000202000000040404040000000000000000000000000202100000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000100010000000000010101b00003030102000003400001815101000000000000000000000000000381000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000100010000000000010103030343030100010101000001010101000000000000000000000000000381000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010001b210000000000120000201b00101030000030301000101b1000000000101000003800003900003a00003b00381000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010100000000000000000000010101010000000000000100010000000000010103034303030103310121000000000101000000000000000000000000000381000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10101000000000101010101110101010101010101013101010101011101010101030000000301000000000000000001010000038003b3b3b003a00000000381000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010100000200019151010001b10101010000000000000101510000000000010103030303430100030303000000000101000003800000000003a00000000381000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010100000000010101010101010101010001b230000001016100000221b0010103030300030100030303000333435101000003800393939003a00000000381000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010100000000000000000000010101010000000000000100010000000000010101010101110100030303000362136101000000000000000000000000000381000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000140010000000000010100000000000000000000000353433101000000000000000000000000000381000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10000000000000000000000000001010100000000000001000100000000000101010101010101010101010101010101010000000383b3b00000000000000381000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000101010000000000000100010000000000010101010101010101010101010101010101000000038003a00000000000000381000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000101010000000000000100010000000000010100000000000000000000000000000101000000039393a00000000000000381000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
100000000000000000000000000010101000000000000010001000000000001010101010101010101010101010101010100000000000000000373b3b3b3b3b1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
