--- Author: Brandon Hook
---
--- Copyright (c) 2022 Brandon Hook. All rights reserved.
--- This work is licensed under the terms of the MIT license.  
--- For a copy, see <https://opensource.org/licenses/MIT>.
--------------------------------------------------------------

--Globals
Query = DB.Query ("SELECT [Units_XP2].[UnitType], [Units_XP2].[ResourceMaintenanceAmount], [Units_XP2].[ResourceMaintenanceType] FROM [Units_XP2] WHERE [Units_XP2].[ResourceMaintenanceAmount] > 0");
Gain = {};
DefenseResults = {};

HeldMaxMultiplier = nil;

function RefundPlayer ()
	--Iterate through all players that are applicable. Cycle through their units where the units has a maintenance. Add the resource back to the player, before cost is deducted out (negating cost).
	local pPlayer
	for _, pPlayer in ipairs (Players) do
		if(pPlayer:IsMajor () and pPlayer:IsAlive ()) then
			local pUnits = pPlayer:GetUnits ();
			local pUnit;
			local playerResources = pPlayer:GetResources ();

			for ii, pUnit in pUnits:Members () do
				--print(GameInfo.Units[pUnit:GetType()].UnitType)
				for _, row in ipairs (Query) do
					if row ~= nil then
						--print (row.UnitType)
						if pUnit ~= nil and row.UnitType == GameInfo.Units[pUnit:GetType ()].UnitType then
							if pUnit:GetMovesRemaining () == pUnit:GetMaxMoves () or (GameConfiguration.ModSettings ~= nil and GameConfiguration.ModSettings.Zug_RefundResources ~= nil and GameConfiguration.ModSettings.Zug_RefundResources.AlwaysActive) then
								--Tactical Mode
								if GameConfiguration.ModSettings ~= nil and GameConfiguration.ModSettings.Zug_RefundResources ~= nil then
									CalculateRefund (pUnit, row);

								--Simple								
								else
									local resourceInfo = GameInfo.Resources[row.ResourceMaintenanceType];
									print("Unit" .. pUnit:GetType ())
									print (resourceInfo)
									if Gain[1] == nil then
										Gain[1] = {}
									end
									local temp = Gain[1];
									print(tmp)
									print("Maintenance Amount" .. row.ResourceMaintenanceAmount)
									temp[resourceInfo.Index] = (temp[resourceInfo.Index] or 0) + row.ResourceMaintenanceAmount;
									print ("Made it")
								end
							end
						end
					end
				end
			end

			for multiplier, table in pairs (Gain) do
				for resourceID, quantity in pairs (table) do
					print ("Gain: " .. "Multiplier: " .. multiplier .. " ID: " .. resourceID .. " Quantity: " .. quantity .. " Refund: " .. math.ceil (quantity * multiplier));
					playerResources:ChangeResourceAmount (resourceID, math.ceil (quantity * multiplier));
				end
			end

			--Reset our globals, so we don't take up more memory, and so the next player has fresh. 
			Gain = {};
			DefenseResults = {};
		end
	end
end

