BEGIN{ 	if (MaxDepth==""){MaxDepth=9999} 
	if (MinDepth==""){MinDepth=-9999}
	if (Skip==""){Skip=0}
	}
/^#/{print; place=-Skip}
!/^#/ && $4>=MinDepth && $4<=MaxDepth && $3>(place+Skip){print; place=$3} 


