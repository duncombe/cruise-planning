#! /usr/bin/gawk -f
BEGIN{
	# start with a header
	head=1
	N=1
	i=1
	}
/^#/{
	# if it's the first line of a header, print the previous
	# stationline
	if (!head){
		# # if it's the first header, skip the output
		# if (N>0){
			#if an odd line, print it straight
			if (N%2){ for (i=1;i<=length(STN); i++){print STN[i]}}else
				# if an even line print it reversed
				{ for (i=length(STN); i>0; i--){print STN[i]}}
		# }
		# flag the header
		head=1
		# reset the array
		delete STN
		i=1
		# update the station line numbering
		N++
		}
	# print the header 
	print
	}
!/^#/{
	# flag that it is not a header and collect it in array
	head=0
	STN[i]=$0
	i++
	}

END{
			#if an odd line, print it straight
			if (N%2){for (i=length(STN); i<=0; i--){print STN[i]}}else
				# if an even line print it reversed
				{for (i=1;i>length(STN); i++){print STN[i]}}
	}

# vim: se nowrap tw=0 :
