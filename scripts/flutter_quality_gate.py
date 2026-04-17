#!/usr/bin/env python3
"""Learnova Flutter quality gate.

Runs deterministic local checks and exits on the first failure.
"""

from __future__ import annotations

import argparse
import subprocess
import sys
import shutil
from pathlib import Path


def run_step(name: str, cmd: list[str], cwd: Path) -> int:
    print(f"\n==> {name}")
    print("$", " ".join(cmd))
    executable = cmd[0].lower()
    if executable.endswith(".bat") or executable.endswith(".cmd"):
        cmd = ["cmd", "/c", *cmd]
    result = subprocess.run(cmd, cwd=str(cwd))
    return result.returncode


def main() -> int:
    parser = argparse.ArgumentParser(description="Run Flutter quality checks.")
    parser.add_argument("--project", default=".", help="Project root path.")
    parser.add_argument("--skip-format-check", action="store_true")
    parser.add_argument("--skip-analyze", action="store_true")
    parser.add_argument("--skip-tests", action="store_true")
    parser.add_argument("--skip-web-build", action="store_true")
    args = parser.parse_args()

    project = Path(args.project).resolve()
    if not (project / "pubspec.yaml").exists():
        print(f"Project not found at: {project}")
        return 2

    flutter_bin = shutil.which("flutter.bat") or shutil.which("flutter")
    dart_bin = (
        shutil.which("dart.bat")
        or shutil.which("dart.exe")
        or shutil.which("dart")
    )
    if not flutter_bin or not dart_bin:
        print("Unable to find flutter/dart in PATH.")
        return 2

    steps: list[tuple[str, list[str]]] = [
        ("Flutter pub get", [flutter_bin, "pub", "get"]),
    ]

    if not args.skip_format_check:
        steps.append(
            (
                "Format check",
                [
                    dart_bin,
                    "format",
                    "--output=none",
                    "--set-exit-if-changed",
                    "lib",
                    "test",
                    "scripts",
                ],
            )
        )
    if not args.skip_analyze:
        steps.append(("Static analysis", [flutter_bin, "analyze"]))
    if not args.skip_tests:
        steps.append(
            ("Unit/widget tests", [flutter_bin, "test", "-r", "compact"])
        )
    if not args.skip_web_build:
        steps.append(
            ("Web release build", [flutter_bin, "build", "web", "--release"])
        )

    for step_name, command in steps:
        code = run_step(step_name, command, project)
        if code != 0:
            print(f"\nQuality gate failed at: {step_name}")
            return code

    print("\nQuality gate passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
