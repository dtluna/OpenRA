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

NodBase = { NodConYard }

ConYardDiscovered = function (_, discoverer)
	if not Nod.IsObjectiveCompleted(FindBase) and discoverer == Nod then
		Nod.MarkCompletedObjective(FindBase)

		Utils.Do(NodBase, function (actor)
			if not actor.IsDead then
				actor.Owner = Nod
			end
		end)

		Trigger.AfterDelay(DateTime.Seconds(1), function()
			Media.PlaySpeechNotification(Nod, "NewOptions")
		end)
	end
end

TechCenterCaptured = function(_, _, _, newOwner)
	if not Nod.IsObjectiveCompleted(CaptureTechCenter) and newOwner == Nod then
		Nod.MarkCompletedObjective(CaptureTechCenter)

		Trigger.AfterDelay(DateTime.Seconds(1), function()
			Media.PlaySpeechNotification(Nod, "NewOptions")
		end)
	end
end


CheckForSams = function()
	local sams = Nod.GetActorsByType("sam")
	return #sams >= 3
end

WorldLoaded = function()
	Nod = Player.GetPlayer("Nod")
	GDI = Player.GetPlayer("GDI")

	GDI.Cash = 10000

	Camera.Position = DefaultCameraPosition.CenterPosition

	InitObjectives(Nod)

	GDIObjective = GDI.AddPrimaryObjective("Eliminate all Nod forces in the area.")

	FindBase = Nod.AddPrimaryObjective("Find the Nod base.")
	CaptureTechCenter = Nod.AddSecondaryObjective("Capture the Tech Center.")
	BuildSAMs = Nod.AddSecondaryObjective("Build 3 SAMs to fend off the GDI bombers.")
	EliminateGDI = Nod.AddPrimaryObjective("Eliminate all GDI forces in the area.")

	Actor.Create(Rambo, true, { Owner = Nod, Location = RamboLocation.Location })

	Trigger.OnDiscovered(NodConYard, ConYardDiscovered)
	Trigger.OnCapture(TechCenter, TechCenterCaptured)
end

Tick = function()
	if DateTime.GameTime > 2 and Nod.HasNoRequiredUnits() then
		GDI.MarkCompletedObjective(GDIObjective)
	end

	if DateTime.GameTime > 2 and GDI.HasNoRequiredUnits() then
		Nod.MarkCompletedObjective(EliminateGDI)
	end

	if not Nod.IsObjectiveCompleted(BuildSAMs) and CheckForSams() then
		Nod.MarkCompletedObjective(BuildSAMs)
	end
end
