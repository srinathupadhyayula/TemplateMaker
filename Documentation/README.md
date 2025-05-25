# TemplateMaker

A comprehensive template management system for XCOM 2 mods that consolidates template functionality from multiple foundational mods while maintaining 100% backward compatibility through comprehensive wrapper classes.

## Overview

TemplateMaker is a unified system that combines and enhances the functionality of:
- **Template Master** (EditTemplateStruct compatibility)
- **Dynamic Enemy Creation** (UnitDefinition compatibility)
- **Weapon Skin Replacer (WSR)** (GIVE_ABILITIES/CHANGE_TEMPLATE compatibility)
- **Build-A-Dark-Event** (AbilityDarkEvent compatibility)
- **Ability Editor** (AbilityNames compatibility)
- **PCS System** (X2EquipmentTemplate PCS compatibility)
- **SitRep System** (X2SitRepTemplate compatibility)

The mod provides a unified, configuration-based approach to template management, allowing modders to create, edit, and replace templates without writing code, while preserving all existing API formats for seamless integration with the mod ecosystem.

## Key Features

- **Unified Template Processing**: Single system handling all template operations through a comprehensive processing pipeline
- **100% Backward Compatibility**: All existing configurations work without modification through comprehensive wrapper classes
- **Proactive Conflict Detection**: Template tracking and conflict resolution system to prevent naming collisions
- **Transparent Wrapper Behavior**: Extensive logging showing how legacy configurations are processed
- **Enhanced Template Creation**: Advanced template creation capabilities beyond basic wrapper compatibility
- **Stukov Ecosystem Support**: Special attention to mods that depend on multiple APIs simultaneously
- **Configuration-Only User Experience**: No code changes required for template operations

## Installation

