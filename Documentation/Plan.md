# TemplateMaker Unified System - Complete Implementation Plan

## Overview

This document provides the complete implementation plan for the unified TemplateMaker system, designed to consolidate XCOM 2 template functionality from multiple mods while maintaining 100% backward compatibility through comprehensive wrapper classes.

## 1. Technical Architecture Implementation

### 1.1 Corrected File Structure

All .uc files must be placed directly under `Src/TemplateMaker/Classes/` (no subdirectories):

```Directory Structure
TemplateMaker/
├── Src/TemplateMaker/Classes/
│   ├── TM_CoreConfigManager.uc                    // Enhanced configuration management
│   ├── TM_CoreLogger.uc                          // Comprehensive logging system
│   ├── TM_CoreTemplateTracker.uc                 // Proactive conflict detection
│   ├── TM_CoreTemplateProcessor.uc               // Core template processing pipeline
│   ├── TM_CoreAPIRegistry.uc                     // API compatibility registry
│   ├── TM_WrapperTemplateMaster.uc               // EditTemplateStruct compatibility
│   ├── TM_WrapperDynamicEnemyCreation.uc         // UnitDefinition compatibility
│   ├── TM_WrapperWSR.uc                          // GIVE_ABILITIES/CHANGE_TEMPLATE compatibility
│   ├── TM_WrapperBuildADarkEvent.uc              // AbilityDarkEvent compatibility
│   ├── TM_WrapperAbilityEditor.uc                // AbilityNames compatibility
│   ├── TM_WrapperPCSSystem.uc                    // X2EquipmentTemplate PCS compatibility
│   ├── TM_WrapperSitRepSystem.uc                 // X2SitRepTemplate compatibility
│   ├── TM_TemplateDefinitionUnified.uc           // Unified template definition structure
│   ├── TM_CreatorCharacterTemplate.uc            // Character template creation
│   ├── TM_CreatorAbilityTemplate.uc              // Ability template creation
│   ├── TM_CreatorItemTemplate.uc                 // Item/PCS template creation
│   ├── TM_CreatorDarkEventTemplate.uc            // Dark event template creation
│   ├── TM_CreatorSitRepTemplate.uc               // SitRep template creation
│   ├── TM_ProcessorConfig.uc                     // Configuration file processing
│   ├── TM_ProcessorValidation.uc                 // Template validation
│   ├── TM_ProcessorConflictResolver.uc           // Template conflict resolution
│   └── X2DownloadableContentInfo_TemplateMaker.uc // Main DLC integration point
├── Config/
│   ├── XComTemplateMaker.ini                     // Main TemplateMaker configuration
│   ├── XComTemplateEditor.ini                    // Template Master compatibility
│   ├── XComTemplateCreator.ini                   // Template Creator compatibility
│   ├── XComWeaponSkinReplacer.ini                // WSR compatibility
│   ├── XComAbilityDarkEvents.ini                 // Build-A-Dark-Event compatibility
│   ├── XComAbilityEditor.ini                     // Ability Editor compatibility
│   └── TemplateMaker/
│       ├── UnifiedTemplateDefinitions.ini        // New unified format
│       ├── ConflictResolution.ini                // Conflict detection settings
│       └── APICompatibility.ini                  // API preservation settings
```

### 1.2 Core Template Processing Pipeline

**Task ID: [TBD]** - Core Template Processing Pipeline Implementation

