//---------------------------------------------------------------------------------------
//  FILE:    TM_TemplateDefinitionUnified.uc
//  AUTHOR:  Srinath Upadhyayula
//  PURPOSE: Unified template definition structures for the TemplateMaker system
//           Provides common data structures used across all template operations
//---------------------------------------------------------------------------------------

class TM_TemplateDefinitionUnified extends Object;

// Template operation types
enum ETemplateOperation
{
    ETO_Create,         // Create a new template
    ETO_Modify,         // Modify an existing template
    ETO_Replace,        // Replace an existing template entirely
    ETO_Delete,         // Mark a template for deletion
    ETO_Validate        // Validate template without applying changes
};

// Template types supported by the system
enum ETemplateType
{
    ETT_Character,      // X2CharacterTemplate
    ETT_Weapon,         // X2WeaponTemplate
    ETT_Armor,          // X2ArmorTemplate
    ETT_Item,           // X2ItemTemplate
    ETT_Equipment,      // X2EquipmentTemplate
    ETT_Ability,        // X2AbilityTemplate
    ETT_Effect,         // X2EffectTemplate
    ETT_DarkEvent,      // X2DarkEventTemplate
    ETT_SitRep,         // X2SitRepTemplate
    ETT_Unknown         // Unknown or unsupported template type
};

// Property modification types
enum EPropertyOperation
{
    EPO_Set,            // Set property value (replace)
    EPO_Add,            // Add to array property
    EPO_Remove,         // Remove from array property
    EPO_Insert,         // Insert at specific array index
    EPO_Increment,      // Increment numeric value
    EPO_Decrement,      // Decrement numeric value
    EPO_Multiply,       // Multiply numeric value
    EPO_Divide          // Divide numeric value
};

// Conflict resolution strategies
enum EConflictResolution
{
    ECR_Fail,           // Fail operation on conflict
    ECR_Override,       // Override existing template
    ECR_Rename,         // Rename new template to avoid conflict
    ECR_Merge,          // Attempt to merge templates
    ECR_Skip            // Skip conflicting operation
};

// API format types for compatibility tracking
enum EAPIFormat
{
    EAF_TemplateMaster,         // EditTemplateStruct format
    EAF_DynamicEnemyCreation,   // UnitDefinition format
    EAF_WSR,                    // GIVE_ABILITIES/CHANGE_TEMPLATE format
    EAF_BuildADarkEvent,        // AbilityDarkEvent format
    EAF_AbilityEditor,          // AbilityNames format
    EAF_PCSSystem,              // X2EquipmentTemplate PCS format
    EAF_SitRepSystem,           // X2SitRepTemplate format
    EAF_Unified                 // TemplateMaker unified format
};

// Property modification definition
struct PropertyModification
{
    var string PropertyName;            // Name of the property to modify
    var EPropertyOperation Operation;   // Type of operation to perform
    var string Value;                   // New value or value to add/remove
    var int ArrayIndex;                 // Array index for insert/remove operations (-1 for append)
    var string Condition;               // Optional condition for conditional modifications
};

// Template dependency definition
struct TemplateDependency
{
    var name TemplateName;          // Name of the required template
    var ETemplateType TemplateType; // Type of the required template
    var bool bOptional;             // Whether this dependency is optional
    var string Reason;              // Reason for the dependency
};

// Unified template definition structure
struct UnifiedTemplateDefinition
{
    // Basic template information
    var name TemplateName;                      // Unique name for the template
    var ETemplateType TemplateType;             // Type of template being defined
    var ETemplateOperation Operation;           // Operation to perform
    var string SourceMod;                       // Mod that defined this template
    var EAPIFormat SourceFormat;                // Original API format used

    // Template inheritance and dependencies
    var name BasedOnTemplate;                   // Template to inherit from (for create operations)
    var array<TemplateDependency> Dependencies; // Required templates

    // Property modifications
    var array<PropertyModification> Properties; // Properties to set/modify

    // Conflict resolution
    var EConflictResolution ConflictResolution; // How to handle conflicts
    var int Priority;                           // Priority for conflict resolution (higher = more important)

    // Metadata
    var string Description;                     // Human-readable description
    var array<string> Tags;                     // Tags for categorization
    var bool bEnabled;                          // Whether this definition is active
    var string ConfigFile;                      // Source configuration file
    var int ConfigLine;                         // Line number in configuration file

    // Validation and processing
    var bool bValidated;                        // Whether this definition has been validated
    var array<string> ValidationErrors;         // Validation error messages
    var float ProcessingTime;                   // Time taken to process this definition
};

// Template registration record for tracking
struct TemplateRegistrationRecord
{
    var name TemplateName;                      // Name of the registered template
    var ETemplateType TemplateType;             // Type of template
    var string SourceMod;                       // Mod that registered the template
    var EAPIFormat SourceFormat;                // API format used for registration
    var string Timestamp;                       // When the template was registered
    var bool bSuccessful;                       // Whether registration was successful
    var array<string> Errors;                   // Any errors that occurred
    var float ProcessingTime;                   // Time taken to process
};

// Conflict detection result
struct ConflictDetectionResult
{
    var bool bConflictDetected;                     // Whether a conflict was found
    var name ConflictingTemplate;                   // Name of the conflicting template
    var array<string> ConflictingMods;              // Mods involved in the conflict
    var string ConflictType;                        // Type of conflict (name, property, etc.)
    var string ConflictDescription;                 // Human-readable description
    var array<string> ResolutionOptions;            // Possible resolution strategies
    var EConflictResolution RecommendedResolution;  // Recommended resolution
};

// API compatibility information
struct APICompatibilityInfo
{
    var EAPIFormat Format;                      // API format
    var string FormatName;                      // Human-readable name
    var string Description;                     // Description of the format
    var array<string> SupportedSections;        // Configuration sections supported
    var array<string> RequiredProperties;       // Properties required for this format
    var bool bActive;                           // Whether this format is currently active
    var int Priority;                           // Processing priority
};

// Performance metrics for monitoring
struct PerformanceMetrics
{
    var string OperationName;                   // Name of the operation
    var float StartTime;                        // When the operation started
    var float EndTime;                          // When the operation ended
    var float Duration;                         // Total duration in seconds
    var int TemplatesProcessed;                 // Number of templates processed
    var int ErrorsEncountered;                  // Number of errors encountered
    var string AdditionalInfo;                  // Additional performance information
};

// Configuration validation result
struct ConfigValidationResult
{
    var bool bValid;                            // Whether the configuration is valid
    var string ConfigFile;                      // Configuration file path
    var array<string> Errors;                   // Validation errors
    var array<string> Warnings;                 // Validation warnings
    var int EntriesProcessed;                   // Number of entries processed
    var int EntriesValid;                       // Number of valid entries
};

defaultproperties
{
}
