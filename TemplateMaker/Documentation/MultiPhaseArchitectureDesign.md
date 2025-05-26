# TemplateMaker Multi-Phase Architecture Design

## Overview

This document outlines the strategic migration from `X2DownloadableContentInfo_TemplateMaker.uc` to a sophisticated multi-phase entry point system using the X2WOTCCommunityHighlander's X2DLCInfo architecture, following the proven approach used by TemplateMaster.

## Research Findings

### Community Highlander Multi-Phase System
Based on comprehensive analysis of X2WOTCCommunityHighlander source code (CHDLCRunOrder.uc):

- **DLC Run Order System**: Controls execution order of X2DownloadableContentInfo classes
- **Three Priority Groups**: RUN_FIRST, RUN_STANDARD (default), RUN_LAST
- **Fine-Grained Control**: RunBefore/RunAfter directives for precise ordering
- **Configuration-Based**: Uses XComGame.ini sections for run order specification
- **Error Detection**: Catches configuration errors and dependency cycles

### Template Master Implementation
Based on analysis of Template Master source code:

- **Three X2DLCInfo Classes**: X2DLCInfo_First, X2DLCInfo_Standard, X2DLCInfo_Last
- **All Extend X2DownloadableContentInfo**: Standard inheritance pattern
- **Alphabetical Execution**: Community Highlander processes classes alphabetically by suffix
- **Identical Structure**: Each phase has same event methods but different timing
- **Configuration Sections**: Uses WOTCIridarTemplateMaster.X2DLCInfo_[Phase] format

### Strategic Benefits

1. **Template Processing Control**: Better sequencing of legacy mod templates vs unified templates
2. **Mod Integration Points**: Other mods can specify dependency order relative to TemplateMaker phases
3. **Conflict Resolution**: Improved handling of template conflicts through phased processing
4. **API Compatibility**: Proper sequencing for wrapper initialization and compatibility layers

## Current Functionality Analysis

### X2DownloadableContentInfo_TemplateMaker.uc (181 lines)

**Primary Events:**
- `OnLoadedSaveGame()` - Initialization and setup
- `OnPostTemplatesCreated()` - Template processing and validation

**Support Functions:**
- `DisplayEarlyWarningBanner()` - User communication
- `DisplayModCompatibilityStatus()` - Mod detection reporting
- `PerformFinalCompatibilityCheck()` - Final validation and statistics
- `OnLoadedSavedGame()` - Save game compatibility
- `InstallNewCampaign()` - New campaign setup
- `LogConfigValues()` - Debug configuration logging

## Multi-Phase Distribution Strategy

### Phase 1: X2DLCInfo_TemplateMaker_First.uc
**Purpose**: Early initialization - foundational systems that other mods should see first

**Responsibilities:**
- Early warning banner display
- Core infrastructure initialization (TM_TemplateProcessor.Initialize())
- API registry initialization (TM_APIRegistry.Initialize())
- Mod detection startup (TM_TemplateTracker mod detection)
- Basic configuration validation
- Legacy mod compatibility warnings

**Strategic Rationale:**
- Ensures TemplateMaker's core systems are available to other mods
- Establishes template tracking before other mods register templates
- Provides early warnings about potential conflicts
- Sets up API compatibility layers for legacy mod integration

### Phase 2: X2DLCInfo_TemplateMaker_Standard.uc
**Purpose**: Main processing - standard template operations and mod integration

**Responsibilities:**
- Template processing through unified system (TM_TemplateProcessor.ProcessAllTemplates())
- API compatibility layer operations
- Primary template creation and modification
- Standard mod integration points
- Configuration-driven template operations

**Strategic Rationale:**
- Runs after First phase has established foundations
- Allows other mods to hook into TemplateMaker's processing
- Provides standard execution order for most template operations
- Maintains compatibility with mods expecting standard timing

### Phase 3: X2DLCInfo_TemplateMaker_Last.uc
**Purpose**: Final processing - TemplateMaker gets the last word

**Responsibilities:**
- Final compatibility checks (PerformFinalCompatibilityCheck())
- Validation tests (TM_InfrastructureTest if debug enabled)
- Status reporting and statistics
- Cleanup operations
- Final configuration validation
- Comprehensive logging and troubleshooting reports

**Strategic Rationale:**
- Ensures TemplateMaker can override any conflicting changes
- Provides final validation after all mods have processed
- Generates comprehensive reports for troubleshooting
- Implements final conflict resolution strategies

## Event Distribution

### OnLoadedSaveGame() Distribution
- **First**: Early banner, core initialization, mod detection
- **Standard**: Main template processing
- **Last**: Final validation, status reporting

### OnPostTemplatesCreated() Distribution
- **First**: Template tracking setup, API preparation
- **Standard**: Primary template processing operations
- **Last**: Final checks, validation, reporting

### Support Functions Distribution
- **First**: DisplayEarlyWarningBanner(), basic mod detection
- **Standard**: Main processing functions
- **Last**: PerformFinalCompatibilityCheck(), comprehensive reporting

## Technical Implementation

### Class Inheritance
```unrealscript
class X2DLCInfo_TemplateMaker_First extends Object;
class X2DLCInfo_TemplateMaker_Standard extends Object;
class X2DLCInfo_TemplateMaker_Last extends Object;
```

### Execution Order Guarantee
The Community Highlander ensures execution order:
1. All `X2DLCInfo_*_First` classes execute first
2. All `X2DLCInfo_*_Standard` classes execute second
3. All `X2DLCInfo_*_Last` classes execute last

### Inter-Phase Communication
- Shared state through static class variables
- Configuration flags to track phase completion
- Error handling and rollback mechanisms

## Benefits for TemplateMaker

### Enhanced Template Merging
- **First Phase**: Detect legacy mods and prepare compatibility layers
- **Standard Phase**: Process templates with full context of mod environment
- **Last Phase**: Apply final overrides and resolve any remaining conflicts

### Improved Mod Compatibility
- Other mods can specify: "run after TemplateMaker_First but before TemplateMaker_Last"
- Provides clear integration points for dependent mods
- Reduces conflicts through controlled execution order

### Better Error Handling
- Early detection of configuration issues
- Progressive validation throughout phases
- Comprehensive final reporting

### Future Extensibility
- Clean architecture for adding new phases if needed
- Modular design allows selective feature enabling/disabling
- Easier maintenance and debugging

## Migration Checklist

1. ✅ **Research and Design** - This document
2. ⏳ **Create First Phase** - Early initialization
3. ⏳ **Create Standard Phase** - Main processing
4. ⏳ **Create Last Phase** - Final validation
5. ⏳ **Update Project Files** - .x2proj modifications
6. ⏳ **Validation and Testing** - Comprehensive testing

## Conclusion

The multi-phase architecture provides TemplateMaker with sophisticated control over template processing order, improved mod compatibility, and better conflict resolution capabilities. This strategic upgrade positions TemplateMaker as a foundational system that other mods can reliably integrate with while maintaining the flexibility to handle complex template modification scenarios.
