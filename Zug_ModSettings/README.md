# No Resource Maintenance Cost for Inactive Units -- Tactical Extension
## General
This is an extension to No Resource Maintenance Cost for Inactive Units
https://steamcommunity.com/sharedfiles/filedetails/?id=1702672878, which updates the logic quite heavily and allows for easier customization of these settings. This mod does nothing by itself, and requires that mod to run properly.


The default logic is as follows, and still must be when the unit has not moved/performed an action itself:
Fortify Inside Owned/Allied Territory: Full Refund
Fortify Outside of Owned/Allied/Hostile: Half Refund
Fortify Inside Hostile: No Refund

No Action Inside Owned/Allied: Full Refund
No Action Outside of Owned/Allied/Hostile: Full Refund
No Action Inside Hostile: Half Refund

Defending With No Retaliation: Full Refund
Defending With Retaliation: Half Refund.

Always Active: false (Setting to true will bypass the Movement check, letting a unit with any movement (or lack thereof) allow a refund opportunity.


The lowest value is taken, so if you Sleep inside your own territory, but defend retaliate, you will still get half refund. Additionally, values are always rounded up when dividing, leaving at least 1 refunded resource in all cases applicable.


**Modifying the Values:**
1. Navigate to your Steam Install Directory (By Default: C:\Program Files\Steam\steamapps\workshop\content)
2. Search for "Zug_RefundInactive_ModSettings.lua" and open in Text.
3. Change the values inside "RefundRates" only.
4. Modify the values according to preference. -1 would be the unit's cost is doubled, 0.5 is the unit cost is halved, 1 the unit cost is zero. Please do not put ".5", but rather "0.5".

## Download & Install
### Steam 
https://steamcommunity.com/sharedfiles/filedetails/?id=1710037352

## License
This project is licensed under MIT. Refer to the [LICENSE](./LICENSE) for more details

This repository is not created by, affiliated with or sponsored by Take-Two Interactive Software and its subsidiaries or its affiliates.