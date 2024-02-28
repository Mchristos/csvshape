# csvshape
A simple CLI to show csv shapes (rows, cols).

`csvshape` is a command-line utility that helps you quickly find the dimensions (number of rows and columns) of CSV files in a directory or matching a pattern. It's useful for getting an overview of a directory with many csv files, and you don't want to load them up individually in pandas or some other tool. 

## Installation

### Direct Installation

To install `csvshape`, add the following function to your `~/.bashrc` or `~/.zshrc` file:

```bash
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
```

After adding the function, save the file and reload your shell configuration with `source ~/.bashrc` or `source ~/.zshrc`.

## Usage 

### Print the Shape of All CSVs in the Current Directory

```bash
csvshape
```

Output example:

```
./a-file1.csv: (1341,195)
./a-file2.csv: (440,195)
./b-file3.csv: (6438,195)
./b-file4.csv: (2100,195)
```

### Using a Wildcard

Specify file patterns using wildcards:

```bash
csvshape a-*
```

Output example:

```
./a-file1.csv: (1341,195)
./a-file2.csv: (440,195)
```

### Recursive Search in a Directory

Use the `-r` flag for a recursive search in a directory:

```bash
csvshape -r path/to/directory
```

This will search for CSV files in the specified directory and all its subdirectories.

Output example:

```
path/to/directory/file1.csv: (1341,195)
path/to/directory/subdirectory/file2.csv: (440,195)
```

## Contributing

Contributions to `csvshape` are welcome! Feel free to fork the repository and submit pull requests.
