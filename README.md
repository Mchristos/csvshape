# csvshape
A simple CLI to show csv shapes (rows, cols).

`csvshape` is a command-line utility that helps you quickly find the dimensions (number of rows and columns) of CSV files in a directory or matching a pattern. It's useful for getting an overview of a directory with many csv files, and you don't want to load them up individually in pandas or some other tool. 

## Installation

### Direct Installation

To install `csvshape`, simply add the following function to your `~/.bashrc` or `~/.zshrc` file:

```bash
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
```

After adding the function, save the file and reload your shell configuration with `source ~/.bashrc` or `source ~/.zshrc`.

## Usage 

`csvshape` can be used in various ways to suit your needs.

### Print the Shape of All CSVs in the Current Directory

```bash
csvshape
```

This command will output the shape of all CSV files in the current directory, as follows:

```
./a-file1.csv: (1341,195)
./a-file2.csv: (440,195)
./b-file3.csv: (6438,195)
./b-file4.csv: (2100,195)
```

### Using a Wildcard

You can also use wildcards to specify which files to analyze:

```bash
csvshape a-*
```

Example output:

```
./a-file1.csv: (1341,195)
./a-file2.csv: (440,195)
```

### Specifying a Directory

To analyze CSV files in a specific directory, just pass the directory path:

```bash
csvshape path/to/directory
```

## Contributing

Contributions to `csvshape` are welcome! Feel free to fork the repository and submit pull requests.

---

This README provides a comprehensive guide for both installation and usage of your `csvshape` tool, making it accessible for users regardless of their familiarity with command-line tools.