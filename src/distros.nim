import std/strtabs


const ids* = @[ # TODO: check for rightness
  "alpine", "arch", "arco", "artix",
  "centos", "crystal",
  "debian", "devuan",
  "endeavouros",
  "fedora",
  "gentoo", "guix",
  "hyperbola",
  "linuxmint",
  "mageia", "manjaro", "mx",
  "neon", "nixos",
  "opensuse-tumbleweed", "opensuse-leap",
  "parabola", "popos", "pureos",
  "raspbian",
  "slackware", "solus",
  "ubuntu",
  "void"
]

let properties* = @[
  { "pm_name":    "apk",
    "pm_command": "apk info",
    "color": "{c4}",
    "logo_tiny": "",
    "logo_0": "{c4}      /\\          ",
    "logo_1": "{c4}     /  \\         ",
    "logo_2": "{c4}    / /\\ \\  /\\    ",
    "logo_3": "{c4}   / /  \\ \\/  \\   ",
    "logo_4": "{c4}  / /    \\ \\/\\ \\  ",
    "logo_5": "{c4} / / /|   \\ \\ \\ \\ ",
    "logo_6": "{c4}/_/ /_|    \\_\\ \\_\\"}.newStringTable,
  { "pm_name":    "pacman",
    "pm_command": "pacman -Q",
    "color": "{c6}",
    "logo_tiny": "",
    "logo_0": "{c6}      /\\      ",
    "logo_1": "{c6}     /  \\     ",
    "logo_2": "{c6}    /\\   \\    ",
    "logo_3": "{c6}   /      \\   ",
    "logo_4": "{c6}  /   ,,   \\  ",
    "logo_5": "{c6} /   |  |  -\\ ",
    "logo_6": "{c6}/_-''    ''-_\\"}.newStringTable,
  { "pm_name":    "pacman",
    "pm_command": "pacman -Q",
    "color": "{c4}",
    "logo_tiny": "",
    "logo_0": "{c4}      /\\      ",
    "logo_1": "{c4}     /  \\     ",
    "logo_2": "{c4}    / /\\ \\    ",
    "logo_3": "{c4}   / /  \\ \\   ",
    "logo_4": "{c4}  / /    \\ \\  ",
    "logo_5": "{c4} / / _____\\ \\ ",
    "logo_6": "{c4}/_/  `----.__\\"}.newStringTable,
  { "pm_name":    "pacman",
    "pm_command": "pacman -Q",
    "color": "{c6}",
    "logo_tiny": "",
    "logo_0": "{c6}      /\\      ",
    "logo_1": "{c6}     /  \\     ",
    "logo_2": "{c6}    /`'.,\\    ",
    "logo_3": "{c6}   /     ',   ",
    "logo_4": "{c6}  /      ,`\\  ",
    "logo_5": "{c6} /   ,.'`.  \\ ",
    "logo_6": "{c6}/.,'`     `'.\\"}.newStringTable,
  # TODO: Bedrock
  { "pm_name":    "rpm",
    "pm_command": "rpm -qa",
    "color": "{c5}",
    "logo_tiny": "",
    "logo_0": "{c2} ____{c3}^{c5}____ ",
    "logo_1": "{c2} |\\  {c3}|{c5}  /| ",
    "logo_2": "{c2} | \\ {c3}|{c5} / | ",
    "logo_3": "{c5}<---- {c4}---->",
    "logo_4": "{c4} | / {c2}|{c3} \\ | ",
    "logo_5": "{c4} |/__{c2}|{c3}__\\| ",
    "logo_6": "{c2}     v     "}.newStringTable,
  { "pm_name":    "pacman",
    "pm_command": "pacman -Q",
    "color": "{c5}",
    "logo_tiny": "",
    "logo_0": "{c5}  //    ",
    "logo_1": "{c5} //     ",
    "logo_2": "{c5}//   \\\\ ",
    "logo_3": "{c5}\\\\    \\\\",
    "logo_4": "{c5} \\\\   //",
    "logo_5": "{c5}     // ",
    "logo_6": "{c5}    //  "}.newStringTable,
  { "pm_name":    "dpkg",
    "pm_command": "dpkg-query -f '.\n' -W",
    "color": "{c1}",
    "logo_tiny": "",
    "logo_0": "{c1}   ,---._ ",
    "logo_1": "{c1} /`  __  \\",
    "logo_2": "{c1}|   /    |",
    "logo_3": "{c1}|   `.__.`",
    "logo_4": "{c1} \\        ",
    "logo_5": "{c1}  `-,_    "}.newStringTable,
  { "pm_name":    "dpkg",
    "pm_command": "dpkg-query -f '.\n' -W",
    "color": "{c4}",
    "logo_tiny": "",
    "logo_0": "{c4}-.,          ",
    "logo_1": "{c4}   `'-._     ",
    "logo_2": "{c4}        `::. ",
    "logo_3": "{c4}          \\::",
    "logo_4": "{c4}      __--`:`",
    "logo_5": "{c4} _,--` _.-`  ",
    "logo_6": "{c4}:_,--``      "}.newStringTable,
  { "pm_name":    "pacman",
    "pm_command": "pacman -Q",
    "color": "{c5}",
    "logo_tiny": "",
    "logo_0": "{c1}      /{c5}\\     ",
    "logo_1": "{c1}    /{c5}/  \\{c4}\\   ",
    "logo_2": "{c1}   /{c5}/    \\ {c4}\\ ",
    "logo_3": "{c1} / {c5}/     _) {c4})",
    "logo_4": "{c1}/_{c5}/___-- {c4}__- ",
    "logo_5": "{c4} /____--     "}.newStringTable,
  { "pm_name":    "rpm",
    "pm_command": "rpm -qa",
    "color": "{c4}",
    "logo_tiny": "",
    "logo_0": "{c7}      ____   ",
    "logo_1": "{c7}     /  __){c4}\\ ",
    "logo_2": "{c7}  ___| |_{c4}_) )",
    "logo_3": "{c7} / __|  _){c4}_/ ",
    "logo_4": "{c7}( (__| |     ",
    "logo_5": "{c7} \\_____/     "}.newStringTable,
  { "pm_name":    "emerge",
    "pm_command": "ls /var/db/pkg/*",
    "color": "{c5}",
    "logo_tiny": "",
    "logo_0": "{c5} .-----.   ",
    "logo_1": "{c5}(       \\  ",
    "logo_2": "{c5}\\   ()   \\ ",
    "logo_3": "{c5} \\        )",
    "logo_4": "{c5} /      _/ ",
    "logo_5": "{c5}(     _-   ",
    "logo_6": "{c5}\\____-     "}.newStringTable,
  { "pm_name":    "guix",
    "pm_command": "guix package --list-installed",
    "color": "{c3}",
    "logo_tiny": "",
    "logo_0": "{c3}\\____          ____/",
    "logo_1": "{c3} \\__ \\        / __/ ",
    "logo_2": "{c3}    \\ \\      / /    ",
    "logo_3": "{c3}     \\ \\    / /     ",
    "logo_4": "{c3}      \\ \\  / /      ",
    "logo_5": "{c3}       \\ \\/ /       ",
    "logo_6": "{c3}        \\__/        "}.newStringTable,
  { "pm_name":    "pacman",
    "pm_command": "pacman -Q",
    "color": "{c7}",
    "logo_tiny": "",
    "logo_0": "{c7}    /`__.`/ ",
    "logo_1": "{c7}    \\____/  ",
    "logo_2": "{c7}    .--.    ",
    "logo_3": "{c7}   /    \\   ",
    "logo_4": "{c7}  /  ___ \\  ",
    "logo_5": "{c7} / .`   `.\\ ",
    "logo_6": "{c7}/.`      `.\\"}.newStringTable,
  { "pm_name":    "dpkg",
    "pm_command": "dpkg-query -f '.\n' -W",
    "color": "{c2}",
    "logo_tiny": "󰣭",
    "logo_0": "{c2} ___________ ",
    "logo_1": "{c2}|_          \\",
    "logo_2": "{c2}  | {c7}| ,.,., {c2}|",
    "logo_3": "{c2}  | {c7}| | | | {c2}|",
    "logo_4": "{c2}  | {c7}| | | | {c2}|",
    "logo_5": "{c2}  | {c7}\\_____/ {c2}|",
    "logo_6": "{c2}  \\_________/"}.newStringTable,
  { "pm_name":    "rpm",
    "pm_command": "rpm -qa",
    "color": "{c6}",
    "logo_tiny": "",
    "logo_0": "{c6}   *    ",
    "logo_1": "{c6}    *   ",
    "logo_2": "{c6}   **   ",
    "logo_3": "{c7} /\\__/\\ ",
    "logo_4": "{c7}/      \\",
    "logo_5": "{c7}\\      /",
    "logo_6": "{c7} \\____/ "}.newStringTable,
  { "pm_name":    "pacman",
    "pm_command": "pacman -Q",
    "color": "{c2}",
    "logo_tiny": "",
    "logo_0": "{c2}||||||||| ||||",
    "logo_1": "{c2}||||||||| ||||",
    "logo_2": "{c2}|||| .... ||||",
    "logo_3": "{c2}|||| |||| ||||",
    "logo_4": "{c2}|||| |||| ||||",
    "logo_5": "{c2}|||| |||| ||||",
    "logo_6": "{c2}|||| |||| ||||"}.newStringTable,
  { "pm_name":    "dpkg",
    "pm_command": "dpkg-query -f '.\n' -W",
    "color": "{c7}",
    "logo_tiny": "",
    "logo_0": "{c7}    \\\\  / ",
    "logo_1": "{c7}     \\\\/  ",
    "logo_2": "{c7}      \\\\  ",
    "logo_3": "{c7}   /\\/ \\\\ ",
    "logo_4": "{c7}  /  \\  V\\",
    "logo_5": "{c7} /    \\/  \\",
    "logo_6": "{c7}/__________\\"}.newStringTable,
  { "pm_name":    "dpkg",
    "pm_command": "dpkg-query -f '.\n' -W",
    "color": "{c6}",
    "logo_tiny": "",
    "logo_0": "{c7}  .{c6}__{c7}.{c6}__{c7}.  ",
    "logo_1": "{c6} /  _{c7}.{c6}_  \\ ",
    "logo_2": "{c6}/  /   \\  \\",
    "logo_3": "{c7}. {c6}|  {c7}O{c6}  | {c7}.",
    "logo_4": "{c6}\\  \\_{c7}.{c6}_/  /",
    "logo_5": "{c6} \\{c7}.{c6}__{c7}.{c6}__{c7}.{c6}/ "}.newStringTable,
  { "pm_name":    "nix",
    "pm_command": "nix-store -q --requisites /run/current-system/sw && nix-store -q --requisites ~/.nix-profile",
    "color": "{c4}",
    "logo_tiny": "",
    "logo_0": "{c4}  \\\\  \\\\ //  ",
    "logo_1": "{c4}:::\\\\__\\\\/ //",
    "logo_2": "{c4}   //   \\\\// ",
    "logo_3": "{c4}:://     //::",
    "logo_4": "{c4} //\\\\___//   ",
    "logo_5": "{c4}// /\\\\  \\\\:::",
    "logo_6": "{c4}  // \\\\  \\\\  "}.newStringTable,
  { "pm_name":    "rpm",
    "pm_command": "rpm -qa",
    "color": "{c4}",
    "logo_tiny": "∞",
    "logo_0": "{c4}  _____   ______  ",
    "logo_1": "{c4} / ____\\ / ____ \\ ",
    "logo_2": "{c4}/ /    '/ /    \\ \\",
    "logo_3": "{c4}\\ \\____/ /,____/ /",
    "logo_4": "{c4} \\______/ \\_____/ "}.newStringTable,
  { "pm_name":    "rpm",
    "pm_command": "rpm -qa",
    "color": "{c2}",
    "logo_tiny": "",
    "logo_0": "{c2}  _______  ",
    "logo_1": "{c2}__|   __ \\ ",
    "logo_2": "{c2}     / .\\ \\",
    "logo_3": "{c2}     \\__/ |",
    "logo_4": "{c2}   _______|",
    "logo_5": "{c2}   \\_______",
    "logo_6": "{c2}__________/"}.newStringTable,
  # TODO: OpenWRT (normal logo)
  { "pm_name":    "pacman",
    "pm_command": "pacman -Q",
    "color": "{c5}",
    "logo_tiny": "",
    "logo_0": "{c5}  __ __ __  _  ",
    "logo_1": "{c5}.`_//_//_/ / `.",
    "logo_2": "{c5}          /  .`",
    "logo_3": "{c5}         / .`  ",
    "logo_4": "{c5}        /.`    ",
    "logo_5": "{c5}       /`      "}.newStringTable,
  { "pm_name":    "dpkg",
    "pm_command": "dpkg-query -f '.\n' -W",
    "color": "{c6}",
    "logo_tiny": "",
    "logo_0": "{c7} 76767      ",
    "logo_1": "{c7}76  76   767",
    "logo_2": "{c7} 7676'   76 ",
    "logo_3": "{c7}  76     7  ",
    "logo_4": "{c7}   76   76  ",
    "logo_5": "{c7} __________ ",
    "logo_6": "{c7} 7676767676 "}.newStringTable,
  { "pm_name":    "dpkg",
    "pm_command": "dpkg-query -f '.\n' -W",
    "color": "{c7}",
    "logo_tiny": "□",
    "logo_0": "{c7} _____________ ",
    "logo_1": "{c7}|  _________  |",
    "logo_2": "{c7}| |         | |",
    "logo_3": "{c7}| |         | |",
    "logo_4": "{c7}| |_________| |",
    "logo_5": "{c7}|_____________|"}.newStringTable,
  { "pm_name":    "dpkg",
    "pm_command": "dpkg-query -f '.\n' -W",
    "color": "{c1}",
    "logo_tiny": "",
    "logo_0": "{c2}  __  __  ",
    "logo_1": "{c2} (_\\)(/_) ",
    "logo_2": "{c1} (_(__)_) ",
    "logo_3": "{c1}(_(_)(_)_)",
    "logo_4": "{c1} (_(__)_) ",
    "logo_5": "{c1}   (__)   "}.newStringTable,
  { "pm_name":    "pkgtool",
    "pm_command": "ls /var/log/packages",
    "color": "{c4}",
    "logo_tiny": "",
    "logo_0": "{c4}   ________  ",
    "logo_1": "{c4}  /  ______| ",
    "logo_2": "{c4}  | |______  ",
    "logo_3": "{c4}  \\______  \\ ",
    "logo_4": "{c4}   ______| | ",
    "logo_5": "{c4}| |________/ ",
    "logo_6": "{c4}|____________"}.newStringTable,
  { "pm_name":    "eopkg",
    "pm_command": "ls /var/lib/eopkg/package",
    "color": "{c4}",
    "logo_tiny": "",
    "logo_0": "{c7}      _     ",
    "logo_1": "{c7}     /|     ",
    "logo_2": "{c7}    / |\\    ",
    "logo_3": "{c7}   /  | \\ _ ",
    "logo_4": "{c7}  /{c4}___{c7}|{c4}__{c7}\\{c4}_{c7}\\",
    "logo_5": "{c4} \\         /",
    "logo_6": "{c4}  `-------' "}.newStringTable,
  { "pm_name":    "dpkg",
    "pm_command": "dpkg-query -f '.\n' -W",
    "color": "{c1}",
    "logo_tiny": "",
    "logo_0": "{c1}         _ ",
    "logo_1": "{c1}     ---(_)",
    "logo_2": "{c1} _/  ---  \\",
    "logo_3": "{c1}(_) |   |  ",
    "logo_4": "{c1}  \\  --- _/",
    "logo_5": "{c1}     ---(_)"}.newStringTable,
  # TODO: Vanilla OS (learn how to list pkgs with apx)
  { "pm_name":    "xbps",
    "pm_command": "xbps-query -l",
    "color": "{c2}",
    "logo_tiny": "",
    "logo_0": "{c2}    _______  ",
    "logo_1": "{c2} _ \\______ - ",
    "logo_2": "{c2}| \\  ___  \\ |",
    "logo_3": "{c2}| | /   \\ | |",
    "logo_4": "{c2}| | \\___/ | |",
    "logo_5": "{c2}| \\______ \\_|",
    "logo_6": "{c2} -_______\\   "}.newStringTable,
  ]


# some logos are taken from or derived from dylanaraps/pfetch, Gobidev/pfetch-rs or ufetch under the MIT License:

# Copyright (c) 2016-2019 Dylan Araps : pfetch
# Copyright (c) 2023 Adrian Groh      : pfetch-rs
# Copyright (c) 2015 J Schillinger    : ufetch
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
