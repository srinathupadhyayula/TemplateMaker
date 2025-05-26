TemplateMaker - Multi-Phase Template Management System

A sophisticated template management system for XCOM 2 mods that consolidates template functionality from multiple foundational mods while maintaining 100% backward compatibility through a multi-phase architecture powered by X2WOTCCommunityHighlander.

MULTI-PHASE ARCHITECTURE:
- First Phase (RUN_FIRST): Early initialization, core infrastructure setup, mod detection
- Standard Phase (RUN_STANDARD): Main template processing, API compatibility layers
- Last Phase (RUN_LAST): Final validation, conflict resolution, comprehensive reporting

ENHANCED FEATURES:
- Controlled Execution Order: Predictable processing sequence regardless of mod load order
- Enhanced Mod Compatibility: Clear integration points for other mods to hook into specific phases
- Strategic Conflict Resolution: TemplateMaker gets the final word on template modifications
- Comprehensive Validation: Complete system health checks and performance monitoring
- 100% Backward Compatibility: All existing configurations work without modification
- Proactive Conflict Detection: Template tracking and conflict resolution system
- Transparent Wrapper Behavior: Extensive logging showing how legacy configurations are processed

SUPPORTED SYSTEMS:
- Template Master (EditTemplateStruct compatibility)
- Dynamic Enemy Creation (UnitDefinition compatibility)
- Weapon Skin Replacer/WSR (GIVE_ABILITIES/CHANGE_TEMPLATE compatibility)
- Build-A-Dark-Event (AbilityDarkEvent compatibility)
- Ability Editor (AbilityNames compatibility)
- PCS System (X2EquipmentTemplate PCS compatibility)
- SitRep System (X2SitRepTemplate compatibility)

INSTALLATION:
1. Subscribe to the mod on Steam Workshop (coming soon)
2. Alternatively, download from GitHub and extract to XCOM 2 mods folder
3. Enable the mod in XCOM 2 Launcher
4. Existing configurations from supported mods will work automatically

DOCUMENTATION:
See Documentation/README.md for detailed usage instructions, configuration examples, and troubleshooting guides.

CREDITS:
Original mods by Iridar (Template Master, WSR) and various community authors.
TemplateMaker provides unified integration while preserving all original functionality.

LICENSE: MIT License - See LICENSE file for details.
