--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function merge(t1, t2)
	for i, v in pairs(t2) do
		t1[i] = v
	end
end

-- swarm arrays
-- these are not strictly required they just help with inputting the units

local longRangeSwarmieeArray = { 
	["cormart"] = true,
	["firewalker"] = true,
	["armsptk"] = true,
	["corstorm"] = true,
	["shiparty"] = true,
	["armham"] = true,
}

local medRangeSwarmieeArray = { 
	["armrock"] = true,
	["amphfloater"] = true,
	["chickens"] = true,
}

local lowRangeSwarmieeArray = {
	["corthud"] = true,
	["spiderassault"] = true,
	["corraid"] = true,
	["armzeus"] = true,
	["logkoda"] = true,
	["hoverassault"] = true,
	
	["correap"] = true,
	["corgol"] = true,
	
	["armcrabe"] = true,
	["armmanni"] = true,
	
	["chickenr"] = true,
	["chickenblobber"] = true,
	["armsnipe"] = true, -- only worth swarming sniper at low range, too accurate otherwise.
}

merge(medRangeSwarmieeArray,longRangeSwarmieeArray)
merge(lowRangeSwarmieeArray,medRangeSwarmieeArray)


-- skirm arrays
-- these are not strictly required they just help with inputting the units

local veryShortRangeSkirmieeArray = {
	["corcan"] = true,
	["spherepole"] = true,
	["armtick"] = true,
	["puppy"] = true,
	["corroach"] = true,
	["chicken"] = true,
	["chickena"] = true,
	["chicken_tiamat"] = true,
	["chicken_dragon"] = true,
}

local shortRangeSkirmieeArray = {
	["armflea"] = true,
	["armpw"] = true,
	["corfav"] = true,
	["corgator"] = true,
	["corpyro"] = true,
	["logkoda"] = true,
	["amphraider3"] = true,
	["corsumo"] = true,
}

local riotRangeSkirmieeArray = {
	["corak"] = true,
	["panther"] = true,
	["corsh"] = true,
	["shipscout"] = true,
	["shipraider"] = true,
	["amphriot"] = true,
	["armcomdgun"] = true,
	["dante"] = true,
}

local lowMedRangeSkirmieeArray = {
	["armcom"] = true,
	["armadvcom"] = true,

	["armwar"] = true,
	["hoverassault"] = true,
	["arm_venom"] = true,
	
	["cormak"] = true,
	["corthud"] = true,
	["corraid"] = true,
}

local medRangeSkirmieeArray = {
	["corcom"] = true,
	["coradvcom"] = true,
	["commsupport"] = true,
	["commadvsupport"] = true,
	
	["spiderriot"] = true,
	["armzeus"] = true,
	["amphraider2"] = true,
	
	["spiderassault"] = true,
	["corlevlr"] = true,
	
	["hoverriot"] = true,
    ["shieldfelon"] = true,

	["correap"] = true,
	["corgol"] = true,
	["tawf114"] = true, -- banisher
}

for name,data in pairs(UnitDefNames) do -- add all comms to mid range skirm
	if data.customParams.commtype then
		medRangeSkirmieeArray[name] = true
	end
end

local longRangeSkirmieeArray = {
	["armrock"] = true,
	["amphfloater"] = true,
	["nsclash"] = true, -- hover janus
	["capturecar"] = true,
	["chickenc"] = true,
	["armbanth"] = true,
	["gorg"] = true,
	["corllt"] = true,
	["armdeva"] = true,
	["armartic"] = true,
}

local artyRangeSkirmieeArray = {
	["shipskirm"] = true,
	["armsptk"] = true,
	["corstorm"] = true,
	["amphassault"] = true,
	["chicken_sporeshooter"] = true,
	["corrl"] = true,
	["corhlt"] = true,
	["armpb"] = true,
	["cordoom"] = true,
	["armorco"] = true,
}

merge(shortRangeSkirmieeArray,veryShortRangeSkirmieeArray)
merge(riotRangeSkirmieeArray,shortRangeSkirmieeArray)
merge(lowMedRangeSkirmieeArray, riotRangeSkirmieeArray)
merge(medRangeSkirmieeArray, lowMedRangeSkirmieeArray)
merge(longRangeSkirmieeArray,medRangeSkirmieeArray)
merge(artyRangeSkirmieeArray,longRangeSkirmieeArray)

