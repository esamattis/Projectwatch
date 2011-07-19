colors =
  "black":        "0;30"
  "dark gray":    "1;30"
  "light gray":   "0;37"
  "blue":         "0;34"
  "light blue":   "1;34"
  "green":        "0;32"
  "light green":  "1;32"
  "cyan":         "0;36"
  "light cyan":   "1;36"
  "red":          "0;31"
  "light red":    "1;31"
  "purple":       "0;35"
  "light purple": "1;35"
  "brown":        "0;33"
  "yellow":       "1;33"
  "white":        "1;37"

exports.setColor = (color) ->
  process.stdout.write("\033[#{ colors[color] }m")

exports.resetColor = ->
    process.stdout.write("\033[00m")