1. Subscribe to the mod on the Steam Workshop (coming soon)
2. Alternatively, download the latest release from the GitHub repository and extract it to your XCOM 2 mods folder
3. Enable the mod in the XCOM 2 Launcher
4. Existing configurations from supported mods will work automatically

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Supported API Formats](#supported-api-formats)
3. [Configuration](#configuration)
4. [Template Creation](#template-creation)
5. [Template Editing](#template-editing)
6. [Weapon Skin Replacement](#weapon-skin-replacement)
7. [Character Template Enhancement](#character-template-enhancement)
8. [PCS and SitRep Systems](#pcs-and-sitrep-systems)
9. [Console Commands](#console-commands)
10. [Backward Compatibility](#backward-compatibility)
11. [Examples](#examples)
12. [Troubleshooting](#troubleshooting)
13. [Credits](#credits)

## Architecture Overview

TemplateMaker uses a modular wrapper architecture that preserves all existing API formats while providing enhanced capabilities:

### Core Components
- **TM_CoreTemplateProcessor**: Central template processing pipeline
- **TM_CoreTemplateTracker**: Proactive conflict detection and template tracking
- **TM_CoreLogger**: Comprehensive logging with wrapper behavior transparency
- **TM_CoreConfigManager**: Enhanced configuration management

### Wrapper Classes
- **TM_WrapperTemplateMaster**: EditTemplateStruct compatibility
- **TM_WrapperDynamicEnemyCreation**: UnitDefinition compatibility
- **TM_WrapperWSR**: GIVE_ABILITIES/CHANGE_TEMPLATE compatibility
- **TM_WrapperBuildADarkEvent**: AbilityDarkEvent compatibility
- **TM_WrapperAbilityEditor**: AbilityNames compatibility
- **TM_WrapperPCSSystem**: X2EquipmentTemplate PCS compatibility
- **TM_WrapperSitRepSystem**: X2SitRepTemplate compatibility

## Supported API Formats

TemplateMaker maintains 100% compatibility with these critical API formats:

### 1. EditTemplateStruct (Template Master)
```ini
[WOTCIridarTemplateMaster.X2DLCInfo_Standard]
+EditTemplateStruct=(TemplateName="WeaponName", Property="Damage", Operation="Replace", Value="8")
```

### 2. UnitDefinition (Dynamic Enemy Creation)
```ini
[DynamicEnemyCreation.X2Character_DynamicEnemyTemplates]
+UnitDefinition=(TemplateName="CustomUnit", CharacterGroupName="AdventTrooper", ...)
```

### 3. GIVE_ABILITIES/CHANGE_TEMPLATE (WSR)
```ini
[zzzWeaponSkinReplacer.X2DownloadableContentInfo_WeaponSkinReplacer]
+GIVE_ABILITIES=(TEMPLATE="UnitName", ABILITIES[0]="AbilityName")
+CHANGE_TEMPLATE=(TEMPLATE="TemplateName", PROPERTY="PropertyName", VALUE="NewValue")
```

### 4. AbilityDarkEvent (Build-A-Dark-Event)
```ini
[AbilityDarkEvents.X2StrategyElement_AbilityDarkEvents]
+AbilityDarkEvents=(DarkEventID="CustomEvent", Abilities[0]=(AbilityName="SomeAbility"))
```

### 5. AbilityNames (Ability Editor)
```ini
[AbilityEditor.OPTC_Abilities]
+AbilityNames=(AbilityName="SomeAbility", NewDisplayName="Custom Name")
```

### 6. X2EquipmentTemplate PCS Patterns
```ini
; Standard X2EquipmentTemplate with PCS-specific properties
ItemCat=combatsim, InventorySlot=eInvSlot_CombatSim, StatBoostPowerLevel=1
```

### 7. X2SitRepTemplate Structures
```ini
; X2SitRepTemplate with effect system integration
TacticalGameplayTags, PositiveEffects, NegativeEffects, Requirements
```

## Configuration

TemplateMaker uses the following configuration files:

- Config/TemplateMaker/XComTemplateMaker.ini: Main configuration file with global settings
- Config/XComTemplateCreator.ini: Template creation configuration
- Config/XComTemplateEditor.ini: Template editing configuration
- Config/XComWeaponSkinReplacer.ini: WSR configuration

### Main Configuration

The main configuration file (Config/TemplateMaker/XComTemplateMaker.ini) contains global settings for the mod, including feature toggles and compatibility settings.

`ini
[TemplateMaker.TM_Logger]
; Logging configuration
bEnableLogging=true
bVerboseLogging=true
LogCategory=TemplateMaker

[TemplateMaker.TM_ConfigManager]
; Feature toggles
bEnableTemplateCreation=true
bEnableTemplateEditing=true
bEnableWeaponSkinReplacement=true
bEnableDebugCommands=true

; Backward compatibility settings
bEnableWSRCompatibility=true
bEnableTemplateMasterCompatibility=true
`

## Template Creation

TemplateMaker allows you to create new templates through configuration files. This is useful for creating new character templates, weapon templates, armor templates, and more.

### New Format

The new format for template creation is defined in the [TemplateMaker.TM_TemplateCreator] section of Config/XComTemplateCreator.ini:

`ini
[TemplateMaker.TM_TemplateCreator]
; New format for template creation
+CreateTemplate=(TemplateName=\
MyTemplate\, TemplateClass=\X2CharacterTemplate\, BasedOn=\ViperKing\)
`

### Backward Compatibility

For backward compatibility with TemplateMaster, you can also use the old format in the [WOTCIridarTemplateMaster.X2Item_TemplateCreator] section:

`ini
[WOTCIridarTemplateMaster.X2Item_TemplateCreator]
; Old format for template creation
+Create_X2ItemTemplate=(T=\MyTemplate\, C=\X2CharacterTemplate\)
`

## Template Editing

TemplateMaker allows you to edit existing templates through configuration files. This is useful for modifying character templates, weapon templates, armor templates, and more.

### New Format

The new format for template editing is defined in the [TemplateMaker.TM_TemplateEditor] section of Config/XComTemplateEditor.ini:

`ini
[TemplateMaker.TM_TemplateEditor]
; New format for template editing
+EditTemplate=(TemplateName=\ViperKing\, TemplateClass=\X2CharacterTemplate\, PropertyName=\strPawnArchetypes\, PropertyValue=\GameUnit_BigViperKing.ARC_GameUnit_BigViperKing\)
`

### Backward Compatibility

For backward compatibility with TemplateMaster, you can also use the old format in the [WOTCIridarTemplateMaster.X2DLCInfo_First], [WOTCIridarTemplateMaster.X2DLCInfo_Standard], and [WOTCIridarTemplateMaster.X2DLCInfo_Last] sections:

`ini
[WOTCIridarTemplateMaster.X2DLCInfo_First]
; Old format for template editing (first pass)
+Edit_X2CharacterTemplate=(T=\ViperKing\, P=\strPawnArchetypes\, V=\GameUnit_BigViperKing.ARC_GameUnit_BigViperKing\)
`

## Weapon Skin Replacement

TemplateMaker allows you to replace weapon skins, models, and animations through configuration files. This is useful for changing the appearance of weapons, characters, and more.

### New Format

The new format for weapon skin replacement is defined in the [TemplateMaker.TM_WeaponSkinReplacer] section of Config/XComWeaponSkinReplacer.ini:

`ini
[TemplateMaker.TM_WeaponSkinReplacer]
; New format for weapon skin replacement
+WeaponReplacement=(AcceptorTemplate=\ViperKing_WPN\, Scale=1.5)
`

### Backward Compatibility

For backward compatibility with WSR, you can also use the old format in the [zzzWeaponSkinReplacer.X2DownloadableContentInfo_WeaponSkinReplacer] section:

`ini
[zzzWeaponSkinReplacer.X2DownloadableContentInfo_WeaponSkinReplacer]
; Old format for weapon skin replacement
+WEAPON_REPLACEMENT=(ACCEPTOR_TEMPLATE=\ViperKing_WPN\, SCALE=1.5f)
`

## Character Template Enhancement

TemplateMaker provides enhanced support for character template creation and modification, with proper integration with XCOM2's character stats system. This allows you to create and modify character templates with all the features of the base game.

## PCS and SitRep Systems

TemplateMaker includes comprehensive support for Personal Combat Sim (PCS) and Situation Report (SitRep) template systems.

### PCS System Support

PCS items use standard X2EquipmentTemplate with specific properties:

- `ItemCat = 'combatsim'`
- `InventorySlot = eInvSlot_CombatSim`
- `StatBoostPowerLevel` for boost strength
- `StatsToBoost` array for target stats
- `bUseBoostIncrement = true` for flat bonuses

### SitRep System Support

SitRep templates use X2SitRepTemplate with sophisticated modular effect system:

- Force level requirements and mission type validation
- Tactical gameplay tags and effect system integration
- 20+ different effect types for various modifications
- Complex requirement system with strategy requirements

### Character Stats

Character stats are defined in the XComGameData_CharacterStats.ini file in the base game. TemplateMaker provides a way to access and modify these stats through configuration files.

`ini
[TemplateMaker.TM_TemplateEditor]
; Set character stats
+EditTemplate=(TemplateName=\ViperKing\, TemplateClass=\X2CharacterTemplate\, PropertyName=\CharacterBaseStats\, ArrayIndex=0, PropertyValue=\24\)
`

## Console Commands

TemplateMaker provides console commands for testing and debugging templates in-game. These commands are only available if debug commands are enabled in the configuration.

### Available Commands

- TM_ListTemplates [TemplateType]: List all templates of the specified type (character, weapon, etc.)
- TM_DumpTemplate <TemplateName>: Dump the properties of the specified template
- TM_TestTemplate <TemplateName>: Test the specified template in-game

### Enabling Debug Commands

Debug commands are enabled by default. You can disable them in the configuration:

`ini
[TemplateMaker.TM_ConfigManager]
bEnableDebugCommands=false
`

## Backward Compatibility

TemplateMaker provides backward compatibility with existing WSR and TemplateMaster configurations. This allows you to use your existing configurations with TemplateMaker without having to rewrite them.

### WSR Compatibility

WSR compatibility is enabled by default. You can disable it in the configuration:

`ini
[TemplateMaker.TM_ConfigManager]
bEnableWSRCompatibility=false
`

### TemplateMaster Compatibility

TemplateMaster compatibility is enabled by default. You can disable it in the configuration:

`ini
[TemplateMaker.TM_ConfigManager]
bEnableTemplateMasterCompatibility=false
`

## Examples

### Creating a New Character Template

`ini
[TemplateMaker.TM_TemplateCreator]
; Create a new character template based on the Viper King
+CreateTemplate=(TemplateName=\MyViperKing\, TemplateClass=\X2CharacterTemplate\, BasedOn=\ViperKing\)

[TemplateMaker.TM_TemplateEditor]
; Modify the new template
+EditTemplate=(TemplateName=\MyViperKing\, TemplateClass=\X2CharacterTemplate\, PropertyName=\strPawnArchetypes\, PropertyValue=\GameUnit_BigViperKing.ARC_GameUnit_BigViperKing\)
+EditTemplate=(TemplateName=\MyViperKing\, TemplateClass=\X2CharacterTemplate\, PropertyName=\fAppearanceScale\, PropertyValue=\1.5\)
+EditTemplate=(TemplateName=\MyViperKing\, TemplateClass=\X2CharacterTemplate\, PropertyName=\CharacterBaseStats\, ArrayIndex=0, PropertyValue=\24\)
`

### Replacing a Weapon Skin

`ini
[TemplateMaker.TM_WeaponSkinReplacer]
; Replace the Viper King's weapon with a scaled version
+WeaponReplacement=(AcceptorTemplate=\ViperKing_WPN\, Scale=1.5)
`

## Troubleshooting

### Common Issues

- **Template not found**: Make sure the template name is correct and the template exists in the game.
- **Property not found**: Make sure the property name is correct and the property exists on the template.
- **Array index out of bounds**: Make sure the array index is within the bounds of the array.
- **Invalid property value**: Make sure the property value is valid for the property type.

### Logging

TemplateMaker provides detailed logging to help with troubleshooting. You can enable verbose logging in the configuration:

`ini
[TemplateMaker.TM_Logger]
bEnableLogging=true
bVerboseLogging=true
`

The logs can be found in the XCOM 2 log file (%USERPROFILE%\\Documents\\my games\\XCOM2 War of the Chosen\\XComGame\\Logs\\Launch.log).

## Credits

TemplateMaker consolidates and enhances functionality from multiple foundational XCOM 2 mods. We acknowledge and thank the original authors:

### Foundational Mods
- **Template Master**: Original mod by Iridar - EditTemplateStruct format and template modification system
- **Weapon Skin Replacer (WSR)**: Original mod by Iridar - GIVE_ABILITIES/CHANGE_TEMPLATE format and visual replacement system
- **Dynamic Enemy Creation (BETA)**: Original mod by various authors - UnitDefinition format and character template creation
- **Build-A-Dark-Event WOTC**: Original mod by various authors - AbilityDarkEvent format and config-driven dark event creation
- **Ability Editor**: Original mod by various authors - AbilityNames format and ability modification system

### Specialized Systems
- **Create Custom Abilities (Immunities & Stats)**: Original mods for ability creation patterns
- **Dark Event Manager**: Original mods for dark event control systems
- **Alien Side Goals**: Original mod for progressive dark event systems
- **Create Custom GTS**: Original mod for GTS modification systems

### Community Contributions
- **Stukov's Mod Ecosystem**: Extensive use of multiple API formats simultaneously, providing real-world testing scenarios
- **PCS Workshop Mods**: Various authors contributing to PCS template patterns and implementations
- **SitRep Workshop Mods**: Various authors contributing to SitRep template systems and effect implementations

### TemplateMaker Development Team
- **Integration and Enhancement**: Unified system architecture and comprehensive wrapper implementation
- **Backward Compatibility**: 100% preservation of existing API formats through comprehensive wrapper classes
- **Conflict Detection**: Proactive template tracking and conflict resolution system
- **Documentation**: Comprehensive implementation plan and user documentation

### Special Thanks
- **XCOM 2 Modding Community**: For establishing the foundational template systems and best practices
- **Firaxis Games**: For creating the extensible XCOM 2 template architecture
- **Mod Authors and Users**: For testing, feedback, and continued support of the unified system

## License

This mod is licensed under the MIT License. See the [LICENSE](../LICENSE) file for details.

TemplateMaker respects and preserves the functionality of all integrated mods while providing enhanced capabilities through a unified architecture. All original mod functionality remains accessible through their existing configuration formats.
