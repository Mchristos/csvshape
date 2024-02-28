calculate_csv_shape() {
    [ -e "$1" ] || return
    echo -n "$1: "
    awk -F',' 'NR==1 {cols=NF} END {printf("(%d,%d)\n", NR-1, cols)}' "$1"
}

csvshape() {
    if [ "$#" -eq 0 ]; then
        set -- "."
    fi

    for arg in "$@"; do
        if [ -d "$arg" ]; then
            for file in "$arg"/*.csv; do
                calculate_csv_shape "$file"
            done
        elif [ -f "$arg" ]; then
            calculate_csv_shape "$arg"
        else
            for file in $arg; do
                calculate_csv_shape "$file"
            done
        fi
    done
}

