//---------------------------------------------------------------------------------------
//  FILE:    X2DLCInfo_TemplateMaker_First.uc
//  AUTHOR:  Srinath Upadhyayula
//  PURPOSE: Early initialization phase for the TemplateMaker multi-phase system
//           Handles foundational systems that other mods should see first
//---------------------------------------------------------------------------------------

class X2DLCInfo_TemplateMaker_First extends X2DownloadableContentInfo;

// Phase tracking - runtime state flags for initialization tracking
var bool bFirstPhaseInitialized;
var bool bFirstPhaseCompleted;

// Called when the mod is loaded to strategy layer - Early initialization phase
static event OnLoadedSavedGameToStrategy()
{
    local X2DLCInfo_TemplateMaker_First CDO;

    CDO = X2DLCInfo_TemplateMaker_First(class'XComEngine'.static.GetClassDefaultObject(class'X2DLCInfo_TemplateMaker_First'));
    if (CDO == none) return;

    // CRITICAL: Initialize logger FIRST before any other operations
    class'TM_Logger'.static.Initialize();

    if (CDO.bFirstPhaseInitialized)
    {
        class'TM_Logger'.static.LogDebug("First Phase already initialized - skipping", "FirstPhase");
        return;
    }

    class'TM_Logger'.static.LogInfo("=== TEMPLATEMAKER FIRST PHASE INITIALIZATION ===", "FirstPhase");
    class'TM_Logger'.static.LogDebug("TemplateMaker: Initializing core infrastructure...", "FirstPhase");

    // Initialize core infrastructure systems
    InitializeCoreInfrastructure();

    // Initialize API registry
    InitializeAPIRegistry();

    // Start mod detection
    InitializeModDetection();

    // Mark first phase as initialized
    CDO.bFirstPhaseInitialized = true;

    class'TM_Logger'.static.LogInfo("TemplateMaker First Phase initialization completed", "FirstPhase");
}

// Called when the mod is loaded to tactical layer - Forward to strategy
static event OnLoadedSavedGameToTactical()
{
    OnLoadedSavedGameToStrategy();
}

// Called when templates are being created - Early template setup
static event OnPostTemplatesCreated()
{
    local X2DLCInfo_TemplateMaker_First CDO;

    CDO = X2DLCInfo_TemplateMaker_First(class'XComEngine'.static.GetClassDefaultObject(class'X2DLCInfo_TemplateMaker_First'));
    if (CDO == none) return;

    if (CDO.bFirstPhaseCompleted)
    {
        class'TM_Logger'.static.LogDebug("First phase template processing already completed", "FirstPhase");
        return;
    }

    class'TM_Logger'.static.LogInfo("=== TEMPLATEMAKER FIRST PHASE TEMPLATE PROCESSING ===", "FirstPhase");

    // Set up template tracking before other mods register templates
    InitializeTemplateTracking();

    // Prepare API compatibility layers
    PrepareAPICompatibilityLayers();

    // Early template validation setup
    SetupEarlyTemplateValidation();

    // Mark first phase template processing as completed
    CDO.bFirstPhaseCompleted = true;

    class'TM_Logger'.static.LogInfo("TemplateMaker First Phase template processing completed", "FirstPhase");
}

// Called before templates are created - Earliest possible initialization
static function OnPreCreateTemplates()
{
    // Logger is already initialized in OnLoadedSavedGameToStrategy
    class'TM_Logger'.static.LogInfo("TemplateMaker First Phase pre-template creation", "FirstPhase");

    // Validate configuration before any template operations
    ValidateConfigurationIntegrity();

    // Set up performance monitoring
    class'TM_Logger'.static.LogPerformanceMetric("FirstPhasePreCreate", 0.0, 0, 0, "First phase pre-create initialization");
}

// Initialize core infrastructure systems
static function InitializeCoreInfrastructure()
{
    local float StartTime, EndTime;

    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    class'TM_Logger'.static.LogInfo("Initializing core infrastructure...", "FirstPhase");

    // Initialize the template processor (but don't start processing yet)
    class'TM_TemplateProcessor'.static.Initialize();

    // Initialize configuration manager
    class'TM_ConfigManager'.static.Initialize();

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    class'TM_Logger'.static.LogPerformanceMetric("CoreInfrastructureInit", EndTime - StartTime, 1, 0, "Core infrastructure initialization");

    class'TM_Logger'.static.LogInfo("Core infrastructure initialized successfully", "FirstPhase");
}

// Initialize API registry for other mods to use
static function InitializeAPIRegistry()
{
    local float StartTime, EndTime;

    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    class'TM_Logger'.static.LogInfo("Initializing API registry...", "FirstPhase");

    // Initialize the API registry so other mods can register their formats
    class'TM_APIRegistry'.static.Initialize();

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    class'TM_Logger'.static.LogPerformanceMetric("APIRegistryInit", EndTime - StartTime, 1, 0, "API registry initialization");

    class'TM_Logger'.static.LogInfo("API registry initialized - other mods can now register", "FirstPhase");
}

// Start mod detection process
static function InitializeModDetection()
{
    local float StartTime, EndTime;

    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    class'TM_Logger'.static.LogInfo("Starting mod detection process...", "FirstPhase");

    // Start the mod detection process early
    class'TM_TemplateTracker'.static.StartModDetection();

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    class'TM_Logger'.static.LogPerformanceMetric("ModDetectionInit", EndTime - StartTime, 1, 0, "Mod detection initialization");

    class'TM_Logger'.static.LogInfo("Mod detection process started", "FirstPhase");
}

