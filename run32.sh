#!/bin/bash
./bin/shellcoderun \
  $(echo -n -e \
    $(make raw |\
      grep -v printf |\
      grep -w "$1" |\
      awk '{print $2}' -))
