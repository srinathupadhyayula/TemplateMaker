//---------------------------------------------------------------------------------------
//  FILE:    X2DownloadableContentInfo_TemplateMaker.uc
//  AUTHOR:  TemplateMaker Team
//  DATE:    2025-05-23
//  PURPOSE: Main entry point for the TemplateMaker mod
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_TemplateMaker extends X2DownloadableContentInfo;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
    class'TM_Logger'.static.Log("TemplateMaker mod detected in existing save game");
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{
    class'TM_Logger'.static.Log("TemplateMaker mod installed in new campaign");
}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
    // Initialize logging
    class'TM_Logger'.static.Init();
    
    // Log configuration values
    LogConfigValues();
    
    // Process template creation
    if (class'TM_ConfigManager'.static.IsTemplateCreationEnabled())
    {
        class'TM_Logger'.static.Log("Template creation enabled, processing...");
        
        // Process TemplateMaster compatibility
        if (class'TM_ConfigManager'.static.IsTemplateMasterCompatibilityEnabled())
        {
            class'TM_Logger'.static.Log("TemplateMaster compatibility enabled, processing template creation...");
            // This will be implemented in a later task
        }
        
        // Process TemplateMaker template creation
        class'TM_Logger'.static.Log("Processing TemplateMaker template creation...");
        // This will be implemented in a later task
    }
    
    // Process template editing
    if (class'TM_ConfigManager'.static.IsTemplateEditingEnabled())
    {
        class'TM_Logger'.static.Log("Template editing enabled, processing...");
        
        // Process TemplateMaster compatibility
        if (class'TM_ConfigManager'.static.IsTemplateMasterCompatibilityEnabled())
        {
            class'TM_Logger'.static.Log("TemplateMaster compatibility enabled, processing template editing...");
            // This will be implemented in a later task
        }
        
        // Process TemplateMaker template editing
        class'TM_Logger'.static.Log("Processing TemplateMaker template editing...");
        // This will be implemented in a later task
    }
    
    // Process weapon skin replacement
    if (class'TM_ConfigManager'.static.IsWeaponSkinReplacementEnabled())
    {
        class'TM_Logger'.static.Log("Weapon skin replacement enabled, processing...");
        
        // Process WSR compatibility
        if (class'TM_ConfigManager'.static.IsWSRCompatibilityEnabled())
        {
            class'TM_Logger'.static.Log("WSR compatibility enabled, processing weapon skin replacement...");
            // This will be implemented in a later task
        }
        
        // Process TemplateMaker weapon skin replacement
        class'TM_Logger'.static.Log("Processing TemplateMaker weapon skin replacement...");
        // This will be implemented in a later task
    }
}

/// <summary>
/// Log configuration values for debugging
/// </summary>
static function LogConfigValues()
{
    class'TM_Logger'.static.Log("TemplateMaker Configuration:");
    
    // Log feature toggles
    class'TM_Logger'.static.Log("Features:");
    class'TM_Logger'.static.LogValue("Template Creation", class'TM_ConfigManager'.static.IsTemplateCreationEnabled() ? "Enabled" : "Disabled");
    class'TM_Logger'.static.LogValue("Template Editing", class'TM_ConfigManager'.static.IsTemplateEditingEnabled() ? "Enabled" : "Disabled");
    class'TM_Logger'.static.LogValue("Weapon Skin Replacement", class'TM_ConfigManager'.static.IsWeaponSkinReplacementEnabled() ? "Enabled" : "Disabled");
    
    // Log compatibility settings
    class'TM_Logger'.static.Log("Compatibility:");
    class'TM_Logger'.static.LogValue("WSR Compatibility", class'TM_ConfigManager'.static.IsWSRCompatibilityEnabled() ? "Enabled" : "Disabled");
    class'TM_Logger'.static.LogValue("TemplateMaster Compatibility", class'TM_ConfigManager'.static.IsTemplateMasterCompatibilityEnabled() ? "Enabled" : "Disabled");
}
