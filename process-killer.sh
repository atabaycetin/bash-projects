#!/bin/bash

if false; then

- Write a BASH script that analyzes the output of such a command and sends a termination signal to all 
- the non-root processes that have a memory usage -%MEM- larger than 25%. Assume that the columns are
- separated from each other by a single space.

fi

command=$(ps -aux)

for line in $command; do
    if [ "${command:1:}" != "root" && "${command:4:}" > 0.25 ]; then
        kill("${command:2:}", SIGKILL);
    fi
done