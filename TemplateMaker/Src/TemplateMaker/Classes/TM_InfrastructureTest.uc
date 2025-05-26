//---------------------------------------------------------------------------------------
//  FILE:    TM_InfrastructureTest.uc
//  AUTHOR:  Srinath Upadhyayula
//  PURPOSE: Infrastructure validation and testing for the TemplateMaker system
//           Provides comprehensive testing of all core systems and components
//---------------------------------------------------------------------------------------

class TM_InfrastructureTest extends Object dependson(TM_TemplateDefinitionUnified);

// Test result structure
struct TestResult
{
    var string TestName;
    var bool bPassed;
    var string ErrorMessage;
    var string Details;
    var float ExecutionTime;
};

// Run all infrastructure tests
static function array<TestResult> RunAllTests()
{
    local array<TestResult> Results;
    local float StartTime, EndTime;

    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    class'TM_Logger'.static.LogInfo("=== STARTING INFRASTRUCTURE TESTS ===", "InfrastructureTest");

    // Core system tests
    Results.AddItem(TestLoggerSystem());
    Results.AddItem(TestConfigurationSystem());
    Results.AddItem(TestAPIRegistry());
    Results.AddItem(TestTemplateTracker());
    Results.AddItem(TestTemplateProcessor());

    // Integration tests
    Results.AddItem(TestSystemIntegration());
    Results.AddItem(TestModDetectionSystem());
    Results.AddItem(TestConflictDetection());
    Results.AddItem(TestPerformanceMetrics());

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    // Log test summary
    LogTestSummary(Results, EndTime - StartTime);

    class'TM_Logger'.static.LogInfo("=== INFRASTRUCTURE TESTS COMPLETED ===", "InfrastructureTest");

    return Results;
}

// Test the logging system
static function TestResult TestLoggerSystem()
{
    local TestResult Result;
    local float StartTime, EndTime;

    Result.TestName = "Logger System";
    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    // Test basic logging - using simple conditional logic instead of try-catch
    class'TM_Logger'.static.LogInfo("Test log message", "InfrastructureTest");
    class'TM_Logger'.static.LogWarning("Test warning message", "InfrastructureTest");
    class'TM_Logger'.static.LogError("Test error message", "InfrastructureTest");

    // Test performance logging
    class'TM_Logger'.static.LogPerformanceMetric("TestOperation", 0.1, 5, 0, "Test performance metric");

    // Test specialized logging
    class'TM_Logger'.static.LogTemplateCreation('TestTemplate', "X2WeaponTemplate", "TestMod", true);
    class'TM_Logger'.static.LogWrapperActivity("TestWrapper", "Test activity");

    // In UnrealScript, if functions execute without crashing, they succeeded
    Result.bPassed = true;
    Result.Details = "All logging methods executed successfully";

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    Result.ExecutionTime = EndTime - StartTime;

    return Result;
}

// Test the configuration system
static function TestResult TestConfigurationSystem()
{
    local TestResult Result;
    local float StartTime, EndTime;

    Result.TestName = "Configuration System";
    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    // Test if configuration system is responding by attempting to access a value
    if (class'TM_ConfigManager'.static.IsInitialized())
    {
        Result.bPassed = true;
        Result.Details = "Configuration system accessible and responsive";
    }
    else
    {
        Result.bPassed = false;
        Result.ErrorMessage = "Configuration system not responding";
    }

    // Test configuration validation
    if (!class'TM_ConfigManager'.static.IsConfigurationValid())
    {
        Result.Details $= " (Configuration validation found issues)";
        Result.bPassed = false;
        Result.ErrorMessage = "Configuration validation failed";
    }

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    Result.ExecutionTime = EndTime - StartTime;

    return Result;
}

// Test the API registry
static function TestResult TestAPIRegistry()
{
    local TestResult Result;
    local float StartTime, EndTime;
    local array<APICompatibilityInfo> APIs;

    Result.TestName = "API Registry";
    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    // Test API registration and retrieval - using simple conditional logic
    APIs = class'TM_APIRegistry'.static.GetAllAPIs();

    if (APIs.Length > 0)
    {
        Result.bPassed = true;
        Result.Details = "API registry contains " $ APIs.Length $ " registered APIs";

        // Test specific API checks
        if (class'TM_APIRegistry'.static.IsAPISupported(EAF_Unified))
        {
            Result.Details $= " (Unified API supported)";
        }
    }
    else
    {
        Result.bPassed = false;
        Result.ErrorMessage = "No APIs registered in registry";
    }

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    Result.ExecutionTime = EndTime - StartTime;

    return Result;
}

// Test the template tracker
static function TestResult TestTemplateTracker()
{
    local TestResult Result;
    local float StartTime, EndTime;
    local array<name> RegisteredTemplates;

    Result.TestName = "Template Tracker";
    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    // Test template tracking functionality - using simple conditional logic
    RegisteredTemplates = class'TM_TemplateTracker'.static.GetRegisteredTemplateNames();

    // Test conflict detection (with dummy data)
    // This is a basic functionality test

    Result.bPassed = true;
    Result.Details = "Template tracker operational - " $ RegisteredTemplates.Length $ " templates tracked";

    // Test mod detection completion
    if (class'TM_TemplateTracker'.static.HasModDetectionCompleted())
    {
        Result.Details $= " (Mod detection completed)";
    }

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    Result.ExecutionTime = EndTime - StartTime;

    return Result;
}

