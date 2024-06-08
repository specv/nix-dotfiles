function portgrep() {
    {
        echo "Port,Process ID,Process Name"
        for port in "$@"; do
            pids=$(lsof -i:$port -t)
            for pid in ${(z)=pids}; do
                name=$(ps -p $pid -o comm=)
                echo "$port,$pid,$name"
            done
        done
    } | column -t -s ','
}

function portkill() {
    {
        echo "Port,Process ID,Process Name"
        for port in "$@"; do
            pids=$(lsof -i:$port -t)
            for pid in ${(z)=pids}; do
                name=$(ps -p $pid -o comm=)
                echo "$port,$pid,$name"
                kill -15 "$pid"
            done
        done
    } | column -t -s ','
}
