//---------------------------------------------------------------------------------------
//  FILE:    TM_ConfigManager.uc
//  AUTHOR:  Srinath Upadhyayula
//  PURPOSE: Enhanced configuration management for the TemplateMaker system
//           Handles multiple configuration files and legacy format detection
//---------------------------------------------------------------------------------------

class TM_ConfigManager extends Object config(TemplateMaker) dependson(TM_TemplateDefinitionUnified, TM_Logger);

// Core system settings
var config bool bEnableUnifiedProcessing;       // Enable the unified processing system
var config bool bEnableLegacyCompatibility;     // Enable legacy format compatibility
var config bool bEnableWrapperLogging;          // Enable wrapper behavior logging
var config bool bEnableConflictDetection;       // Enable proactive conflict detection
var config EConflictResolution ConflictResolutionStrategy; // Default conflict resolution strategy

// Performance settings
var config bool bEnablePerformanceLogging;      // Enable performance monitoring
var config int MaxTemplateProcessingTime;       // Maximum time for template processing (ms)
var config bool bEnableAsyncProcessing;         // Enable asynchronous processing

// Debugging settings
var config ELogLevel LogLevel;                  // Logging level
var config bool bLogWrapperBehavior;            // Log wrapper translation behavior
var config bool bLogTemplateCreation;          // Log template creation operations
var config bool bLogConflictResolution;        // Log conflict detection and resolution

// Feature toggles (inherited from original TM_ConfigManager)
var config bool bEnableTemplateCreation;       // Enable template creation
var config bool bEnableTemplateEditing;        // Enable template editing
var config bool bEnableWeaponSkinReplacement;  // Enable weapon skin replacement
var config bool bEnableDebugCommands;          // Enable debug console commands

// Backward compatibility settings
var config bool bEnableWSRCompatibility;       // Enable WSR format compatibility
var config bool bEnableTemplateMasterCompatibility; // Enable TemplateMaster format compatibility
var config bool bEnableDynamicEnemyCreationCompatibility; // Enable DEC format compatibility
var config bool bEnableBuildADarkEventCompatibility; // Enable BADE format compatibility
var config bool bEnableAbilityEditorCompatibility; // Enable AbilityEditor format compatibility
var config bool bEnablePCSSystemCompatibility; // Enable PCS system compatibility
var config bool bEnableSitRepSystemCompatibility; // Enable SitRep system compatibility

// Configuration file tracking - using config for array modifications
var config array<string> LoadedConfigFiles;
var config array<ConfigValidationResult> ValidationResults;

// Initialize the configuration system
static function Initialize()
{
    class'TM_Logger'.static.LogInfo("TM_ConfigManager initializing...", "ConfigManager");

    // Validate core settings
    ValidateCoreSettings();

    // Load and validate configuration files
    LoadAllConfigurations();

    // Perform startup mod detection and warnings
    PerformStartupModDetection();

    class'TM_Logger'.static.LogInfo("TM_ConfigManager initialized successfully", "ConfigManager");
}

// Check if configuration manager is initialized
static function bool IsInitialized()
{
    // Use loaded config files array length to determine if initialization has occurred
    return default.LoadedConfigFiles.Length > 0;
}

// Core system setting accessors
static function bool IsUnifiedProcessingEnabled()
{
    return default.bEnableUnifiedProcessing;
}

static function bool IsLegacyCompatibilityEnabled()
{
    return default.bEnableLegacyCompatibility;
}

static function bool IsConflictDetectionEnabled()
{
    return default.bEnableConflictDetection;
}

static function EConflictResolution GetConflictResolutionStrategy()
{
    return default.ConflictResolutionStrategy;
}

// Performance setting accessors
static function bool IsPerformanceLoggingEnabled()
{
    return default.bEnablePerformanceLogging;
}

static function int GetMaxTemplateProcessingTime()
{
    return default.MaxTemplateProcessingTime;
}

static function bool IsAsyncProcessingEnabled()
{
    return default.bEnableAsyncProcessing;
}

