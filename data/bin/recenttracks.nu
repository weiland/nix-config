def openTracks [] {
    let location = $env | get --optional RECENTTRACKS | default $"($nu.home-path)/.local/share/recenttracks.csv"
    if ($location | path exists) {
        open --raw $location | from csv --no-infer | select utc_time artist track album
    } else {
        print $"The file '($location)' does not exist."
    }
}

def filterTable [col, query: string, exact: bool] {
    if $exact {
        $col like $query
    } else {
        $col =~ $"\(?i\)($query)"
    }
}

def "main artist" [query: string, --ignore-case (-i)] {
    let $cond = { |table| filterTable $table.artist $query (not $ignore_case) }
    openTracks | where $cond
}

def "main track" [query: string, --exact (-e)] {
    # let $cond = if $exact {{ |x| $x.track like $query }} else {{ |x| $x.track =~ $"\(?i\)($query)" }}
    let $cond = { |table| filterTable $table.track $query $exact }
    openTracks | where $cond
}

def main [query: string] {
    openTracks | enumerate | flatten | find --ignore-case $query
}
