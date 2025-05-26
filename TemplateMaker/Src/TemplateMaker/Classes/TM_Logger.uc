//---------------------------------------------------------------------------------------
//  FILE:    TM_Logger.uc
//  AUTHOR:  Srinath Upadhyayula
//  PURPOSE: Enhanced logging infrastructure for the TemplateMaker system
//           Provides comprehensive logging with performance monitoring and transparency
//---------------------------------------------------------------------------------------

class TM_Logger extends Object dependson(TM_TemplateDefinitionUnified);

// Log level enumeration
enum ELogLevel
{
    ELL_Error,      // Critical errors that prevent operation
    ELL_Warning,    // Non-critical issues that should be noted
    ELL_Info,       // General information about operations
    ELL_Debug,      // Detailed debugging information
    ELL_Verbose     // Extremely detailed information for troubleshooting
};

// Configuration variables - hardcoded values (not config variables)
// All configuration is now read from TM_ConfigManager to avoid duplication
var name LogCategory;                          // Category for log messages (hardcoded)
var int MaxLogEntries;                         // Maximum log entries to keep in memory (hardcoded)

// Performance tracking - simple arrays populated during execution
var array<PerformanceMetrics> PerformanceHistory;
var float SessionStartTime;

// Log entry tracking - simple cache for recent log entries
var array<string> RecentLogEntries;
var int LogEntryIndex;

// Initialize the logging system
static function Initialize()
{
    local TM_Logger CDO;

    CDO = TM_Logger(class'XComEngine'.static.GetClassDefaultObject(class'TM_Logger'));
    if (CDO == none) return;

    // Prevent multiple initializations
    if (CDO.SessionStartTime > 0.0) return;

    // Set hardcoded values
    CDO.LogCategory = 'TemplateMaker';
    CDO.MaxLogEntries = 100;

    CDO.SessionStartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    // Only show initialization message in debug/verbose mode
    LogDebug("TM_Logger initialized - Session started", "Logger");
    LogPerformanceMetric("LoggerInitialization", 0.0, 1, 0, "Logger system startup");
}

// Legacy compatibility method
static function Init()
{
    Initialize();
}

// Legacy compatibility method
static function Log(string Message)
{
    LogInfo(Message);
}

// Core logging methods with level checking
static function LogError(string Message, optional string Context)
{
    if (ShouldLog(ELL_Error))
    {
        InternalLog(ELL_Error, Message, Context);
    }
}

static function LogWarning(string Message, optional string Context)
{
    if (ShouldLog(ELL_Warning))
    {
        InternalLog(ELL_Warning, Message, Context);
    }
}

static function LogInfo(string Message, optional string Context)
{
    if (ShouldLog(ELL_Info))
    {
        InternalLog(ELL_Info, Message, Context);
    }
}

static function LogDebug(string Message, optional string Context)
{
    if (ShouldLog(ELL_Debug))
    {
        InternalLog(ELL_Debug, Message, Context);
    }
}

static function LogVerbose(string Message, optional string Context)
{
    if (ShouldLog(ELL_Verbose))
    {
        InternalLog(ELL_Verbose, Message, Context);
    }
}

// Legacy compatibility methods
static function LogObject(string Message, Object Obj)
{
    local string ObjectInfo;

    if (Obj != none)
    {
        ObjectInfo = Message $ " - " $ Obj.Class.Name $ " (" $ Obj.Name $ ")";
    }
    else
    {
        ObjectInfo = Message $ " - None";
    }

    LogInfo(ObjectInfo);
}

static function LogArray(string Message, array<string> Arr)
{
    local string ArrayInfo;
    local int i;

    ArrayInfo = Message $ " - Array[" $ Arr.Length $ "]:";
    LogInfo(ArrayInfo);

    for (i = 0; i < Arr.Length; i++)
    {
        LogInfo("  [" $ i $ "]: " $ Arr[i]);
    }
}

static function string ArrayToString(array<name> NameArray)
{
    local string Result;
    local int i;

    if (NameArray.Length == 0)
    {
        return "[]";
    }

    Result = "[";
    for (i = 0; i < NameArray.Length; i++)
    {
        Result $= "'" $ NameArray[i] $ "'";
        if (i < NameArray.Length - 1)
        {
            Result $= ", ";
        }
    }
    Result $= "]";

    return Result;
}

