# exclude stations not between MAXDEPTH and MINDEPTH
# skip stations closer together than SKIP km 
# skip lines closer together than LINE km 
BEGIN{ 	if (MAXDEPTH==""){MAXDEPTH=99999} 
	if (MINDEPTH==""){MINDEPTH=-99999}
	if (SKIP==""){SKIP=0}
	if (LINE==""){LINE=0}
	d=-99999
	flag=1
	FS="\t"
	}
/^#/{print; place=-SKIP; if(flag){d0=d}}
/^# Line/{d=$4; if(d-d0>=LINE){flag=1}else{flag=0}}
!/^#/ && $4>=MINDEPTH && $4<=MAXDEPTH && $3>(place+SKIP) && (d-d0)>=LINE{print; place=$3} 


