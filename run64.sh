#!/bin/bash
./bin/shellcoderun64 \
  $(echo -n -e \
    $(make raw |\
      grep -v printf |\
      grep -w "$1" |\
      awk '{print $2}' -))
