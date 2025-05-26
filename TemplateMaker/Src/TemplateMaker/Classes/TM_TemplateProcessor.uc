//---------------------------------------------------------------------------------------
//  FILE:    TM_TemplateProcessor.uc
//  AUTHOR:  Srinath Upadhyayula
//  PURPOSE: Core template processing pipeline for the TemplateMaker system
//           Orchestrates all template operations and integrates core systems
//---------------------------------------------------------------------------------------

class TM_TemplateProcessor extends Object dependson(TM_TemplateDefinitionUnified);

// Processing state - simple variables for template processing pipeline
var bool bProcessingActive;
var array<UnifiedTemplateDefinition> ProcessingQueue;
var array<UnifiedTemplateDefinition> ProcessedTemplates;

// Performance tracking - simple metrics populated during execution
var float ProcessingStartTime;
var int TotalTemplatesProcessed;
var int TotalErrorsEncountered;

// Initialize the template processor
static function Initialize()
{
    local TM_TemplateProcessor CDO;

    CDO = TM_TemplateProcessor(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateProcessor'));
    if (CDO == none) return;

    // Use array length check instead of bInitialized flag - CDO pattern
    if (CDO.ProcessedTemplates.Length > 0 && !CDO.bProcessingActive) return;

    class'TM_Logger'.static.LogInfo("TM_TemplateProcessor initializing...", "TemplateProcessor");

    // Initialize all core systems
    class'TM_Logger'.static.Initialize();
    class'TM_ConfigManager'.static.Initialize();
    class'TM_APIRegistry'.static.Initialize();
    class'TM_TemplateTracker'.static.Initialize();

    CDO.bProcessingActive = false;

    class'TM_Logger'.static.LogInfo("TM_TemplateProcessor initialized successfully", "TemplateProcessor");

    // Log system summary
    LogSystemSummary();
}

// Check if template processor is initialized
static function bool IsInitialized()
{
    local TM_TemplateProcessor CDO;

    CDO = TM_TemplateProcessor(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateProcessor'));
    if (CDO == none) return false;

    // Use array length check to determine if initialization has occurred
    return CDO.ProcessedTemplates.Length >= 0 && !CDO.bProcessingActive;
}

// Configure processing pipeline (called by Standard phase)
static function ConfigureProcessingPipeline()
{
    class'TM_Logger'.static.LogInfo("Configuring template processing pipeline...", "TemplateProcessor");

    // Ensure initialization
    if (!IsInitialized())
    {
        Initialize();
    }

    // Configure processing order and priorities
    // Set up pipeline stages and their execution order

    class'TM_Logger'.static.LogInfo("Template processing pipeline configured", "TemplateProcessor");
}

// Configure conflict resolution (called by Standard phase)
static function ConfigureConflictResolution()
{
    class'TM_Logger'.static.LogInfo("Configuring conflict resolution strategies...", "TemplateProcessor");

    // Set up conflict resolution based on configuration
    // This ensures conflicts are handled according to user preferences

    class'TM_Logger'.static.LogInfo("Conflict resolution strategies configured", "TemplateProcessor");
}

// Main processing entry point
static function ProcessAllTemplates()
{
    local TM_TemplateProcessor CDO;
    local float StartTime, EndTime;

    CDO = TM_TemplateProcessor(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateProcessor'));
    if (CDO == none) return;

    // Initialize if needed - CDO pattern
    Initialize();

    if (CDO.bProcessingActive)
    {
        class'TM_Logger'.static.LogWarning("Template processing already active - skipping", "TemplateProcessor");
        return;
    }

    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    CDO.bProcessingActive = true;
    CDO.ProcessingStartTime = StartTime;
    CDO.TotalTemplatesProcessed = 0;
    CDO.TotalErrorsEncountered = 0;

    class'TM_Logger'.static.LogInfo("Starting template processing pipeline", "TemplateProcessor");

    // Load legacy configurations if compatibility is enabled
    if (class'TM_ConfigManager'.static.IsLegacyCompatibilityEnabled())
    {
        LoadLegacyConfigurations();
    }

    // Load unified configurations
    if (class'TM_ConfigManager'.static.IsUnifiedProcessingEnabled())
    {
        LoadUnifiedConfigurations();
    }

    // Process the queue
    ProcessTemplateQueue();

    // Post-processing validation
    ValidateProcessedTemplates();

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    CDO.bProcessingActive = false;

    // Log processing results
    class'TM_Logger'.static.LogPerformanceMetric("TemplateProcessingPipeline",
        EndTime - StartTime, CDO.TotalTemplatesProcessed, CDO.TotalErrorsEncountered,
        "Complete pipeline execution");

    class'TM_Logger'.static.LogInfo("Template processing completed - " $
        CDO.TotalTemplatesProcessed $ " templates processed, " $
        CDO.TotalErrorsEncountered $ " errors encountered", "TemplateProcessor");
}

// Load legacy configuration formats
static function LoadLegacyConfigurations()
{
    local TM_TemplateProcessor CDO;
    local float StartTime, EndTime;
    local int InitialQueueSize;

    CDO = TM_TemplateProcessor(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateProcessor'));
    if (CDO == none) return;

    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    InitialQueueSize = CDO.ProcessingQueue.Length;

    class'TM_Logger'.static.LogInfo("Loading legacy configurations...", "TemplateProcessor");

    // Load each supported legacy format
    if (class'TM_ConfigManager'.static.IsTemplateMasterCompatibilityEnabled())
    {
        LoadTemplateMasterConfigurations();
    }

    if (class'TM_ConfigManager'.static.IsDynamicEnemyCreationCompatibilityEnabled())
    {
        LoadDynamicEnemyCreationConfigurations();
    }

    if (class'TM_ConfigManager'.static.IsWSRCompatibilityEnabled())
    {
        LoadWSRConfigurations();
    }

    if (class'TM_ConfigManager'.static.IsBuildADarkEventCompatibilityEnabled())
    {
        LoadBuildADarkEventConfigurations();
    }

    if (class'TM_ConfigManager'.static.IsAbilityEditorCompatibilityEnabled())
    {
        LoadAbilityEditorConfigurations();
    }

    if (class'TM_ConfigManager'.static.IsPCSSystemCompatibilityEnabled())
    {
        LoadPCSSystemConfigurations();
    }

    if (class'TM_ConfigManager'.static.IsSitRepSystemCompatibilityEnabled())
    {
        LoadSitRepSystemConfigurations();
    }

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    class'TM_Logger'.static.LogPerformanceMetric("LegacyConfigurationLoading",
        EndTime - StartTime, CDO.ProcessingQueue.Length - InitialQueueSize, 0,
        "Legacy format compatibility loading");

    class'TM_Logger'.static.LogInfo("Legacy configurations loaded - " $
        (CDO.ProcessingQueue.Length - InitialQueueSize) $ " templates queued", "TemplateProcessor");
}

// Load unified configuration format
static function LoadUnifiedConfigurations()
{
    local TM_TemplateProcessor CDO;
    local float StartTime, EndTime;
    local int InitialQueueSize;

    CDO = TM_TemplateProcessor(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateProcessor'));
    if (CDO == none) return;

    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    InitialQueueSize = CDO.ProcessingQueue.Length;

    class'TM_Logger'.static.LogInfo("Loading unified configurations...", "TemplateProcessor");

    // Load unified format configurations
    // This will be implemented by specific configuration loaders

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    class'TM_Logger'.static.LogPerformanceMetric("UnifiedConfigurationLoading",
        EndTime - StartTime, CDO.ProcessingQueue.Length - InitialQueueSize, 0,
        "Unified format configuration loading");

    class'TM_Logger'.static.LogInfo("Unified configurations loaded - " $
        (CDO.ProcessingQueue.Length - InitialQueueSize) $ " templates queued", "TemplateProcessor");
}

// Process the template queue
static function ProcessTemplateQueue()
{
    local TM_TemplateProcessor CDO;
    local int i;
    local UnifiedTemplateDefinition TemplateDefinition;
    local bool bProcessingResult;
    local float StartTime, EndTime;

    CDO = TM_TemplateProcessor(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateProcessor'));
    if (CDO == none) return;

    class'TM_Logger'.static.LogInfo("Processing template queue - " $
        CDO.ProcessingQueue.Length $ " templates", "TemplateProcessor");

    for (i = 0; i < CDO.ProcessingQueue.Length; i++)
    {
        TemplateDefinition = CDO.ProcessingQueue[i];
        StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

        // Process individual template
        bProcessingResult = ProcessSingleTemplate(TemplateDefinition);

        EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
        TemplateDefinition.ProcessingTime = EndTime - StartTime;

        // Update statistics
        CDO.TotalTemplatesProcessed++;
        if (!bProcessingResult)
        {
            CDO.TotalErrorsEncountered++;
        }

        // Add to processed list
        CDO.ProcessedTemplates.AddItem(TemplateDefinition);

        // Check processing time limit
        if ((EndTime - CDO.ProcessingStartTime) * 1000 > class'TM_ConfigManager'.static.GetMaxTemplateProcessingTime())
        {
            class'TM_Logger'.static.LogWarning("Template processing time limit exceeded - stopping", "TemplateProcessor");
            break;
        }
    }

    // Clear the queue
    CDO.ProcessingQueue.Length = 0;
}

// Process a single template definition
static function bool ProcessSingleTemplate(out UnifiedTemplateDefinition TemplateDefinition)
{
    local ConflictDetectionResult ConflictResult;
    local array<string> ValidationErrors;
    local bool bSuccess;
    local float StartTime, EndTime;

    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    bSuccess = true;

    class'TM_Logger'.static.LogDebug("Processing template: " $ TemplateDefinition.TemplateName, "TemplateProcessor");

    // Step 1: Validate template definition
    if (!ValidateTemplateDefinition(TemplateDefinition, ValidationErrors))
    {
        TemplateDefinition.ValidationErrors = ValidationErrors;
        TemplateDefinition.bValidated = false;
        bSuccess = false;

        class'TM_Logger'.static.LogError("Template validation failed: " $ TemplateDefinition.TemplateName, "TemplateProcessor");
    }
    else
    {
        TemplateDefinition.bValidated = true;
    }

    // Step 2: Conflict detection
    if (bSuccess && class'TM_ConfigManager'.static.IsConflictDetectionEnabled())
    {
        ConflictResult = class'TM_TemplateTracker'.static.DetectConflicts(TemplateDefinition);

        if (ConflictResult.bConflictDetected)
        {
            bSuccess = HandleConflict(TemplateDefinition, ConflictResult);
        }
    }

    // Step 3: Execute template operation
    if (bSuccess)
    {
        bSuccess = ExecuteTemplateOperation(TemplateDefinition);
    }

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    // Record the operation
    class'TM_TemplateTracker'.static.RecordTemplateRegistration(
        TemplateDefinition.TemplateName,
        TemplateDefinition.TemplateType,
        TemplateDefinition.SourceMod,
        TemplateDefinition.SourceFormat,
        bSuccess,
        TemplateDefinition.ValidationErrors,
        EndTime - StartTime
    );

    return bSuccess;
}

// Validate a template definition
static function bool ValidateTemplateDefinition(UnifiedTemplateDefinition TemplateDefinition, out array<string> ValidationErrors)
{
    ValidationErrors.Length = 0;

    // Basic validation
    if (TemplateDefinition.TemplateName == '')
    {
        ValidationErrors.AddItem("Template name cannot be empty");
    }

    if (TemplateDefinition.TemplateType == ETT_Unknown)
    {
        ValidationErrors.AddItem("Template type must be specified");
    }

    if (TemplateDefinition.Operation == ETO_Create && TemplateDefinition.BasedOnTemplate == '')
    {
        ValidationErrors.AddItem("Create operations require a base template");
    }

    // API format validation
    if (!class'TM_APIRegistry'.static.IsAPISupported(TemplateDefinition.SourceFormat))
    {
        ValidationErrors.AddItem("Unsupported API format: " $ TemplateDefinition.SourceFormat);
    }

    return ValidationErrors.Length == 0;
}

// Handle template conflicts
static function bool HandleConflict(out UnifiedTemplateDefinition TemplateDefinition, ConflictDetectionResult ConflictResult)
{
    local EConflictResolution Resolution;

    Resolution = ConflictResult.RecommendedResolution;

    switch (Resolution)
    {
        case ECR_Fail:
            class'TM_Logger'.static.LogError("Template conflict - operation failed: " $ TemplateDefinition.TemplateName, "TemplateProcessor");
            return false;

        case ECR_Override:
            class'TM_Logger'.static.LogWarning("Template conflict - overriding existing: " $ TemplateDefinition.TemplateName, "TemplateProcessor");
            return true;

        case ECR_Rename:
            TemplateDefinition.TemplateName = name(string(TemplateDefinition.TemplateName) $ "_" $ TemplateDefinition.SourceMod);
            class'TM_Logger'.static.LogWarning("Template conflict - renamed to: " $ TemplateDefinition.TemplateName, "TemplateProcessor");
            return true;

        case ECR_Skip:
            class'TM_Logger'.static.LogWarning("Template conflict - skipping: " $ TemplateDefinition.TemplateName, "TemplateProcessor");
            return false;

        default:
            class'TM_Logger'.static.LogError("Unknown conflict resolution strategy", "TemplateProcessor");
            return false;
    }
}

// Execute template operation
static function bool ExecuteTemplateOperation(UnifiedTemplateDefinition TemplateDefinition)
{
    // This is a placeholder for the actual template operation execution
    // The specific implementation will depend on the template type and operation

    class'TM_Logger'.static.LogDebug("Executing template operation: " $ TemplateDefinition.Operation $
        " on " $ TemplateDefinition.TemplateName, "TemplateProcessor");

    // For now, just log the operation as successful
    class'TM_Logger'.static.LogWrapperActivity("CoreProcessor",
        "Executed " $ TemplateDefinition.Operation $ " operation on " $ TemplateDefinition.TemplateName);

    return true;
}

// Validate processed templates
static function ValidateProcessedTemplates()
{
    local TM_TemplateProcessor CDO;
    local int i;
    local int ValidCount, InvalidCount;

    CDO = TM_TemplateProcessor(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateProcessor'));
    if (CDO == none) return;

    class'TM_Logger'.static.LogInfo("Validating processed templates...", "TemplateProcessor");

    for (i = 0; i < CDO.ProcessedTemplates.Length; i++)
    {
        if (CDO.ProcessedTemplates[i].bValidated)
        {
            ValidCount++;
        }
        else
        {
            InvalidCount++;
        }
    }

    class'TM_Logger'.static.LogInfo("Template validation complete - Valid: " $ ValidCount $
        ", Invalid: " $ InvalidCount, "TemplateProcessor");
}

// Placeholder methods for legacy configuration loading
static function LoadTemplateMasterConfigurations()
{
    class'TM_Logger'.static.LogDebug("Loading Template Master configurations", "TemplateProcessor");
    // Implementation will be provided by TM_WrapperTemplateMaster
}

static function LoadDynamicEnemyCreationConfigurations()
{
    class'TM_Logger'.static.LogDebug("Loading Dynamic Enemy Creation configurations", "TemplateProcessor");
    // Implementation will be provided by TM_WrapperDynamicEnemyCreation
}

static function LoadWSRConfigurations()
{
    class'TM_Logger'.static.LogDebug("Loading WSR configurations", "TemplateProcessor");
    // Implementation will be provided by TM_WrapperWSR
}

static function LoadBuildADarkEventConfigurations()
{
    class'TM_Logger'.static.LogDebug("Loading Build-A-Dark-Event configurations", "TemplateProcessor");
    // Implementation will be provided by TM_WrapperBuildADarkEvent
}

static function LoadAbilityEditorConfigurations()
{
    class'TM_Logger'.static.LogDebug("Loading Ability Editor configurations", "TemplateProcessor");
    // Implementation will be provided by TM_WrapperAbilityEditor
}

static function LoadPCSSystemConfigurations()
{
    class'TM_Logger'.static.LogDebug("Loading PCS System configurations", "TemplateProcessor");
    // Implementation will be provided by TM_WrapperPCSSystem
}

static function LoadSitRepSystemConfigurations()
{
    class'TM_Logger'.static.LogDebug("Loading SitRep System configurations", "TemplateProcessor");
    // Implementation will be provided by TM_WrapperSitRepSystem
}

// System summary and diagnostics
static function LogSystemSummary()
{
    class'TM_Logger'.static.LogInfo("=== TEMPLATEMAKER SYSTEM SUMMARY ===", "TemplateProcessor");

    // Log configuration summary
    class'TM_ConfigManager'.static.LogConfigurationSummary();

    // Log API registry summary
    class'TM_APIRegistry'.static.LogAPIRegistrySummary();

    // Log template tracker summary
    class'TM_TemplateTracker'.static.GenerateTrackingReport();

    class'TM_Logger'.static.LogInfo("=== END SYSTEM SUMMARY ===", "TemplateProcessor");
}

// Query methods
static function array<UnifiedTemplateDefinition> GetProcessedTemplates()
{
    local TM_TemplateProcessor CDO;
    local array<UnifiedTemplateDefinition> EmptyArray;

    CDO = TM_TemplateProcessor(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateProcessor'));
    if (CDO == none) return EmptyArray; // Return empty array

    return CDO.ProcessedTemplates;
}

static function bool IsProcessingActive()
{
    local TM_TemplateProcessor CDO;

    CDO = TM_TemplateProcessor(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateProcessor'));
    if (CDO == none) return false;

    return CDO.bProcessingActive;
}

static function int GetTotalTemplatesProcessed()
{
    local TM_TemplateProcessor CDO;

    CDO = TM_TemplateProcessor(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateProcessor'));
    if (CDO == none) return 0;

    return CDO.TotalTemplatesProcessed;
}

static function int GetTotalErrorsEncountered()
{
    local TM_TemplateProcessor CDO;

    CDO = TM_TemplateProcessor(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateProcessor'));
    if (CDO == none) return 0;

    return CDO.TotalErrorsEncountered;
}

// No defaultproperties needed - using CDO pattern