```unrealscript
class TM_CoreTemplateProcessor extends Object config(TemplateMaker);

enum ETemplateOperation
{
    ETO_Create,
    ETO_Modify,
    ETO_Replace,
    ETO_Delete
};

enum ETemplateType
{
    ETT_Character,
    ETT_Ability,
    ETT_Item,
    ETT_Equipment,
    ETT_DarkEvent,
    ETT_SitRep,
    ETT_Unknown
};

struct UnifiedTemplateDefinition
{
    var ETemplateOperation Operation;
    var ETemplateType TemplateType;
    var name TemplateName;
    var string TemplateClass;
    var string SourceMod;
    var string SourceConfigFile;
    var array<PropertyModification> Properties;
    var array<string> Dependencies;
    var bool bValidated;
    var string ValidationErrors;
};

struct PropertyModification
{
    var string PropertyName;
    var string PropertyValue;
    var string PropertyType;
    var int ArrayIndex;
    var bool bIsArrayOperation;
    var string Operation; // "Set", "Add", "Remove", "Replace"
};

// Core processing pipeline
static function ProcessAllTemplateDefinitions()
{
    local array<UnifiedTemplateDefinition> AllDefinitions;

    // Phase 1: Load and parse all configuration formats
    LoadLegacyConfigurations(AllDefinitions);
    LoadUnifiedConfigurations(AllDefinitions);

    // Phase 2: Validate and resolve dependencies
    ValidateDefinitions(AllDefinitions);
    ResolveDependencies(AllDefinitions);

    // Phase 3: Detect and resolve conflicts
    DetectConflicts(AllDefinitions);
    ResolveConflicts(AllDefinitions);

    // Phase 4: Execute template operations
    ExecuteTemplateOperations(AllDefinitions);

    // Phase 5: Post-processing validation
    ValidateCreatedTemplates();
}
```

### 1.3 Template Tracker Implementation

**Task ID: [TBD]** - Template Tracker and Conflict Detection System

```unrealscript
class TM_CoreTemplateTracker extends Object config(TemplateMaker);

struct TemplateRegistrationRecord
{
    var name TemplateName;
    var string TemplateClass;
    var string SourceMod;
    var string SourceConfigFile;
    var string CreationTimestamp;
    var bool bSuccessful;
    var string FailureReason;
    var bool bWasReplacement;
    var ETemplateOperation Operation;
    var string ConflictResolution;
};

struct ConflictDetectionResult
{
    var bool bConflictDetected;
    var array<TemplateRegistrationRecord> ConflictingRecords;
    var string RecommendedResolution;
    var string ConflictSeverity; // "Warning", "Error", "Critical"
};

var config array<TemplateRegistrationRecord> TemplateRegistry;
var config bool bEnableConflictDetection;
var config bool bEnablePreventiveDuplicateDetection;
var config string ConflictResolutionStrategy;

// Core tracking methods
static function RecordTemplateOperation(UnifiedTemplateDefinition Definition, bool bSuccess, optional string FailureReason);
static function ConflictDetectionResult CheckForConflicts(UnifiedTemplateDefinition Definition);
static function array<TemplateRegistrationRecord> GetTemplateHistory(name TemplateName);
static function GenerateComprehensiveConflictReport();
static function bool ValidateTemplateIntegrity();
```

## 2. API Preservation Strategy

### 2.1 Wrapper Class Specifications

#### 2.1.1 TM_WrapperTemplateMaster (EditTemplateStruct Compatibility)

**Task ID: task-184** - Template Master Wrapper Implementation

```unrealscript
class TM_WrapperTemplateMaster extends Object config(TemplateMaker);

struct EditTemplateStruct
{
    var string TemplateName;
    var string Property;
    var string Operation;
    var string Value;
    var int Index;
    var string ArrayOperation;
};

// Legacy configuration processing
static function ProcessTemplateMasterConfigurations()
{
    local array<EditTemplateStruct> FirstPassEdits;
    local array<EditTemplateStruct> StandardPassEdits;
    local array<EditTemplateStruct> LastPassEdits;

    // Load from legacy configuration sections
    LoadEditTemplateStructs("WOTCIridarTemplateMaster.X2DLCInfo_First", FirstPassEdits);
    LoadEditTemplateStructs("WOTCIridarTemplateMaster.X2DLCInfo_Standard", StandardPassEdits);
    LoadEditTemplateStructs("WOTCIridarTemplateMaster.X2DLCInfo_Last", LastPassEdits);

    // Convert to unified format and process
    ConvertToUnifiedFormat(FirstPassEdits, ETO_Modify, "TemplateMaster_First");
    ConvertToUnifiedFormat(StandardPassEdits, ETO_Modify, "TemplateMaster_Standard");
    ConvertToUnifiedFormat(LastPassEdits, ETO_Modify, "TemplateMaster_Last");

    // Log wrapper behavior
    class'TM_CoreLogger'.static.LogWrapperActivity("TemplateMasterWrapper",
        "Processed " $ (FirstPassEdits.Length + StandardPassEdits.Length + LastPassEdits.Length) $ " EditTemplateStruct entries");
}
```

