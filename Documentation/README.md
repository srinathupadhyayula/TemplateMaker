# TemplateMaker Documentation

This document provides detailed information about the TemplateMaker mod, including its features, configuration options, and usage examples.

## Table of Contents

1. [Introduction](#introduction)
2. [Configuration](#configuration)
3. [Template Creation](#template-creation)
4. [Template Editing](#template-editing)
5. [Weapon Skin Replacement](#weapon-skin-replacement)
6. [Character Template Enhancement](#character-template-enhancement)
7. [Console Commands](#console-commands)
8. [Backward Compatibility](#backward-compatibility)
9. [Examples](#examples)
10. [Troubleshooting](#troubleshooting)

## Introduction

TemplateMaker is a comprehensive template management system for XCOM 2 mods, combining the functionality of Weapon Skin Replacer (WSR) and TemplateMaster with enhanced support for character template creation/modification through configuration files.

The mod provides a unified, configuration-based approach to template management, allowing modders to create, edit, and replace templates without writing code.

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