static function LogValue(string PropertyName, coerce string Value)
{
    LogInfo(PropertyName $ ": " $ Value);
}

static function string FormatMessage(string Level, string Message)
{
    return "[" $ Level $ "] " $ Message;
}

// Template operation logging
static function LogTemplateCreation(name TemplateName, string TemplateClass, string SourceMod, bool bSuccess)
{
    local string Message;

    // Get setting from ConfigManager instead of own config
    if (!class'TM_ConfigManager'.static.IsTemplateCreationLoggingEnabled()) return;

    Message = "Template " $ (bSuccess ? "Created" : "Failed") $ ": " $ TemplateName $
              " (Class: " $ TemplateClass $ ", Mod: " $ SourceMod $ ")";

    if (bSuccess)
        LogInfo(Message, "TemplateCreation");
    else
        LogError(Message, "TemplateCreation");
}

static function LogWrapperActivity(string WrapperName, string Activity)
{
    // Get setting from ConfigManager instead of own config
    if (!class'TM_ConfigManager'.static.IsWrapperBehaviorLoggingEnabled()) return;

    LogInfo("Wrapper[" $ WrapperName $ "]: " $ Activity, "WrapperBehavior");
}

static function LogConflictDetection(name TemplateName, array<string> ConflictingMods)
{
    local string Message;
    local int i;

    // Get setting from ConfigManager instead of own config
    if (!class'TM_ConfigManager'.static.IsConflictResolutionLoggingEnabled()) return;

    Message = "Conflict detected for template '" $ TemplateName $ "' between mods: ";
    for (i = 0; i < ConflictingMods.Length; i++)
    {
        Message $= ConflictingMods[i];
        if (i < ConflictingMods.Length - 1)
            Message $= ", ";
    }

    LogWarning(Message, "ConflictDetection");
}

static function LogPerformanceMetric(string Operation, float ExecutionTime, int TemplatesProcessed, int ErrorsFound, optional string AdditionalInfo)
{
    local TM_Logger CDO;
    local PerformanceMetrics Metrics;
    local string Message;

    CDO = TM_Logger(class'XComEngine'.static.GetClassDefaultObject(class'TM_Logger'));
    if (CDO == none) return;

    // Get setting from ConfigManager instead of own config
    if (!class'TM_ConfigManager'.static.IsPerformanceLoggingEnabled()) return;

    // Create performance record
    Metrics.OperationName = Operation;
    Metrics.Duration = ExecutionTime;
    Metrics.TemplatesProcessed = TemplatesProcessed;
    Metrics.ErrorsEncountered = ErrorsFound;
    Metrics.AdditionalInfo = AdditionalInfo;
    Metrics.StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds - ExecutionTime;
    Metrics.EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    // Store in history
    CDO.PerformanceHistory.AddItem(Metrics);

    // Limit history size
    if (CDO.PerformanceHistory.Length > 100)
    {
        CDO.PerformanceHistory.Remove(0, 1);
    }

    // Log performance information
    Message = "Performance[" $ Operation $ "]: " $ ExecutionTime $ "s, " $
              TemplatesProcessed $ " templates, " $ ErrorsFound $ " errors";
    if (AdditionalInfo != "")
        Message $= " (" $ AdditionalInfo $ ")";

    LogDebug(Message, "Performance");
}

static function LogConfigurationParsing(string ConfigFile, int EntriesProcessed, int ErrorsFound)
{
    local string Message;

    Message = "Configuration parsed: " $ ConfigFile $ " - " $ EntriesProcessed $
              " entries processed, " $ ErrorsFound $ " errors found";

    if (ErrorsFound > 0)
        LogWarning(Message, "ConfigParsing");
    else
        LogInfo(Message, "ConfigParsing");
}

