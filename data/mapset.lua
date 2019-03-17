local mapset = {
      path = {
         name = "path",
         char = {".o.", " o.", ".o ", " o "}, 
         img = {
            {0, 15, 14},
            {14, 0, 16},
            {16, 14, 15},
            {16, 15, 16}
            },
         color={{70, 60, 60}}, 
         move=true,
         see=true
      },
      puddle = {
         name = "puddle",
         char={" ~ "},
         img = {
           {1, 1, 1}
           },
         color={{20, 60, 100,
            ember={30,90,110}}}, 
         move=true,
         see=true,
         effect={wet=3}
      },
      dirt = {
         name = "dirt",
         char={" . "},
         img = {
            {0, 9, 0}, 
            {0, 10, 0}
            },
         color={{80, 60, 20}}, 
         move=true,
         see=true
      },
      flower = {
         name = "flower",
         char={" * ", ".*."},
         img = {
            {1, 1, 1}
            },
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
         img = {
            {9, 12, 9}, 
            {9, 11, 9},
            {11, 12, 9},
            {10, 12, 11}
            },
         color={{20, 80, 10}}, 
         move=true,
         see=true
      },
      tallgrass = {
         name = "tall grass",
         char={"iii"},
         img = {
            {13, 13, 13}
            },
         color={{50, 120, 30}},
         move=true,
         see=false,
         hit = "grass",
         key = nil
      },
      tree = {
         name = "big trees",
         char = {"/\\\\", "//\\", "/V\\"},
         img = {
            {19, 20, 18},
            {18, 19, 20}
            },
         color={
            {100, 200, 50},
            {150, 200, 50}
            }, 
         move=false,
         see=false,
         hit = "treesmall",
         key = "chop"
      },
      treesmall = {
         name = "trees",
         char = {"/\\_", "^/\\", "./\\"},
         img = {
            {19, 20, 9},
            {9, 19, 20}
            },
         color={
            {100, 200, 50},
            {150, 200, 50}
            },
         move = false,
         see = false,
         hit = "stump",
         key = "chop"
      },
      stump = {
         name = "log",
         char={"c=o"},
         img = {
            {22, 23, 21},
            {21, 22, 23}
            },
         color={{200, 120, 90}}, 
         move=false,
         see=true,
         hit="twig",
         key="chop"
      },
      twig = {
         name = "broken branches",
         char={"_-_","-_-","_._","._-", "_-."},
         img = {
            {0, 24, 0}
            },
         color={{100, 80, 70}}, 
         move=true,
         see=true
      },
      dooropen = {
         name = "open door",
         char = {"|_|"},
         img = {
            {5, 8, 7}
            },
         color = {{128, 128, 128}},
         move = true,
         see = true,
         leave = "doorclose",
      },
      doorclose = {
         name = "closed door",
         char = {"|+|"},
         img = {
            {5, 6, 7}
            },
         color = {{200, 200, 200}},
         move = false,
         see = false,
         hit = "dooropen"
      },
      doorlocked = {
         name = "locked door",
         char = {"|X|"},
         color = {
            {200, 200, 200}
            },
         img = {5, 1, 7},
         move = false,
         see = false,
         hit = "dooropen",
         key = "key"
      },
      wall = {
         name = "wall",
         char = {"|#|"},
         img = {
            {2, 2, 2},
            {2, 3, 4},
            {2, 3, 2}
            },
         color = {{200, 200, 200}},
         move = false,
         see = false
      },
      cliff = {
         name = "cliff",
         char = {"%%%"},
         img = {
            {1, 1, 1}
            },
         color = {{180, 140, 80}},
         move = false,
         see = false,
         hit = "rubble",
         key = "dig"
      },
      rubble = {
         name = "rocks",
         char = {"oO°", "OoO", "0oO"},
         img = {
            {0, 1, 0}
            },
         color = {{200, 160, 100}},
         move = false,
         see = true,
         hit = "dirt",
         key = "dig"
      }
   }
   
return mapset