-- UNITDEF -- EALLTERRENGINEER --
--------------------------------------------------------------------------------

local unitName                   = "eallterrengineer"

--------------------------------------------------------------------------------

local buildCostMetal 			  = 45
local maxDamage					  = 600

local armortype					 = [[light]]
--local supply					 = [[2]]

local unitDef                    = {

	--mobileunit 
	transportbyenemy             = false;

	--**


	acceleration                 = 1,
	brakeRate                    = 1,
	buildCostEnergy              = 0,
	buildCostMetal               = buildCostMetal,
	buildDistance                = 800,
	builder                      = true,
	buildTime                    = 5,
	CanAttack			         = false,
	CanAssist			         = true,
	canBeAssisted                = true,
	CanCapture                   = false,
	CanRepair			         = true,
	cancollect                   = "1",
	canGuard                     = true,
	canMove                      = true,
	canPatrol                    = true,
	canreclaim		             = false,
	canstop                      = true,
	category                     = "LIGHT NOTAIR SUPPORT",
	corpse                       = "ammobox",

	-- Cloaking

	cancloak		             = true,
	cloakCost		             = 0,
	cloakCostMoving	             = 1,
	minCloakDistance             = 70,
	decloakOnFire	             = true,
	decloakSpherical             = true,
	initCloaked		             = false,
	
	-- End Cloaking

	description                  = [[Builds Units]],
	energyMake                   = 0,
	energyStorage                = 0,
	energyUse                    = 0,
	explodeAs                    = "mediumExplosionGenericGreen",
	footprintX                   = 3,
	footprintZ                   = 3,
	iconType                     = "engineer",
	idleAutoHeal                 = .5,
	idleTime                     = 2200,
	levelground                  = true,
	maxDamage                    = maxDamage,
	maxSlope                     = 180,
	maxVelocity                  = 3,
	maxReverseVelocity           = 1,
	turninplacespeedlimit        = 3,
	maxWaterDepth                = 10,
	metalmake                    = 0,
	metalStorage                 = 0,
	mobilestandorders            = "1",
	movementClass                = "ALLTERRTANK3",
	moveState			         = "2",
	name                         = "The Architect",
	objectName                   = "eallterrengineer.s3o",
	radarDistance                = 0,
	repairable		             = false,
	selfDestructAs               = "mediumExplosionGenericGreen",
	showNanoSpray                = true,
	sightDistance                = 500,
	smoothAnim                   = true,
	stealth			             = true,
	seismicSignature             = 2,
	turnInPlace                  = true,
	turnRate                     = 5000,
	unitname                     = "eallterrengineer",
	unitnumber                   = "20",
	workerTime                   = 1,
	capturespeed                 = 1,
	TerraformSpeed               = 100000,
	ReclaimSpeed                 = 0,
	repairspeed                  = 0.15625,
	sfxtypes                     = { 
		pieceExplosionGenerators = { 
			"deathceg3", 
			"deathceg4", 
		}, 

		explosiongenerators      = {
			"custom:nanoorb",
			"custom:dirtsmall",
			"custom:blacksmoke",
		},
	},
	buildoptions                 = {
		[[ehbotfac]],
		[[eminifac]],
		[[ebasefactory]],
		[[eamphibfac]],
		[[eairplant]],
		[[etech1]],
		[[esolar2]],
		[[egeothermal]],
		[[efusion2]],
		[[estorage]],
		[[eradar2]],
		[[ejammer2]],
		[[ekmar]],
		[[elightturret2]],
		[[eheavyturret2]],
		[[eartyturret]],
		[[euwturret]],
		[[eshieldgen]],
		[[esilo]],
		[[emine]],
		[[eorb]],
	},
	sounds                       = {
		underattack              = "unitsunderattack1",
		ok                       = {
			"ack",
		},
		select                   = {
			"unitselect",
		},
	},
	customParams                 = {
		canbetransported 		 = "true",
		needed_cover             = 1,
		death_sounds             = "generic",
		dronespawner             = "1",
		armortype                = armortype,
--		supply_cost              = supply,
		normaltex               = "unittextures/con_legonormal.png", 
	},
}

--------------------------------------------------------------------------------

return lowerkeys({ [unitName]    = unitDef })

--------------------------------------------------------------------------------
