#!/bin/bash
sensors | grep 'Tctl' | awk '{print $2}' | sed 's/+//'
