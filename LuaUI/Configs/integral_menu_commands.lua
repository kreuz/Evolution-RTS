VFS.Include("LuaRules/Configs/customcmds.h.lua")

--FIXME: use this table until state tooltip detection is fixed
local tooltips = {
	priority = "Priority: Set construction priority (low, normal, high)",
	miscpriority = "Misc Priority: Set priority for morph or stockpile (low, normal, high)",
	retreat = "Retreat: Retreat to closest retreat point at 30/60/90% of health (right-click to disable)",
	landat = "Repair level: set the HP % at which this aircraft will go to a repair pad (0, 30, 50, 80)",
	factoryGuard = "Auto Assist: Newly built constructors automatically assist their factory",
	diveBomb = "\255\90\255\90Green\255\255\255\255:Dive For Shielded Target\n\255\255\255\90Yellow\255\255\255\255:Dive For All Target\n\255\255\90\90Red\255\255\255\255:Always Fly Low\n\255\90\90\90Grey\255\255\255\255:Always Fly High", --override tooltip supplied by unit_bomber_dive.lua gadget.
	floatState = "\255\90\255\90Green\255\255\255\255:Always float \n\255\90\90\90Grey\255\255\255\255:Float to fire\n\255\255\90\90Red\255\255\255\255:Never float",
	fireState = "Fire State: Sets under what conditions a unit will fire without an explicit attack order (never, when attacked, always)",
	moveState = "Move State: Sets how far out of its way a unit will move to attack enemies",
	["repeat"] = "Repeat: if on the unit will continously push finished orders to the end of its order queue",
}

local factories = {
	ebasefactory = {order = 1},
	ebasefactoryai = {order = 1},
	eamphibfac = {order = 2},
	eamphibfacai = {order = 2},
	eminifac = {order = 3},
	eminifacai = {order = 3},
	eairplant = {order = 4},
	eairplantai = {order = 4},
--	eexperimentalfac = {order = 5},
}

--Integral menu is NON-ROBUST
--all buildings (except facs) need a row or they won't appear!
--you can put too many things into the same row, but the buttons will be squished
local econ = {
--	emetalextractor = {order = 1, row = 1},
--	emetalextractorai = {order = 1, row = 1},
	esolar2 = {order = 2, row = 1},
	esolar2ai = {order = 2, row = 1},
	emediumgen = {order = 3, row = 1},
	emediumgenai = {order = 3, row = 1},
	egeothermal = {order = 4, row = 1},
	efusion2 = {order = 5, row = 1},
	efusion2ai = {order = 5, row = 1},
	emaker = {order = 1, row = 2},
	estorage = {order = 2, row = 2},
	estorageai = {order = 2, row = 2},
}

local defense = {
	elightturret2 = {order = 0, row = 1},
	elightturret2ai = {order = 0, row = 1},
	eheavyturret2 = {order = 1, row = 1},
	eheavyturret2ai = {order = 1, row = 1},
	euwturret = {order = 2, row = 1},
	eartyturret = {order = 3, row = 1},
	emine = {order = 4, row = 1},
	emineai = {order = 4, row = 1},
	ekmar = {order = 0, row = 2},
	eshieldgen = {order = 1, row = 2},
}

local aux = {	--merged into special
	eorb = {order = 0, row = 1},
	eorbai = {order = 0, row = 1},
	ecommander = {order = 1, row = 1},
	eradar2 = {order = 0, row = 2},
	ejammer2 = {order = 1, row = 2},
}

local super = {	--merged into special
	ecruisesilo = {order = 0, row = 2},
	ecruisesiloai = {order = 0, row = 2},
	esilo = {order = 1, row = 2},
}

--manual entries not needed; menu has autodetection
local common_commands = {}
local states_commands = {}

local factory_commands = {}
local econ_commands = {}
local defense_commands = {}
local special_commands = {
	-- [CMD_RAMP] = {order = 16, row = 3},
	-- [CMD_LEVEL] = {order = 17, row = 3},
	-- [CMD_RAISE] = {order = 18, row = 3},
	-- [CMD_RESTORE] = {order = 19, row = 3},
	-- [CMD_SMOOTH] = {order = 20, row = 3},
	--[CMD_BUMPY] = {order = 21, row = 3},
}

