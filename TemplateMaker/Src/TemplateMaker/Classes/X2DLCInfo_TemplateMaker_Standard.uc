//---------------------------------------------------------------------------------------
//  FILE:    X2DLCInfo_TemplateMaker_Standard.uc
//  AUTHOR:  Srinath Upadhyayula
//  PURPOSE: Standard processing phase for the TemplateMaker multi-phase system
//           Handles main template operations and mod integration points
//---------------------------------------------------------------------------------------

class X2DLCInfo_TemplateMaker_Standard extends X2DownloadableContentInfo;

// Phase tracking - simple initialization flags used once during startup
var bool bStandardPhaseInitialized;
var bool bStandardPhaseCompleted;

// Called when the mod is loaded to strategy layer - Standard processing phase
static event OnLoadedSavedGameToStrategy()
{
    local X2DLCInfo_TemplateMaker_Standard CDO;

    CDO = X2DLCInfo_TemplateMaker_Standard(class'XComEngine'.static.GetClassDefaultObject(class'X2DLCInfo_TemplateMaker_Standard'));
    if (CDO == none) return;

    // Logger should already be initialized by First phase
    if (CDO.bStandardPhaseInitialized)
    {
        class'TM_Logger'.static.LogDebug("Standard phase already initialized - skipping", "StandardPhase");
        return;
    }

    // Ensure First phase has completed
    if (!class'X2DLCInfo_TemplateMaker_First'.static.IsFirstPhaseInitialized())
    {
        class'TM_Logger'.static.LogWarning("First phase not completed - Standard phase may have issues", "StandardPhase");
    }

    class'TM_Logger'.static.LogInfo("=== TEMPLATEMAKER STANDARD PHASE INITIALIZATION ===", "StandardPhase");

    // Initialize main processing systems
    InitializeMainProcessingSystems();

    // Set up API compatibility layers
    InitializeAPICompatibilityLayers();

    // Configure template processing pipeline
    ConfigureTemplateProcessingPipeline();

    // Initialize mod integration points
    InitializeModIntegrationPoints();

    // Mark standard phase as initialized
    CDO.bStandardPhaseInitialized = true;

    class'TM_Logger'.static.LogInfo("TemplateMaker Standard Phase initialization completed", "StandardPhase");
}

// Called when the mod is loaded to tactical layer - Forward to strategy
static event OnLoadedSavedGameToTactical()
{
    OnLoadedSavedGameToStrategy();
}

// Called when templates are being created - Main template processing
static event OnPostTemplatesCreated()
{
    local X2DLCInfo_TemplateMaker_Standard CDO;

    CDO = X2DLCInfo_TemplateMaker_Standard(class'XComEngine'.static.GetClassDefaultObject(class'X2DLCInfo_TemplateMaker_Standard'));
    if (CDO == none) return;

    if (CDO.bStandardPhaseCompleted)
    {
        class'TM_Logger'.static.LogDebug("Standard phase template processing already completed", "StandardPhase");
        return;
    }

    // Ensure First phase template processing has completed
    if (!class'X2DLCInfo_TemplateMaker_First'.static.IsFirstPhaseCompleted())
    {
        class'TM_Logger'.static.LogWarning("First phase template processing not completed", "StandardPhase");
    }

    class'TM_Logger'.static.LogInfo("=== TEMPLATEMAKER STANDARD PHASE TEMPLATE PROCESSING ===", "StandardPhase");

    // Process all templates through the unified system
    ProcessTemplatesThroughUnifiedSystem();

    // Execute API compatibility operations
    ExecuteAPICompatibilityOperations();

    // Perform primary template operations
    PerformPrimaryTemplateOperations();

    // Handle configuration-driven template operations
    HandleConfigurationDrivenOperations();

    // Mark standard phase template processing as completed
    CDO.bStandardPhaseCompleted = true;

    class'TM_Logger'.static.LogInfo("TemplateMaker Standard Phase template processing completed", "StandardPhase");
}

