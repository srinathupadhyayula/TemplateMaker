//---------------------------------------------------------------------------------------
//  FILE:    TM_Logger.uc
//  AUTHOR:  TemplateMaker Team
//  DATE:    2025-05-23
//  PURPOSE: Logging system for the TemplateMaker mod
//---------------------------------------------------------------------------------------

class TM_Logger extends Object config(TemplateMaker);

// Configuration variables
var config bool bEnableLogging;      // Whether logging is enabled at all
var config bool bVerboseLogging;     // Whether to include debug-level messages
var config name logCategory;         // The category to use for log messages

// Log level constants
const LOG_LEVEL_ERROR = "ERROR";
const LOG_LEVEL_WARNING = "WARNING";
const LOG_LEVEL_INFO = "INFO";
const LOG_LEVEL_DEBUG = "DEBUG";

// Default values are set in XComTemplateMaker.ini
defaultproperties
{
}

// Initialize the logging system
static function Init()
{
    Log("TemplateMaker initialized");
    LogInfo("Logging system initialized");
    LogDebug("Debug logging is " $ (default.bVerboseLogging ? "enabled" : "disabled"));
}

// Basic logging function
static function Log(string Message)
{
    LogInfo(Message);
}

// Log an error message
static function LogError(string Message)
{
    if (default.bEnableLogging)
    {
        `log(FormatMessage(LOG_LEVEL_ERROR, Message),, default.logCategory);
    }
}

// Log a warning message
static function LogWarning(string Message)
{
    if (default.bEnableLogging)
    {
        `log(FormatMessage(LOG_LEVEL_WARNING, Message),, default.logCategory);
    }
}

// Log an informational message
static function LogInfo(string Message)
{
    if (default.bEnableLogging)
    {
        `log(FormatMessage(LOG_LEVEL_INFO, Message),, default.logCategory);
    }
}

// Log a debug message (only if verbose logging is enabled)
static function LogDebug(string Message)
{
    if (default.bEnableLogging && default.bVerboseLogging)
    {
        `log(FormatMessage(LOG_LEVEL_DEBUG, Message),, default.logCategory);
    }
}

// Log information about an object
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

// Log an array of strings
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

// Convert an array of names to a single string for logging
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

// Log a name-value pair
static function LogValue(string PropertyName, coerce string Value)
{
    LogInfo(PropertyName $ ": " $ Value);
}

// Format a message with timestamp and level
static function string FormatMessage(string Level, string Message)
{
    return "[" $ Level $ "] " $ Message;
}
