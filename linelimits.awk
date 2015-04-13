BEGIN{ started=0}
!/^#/ && !started{print; started=1}
started && !/^#/{last=$0}
started && /^#/{print last; started=0} 
END{print last} 

