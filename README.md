Provided as-is with no promises.

### Requirements

- LUA Executable.
- CSV file with formatted groups.

### Usage

format of groups should be as-follows in a CSV format:
```csv
group_1_player_1,group_1_player_2,...group_1_player_5,
group_2_player_1,group_2_player_2,...group_2_player_5,
...
```

Any extraneous columns (beyond 5), and rows (beyond 8) will be stripped.

```bash
> ./ertgroups -D "$(cat ./path/to/groups.csv)"
```

The output will be code to paste into the import section of the ERT tool.