#### 2.1.2 TM_WrapperDynamicEnemyCreation (UnitDefinition Compatibility)

**Task ID: task-184** - Dynamic Enemy Creation Wrapper Implementation

```unrealscript
class TM_WrapperDynamicEnemyCreation extends Object config(TemplateMaker);

struct UnitDefinition
{
    var string UnitArchetype;
    var name UnitName;
    var string MovementPreset;
    var string CustomAIRoot;
    var bool bIsAdvent;
    var bool bIsAlien;
    var bool bIsRobotic;
    var bool bIsPsionic;
    var bool bIsTurret;
    var bool bIsMeleeOnly;
    var bool bCanBeDowned;
    var bool bWeakToTech;
    var bool bNotScaredOfFire;
    var bool bFitsIntoTransport;
    var int UnitSize;
    var int UnitHeight;
    var float KillXP;
    var string HackType;
    var name CharacterGroup;
    var bool CreateDifficultyVariants;
    var string DefaultLoadout;
    var string DefaultLootTable;
    var array<name> Abilities;
};

static function ProcessDynamicEnemyCreationConfigurations()
{
    local array<UnitDefinition> UnitDefinitions;

    // Load from legacy configuration
    LoadUnitDefinitions("DynamicEnemyCreation.X2Character_DynamicEnemyTemplates", UnitDefinitions);

    // Convert to unified format
    ConvertUnitDefinitionsToUnified(UnitDefinitions);

    // Log wrapper behavior
    class'TM_CoreLogger'.static.LogWrapperActivity("DynamicEnemyCreationWrapper",
        "Processed " $ UnitDefinitions.Length $ " UnitDefinition entries");
}
```

#### 2.1.3 TM_WrapperWSR (GIVE_ABILITIES/CHANGE_TEMPLATE Compatibility)

**Task ID: task-185** - WSR Wrapper Implementation

```unrealscript
class TM_WrapperWSR extends Object config(TemplateMaker);

struct GiveAbilitiesStruct
{
    var string CHARACTER;
    var string TEMPLATE;
    var string ABILITY;
    var string REMOVE_ABILITY;
    var array<string> ABILITIES;
    var array<string> REMOVE_ABILITIES;
};

struct ChangeTemplateStruct
{
    var string TEMPLATE;
    var string PROPERTY;
    var string VALUE;
    var string OPERATION;
};

static function ProcessWSRConfigurations()
{
    local array<GiveAbilitiesStruct> GiveAbilitiesEntries;
    local array<ChangeTemplateStruct> ChangeTemplateEntries;

    // Load from legacy WSR configuration
    LoadGiveAbilitiesStructs("zzzWeaponSkinReplacer.X2DownloadableContentInfo_WeaponSkinReplacer", GiveAbilitiesEntries);
    LoadChangeTemplateStructs("zzzWeaponSkinReplacer.X2DownloadableContentInfo_WeaponSkinReplacer", ChangeTemplateEntries);

    // Convert to unified format
    ConvertGiveAbilitiesToUnified(GiveAbilitiesEntries);
    ConvertChangeTemplateToUnified(ChangeTemplateEntries);

    // Log wrapper behavior
    class'TM_CoreLogger'.static.LogWrapperActivity("WSRWrapper",
        "Processed " $ GiveAbilitiesEntries.Length $ " GIVE_ABILITIES and " $ ChangeTemplateEntries.Length $ " CHANGE_TEMPLATE entries");
}
```

#### 2.1.4 TM_WrapperBuildADarkEvent (AbilityDarkEvent Compatibility)

**Task ID: task-185** - Build-A-Dark-Event Wrapper Implementation

