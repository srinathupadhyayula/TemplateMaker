//---------------------------------------------------------------------------------------
//  FILE:    TM_APIRegistry.uc
//  AUTHOR:  Srinath Upadhyayula
//  PURPOSE: API compatibility registry for the TemplateMaker system
//           Manages registration and validation of supported API formats
//---------------------------------------------------------------------------------------

class TM_APIRegistry extends Object dependson(TM_TemplateDefinitionUnified);

// Simple tracking array - populated once during initialization
var array<APICompatibilityInfo> RegisteredAPIs;
var bool bSummaryLogged; // Prevent duplicate summary logs

// Initialize the API registry with all supported formats
static function Initialize()
{
    local TM_APIRegistry CDO;

    CDO = TM_APIRegistry(class'XComEngine'.static.GetClassDefaultObject(class'TM_APIRegistry'));
    if (CDO == none) return;

    // Use array length check instead of bInitialized flag - CDO pattern
    if (CDO.RegisteredAPIs.Length > 0) return;

    class'TM_Logger'.static.LogInfo("TM_APIRegistry initializing...", "APIRegistry");

    // Register all supported API formats
    RegisterTemplateMasterAPI();
    RegisterDynamicEnemyCreationAPI();
    RegisterWSRAPI();
    RegisterBuildADarkEventAPI();
    RegisterAbilityEditorAPI();
    RegisterPCSSystemAPI();
    RegisterSitRepSystemAPI();
    RegisterUnifiedAPI();

    class'TM_Logger'.static.LogInfo("TM_APIRegistry initialized with " $
        CDO.RegisteredAPIs.Length $ " API formats", "APIRegistry");
}

// Register Template Master API format
static function RegisterTemplateMasterAPI()
{
    local APICompatibilityInfo APIInfo;

    APIInfo.Format = EAF_TemplateMaster;
    APIInfo.FormatName = "Template Master";
    APIInfo.Description = "EditTemplateStruct format for template modification";
    APIInfo.SupportedSections.AddItem("WOTCIridarTemplateMaster.X2DLCInfo_First");
    APIInfo.SupportedSections.AddItem("WOTCIridarTemplateMaster.X2DLCInfo_Standard");
    APIInfo.SupportedSections.AddItem("WOTCIridarTemplateMaster.X2DLCInfo_Last");
    APIInfo.RequiredProperties.AddItem("TemplateName");
    APIInfo.RequiredProperties.AddItem("Property");
    APIInfo.RequiredProperties.AddItem("Operation");
    APIInfo.RequiredProperties.AddItem("Value");
    APIInfo.bActive = class'TM_ConfigManager'.static.IsTemplateMasterCompatibilityEnabled();
    APIInfo.Priority = 100;

    RegisterAPI(APIInfo);
}

// Register Dynamic Enemy Creation API format
static function RegisterDynamicEnemyCreationAPI()
{
    local APICompatibilityInfo APIInfo;

    APIInfo.Format = EAF_DynamicEnemyCreation;
    APIInfo.FormatName = "Dynamic Enemy Creation";
    APIInfo.Description = "UnitDefinition format for character template creation";
    APIInfo.SupportedSections.AddItem("DynamicEnemyCreation.X2Character_DynamicEnemyTemplates");
    APIInfo.RequiredProperties.AddItem("TemplateName");
    APIInfo.RequiredProperties.AddItem("CharacterGroupName");
    APIInfo.bActive = class'TM_ConfigManager'.static.IsDynamicEnemyCreationCompatibilityEnabled();
    APIInfo.Priority = 90;

    RegisterAPI(APIInfo);
}

// Register WSR API format
static function RegisterWSRAPI()
{
    local APICompatibilityInfo APIInfo;

    APIInfo.Format = EAF_WSR;
    APIInfo.FormatName = "Weapon Skin Replacer";
    APIInfo.Description = "GIVE_ABILITIES/CHANGE_TEMPLATE format for template modification";
    APIInfo.SupportedSections.AddItem("zzzWeaponSkinReplacer.X2DownloadableContentInfo_WeaponSkinReplacer");
    APIInfo.RequiredProperties.AddItem("TEMPLATE");
    APIInfo.bActive = class'TM_ConfigManager'.static.IsWSRCompatibilityEnabled();
    APIInfo.Priority = 80;

    RegisterAPI(APIInfo);
}