// Feature toggle accessors (maintaining compatibility with original TM_ConfigManager)
static function bool IsTemplateCreationEnabled()
{
    return default.bEnableTemplateCreation;
}

static function bool IsTemplateEditingEnabled()
{
    return default.bEnableTemplateEditing;
}

static function bool IsWeaponSkinReplacementEnabled()
{
    return default.bEnableWeaponSkinReplacement;
}

static function bool AreDebugCommandsEnabled()
{
    return default.bEnableDebugCommands;
}

// Logging setting accessors for TM_Logger
static function ELogLevel GetLogLevel()
{
    return default.LogLevel;
}

static function bool IsWrapperBehaviorLoggingEnabled()
{
    return default.bLogWrapperBehavior;
}

static function bool IsTemplateCreationLoggingEnabled()
{
    return default.bLogTemplateCreation;
}

static function bool IsConflictResolutionLoggingEnabled()
{
    return default.bLogConflictResolution;
}

// Compatibility setting accessors
static function bool IsWSRCompatibilityEnabled()
{
    return default.bEnableWSRCompatibility && default.bEnableLegacyCompatibility;
}

static function bool IsTemplateMasterCompatibilityEnabled()
{
    return default.bEnableTemplateMasterCompatibility && default.bEnableLegacyCompatibility;
}

static function bool IsDynamicEnemyCreationCompatibilityEnabled()
{
    return default.bEnableDynamicEnemyCreationCompatibility && default.bEnableLegacyCompatibility;
}

static function bool IsBuildADarkEventCompatibilityEnabled()
{
    return default.bEnableBuildADarkEventCompatibility && default.bEnableLegacyCompatibility;
}

static function bool IsAbilityEditorCompatibilityEnabled()
{
    return default.bEnableAbilityEditorCompatibility && default.bEnableLegacyCompatibility;
}

static function bool IsPCSSystemCompatibilityEnabled()
{
    return default.bEnablePCSSystemCompatibility && default.bEnableLegacyCompatibility;
}

static function bool IsSitRepSystemCompatibilityEnabled()
{
    return default.bEnableSitRepSystemCompatibility && default.bEnableLegacyCompatibility;
}

// Configuration file management
static function LoadAllConfigurations()
{
    local array<string> ConfigFiles;
    local int i;
    local float StartTime, EndTime;

    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    // Define configuration files to load
    ConfigFiles.AddItem("XComTemplateMaker.ini");
    ConfigFiles.AddItem("XComTemplateCreator.ini");
    ConfigFiles.AddItem("XComTemplateEditor.ini");
    ConfigFiles.AddItem("XComWeaponSkinReplacer.ini");

    // Load each configuration file
    for (i = 0; i < ConfigFiles.Length; i++)
    {
        LoadConfigurationFile(ConfigFiles[i]);
    }

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    class'TM_Logger'.static.LogPerformanceMetric("ConfigurationLoading",
        EndTime - StartTime, ConfigFiles.Length, GetTotalValidationErrors(),
        "Loaded " $ ConfigFiles.Length $ " configuration files");
}

static function LoadConfigurationFile(string ConfigFile)
{
    local ConfigValidationResult ValidationResult;
    local float StartTime, EndTime;

    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    class'TM_Logger'.static.LogDebug("Loading configuration file: " $ ConfigFile, "ConfigManager");

    // Validate the configuration file
    ValidationResult = ValidateConfigurationFile(ConfigFile);

    // Store validation results
    default.ValidationResults.AddItem(ValidationResult);

    // Track loaded files
    if (default.LoadedConfigFiles.Find(ConfigFile) == INDEX_NONE)
    {
        default.LoadedConfigFiles.AddItem(ConfigFile);
    }

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    // Log configuration parsing results
    class'TM_Logger'.static.LogConfigurationParsing(ConfigFile,
        ValidationResult.EntriesProcessed, ValidationResult.Errors.Length);

    class'TM_Logger'.static.LogPerformanceMetric("ConfigFileLoading",
        EndTime - StartTime, 1, ValidationResult.Errors.Length, ConfigFile);
}

