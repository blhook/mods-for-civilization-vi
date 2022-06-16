--- Author: Brandon Hook
---
--- Copyright (c) 2022 Brandon Hook. All rights reserved.
--- This work is licensed under the terms of the MIT license.  
--- For a copy, see <https://opensource.org/licenses/MIT>.
--------------------------------------------------------------

--Handle Eleanor's Modifications
DELETE FROM [TraitModifiers]
WHERE (([TraitType] = 'TRAIT_LEADER_ELEANOR_LOYALTY') AND ([ModifierId] = 'SKIP_FREE_CITY'));

UPDATE [ModifierArguments]
SET [Value] = '1.5'
WHERE (([ModifierId] = 'IDENTITY_NEARBY_GREATWORKS') AND ([Name] = 'Amount'));

INSERT INTO [Types] ([Type], [Kind]) VALUES 
('MODIFIER_GIVE_LOYALTY_ELEANOR_CULTURE_CAPTURE_ZUG', 'KIND_MODIFIER');

INSERT INTO [DynamicModifiers] ([ModifierType], [CollectionType], [EffectType]) VALUES 
('MODIFIER_GIVE_LOYALTY_ELEANOR_CULTURE_CAPTURE_ZUG', 'COLLECTION_PLAYER_CITIES', 'EFFECT_ADJUST_CITY_ALWAYS_LOYAL');

INSERT INTO [TraitModifiers] ([TraitType], [ModifierId]) VALUES 
('TRAIT_LEADER_ELEANOR_LOYALTY', 'MODIFIER_LEADER_ELEANOR_EXTRAGREATWORK_ZUG');

INSERT INTO [Modifiers] ([ModifierId], [ModifierType], [RunOnce], [Permanent], [NewOnly], [OwnerRequirementSetId], [SubjectRequirementSetId]) VALUES 
('MODIFIER_LEADER_ELEANOR_EXTRAGREATWORK_ZUG', 'MODIFIER_GIVE_LOYALTY_ELEANOR_CULTURE_CAPTURE_ZUG', 0, 0, 0, NULL, 'REQUIREMENT_ELEANOR_OWNED_CULTURE_CAPTURED_ZUG');

INSERT INTO [ModifierArguments] ([ModifierId], [Name], [Value]) VALUES 
('MODIFIER_LEADER_ELEANOR_EXTRAGREATWORK_ZUG', 'AlwaysLoyal', 1);

INSERT INTO [Requirements] ([RequirementId], [RequirementType], [Inverse]) VALUES 
('REQUIREMENT_ELEANOR_NOT_ORIGINAL_OWNER_ZUG', 'REQUIREMENT_CITY_IS_ORIGINAL_OWNER', 1), 
('REQUIREMENT_ELEANOR_CAPTURE_BY_CULTURE_ZUG', 'REQUIREMENT_CITY_TRANSFER_TYPE_MATCHES', 0);

INSERT INTO [RequirementArguments] ([RequirementId], [Name], [Value]) VALUES 
('REQUIREMENT_ELEANOR_CAPTURE_BY_CULTURE_ZUG', 'TransferType', 'BY_CULTURAL_IDENTITY');

INSERT INTO [RequirementSets] ([RequirementSetId], [RequirementSetType]) VALUES 
('REQUIREMENT_ELEANOR_OWNED_CULTURE_CAPTURED_ZUG', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO [RequirementSetRequirements] ([RequirementSetId], [RequirementId]) VALUES 
('REQUIREMENT_ELEANOR_OWNED_CULTURE_CAPTURED_ZUG', 'REQUIREMENT_ELEANOR_NOT_ORIGINAL_OWNER_ZUG'), 
('REQUIREMENT_ELEANOR_OWNED_CULTURE_CAPTURED_ZUG', 'REQUIREMENT_ELEANOR_CAPTURE_BY_CULTURE_ZUG');