local function CopyBuildArray(source, target)
	for name, value in pairs(source) do
		udef = (UnitDefNames[name])
		if udef then
			target[-udef.id] = value
		end
	end
end

CopyBuildArray(factories, factory_commands)
CopyBuildArray(econ, econ_commands)
CopyBuildArray(aux, special_commands)
CopyBuildArray(defense, defense_commands)
CopyBuildArray(super, special_commands)

-- Global commands defined here - they have cmdDesc format + 
local globalCommands = {
--[[	{
		name = "crap",
		texture= 'LuaUi/Images/move_hold.png',
		id = math.huge,
		OnClick = {function() 
			Spring.SendMessage("crap")
		end }
	}
	{
		id      = CMD_RETREAT_ZONE
		type    = CMDTYPE.ICON_MAP,
		tooltip = 'Place a retreat zone. Units will retreat there. Constructors placed in it will repair units.',
		cursor  = 'Repair',
		action  = 'sethaven',
		params  = { }, 
		texture = 'LuaUI/Images/ambulance.png',
	}]]--
}

-- Command overrides. State commands by default expect array of textures, one for each state.
-- You can specify texture, text,tooltip, color
local imageDir = 'LuaUI/Images/commands/'

--[[
local overrides = {
	[CMD.ATTACK] = { texture = imageDir .. 'attack.png',  text= '\255\0\255\0A\008ttack'},
	[CMD.STOP] = { texture = imageDir .. 'cancel.png', color={1,0,0,1.2}, text= '\255\0\255\0S\008top'},
	[CMD.FIGHT] = { texture = imageDir .. 'fight.png',text= '\255\0\255\0F\008ight'},
	[CMD.GUARD] = { texture = imageDir .. 'guard.png', text= '\255\0\255\0G\008uard'},
	[CMD.MOVE] = { texture = imageDir .. 'move.png', text= '\255\0\255\0M\008ove'},
	[CMD.PATROL] = { texture = imageDir .. 'patrol.png', text= '\255\0\255\0P\008atrol'},
	[CMD.WAIT] = { texture = imageDir .. 'wait.png', text= '\255\0\255\0W\008ait'},
	
	[CMD.REPAIR] = {text= '\255\0\255\0R\008epair', texture = imageDir .. 'repair.png'},
	[CMD.RECLAIM] = {text= 'R\255\0\255\0e\008claim', texture = imageDir .. 'reclaim.png'},
	[CMD.RESURRECT] = {text= 'Resurrec\255\0\255\0t\008', texture = imageDir .. 'resurrect.png'},
	[CMD_BUILD] = {text = '\255\0\255\0B\008uild'},
	[CMD.DGUN] = { texture = imageDir .. 'dgun.png', text= '\255\0\255\0D\008Gun'},
	
	[CMD_RAMP] = {text = 'Ramp', texture = imageDir .. 'ramp.png'},
	[CMD_LEVEL] = {text = 'Level', texture = imageDir .. 'level.png'},
	[CMD_RAISE] = {text = 'Raise', texture = imageDir .. 'raise.png'},
	[CMD_SMOOTH] = {text = 'Smooth', texture = imageDir .. 'smooth.png'},
	[CMD_RESTORE] = {text = 'Restore', texture = imageDir .. 'restore.png'},
	
	[CMD_AREA_MEX] = {text = 'Mex', texture = 'LuaUi/Images/ibeam.png'},
	[CMD_JUMP] = {text = 'Jump', texture = imageDir .. 'Bold/jump.png'},	
	
	[CMD.ONOFF] = { texture = {imageDir .. 'states/off.png', imageDir .. 'states/on.png'}, text=''},
	[CMD_UNIT_AI] = { texture = {imageDir .. 'states/bulb_off.png', imageDir .. 'states/bulb_on.png'}, text=''},
	[CMD.REPEAT] = { texture = {imageDir .. 'states/repeat_off.png', imageDir .. 'states/repeat_on.png'}, text=''},
	[CMD.CLOAK] = { texture = {imageDir .. 'states/cloak_off.png', imageDir .. 'states/cloak_on.png'}, text ='', tooltip =  'Unit cloaking state - press \255\0\255\0K\008 to toggle'},
	[CMD_CLOAK_SHIELD] = { texture = {imageDir .. 'states/areacloak_off.png', imageDir .. 'states/areacloak_on.png'}, text ='',},
	[CMD_STEALTH] = { texture = {imageDir .. 'states/stealth_off.png', imageDir .. 'states/stealth_on.png'}, text ='', },
	[CMD_PRIORITY] = { texture = {imageDir .. 'states/wrench_low.png', imageDir .. 'states/wrench_med.png', imageDir .. 'states/wrench_high.png'}, text='', tooltip = tooltips.priority},
	[CMD.MOVE_STATE] = { texture = {imageDir .. 'states/move_hold.png', imageDir .. 'states/move_engage.png', imageDir .. 'states/move_roam.png'}, text=''},
	[CMD.FIRE_STATE] = { texture = {imageDir .. 'states/fire_hold.png', imageDir .. 'states/fire_return.png', imageDir .. 'states/fire_atwill.png'}, text=''},
	[CMD_RETREAT] = { texture = {imageDir .. 'states/retreat_off.png', imageDir .. 'states/retreat_30.png', imageDir .. 'states/retreat_60.png', imageDir .. 'states/retreat_90.png'}, text=''},
}]]