// Register Build-A-Dark-Event API format
static function RegisterBuildADarkEventAPI()
{
    local APICompatibilityInfo APIInfo;

    APIInfo.Format = EAF_BuildADarkEvent;
    APIInfo.FormatName = "Build-A-Dark-Event";
    APIInfo.Description = "AbilityDarkEvent format for dark event creation";
    APIInfo.SupportedSections.AddItem("AbilityDarkEvents.X2StrategyElement_AbilityDarkEvents");
    APIInfo.RequiredProperties.AddItem("DarkEventID");
    APIInfo.RequiredProperties.AddItem("Abilities");
    APIInfo.bActive = class'TM_ConfigManager'.static.IsBuildADarkEventCompatibilityEnabled();
    APIInfo.Priority = 70;

    RegisterAPI(APIInfo);
}

// Register Ability Editor API format
static function RegisterAbilityEditorAPI()
{
    local APICompatibilityInfo APIInfo;

    APIInfo.Format = EAF_AbilityEditor;
    APIInfo.FormatName = "Ability Editor";
    APIInfo.Description = "AbilityNames format for ability modification";
    APIInfo.SupportedSections.AddItem("AbilityEditor.OPTC_Abilities");
    APIInfo.RequiredProperties.AddItem("AbilityName");
    APIInfo.bActive = class'TM_ConfigManager'.static.IsAbilityEditorCompatibilityEnabled();
    APIInfo.Priority = 60;

    RegisterAPI(APIInfo);
}

// Register PCS System API format
static function RegisterPCSSystemAPI()
{
    local APICompatibilityInfo APIInfo;

    APIInfo.Format = EAF_PCSSystem;
    APIInfo.FormatName = "PCS System";
    APIInfo.Description = "X2EquipmentTemplate PCS format for PCS item creation";
    APIInfo.SupportedSections.AddItem("XComTemplateCreator.ini");
    APIInfo.SupportedSections.AddItem("XComOverwatchPCS.ini");
    APIInfo.RequiredProperties.AddItem("TemplateName");
    APIInfo.RequiredProperties.AddItem("ItemCat");
    APIInfo.RequiredProperties.AddItem("InventorySlot");
    APIInfo.bActive = class'TM_ConfigManager'.static.IsPCSSystemCompatibilityEnabled();
    APIInfo.Priority = 50;

    RegisterAPI(APIInfo);
}

// Register SitRep System API format
static function RegisterSitRepSystemAPI()
{
    local APICompatibilityInfo APIInfo;

    APIInfo.Format = EAF_SitRepSystem;
    APIInfo.FormatName = "SitRep System";
    APIInfo.Description = "X2SitRepTemplate format for situation report creation";
    APIInfo.SupportedSections.AddItem("XComGame.X2SitRep_DefaultSitReps");
    APIInfo.RequiredProperties.AddItem("TemplateName");
    APIInfo.bActive = class'TM_ConfigManager'.static.IsSitRepSystemCompatibilityEnabled();
    APIInfo.Priority = 40;

    RegisterAPI(APIInfo);
}

// Register Unified API format
static function RegisterUnifiedAPI()
{
    local APICompatibilityInfo APIInfo;

    APIInfo.Format = EAF_Unified;
    APIInfo.FormatName = "TemplateMaker Unified";
    APIInfo.Description = "TemplateMaker unified format for all template operations";
    APIInfo.SupportedSections.AddItem("TemplateMaker.TM_TemplateCreator");
    APIInfo.SupportedSections.AddItem("TemplateMaker.TM_TemplateEditor");
    APIInfo.SupportedSections.AddItem("TemplateMaker.TM_WeaponSkinReplacer");
    APIInfo.RequiredProperties.AddItem("TemplateName");
    APIInfo.RequiredProperties.AddItem("TemplateType");
    APIInfo.RequiredProperties.AddItem("Operation");
    APIInfo.bActive = class'TM_ConfigManager'.static.IsUnifiedProcessingEnabled();
    APIInfo.Priority = 1000; // Highest priority

    RegisterAPI(APIInfo);
}

