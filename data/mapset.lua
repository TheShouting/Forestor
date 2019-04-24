local mapset = {
      blank = {
         name = "blank space",
         tile = "blank",
         move=true,
         see=true
      },
      path = {
         name = "path",
         neighbors = {path=true},
         tile = "path",
         move=true,
         see=true
      },
      puddle = {
         name = "puddle",
         tile = "puddle",
         move=true,
         see=true,
         effect={wet=3}
      },
      dirt = {
         name = "dirt",
         tile = "dirt",
         move=true,
         see=true
      },
      grass = {
         name = "grass",
         tile = "grass",
         move=true,
         see=true
      },
      tallgrass = {
         name = "tall grass",
         neighbors = {tallgrass=true},
         tile = "tallgrass",
         move=true,
         see=false,
         hit = "grass",
         key = nil
      },
      tree = {
         name = "big trees",
         neighbors = {tree=true, treesmall=true},
         tile = "tree",
         move=false,
         see=false,
         hit = "treesmall",
         key = "chop"
      },
      treesmall = {
         name = "trees",
         neighbors = {tree=true, treesmall=true},
         tile = "tree",
         move = false,
         see = false,
         hit = "stump",
         key = "chop"
      },
      stump = {
         name = "log",
         tile = "stump",
         move=false,
         see=true,
         hit="dirt",
         key="chop"
      },
      dooropen = {
         name = "open door",
         tile = "dooropen",
         move = true,
         see = true,
         leave = "doorclose",
      },
      doorclose = {
         name = "closed door",
         tile = "doorclose",
         move = false,
         see = false,
         hit = "dooropen"
      },
      doorlocked = {
         name = "locked door",
         tile = "doorlocked",
         move = false,
         see = false,
         hit = "dooropen",
         key = "key"
      },
      wall = {
         name = "wall",
         neighbors = {
            dooropen=true, 
            doorclose=true,
            doorlocked=true,
            wall=true
            },
         tile = "wall",
         move = false,
         see = false
      },
      cliff = {
         name = "cliff",
         tile = "cliff",
         move = false,
         see = false,
         hit = "rubble",
         key = "dig"
      },
   portal = {
         name = "magical ground",
         tile = "portal",
         move = true,
         see = true
      }
   }
   
return mapset