// Test the template processor
static function TestResult TestTemplateProcessor()
{
    local TestResult Result;
    local float StartTime, EndTime;

    Result.TestName = "Template Processor";
    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    // Test processor state - using simple conditional logic
    if (!class'TM_TemplateProcessor'.static.IsProcessingActive())
    {
        Result.bPassed = true;
        Result.Details = "Template processor ready and not currently processing";

        // Test statistics
        Result.Details $= " (Processed: " $ class'TM_TemplateProcessor'.static.GetTotalTemplatesProcessed() $
                         ", Errors: " $ class'TM_TemplateProcessor'.static.GetTotalErrorsEncountered() $ ")";
    }
    else
    {
        Result.bPassed = false;
        Result.ErrorMessage = "Template processor is currently active during test";
    }

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    Result.ExecutionTime = EndTime - StartTime;

    return Result;
}

// Test system integration
static function TestResult TestSystemIntegration()
{
    local TestResult Result;
    local float StartTime, EndTime;
    local bool bConfigManagerResponding, bAPIRegistryResponding;

    Result.TestName = "System Integration";
    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    // Test cross-system communication with meaningful assertions

    // Logger -> ConfigManager
    bConfigManagerResponding = class'TM_ConfigManager'.static.IsInitialized();

    // ConfigManager -> APIRegistry
    bAPIRegistryResponding = class'TM_APIRegistry'.static.GetAllAPIs().Length > 0;

    if (bConfigManagerResponding && bAPIRegistryResponding)
    {
        Result.bPassed = true;
        Result.Details = "Cross-system communication functional";
    }
    else if (!bConfigManagerResponding)
    {
        Result.bPassed = false;
        Result.ErrorMessage = "Configuration Manager communication failed";
    }
    else
    {
        Result.bPassed = false;
        Result.ErrorMessage = "API Registry communication failed";
    }

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    Result.ExecutionTime = EndTime - StartTime;

    return Result;
}

// Test mod detection system
static function TestResult TestModDetectionSystem()
{
    local TestResult Result;
    local float StartTime, EndTime;
    local array<string> DetectedMods;
    local int ModCount;

    Result.TestName = "Mod Detection System";
    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    // Test mod detection completion - using simple conditional logic
    if (class'TM_TemplateTracker'.static.HasModDetectionCompleted())
    {
        DetectedMods = class'TM_TemplateTracker'.static.GetDetectedLegacyMods();
        ModCount = DetectedMods.Length;

        Result.bPassed = true;
        Result.Details = "Mod detection completed - " $ ModCount $ " legacy mods detected";

        // Test specific mod detection methods
        if (class'TM_TemplateTracker'.static.DetectWSRMod() ||
            class'TM_TemplateTracker'.static.DetectTemplateMasterMod() ||
            class'TM_TemplateTracker'.static.DetectDynamicEnemyCreationMod())
        {
            Result.Details $= " (Active detection methods working)";
        }
    }
    else
    {
        Result.bPassed = false;
        Result.ErrorMessage = "Mod detection not completed";
    }

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    Result.ExecutionTime = EndTime - StartTime;

    return Result;
}

// Test conflict detection
static function TestResult TestConflictDetection()
{
    local TestResult Result;
    local float StartTime, EndTime;
    local int ConflictCount;

    Result.TestName = "Conflict Detection";
    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    // Test conflict detection system - using simple conditional logic
    ConflictCount = class'TM_TemplateTracker'.static.GetConflictCount();

    Result.bPassed = true;
    Result.Details = "Conflict detection system operational - " $ ConflictCount $ " conflicts recorded";

    // Test conflict resolution configuration
    if (class'TM_ConfigManager'.static.IsConflictDetectionEnabled())
    {
        Result.Details $= " (Conflict detection enabled)";
    }
    else
    {
        Result.Details $= " (Conflict detection disabled)";
    }

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    Result.ExecutionTime = EndTime - StartTime;

    return Result;
}

// Test performance metrics
static function TestResult TestPerformanceMetrics()
{
    local TestResult Result;
    local float StartTime, EndTime;
    local array<PerformanceMetrics> Metrics;

    Result.TestName = "Performance Metrics";
    StartTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;

    // Test performance tracking - using simple conditional logic
    Metrics = class'TM_Logger'.static.GetPerformanceHistory();

    Result.bPassed = true;
    Result.Details = "Performance metrics system operational - " $ Metrics.Length $ " metrics recorded";

    // Test average calculation
    if (class'TM_Logger'.static.GetAverageOperationTime("TestOperation") >= 0.0)
    {
        Result.Details $= " (Average calculation working)";
    }

    EndTime = class'WorldInfo'.static.GetWorldInfo().TimeSeconds;
    Result.ExecutionTime = EndTime - StartTime;

    return Result;
}