// Register an API format
static function RegisterAPI(APICompatibilityInfo APIInfo)
{
    local TM_APIRegistry CDO;
    local int ExistingIndex;

    CDO = TM_APIRegistry(class'XComEngine'.static.GetClassDefaultObject(class'TM_APIRegistry'));
    if (CDO == none) return;

    // Check if API is already registered
    ExistingIndex = FindAPIByFormat(APIInfo.Format);

    if (ExistingIndex != INDEX_NONE)
    {
        // Update existing registration
        CDO.RegisteredAPIs[ExistingIndex] = APIInfo;
        class'TM_Logger'.static.LogDebug("Updated API registration: " $ APIInfo.FormatName, "APIRegistry");
    }
    else
    {
        // Add new registration
        CDO.RegisteredAPIs.AddItem(APIInfo);
        class'TM_Logger'.static.LogDebug("Registered new API: " $ APIInfo.FormatName, "APIRegistry");
    }

    // Log API compatibility check
    class'TM_Logger'.static.LogAPICompatibilityCheck(APIInfo.FormatName, APIInfo.bActive,
        "Priority: " $ APIInfo.Priority $ ", Sections: " $ APIInfo.SupportedSections.Length);
}

// Query methods
static function bool IsAPISupported(EAPIFormat Format)
{
    local TM_APIRegistry CDO;
    local int Index;

    CDO = TM_APIRegistry(class'XComEngine'.static.GetClassDefaultObject(class'TM_APIRegistry'));
    if (CDO == none) return false;

    Index = FindAPIByFormat(Format);
    return (Index != INDEX_NONE) && CDO.RegisteredAPIs[Index].bActive;
}

static function APICompatibilityInfo GetAPIInfo(EAPIFormat Format)
{
    local TM_APIRegistry CDO;
    local int Index;
    local APICompatibilityInfo EmptyInfo;

    CDO = TM_APIRegistry(class'XComEngine'.static.GetClassDefaultObject(class'TM_APIRegistry'));
    if (CDO == none) return EmptyInfo;

    Index = FindAPIByFormat(Format);
    if (Index != INDEX_NONE)
    {
        return CDO.RegisteredAPIs[Index];
    }

    return EmptyInfo;
}

static function array<APICompatibilityInfo> GetAllAPIs()
{
    local TM_APIRegistry CDO;
    local array<APICompatibilityInfo> EmptyArray;

    CDO = TM_APIRegistry(class'XComEngine'.static.GetClassDefaultObject(class'TM_APIRegistry'));
    if (CDO == none) return EmptyArray; // Return empty array

    return CDO.RegisteredAPIs;
}

static function array<APICompatibilityInfo> GetActiveAPIs()
{
    local TM_APIRegistry CDO;
    local array<APICompatibilityInfo> ActiveAPIs;
    local int i;

    CDO = TM_APIRegistry(class'XComEngine'.static.GetClassDefaultObject(class'TM_APIRegistry'));
    if (CDO == none) return ActiveAPIs; // Return empty array

    for (i = 0; i < CDO.RegisteredAPIs.Length; i++)
    {
        if (CDO.RegisteredAPIs[i].bActive)
        {
            ActiveAPIs.AddItem(CDO.RegisteredAPIs[i]);
        }
    }

    return ActiveAPIs;
}

static function bool ValidateAPIRequirements(EAPIFormat Format, array<string> ProvidedProperties)
{
    local APICompatibilityInfo APIInfo;
    local int i, j;
    local bool bFound;

    APIInfo = GetAPIInfo(Format);
    if (APIInfo.Format == EAF_Unified && APIInfo.FormatName == "") // Empty struct check
    {
        class'TM_Logger'.static.LogWarning("API format not found: " $ Format, "APIRegistry");
        return false;
    }

    // Check if all required properties are provided
    for (i = 0; i < APIInfo.RequiredProperties.Length; i++)
    {
        bFound = false;
        for (j = 0; j < ProvidedProperties.Length; j++)
        {
            if (APIInfo.RequiredProperties[i] ~= ProvidedProperties[j])
            {
                bFound = true;
                break;
            }
        }

        if (!bFound)
        {
            class'TM_Logger'.static.LogWarning("Missing required property '" $
                APIInfo.RequiredProperties[i] $ "' for API format: " $ APIInfo.FormatName, "APIRegistry");
            return false;
        }
    }

    return true;
}

