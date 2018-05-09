defaultColour = {222, 222, 222}
backgroundColour = {16, 16, 16}
ammoColour = {123, 200, 164}
boostColour = {76, 195, 217}
hpColour = {241, 103, 69}
skillPointColour = {255, 198, 93}

defaultColours = { defaultColour, hpColour, ammoColour, boostColour, skillPointColour }
negativeColours = {
    { 255 - defaultColour[1], 255 - defaultColour[2], 255 - defaultColour[3] }, 
    { 255 - hpColour[1], 255 - hpColour[2], 255 - hpColour[3] }, 
    { 255 - ammoColour[1], 255 - ammoColour[2], 255 - ammoColour[3] }, 
    { 255 - boostColour[1], 255 - boostColour[2], 255 - boostColour[3] }, 
    { 255 - skillPointColour[1], 255 - skillPointColour[2], 255 - skillPointColour[3]}
}
allColours = Tbl.append(defaultColours, negativeColours)

attacks = {
    ['Neutral'] = { cooldown = 0.24, ammo = 0, abbreviation = 'N', colour = defaultColour },
}