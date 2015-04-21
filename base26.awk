#! /usr/bin/gawk -f
# convert a decimal number to bijective hexavigesimal (base 26 without 0)
# 
{	s=""
	a=$1
	c=0
	x=1
	while (a>=x){
		c++
		a-=x
		x*=26
		}
	for (i=0;i<c;i++){
		s=sprintf("%c",(a%26)+65) s 
		a=int(a/26)
	}
	print s
}

# # from javascript found on stackexchange 
# alpha = "abcdefghijklmnopqrstuvwxyz";
# 
# function hex(a) {
#   // First figure out how many digits there are.
#   a += 1; // This line is funky
#   c = 0;
#   var x = 1;      
#   while (a >= x) {
#     c++;
#     a -= x;
#     x *= 26;
#   }
# 
#   // Now you can do normal base conversion.
#   var s = "";
#   for (var i = 0; i < c; i++) {
#     s = alpha.charAt(a % 26) + s;
#     a = Math.floor(a/26);
#   }
# 
#   return s;
# }

