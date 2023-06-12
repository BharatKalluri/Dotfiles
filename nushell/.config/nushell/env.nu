let-env config = {show_banner: false}

let-env NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
]
let-env NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]


# add all bin folders to path
let BIN_PATH_LIST = ([
    "~/.local/bin",
] | path expand)
let-env PATH = ($env.PATH | split row (char esep) | prepend $BIN_PATH_LIST)


# activate starship & rtx
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
mkdir ~/.cache/rtx
rtx activate nu | save -f ~/.cache/rtx/init.nu
