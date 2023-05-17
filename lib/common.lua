local module = {}

module.bool_to_number = { [true]=1, [false]=0 }
-- Empty table that refers to currently playing looped sounds. Stops and destroys them if the entity they're playing from didnt die
module.looped_sounds = {}

function module.teleport_mount(ent, x, y)
    if ent.overlay ~= nil then
        move_entity(ent.overlay.uid, x, y, 0, 0)
    else
        move_entity(ent.uid, x, y, 0, 0)
    end
    -- ent.more_flags = clr_flag(ent.more_flags, 16)
    --set_camera_position(x, y)--wow this looks wrong, i think this auto-corrected at some point :/ (it was deprecated)
    state.camera.adjusted_focus_x = x
    state.camera.adjusted_focus_y = y
end

function module.rotate(cx, cy, x, y, degrees)
	local radians = degrees * (math.pi/180)
	local rx = math.cos(radians) * (x - cx) - math.sin(radians) * (y - cy) + cx
	local ry = math.sin(radians) * (x - cx) + math.cos(radians) * (y - cy) + cy
	local result = {rx, ry}
	return result
end

function module.file_exists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function module.lines_from(file)
  if not module.file_exists(file) then return {} end
  local lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

function module.CompactList(list, prev_size)
	local j=0
	for i=1,prev_size do
		if list[i]~=nil then
			j=j+1
			list[j]=list[i]
		end
	end
	for i=j+1,prev_size do
		list[i]=nil
	end
	return list
end

