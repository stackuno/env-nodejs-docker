#!/bin/bash

# Install project-specific system dependencies
apt-get install -y --no-install-recommends \
  && return 0

# The return statement has been added to keep the diffs "clean" as additions
# can be made in a manner that flag the lines with the newly added, removed or
# modified packages without forcing the user to consider punctuation for line
# continuation for example.
# https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_02_01