// Wrapper behavior transparency logging
static function LogWrapperTranslation(string LegacyFormat, string UnifiedFormat, string TranslationDetails)
{
    local string Message;

    // Get setting from ConfigManager instead of own config
    if (!class'TM_ConfigManager'.static.IsWrapperBehaviorLoggingEnabled()) return;

    Message = "Translation: " $ LegacyFormat $ " -> " $ UnifiedFormat;
    if (TranslationDetails != "")
        Message $= " (" $ TranslationDetails $ ")";

    LogDebug(Message, "WrapperTranslation");
}

static function LogAPICompatibilityCheck(string APIFormat, bool bCompatible, string Details)
{
    local string Message;

    Message = "API Compatibility[" $ APIFormat $ "]: " $ (bCompatible ? "PASS" : "FAIL");
    if (Details != "")
        Message $= " - " $ Details;

    if (bCompatible)
        LogDebug(Message, "APICompatibility");
    else
        LogWarning(Message, "APICompatibility");
}

// Error reporting and troubleshooting
static function LogDetailedError(string ErrorContext, string ErrorMessage, string SuggestedResolution)
{
    local string Message;

    Message = "ERROR in " $ ErrorContext $ ": " $ ErrorMessage;
    if (SuggestedResolution != "")
        Message $= " | Suggested fix: " $ SuggestedResolution;

    LogError(Message, "DetailedError");
}

static function GenerateTroubleshootingReport(string ProblemDescription)
{
    local TM_Logger CDO;
    local int i;
    local string Report;

    CDO = TM_Logger(class'XComEngine'.static.GetClassDefaultObject(class'TM_Logger'));
    if (CDO == none) return;

    LogInfo("=== TROUBLESHOOTING REPORT ===", "TroubleshootingReport");
    LogInfo("Problem: " $ ProblemDescription, "TroubleshootingReport");
    LogInfo("Session Duration: " $ (class'WorldInfo'.static.GetWorldInfo().TimeSeconds - CDO.SessionStartTime) $ "s", "TroubleshootingReport");

    // Recent performance metrics
    LogInfo("Recent Performance Metrics:", "TroubleshootingReport");
    for (i = Max(0, CDO.PerformanceHistory.Length - 5); i < CDO.PerformanceHistory.Length; i++)
    {
        Report = "  " $ CDO.PerformanceHistory[i].OperationName $ ": " $
                 CDO.PerformanceHistory[i].Duration $ "s";
        LogInfo(Report, "TroubleshootingReport");
    }

    // Recent log entries
    LogInfo("Recent Log Entries:", "TroubleshootingReport");
    for (i = Max(0, CDO.RecentLogEntries.Length - 10); i < CDO.RecentLogEntries.Length; i++)
    {
        LogInfo("  " $ CDO.RecentLogEntries[i], "TroubleshootingReport");
    }

    LogInfo("=== END TROUBLESHOOTING REPORT ===", "TroubleshootingReport");
}

// Mod conflict detection and warning system
static function LogModConflictWarning(string ModName, string ConflictType, string Recommendation)
{
    local string WarningMessage;

    WarningMessage = "MOD CONFLICT DETECTED: " $ ModName $ " - " $ ConflictType;
    LogWarning(WarningMessage, "ModConflictDetection");

    if (Recommendation != "")
    {
        LogWarning("RECOMMENDATION: " $ Recommendation, "ModConflictDetection");
    }
}

static function LogLegacyModDetected(string ModName, string ModClass, string Impact, string Guidance)
{
    LogWarning("LEGACY MOD DETECTED: " $ ModName $ " (" $ ModClass $ ")", "LegacyModDetection");
    LogWarning("POTENTIAL IMPACT: " $ Impact, "LegacyModDetection");
    LogWarning("GUIDANCE: " $ Guidance, "LegacyModDetection");
}

