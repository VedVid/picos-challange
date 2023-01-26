pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
--main

function _init()
 player = new_player(5*8,
          5*8, 1)
end

function _update()
 move_player()
 update_player()
end

function _draw()
 cls()
 map((1*player.level)-1,
     (1*player.level)-1,
     0,
     0,
     16,
     16)
 spr(player.spr_current,
     player.x, player.y)
end

-->8
--player


function new_player(x, y, lvl)
 local player = {}
 player.x = x
 player.y = y
 player.level = lvl
 player.spr_idle = 1
 player.spr_left = 2
 player.spr_right = 3
 player.spr_up = 4
 player.spr_down = 5
 player.spr_current = 1
 player.idle = 0
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
 
 if btn(0) then
  x -= 1
  player.idle = 0
  player.spr_current = player.spr_left
 end   
 if btn(1) then
  x += 1
  player.idle = 0
  player.spr_current = player.spr_right
 end
 if btn(2) then
  y -= 1
  player.idle = 0
  player.spr_current = player.spr_up
 end
 if btn(3) then
  y += 1
  player.idle = 0
  player.spr_current = player.spr_down
 end
  
 local flags = collision(x, y)
 if not flags.obstacle then
  player.x = x
  player.y = y
 end
end

-->8
--map and collisions

function collision(x, y)
 local i, j = flr(x/8), flr(y/8)
 local sprite = mget(i, j)
 local flags = {}
 flags.obstacle = fget(sprite, 1)
 return flags
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
66656665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65666566000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66656665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65666566000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
