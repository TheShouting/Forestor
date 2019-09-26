local tileset = {
	width = 16,
	height = 16,
	
	tree = {
		bitmask = false,
		sheet = "forest",
		images = {
			{0, 0, 16, 16},
			{16, 0, 16, 16},
			{32, 0, 16, 16},
			{48, 0, 16, 16}
			},
		color = "green"
	},
	
	stump = {
		sheet = "forest",
		images = {
			{0, 16, 16, 16},
			{16, 16, 16, 16},
			{16, 16, 16, 16},
			{0, 16, 16, 16}
			},
		color = "brown"
	},
	
	path = {
		sheet = "forest",
		images = {
			{80, 16, 16, 16},
			{96, 16, 16, 16}
			},
		color = "stone"
	},
	
	dirt = {
		bitmask = true,
		sheet = "forest",
		images = {
			{48, 112, 16, 16},	--0
			{48, 96, 16, 16},	--1
			{0, 112, 16, 16},	--2
			{0, 96, 16, 16},	--3
			{48, 64, 16, 16},	--4
			{48, 80, 16, 16},	--5
			{0, 64, 16, 16},	--6
			{0, 80, 16, 16},	--7
			{32, 112, 16, 16},	--8
			{32, 96, 16, 16},	--9
			{16, 112, 16, 16},	--10
			{16, 96, 16, 16},	--11
			{32, 64, 16, 16},	--12
			{32, 80, 16, 16},	--13
			{16, 64, 16, 16},	--14
			{16, 80, 16, 16}	--15
			},
		color = "brown"
		},
	
	grass = {
		bitmask = false,
		sheet = "forest",
		images = {
			{16, 80, 16, 16},
			{16, 80, 16, 16},
			{64, 0, 16, 16},
			{80, 0, 16, 16}
			},
		color = "green"
		},
	
	tallgrass = {
		bitmask = false,
		sheet = "forest",
		images = {
			{96, 0, 16, 16},
			{112, 0, 16, 16}
			},
		color = "green"
		},
	
	blank = {
		sheet = "forest",
		images = {
			{16, 80, 16, 16}
			},
		color = "green"
		},
	
	doorclose = {
		sheet = "forest",
		images = {
			{96, 48, 16, 16}
			},
		color = "highlight"
		},
	
	dooropen = {
		sheet = "forest",
		images = {
			{112, 48, 16, 16}
			},
		color = "highlight"
		},
	
	doorlocked = {
		sheet = "forest",
		images = {
			{80, 48, 16, 16}
			},
		color = "highlight"
		},
	
	puddle = {
		bitmask = false,
		sheet = "forest",
		images = {
			{32, 16, 16, 16},
			{48, 16, 16, 16},
			{64, 16, 16, 16}
			},
		color = "blue"
		},
	
	wall = {
		bitmask = false,
		sheet = "forest",
		images = {
			{0, 32, 16, 16},
			{16, 32, 16, 16},
			{32, 32, 16, 16},
			{48, 32, 16, 16},
			{64, 32, 16, 16}
			},
		color = "stone"
		},
	
	floor = {
		bitmask = false,
		sheet = "forest",
		images = {
			{96, 32, 16, 16}
		},
		color = "brown"
	},
	
	cliff = {
		bitmask = false,
		sheet = "forest",
		images = {
			{0, 48, 16, 16},
			{16, 48, 16, 16},
			{32, 48, 16, 16},
			{48, 48, 16, 16},
			{64, 48, 16, 16}
			},
		color = "brown"
		}
	
	}


return tileset