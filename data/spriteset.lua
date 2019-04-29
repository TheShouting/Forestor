local spriteset = {

   blank = {
      sheet = "objects",
      color = "highlight",
      idle = {
         {0, 0, 16, 32}
         },
      ground = {
         {0, 0, 16, 32}
         },
      hand = {
         {0, 0, 16, 32}
         }
      },
   player = {
      sheet = "objects",
      color = "highlight",
      framerate = 0.1,
      idle = {
         {16, 0, 16, 32}
         }
      },
   goblin = {
      sheet = "objects",
      color = "highlight",
      framerate = 0.1,
      idle = {
         {32, 0, 16, 32}
         }
      },
   potion = {
      sheet = "objects",
      color = "highlight",
      framerate = 0.1,
      ground = {
         {0, 32, 16, 32}
         }
      },
   sword = {
      sheet = "objects",
      color = "highlight",
      framerate = 0.1,
      ground = {
         {32, 32, 16, 32}
         },
      hand = {
         {32, 64, 16, 32}
         }
      },
   axe = {
      sheet = "objects",
      color = "highlight",
      framerate = 0.1,
      ground = {
         {48, 32, 16, 32}
         },
      hand = {
         {64, 64, 16, 32}
         }
      },
   hammer = {
      sheet = "objects",
      color = "highlight",
      framerate = 0.1,
      ground = {
         {64, 32, 16, 32}
         },
      hand = {
         {48, 64, 16, 32}
         }
      }

}


return spriteset