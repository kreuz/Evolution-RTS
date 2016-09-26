return {
	chickenr3 = {
		acceleration = 1,
		bmcode = "1",
		brakerate = 8,
		buildcostenergy = 12320,
		buildcostmetal = 396,
		builder = false,
		buildtime = 180000,
		canattack = true,
		canguard = true,
		canmove = true,
		canpatrol = true,
		canstop = "1",
		category = "BIO",
		collisionvolumeoffsets = "0 -1 0",
		collisionvolumescales = "84 215 84",
		collisionvolumetest = 1,
		collisionvolumetype = "CylY",
		corpse = "chicken_egg",
		defaultmissiontype = "Standby",
		description = "Meteor Launcher",
		explodeas = "LOBBER_MORPH",
		footprintx = 4,
		footprintz = 4,
		hidedamage = 1,
		hightrajectory = 1,
		icontype = "chickenr",
		idleautoheal = 20,
		idletime = 300,
		leavetracks = true,
		maneuverleashlength = "640",
		mass = 40000,
		maxdamage = 90000,
		maxslope = 18,
		maxvelocity = 2,
		maxwaterdepth = 15,
		movementclass = "CHICKQUEEN",
		name = "Chicken Colonizer",
		noautofire = false,
		nochasecategory = "VTOL",
		objectname = "ChickenDefenseModels/chicken_colonizer.s3o",
		script = "ChickenDefenseScripts/chickenr3.cob",
		seismicsignature = 4,
		selfdestructas = "LOBBER_MORPH",
		side = "THUNDERBIRDS",
		sightdistance = 1250,
		smoothanim = true,
		steeringmode = "2",
		tedclass = "KBOT",
		trackoffset = 6,
		trackstrength = 8,
		trackstretch = 1,
		tracktype = "ChickenTrack",
		trackwidth = 70,
		turninplace = true,
		turnrate = 5000,
		unitname = "chickenr3",
		upright = false,
		workertime = 0,
		featuredefs = {
			dead = {},
			heap = {},
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:blood_spray",
				[2] = "custom:blood_explode",
				[3] = "custom:dirt",
			},
		},
		weapondefs = {
			meteorlauncher = {
				areaofeffect = 750,
				avoidfriendly = 0,
				cegtag = "ASTEROIDTRAIL_Expl",
				collidefriendly = 0,
				craterboost = 0,
				cratermult = 0,
				edgeeffectiveness = 0,
				explosiongenerator = "custom:COMM_EXPLOSION",
				firestarter = 70,
				hightrajectory = 1,
				model = "ChickenDefenseModels/greyrock2.s3o",
				name = "METEORLAUNCHER",
				proximitypriority = -6,
				range = 18000,
				reloadtime = 15,
				soundhit = "ChickenDefenseSounds/nuke4",
				targetable = 1,
				turret = 1,
				weaponvelocity = 1500,
				damage = {
					default = 2900,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "MOBILE",
				def = "METEORLAUNCHER",
				maindir = "0 0 1",
				onlytargetcategory = "NOTAIR LIGHT ARMORED BUILDING",
			},
		},
	},
}