static function ConfigValidationResult ValidateConfigurationFile(string ConfigFile)
{
    local ConfigValidationResult Result;

    // Initialize result
    Result.ConfigFile = ConfigFile;
    Result.bValid = true;
    Result.EntriesProcessed = 0;
    Result.EntriesValid = 0;

    // Basic validation - check if file exists and is accessible
    // Note: In XCOM 2, we can't directly check file existence, so we assume it exists
    // and rely on the configuration system to handle missing files gracefully

    class'TM_Logger'.static.LogDebug("Validating configuration file: " $ ConfigFile, "ConfigManager");

    // For now, mark as valid - specific validation will be implemented by wrapper classes
    Result.bValid = true;
    Result.EntriesProcessed = 1; // Placeholder
    Result.EntriesValid = 1;     // Placeholder

    return Result;
}

static function ValidateCoreSettings()
{
    local array<string> ValidationErrors;

    class'TM_Logger'.static.LogDebug("Validating core configuration settings", "ConfigManager");

    // Validate conflict resolution strategy
    if (default.ConflictResolutionStrategy < ECR_Fail || default.ConflictResolutionStrategy > ECR_Skip)
    {
        ValidationErrors.AddItem("Invalid ConflictResolutionStrategy value");
        default.ConflictResolutionStrategy = ECR_Fail; // Set to safe default
    }

    // Validate performance settings
    if (default.MaxTemplateProcessingTime <= 0)
    {
        ValidationErrors.AddItem("MaxTemplateProcessingTime must be positive");
        default.MaxTemplateProcessingTime = 5000; // Set to safe default
    }

    // Validate log level
    if (default.LogLevel < ELL_Error || default.LogLevel > ELL_Verbose)
    {
        ValidationErrors.AddItem("Invalid LogLevel value");
        default.LogLevel = ELL_Info; // Set to safe default
    }

    // Log validation results
    if (ValidationErrors.Length > 0)
    {
        class'TM_Logger'.static.LogWarning("Core settings validation found " $
            ValidationErrors.Length $ " issues - using safe defaults", "ConfigManager");
    }
    else
    {
        class'TM_Logger'.static.LogDebug("Core settings validation passed", "ConfigManager");
    }
}

// Configuration query methods
static function array<string> GetLoadedConfigFiles()
{
    return default.LoadedConfigFiles;
}

static function array<ConfigValidationResult> GetValidationResults()
{
    return default.ValidationResults;
}

static function int GetTotalValidationErrors()
{
    local int i, TotalErrors;

    for (i = 0; i < default.ValidationResults.Length; i++)
    {
        TotalErrors += default.ValidationResults[i].Errors.Length;
    }

    return TotalErrors;
}

static function bool IsConfigurationValid()
{
    return GetTotalValidationErrors() == 0;
}

// Runtime configuration updates
static function SetConflictResolutionStrategy(EConflictResolution Strategy)
{
    default.ConflictResolutionStrategy = Strategy;
    class'TM_Logger'.static.LogInfo("Conflict resolution strategy changed to: " $ Strategy, "ConfigManager");
}

static function SetLogLevel(ELogLevel Level)
{
    default.LogLevel = Level;
    class'TM_Logger'.static.LogInfo("Log level changed to: " $ Level, "ConfigManager");
}

// Configuration summary for debugging
static function LogConfigurationSummary()
{
    class'TM_Logger'.static.LogInfo("=== CONFIGURATION SUMMARY ===", "ConfigManager");
    class'TM_Logger'.static.LogInfo("Unified Processing: " $ default.bEnableUnifiedProcessing, "ConfigManager");
    class'TM_Logger'.static.LogInfo("Legacy Compatibility: " $ default.bEnableLegacyCompatibility, "ConfigManager");
    class'TM_Logger'.static.LogInfo("Conflict Detection: " $ default.bEnableConflictDetection, "ConfigManager");
    class'TM_Logger'.static.LogInfo("Conflict Resolution: " $ default.ConflictResolutionStrategy, "ConfigManager");
    class'TM_Logger'.static.LogInfo("Performance Logging: " $ default.bEnablePerformanceLogging, "ConfigManager");
    class'TM_Logger'.static.LogInfo("Log Level: " $ default.LogLevel, "ConfigManager");
    class'TM_Logger'.static.LogInfo("Loaded Config Files: " $ default.LoadedConfigFiles.Length, "ConfigManager");
    class'TM_Logger'.static.LogInfo("Total Validation Errors: " $ GetTotalValidationErrors(), "ConfigManager");
    class'TM_Logger'.static.LogInfo("=== END CONFIGURATION SUMMARY ===", "ConfigManager");
}