-- Stuff that mobile AA skirms

local skirmableAir = {
	["blastwing"] = true,
	["bladew"] = true,
	["armkam"] = true,
	["corape"] = true,
	["armbrawl"] = true,
	["blackdawn"] = true,
	["corbtrans"] = true,
	["corcrw"] = true,
}

-- Things that are fled by some things

local fleeables = {
	["corllt"] = true,
	["armdeva"] = true,
	["armartic"] = true,
	["corgrav"] = true,
	
	["armcom"] = true,
	["armadvcom"] = true,
	["corcom"] = true,
	["coradvcom"] = true,
	
	["armwar"] = true,
	["armzeus"] = true,
	
	["arm_venom"] = true,
	["spiderriot"] = true,
	
	["cormak"] = true,
	
	["corlevlr"] = true,
	["capturecar"] = true,

	["hoverriot"] = true, -- mumbo
    ["shieldfelon"] = true,
	["corsumo"] = true,
}

local armedLand = {}
for name,data in pairs(UnitDefNames) do
	if data.canAttack and (not data.canFly) 
	and data.weapons[1] and data.weapons[1].onlyTargets.land then
		armedLand[name] = true 
	end
end

-- searchRange(defaults to 800): max range of GetNearestEnemy for the unit.
-- defaultAIState (defaults in config): (1 or 0) state of AI when unit is initialised

--*** skirms(defaults to empty): the table of units that this unit will attempt to keep at max range
-- skirmEverything (defaults to false): Skirms everything (does not skirm radar with this enabled only)
-- skirmLeeway: (Weapon range - skirmLeeway) = distance that the unit will try to keep from units while skirming
-- stoppingDistance (defaults to 0): (skirmLeeway - stoppingDistance) = max distance from target unit that move commands can be given while skirming
-- skirmRadar (defaults to false): Skirms radar dots
-- skirmOrderDis (defaults in config): max distance the move order is from the unit when skirming
-- velocityPrediction (defaults in config): number of frames of enemy velocity prediction for skirming and fleeing

--*** swarms(defaults to empty): the table of units that this unit will jink towards and strafe
-- maxSwarmLeeway (defaults to Weapon range): (Weapon range - maxSwarmLeeway) = Max range that the unit will begin strafing targets while swarming
-- minSwarmLeeway (defaults to Weapon range): (Weapon range - minSwarmLeeway) = Range that the unit will attempt to move further away from the target while swarming
-- jinkTangentLength (default in config): component of jink vector tangent to direction to enemy
-- jinkParallelLength (default in config): component of jink vector parallel to direction to enemy
-- circleStrafe (defaults to false): when set to true the unit will run all around the target unit, false will cause the unit to jink back and forth
-- minCircleStrafeDistance (default in config): (weapon range - minCircleStrafeDistance) = distance at which the circle strafer will attempt to move away from target
-- strafeOrderLength (default in config): length of move order while strafing
-- swarmLeeway (defaults to 50): adds to enemy range when swarming
-- swarmEnemyDefaultRange (defaults to 800): range of the enemy used if it cannot be seen.
-- alwaysJinkFight (defaults to false): If enabled the unit with jink whenever it has a fight command
-- localJinkOrder (defaults in config): Causes move commands to be given near the unit, otherwise given next to opponent

--*** flees(defaults to empty): the table of units that this unit will flee like the coward it is!!!
-- fleeCombat (defaults to false): if true will flee everything without catergory UNARMED
-- fleeLeeway (defaults to 100): adds to enemy range when fleeing
-- fleeDistance (defaults to 100): unit will flee to enemy range + fleeDistance away from enemy
-- fleeRadar (defaults to false): does the unit flee radar dots?
-- minFleeRange (defaults to 0): minumun range at which the unit will flee, will flee at higher range if the attacking unit outranges it
-- fleeOrderDis (defaults to 120): max distance the move order is from the unit when fleeing


--- Array loaded into gadget 
local behaviourDefaults = {
	defaultState = 1,
	defaultJinkTangentLength = 80,
	defaultJinkParallelLength = 200,
	defaultStrafeOrderLength = 100,
	defaultMinCircleStrafeDistance = 40,
    defaultLocalJinkOrder = true,
	defaultSkirmOrderDis = 120,
	defaultVelocityPrediction = 30,
}

