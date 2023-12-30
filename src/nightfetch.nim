import std/[sequtils, strutils, strtabs, osproc]
import distros

let configPath = "./config"

var orderedWords, orderedSources: seq[string]

# Read KEYxVAL style files
proc processFile(path: string, separator: char): seq[(string, string)] =
  let f = path.open
  defer: f.close

  while not f.endOfFile:
    let l = f.readLine.replace("\"")
    var key, val: string

    if l.contains(separator):
      key = l.split(separator)[0].strip
      val = l.split(separator)[1].strip
    else:
      (key, val) = ("", "")

    result.add((key, val))

# Get a specific KEYxVAL pair from KEYxVAL file
proc processKey(path: string, separator: char, key: string): string =
  let f = path.open
  defer: f.close

  while not f.endOfFile:
    let l = f.readLine.replace("\"")

    if l.contains(separator):
      let k = l.split(separator)[0].strip
      let v = l.split(separator)[1].strip

      if k == key:
        result = v
        break
    
# Style config and logos
proc styleLine(line: string, unstyle = false): string =
  result = line & "{ }"

  if result.contains("{cauto}"):
    var id = processKey("/etc/os-release", '=', "ID")
    let id_like = processKey("/etc/os-release", '=', "ID_LIKE").splitWhitespace

    if not ids.contains(id):
      for i in id_like:
        if ids.contains(id):
          id = i

    let color = properties[ids.find(id)]["color"]
    result = result.replace("{cauto}", color)
  
  const colors = ["{c0}", "{c1}", "{c2}", "{c3}", "{c4}", "{c5}", "{c6}", "{c7}"]
  if unstyle:
    for c in colors: result = result.replace(c, "")
  else:
    for i, c in colors.pairs:
      result = result.replace(c, "\x1b[3" & $i & "m")

  const fonts = ["{ }", "{b}", "{d}", "{i}", "{u}"]
  if unstyle:
    for f in fonts: result = result.replace(f, "")
  else:
    for i, f in fonts.pairs:
      result = result.replace(f, "\x1b[" & $i & "m")
    
# Processing config
let config = configPath.open
while not config.endOfFile:
  let l = config.readLine.styleLine & '{'
  # idk why but it doesn't register some symbols without this `& '{'`
  if l[0] != '#':
    var word: string
    for c in l:
      if c == '{' or c == '\n':
        orderedWords.add(word)
        orderedSources.add("")
        word = ""
      elif c == '}':
        let wordSplit = word.split(':')
        orderedSources.add(wordSplit[0])
        orderedWords.add(wordSplit[1])
        word = ""
      else:
        word.add(c)
        
  orderedWords.add("\n")
  orderedSources.add("")
      
config.close()

# Fetching the values
var sources = orderedSources.deduplicate()
  .filter(proc(x: string): bool = x != "")
var fetched = newSeq[StringTableRef](sources.len)

for i, e in sources.pairs:
  fetched[i] = newStringTable(modeStyleInsensitive)

  case e
  of "kernel":
    const files = ["arch", "hostname", "osrelease", "ostype"]
    for f in files:
      fetched[i][f] = readFile("/proc/sys/kernel/" & f).strip
  of "board":
    const files = ["name", "vendor", "version"]
    for f in files:
      fetched[i][f] = readFile("/sys/devices/virtual/dmi/id/board_" & f).strip
  of "os":
    for (k, v) in processFile("/etc/os-release", '='):
      fetched[i][k.toLower] = v
  of "cpu":
    var processor: string
    
    for (k, v) in processFile("/proc/cpuinfo", ':'):
      case k
      of "processor": processor = v
      of "vendor_id": fetched[i]["vendor"] = v
      of "model": fetched[i]["model"] = v
      of "model name": fetched[i]["name"] = v
      of "siblings": fetched[i]["threads"] = v
      of "cpu cores": fetched[i]["cores"] = v
      of "cpu MHz":
        fetched[i]["mhz_" & processor] = v
        let ghz = v.parseFloat / 1000
        fetched[i]["ghz_" & processor] = ghz.formatFloat(ffDecimal, 3)
      else: discard
  of "mem":
    var memfree, memtotal, swapfree, swaptotal: int
    let meminfo = processFile("/proc/meminfo", ':')

    for (k, v) in meminfo:
      if k.contains("Total") or k.contains("Free"):
        let dataKB: int = v.replace(" kB", "").parseInt
        let dataMB: int = dataKB div 1024
        let dataGB: int = dataMB div 1024

        fetched[i][k.toLower() & "_kb"] = $dataKB
        fetched[i][k.toLower() & "_mb"] = $dataMB
        fetched[i][k.toLower() & "_gb"] = $dataGB

        case k
        of "MemFree":   memfree = dataKB
        of "MemTotal":  memtotal = dataKB
        of "SwapFree":  swapfree = dataKB
        of "SwapTotal": swaptotal = dataKB
        else: discard

    for j in ["mem", "swap"]:
      var total, free: int
      case j
      of "mem": (free, total) = (memfree, memtotal)
      of "swap": (free, total) = (swapfree, swaptotal)
      
      let usedKB = total - free
      let usedMB = usedKB div 1024
      let usedGB = usedMB div 1024
      
      fetched[i][j & "used_kb"] = $usedKB
      fetched[i][j & "used_mb"] = $usedMB
      fetched[i][j & "used_gb"] = $usedGB
  of "uptime":
    let uptime = readFile("/proc/uptime").split(' ')[0].parseFloat.toInt
    let
      hours: int = uptime div 3600
      mins:  int = (uptime - hours * 3600) div 60
      secs:  int = uptime - hours * 3600 - mins * 60

    fetched[i]["hours"] = $hours
    fetched[i]["mins"] = $mins
    fetched[i]["secs"] = $secs
  of "distro":
    var id = processKey("/etc/os-release", '=', "ID")
    let id_like = processKey("/etc/os-release", '=', "ID_LIKE").splitWhitespace

    if not ids.contains(id):
      for i in id_like:
        if ids.contains(id):
          id = i

    let distro = properties[ids.find(id)]

    let logo_width = distro["logo_0"].styleLine(true).len
    let logo_x = ' '.repeat(logo_width)
    distro["logo_x"] = logo_x
    
    var j = 0
    while distro.contains("logo_" & $j):
      distro["logo_" & $j] = distro["logo_" & $j].styleLine
      j += 1
    
    let pm_out = distro["pm_command"].execProcess
    if not pm_out.contains("not found") or pm_out.contains("No such"):
     distro["pm_count"] = $pm_out.countLines

    fetched[i] = distro
  else: discard

var words: string
for i, e in orderedWords.pairs:
  let source = orderedSources[i]

  if source != "":
    let sourceFetched = fetched[sources.find(source)]

    if sourceFetched.contains(e):
      words.add(sourceFetched[e])
    elif source == "distro" and e.contains("logo_"):
      words.add(sourceFetched["logo_x"])
  else:
    words.add(e)

echo words