static function LogModCompatibilityReport(array<string> DetectedMods, array<string> Recommendations)
{
    local int i;

    LogWarning("=== MOD COMPATIBILITY REPORT ===", "ModCompatibility");

    if (DetectedMods.Length > 0)
    {
        LogWarning("DETECTED LEGACY TEMPLATE MODS:", "ModCompatibility");
        for (i = 0; i < DetectedMods.Length; i++)
        {
            LogWarning("  - " $ DetectedMods[i], "ModCompatibility");
        }

        LogWarning("RECOMMENDATIONS:", "ModCompatibility");
        for (i = 0; i < Recommendations.Length; i++)
        {
            LogWarning("  " $ (i + 1) $ ". " $ Recommendations[i], "ModCompatibility");
        }

        LogWarning("For detailed conflict resolution, enable ConflictResolutionStrategy in TemplateMaker configuration", "ModCompatibility");
    }
    else
    {
        LogInfo("No conflicting legacy template mods detected", "ModCompatibility");
    }

    LogWarning("=== END MOD COMPATIBILITY REPORT ===", "ModCompatibility");
}

static function LogConflictResolutionGuidance()
{
    LogWarning("=== CONFLICT RESOLUTION GUIDANCE ===", "ConflictGuidance");
    LogWarning("If you experience template conflicts, consider these options:", "ConflictGuidance");
    LogWarning("1. Set ConflictResolutionStrategy=ECR_Override in TemplateMaker configuration", "ConflictGuidance");
    LogWarning("2. Disable legacy mods and use TemplateMaker's unified system instead", "ConflictGuidance");
    LogWarning("3. Enable bEnableConflictDetection=true for detailed conflict logging", "ConflictGuidance");
    LogWarning("4. Review Documentation/README.md for migration guidance", "ConflictGuidance");
    LogWarning("=== END CONFLICT RESOLUTION GUIDANCE ===", "ConflictGuidance");
}

// Utility methods - Now reads from TM_ConfigManager instead of own config
static function bool ShouldLog(ELogLevel Level)
{
    // Get logging settings from ConfigManager instead of own config variables
    return true && (Level <= class'TM_ConfigManager'.static.GetLogLevel());
}

static function string GetLogLevelString(ELogLevel Level)
{
    switch (Level)
    {
        case ELL_Error:   return "ERROR";
        case ELL_Warning: return "WARN";
        case ELL_Info:    return "INFO";
        case ELL_Debug:   return "DEBUG";
        case ELL_Verbose: return "VERBOSE";
        default:          return "UNKNOWN";
    }
}

static function InternalLog(ELogLevel Level, string Message, optional string Context)
{
    local TM_Logger CDO;
    local string FormattedMessage;

    CDO = TM_Logger(class'XComEngine'.static.GetClassDefaultObject(class'TM_Logger'));
    if (CDO == none) return;

    // Format the message
    FormattedMessage = "[" $ GetLogLevelString(Level) $ "]";
    if (Context != "")
        FormattedMessage $= "[" $ Context $ "]";
    FormattedMessage $= " " $ Message;

    // Add to recent entries
    CDO.RecentLogEntries.AddItem(FormattedMessage);
    if (CDO.RecentLogEntries.Length > CDO.MaxLogEntries)
    {
        CDO.RecentLogEntries.Remove(0, 1);
    }

    // Output to game log
    `log(FormattedMessage,, CDO.LogCategory);
}

// Get performance statistics
static function array<PerformanceMetrics> GetPerformanceHistory()
{
    local TM_Logger CDO;
    local array<PerformanceMetrics> EmptyArray;

    CDO = TM_Logger(class'XComEngine'.static.GetClassDefaultObject(class'TM_Logger'));
    if (CDO == none) return EmptyArray; // Return empty array

    return CDO.PerformanceHistory;
}

static function float GetAverageOperationTime(string OperationName)
{
    local TM_Logger CDO;
    local int i, Count;
    local float Total;

    CDO = TM_Logger(class'XComEngine'.static.GetClassDefaultObject(class'TM_Logger'));
    if (CDO == none) return 0.0;

    for (i = 0; i < CDO.PerformanceHistory.Length; i++)
    {
        if (CDO.PerformanceHistory[i].OperationName == OperationName)
        {
            Total += CDO.PerformanceHistory[i].Duration;
            Count++;
        }
    }

    return Count > 0 ? Total / Count : 0.0;
}

defaultproperties
{
    // NOTE: No config variables here anymore!
    // All configuration is now read from TM_ConfigManager
    // Only hardcoded defaults remain
    LogCategory='TemplateMaker'
    MaxLogEntries=100
}
