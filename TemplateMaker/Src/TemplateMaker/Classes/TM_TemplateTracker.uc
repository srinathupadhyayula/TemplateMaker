//---------------------------------------------------------------------------------------
//  FILE:    TM_TemplateTracker.uc
//  AUTHOR:  Srinath Upadhyayula
//  PURPOSE: Template tracking and conflict detection for the TemplateMaker system
//           Provides proactive conflict detection and template operation history
//---------------------------------------------------------------------------------------

class TM_TemplateTracker extends Object dependson(TM_TemplateDefinitionUnified);

// Template registration tracking - simple arrays populated during execution
var array<TemplateRegistrationRecord> RegistrationHistory;
var array<name> RegisteredTemplateNames;

// Conflict detection cache - simple cache for performance optimization
var array<ConflictDetectionResult> ConflictCache;
var int MaxCacheSize;

// Mod detection tracking - simple flags populated during mod detection
var array<string> DetectedLegacyMods;
var bool bModDetectionCompleted;

// Initialize the template tracker
static function Initialize()
{
    local TM_TemplateTracker CDO;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return;

    // Use mod detection completion check instead of bInitialized flag - CDO pattern
    if (CDO.bModDetectionCompleted) return;

    class'TM_Logger'.static.LogInfo("TM_TemplateTracker initializing...", "TemplateTracker");

    CDO.MaxCacheSize = 100;
    CDO.bModDetectionCompleted = false;

    // Perform mod detection during initialization
    DetectLegacyTemplateMods();

    class'TM_Logger'.static.LogInfo("TM_TemplateTracker initialized", "TemplateTracker");
}

// Start mod detection process (called by First phase)
static function StartModDetection()
{
    class'TM_Logger'.static.LogInfo("Starting mod detection process...", "TemplateTracker");

    // Initialize if not already done
    Initialize();

    // Perform mod detection
    DetectLegacyTemplateMods();

    class'TM_Logger'.static.LogInfo("Mod detection process completed", "TemplateTracker");
}

// Check if template tracker is initialized
static function bool IsInitialized()
{
    local TM_TemplateTracker CDO;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return false;

    return CDO.bModDetectionCompleted;
}

// Prepare for main processing (called by Standard phase)
static function PrepareForMainProcessing()
{
    class'TM_Logger'.static.LogInfo("Preparing template tracker for main processing...", "TemplateTracker");

    // Ensure initialization is complete
    if (!IsInitialized())
    {
        Initialize();
    }

    // Clear any temporary data that shouldn't persist into main processing
    // Keep the important tracking data but reset processing-specific state

    class'TM_Logger'.static.LogInfo("Template tracker prepared for main processing", "TemplateTracker");
}

// Record template registration
static function RecordTemplateRegistration(name TemplateName, ETemplateType TemplateType,
    string SourceMod, EAPIFormat SourceFormat, bool bSuccessful, array<string> Errors, float ProcessingTime)
{
    local TM_TemplateTracker CDO;
    local TemplateRegistrationRecord Record;
    local string TimeStamp;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return;

    if (!class'TM_ConfigManager'.static.IsConflictDetectionEnabled()) return;

    // Create registration record
    Record.TemplateName = TemplateName;
    Record.TemplateType = TemplateType;
    Record.SourceMod = SourceMod;
    Record.SourceFormat = SourceFormat;
    Record.bSuccessful = bSuccessful;
    Record.Errors = Errors;
    Record.ProcessingTime = ProcessingTime;

    // Generate timestamp
    TimeStamp = class'WorldInfo'.static.GetWorldInfo().TimeSeconds $ "";
    Record.Timestamp = TimeStamp;

    // Add to history
    CDO.RegistrationHistory.AddItem(Record);

    // Track successful registrations
    if (bSuccessful && CDO.RegisteredTemplateNames.Find(TemplateName) == INDEX_NONE)
    {
        CDO.RegisteredTemplateNames.AddItem(TemplateName);
    }

    // Limit history size
    if (CDO.RegistrationHistory.Length > 1000)
    {
        CDO.RegistrationHistory.Remove(0, 100); // Remove oldest 100 entries
    }

    // Log the registration
    class'TM_Logger'.static.LogTemplateCreation(TemplateName,
        GetTemplateTypeString(TemplateType), SourceMod, bSuccessful);

    class'TM_Logger'.static.LogDebug("Template registration recorded: " $ TemplateName $
        " from " $ SourceMod $ " (" $ (bSuccessful ? "SUCCESS" : "FAILED") $ ")", "TemplateTracker");
}