```unrealscript
class TM_WrapperBuildADarkEvent extends Object config(TemplateMaker);

struct AbilityDarkEventStruct
{
    var string DarkEventID;
    var array<AbilityGrantStruct> Abilities;
    var string Img;
    var int MinActivationDays;
    var int MaxActivationDays;
    var bool bInfiniteDuration;
    var int MinDurationDays;
    var int MaxDurationDays;
    var bool bRepeatable;
    var int MaxSuccesses;
    var int StartingWeight;
    var int WeightDeltaPerPlay;
    var int MinWeight;
    var int MaxWeight;
    var int MinFL;
    var int MaxFL;
    var array<string> DLC;
    var array<string> AffectedGroups;
    var array<string> AffectedUnits;
    var int ApplyChance;
};

struct AbilityGrantStruct
{
    var string AbilityName;
    var string ApplyToWeaponSlot;
};

static function ProcessBuildADarkEventConfigurations()
{
    local array<AbilityDarkEventStruct> DarkEventDefinitions;

    // Load from legacy configuration
    LoadAbilityDarkEvents("AbilityDarkEvents.X2StrategyElement_AbilityDarkEvents", DarkEventDefinitions);

    // Convert to unified format
    ConvertDarkEventsToUnified(DarkEventDefinitions);

    // Log wrapper behavior
    class'TM_CoreLogger'.static.LogWrapperActivity("BuildADarkEventWrapper",
        "Processed " $ DarkEventDefinitions.Length $ " AbilityDarkEvent entries");
}
```

#### 2.1.5 TM_WrapperAbilityEditor (AbilityNames Compatibility)

**Task ID: task-186** - Ability Editor Wrapper Implementation

```unrealscript
class TM_WrapperAbilityEditor extends Object config(TemplateMaker);

struct AbilityNames
{
    var string AbilityName;
    var string NewDisplayName;
    var string NewDescription;
    var string NewIconImage;
    var string NewCinescriptCamera;
    var string NewTargetingMethod;
    var bool bNewHideErrors;
    var string NewShotHUDPriority;
    var string NeweAbilityIconBehaviorHUD; 
    var string NewActivationSpeech;
    var string NewSourceName;
    var string NewTargetEffectsDealDamage;
};

static function ProcessAbilityEditorConfigurations()
{
    local array<AbilityNames> AbilityModifications;

    // Load from legacy configuration
    LoadAbilityNames("AbilityEditor.OPTC_Abilities", AbilityModifications);

    // Convert to unified format
    ConvertAbilityModificationsToUnified(AbilityModifications);

    // Log wrapper behavior
    class'TM_CoreLogger'.static.LogWrapperActivity("AbilityEditorWrapper",
        "Processed " $ AbilityModifications.Length $ " AbilityNames entries");
}
```

#### 2.1.6 TM_WrapperPCSSystem (X2EquipmentTemplate PCS Compatibility)

**Task ID: task-186** - PCS System Wrapper Implementation

```unrealscript
class TM_WrapperPCSSystem extends Object config(TemplateMaker);

struct PCSDefinition
{
    var string TemplateName;
    var string Operation; // CREATE, MODIFY
    var string ItemCat;
    var string InventorySlot;
    var int TradingPostValue;
    var bool bAlwaysUnique;
    var int Tier;
    var int StatBoostPowerLevel;
    var array<string> StatsToBoost;
    var bool bUseBoostIncrement;
    var array<string> Abilities;
    var string LootStaticMesh;
    var string strImage;
    var string BlackMarketTexts;
};

static function ProcessPCSSystemConfigurations()
{
    local array<PCSDefinition> PCSDefinitions;

    // Load from various PCS mod configurations
    LoadPCSDefinitions("XComTemplateCreator.ini", PCSDefinitions);
    LoadPCSDefinitions("XComOverwatchPCS.ini", PCSDefinitions);

    // Convert to unified format
    ConvertPCSDefinitionsToUnified(PCSDefinitions);

    // Log wrapper behavior
    class'TM_CoreLogger'.static.LogWrapperActivity("PCSSystemWrapper",
        "Processed " $ PCSDefinitions.Length $ " PCS template entries");
}
```

#### 2.1.7 TM_WrapperSitRepSystem (X2SitRepTemplate Compatibility)

**Task ID: task-186** - SitRep System Wrapper Implementation

