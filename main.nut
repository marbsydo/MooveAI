require("pathfinding/include.nut");
require("engineering/include.nut");

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

  local road_engineer = RoadEngineer();
  local rail_engineer = RailEngineer();

  rail_engineer.RailPathfinderTest();        

  road_engineer.RoadPathfinderTest();

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