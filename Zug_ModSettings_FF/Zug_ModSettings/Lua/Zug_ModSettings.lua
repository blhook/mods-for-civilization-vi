--- Author: Brandon Hook
---
--- Copyright (c) 2022 Brandon Hook. All rights reserved.
--- This work is licensed under the terms of the MIT license.  
--- For a copy, see <https://opensource.org/licenses/MIT>.
--------------------------------------------------------------

include "Zug_ModSettings_Core"

ModSettings = 
{
};

function ModSettings:SaveConfig ()
	for name, value in pairs(self) do
		SaveTableToSlot(value, name);
	end
end

function ModSettings:LoadConfig ()
	for name, value in pairs(self) do
		print(name);
		local tableVersion = value[Version] or -1;
		local loadedValue = LoadTableFromSlot(name);

		if loadedValue ~= nil then
			local loadedVersion = loadedValue[Version] or -1;

			if tableVersion == loadedVersion and tableVersion ~= -1 then
				value = loadedValue;
			else
				for innerLoadedName, innerLoadedValue in pairs(loadedValue) do
					if(value[innerLoadedName] ~= nil) and type(value[innerLoadedName] ~= nil) ~= "table" then
						value[innerLoadedName] = innerLoadedValue;

					--We'll go up to two layers deep. Probably would be better as recursion, but I don't really trust Lua that much for it at this stage. 
					elseif (value[innerLoadedName] ~= nil) and type(value[innerLoadedName] ~= nil) == "table" then 
						for innerInnerLoadedName, innerInnerLoadedValue in pairs(loadedValue[innerLoadedName]) do
							local heldTable = value[innerLoadedName];
							if heldTable[innerInnerLoadedName] ~= nil then 
								heldTable[innerInnerLoadedName] = innerInnerLoadedValue;
							end
						end
					end
				end
			end
		end
	end
end

--LoadConfig ();
--SaveConfig ();

--GameConfiguration.SetValue("57e9060c-74db-415e-b0ec-313e551eb6d5", "1");
GameConfiguration.ModSettings = ModSettings;
--print("Loaded Base Settings")