```unrealscript
class TM_WrapperSitRepSystem extends Object config(TemplateMaker);

struct SitRepDefinition
{
    var string TemplateName;
    var string Operation; // CREATE, MODIFY
    var bool bNegativeEffect;
    var bool bExcludeFromStrategy;
    var bool bExcludeFromChallengeMode;
    var bool bOverrideCivilianHostility;
    var int MinimumForceLevel;
    var int MaximumForceLevel;
    var array<string> ValidMissionTypes;
    var array<string> ValidMissionFamilies;
    var array<string> ExcludePlotTypes;
    var array<string> ExcludeGameplayTags;
    var array<string> PositiveEffects;
    var array<string> NegativeEffects;
    var array<string> DisplayEffects;
    var array<string> TacticalGameplayTags;
    var string SquadSelectNarrative;
};

static function ProcessSitRepSystemConfigurations()
{
    local array<SitRepDefinition> SitRepDefinitions;

    // Load from SitRep mod configurations
    LoadSitRepDefinitions("XComGame.X2SitRep_DefaultSitReps", SitRepDefinitions);

    // Convert to unified format
    ConvertSitRepDefinitionsToUnified(SitRepDefinitions);

    // Log wrapper behavior
    class'TM_CoreLogger'.static.LogWrapperActivity("SitRepSystemWrapper",
        "Processed " $ SitRepDefinitions.Length $ " SitRep template entries");
}
```

## 3. Implementation Phases and Priorities

### Phase 1: Foundation Infrastructure

**Task ID: task-183** - Core Infrastructure Implementation

**Priority: CRITICAL** - Must be completed before any wrapper development

**Deliverables:**

- TM_CoreConfigManager.uc - Enhanced configuration management system
- TM_CoreLogger.uc - Comprehensive logging infrastructure
- TM_CoreTemplateTracker.uc - Template tracking and conflict detection
- TM_CoreTemplateProcessor.uc - Core template processing pipeline
- TM_CoreAPIRegistry.uc - API compatibility registry
- TM_TemplateDefinitionUnified.uc - Unified template definition structures

**Testing Requirements:**

- Configuration loading and parsing validation
- Logging system functionality verification
- Template tracking accuracy testing
- Performance baseline establishment

**Risk Mitigation:**

- Extensive unit testing for core components
- Performance profiling to ensure no overhead
- Backward compatibility validation framework

### Phase 2: Core Wrapper Implementation

**Task ID: task-184** - Template Master and Dynamic Enemy Creation Wrappers

**Priority: HIGH** - Foundation systems for Stukov ecosystem

**Deliverables:**

- TM_WrapperTemplateMaster.uc - EditTemplateStruct compatibility
- TM_WrapperDynamicEnemyCreation.uc - UnitDefinition compatibility
- Configuration file compatibility layers
- Wrapper behavior logging integration

**Task ID: task-185** - WSR and Build-A-Dark-Event Wrappers

**Priority: HIGH** - Critical for Stukov ecosystem dependencies

**Deliverables:**

- TM_WrapperWSR.uc - GIVE_ABILITIES/CHANGE_TEMPLATE compatibility
- TM_WrapperBuildADarkEvent.uc - AbilityDarkEvent compatibility
- Multi-API dependency handling for Stukov mods
- Comprehensive wrapper testing

**Task ID: task-186** - Specialized System Wrappers

**Priority: MEDIUM** - Extended functionality support

**Deliverables:**

- TM_WrapperAbilityEditor.uc - AbilityNames compatibility
- TM_WrapperPCSSystem.uc - X2EquipmentTemplate PCS compatibility
- TM_WrapperSitRepSystem.uc - X2SitRepTemplate compatibility
- Integration testing with workshop mods

### Phase 3: Advanced Features and Optimization

**Task ID: task-187** - Template Creation System Implementation

**Priority: MEDIUM** - Enhanced template creation capabilities

**Deliverables:**

- TM_CreatorCharacterTemplate.uc - Advanced character template creation
- TM_CreatorAbilityTemplate.uc - Ability template creation with effects
- TM_CreatorItemTemplate.uc - Item and PCS template creation
- TM_CreatorDarkEventTemplate.uc - Dark event template creation
- TM_CreatorSitRepTemplate.uc - SitRep template creation

**Task ID: task-188** - Processing and Validation Systems

**Priority: MEDIUM** - Robust template processing

**Deliverables:**

- TM_ProcessorConfig.uc - Advanced configuration processing
- TM_ProcessorValidation.uc - Comprehensive template validation
- TM_ProcessorConflictResolver.uc - Intelligent conflict resolution
- Error handling and recovery systems

### Phase 4: Testing and Validation

**Task ID: task-189** - Comprehensive Testing Suite

**Priority: HIGH** - Ensure system reliability

**Testing Scope:**

- All wrapper classes with real mod configurations
- Stukov ecosystem integration testing
- Performance impact assessment
- Conflict detection and resolution validation
- Error handling and recovery testing