// Proactive conflict detection
static function ConflictDetectionResult DetectConflicts(UnifiedTemplateDefinition TemplateDefinition)
{
    local ConflictDetectionResult Result;
    local array<string> ConflictingMods;
    local int i;
    local bool bConflictFound;

    if (!class'TM_ConfigManager'.static.IsConflictDetectionEnabled())
    {
        Result.bConflictDetected = false;
        return Result;
    }

    // Initialize result
    Result.bConflictDetected = false;
    Result.ConflictingTemplate = TemplateDefinition.TemplateName;
    Result.ConflictType = "None";

    // Check for name conflicts
    bConflictFound = CheckNameConflict(TemplateDefinition, ConflictingMods);

    if (bConflictFound)
    {
        Result.bConflictDetected = true;
        Result.ConflictingMods = ConflictingMods;
        Result.ConflictType = "TemplateName";
        Result.ConflictDescription = "Template name '" $ TemplateDefinition.TemplateName $
            "' conflicts with existing template(s)";

        // Generate resolution options
        GenerateResolutionOptions(Result, TemplateDefinition);

        // Cache the result
        CacheConflictResult(Result);

        // Log the conflict
        class'TM_Logger'.static.LogConflictDetection(TemplateDefinition.TemplateName, ConflictingMods);
    }

    return Result;
}

// Check for template name conflicts
static function bool CheckNameConflict(UnifiedTemplateDefinition TemplateDefinition, out array<string> ConflictingMods)
{
    local TM_TemplateTracker CDO;
    local int i;
    local bool bConflictFound;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return false;

    bConflictFound = false;
    ConflictingMods.Length = 0;

    // Check against registered templates
    if (CDO.RegisteredTemplateNames.Find(TemplateDefinition.TemplateName) != INDEX_NONE)
    {
        // Find which mods registered this template
        for (i = 0; i < CDO.RegistrationHistory.Length; i++)
        {
            if (CDO.RegistrationHistory[i].TemplateName == TemplateDefinition.TemplateName &&
                CDO.RegistrationHistory[i].bSuccessful &&
                CDO.RegistrationHistory[i].SourceMod != TemplateDefinition.SourceMod)
            {
                if (ConflictingMods.Find(CDO.RegistrationHistory[i].SourceMod) == INDEX_NONE)
                {
                    ConflictingMods.AddItem(CDO.RegistrationHistory[i].SourceMod);
                }
                bConflictFound = true;
            }
        }
    }

    return bConflictFound;
}

// Generate resolution options for conflicts
static function GenerateResolutionOptions(out ConflictDetectionResult Result, UnifiedTemplateDefinition TemplateDefinition)
{
    Result.ResolutionOptions.Length = 0;

    // Add standard resolution options
    Result.ResolutionOptions.AddItem("FAIL - Abort operation and report error");
    Result.ResolutionOptions.AddItem("OVERRIDE - Replace existing template with new definition");
    Result.ResolutionOptions.AddItem("RENAME - Automatically rename new template to avoid conflict");
    Result.ResolutionOptions.AddItem("SKIP - Skip this template and continue processing");

    // Determine recommended resolution based on configuration and context
    switch (class'TM_ConfigManager'.static.GetConflictResolutionStrategy())
    {
        case ECR_Fail:
            Result.RecommendedResolution = ECR_Fail;
            break;
        case ECR_Override:
            Result.RecommendedResolution = ECR_Override;
            break;
        case ECR_Rename:
            Result.RecommendedResolution = ECR_Rename;
            break;
        case ECR_Skip:
            Result.RecommendedResolution = ECR_Skip;
            break;
        default:
            Result.RecommendedResolution = ECR_Fail;
            break;
    }
}

