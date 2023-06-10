#! /bin/bash

if nvidia-smi 1>/dev/null 2>&1;
then
    echo "[INFO] Skipping nvidia driver -> already installed."
fi