// Validate basic configuration
static function PerformBasicConfigurationValidation()
{
    local bool bConfigValid;

    class'TM_Logger'.static.LogInfo("Performing basic configuration validation...", "FirstPhase");

    bConfigValid = class'TM_ConfigManager'.static.IsConfigurationValid();

    if (bConfigValid)
    {
        class'TM_Logger'.static.LogInfo("Basic configuration validation passed", "FirstPhase");
    }
    else
    {
        class'TM_Logger'.static.LogWarning("Basic configuration validation found issues - see detailed logs", "FirstPhase");
    }

    // Log early configuration status
    LogEarlyConfigurationStatus();
}

// Initialize template tracking system
static function InitializeTemplateTracking()
{
    class'TM_Logger'.static.LogInfo("Initializing template tracking system...", "FirstPhase");

    // Initialize template tracking before other mods register templates
    class'TM_TemplateTracker'.static.Initialize();

    class'TM_Logger'.static.LogInfo("Template tracking system initialized", "FirstPhase");
}

// Prepare API compatibility layers
static function PrepareAPICompatibilityLayers()
{
    local array<APICompatibilityInfo> ActiveAPIs;
    local int i;

    class'TM_Logger'.static.LogInfo("Preparing API compatibility layers...", "FirstPhase");

    // Get all active APIs and prepare their compatibility layers
    ActiveAPIs = class'TM_APIRegistry'.static.GetActiveAPIs();

    for (i = 0; i < ActiveAPIs.Length; i++)
    {
        class'TM_Logger'.static.LogDebug("Preparing compatibility layer for: " $ ActiveAPIs[i].FormatName, "FirstPhase");
    }

    class'TM_Logger'.static.LogInfo("API compatibility layers prepared for " $ ActiveAPIs.Length $ " formats", "FirstPhase");
}

// Set up early template validation
static function SetupEarlyTemplateValidation()
{
    class'TM_Logger'.static.LogInfo("Setting up early template validation...", "FirstPhase");

    // Set up validation systems that will be used by later phases
    // This ensures validation is ready before template processing begins

    class'TM_Logger'.static.LogInfo("Early template validation setup completed", "FirstPhase");
}

// Validate configuration integrity
static function ValidateConfigurationIntegrity()
{
    class'TM_Logger'.static.LogDebug("Validating configuration integrity...", "FirstPhase");

    // Perform early configuration integrity checks
    if (!class'TM_ConfigManager'.static.IsConfigurationValid())
    {
        class'TM_Logger'.static.LogError("Configuration integrity validation failed", "FirstPhase");
    }
}

// Display early warning banner
static function DisplayEarlyWarningBanner()
{
    `log("=== TEMPLATEMAKER EARLY WARNING ===");
    `log("TemplateMaker is initializing in multi-phase mode");
    `log("This mod consolidates template functionality from multiple legacy mods");
    `log("Check logs for compatibility warnings and recommendations");
    `log("=== END EARLY WARNING ===");
}

// Log early configuration status
static function LogEarlyConfigurationStatus()
{
    class'TM_Logger'.static.LogInfo("=== EARLY CONFIGURATION STATUS ===", "FirstPhase");
    class'TM_Logger'.static.LogValue("Unified Processing", class'TM_ConfigManager'.static.IsUnifiedProcessingEnabled() ? "Enabled" : "Disabled");
    class'TM_Logger'.static.LogValue("Conflict Detection", class'TM_ConfigManager'.static.IsConflictDetectionEnabled() ? "Enabled" : "Disabled");
    class'TM_Logger'.static.LogValue("Legacy Compatibility", class'TM_ConfigManager'.static.IsLegacyCompatibilityEnabled() ? "Enabled" : "Disabled");
    class'TM_Logger'.static.LogInfo("=== END EARLY CONFIGURATION STATUS ===", "FirstPhase");
}

// Called when loading a saved game created before this mod was installed
static event OnLoadedSavedGame()
{
    class'TM_Logger'.static.LogInfo("TemplateMaker First Phase detected in existing save game", "FirstPhase");
}

// Called when starting a new campaign
static event InstallNewCampaign(XComGameState StartState)
{
    class'TM_Logger'.static.LogInfo("TemplateMaker First Phase installed in new campaign", "FirstPhase");
}

// Phase status queries
static function bool IsFirstPhaseInitialized()
{
    local X2DLCInfo_TemplateMaker_First CDO;

    CDO = X2DLCInfo_TemplateMaker_First(class'XComEngine'.static.GetClassDefaultObject(class'X2DLCInfo_TemplateMaker_First'));
    if (CDO == none) return false;

    return CDO.bFirstPhaseInitialized;
}

static function bool IsFirstPhaseCompleted()
{
    local X2DLCInfo_TemplateMaker_First CDO;

    CDO = X2DLCInfo_TemplateMaker_First(class'XComEngine'.static.GetClassDefaultObject(class'X2DLCInfo_TemplateMaker_First'));
    if (CDO == none) return false;

    return CDO.bFirstPhaseCompleted;
}

defaultproperties
{
    // NOTE: No defaultproperties needed for runtime state variables
    // bFirstPhaseInitialized and bFirstPhaseCompleted are initialized to false by default
}