// Cache conflict detection results
static function CacheConflictResult(ConflictDetectionResult Result)
{
    local TM_TemplateTracker CDO;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return;

    CDO.ConflictCache.AddItem(Result);

    // Limit cache size
    if (CDO.ConflictCache.Length > CDO.MaxCacheSize)
    {
        CDO.ConflictCache.Remove(0, 1);
    }
}

// Query methods
static function bool IsTemplateRegistered(name TemplateName)
{
    local TM_TemplateTracker CDO;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return false;

    return CDO.RegisteredTemplateNames.Find(TemplateName) != INDEX_NONE;
}

static function array<TemplateRegistrationRecord> GetRegistrationHistory(optional name TemplateName)
{
    local TM_TemplateTracker CDO;
    local array<TemplateRegistrationRecord> FilteredHistory;
    local int i;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return FilteredHistory; // Return empty array

    if (TemplateName == '')
    {
        return CDO.RegistrationHistory;
    }

    // Filter by template name
    for (i = 0; i < CDO.RegistrationHistory.Length; i++)
    {
        if (CDO.RegistrationHistory[i].TemplateName == TemplateName)
        {
            FilteredHistory.AddItem(CDO.RegistrationHistory[i]);
        }
    }

    return FilteredHistory;
}

static function array<name> GetRegisteredTemplateNames()
{
    local TM_TemplateTracker CDO;
    local array<name> EmptyArray;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return EmptyArray; // Return empty array

    return CDO.RegisteredTemplateNames;
}

static function array<ConflictDetectionResult> GetConflictHistory()
{
    local TM_TemplateTracker CDO;
    local array<ConflictDetectionResult> EmptyArray;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return EmptyArray; // Return empty array

    return CDO.ConflictCache;
}

static function int GetRegistrationCount(optional string SourceMod)
{
    local TM_TemplateTracker CDO;
    local int i, Count;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return 0;

    for (i = 0; i < CDO.RegistrationHistory.Length; i++)
    {
        if (CDO.RegistrationHistory[i].bSuccessful)
        {
            if (SourceMod == "" || CDO.RegistrationHistory[i].SourceMod ~= SourceMod)
            {
                Count++;
            }
        }
    }

    return Count;
}

static function int GetConflictCount()
{
    local TM_TemplateTracker CDO;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return 0;

    return CDO.ConflictCache.Length;
}

// Template validation
static function bool ValidateTemplateIntegrity(name TemplateName)
{
    local array<TemplateRegistrationRecord> Records;
    local int i;
    local bool bValid;

    Records = GetRegistrationHistory(TemplateName);
    bValid = false;

    // Check if template was successfully registered
    for (i = 0; i < Records.Length; i++)
    {
        if (Records[i].bSuccessful)
        {
            bValid = true;
            break;
        }
    }

    if (!bValid)
    {
        class'TM_Logger'.static.LogWarning("Template integrity check failed for: " $ TemplateName, "TemplateTracker");
    }

    return bValid;
}

// Utility methods
static function string GetTemplateTypeString(ETemplateType TemplateType)
{
    switch (TemplateType)
    {
        case ETT_Character:  return "X2CharacterTemplate";
        case ETT_Weapon:     return "X2WeaponTemplate";
        case ETT_Armor:      return "X2ArmorTemplate";
        case ETT_Item:       return "X2ItemTemplate";
        case ETT_Equipment:  return "X2EquipmentTemplate";
        case ETT_Ability:    return "X2AbilityTemplate";
        case ETT_Effect:     return "X2EffectTemplate";
        case ETT_DarkEvent:  return "X2DarkEventTemplate";
        case ETT_SitRep:     return "X2SitRepTemplate";
        default:             return "UnknownTemplate";
    }
}

