import("pathfinder.road", "RoadPathFinder", 3);

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

	/* The following is from: http://wiki.openttd.org/AI:RoadPathfinder
	Edited because AIAbstractList no longer exists.
	Also changed costs.
	TODO: Edit the road path finder so that it has a cost for farms
	Source is at: http://dev.openttdcoop.org/projects/lib-pathfinderroad/repository/entry/main.nut
	*/

	/* Get a list of all towns on the map. */
	local townlist = AITownList();

	/* Sort the list by population, highest population first. */
	townlist.Valuate(AITown.GetPopulation);
	townlist.Sort(AIList.SORT_BY_VALUE, false);

	/* Pick the two towns with the highest population. */
	local townid_a = townlist.Begin();
	local townid_b = townlist.Next();

	/* Print the names of the towns we'll try to connect. */
	AILog.Info("Going to connect " + AITown.GetName(townid_a) + " to " + AITown.GetName(townid_b));

	/* Tell OpenTTD we want to build normal road (no tram tracks). */
	AIRoad.SetCurrentRoadType(AIRoad.ROADTYPE_ROAD);

	/* Create an instance of the pathfinder. */
	local pathfinder = RoadPathFinder();

	/* Adjust costs */
	pathfinder.cost.tile = 100;
	pathfinder.cost.no_existing_road = 40;
	pathfinder.cost.turn = 0;
	pathfinder.cost.slope = 250;
	pathfinder.cost.bridge_per_tile = 500;
	pathfinder.cost.tunnel_per_tile = 300;
	pathfinder.cost.coast = 1000;
	pathfinder.cost.max_bridge_length = 10;
	pathfinder.cost.max_tunnel_length = 20;

	/* Give the source and goal tiles to the pathfinder. */
	pathfinder.InitializePath([AITown.GetLocation(townid_a)], [AITown.GetLocation(townid_b)]);

	/* Try to find a path. */
	local path = false;
	while (path == false) {
		path = pathfinder.FindPath(100);
		this.Sleep(1);
	}

	if (path == null) {
		/* No path was found. */
		AILog.Error("pathfinder.FindPath return null");
	}

	/* If a path was found, build a road over it. */
	while (path != null) {
		local par = path.GetParent();
		if (par != null) {
			local last_node = path.GetTile();
			if (AIMap.DistanceManhattan(path.GetTile(), par.GetTile()) == 1 ) {
				if (!AIRoad.BuildRoad(path.GetTile(), par.GetTile())) {
					/* An error occured while building a piece of road. TODO: handle it. 
					 * Note that is can also be the case that the road was already build. */
				}
			} else {
				/* Build a bridge or tunnel. */
				if (!AIBridge.IsBridgeTile(path.GetTile()) && !AITunnel.IsTunnelTile(path.GetTile())) {
					/* If it was a road tile, demolish it first. Do this to work around expended roadbits. */
					if (AIRoad.IsRoadTile(path.GetTile())) AITile.DemolishTile(path.GetTile());
					if (AITunnel.GetOtherTunnelEnd(path.GetTile()) == par.GetTile()) {
						if (!AITunnel.BuildTunnel(AIVehicle.VT_ROAD, path.GetTile())) {
							/* An error occured while building a tunnel. TODO: handle it. */
						}
					} else {
						local bridge_list = AIBridgeList_Length(AIMap.DistanceManhattan(path.GetTile(), par.GetTile()) + 1);
						bridge_list.Valuate(AIBridge.GetMaxSpeed);
						bridge_list.Sort(AIList.SORT_BY_VALUE, false);
						if (!AIBridge.BuildBridge(AIVehicle.VT_ROAD, bridge_list.Begin(), path.GetTile(), par.GetTile())) {
							/* An error occured while building a bridge. TODO: handle it. */
						}
					}
				}
			}
		}
		path = par;
	}
	AILog.Info("Done");

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