--[[
   Copyright 2007-2022 The OpenRA Developers (see AUTHORS)
   This file is part of OpenRA, which is free software. It is made
   available to you under the terms of the GNU General Public License
   as published by the Free Software Foundation, either version 3 of
   the License, or (at your option) any later version. For more
   information, see COPYING.
]]

if Difficulty == "easy" then
	Rambo = "rmbo.easy"
elseif Difficulty == "hard" then
	Rambo = "rmbo.hard"
else
	Rambo = "rmbo"
end


WorldLoaded = function()
	Nod = Player.GetPlayer("Nod")
	GDI = Player.GetPlayer("GDI")

	GDI.Cash = 10000

	Camera.Position = DefaultCameraPosition.CenterPosition

	InitObjectives(Nod)

	GDIObjective = GDI.AddPrimaryObjective("Eliminate all Nod forces in the area.")
	WarFactoryObjective = Nod.AddPrimaryObjective("Destroy or capture the Weapons Factory.")

end

Tick = function()
	if DateTime.GameTime > 2 and Nod.HasNoRequiredUnits() then
		GDI.MarkCompletedObjective(GDIObjective)
	end
end