// Performance and statistics
static function float GetAverageProcessingTime(optional string SourceMod)
{
    local TM_TemplateTracker CDO;
    local int i, Count;
    local float Total;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return 0.0;

    for (i = 0; i < CDO.RegistrationHistory.Length; i++)
    {
        if (SourceMod == "" || CDO.RegistrationHistory[i].SourceMod ~= SourceMod)
        {
            Total += CDO.RegistrationHistory[i].ProcessingTime;
            Count++;
        }
    }

    return Count > 0 ? Total / Count : 0.0;
}

// Mod detection system
static function DetectLegacyTemplateMods()
{
    local TM_TemplateTracker CDO;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return;

    class'TM_Logger'.static.LogInfo("Starting legacy template mod detection...", "TemplateTracker");

    CDO.DetectedLegacyMods.Length = 0;

    // Detect specific legacy mods
    if (DetectWSRMod())
        CDO.DetectedLegacyMods.AddItem("Weapon Skin Replacer (WSR)");

    if (DetectTemplateMasterMod())
        CDO.DetectedLegacyMods.AddItem("Template Master (WOTCIridarTemplateMaster)");

    if (DetectDynamicEnemyCreationMod())
        CDO.DetectedLegacyMods.AddItem("Dynamic Enemy Creation");

    if (DetectBuildADarkEventMod())
        CDO.DetectedLegacyMods.AddItem("Build-A-Dark-Event");

    if (DetectAbilityEditorMod())
        CDO.DetectedLegacyMods.AddItem("Ability Editor");

    if (DetectCreateCustomAbilitiesMod())
        CDO.DetectedLegacyMods.AddItem("Create Custom Abilities");

    if (DetectDarkEventManagerMod())
        CDO.DetectedLegacyMods.AddItem("Dark Event Manager");

    CDO.bModDetectionCompleted = true;

    class'TM_Logger'.static.LogInfo("Legacy mod detection completed - " $ CDO.DetectedLegacyMods.Length $ " mods detected", "TemplateTracker");

    // Log detected mods for user awareness
    if (CDO.DetectedLegacyMods.Length > 0)
    {
        LogDetectedMods();
    }
}

static function bool DetectWSRMod()
{
    // Check for WSR mod using proper XCOM 2 mod detection
    return IsModInstalled("zzzWeaponSkinReplacer") || IsModInstalled("WeaponSkinReplacer");
}

static function bool DetectTemplateMasterMod()
{
    // Check for Template Master mod using proper XCOM 2 mod detection
    return IsModInstalled("WOTCIridarTemplateMaster");
}

static function bool DetectDynamicEnemyCreationMod()
{
    // Check for Dynamic Enemy Creation mod using proper XCOM 2 mod detection
    return IsModInstalled("DynamicEnemyCreation");
}

static function bool DetectBuildADarkEventMod()
{
    // Check for Build-A-Dark-Event mod using proper XCOM 2 mod detection
    return IsModInstalled("BuildADarkEvent");
}

static function bool DetectAbilityEditorMod()
{
    // Check for Ability Editor mod using proper XCOM 2 mod detection
    return IsModInstalled("AbilityEditor");
}

static function bool DetectCreateCustomAbilitiesMod()
{
    // Check for Create Custom Abilities mod using proper XCOM 2 mod detection
    return IsModInstalled("CreateCustomAbilities");
}

static function bool DetectDarkEventManagerMod()
{
    // Check for Dark Event Manager mod using proper XCOM 2 mod detection
    return IsModInstalled("DarkEventManager");
}