local overrides = {
	[CMD.ATTACK] = { texture = imageDir .. 'Bold/attack.png'},
	[CMD.STOP] = { texture = imageDir .. 'Bold/cancel.png'},
	[CMD.FIGHT] = { texture = imageDir .. 'Bold/fight.png'},
	[CMD.GUARD] = { texture = imageDir .. 'Bold/guard.png'},
	[CMD.MOVE] = { texture = imageDir .. 'Bold/move.png'},
	[CMD.PATROL] = { texture = imageDir .. 'Bold/patrol.png'},
	[CMD.WAIT] = { texture = imageDir .. 'Bold/wait.png'},
	[CMD.CAPTURE] = { texture = imageDir .. 'Bold/capture.png'},
	
	[CMD.REPAIR] = {texture = imageDir .. 'Bold/repair.png'},
	[CMD.RECLAIM] = {texture = imageDir .. 'Bold/reclaim.png'},
	[CMD.RESURRECT] = {texture = imageDir .. 'Bold/resurrect.png'},
	[CMD_BUILD] = {texture = imageDir .. 'Bold/build.png'},
	[CMD.MANUALFIRE] = { texture = imageDir .. 'Bold/dgun.png'},

	[CMD.LOAD_UNITS] = { texture = imageDir .. 'Bold/load.png'},
	[CMD.UNLOAD_UNITS] = { texture = imageDir .. 'Bold/unload.png'},
	[CMD.AREA_ATTACK] = { texture = imageDir .. 'Bold/areaattack.png'},
	
	[CMD_RAMP] = {texture = imageDir .. 'ramp.png'},
	[CMD_LEVEL] = {texture = imageDir .. 'level.png'},
	[CMD_RAISE] = {texture = imageDir .. 'raise.png'},
	[CMD_SMOOTH] = {texture = imageDir .. 'smooth.png'},
	[CMD_RESTORE] = {texture = imageDir .. 'restore.png'},
	[CMD_BUMPY] = {texture = imageDir .. 'bumpy.png'},
	
	[CMD_AREA_GUARD] = { texture = imageDir .. 'Bold/guard.png'},
	
	[CMD_AREA_MEX] = {text = ' ', texture = imageDir .. 'Bold/mex.png'},
	
	[CMD_JUMP] = {texture = imageDir .. 'Bold/jump.png'},	
	
	[CMD_FIND_PAD] = {text = ' ', texture = imageDir .. 'Bold/rearm.png'},
	
	[CMD_EMBARK] = {text = ' ', texture = imageDir .. 'Bold/embark.png'},	
	[CMD_DISEMBARK] = {text = ' ', texture = imageDir .. 'Bold/disembark.png'},
	
	[CMD_ONECLICK_WEAPON] = {},--texture = imageDir .. 'Bold/action.png'},
	[CMD_UNIT_SET_TARGET_CIRCLE] = {text='', texture = imageDir .. 'Bold/settarget.png'},
	[CMD_UNIT_CANCEL_TARGET] = {text='', texture = imageDir .. 'Bold/canceltarget.png'},
	
	[CMD_ABANDON_PW] = {text= '', texture = 'LuaUI/Images/Crystal_Clear_action_flag_white.png'},
	
	[CMD_PLACE_BEACON] = {text= '', texture = imageDir .. 'Bold/drop_beacon.png'},
	
	-- states
	[CMD.ONOFF] = { texture = {imageDir .. 'states/off.png', imageDir .. 'states/on.png'}, text=''},
	[CMD_UNIT_AI] = { texture = {imageDir .. 'states/bulb_off.png', imageDir .. 'states/bulb_on.png'}, text=''},
	[CMD.REPEAT] = { texture = {imageDir .. 'states/repeat_off.png', imageDir .. 'states/repeat_on.png'}, text='', tooltip = tooltips["repeat"]},
	[CMD.CLOAK] = { texture = {imageDir .. 'states/cloak_off.png', imageDir .. 'states/cloak_on.png'},
		text ='', tooltip =  'Unit cloaking state - press \255\0\255\0K\008 to toggle'},
	[CMD_WANT_CLOAK] = { texture = {imageDir .. 'states/cloak_off.png', imageDir .. 'states/cloak_on.png'},
		text ='', tooltip =  'Unit cloaking state - press \255\0\255\0K\008 to toggle'},
	[CMD_CLOAK_SHIELD] = { texture = {imageDir .. 'states/areacloak_off.png', imageDir .. 'states/areacloak_on.png'}, 
		text ='',	tooltip = 'Area Cloaker State'},
	[CMD_STEALTH] = { texture = {imageDir .. 'states/stealth_off.png', imageDir .. 'states/stealth_on.png'}, text ='', },
	[CMD_PRIORITY] = { texture = {imageDir .. 'states/wrench_low.png', imageDir .. 'states/wrench_med.png', imageDir .. 'states/wrench_high.png'},
		text='', tooltip = tooltips.priority},
	[CMD_MISC_PRIORITY] = { texture = {imageDir .. 'states/wrench_low_other.png', imageDir .. 'states/wrench_med_other.png', imageDir .. 'states/wrench_high_other.png'},
		text='', tooltip = tooltips.miscpriority},
	[CMD_FACTORY_GUARD] = { texture = {imageDir .. 'states/autoassist_off.png', imageDir .. 'states/autoassist_on.png'},
		text='', tooltip = tooltips.factoryGuard,},
	[CMD.MOVE_STATE] = { texture = {imageDir .. 'states/move_hold.png', imageDir .. 'states/move_engage.png', imageDir .. 'states/move_roam.png'}, text='', tooltip = tooltips.moveState},
	[CMD.FIRE_STATE] = { texture = {imageDir .. 'states/fire_hold.png', imageDir .. 'states/fire_return.png', imageDir .. 'states/fire_atwill.png'}, text='', tooltip = tooltips.fireState},
	[CMD_RETREAT] = { texture = {imageDir .. 'states/retreat_off.png', imageDir .. 'states/retreat_30.png', imageDir .. 'states/retreat_60.png', imageDir .. 'states/retreat_90.png'},
		text='', tooltip = tooltips.retreat,},
	[CMD.IDLEMODE] = { texture = {imageDir .. 'states/fly_on.png', imageDir .. 'states/fly_off.png'}, text=''},	
	[CMD_AP_FLY_STATE] = { texture = {imageDir .. 'states/fly_on.png', imageDir .. 'states/fly_off.png'}, text=''},
	[CMD.AUTOREPAIRLEVEL] = { texture = {imageDir .. 'states/landat_off.png', imageDir .. 'states/landat_30.png', imageDir .. 'states/landat_50.png', imageDir .. 'states/landat_80.png'},
		text = '', tooltip = tooltips.landat,},
	[CMD_AP_AUTOREPAIRLEVEL] = { texture = {imageDir .. 'states/landat_off.png', imageDir .. 'states/landat_30.png', imageDir .. 'states/landat_50.png', imageDir .. 'states/landat_80.png'},
		text = ''},
	[CMD_UNIT_BOMBER_DIVE_STATE] = { texture = {imageDir .. 'states/divebomb_off.png', imageDir .. 'states/divebomb_shield.png', imageDir .. 'states/divebomb_attack.png', imageDir .. 'states/divebomb_always.png'},
		text = '', tooltip = tooltips.diveBomb},
	[CMD_UNIT_KILL_SUBORDINATES] = {texture = {imageDir .. 'states/capturekill_off.png', imageDir .. 'states/capturekill_on.png'}, text=''},
	[CMD_DONT_FIRE_AT_RADAR] = {texture = {imageDir .. 'states/stealth_on.png', imageDir .. 'states/stealth_off.png'}, text=''},
	[CMD.TRAJECTORY] = { texture = {imageDir .. 'states/traj_low.png', imageDir .. 'states/traj_high.png'}, text=''},
	[CMD_AIR_STRAFE] = { texture = {imageDir .. 'states/strafe_off.png', imageDir .. 'states/strafe_on.png'}, text=''},
	[CMD_UNIT_FLOAT_STATE] = { texture = {imageDir .. 'states/amph_sink.png', imageDir .. 'states/amph_attack.png', imageDir .. 'states/amph_float.png'}, text='', tooltip=tooltips.floatState},
	}