static function EAPIFormat DetectAPIFormat(string ConfigSection)
{
    local TM_APIRegistry CDO;
    local int i, j;

    CDO = TM_APIRegistry(class'XComEngine'.static.GetClassDefaultObject(class'TM_APIRegistry'));
    if (CDO == none) return EAF_Unified;

    for (i = 0; i < CDO.RegisteredAPIs.Length; i++)
    {
        for (j = 0; j < CDO.RegisteredAPIs[i].SupportedSections.Length; j++)
        {
            if (ConfigSection ~= CDO.RegisteredAPIs[i].SupportedSections[j])
            {
                return CDO.RegisteredAPIs[i].Format;
            }
        }
    }

    return EAF_Unified; // Default to unified format
}

// Utility methods
static function int FindAPIByFormat(EAPIFormat Format)
{
    local TM_APIRegistry CDO;
    local int i;

    CDO = TM_APIRegistry(class'XComEngine'.static.GetClassDefaultObject(class'TM_APIRegistry'));
    if (CDO == none) return INDEX_NONE;

    for (i = 0; i < CDO.RegisteredAPIs.Length; i++)
    {
        if (CDO.RegisteredAPIs[i].Format == Format)
        {
            return i;
        }
    }

    return INDEX_NONE;
}

static function string GetAPIFormatName(EAPIFormat Format)
{
    local APICompatibilityInfo APIInfo;

    APIInfo = GetAPIInfo(Format);
    return APIInfo.FormatName != "" ? APIInfo.FormatName : "Unknown";
}

// Runtime API management
static function SetAPIActive(EAPIFormat Format, bool bActive)
{
    local TM_APIRegistry CDO;
    local int Index;

    CDO = TM_APIRegistry(class'XComEngine'.static.GetClassDefaultObject(class'TM_APIRegistry'));
    if (CDO == none) return;

    Index = FindAPIByFormat(Format);
    if (Index != INDEX_NONE)
    {
        CDO.RegisteredAPIs[Index].bActive = bActive;
        class'TM_Logger'.static.LogInfo("API " $ CDO.RegisteredAPIs[Index].FormatName $
            " set to " $ (bActive ? "active" : "inactive"), "APIRegistry");
    }
}

static function LogAPIRegistrySummary()
{
    local TM_APIRegistry CDO;
    local int i;
    local int ActiveCount;

    CDO = TM_APIRegistry(class'XComEngine'.static.GetClassDefaultObject(class'TM_APIRegistry'));
    if (CDO == none) return;

    // Prevent duplicate summaries - only log once per session
    if (CDO.bSummaryLogged) return;

    class'TM_Logger'.static.LogInfoBlock("=== API REGISTRY SUMMARY ===", "APIRegistry");

    for (i = 0; i < CDO.RegisteredAPIs.Length; i++)
    {
        class'TM_Logger'.static.LogInfo("API[" $ i $ "]: " $ CDO.RegisteredAPIs[i].FormatName $
            " (Active: " $ CDO.RegisteredAPIs[i].bActive $ ", Priority: " $
            CDO.RegisteredAPIs[i].Priority $ ")", "APIRegistry");

        if (CDO.RegisteredAPIs[i].bActive)
            ActiveCount++;
    }

    class'TM_Logger'.static.LogInfo("Total APIs: " $ CDO.RegisteredAPIs.Length $
        ", Active: " $ ActiveCount, "APIRegistry");
    class'TM_Logger'.static.LogInfoBlock("=== END API REGISTRY SUMMARY ===", "APIRegistry");

    // Mark summary as logged to prevent duplicates
    CDO.bSummaryLogged = true;
}

// No defaultproperties needed - using CDO pattern with array length checks
