import std/[sequtils, strutils, strtabs]

let configPath = "./config"

var orderedWords, orderedSources: seq[string]

# Pre-processing config
let config = configPath.open
while not config.endOfFile:
  let l = config.readLine
  var word: string
  for c in l:
    if c == '{':
      orderedWords.add(word)
      orderedSources.add("")
      word = ""
    elif c == '}':
      let wordSplit = word.split(':')
      orderedSources.add(wordSplit[0])
      orderedWords.add(wordSplit[1])
    else:
      word.add(c)      
config.close()

# Reading KEYxVAL style files
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
      let data = readFile("/proc/sys/kernel/" & f).strip
      fetched[i][f] = data
  of "board":
    const files = ["name", "vendor", "version"]
    for f in files:
      let data = readFile("/sys/devices/virtual/dmi/id/board_" & f).strip
      fetched[i][f] = data
  of "os":
    let osFetched = processFile("/etc/os-release", '=')
    for (k, v) in osFetched: fetched[i][k.toLower] = v
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
    let memFetched = processFile("/proc/meminfo", ':')

    for (k, v) in memFetched:
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
  else: discard

for i, _ in sources.pairs:
  echo $sources[i], " is ", $fetched[i], "\n"
