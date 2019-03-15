local mapset = {
      path = {
         name = "path",
         char={".o.", " o.", ".o ", " o "}, 
         color={{70, 60, 60}}, 
         move=true,
         see=true
      },
      puddle = {
         name = "puddle",
         char={" ~ "}, 
         color={{20, 60, 100,
            ember={30,90,110}}}, 
         move=true,
         see=true,
         effect={wet=3}
      },
      dirt = {
         name = "dirt",
         char={" . "}, 
         color={{80, 60, 20}}, 
         move=true,
         see=true
      },
      flower = {
         name = "flower",
         char={" * ", ".*."}, 
         color={
            {156, 156, 72},
            {156, 128, 60},
            {156, 128, 128}
            }, 
         move=true,
         see=true
      },
      grass = {
         name = "grass",
         char={".v.", "..."}, 
         color={{20, 80, 10}}, 
         move=true,
         see=true
      },
      tallgrass = {
         name = "tall grass",
         char={"iii"},
         color={{50, 120, 30}}, 
         move=true,
         see=false,
         hit = "grass",
         key = nil
      },
      tree = {
         name = "big trees",
         char={"/\\\\", "//\\", "/V\\"}, 
         color={
            {100, 200, 50},
            {150, 200, 50}
            }, 
         move=false,
         see=false,
         hit = "treesmall",
         key = "axe"
      },
      treesmall = {
         name = "trees",
         char = {"/\\_", "^/\\", "./\\"},
         color={
            {100, 200, 50},
            {150, 200, 50}
            },
         move = false,
         see = false,
         hit = "stump",
         key = "axe"
      },
      stump = {
         name = "log",
         char={"c=o"}, 
         color={{200, 120, 90}}, 
         move=false,
         see=true,
         hit="twig",
         key="axe"
      },
      twig = {
         name = "broken branches",
         char={"_-_","-_-","_._","._-", "_-."}, 
         color={{100, 80, 70}}, 
         move=true,
         see=true
      },
      dooropen = {
         name = "open door",
         char = {"|_|"},
         color = {{128, 128, 128}},
         move = true,
         see = true,
         leave = "doorclose",
      },
      doorclose = {
         name = "closed door",
         char = {"|+|"},
         color = {{200, 200, 200}},
         move = false,
         see = false,
         hit = "dooropen"
      },
      doorlocked = {
         name = "locked door",
         char = {"|X|"},
         color = {{200, 200, 200}},
         move = false,
         see = false,
         hit = "dooropen",
         key = "key"
      },
      wall = {
         name = "wall",
         char = {"|#|"},
         color = {{200, 200, 200}},
         move = false,
         see = false
      },
      cliff = {
         name = "cliff",
         char = {"%%%"},
         color = {{180, 140, 80}},
         move = false,
         see = false,
         hit = "rubble",
         key = "pickaxe"
      },
      rubble = {
         name = "rocks",
         char = {"oO°", "OoO", "0oO"},
         color = {{200, 160, 100}},
         move = false,
         see = true,
         hit = "dirt",
         key = "pickaxe"
      }
   }
   
return mapset