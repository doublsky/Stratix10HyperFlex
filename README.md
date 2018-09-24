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

1. Add project root as "HFHOME" to environment variables (required for simulation)
2. Create a benchmark list file, see the example under scripts
3. Run `python scripts/compile_benchmarks.py <benchmark list file>` to compile all benchmarks in benchmark list file
4. Use `--no-sim` for experimental changes. Use `--no-dse` for faster compilation.
5. Try `python scripts/compile_benchmarks.py -h` for full help message.
