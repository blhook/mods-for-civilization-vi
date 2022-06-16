--- Author: Brandon Hook
---
--- Copyright (c) 2022 Brandon Hook. All rights reserved.
--- This work is licensed under the terms of the MIT license.  
--- For a copy, see <https://opensource.org/licenses/MIT>.
--------------------------------------------------------------

Zug_RefundResources =
{
	RefundRates = {
		--0 == No Gain; 1 == Full Gain; 0.5 == Half Gain; 2 == Double Gain; 0.25 == 1/4 Gain; -1 == 2 Total Consumed; Etc. 
		FortifyInsideOwned = 1;
		FortifyOutsideOwned = 0.5;
		FortifyInsideHostile = 0;

		SleepInsideOwned = 1;
		SleepOutsideOwned = 1;
		SleepInsideHostile = 0.5;

		DefenseRetaliate = 0.5;
		DefenseNonRetaliate = 1;

		--Determines if the refund should always happen, regardless of number of moves left on a unit. Case sensitive "false" or "true" 
		AlwaysActive = false; 
	};
	Version = 3;
}

if (GameConfiguration.ModSettings ~= nil) then
	GameConfiguration.ModSettings.Zug_RefundResources = Zug_RefundResources;
	--print("Mod Settings Loaded");
else
	--print("Mod Settings Not Loaded");
end