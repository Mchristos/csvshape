calculate_csv_shape() {
    [ -e "$1" ] || return
    echo -n "$1: "
    awk -F',' 'NR==1 {cols=NF} END {printf("(%d,%d)\n", NR-1, cols)}' "$1"
}

csvshape() {
    local recursive=0

    if [ "$1" = "-r" ]; then
        recursive=1
        shift
    fi

    if [ "$#" -eq 0 ]; then
        set -- "."
    fi

    for arg in "$@"; do
        if [ -d "$arg" ]; then
            if [ "$recursive" -eq 1 ]; then
                find "$arg" -name '*.csv' -type f | while read -r file; do
                    calculate_csv_shape "$file"
                done
            else
                for file in "$arg"/*.csv; do
                    calculate_csv_shape "$file"
                done
            fi
        elif [ -f "$arg" ]; then
            calculate_csv_shape "$arg"
        else
            for file in $arg; do
                calculate_csv_shape "$file"
            done
        fi
    done
}
