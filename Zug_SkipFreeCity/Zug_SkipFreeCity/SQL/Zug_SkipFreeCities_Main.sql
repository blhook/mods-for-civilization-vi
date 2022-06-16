--- Author: Brandon Hook
---
--- Copyright (c) 2022 Brandon Hook. All rights reserved.
--- This work is licensed under the terms of the MIT license.  
--- For a copy, see <https://opensource.org/licenses/MIT>.
--------------------------------------------------------------

--Give all Leaders the SkipFree trait. 
INSERT OR REPLACE INTO [Types]([Type], [Kind])
VALUES ('TRAIT_LEADER_ALLSKIPFREECITY_ZUG', 'KIND_TRAIT');

INSERT OR REPLACE INTO [Traits]	([TraitType])
VALUES	('TRAIT_LEADER_ALLSKIPFREECITY_ZUG');

INSERT OR REPLACE INTO [TraitModifiers]([TraitType], [ModifierId])
VALUES ('TRAIT_LEADER_ALLSKIPFREECITY_ZUG', 'SKIP_FREE_CITY');

INSERT OR IGNORE INTO [LeaderTraits]([LeaderType], [TraitType])
SELECT [LeaderType] , 'TRAIT_LEADER_ALLSKIPFREECITY_ZUG' FROM [Leaders]
WHERE [InheritFrom] = 'LEADER_DEFAULT';