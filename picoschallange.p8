pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
--main

function _init()
 player = new_player()
 game_map = new_map()
 set_up_level()
end

function _update()
 move_player()
 update_player()
end

function _draw()
 cls()
 map(game_map.cell_x,
     game_map.cell_y,
     game_map.start_x,
     game_map.start_y,
     game_map.cell_w,
     game_map.cell_h)
 spr(player.spr_current,
     player.x, player.y)
 oxg = 0
 if player.key_gold then
  spr(32, oxg, 0)
  oxg += 8
 end
 if player.key_green then
  spr(33, oxg, 0)
  oxg += 8
 end
 if player.key_gray then
  spr(34, oxg, 0)
  oxg += 8
 end
 if player.key_white then
  spr(35, oxg, 0)
  oxg += 8
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
  if sprite == 21 then
   next_level()
  elseif sprite == 26 then
   remove_sprite(x, y)
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


function new_map()
 local nmap = {}
 nmap.cell_x = 0
 nmap.cell_y = 0
 nmap.start_x = 0
 nmap.start_y = 0
 nmap.cell_w = 16
 nmap.cell_h = 16
 nmap.layer = 0
 nmap.final_door_x = 0
 nmap.final_door_y = 0
 return nmap
end


function toggle_final_door()
 local x = game_map.final_door_x
 local y = game_map.final_door_y
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
 set_up_level()
end


function level_1()
 player = new_player()
 player.level = 1
 player.x = 5*8
 player.y = 5*8
 game_map = new_map()
 game_map.final_door_x = 2*8
 game_map.final_door_y = 2*8
end


function level_2()
 player = new_player()
 player.level = 2
 player.x = 5*8
 player.y = 5*8
 game_map = new_map()
 game_map.cell_x = 16
	game_map.final_door_x = 14*8
	game_map.final_door_y = 2*8
end


function set_up_level()
 if player.level == 1 then
  level_1()
 elseif player.level == 2 then
  level_2()
 end
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
__gff__
00000000000000000000000000000000020a0a0a0a000a0a0a0a000202000000040404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1015160020002100220023000000001010000000000000000000000000161510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010100000000000000000000000001010000000000000000000000000101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000011001200130014000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
100000001b001b001b001b000000001010001b1b1b1b00000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001010000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
