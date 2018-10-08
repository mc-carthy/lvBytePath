defaultColour = {222 / 255, 222 / 255, 222 / 255 }
backgroundColour = {16 / 255, 16 / 255, 16 / 255 }
ammoColour = {123 / 255, 200 / 255, 164 / 255 }
boostColour = {76 / 255, 195 / 255, 217 / 255 }
hpColour = {241 / 255, 103 / 255, 69 / 255 }
skillPointColour = {255 / 255, 198 / 255, 93 / 255 }

defaultColours = { defaultColour, hpColour, ammoColour, boostColour, skillPointColour }
negativeColours = {
    { 1 - defaultColour[1], 1 - defaultColour[2], 1 - defaultColour[3] }, 
    { 1 - hpColour[1], 1 - hpColour[2], 1 - hpColour[3] }, 
    { 1 - ammoColour[1], 1 - ammoColour[2], 1 - ammoColour[3] }, 
    { 1 - boostColour[1], 1 - boostColour[2], 1 - boostColour[3] }, 
    { 1 - skillPointColour[1], 1 - skillPointColour[2], 1 - skillPointColour[3]}
}
allColours = Tbl.append(defaultColours, negativeColours)

attacks = {
    ['Neutral'] = { cooldown = 0.24, ammo = 0, abbreviation = 'N', colour = defaultColour },
    ['Double'] = { cooldown = 0.32, ammo = 2, abbreviation = '2X', colour = ammoColour },
    ['Triple'] = { cooldown = 0.32, ammo = 3, abbreviation = '3X', colour = boostColour },
    ['Rapid'] = { cooldown = 0.12, ammo = 1, abbreviation = 'RP', colour = defaultColour },
    ['Spread'] = { cooldown = 0.16, ammo = 1, abbreviation = 'RS', colour = defaultColour },
    ['Back'] = { cooldown = 0.32, ammo = 2, abbreviation = 'BK', colour = skillPointColour },
    ['Side'] = { cooldown = 0.32, ammo = 3, abbreviation = 'SI', colour = boostColour },
    ['Homing'] = { cooldown = 0.56, ammo = 4, abbreviation = 'H', colour = skillPointColour }
}

enemies = {
    'Rock',
    'Shooter'
}