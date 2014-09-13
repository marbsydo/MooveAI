class MooveAI extends AIController
{
	constructor()
	{
	} 
};


function MooveAI::Start()
{
	AILog.Info("MooveAI Started.");
	SetCompanyName();

	//set a legal railtype. 
	local types = AIRailTypeList();
	AIRail.SetCurrentRailType(types.Begin());
					
	//Keep running. If Start() exits, the AI dies.
	while (true) {
		this.Sleep(100);
		AILog.Warning("TODO: Add functionality to the AI.");
	}
}

function MooveAI::Save()
{
	local table = {};	
	//TODO: Add your save data to the table.
	return table;
}

function MooveAI::Load(version, data)
{
	AILog.Info("Loaded");
	//TODO: Add your loading routines.
}


function MooveAI::SetCompanyName()
{
	if(!AICompany.SetName("MooveAI")) {
		local i = 2;
		while(!AICompany.SetName("MooveAI #" + i)) {
			i = i + 1;
			if(i > 255) break;
		}
	}
	AICompany.SetPresidentName("M. Bovine");
}