-- noone really knows what this table does but it's needed for epic menu to get the hotkey
local custom_cmd_actions = {
	-- states are 2, targeted commands (e.g. attack) are 1, instant commands (e.g. selfd) are 3
	-- can (probably) set to 1 instead of 3 if order doesn't need to be queueable
	--SPRING COMMANDS
	selfd=3,
	attack=1,
	stop=3,
	fight=1,
	guard=1,
	move=1,
	patrol=1,
	wait=3,
	repair=1,
	reclaim=1,
	resurrect=1,
	manualfire=1,
	loadunits=1,
	unloadunits=1,
	areaattack=1,
	
	-- states
	onoff=2,
	['repeat']=2,
	cloak=2,
	movestate=2,
	firestate=2,
	idlemode=2,
	autorepairlevel=2,
	
	      
	--CUSTOM COMMANDS
	sethaven=1,
	--build=1,
	areamex=1,
	areaguard=1,
	mine=1,
	build=1,
	jump=1,
	find_pad=3,
	embark=3,
	disembark=3,
	oneclickwep=3,
	settarget=1,
	settargetcircle=1,
	canceltarget=3,
	setferry=1, 
	radialmenu=3,
	placebeacon=1,
	buildprev=1,
	
	-- terraform
	rampground=1,
	levelground=1,
	raiseground=1,
	smoothground=1,
	restoreground=1,
	--terraform_internal=1,
	
	resetfire=3,
	resetmove=3,
	
	--states
--	stealth=2, --no longer applicable
	cloak_shield=2,
	retreat=2,
	['luaui noretreat']=2,
	priority=2,
	miscpriority=2,
	ap_fly_state=2,
	ap_autorepairlevel=2,
	floatstate=2,
	dontfireatradar=2,
	antinukezone=2,
	unitai=2,
	unit_kill_subordinates=2,
	autoassist=2,	
	airstrafe=2,
	divestate=2,
}


return common_commands, states_commands, factory_commands, econ_commands, defense_commands, special_commands, globalCommands, overrides, custom_cmd_actions