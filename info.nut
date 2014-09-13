class MooveAI extends AIInfo {
	function GetAuthor()      { return "marbs"; }
	function GetName()        { return "MooveAI"; }
	function GetShortName()   { return "MOOV"; }
	function GetDescription() { return "Friendly, realistic, scenic, all-transport-types AI."; }
	function GetVersion()     { return 1; }
	function GetAPIVersion()  { return "1.4"; }
	function GetDate()        { return "2014-09-13"; }
	function CreateInstance() { return "MooveAI"; }
	function GetSettings() {
	}
};

RegisterAI(MooveAI());