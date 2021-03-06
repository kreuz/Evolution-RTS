--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    gui_build_eta.lua
--  brief:   display estimated time of arrival for builds
--  author:  Dave Rodgers
--
--  Copyright (C) 2007.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "BuildETA",
    desc      = "Displays estimated time of arrival for builds",
    author    = "trepan",
    date      = "Feb 04, 2007",
    license   = "GNU GPL, v2 or later",
    layer     = -1,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local gl = gl  --  use a local copy for faster access

local etaTable = {}


--------------------------------------------------------------------------------

local vsx, vsy = widgetHandler:GetViewSizes()

function widget:ViewResize(viewSizeX, viewSizeY)
  vsx = viewSizeX
  vsy = viewSizeY
end


--------------------------------------------------------------------------------

local function MakeETA(unitID,unitDefID)
  if (unitDefID == nil) then return nil end
  local _,_,_,_,buildProgress = Spring.GetUnitHealth(unitID)
  if (buildProgress == nil) then return nil end

  local ud = UnitDefs[unitDefID]
  if (ud == nil)or(ud.height == nil) then return nil end

  return {
    firstSet = true,
    lastTime = Spring.GetGameSeconds(),
    lastProg = buildProgress,
    rate     = nil,
    timeLeft = nil,
    yoffset  = ud.height + 14 --dims.height - (dims.midy - dims.miny) + 5
  }
end


--------------------------------------------------------------------------------

function widget:Initialize()
  if (UnitDefs[1].height == nil) then
    for udid, ud in ipairs(UnitDefs) do
      ud.height = Spring.GetUnitDefDimensions(udid).radius
    end
  end

  local myUnits = Spring.GetTeamUnits(Spring.GetMyTeamID())
  for _,unitID in ipairs(myUnits) do
    local _,_,_,_,buildProgress = Spring.GetUnitHealth(unitID)
    if (buildProgress < 1) then
      etaTable[unitID] = MakeETA(unitID,Spring.GetUnitDefID(unitID))
    end
  end
end


--------------------------------------------------------------------------------

local lastGameUpdate = Spring.GetGameSeconds()

function widget:Update(dt)

  local userSpeed,_,pause = Spring.GetGameSpeed()
  if (pause) then
    return
  end

  local gs = Spring.GetGameSeconds()
  if (gs == lastGameUpdate) then
    return
  end
  lastGameUpdate = gs
  
  local killTable = {}
  for unitID,bi in pairs(etaTable) do
    local _,_,_,_,buildProgress = Spring.GetUnitHealth(unitID)
    if ((not buildProgress) or (buildProgress >= 1.0)) then
      table.insert(killTable, unitID)
    else
      local dp = buildProgress - bi.lastProg 
      local dt = gs - bi.lastTime
      if (dt > 2) then
        bi.firstSet = true
        bi.rate = nil
        bi.timeLeft = nil
      end

      local rate = (dp / dt) * userSpeed

      if (rate ~= 0) then
        if (bi.firstSet) then
          if (buildProgress > 0.001) then
            bi.firstSet = false
          end
        else
          local rf = 0.5
          if (bi.rate == nil) then
            bi.rate = rate
          else
            bi.rate = ((1 - rf) * bi.rate) + (rf * rate)
          end

          local tf = 0.1
          if (rate > 0) then
            local newTime = (1 - buildProgress) / rate
            if (bi.timeLeft and (bi.timeLeft > 0)) then
              bi.timeLeft = ((1 - tf) * bi.timeLeft) + (tf * newTime)
            else
              bi.timeLeft = (1 - buildProgress) / rate
            end
          elseif (rate < 0) then
            local newTime = buildProgress / rate
            if (bi.timeLeft and (bi.timeLeft < 0)) then
              bi.timeLeft = ((1 - tf) * bi.timeLeft) + (tf * newTime)
            else
              bi.timeLeft = buildProgress / rate
            end
          end
        end
        bi.lastTime = gs
        bi.lastProg = buildProgress
      end
    end
  end
  for _,unitID in ipairs(killTable) do
    etaTable[unitID] = nil
  end
end


--------------------------------------------------------------------------------

function widget:UnitCreated(unitID, unitDefID, unitTeam)
  if (unitTeam == Spring.GetMyTeamID()) then
    etaTable[unitID] = MakeETA(unitID,unitDefID)
  end
end


function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
  etaTable[unitID] = nil
end


function widgetHandler:UnitTaken(unitID, unitDefID, unitTeam, newTeam)
  etaTable[unitID] = nil
end


function widget:UnitFinished(unitID, unitDefID, unitTeam)
  etaTable[unitID] = nil
end


--------------------------------------------------------------------------------

function widget:DrawWorld()
if not Spring.IsGUIHidden() then 
  gl.DepthTest(true)

  gl.Color(1, 1, 1)
  --fontHandler.UseDefaultFont()

  for unitID, bi in pairs(etaTable) do
    gl.DrawFuncAtUnit(unitID, true, function(timeLeft,yoffset)
      local etaStr
      if (timeLeft == nil) then
        etaStr = '\255\1\1\255???'
      else
        if (timeLeft > 0) then
          etaStr = string.format('\255\1\255\1%.1f', timeLeft)
        else
          etaStr = string.format('\255\255\1\1%.1f', -timeLeft)
        end
      end
      etaStr = "\255\255\255\1ETA\255\255\255\255:" .. etaStr

      gl.Translate(0, yoffset,0)
      gl.Billboard()
      gl.Translate(0, 5 ,0)
      --fontHandler.DrawCentered(etaStr)
      gl.Text(etaStr, 0, 0, 8, "c")
    end, bi.timeLeft,bi.yoffset)
  end

  gl.DepthTest(false)
end
end
  

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
