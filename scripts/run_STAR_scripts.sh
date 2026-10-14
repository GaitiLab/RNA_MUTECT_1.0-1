#!/bin/bash

filesOfInterest=$2

while read -r line || [ -n "$line" ]; do sbatch $line; done < "${filesOfInterest}"

