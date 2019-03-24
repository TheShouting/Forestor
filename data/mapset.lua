local mapset = {
      blank = {
         name = "blank space",
         char={" . "},
         img = {
            {0, 9, 0}
            },
         color={
         {96, 96, 96},
         {128, 128, 128},
         {160, 160, 160}
         }, 
         move=true,
         see=true
      },
      path = {
         name = "path",
         char = {".o.", " o.", ".o ", " o "}, 
         img = {
            {0, 25, 0},
            {27, 25, 0},
            {0, 25, 27},
            {27, 25, 27},
            {0, 26, 0},
            {0, 26, 27},
            {27, 26, 0},
            {27, 26, 27}
            },
         color={{70, 60, 60}}, 
         move=true,
         see=true
      },
      puddle = {
         name = "puddle",
         char={" ~ "},
         img = {
           {9, 10, 9},
           {9, 9, 9}
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
            {13, 14, 13}
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
            {15, 16, 15},
            {16, 15, 16},
            {15, 15, 15},
            {16, 16, 16}
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
            {17, 18, 19},
            {19, 17, 18}
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
            {20, 21, 19},
            {19, 20, 21}
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
            {20, 21, 22},
            {22, 20, 21}
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
            {0, 22, 0}
            },
         color={{100, 80, 70}}, 
         move=true,
         see=true
      },
      dooropen = {
         name = "open door",
         char = {"|_|"},
         img = {
            {3, 6, 3}
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
            {3, 4, 3}
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
         img = {3, 5, 3},
         move = false,
         see = false,
         hit = "dooropen",
         key = "key"
      },
      wall = {
         name = "wall",
         char = {"|#|"},
         img = {
            {2, 2, 2}
            },
         color = {{200, 200, 200}},
         move = false,
         see = false
      },
      cliff = {
         name = "cliff",
         char = {"%%%"},
         img = {
            {28, 29, 28},
            {29, 28, 29},
            {28, 28, 29},
            {29, 28, 28}
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
      },
   portal = {
         name = "magical ground",
         char = {"{0}"},
         img = {
            {33, 34, 35}
            },
         color = {
            {128,0,128,ember={255,128,255}}
            },
         move = true,
         see = true
      }
   }
   
return mapset