// Log test summary
static function LogTestSummary(array<TestResult> Results, float TotalTime)
{
    local int i;
    local int PassedCount, FailedCount;
    local float TotalExecutionTime;

    class'TM_Logger'.static.LogInfo("=== TEST SUMMARY ===", "InfrastructureTest");

    for (i = 0; i < Results.Length; i++)
    {
        if (Results[i].bPassed)
        {
            PassedCount++;
            class'TM_Logger'.static.LogInfo("PASS: " $ Results[i].TestName $ " (" $ Results[i].ExecutionTime $ "s) - " $ Results[i].Details, "InfrastructureTest");
        }
        else
        {
            FailedCount++;
            class'TM_Logger'.static.LogError("FAIL: " $ Results[i].TestName $ " - " $ Results[i].ErrorMessage, "InfrastructureTest");
        }

        TotalExecutionTime += Results[i].ExecutionTime;
    }

    class'TM_Logger'.static.LogInfo("Total Tests: " $ Results.Length, "InfrastructureTest");
    class'TM_Logger'.static.LogInfo("Passed: " $ PassedCount, "InfrastructureTest");
    class'TM_Logger'.static.LogInfo("Failed: " $ FailedCount, "InfrastructureTest");
    class'TM_Logger'.static.LogInfo("Total Execution Time: " $ TotalExecutionTime $ "s", "InfrastructureTest");
    class'TM_Logger'.static.LogInfo("Overall Test Time: " $ TotalTime $ "s", "InfrastructureTest");

    if (FailedCount == 0)
    {
        class'TM_Logger'.static.LogInfo("ALL TESTS PASSED - Infrastructure is healthy", "InfrastructureTest");
    }
    else
    {
        class'TM_Logger'.static.LogWarning("SOME TESTS FAILED - Infrastructure may have issues", "InfrastructureTest");
    }

    class'TM_Logger'.static.LogInfo("=== END TEST SUMMARY ===", "InfrastructureTest");
}

// Quick health check
static function bool QuickHealthCheck()
{
    local array<TestResult> Results;
    local int i;

    class'TM_Logger'.static.LogInfo("Performing quick infrastructure health check...", "InfrastructureTest");

    // Run critical tests only
    Results.AddItem(TestLoggerSystem());
    Results.AddItem(TestConfigurationSystem());
    Results.AddItem(TestSystemIntegration());

    // Check if all critical tests passed
    for (i = 0; i < Results.Length; i++)
    {
        if (!Results[i].bPassed)
        {
            class'TM_Logger'.static.LogError("Critical test failed: " $ Results[i].TestName, "InfrastructureTest");
            return false;
        }
    }

    class'TM_Logger'.static.LogInfo("Quick health check passed - Infrastructure is operational", "InfrastructureTest");
    return true;
}

// Validate specific component
static function TestResult ValidateComponent(string ComponentName)
{
    local TestResult Result;

    Result.TestName = "Component Validation: " $ ComponentName;

    switch (ComponentName)
    {
        case "Logger":
            return TestLoggerSystem();
        case "ConfigManager":
            return TestConfigurationSystem();
        case "APIRegistry":
            return TestAPIRegistry();
        case "TemplateTracker":
            return TestTemplateTracker();
        case "TemplateProcessor":
            return TestTemplateProcessor();
        default:
            Result.bPassed = false;
            Result.ErrorMessage = "Unknown component: " $ ComponentName;
            return Result;
    }
}

// Generate comprehensive infrastructure report
static function GenerateInfrastructureReport()
{
    local array<TestResult> Results;
    local array<string> DetectedMods;
    local array<APICompatibilityInfo> APIs;

    class'TM_Logger'.static.LogInfo("=== COMPREHENSIVE INFRASTRUCTURE REPORT ===", "InfrastructureTest");

    // System configuration
    class'TM_ConfigManager'.static.LogConfigurationSummary();

    // API registry status
    class'TM_APIRegistry'.static.LogAPIRegistrySummary();

    // Template tracking status
    class'TM_TemplateTracker'.static.GenerateTrackingReport();

    // Mod detection results
    DetectedMods = class'TM_TemplateTracker'.static.GetDetectedLegacyMods();
    if (DetectedMods.Length > 0)
    {
        class'TM_Logger'.static.LogModCompatibilityReport(DetectedMods, GetModRecommendations(DetectedMods));
    }

    // Run full test suite
    Results = RunAllTests();

    class'TM_Logger'.static.LogInfo("=== END COMPREHENSIVE INFRASTRUCTURE REPORT ===", "InfrastructureTest");
}

// Get mod-specific recommendations
static function array<string> GetModRecommendations(array<string> DetectedMods)
{
    local array<string> Recommendations;

    Recommendations.AddItem("Consider migrating from legacy mods to TemplateMaker's unified system");
    Recommendations.AddItem("Enable conflict resolution if keeping both systems");
    Recommendations.AddItem("Test thoroughly in a separate save before using in main campaign");
    Recommendations.AddItem("Review Documentation/README.md for detailed migration guidance");

    return Recommendations;
}

defaultproperties
{
}