**Validation Requirements:**

- 100% backward compatibility verification
- No performance degradation confirmation
- Comprehensive logging validation
- Error message clarity and actionability

### Phase 5: Documentation and Release

**Task ID: task-192** - Documentation and Migration Guides

**Priority: MEDIUM** - Community adoption support

**Deliverables:**

- Complete API documentation
- Migration guides for mod authors
- Troubleshooting and debugging guides
- Performance optimization recommendations
- Community feedback integration

## 4. Configuration System Design

### 4.1 Unified Configuration Format

**Task ID: task-190** - Unified Configuration System Implementation

```ini
[TemplateMaker.TM_CoreConfigManager]
; Core system settings
bEnableUnifiedProcessing=true
bEnableLegacyCompatibility=true
bEnableWrapperLogging=true
bEnableConflictDetection=true
ConflictResolutionStrategy="FAIL"  ; Options: "FAIL", "RENAME", "OVERRIDE"

; Performance settings
bEnablePerformanceLogging=false
MaxTemplateProcessingTime=5000  ; milliseconds
bEnableAsyncProcessing=false

; Debugging settings
LogLevel="INFO"  ; Options: "ERROR", "WARNING", "INFO", "DEBUG", "VERBOSE"
bLogWrapperBehavior=true
bLogTemplateCreation=true
bLogConflictResolution=true
```

### 4.2 Legacy Configuration Migration

**Task ID: task-190** - Legacy Configuration Migration System

**Migration Strategy:**

1. **Automatic Detection**: Scan for existing legacy configuration files
2. **Compatibility Mapping**: Map legacy formats to unified structures
3. **Gradual Migration**: Support both legacy and unified formats during transition
4. **Validation**: Ensure migrated configurations produce identical results
5. **Documentation**: Provide clear migration paths for mod authors

## 5. Logging and Debugging Infrastructure

### 5.1 Enhanced Logging System

**Task ID: task-191** - Enhanced Logging System Implementation

```unrealscript
class TM_CoreLogger extends Object config(TemplateMaker);

enum ELogLevel
{
    ELL_Error,
    ELL_Warning,
    ELL_Info,
    ELL_Debug,
    ELL_Verbose
};

// Core logging methods
static function LogTemplateCreation(name TemplateName, string TemplateClass, string SourceMod, bool bSuccess);
static function LogWrapperActivity(string WrapperName, string Activity);
static function LogConflictDetection(name TemplateName, array<string> ConflictingMods);
static function LogPerformanceMetric(string Operation, float ExecutionTime);
static function LogConfigurationParsing(string ConfigFile, int EntriesProcessed, int ErrorsFound);

// Wrapper behavior transparency
static function LogWrapperTranslation(string LegacyFormat, string UnifiedFormat, string TranslationDetails);
static function LogAPICompatibilityCheck(string APIFormat, bool bCompatible, string Details);

// Error reporting and troubleshooting
static function LogDetailedError(string ErrorContext, string ErrorMessage, string SuggestedResolution);
static function GenerateTroubleshootingReport(string ProblemDescription);
```

### 5.2 Debugging and Troubleshooting Tools

**Task ID: task-191** - Debugging and Troubleshooting Tools

**Debugging Features:**

- Template creation step-by-step logging
- Wrapper translation verification
- Configuration parsing error details
- Performance bottleneck identification
- Conflict resolution decision logging

**Troubleshooting Guides:**

- Common configuration errors and solutions
- Wrapper behavior explanation and verification
- Performance optimization recommendations
- Conflict resolution strategy selection
- Migration troubleshooting for mod authors

## Implementation Status

- [ ] Foundation Infrastructure
- [ ] Core Wrapper Classes
- [ ] Template Processing Pipeline
- [ ] Conflict Detection System
- [ ] Configuration System
- [ ] Logging Infrastructure
- [ ] Testing and Validation
- [ ] Documentation

## Critical Success Factors

1. 100% API Compatibility preservation
2. Transparent wrapper behavior with extensive logging
3. Performance preservation without wrapper overhead
4. Comprehensive testing with Stukov ecosystem
5. Clear migration guides for mod authors

---
*This document will be updated with specific Task Manager task IDs once tasks are created.*
