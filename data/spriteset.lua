local spriteset = {

   blank = {
      sheet = "kenney",
      color = "highlight",
      idle = {
         {357, 425, 16, 16}
         },
      ground = {
         {357, 425, 16, 16}
         },
      hand = {
         {357, 425, 16, 16}
         }
      },
   portal = {
      sheet = "kenney",
      color = "highlight",
      framerate = 0.1,
      idle = {
         {238, 170, 16, 16}
         }
      },
   player = {
      sheet = "characters",
      color = "highlight",
      framerate = 0.1,
      idle = {
         {0, 0, 16, 16}
         },
        move = {
        	{0, 0, 16, 16},
        	{0, 16, 16, 16},
        	{0, 32, 16, 16},
        	{0, 48, 16, 16}
        }
      },
   goblin = {
      sheet = "characters",
      color = "highlight",
      framerate = 0.1,
      idle = {
         {32, 0, 16, 16}
      },
      move = {
         {32, 0, 16, 16},
         {32, 16, 16, 16},
         {32, 32, 16, 16},
         {32, 48, 16, 16}
         }
      },
   potion = {
      sheet = "kenney",
      color = "highlight",
      framerate = 0.1,
      ground = {
         {272, 425, 16, 16}
         }
      },
   sword = {
      sheet = "kenney",
      color = "highlight",
      framerate = 0.1,
      ground = {
         {34, 476, 16, 16}
         },
      hand = {
         {34, 476, 16, 16}
         }
      },
   axe = {
      sheet = "kenney",
      color = "highlight",
      framerate = 0.1,
      ground = {
         {170, 493, 16, 16}
         },
      hand = {
         {170, 493, 16, 16}
         }
      },
   hammer = {
      sheet = "kenney",
      color = "highlight",
      framerate = 0.1,
      ground = {
         {85, 493, 16, 16}
         },
      hand = {
         {85, 493, 16, 16}
         }
      },
   shield = {
      sheet = "kenney",
      color = "highlight",
      framerate = 0.1,
      ground = {
         {119, 408, 16, 16}
         },
      hand = {
         {119, 408, 16, 16}
         }
      }

}


return spriteset