function module.TableLength(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

--Use key = next(t)
--function module.TableFirstKey(t)

--Use _, value = next(t)
--function module.TableFirstValue(t)

function module.TableCopyRandomElement(tbl)
	return module.TableCopy(tbl[math.random(#tbl)])
end

---appends elements of t2 to t1 and returns t1
function module.TableConcat(t1, t2)
	for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function module.has(arr, item)
    for _, v in pairs(arr) do
        if v == item then
            return true
        end
    end
    return false
end

function module.map(tbl, f)
	local t = {}
	for k, v in ipairs(tbl) do
		t[k] = f(v)
	end
	return t
end

function module.TableCopy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[module.TableCopy(k, s)] = module.TableCopy(v, s) end
  return res
end

function module.setn(t,n)
	setmetatable(t,{__len=function() return n end})
end

function module.shake_camera(countdown_start, countdown, amplitude, multiplier_x, multiplier_y, uniform_shake)
  state.camera.shake_countdown_start = countdown_start
  state.camera.shake_countdown = countdown
  state.camera.shake_amplitude = amplitude
  state.camera.shake_multiplier_x = multiplier_x
  state.camera.shake_multiplier_y = multiplier_y
  state.camera.uniform_shake = uniform_shake
end

--This function isn't perfect yet but it's fine for now.
function module.play_sound_at_entity(snd, uid, volume, sound_loops, amplitude)
  -- Amplitude effects how far away a sound can be heard. By default, a sound can be heard from 14 tiles away and the volume / panning scales proportionally
  -- By default amplitude is 1, and its multiplied to either increase or decrease the distance a sound is heard.
  local v = 0.5
  local a = 1
  local loops = false
  -- Default values for our optional arguments
  if volume ~= nil then
      v = volume
  end
  if sound_loops ~= nil then
      loops = true
  end
  if amplitude ~= nil then
    a = amplitude
  end
  local ent = get_entity(uid)
  local audio = nil
  -- Custom sounds and vanilla sounds get played differently
  if type(snd) == "string" then
    local sound = get_sound(snd)
    audio = sound:play(false)
  else
    audio = snd:play(false)
  end
  -- Setup sound
  local x, y, _ = get_position(ent.uid)
  local sx, sy = screen_position(x, y)
  local cx, cy = state.camera.adjusted_focus_x, state.camera.adjusted_focus_y
  local d = screen_distance(math.abs(math.sqrt((sx-cx)^2+(sy-cy)^2)))
  if get_entity(state.camera.focused_entity_uid) ~= nil then
    d = screen_distance(distance(ent.uid, state.camera.focused_entity_uid))
  end
  audio:set_volume(v)
  audio:set_parameter(VANILLA_SOUND_PARAM.POS_SCREEN_X, sx)
  audio:set_parameter(VANILLA_SOUND_PARAM.DIST_CENTER_X, math.abs(sx)*1.5)
  audio:set_parameter(VANILLA_SOUND_PARAM.DIST_CENTER_Y, math.abs(sy)*1.5)
  audio:set_parameter(VANILLA_SOUND_PARAM.DIST_Z, 0.0)
  audio:set_parameter(VANILLA_SOUND_PARAM.DIST_PLAYER, d)
  audio:set_parameter(VANILLA_SOUND_PARAM.VALUE, v)
  commonlib.update_sound_volume(audio, ent.uid, v, a)
  -- Setup for looped sounds
  if loops then
      -- Add the looped sound to the list of looped sounds to be cleared on a screen change
      table.insert(commonlib.looped_sounds, audio)
      -- If this is a custom sound, set it to loop
      if type(snd) ~= "string" then
        audio:set_looping(SOUND_LOOP_MODE.LOOP)
      end
      -- It's assumed this looping sound is attached to an entity with a statemachine
      ent:set_post_update_state_machine(function()
        commonlib.update_sound_volume(audio, ent.uid, v, a)
      end)
    -- Stop the sound when the entity dies
    ent:set_pre_destroy(function(self)
      audio:stop(true)   
    end)
  end
  -- Unpause and start the sound
  audio:set_pause(false, SOUND_TYPE.SFX) 

  -- Return the audio object so users can control the sound
  return audio 
end
function module.clear_looped_sounds()
  for _, audio in ipairs(module.looped_sounds) do
      audio:stop(true)
  end
  module.looped_sounds = {}
end

-- Clears looped sounds on a screen change
set_callback(module.clear_looped_sounds, ON.TRANSITION)
set_callback(module.clear_looped_sounds, ON.PRE_LEVEL_GENERATION)

-- Updates the panning and volume of a sound relative to its position in the world
function module.update_sound_volume(snd, uid, volume, amplitude)
  local v = 0.5
  if volume ~= nil then
      v = volume
  end
  -- Setup sound
  local ent = get_entity(uid)
  local x, y, _ = get_position(ent.uid)
  local sx, sy = screen_position(x, y)
  local fx, _, _ = 0, 0, 0
  local cx, cy = state.camera.adjusted_focus_x, state.camera.adjusted_focus_y
  local d = screen_distance(math.abs(math.sqrt((sx-cx)^2+(sy-cy)^2)))
  local td = math.abs(math.sqrt((sx-cx)^2+(sy-cy)^2))
  fx = state.camera.adjusted_focus_x
  if get_entity(state.camera.focused_entity_uid) ~= nil then
    d = screen_distance(distance(ent.uid, state.camera.focused_entity_uid))
    td = distance(ent.uid, state.camera.focused_entity_uid)
    fx, _ ,_ = get_position(state.camera.focused_entity_uid)
  end
  -- Set panning / volume
  if td > 2 then
    snd:set_pan(((x-fx)/15)/amplitude)
  else
    snd:set_pan(0)
  end
  if td > 3 then
    snd:set_volume(v-(((distance(uid, state.camera.focused_entity_uid)/15)*v)/amplitude))
  else
    snd:set_volume(v)
  end
  snd:set_parameter(VANILLA_SOUND_PARAM.DIST_Z, 0.0)
  snd:set_parameter(VANILLA_SOUND_PARAM.DIST_PLAYER, d)
  snd:set_parameter(VANILLA_SOUND_PARAM.VALUE, v)
end

-- Useful for doing animations, check if an entity is within a certain distance of another, etc.
function module.in_range(x, y1, y2)
  if x >= y1 and x <= y2 then
      return true
  end
  return false
end

return module