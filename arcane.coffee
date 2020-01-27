# Gods, it feels good to be back to a more civilized language after finishing a 1000 lines C++ project

# Stuff what we need later
Array::shuffle ?= ->
  if @length > 1 then for i in [@length-1..1]
    j = Math.floor Math.random() * (i + 1)
    [@[i], @[j]] = [@[j], @[i]]
  this

p = (text) -> process.stdout.write text + "\n"



# Those numbers can be generated directly
arcana   = Math.floor(Math.random() * 22)
patternB = Math.floor(Math.random() * 65536)
patternC = Math.floor(Math.random() * 65536)
patternD = Math.floor(Math.random() * 65536)
patternE = Math.floor(Math.random() * 65536)
wish     = Math.floor(Math.random() * 4)



# BPM: values between 90 and 150 twice as likely.
bpmTable = [60..180].concat [90..150]
bpm = bpmTable[ Math.floor(Math.random() * bpmTable.length ) ]



# Scales. First we build the table
scaleTable = []
addScale = (scale, weight) ->
    for i in [1..weight]
        scaleTable.push scale

# Add them all only once, starting on C.
# Weigth of 3 means thrice as likely to appear than weight of 1.
#
# Only a small selection for now. 
# Once people understand what Arcane does, I'd like to have experts help me
# decide which ones to add, which to omit, which weights would be best.
#
# I AM NOT SEEKING TO ADD A FULL LIST OF EVERY CONCEIVABLE SCALE EVER.
# Please re-read the line above.
#
# I'll avoid using a lot of fancy theory words, and just explain the big idea:
# shoving any random shit into the quantizer should sound fun and musical to
# people from most countries.
#
# Until that conversation happens, I'll start out with a very limited, 
# safe curation, and add more exotic scales later.

# 8 notes scales
#         CCDDEFFGGAAB Weight  Name
#          # #  # # #    |      |
addScale "X X XX XXX X", 1 # Bebop Major

# 7 notes scales
#         CCDDEFFGGAAB Weight  Name
#          # #  # # #    |      |
addScale "X X XX X X X", 4 # Major, Natural Minor
addScale "X XX X X X X", 1 # Melodic Minor
addScale "X XX X XX  X", 1 # Harmonic Minor
addScale "XX  XX XX X ", 1 # Spanish Gypsy

# 6 notes scales
#         CCDDEFFGGAAB Weight  Name
#          # #  # # #    |      |
addScale "X  X XXX  X ", 1 # Minor Blues

# 5 notes scales
#         CCDDEFFGGAAB Weight  Name
#          # #  # # #    |      |
addScale "X  X X X  X ", 1 # Minor Pentatonic



# Select the scale and rotate it randomly
selectedScale = scaleTable[ Math.floor(Math.random() * scaleTable.length ) ]
rotationSteps = Math.floor(Math.random() * 12)
if rotationSteps > 0
    for i in [1..rotationSteps]
        selectedScale = selectedScale[selectedScale.length - 1] + selectedScale.substring(0, selectedScale.length - 1)

# Convert it to binary
selectedScale = selectedScale.replace(/X/g, "1").replace(/ /g, "0")
scale = parseInt(selectedScale, 2)

# Build an array of valid scale notes & pad end with additional notes
notePattern = []
for i in [0..12]
    notePattern.push i if selectedScale[i] == "1"
	
additionalNotes = notePattern
notePattern = notePattern.shuffle()
additionalNotes = additionalNotes.shuffle()

if notePattern.length < 8
    for i in [0..7 - notePattern.length]
        notePattern.push(additionalNotes[i])




# Done. We print it. Pipelines do the rest.
# No, I'm not gonna whip out a JSON parser to write 20 lines. Frick the h*ck off.

p "{"
p "  \"arcana\": #{arcana},"
p "  \"patternB\": #{patternB},"
p "  \"patternC\": #{patternC},"
p "  \"patternD\": #{patternD},"
p "  \"patternE\": #{patternE},"
p "  \"scale\": #{scale},"
p "  \"notePattern\": ["
p "    #{notePattern[0]},"
p "    #{notePattern[1]},"
p "    #{notePattern[2]},"
p "    #{notePattern[3]},"
p "    #{notePattern[4]},"
p "    #{notePattern[5]},"
p "    #{notePattern[6]},"
p "    #{notePattern[7]}"
p "    ],"
p "  \"bpm\": #{bpm},"
p "  \"wish\": #{wish}"
p "}"

