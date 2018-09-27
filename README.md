# Stratix 10 HyperFlex

## Project Organization

```
<PROJECT_ROOT>
    |
    |- apps
    |   |
    |   `- myapp
    |       |
    |       |- baseline
    |       |     |- rtl
    |       |     |- sdc
    |       |     |- inc (optional)
    |       |     `- ...
    |       |- step1
    |       |     |- rtl
    |       |     |- sdc
    |       |     |- inc (optional)
    |       |     `- ...
    |       `- ...
    |- scripts
    `- common
```

## Getting Start

1. Create a benchmark list file, see the example under scripts
2. Run `python scripts/compile_benchmarks.py <benchmark list file>` to compile all benchmarks in benchmark list file
3. Use `--no-sim` for experimental changes. Use `--no-dse` for faster compilation.
4. Try `python scripts/compile_benchmarks.py -h` for full help message.
