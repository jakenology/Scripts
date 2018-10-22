#!/bin/bash
if [ -f "/tmp/done" ]; then
  exit 0;
else
  osascript -e 'set volume 100'
  say "Test"
  touch /tmp/done
fi