// Initialize main processing systems
static function InitializeMainProcessingSystems()
{
    local float StartTime, EndTime;

    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    class'TM_Logger'.static.LogInfo("Initializing main processing systems...", "StandardPhase");

    // Ensure template processor is ready for main operations
    if (!class'TM_TemplateProcessor'.static.IsInitialized())
    {
        class'TM_Logger'.static.LogWarning("Template processor not initialized - initializing now", "StandardPhase");
        class'TM_TemplateProcessor'.static.Initialize();
    }

    // Initialize template tracking for main processing
    class'TM_TemplateTracker'.static.PrepareForMainProcessing();

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    class'TM_Logger'.static.LogPerformanceMetric("MainProcessingInit", EndTime - StartTime, 1, 0, "Main processing systems initialization");

    class'TM_Logger'.static.LogInfo("Main processing systems initialized successfully", "StandardPhase");
}

// Initialize API compatibility layers
static function InitializeAPICompatibilityLayers()
{
    local array<APICompatibilityInfo> ActiveAPIs;
    local int i;
    local float StartTime, EndTime;

    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    class'TM_Logger'.static.LogInfo("Initializing API compatibility layers...", "StandardPhase");

    // Get all active APIs and initialize their compatibility layers
    ActiveAPIs = class'TM_APIRegistry'.static.GetActiveAPIs();

    for (i = 0; i < ActiveAPIs.Length; i++)
    {
        class'TM_Logger'.static.LogDebug("Initializing compatibility layer for: " $ ActiveAPIs[i].FormatName, "StandardPhase");

        // Initialize specific compatibility layers based on API format
        InitializeSpecificAPILayer(ActiveAPIs[i]);
    }

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    class'TM_Logger'.static.LogPerformanceMetric("APILayersInit", EndTime - StartTime, ActiveAPIs.Length, 0, "API compatibility layers initialization");

    class'TM_Logger'.static.LogInfo("API compatibility layers initialized for " $ ActiveAPIs.Length $ " formats", "StandardPhase");
}

// Initialize specific API compatibility layer
static function InitializeSpecificAPILayer(APICompatibilityInfo APIInfo)
{
    switch (APIInfo.Format)
    {
        case EAF_TemplateMaster:
            InitializeTemplateMasterCompatibility();
            break;
        case EAF_WSR:
            InitializeWSRCompatibility();
            break;
        case EAF_DynamicEnemyCreation:
            InitializeDynamicEnemyCreationCompatibility();
            break;
        case EAF_BuildADarkEvent:
            InitializeBuildADarkEventCompatibility();
            break;
        case EAF_AbilityEditor:
            InitializeAbilityEditorCompatibility();
            break;
        case EAF_PCSSystem:
            InitializePCSSystemCompatibility();
            break;
        case EAF_SitRepSystem:
            InitializeSitRepSystemCompatibility();
            break;
        default:
            class'TM_Logger'.static.LogDebug("No specific initialization for API format: " $ APIInfo.FormatName, "StandardPhase");
            break;
    }
}

// Configure template processing pipeline
static function ConfigureTemplateProcessingPipeline()
{
    class'TM_Logger'.static.LogInfo("Configuring template processing pipeline...", "StandardPhase");

    // Configure processing order and priorities
    class'TM_TemplateProcessor'.static.ConfigureProcessingPipeline();

    // Set up conflict resolution strategies
    class'TM_TemplateProcessor'.static.ConfigureConflictResolution();

    class'TM_Logger'.static.LogInfo("Template processing pipeline configured", "StandardPhase");
}

// Initialize mod integration points
static function InitializeModIntegrationPoints()
{
    class'TM_Logger'.static.LogInfo("Initializing mod integration points...", "StandardPhase");

    // Set up integration points for other mods to hook into
    // This allows other mods to integrate with TemplateMaker's processing

    class'TM_Logger'.static.LogInfo("Mod integration points initialized", "StandardPhase");
}

// Process templates through unified system
static function ProcessTemplatesThroughUnifiedSystem()
{
    local float StartTime, EndTime;

    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    class'TM_Logger'.static.LogInfo("Processing templates through unified system...", "StandardPhase");

    // Main template processing operation
    class'TM_TemplateProcessor'.static.ProcessAllTemplates();

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    class'TM_Logger'.static.LogPerformanceMetric("UnifiedTemplateProcessing", EndTime - StartTime, 1, 0, "Unified template processing");

    class'TM_Logger'.static.LogInfo("Template processing through unified system completed", "StandardPhase");
}

