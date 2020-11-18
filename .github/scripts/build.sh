#!/usr/bin/env bash
set -e
fail() { echo -e "::error::${1}"; exit 1; }

nbdev_read_nbs
nbdev_clean_nbs
status=$(git status -uno -s)
[[ -n "${status}" ]] && fail "Detected unstripped out notebooks.\nRemember to run nbdev_install_git_hooks.\n\n${status}"
diffs=$(nbdev_diff_nbs)
[[ -n "${diffs}" ]] && fail "Detected difference between the notebooks and the library.\n\n${diffs}"
nbdev_test_nbs

