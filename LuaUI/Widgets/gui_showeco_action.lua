function widget:GetInfo()
  return {
    name      = "Showeco and Grid Drawer",
    desc      = "Register an action called Showeco & draw overdrive overlay.", --"acts like F4",
    author    = "xponen",
    date      = "July 19 2013",
    license   = "GNU GPL, v2 or later",
    layer     = -100002, --start before gui_epicmenu.lua before zk_keys.lua is read
    enabled   = true,  --  loaded by default?
	alwaysStart    = true,
    handler   = true,
  }
end

local pylon ={}
--------------------------------------------------------------------------------------
--Action registration. Copied fully from gui_epicmenu.lua (widget by CarRepairer)
local function AddAction(cmd, func, data, types)
	return widgetHandler.actionHandler:AddAction(widget, cmd, func, data, types)
end

local function RemoveAction(cmd, types)
	return widgetHandler.actionHandler:RemoveAction(widget, cmd, types)
end

local function ToggleShoweco()
	WG.showeco = not WG.showeco
end

function widget:Shutdown()
	AddAction("showeco")
end

local function RegisterShoweco()
	WG.showeco = false
	AddAction("showeco", ToggleShoweco, nil, "t")
end

function PylonOut(pylonString)
	local chunk, err = loadstring("return"..pylonString) --This code is from cawidgets.lua
	pylon = chunk and chunk() or {}
end
--------------------------------------------------------------------------------------
--Grid drawing. Copied and trimmed from unit_mex_overdrive.lua gadget (by licho & googlefrog)
local spGetSelectedUnits = Spring.GetSelectedUnits
local spGetUnitDefID     = Spring.GetUnitDefID
local spGetUnitPosition  = Spring.GetUnitPosition
local spGetActiveCommand = Spring.GetActiveCommand
local spTraceScreenRay   = Spring.TraceScreenRay
local spGetMouseState    = Spring.GetMouseState

local glVertex        = gl.Vertex
local glCallList      = gl.CallList
local glColor         = gl.Color
local glBeginEnd      = gl.BeginEnd
local glCreateList    = gl.CreateList

local GL_TRIANGLE_FAN = GL.TRIANGLE_FAN

local Util_DrawGroundCircle = gl.Utilities.DrawGroundCircle

local pylonDefs = {}

VFS.Include("LuaRules/Configs/constants.lua", nil, VFS.ZIP_FIRST)
VFS.Include("LuaRules/Configs/mex_overdrive.lua", nil, VFS.ZIP_FIRST)

for i=1,#UnitDefs do
	local udef = UnitDefs[i]
	if (tonumber(udef.customParams.pylonrange) or 0 > 0) then
		pylonDefs[i] = {
			range = tonumber(udef.customParams.pylonrange) or DEFAULT_PYLON_RANGE,
			extractor = (udef.customParams.ismex and true or false),
			neededLink = tonumber(udef.customParams.neededlink) or false,
			keeptooltip = udef.customParams.keeptooltip or false,
		}
	end
		
end

local floor = math.floor

local circlePolys = 0 -- list for circles

function widget:Initialize()
	RegisterShoweco()
	
	widgetHandler:RegisterGlobal(widget,"PylonOut", PylonOut)
	local circleDivs = 32
	circlePolys = glCreateList(function()
		glBeginEnd(GL_TRIANGLE_FAN, function()
		local radstep = (2.0 * math.pi) / circleDivs
			for i = 1, circleDivs do
				local a = (i * radstep)
				glVertex(math.sin(a), 0, math.cos(a))
			end
		end)
	end)
end

local disabledColor = { 0.6,0.7,0.5,0.2}

local colors = {
	{0.9,0.9,0.2,0.2},
	{0.9,0.2,0.2,0.2},
	{0.2,0.9,0.2,0.2},
	{0.2,0.2,0.9,0.2},
	{0.2,0.9,0.9,0.2},
	{0.9,0.2,0.9,0.2},
}

local function HighlightPylons(selectedUnitDefID)
	pylon = pylon or {}

	for id, data in pairs(pylon) do
		if pylonDefs[spGetUnitDefID(id)] then
			local radius = pylonDefs[spGetUnitDefID(id)].range
			if (radius) then 
				local color
				if (not data.gridID) or data.gridID == 0 or data.color == nil then
					color = disabledColor
				else 
					color = data.color
				end 
				glColor(color[1],color[2], color[3], color[4])

				local x,y,z = spGetUnitPosition(id)
				Util_DrawGroundCircle(x,z, radius)
			end 
		end
	end 
	
	if selectedUnitDefID then 
		local mx, my = spGetMouseState()
		local _, coords = spTraceScreenRay(mx, my, true, true)
		if coords then 
			local radius = pylonDefs[selectedUnitDefID].range
			if (radius == 0) then
			else
				local x = floor((coords[1])/16)*16 +8
				local z = floor((coords[3])/16)*16 +8
				glColor(disabledColor)
				Util_DrawGroundCircle(x,z, radius)
			end
		end 
	end 
end 


function widget:DrawWorldPreUnit()
	if Spring.IsGUIHidden() then return end
	
	local _, cmd_id = spGetActiveCommand()  -- show pylons if pylon is about to be placed
	if (cmd_id) then 
		if pylonDefs[-cmd_id] then 
			HighlightPylons(-cmd_id)
			glColor(1,1,1,1)
			return
		end 
		return 
	end
	
	local showecoMode = WG.showeco
	if showecoMode then
		HighlightPylons(nil)
		glColor(1,1,1,1)
		return
	end

	local selUnits = spGetSelectedUnits()  -- or show it if its selected 	
	if not selUnits then 
		return
	end 
	for i=1,#selUnits do 
		local ud = spGetUnitDefID(selUnits[i])
		if (pylonDefs[ud]) then 
			HighlightPylons(nil)
			glColor(1,1,1,1)
			return 
		end 
	end
end