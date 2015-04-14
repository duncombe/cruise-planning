BEGIN{ 	if (MaxDepth==""){MaxDepth=9999} 
	if (MinDepth==""){MinDepth=-9999}
	}
/^#/{print}
!/^#/ && $4>=MinDepth && $4<=MaxDepth{print}

