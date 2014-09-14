class RailEngineer
{
}

function RailEngineer::RailPathfinderTest()
{
  /* Set a legal railtype. */
  local types = AIRailTypeList();
  AIRail.SetCurrentRailType(types.Begin());
  
  /* Create an instance of the pathfinder. */
  local pathfinder = RailPathfinder();

  /* Adjust costs. */
  pathfinder.cost.tile = 100;
  pathfinder.cost.diagonal_tile = 70;
  pathfinder.cost.turn = 50;
  pathfinder.cost.slope = 100;
  pathfinder.cost.bridge_per_tile = 150;
  pathfinder.cost.tunnel_per_tile = 120;
  pathfinder.cost.coast = 1000;
  pathfinder.cost.max_bridge_length = 10;
  pathfinder.cost.max_tunnel_length = 20;

  /* Give the source and goal tiles to the pathfinder. */
  pathfinder.InitializePath([[AIMap.GetTileIndex(32, 32), AIMap.GetTileIndex(33, 32)]], [[AIMap.GetTileIndex(95, 96), AIMap.GetTileIndex(96, 96)]]);

  /* Try to find a path. */
  local path = false;
  while (path == false) {
    path = pathfinder.FindPath(100);
    AIController.Sleep(1);
  }

  if (path == null) {
    /* No path was found. */
    AILog.Error("pathfinder.FindPath return null");
  }

  /* If a path was found, build a rail over it. */
  while (path != null) {
    local par = path.GetParent();
    
    if (par != null) {
      local parpar = par.GetParent();
      if (parpar != null)
      {
        local last_node = path.GetTile();
        if (AIMap.DistanceManhattan(path.GetTile(), par.GetTile()) == 1 ) {
          if (!AIRail.BuildRail(path.GetTile(), par.GetTile(), parpar.GetTile())) {
            /* An error occured while building a piece of rail. TODO: handle it. 
             * Note that is can also be the case that the rail was already build. */
          }
        } else {
          /* Build a bridge or tunnel. */
          if (!AIBridge.IsBridgeTile(path.GetTile()) && !AITunnel.IsTunnelTile(path.GetTile())) {
            /* If it was a rail tile, demolish it first. Do this to work around expended railbits. */
            if (AIRail.IsRoadTile(path.GetTile())) AITile.DemolishTile(path.GetTile());
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
    }
    path = par;
  }
  AILog.Info("Done");
}