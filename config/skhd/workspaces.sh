#!/bin/bash

WORKSPACE=$1
APP=$2

hyprspace workspace $WORKSPACE
if ! hyprspace list-windows --workspace "$WORKSPACE" | grep -qi "$APP"; then
  open -a "$APP"
fi
