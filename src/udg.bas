10 REM COPY ROUTINE
11 FOR I=0 TO 26: READ X: POKE 828+I,X: NEXT I
12 DATA 169,000,160,208,133,095,132,096 
13 DATA 169,000,160,224,133,090,132,091
14 DATA 169,000,160,064,133,088,132,089
15 DATA 076,191,163
16 REM COPY $D000-$DFFF -> $3000-$3FFF
20 REM CHAR SET ROM INTO RAM 
21 POKE 56334,PEEK(56334) AND 254
22 POKE 1,PEEK(1) AND 251
23 SYS 828
24 POKE 1,PEEK(1) OR 4
25 POKE 56334,PEEK(56334) OR 1
26 POKE 53272,PEEK(53272) AND 240 OR 12
60 REM GERMAN MUTATED VOWEL
61 FOR A=13136 TO 13279: READ ZE: POKE A,ZE: NEXT A

62 DATA 0,170,254,254,0,239,239,239
63 DATA 0,170,254,254,0,239,239,239
64 DATA 0,254,254,254,0,239,239,170
65 DATA 0,254,254,254,0,239,239,170

66 DATA 0,127,127,0,111,111,96,109
67 DATA 0,254,254,0,182,118,230,214
68 DATA 107,103,110,109,0,127,127,0
69 DATA 182,6,246,246,0,254,254,0

70 DATA 0,7,24,32,64,64,64,56
71 DATA 0,224,24,100,18,2,2,28
72 DATA 71,120,71,86,71,126,31,0
73 DATA 226,10,210,170,210,166,248,0

74 DATA 0,85,0,170,85,170,255,255

75 DATA 0,42,85,0,127,74,90,77
76 DATA 0,170,84,0,254,162,182,182
77 DATA 90,74,127,127,0,42,85,0
78 DATA 182,182,254,254,0,170,84,0

79 DATA 170,85,170,85,170,85,170,85

90 POKE 53280,0: POKE 53281,0

100 PRINT CHR$(28)+CHR$(170)+CHR$(171)
101 PRINT CHR$(150)+CHR$(172)+CHR$(173)
102 PRINT CHR$(158)+CHR$(174)+CHR$(175)
103 PRINT CHR$(158)+CHR$(176)+CHR$(177)
104 PRINT CHR$(155)+CHR$(178)+CHR$(179)
105 PRINT CHR$(159)+CHR$(180)+CHR$(181)
106 PRINT CHR$(31)+CHR$(182)
107 PRINT CHR$(129)+CHR$(183)+CHR$(184)
108 PRINT CHR$(129)+CHR$(185)+CHR$(186)
109 PRINT CHR$(31)+CHR$(187)