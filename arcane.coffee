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

# Add them all only once starting on C
#
#         CCDDEFFGGAAB Weight
#          # #  # # #    |
addScale "X X XX X X X", 1 # Test
addScale "XX XX XX  XX", 1 # Test
addScale "X XX X      ", 1
addScale "X XX X   X  ", 1
addScale "X XX X X X  ", 1

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

