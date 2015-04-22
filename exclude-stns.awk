# exclude stations not between MAXDEPTH and MINDEPTH
# skip stations closer together than SKIP km 
BEGIN{ 	if (MAXDEPTH==""){MAXDEPTH=99999} 
	if (MINDEPTH==""){MINDEPTH=-99999}
	if (SKIP==""){SKIP=0}
	}
/^#/{print; place=-SKIP}
!/^#/ && $4>=MINDEPTH && $4<=MAXDEPTH && $3>(place+SKIP){print; place=$3} 


