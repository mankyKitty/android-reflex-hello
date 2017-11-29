#!/usr/bin/env bash
ghcid --command="ghci -ghci-script=frontend.ghci" -W --test="main" --reload=./css
