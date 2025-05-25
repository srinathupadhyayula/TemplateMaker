//---------------------------------------------------------------------------------------
//  FILE:    TM_ConfigManager.uc
//  AUTHOR:  TemplateMaker Team
//  DATE:    2025-05-23
//  PURPOSE: Configuration management for the TemplateMaker mod
//---------------------------------------------------------------------------------------

class TM_ConfigManager extends Object config(TemplateMaker);

// Feature toggles
var config bool bEnableTemplateCreation;
var config bool bEnableTemplateEditing;
var config bool bEnableWeaponSkinReplacement;
var config bool bEnableDebugCommands;

// Backward compatibility settings
var config bool bEnableWSRCompatibility;
var config bool bEnableTemplateMasterCompatibility;

// Check if template creation is enabled
static function bool IsTemplateCreationEnabled()
{
    return default.bEnableTemplateCreation;
}

// Check if template editing is enabled
static function bool IsTemplateEditingEnabled()
{
    return default.bEnableTemplateEditing;
}

// Check if weapon skin replacement is enabled
static function bool IsWeaponSkinReplacementEnabled()
{
    return default.bEnableWeaponSkinReplacement;
}

// Check if debug commands are enabled
static function bool AreDebugCommandsEnabled()
{
    return default.bEnableDebugCommands;
}

// Check if WSR compatibility is enabled
static function bool IsWSRCompatibilityEnabled()
{
    return default.bEnableWSRCompatibility;
}

// Check if TemplateMaster compatibility is enabled
static function bool IsTemplateMasterCompatibilityEnabled()
{
    return default.bEnableTemplateMasterCompatibility;
}
