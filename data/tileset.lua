local tileset = {
   width = 16,
   height = 16,
   
   tree = {
      bitmask = false,
      sheet = "kenney",
      images = {
         {0, 17, 16, 16},
         {17, 17, 16, 16},
         {34, 17, 16, 16},
         {51, 17, 16, 16},
         {68, 17, 16, 16},
         },
      color = "default"
   },
   
   stump = {
      sheet = "kenney",
      images = {
         {102, 34, 16, 16}
         },
      color = "warm"
   },
   
   path = {
      sheet = "kenney",
      images = {
         {51, 0, 16, 16},
         {68, 0, 16, 16}
         },
      color = "cool"
   },
   
   dirt = {
      sheet = "kenney",
      images = {
         {0, 0, 16, 16}
         },
      color = "warm"
   },

   grass = {
      sheet = "kenney",
      images = {
         {85, 0, 16, 16},
         {102, 0, 16, 16},
         {119, 0, 16, 16}
         },
      color = "default"
   },
   
   tallgrass = {
      bitmask = false,
      sheet = "kenney",
      images = {
         {0, 34, 16, 16}
         },
      color = "warm"
   },
   
   blank = {
      sheet = "kenney",
      images = {
         {0, 0, 16, 16}
         },
      color = "default"
   },
   
   doorclose = {
      sheet = "kenney",
      images = {
         {51, 153, 16, 16}
         },
      color = "highlight"
   },
   
   dooropen = {
      sheet = "kenney",
      images = {
         {34, 153, 16, 16}
         },
      color = "highlight"
   },
   
   doorlocked = {
      sheet = "kenney",
      images = {
         {0, 153, 16, 16}
         },
      color = "highlight"
   },
   
   wall = {
      bitmask = false,
      sheet = "kenney",
      images = {
         {170, 289, 16, 16},
         {102, 221, 16, 16},
         {119,  255, 16, 16}
         },
      color = "highlight"
   }

}


return tileset