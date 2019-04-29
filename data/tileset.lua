local tileset = {
   width = 16,
   height = 16,
   
   tree = {
      bitmask = true,
      sheet = "trees",
      images = {
         {64, 96, 16, 32},
         {64, 64, 16, 32},
         {0, 96, 16, 32},
         {0, 64, 16, 32},
         {64, 0, 16, 32},
         {64, 32, 16, 32},
         {0, 0, 16, 32},
         {0, 32, 16, 32},
         {32, 96, 16, 32},
         {32, 64, 16, 32},
         {16, 96, 16, 32},
         {16, 64, 16, 32},
         {32, 0, 16, 32},
         {32, 32, 16, 32},
         {16, 0, 16, 32},
         {16, 32, 16, 32}
         },
      color = "default"
   },
   
   stump = {
      sheet = "ground",
      images = {
         {176, 32, 16, 16}
         },
      color = "warm"
   },
   
   path = {
      sheet = "ground",
      images = {
         {128, 32, 16, 16},
         {144, 32, 16, 16},
         {160, 32, 16, 16}
         },
      color = "cool"
   },
   
   dirt = {
      sheet = "ground",
      images = {
         {176, 0, 16, 16}
         },
      color = "default"
   },

   grass = {
      sheet = "ground",
      images = {
         {128, 16, 16, 16},
         {144, 16, 16, 16},
         {160, 16, 16, 16}
         },
      color = "default"
   },
   
   tallgrass = {
      bitmask = true,
      sheet = "ground",
      images = {
         {48, 112, 16, 16},
         {48, 96, 16, 16},
         {0, 112, 16, 16},
         {0, 96, 16, 16},
         {48, 64, 16, 16},
         {48, 96, 16, 16},
         {0, 64, 16, 16},
         {0, 96, 16, 16},
         {32, 112, 16, 16},
         {32, 96, 16, 16},
         {16, 112, 16, 16},
         {16, 96, 16, 16},
         {32, 64, 16, 16},
         {32, 96, 16, 16},
         {16, 64, 16, 16},
         {16, 96, 16, 16}
         },
      color = "warm"
   },
   
   blank = {
      sheet = "ground",
      images = {
         {176, 0, 16, 16}
         },
      color = "default"
   },
   
   doorclose = {
      sheet = "ground",
      images = {
         {128, 0, 16, 16}
         },
      color = "default"
   },
   
   dooropen = {
      sheet = "ground",
      images = {
         {144, 0, 16, 16}
         },
      color = "default"
   },
   
   doorlocked = {
      sheet = "ground",
      images = {
         {160, 0, 16, 16}
         },
      color = "default"
   },
   
   wall = {
      bitmask = true,
      sheet = "ground",
      images = {
         {112, 48, 16, 16},
         {112, 32, 16, 16},
         {64, 48, 16, 16},
         {64, 32, 16, 16},
         {112, 0, 16, 16},
         {112, 16, 16, 16},
         {64, 0, 16, 16},
         {64, 16, 16, 16},
         {96, 48, 16, 16},
         {96, 32, 16, 16},
         {80, 48, 16, 16},
         {80, 32, 16, 16},
         {96, 0, 16, 16},
         {96, 16, 16, 16},
         {80, 0, 16, 16},
         {80, 16, 16, 16}
         },
      color = "default"
   }

}


return tileset