#!/usr/bin/env sh

if command -v emacs >/dev/null; then
  if systemctl is-active --quiet emacs.service; then
    systemctl --user restart emacs.service
    emacsclient -c
  else
    systemctl --user start emacs.service
    emacsclient -c
  fi
else
  exit 1
fi
