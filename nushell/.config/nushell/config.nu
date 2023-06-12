source ~/.cache/starship/init.nu
source ~/.cache/rtx/init.nu

def dlp [link, index] {
    let command = $"yt-dlp --cookies-from-browser firefox ($link) -o \"($index). %\(title\)s.%\(ext\)s\""
    nu -c $command
}
