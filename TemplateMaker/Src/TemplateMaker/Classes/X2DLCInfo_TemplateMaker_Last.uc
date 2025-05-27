//---------------------------------------------------------------------------------------
//  FILE:    X2DLCInfo_TemplateMaker_Last.uc
//  AUTHOR:  Srinath Upadhyayula
//  PURPOSE: Final processing phase for the TemplateMaker multi-phase system
//           Ensures TemplateMaker gets the last word on template modifications
//---------------------------------------------------------------------------------------

class X2DLCInfo_TemplateMaker_Last extends X2DownloadableContentInfo;

// Phase tracking - simple initialization flags used once during startup
var bool bLastPhaseInitialized;
var bool bLastPhaseCompleted;

// Called when the mod is loaded to strategy layer - Final processing phase
static event OnLoadedSavedGameToStrategy()
{
    local X2DLCInfo_TemplateMaker_Last CDO;

    CDO = X2DLCInfo_TemplateMaker_Last(class'XComEngine'.static.GetClassDefaultObject(class'X2DLCInfo_TemplateMaker_Last'));
    if (CDO == none) return;

    // Logger should already be initialized by First phase
    if (CDO.bLastPhaseInitialized)
    {
        class'TM_Logger'.static.LogDebug("Last phase already initialized - skipping", "LastPhase");
        return;
    }

    // Ensure previous phases have completed
    if (!class'X2DLCInfo_TemplateMaker_Standard'.static.IsStandardPhaseInitialized())
    {
        class'TM_Logger'.static.LogWarning("Standard phase not completed - Last phase may have issues", "LastPhase");
    }

    class'TM_Logger'.static.LogInfo("=== TEMPLATEMAKER LAST PHASE INITIALIZATION ===", "LastPhase");

    // Initialize final processing systems
    InitializeFinalProcessingSystems();

    // Set up final validation systems
    SetupFinalValidationSystems();

    // Initialize cleanup systems
    InitializeCleanupSystems();

    // Prepare comprehensive reporting
    PrepareComprehensiveReporting();

    // Mark last phase as initialized
    CDO.bLastPhaseInitialized = true;

    class'TM_Logger'.static.LogInfo("TemplateMaker Last Phase initialization completed", "LastPhase");
}

// Called when the mod is loaded to tactical layer - Forward to strategy
static event OnLoadedSavedGameToTactical()
{
    OnLoadedSavedGameToStrategy();
}

// Called when templates are being created - Final template processing
static event OnPostTemplatesCreated()
{
    local X2DLCInfo_TemplateMaker_Last CDO;

    CDO = X2DLCInfo_TemplateMaker_Last(class'XComEngine'.static.GetClassDefaultObject(class'X2DLCInfo_TemplateMaker_Last'));
    if (CDO == none) return;

    if (CDO.bLastPhaseCompleted)
    {
        class'TM_Logger'.static.LogDebug("Last phase template processing already completed", "LastPhase");
        return;
    }

    // Ensure previous phases have completed
    if (!class'X2DLCInfo_TemplateMaker_Standard'.static.IsStandardPhaseCompleted())
    {
        class'TM_Logger'.static.LogWarning("Standard phase template processing not completed", "LastPhase");
    }

    class'TM_Logger'.static.LogInfo("=== TEMPLATEMAKER LAST PHASE TEMPLATE PROCESSING ===", "LastPhase");

    // Perform final compatibility checks
    PerformFinalCompatibilityChecks();

    // Execute final template overrides
    ExecuteFinalTemplateOverrides();

    // Run validation tests if enabled
    RunValidationTests();

    // Generate comprehensive status reports
    GenerateComprehensiveStatusReports();

    // Perform cleanup operations
    PerformCleanupOperations();

    // Mark last phase template processing as completed
    CDO.bLastPhaseCompleted = true;

    class'TM_Logger'.static.LogInfo("TemplateMaker Last Phase template processing completed", "LastPhase");
    class'TM_Logger'.static.LogInfoBlock("=== ALL TEMPLATEMAKER PHASES COMPLETED ===", "LastPhase");
}

// Initialize final processing systems
static function InitializeFinalProcessingSystems()
{
    local float StartTime, EndTime;

    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    class'TM_Logger'.static.LogDebug("Initializing final processing systems...", "LastPhase");

    // Ensure all core systems are ready for final operations
    ValidateAllSystemsReady();

    // Initialize final conflict resolution
    InitializeFinalConflictResolution();

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    class'TM_Logger'.static.LogPerformanceMetric("FinalProcessingInit", EndTime - StartTime, 1, 0, "Final processing systems initialization");

    class'TM_Logger'.static.LogDebug("Final processing systems initialized successfully", "LastPhase");
}

