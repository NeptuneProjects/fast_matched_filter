#!/usr/bin/env python
"""Custom `build_ext` module for building C extensions for FastMatchedFilter."""

from pathlib import Path
from setuptools import Extension
from setuptools.command.build_ext import build_ext as _build_ext
import subprocess


class FMFExtension(Extension):
    def __init__(self, name: str, sources: list = []) -> None:
        Extension.__init__(self, name=name, sources=sources)


class FastMatchedFilterBuild(_build_ext):
    def run(self) -> None:
        # print("*" * 40)
        # print(Path.cwd())
        # print(Path(__file__))
        # lib_dir = Path("fast_matched_filter/lib")
        # lib_dir.mkdir(parents=True, exist_ok=True)

        python_build_lib = self.build_lib

        commands = ["python_cpu", "python_gpu"]
        for command in commands:
            ret = subprocess.call(["make", command, f"PYTHON_BUILD_LIB={python_build_lib}"])
            if ret != 0:
                raise OSError(f"Unable to compile {command} code.")