--Assume we know the unit is, at the base of levels, able to get a refund. Also, assume we are in Tactical Mode. 
function CalculateRefund (pUnit, row)
	local resourceInfo = GameInfo.Resources[row.ResourceMaintenanceType];
	local pUnitPlot = Map.GetPlotXYWithRangeCheck (pUnit:GetX (), pUnit:GetY ());

	if(HeldMaxMultiplier == nil) then
		HeldMaxMultiplier = 0;
		for _, i in pairs (GameConfiguration.ModSettings.Zug_RefundResources.RefundRates) do
			if (type (i) == "number") then
				HeldMaxMultiplier = (HeldMaxMultiplier > i) and HeldMaxMultiplier or i;
			end
		end
	end
	local iGainType = HeldMaxMultiplier; --Assume Full until proven not, where we only go down, never up. 

	local iLocationType = 0; --0 == Owned/Ally; 1 == Neutral; 2 == Hostile

	--Get plot infos
	if pUnitPlot:GetOwner () == - 1 then
		iLocationType = 1;
	elseif (pUnitPlot:GetOwner () == pUnit:GetOwner ()) or (Players[pUnitPlot:GetOwner ()]:IsMajor () and Players[pUnit:GetOwner ()]:GetAi_Diplomacy ():GetDiplomaticState (pUnitPlot:GetOwner ()) == "DIPLO_STATE_ALLIED") or (not (Players[pUnitPlot:GetOwner ()]:IsMajor ()) and Players[pUnit:GetOwner ()]:GetAi_Diplomacy ():GetDiplomaticState (pUnitPlot:GetOwner ()) == "DIPLO_STATE_PROTECTOR") then
		iLocationType = 0;
	elseif(string.find (Players[pUnit:GetOwner ()]:GetAi_Diplomacy ():GetDiplomaticState (pUnitPlot:GetOwner ()), ("_WAR"))) then
		iLocationType = 2;
	end

	--print ("LocationType: " .. iLocationType)

	--Fortify
	if UnitManager.GetOperationTypeName (pUnit) == "UNITOPERATION_FORTIFY" or UnitManager.GetOperationTypeName (pUnit) == "UNITOPERATION_HEAL" or pUnit:GetFortifyTurns () > 0 then
		if iLocationType == 0 and iGainType > GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.FortifyInsideOwned then
			iGainType = GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.FortifyInsideOwned
		--print ("1f")
		elseif iLocationType == 1 and iGainType > GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.FortifyOutsideOwned then
			iGainType = GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.FortifyOutsideOwned
		--print ("2f")
		elseif iLocationType == 2 and iGainType > GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.FortifyInsideHostile then
			iGainType = GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.FortifyInsideHostile
		--print ("3f")
		end
	--print ("Gain Type Fortify: " .. iGainType)
	else
		--Sleep/Skip/Etc
		if iLocationType == 0 and iGainType > GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.SleepInsideOwned then
			iGainType = GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.SleepInsideOwned
		--print ("1s")
		elseif iLocationType == 1 and iGainType > GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.SleepOutsideOwned then
			iGainType = GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.SleepOutsideOwned
		--print ("2s")
		elseif iLocationType == 2 and iGainType > GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.SleepInsideHostile then
			iGainType = GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.SleepInsideHostile
		--print ("3s")
		end

	--print ("Gain Type Sleep: " .. iGainType)
	end

	--Defense
	if iGainType > GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.DefenseRetaliate or iGainType > GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.DefenseNonRetaliate then
		--print ("My Unit: " .. pUnit:GetID ())
		for id, retaliate in pairs (DefenseResults) do
			--print ("Defense Unit: " .. id);
			if(id == pUnit:GetID ()) then
				--print ("0d")
				if retaliate and iGainType > GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.DefenseRetaliate then
					iGainType = GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.DefenseRetaliate
				--print ("1d")
				elseif not retaliate and iGainType > GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.DefenseNonRetaliate then
					iGainType = GameConfiguration.ModSettings.Zug_RefundResources.RefundRates.DefenseNonRetaliate
				--print ("2d")
				end
				break;
			end
		end
	--print ("Gain Type Sleep: " .. iGainType)
	end

--Refund Amounts
	if iGainType ~= 0 then
		if Gain[iGainType] == nil then
			Gain[iGainType] = {}
		end
		local temp = Gain[iGainType];
		temp[resourceInfo.Index] = (temp[resourceInfo.Index] or 0) + row.ResourceMaintenanceAmount;
	end
end

function TestCombat (combatResult)
	if GameConfiguration.ModSettings ~= nil and GameConfiguration.ModSettings.Zug_RefundResources ~= nil then
		if(combatResult[CombatResultParameters.DEFENDER] ~= nil) then
			local defender = combatResult[CombatResultParameters.DEFENDER];
			local id = defender[CombatResultParameters.ID];
			if(id.type == ComponentType.UNIT) then
				DefenseResults[id.id] = (DefenseResults[id.id]) or combatResult[CombatResultParameters.DEFENDER_RETALIATES];
			end
		end
	end
end

Events.TurnEnd.Add (RefundPlayer)
Events.Combat.Add (TestCombat)