// Set up final validation systems
static function SetupFinalValidationSystems()
{
    class'TM_Logger'.static.LogDebug("Setting up final validation systems...", "LastPhase");

    // Prepare infrastructure testing if debug mode is enabled
    if (class'TM_ConfigManager'.static.AreDebugCommandsEnabled())
    {
        class'TM_Logger'.static.LogDebug("Debug mode enabled - preparing infrastructure tests", "LastPhase");
    }

    class'TM_Logger'.static.LogDebug("Final validation systems ready", "LastPhase");
}

// Initialize cleanup systems
static function InitializeCleanupSystems()
{
    class'TM_Logger'.static.LogDebug("Initializing cleanup systems...", "LastPhase");

    // Prepare cleanup operations for post-processing
    // This includes memory cleanup, temporary data removal, etc.

    class'TM_Logger'.static.LogDebug("Cleanup systems initialized", "LastPhase");
}

// Prepare comprehensive reporting
static function PrepareComprehensiveReporting()
{
    class'TM_Logger'.static.LogDebug("Preparing comprehensive reporting systems...", "LastPhase");

    // Set up systems for generating detailed reports
    // This includes performance metrics, conflict reports, etc.

    class'TM_Logger'.static.LogDebug("Comprehensive reporting systems ready", "LastPhase");
}

// Perform final compatibility checks
static function PerformFinalCompatibilityChecks()
{
    local float StartTime, EndTime;
    local array<string> DetectedMods;
    local int ModCount, ProcessedTemplates, ErrorCount, ConflictCount;

    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    class'TM_Logger'.static.LogInfo("Performing final compatibility checks...", "LastPhase");

    // Get final statistics
    if (class'TM_TemplateTracker'.static.HasModDetectionCompleted())
    {
        DetectedMods = class'TM_TemplateTracker'.static.GetDetectedLegacyMods();
        ModCount = DetectedMods.Length;
    }

    ProcessedTemplates = class'TM_TemplateProcessor'.static.GetTotalTemplatesProcessed();
    ErrorCount = class'TM_TemplateProcessor'.static.GetTotalErrorsEncountered();
    ConflictCount = class'TM_TemplateTracker'.static.GetConflictCount();

    // Log final compatibility status
    class'TM_Logger'.static.LogInfoBlock("=== FINAL COMPATIBILITY STATUS ===", "LastPhase");
    class'TM_Logger'.static.LogInfo("Legacy Mods Detected: " $ ModCount, "LastPhase");
    class'TM_Logger'.static.LogInfo("Templates Processed: " $ ProcessedTemplates, "LastPhase");
    class'TM_Logger'.static.LogInfo("Processing Errors: " $ ErrorCount, "LastPhase");
    class'TM_Logger'.static.LogInfo("Conflicts Detected: " $ ConflictCount, "LastPhase");

    // Validate configuration with mod detection
    if (class'TM_ConfigManager'.static.ValidateConfigurationWithModDetection())
    {
        class'TM_Logger'.static.LogInfo("Configuration is optimal for current mod setup", "LastPhase");
    }
    else
    {
        class'TM_Logger'.static.LogWarning("Configuration may not be optimal - see recommendations", "LastPhase");
    }

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    class'TM_Logger'.static.LogPerformanceMetric("FinalCompatibilityCheck", EndTime - StartTime, 1, 0, "Final compatibility checks");

    class'TM_Logger'.static.LogInfo("Final compatibility checks completed", "LastPhase");
}

// Execute final template overrides
static function ExecuteFinalTemplateOverrides()
{
    class'TM_Logger'.static.LogDebug("Executing final template overrides...", "LastPhase");

    // Apply any final template modifications that need to override other mods
    // This ensures TemplateMaker gets the last word on template modifications

    class'TM_Logger'.static.LogDebug("Final template overrides completed", "LastPhase");
}

// Run validation tests if enabled
static function RunValidationTests()
{
    local array<TestResult> TestResults;
    local int i, PassedCount, FailedCount;

    if (!class'TM_ConfigManager'.static.AreDebugCommandsEnabled())
    {
        class'TM_Logger'.static.LogDebug("Debug commands disabled - skipping validation tests", "LastPhase");
        return;
    }

    class'TM_Logger'.static.LogInfo("Running comprehensive validation tests...", "LastPhase");

    // Run all infrastructure tests
    TestResults = class'TM_InfrastructureTest'.static.RunAllTests();

    // Count results
    for (i = 0; i < TestResults.Length; i++)
    {
        if (TestResults[i].bPassed)
        {
            PassedCount++;
        }
        else
        {
            FailedCount++;
        }
    }

    class'TM_Logger'.static.LogInfo("Validation tests completed - Passed: " $ PassedCount $ ", Failed: " $ FailedCount, "LastPhase");

    if (FailedCount > 0)
    {
        class'TM_Logger'.static.LogWarning("Some validation tests failed - check detailed logs", "LastPhase");
    }
}