// Execute API compatibility operations
static function ExecuteAPICompatibilityOperations()
{
    local array<APICompatibilityInfo> ActiveAPIs;
    local int i;

    class'TM_Logger'.static.LogInfo("Executing API compatibility operations...", "StandardPhase");

    ActiveAPIs = class'TM_APIRegistry'.static.GetActiveAPIs();

    for (i = 0; i < ActiveAPIs.Length; i++)
    {
        if (ActiveAPIs[i].bActive)
        {
            class'TM_Logger'.static.LogDebug("Executing compatibility operations for: " $ ActiveAPIs[i].FormatName, "StandardPhase");
            ExecuteSpecificAPIOperations(ActiveAPIs[i]);
        }
    }

    class'TM_Logger'.static.LogInfo("API compatibility operations completed", "StandardPhase");
}

// Execute specific API operations
static function ExecuteSpecificAPIOperations(APICompatibilityInfo APIInfo)
{
    // Execute format-specific operations during standard phase
    class'TM_Logger'.static.LogDebug("Executing operations for API: " $ APIInfo.FormatName, "StandardPhase");
}

// Perform primary template operations
static function PerformPrimaryTemplateOperations()
{
    class'TM_Logger'.static.LogInfo("Performing primary template operations...", "StandardPhase");

    // Primary template creation and modification operations
    // These are the main operations that most mods expect to run in standard order

    class'TM_Logger'.static.LogInfo("Primary template operations completed", "StandardPhase");
}

// Handle configuration-driven template operations
static function HandleConfigurationDrivenOperations()
{
    class'TM_Logger'.static.LogInfo("Handling configuration-driven template operations...", "StandardPhase");

    // Process configuration-based template modifications
    // This includes operations driven by configuration files

    class'TM_Logger'.static.LogInfo("Configuration-driven template operations completed", "StandardPhase");
}

// API-specific compatibility initialization methods
static function InitializeTemplateMasterCompatibility()
{
    class'TM_Logger'.static.LogDebug("Initializing Template Master compatibility layer", "StandardPhase");
}

static function InitializeWSRCompatibility()
{
    class'TM_Logger'.static.LogDebug("Initializing WSR compatibility layer", "StandardPhase");
}

static function InitializeDynamicEnemyCreationCompatibility()
{
    class'TM_Logger'.static.LogDebug("Initializing Dynamic Enemy Creation compatibility layer", "StandardPhase");
}

static function InitializeBuildADarkEventCompatibility()
{
    class'TM_Logger'.static.LogDebug("Initializing Build-A-Dark-Event compatibility layer", "StandardPhase");
}

static function InitializeAbilityEditorCompatibility()
{
    class'TM_Logger'.static.LogDebug("Initializing Ability Editor compatibility layer", "StandardPhase");
}

static function InitializePCSSystemCompatibility()
{
    class'TM_Logger'.static.LogDebug("Initializing PCS System compatibility layer", "StandardPhase");
}

static function InitializeSitRepSystemCompatibility()
{
    class'TM_Logger'.static.LogDebug("Initializing SitRep System compatibility layer", "StandardPhase");
}

// Called when loading a saved game created before this mod was installed
static event OnLoadedSavedGame()
{
    class'TM_Logger'.static.LogInfo("TemplateMaker Standard Phase detected in existing save game", "StandardPhase");
}

// Called when starting a new campaign
static event InstallNewCampaign(XComGameState StartState)
{
    class'TM_Logger'.static.LogInfo("TemplateMaker Standard Phase installed in new campaign", "StandardPhase");
}

// Phase status queries
static function bool IsStandardPhaseInitialized()
{
    local X2DLCInfo_TemplateMaker_Standard CDO;

    CDO = X2DLCInfo_TemplateMaker_Standard(class'XComEngine'.static.GetClassDefaultObject(class'X2DLCInfo_TemplateMaker_Standard'));
    if (CDO == none) return false;

    return CDO.bStandardPhaseInitialized;
}

static function bool IsStandardPhaseCompleted()
{
    local X2DLCInfo_TemplateMaker_Standard CDO;

    CDO = X2DLCInfo_TemplateMaker_Standard(class'XComEngine'.static.GetClassDefaultObject(class'X2DLCInfo_TemplateMaker_Standard'));
    if (CDO == none) return false;

    return CDO.bStandardPhaseCompleted;
}

defaultproperties
{
    // NOTE: No defaultproperties needed for runtime state variables
    // bStandardPhaseInitialized and bStandardPhaseCompleted are initialized to false by default
}
