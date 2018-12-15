#!/usr/bin/env bash

find /tmp > "$(uname -n)_tmpdir_${RANDOM}.txt"