// Startup mod detection and warning system
static function PerformStartupModDetection()
{
    local array<string> DetectedMods;
    local array<string> StartupWarnings;

    class'TM_Logger'.static.LogInfo("Performing startup mod compatibility check...", "ConfigManager");

    // Check if template tracker has completed mod detection
    if (class'TM_TemplateTracker'.static.HasModDetectionCompleted())
    {
        DetectedMods = class'TM_TemplateTracker'.static.GetDetectedLegacyMods();

        if (DetectedMods.Length > 0)
        {
            GenerateStartupWarnings(DetectedMods, StartupWarnings);
            DisplayStartupWarnings(StartupWarnings);

            // Suggest configuration changes based on detected mods
            SuggestConfigurationChanges(DetectedMods);
        }
        else
        {
            class'TM_Logger'.static.LogInfo("No legacy template mods detected - optimal configuration", "ConfigManager");
        }
    }
    else
    {
        class'TM_Logger'.static.LogWarning("Mod detection not completed during startup - manual check recommended", "ConfigManager");
    }
}

static function GenerateStartupWarnings(array<string> DetectedMods, out array<string> Warnings)
{
    local int i;

    Warnings.Length = 0;

    Warnings.AddItem("ATTENTION: Legacy template modification mods detected!");
    Warnings.AddItem("These mods may conflict with TemplateMaker's unified system:");

    for (i = 0; i < DetectedMods.Length; i++)
    {
        Warnings.AddItem("  - " $ DetectedMods[i]);
    }

    Warnings.AddItem("");
    Warnings.AddItem("RECOMMENDATIONS:");
    Warnings.AddItem("1. Consider disabling legacy mods and using TemplateMaker instead");
    Warnings.AddItem("2. If keeping both, enable conflict resolution in TemplateMaker");
    Warnings.AddItem("3. Test thoroughly before using in main campaign");
    Warnings.AddItem("4. Review Documentation/README.md for migration guidance");
}

static function DisplayStartupWarnings(array<string> Warnings)
{
    local int i;

    class'TM_Logger'.static.LogWarning("=== STARTUP MOD COMPATIBILITY WARNING ===", "ConfigManager");

    for (i = 0; i < Warnings.Length; i++)
    {
        class'TM_Logger'.static.LogWarning(Warnings[i], "ConfigManager");
    }

    class'TM_Logger'.static.LogWarning("=== END STARTUP WARNING ===", "ConfigManager");
}

