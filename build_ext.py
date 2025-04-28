#!/usr/bin/env python
"""Custom `build_ext` module for building C extensions for FastMatchedFilter."""

from setuptools import Extension
from setuptools.command.build_ext import build_ext
import subprocess


class FMFExtension(Extension):
    def __init__(self, name: str, sources: list = []) -> None:
        Extension.__init__(self, name=name, sources=sources)


class FastMatchedFilterBuild(build_ext):
    def run(self) -> None:
        commands = ["python_cpu", "python_gpu"]
        for command in commands:
            ret = subprocess.call(["make", command])
            if ret != 0:
                raise OSError(f"Unable to compile {command} code.")
