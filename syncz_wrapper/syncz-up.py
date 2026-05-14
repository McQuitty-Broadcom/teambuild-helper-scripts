#!/usr/bin/env python3
"""Run syncz from the nearest ancestor directory containing syncz.yml."""

from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path


def find_config_dir(start: Path, config_name: str) -> Path | None:
    current = start.resolve()

    while True:
        if (current / config_name).is_file():
            return current

        parent = current.parent
        if parent == current:
            return None

        current = parent


def main(argv: list[str]) -> int:
    config_name = os.environ.get("SYNCZ_CONFIG_NAME", "syncz.yml")
    config_dir = find_config_dir(Path.cwd(), config_name)

    if config_dir is None:
        print(
            f"syncz wrapper: {config_name} not found in current directory or any parent directory",
            file=sys.stderr,
        )
        return 1

    try:
        completed = subprocess.run(["syncz", *argv], cwd=config_dir, check=False)
    except FileNotFoundError:
        print("syncz wrapper: syncz executable not found on PATH", file=sys.stderr)
        return 127

    return completed.returncode


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