// Helper function for proper XCOM 2 mod detection using Community Highlander pattern
static function bool IsModInstalled(string ModDLCName)
{
    local array<X2DownloadableContentInfo> DLCInfos;
    local int i;

    // Use the proper Community Highlander pattern for mod detection
    DLCInfos = `ONLINEEVENTMGR.GetDLCInfos(false);

    for (i = 0; i < DLCInfos.Length; ++i)
    {
        if (DLCInfos[i].DLCIdentifier ~= ModDLCName)
        {
            return true;
        }
    }

    return false;
}

static function LogDetectedMods()
{
    local TM_TemplateTracker CDO;
    local int i;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return;

    class'TM_Logger'.static.LogWarning("=== LEGACY TEMPLATE MODS DETECTED ===", "TemplateTracker");

    for (i = 0; i < CDO.DetectedLegacyMods.Length; i++)
    {
        class'TM_Logger'.static.LogWarning("DETECTED: " $ CDO.DetectedLegacyMods[i], "TemplateTracker");
    }

    class'TM_Logger'.static.LogWarning("These mods may conflict with TemplateMaker's unified system", "TemplateTracker");
    class'TM_Logger'.static.LogWarning("Consider enabling conflict resolution or migrating to TemplateMaker", "TemplateTracker");
    class'TM_Logger'.static.LogWarning("=== END LEGACY MOD DETECTION ===", "TemplateTracker");
}

// Mod detection query methods
static function bool HasModDetectionCompleted()
{
    local TM_TemplateTracker CDO;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return false;

    return CDO.bModDetectionCompleted;
}

static function array<string> GetDetectedLegacyMods()
{
    local TM_TemplateTracker CDO;
    local array<string> EmptyArray;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return EmptyArray; // Return empty array

    return CDO.DetectedLegacyMods;
}

static function bool IsLegacyModDetected(string ModName)
{
    local TM_TemplateTracker CDO;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return false;

    return CDO.DetectedLegacyMods.Find(ModName) != INDEX_NONE;
}

static function int GetDetectedModCount()
{
    local TM_TemplateTracker CDO;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return 0;

    return CDO.DetectedLegacyMods.Length;
}

// Generate comprehensive tracking report
static function GenerateTrackingReport()
{
    local TM_TemplateTracker CDO;
    local int i;
    local float TotalProcessingTime;

    CDO = TM_TemplateTracker(class'XComEngine'.static.GetClassDefaultObject(class'TM_TemplateTracker'));
    if (CDO == none) return;

    class'TM_Logger'.static.LogInfo("=== TEMPLATE TRACKING REPORT ===", "TemplateTracker");
    class'TM_Logger'.static.LogInfo("Total Registered Templates: " $ CDO.RegisteredTemplateNames.Length, "TemplateTracker");
    class'TM_Logger'.static.LogInfo("Total Registration Attempts: " $ CDO.RegistrationHistory.Length, "TemplateTracker");
    class'TM_Logger'.static.LogInfo("Total Conflicts Detected: " $ CDO.ConflictCache.Length, "TemplateTracker");
    class'TM_Logger'.static.LogInfo("Legacy Mods Detected: " $ CDO.DetectedLegacyMods.Length, "TemplateTracker");

    // Calculate total processing time
    for (i = 0; i < CDO.RegistrationHistory.Length; i++)
    {
        TotalProcessingTime += CDO.RegistrationHistory[i].ProcessingTime;
    }

    class'TM_Logger'.static.LogInfo("Total Processing Time: " $ TotalProcessingTime $ "s", "TemplateTracker");
    class'TM_Logger'.static.LogInfo("Average Processing Time: " $ GetAverageProcessingTime() $ "s", "TemplateTracker");

    // List detected legacy mods
    if (CDO.DetectedLegacyMods.Length > 0)
    {
        class'TM_Logger'.static.LogInfo("Detected Legacy Mods:", "TemplateTracker");
        for (i = 0; i < CDO.DetectedLegacyMods.Length; i++)
        {
            class'TM_Logger'.static.LogInfo("  - " $ CDO.DetectedLegacyMods[i], "TemplateTracker");
        }
    }

    class'TM_Logger'.static.LogInfo("=== END TEMPLATE TRACKING REPORT ===", "TemplateTracker");
}

defaultproperties
{
    // NOTE: No defaultproperties needed anymore!
    // All variables are now runtime state, not config variables
    // MaxCacheSize and bModDetectionCompleted are set in Initialize()
}