static function SuggestConfigurationChanges(array<string> DetectedMods)
{
    local bool bSuggestOverride, bSuggestConflictDetection;

    class'TM_Logger'.static.LogWarning("=== CONFIGURATION SUGGESTIONS ===", "ConfigManager");

    // Analyze detected mods and suggest appropriate settings
    if (DetectedMods.Find("Weapon Skin Replacer (WSR)") != INDEX_NONE ||
        DetectedMods.Find("Template Master (WOTCIridarTemplateMaster)") != INDEX_NONE)
    {
        bSuggestOverride = true;
        bSuggestConflictDetection = true;
    }

    if (DetectedMods.Find("Dynamic Enemy Creation") != INDEX_NONE ||
        DetectedMods.Find("Build-A-Dark-Event") != INDEX_NONE)
    {
        bSuggestConflictDetection = true;
    }

    // Provide specific configuration recommendations
    if (bSuggestOverride)
    {
        class'TM_Logger'.static.LogWarning("RECOMMENDED: Set ConflictResolutionStrategy=ECR_Override", "ConfigManager");
        class'TM_Logger'.static.LogWarning("This allows TemplateMaker to handle conflicts automatically", "ConfigManager");
    }

    if (bSuggestConflictDetection)
    {
        class'TM_Logger'.static.LogWarning("RECOMMENDED: Set bEnableConflictDetection=true", "ConfigManager");
        class'TM_Logger'.static.LogWarning("This provides detailed logging of template conflicts", "ConfigManager");
    }

    // Current configuration status
    class'TM_Logger'.static.LogWarning("CURRENT SETTINGS:", "ConfigManager");
    class'TM_Logger'.static.LogWarning("  ConflictResolutionStrategy: " $ default.ConflictResolutionStrategy, "ConfigManager");
    class'TM_Logger'.static.LogWarning("  ConflictDetection: " $ default.bEnableConflictDetection, "ConfigManager");
    class'TM_Logger'.static.LogWarning("  LegacyCompatibility: " $ default.bEnableLegacyCompatibility, "ConfigManager");

    if (default.ConflictResolutionStrategy == ECR_Fail && bSuggestOverride)
    {
        class'TM_Logger'.static.LogWarning("WARNING: Current conflict resolution is set to FAIL", "ConfigManager");
        class'TM_Logger'.static.LogWarning("Template conflicts will cause errors instead of being resolved", "ConfigManager");
    }

    class'TM_Logger'.static.LogWarning("=== END CONFIGURATION SUGGESTIONS ===", "ConfigManager");
}

// Enhanced configuration validation with mod awareness
static function bool ValidateConfigurationWithModDetection()
{
    local array<string> DetectedMods;
    local bool bConfigurationOptimal;

    bConfigurationOptimal = true;
    DetectedMods = class'TM_TemplateTracker'.static.GetDetectedLegacyMods();

    if (DetectedMods.Length > 0)
    {
        // Check if conflict resolution is appropriately configured
        if (default.ConflictResolutionStrategy == ECR_Fail)
        {
            class'TM_Logger'.static.LogWarning("Configuration may not be optimal for detected legacy mods", "ConfigManager");
            bConfigurationOptimal = false;
        }

        // Check if conflict detection is enabled
        if (!default.bEnableConflictDetection)
        {
            class'TM_Logger'.static.LogWarning("Conflict detection disabled - may miss template conflicts", "ConfigManager");
            bConfigurationOptimal = false;
        }

        // Check if legacy compatibility is enabled
        if (!default.bEnableLegacyCompatibility)
        {
            class'TM_Logger'.static.LogWarning("Legacy compatibility disabled but legacy mods detected", "ConfigManager");
            bConfigurationOptimal = false;
        }
    }

    return bConfigurationOptimal;
}

defaultproperties
{
    // Core system defaults
    bEnableUnifiedProcessing=true
    bEnableLegacyCompatibility=true
    bEnableWrapperLogging=true
    bEnableConflictDetection=true
    ConflictResolutionStrategy=ECR_Fail

    // Performance defaults
    bEnablePerformanceLogging=false
    MaxTemplateProcessingTime=5000
    bEnableAsyncProcessing=false

    // Debugging defaults
    LogLevel=ELL_Info
    bLogWrapperBehavior=true
    bLogTemplateCreation=true
    bLogConflictResolution=true

    // Feature defaults
    bEnableTemplateCreation=true
    bEnableTemplateEditing=true
    bEnableWeaponSkinReplacement=true
    bEnableDebugCommands=false

    // Compatibility defaults
    bEnableWSRCompatibility=true
    bEnableTemplateMasterCompatibility=true
    bEnableDynamicEnemyCreationCompatibility=true
    bEnableBuildADarkEventCompatibility=true
    bEnableAbilityEditorCompatibility=true
    bEnablePCSSystemCompatibility=true
    bEnableSitRepSystemCompatibility=true
}