local behaviourConfig = { 
	-- swarmers
	["armtick"] = {
		skirms = {}, 
		swarms = lowRangeSwarmieeArray, 
		flees = {},
		circleStrafe = true, 
		maxSwarmLeeway = 40, 
		jinkTangentLength = 100, 
		minCircleStrafeDistance = 0,
		minSwarmLeeway = 100,
		swarmLeeway = 30,
		alwaysJinkFight = true,		
	},
	
	["corroach"] = {
		skirms = {}, 
		swarms = lowRangeSwarmieeArray, 
		flees = {},
		circleStrafe = true, 
		maxSwarmLeeway = 40, 
		jinkTangentLength = 100, 
		minCircleStrafeDistance = 0,
		minSwarmLeeway = 100,
		swarmLeeway = 30, 
		alwaysJinkFight = true,	
	},
	
	["puppy"] = {
		skirms = {}, 
		swarms = lowRangeSwarmieeArray, 
		flees = {},
		circleStrafe = true, 
		maxSwarmLeeway = 40, 
		jinkTangentLength = 100, 
		minCircleStrafeDistance = 0,
		minSwarmLeeway = 100,
		swarmLeeway = 30, 
		alwaysJinkFight = true,	
	},
  
	["armpw"] = {
		skirms = veryShortRangeSkirmieeArray, 
		swarms = lowRangeSwarmieeArray, 
		flees = {},
		circleStrafe = true, 
		maxSwarmLeeway = 35, 
		swarmLeeway = 50, 
		jinkTangentLength = 140, 
		stoppingDistance = 10,
		velocityPrediction = 20,
	},
	
	["armflea"] = {
		skirms = veryShortRangeSkirmieeArray, 
		swarms = lowRangeSwarmieeArray, 
		flees = fleeables,
		circleStrafe = true, 
		maxSwarmLeeway = 5, 
		swarmLeeway = 30, 
		stoppingDistance = 0,
		strafeOrderLength = 100,
		minCircleStrafeDistance = 20,
		fleeLeeway = 150,
		fleeDistance = 150,
	},
	["corfav"] = { -- weasel
		skirms = veryShortRangeSkirmieeArray, 
		swarms = lowRangeSwarmieeArray, 
		flees = fleeables,
		circleStrafe = true, 
		strafeOrderLength = 180,
		maxSwarmLeeway = 40, 
		swarmLeeway = 40, 
		stoppingDistance = 15,
		minCircleStrafeDistance = 50,
		fleeLeeway = 100,
		fleeDistance = 150,
	},
  
	-- longer ranged swarmers
	["corak"] = {
		skirms = shortRangeSkirmieeArray, 
		swarms = lowRangeSwarmieeArray, 
		flees = {},
		circleStrafe = true, 
		maxSwarmLeeway = 35, 
		swarmLeeway = 30, 
		jinkTangentLength = 140, 
		stoppingDistance = 25,
		minCircleStrafeDistance = 10,
		velocityPrediction = 20,
	},
	["corgator"] = {
		skirms = shortRangeSkirmieeArray, 
		swarms = lowRangeSwarmieeArray, 
		flees = {},
		circleStrafe = true, 
		strafeOrderLength = 120,
		skirmLeeway = 60,
		maxSwarmLeeway =180, 
		minSwarmLeeway = 300, 
		swarmLeeway = 40, 
		stoppingDistance = 8,
		skirmOrderDis = 150,
	},
	
	["corsh"] = {
		skirms = shortRangeSkirmieeArray, 
		swarms = lowRangeSwarmieeArray, 
		flees = {},
		circleStrafe = true, 
		strafeOrderLength = 180,
		maxSwarmLeeway = 40, 
		swarmLeeway = 40, 
		stoppingDistance = 8,
		skirmOrderDis = 150,
	},
  
	["corpyro"] = {
		skirms = shortRangeSkirmieeArray, 
		swarms = lowRangeSwarmieeArray, 
		flees = {},
		circleStrafe = true, 
		maxSwarmLeeway = 100, 
		minSwarmLeeway = 200, 
		swarmLeeway = 30, 
		stoppingDistance = 8
	},
	
	["logkoda"] = {
		skirms = shortRangeSkirmieeArray, 
		swarms = lowRangeSwarmieeArray, 
		flees = {},
		circleStrafe = true, 
		maxSwarmLeeway = 40, 
		swarmLeeway = 30, 
		stoppingDistance = 8,
		skirmOrderDis = 150,
	},
  
	["panther"] = {
		skirms = shortRangeSkirmieeArray, 
		swarms = lowRangeSwarmieeArray, 
		flees = {},
		circleStrafe = true, 
		strafeOrderLength = 180,
		maxSwarmLeeway = 40, 
		swarmLeeway = 50, 
		stoppingDistance = 15,
		skirmOrderDis = 150,
	},

	["shipscout"] = { -- scout boat
		skirms = shortRangeSkirmieeArray, 
		swarms = lowRangeSwarmieeArray, 
		flees = {},
		circleStrafe = true, 
		maxSwarmLeeway = 40, 
		swarmLeeway = 30, 
		stoppingDistance = 8
	},
	["amphraider2"] = {
		skirms = riotRangeSkirmieeArray, 
		swarms = lowRangeSwarmieeArray, 
		flees = {},
		circleStrafe = true,
		maxSwarmLeeway = 40,
		skirmLeeway = 30, 
		minCircleStrafeDistance = 10,
	},
	
	-- riots
	["armwar"] = {
		skirms = riotRangeSkirmieeArray, 
		swarms = {}, 
		flees = {},
		maxSwarmLeeway = 0, 
		skirmLeeway = 0, 
	},
	["spiderriot"] = {
		skirms = lowMedRangeSkirmieeArray, 
		swarms = {}, 
		flees = {},
		maxSwarmLeeway = 0, 
		skirmLeeway = 0, 
	},
	["arm_venom"] = {
		skirms = riotRangeSkirmieeArray, 
		swarms = lowRangeSwarmieeArray, 
		flees = {},
		circleStrafe = true,
		maxSwarmLeeway = 40,
		skirmLeeway = 30, 
		minCircleStrafeDistance = 10,
	},
	["cormak"] = {
		skirms = riotRangeSkirmieeArray, 
		swarms = {}, 
		flees = {},
		maxSwarmLeeway = 0, 
		skirmLeeway = 50, 
	},
	["corlevlr"] = {
		skirms = lowMedRangeSkirmieeArray, 
		swarms = {}, 
		flees = {},
		maxSwarmLeeway = 0, 
		skirmLeeway = -30, 
		stoppingDistance = 5
	},
    ["shieldfelon"] = {
		skirms = lowMedRangeSkirmieeArray, 
		swarms = lowRangeSwarmieeArray, 
		flees = {},
		maxSwarmLeeway = 0, 
		skirmLeeway = -30, 
		stoppingDistance = 5
	},
	["hoverriot"] = {
		skirms = lowMedRangeSkirmieeArray, 
		swarms = lowRangeSwarmieeArray, 
		flees = {},
		maxSwarmLeeway = 0, 
		skirmLeeway = -30, 
		stoppingDistance = 5
	},
	["tawf114"] = {
		skirms = lowMedRangeSkirmieeArray, 
		swarms = {}, 
		flees = {},
		maxSwarmLeeway = 0, 
		skirmLeeway = -30, 
		stoppingDistance = 10
	},
	["amphriot"] = {
		skirms = riotRangeSkirmieeArray, 
		swarms = {}, 
		flees = {},
		circleStrafe = true,
		maxSwarmLeeway = 40,
		skirmLeeway = 30, 
		minCircleStrafeDistance = 10,
	},
		
	--assaults
	["armzeus"] = {
		skirms = lowMedRangeSkirmieeArray, 
		swarms = medRangeSwarmieeArray, 
		flees = {},
		maxSwarmLeeway = 30, 
		minSwarmLeeway = 90, 
		skirmLeeway = 20, 
	},
	["corthud"] = {
		skirms = riotRangeSkirmieeArray, 
		swarms = medRangeSwarmieeArray, 
		flees = {},
		maxSwarmLeeway = 50, 
		minSwarmLeeway = 120, 
		skirmLeeway = 40, 
	},
	["spiderassault"] = {
		skirms = lowMedRangeSkirmieeArray, 
		swarms = medRangeSwarmieeArray, 
		flees = {},
		maxSwarmLeeway = 50, 
		minSwarmLeeway = 120, 
		skirmLeeway = 40, 
	},
	["dante"] = {
		skirms = lowMedRangeSkirmieeArray, 
		swarms = {}, 
		flees = {},
		skirmLeeway = 40, 
	},	
	["shipraider"] = {
		skirms = riotRangeSkirmieeArray, 
		swarms = lowRangeSwarmieeArray, 
		flees = {},
		maxSwarmLeeway = 30, 
		minSwarmLeeway = 90, 
		skirmLeeway = 60, 
	},		
	
	-- med range skirms
	["armrock"] = {
		skirms = medRangeSkirmieeArray, 
		swarms = medRangeSwarmieeArray, 
		flees = {},
		maxSwarmLeeway = 30, 
		minSwarmLeeway = 130, 
		skirmLeeway = 10, 
	},
	["amphfloater"] = {
		skirms = medRangeSkirmieeArray, 
		swarms = medRangeSwarmieeArray, 
		flees = {},
		maxSwarmLeeway = 30, 
		minSwarmLeeway = 130, 
		skirmLeeway = 10, 
	},
	["nsaclash"] = {
		skirms = medRangeSkirmieeArray, 
		swarms = medRangeSwarmieeArray, 
		flees = {},
		maxSwarmLeeway = 30, 
		minSwarmLeeway = 130, 
		skirmLeeway = 30,
		skirmOrderDis = 200,
		velocityPrediction = 90,
	},
	["shiptorp"] = {
		skirms = medRangeSkirmieeArray, 
		swarms = medRangeSwarmieeArray, 
		flees = {},
		maxSwarmLeeway = 30, 
		minSwarmLeeway = 130, 
		skirmLeeway = 30, 
	},	
	
	-- long range skirms
	["jumpblackhole"] = {
		skirms = longRangeSkirmieeArray, 
		swarms = longRangeSwarmieeArray, 
		flees = {},
		maxSwarmLeeway = 30, 
		minSwarmLeeway = 130, 
		skirmLeeway = 10, 
	},
	["corstorm"] = {
		skirms = longRangeSkirmieeArray, 
		swarms = longRangeSwarmieeArray, 
		flees = {},
		maxSwarmLeeway = 30, 
		minSwarmLeeway = 130, 
		skirmLeeway = 10, 
	},
	["armsptk"] = {
		skirms = longRangeSkirmieeArray, 
		swarms = longRangeSwarmieeArray, 
		flees = {},
		maxSwarmLeeway = 10, 
		minSwarmLeeway = 130, 
		skirmLeeway = 10, 
	},
	["corcrw"] = {
		skirms = longRangeSkirmieeArray, 
		swarms = {}, 
		flees = {},
		maxSwarmLeeway = 10, 
		minSwarmLeeway = 130, 
		skirmLeeway = 20, 
	},
	["slowmort"] = {
		skirms = longRangeSkirmieeArray, 
		swarms = longRangeSwarmieeArray, 
		flees = {},
		maxSwarmLeeway = 10, 
		minSwarmLeeway = 130, 
		skirmLeeway = 10, 
	},
	["capturecar"] = {
		skirms = longRangeSkirmieeArray, 
		swarms = longRangeSwarmieeArray, 
		flees = {},
		maxSwarmLeeway = 30, 
		minSwarmLeeway = 130, 
		skirmLeeway = 30,
		skirmOrderDis = 200,
		velocityPrediction = 60,
	},
	
	-- arty range skirms
	["armbanth"] = {
		skirms = artyRangeSkirmieeArray,
		swarms = {}, 
		flees = {},
		skirmLeeway = 60, 
	},	
	
	["armsnipe"] = {
		skirms = artyRangeSkirmieeArray, 
		swarms = {}, 
		flees = {},
		maxSwarmLeeway = 10,
		minSwarmLeeway = 130, 
		skirmLeeway = 10, 
	},
	
	["corgarp"] = {
		skirms = artyRangeSkirmieeArray, 
		swarms = {}, 
		flees = {},
		maxSwarmLeeway = 10, 
		minSwarmLeeway = 130, 
		skirmLeeway = 10, 
	},
	["armham"] = {
		skirms = artyRangeSkirmieeArray, 
		swarms = {}, 
		flees = {},
		skirmRadar = true,
		maxSwarmLeeway = 10, 
		minSwarmLeeway = 130, 
		skirmLeeway = 40, 
	},
	["shiparty"] = {
		skirms = artyRangeSkirmieeArray, 
		swarms = {}, 
		flees = {},
		skirmRadar = true,
		maxSwarmLeeway = 10, 
		minSwarmLeeway = 130, 
		skirmLeeway = 40, 
	},
	["firewalker"] = {
		skirms = artyRangeSkirmieeArray, 
		swarms = {}, 
		flees = {},
		skirmRadar = true,
		maxSwarmLeeway = 10, 
		minSwarmLeeway = 130, 
		skirmLeeway = 40, 
	},	
	["shieldarty"] = {
		skirms = artyRangeSkirmieeArray, 
		swarms = {}, 
		flees = {},
		skirmRadar = true,
		maxSwarmLeeway = 10, 
		minSwarmLeeway = 130, 
		skirmLeeway = 40, 
	},	
	["armmanni"] = {
		skirms = artyRangeSkirmieeArray, 
		swarms = {}, 
		flees = {},
		skirmRadar = true,
		maxSwarmLeeway = 10, 
		minSwarmLeeway = 130, 
		skirmLeeway = 40, 
	},	
	-- cowardly support units
	--[[
	["example"] = {
		skirms = {}, 
		swarms = {}, 
		flees = {},
		fleeCombat = true,
		fleeLeeway = 100,
		fleeDistance = 100,
		minFleeRange = 500,
	},
	--]]

	-- support
	["spherecloaker"] = {
		skirms = {}, 
		swarms = {}, 
		flees = armedLand,
		fleeLeeway = 100,
		fleeDistance = 100,
		minFleeRange = 400,
	},
	
	["core_spectre"] = {
		skirms = {}, 
		swarms = {}, 
		flees = armedLand,
		fleeLeeway = 100,
		fleeDistance = 100,
		minFleeRange = 450,
	},
	
	-- mobile AA
	["armjeth"] = {
		skirms = skirmableAir, 
		swarms = {}, 
		flees = armedLand,
		fleeLeeway = 100,
		fleeDistance = 100,
		minFleeRange = 500,
        skirmLeeway = 50, 
	},
	["corcrash"] = {
		skirms = skirmableAir, 
		swarms = {}, 
		flees = armedLand,
		fleeLeeway = 100,
		fleeDistance = 100,
		minFleeRange = 500,
        skirmLeeway = 50, 
	},
	["armaak"] = {
		skirms = skirmableAir, 
		swarms = {}, 
		flees = armedLand,
		fleeLeeway = 100,
		fleeDistance = 100,
		minFleeRange = 500,
        skirmLeeway = 50, 
	},
	["hoveraa"] = {
		skirms = skirmableAir, 
		swarms = {}, 
		flees = armedLand,
		fleeLeeway = 100,
		fleeDistance = 100,
		minFleeRange = 500,
        skirmLeeway = 50,
		skirmOrderDis = 200,
	},
	["spideraa"] = {
		skirms = skirmableAir, 
		swarms = {}, 
		flees = armedLand,
		fleeLeeway = 100,
		fleeDistance = 100,
		minFleeRange = 500,
        skirmLeeway = 50, 
	},
	["corsent"] = {
		skirms = skirmableAir, 
		swarms = {}, 
		flees = armedLand,
		fleeLeeway = 100,
		fleeDistance = 100,
		minFleeRange = 500,
        skirmLeeway = 50,
		skirmOrderDis = 200, 
	},
	["amphaa"] = {
		skirms = skirmableAir, 
		swarms = {}, 
		flees = armedLand,
		fleeLeeway = 100,
		fleeDistance = 100,
		minFleeRange = 500,
        skirmLeeway = 50,
		skirmOrderDis = 200, 
	},
	["shipaa"] = {
		skirms = skirmableAir, 
		swarms = {}, 
		flees = armedLand,
		fleeLeeway = 100,
		fleeDistance = 100,
		minFleeRange = 500,
        skirmLeeway = 50,
		skirmOrderDis = 200, 
	},
}

return behaviourConfig, behaviourDefaults

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