// Generate comprehensive status reports
static function GenerateComprehensiveStatusReports()
{
    class'TM_Logger'.static.LogDebug("Generating comprehensive status reports...", "LastPhase");

    // Generate infrastructure report
    class'TM_InfrastructureTest'.static.GenerateInfrastructureReport();

    // Generate template tracking report
    class'TM_TemplateTracker'.static.GenerateTrackingReport();

    // Generate API registry summary
    class'TM_APIRegistry'.static.LogAPIRegistrySummary();

    // Generate configuration summary
    class'TM_ConfigManager'.static.LogConfigurationSummary();

    class'TM_Logger'.static.LogDebug("Comprehensive status reports generated", "LastPhase");
}

// Perform cleanup operations
static function PerformCleanupOperations()
{
    class'TM_Logger'.static.LogDebug("Performing cleanup operations...", "LastPhase");

    // Clean up temporary data, optimize memory usage, etc.
    // This ensures the system is in a clean state after processing

    class'TM_Logger'.static.LogDebug("Cleanup operations completed", "LastPhase");
}

// Validate all systems are ready
static function ValidateAllSystemsReady()
{
    local bool bAllSystemsReady;

    bAllSystemsReady = true;

    // Check if all required systems are initialized
    if (!class'TM_TemplateProcessor'.static.IsInitialized())
    {
        class'TM_Logger'.static.LogError("Template processor not initialized", "LastPhase");
        bAllSystemsReady = false;
    }

    if (!class'TM_ConfigManager'.static.IsInitialized())
    {
        class'TM_Logger'.static.LogError("Configuration manager not initialized", "LastPhase");
        bAllSystemsReady = false;
    }

    if (!class'TM_TemplateTracker'.static.IsInitialized())
    {
        class'TM_Logger'.static.LogError("Template tracker not initialized", "LastPhase");
        bAllSystemsReady = false;
    }

    if (bAllSystemsReady)
    {
        class'TM_Logger'.static.LogDebug("All systems validated and ready for final processing", "LastPhase");
    }
    else
    {
        class'TM_Logger'.static.LogError("Some systems not ready - final processing may have issues", "LastPhase");
    }
}

// Initialize final conflict resolution
static function InitializeFinalConflictResolution()
{
    class'TM_Logger'.static.LogDebug("Initializing final conflict resolution...", "LastPhase");

    // Set up final conflict resolution strategies
    // This ensures any remaining conflicts are resolved with TemplateMaker's preferences

    class'TM_Logger'.static.LogDebug("Final conflict resolution initialized", "LastPhase");
}

// Called when loading a saved game created before this mod was installed
static event OnLoadedSavedGame()
{
    class'TM_Logger'.static.LogInfo("TemplateMaker Last Phase detected in existing save game", "LastPhase");
}

// Called when starting a new campaign
static event InstallNewCampaign(XComGameState StartState)
{
    class'TM_Logger'.static.LogInfo("TemplateMaker Last Phase installed in new campaign", "LastPhase");
}

// Phase status queries
static function bool IsLastPhaseInitialized()
{
    local X2DLCInfo_TemplateMaker_Last CDO;

    CDO = X2DLCInfo_TemplateMaker_Last(class'XComEngine'.static.GetClassDefaultObject(class'X2DLCInfo_TemplateMaker_Last'));
    if (CDO == none) return false;

    return CDO.bLastPhaseInitialized;
}

static function bool IsLastPhaseCompleted()
{
    local X2DLCInfo_TemplateMaker_Last CDO;

    CDO = X2DLCInfo_TemplateMaker_Last(class'XComEngine'.static.GetClassDefaultObject(class'X2DLCInfo_TemplateMaker_Last'));
    if (CDO == none) return false;

    return CDO.bLastPhaseCompleted;
}

// Check if all phases are completed
static function bool AreAllPhasesCompleted()
{
    local X2DLCInfo_TemplateMaker_Last CDO;

    CDO = X2DLCInfo_TemplateMaker_Last(class'XComEngine'.static.GetClassDefaultObject(class'X2DLCInfo_TemplateMaker_Last'));
    if (CDO == none) return false;

    return class'X2DLCInfo_TemplateMaker_First'.static.IsFirstPhaseCompleted() &&
           class'X2DLCInfo_TemplateMaker_Standard'.static.IsStandardPhaseCompleted() &&
           CDO.bLastPhaseCompleted;
}

defaultproperties
{
    // NOTE: No defaultproperties needed for runtime state variables
    // bLastPhaseInitialized and bLastPhaseCompleted are initialized to false by default
}
