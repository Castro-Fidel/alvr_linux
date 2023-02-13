#!/usr/bin/env bash

ALVR_VERSION="v20.0.0-dev07+nightly.2023.02.12_ROSA"

echo "Used:
 * STEAM (beta)
 * SteamVR (beta)
"

cd "$(dirname "`readlink -f "$0"`")"
export ALVR_SCRIPTS_PATH="$(pwd)"

if [[ ! -d "${ALVR_SCRIPTS_PATH}/ALVR ${ALVR_VERSION}" ]] ; then
#     wget https://github.com/Castro-Fidel/alvr_linux/releases/download/ALVR_v20.0.0-dev07%2Bnightly.2023.02.12/ALVR_v20.0.0-dev07+nightly.2023.02.12_ROSA.tar.xz
#     wget https://github.com/Castro-Fidel/alvr_linux/releases/download/ALVR_v20.0.0-dev07%2Bnightly.2023.02.12/alvr_client_android.v20.0.0-dev07+nightly.2023.02.12.apk
# fi

echo 'Check "getcap"'
if [[ ! $(which getcap 2>/dev/null) ]] && [[ ! $(echo $PATH | grep '/usr/sbin') ]]; then
    export PATH+=':/usr/sbin'
fi
if [[ ! $(which getcap) ]] ; then
    echo "ERROR: getcap not found."
    exit 1
fi
echo "OK.
"
if [[ ! $(which steam) ]] ; then
    echo "ERROR: steam not found."
    exit 1
fi

echo "Try kill steam and steamVR...
"
killall -9 steam alvr_launcher vrmonitor vrcompositor vrcompositor.re vrwebhelper steamtours vrdashboard &>/dev/null
sleep 3

# Rainbow pixels at the edge of my viewport (AMDGPU)
# SteamVR only renders what can actually be seen by the player. This results in two ovals being drawn on the HMD. SteamVR does not touch the outside of those ovals. That results in random pixels from the VRAM segment the frame buffer was allocated on. You can probably see these if you move your eyes quick enough and are looking at a dark scene in VR.
# You can tell the RADV driver to always zero the frame buffer to avoid this. I am not sure if this results in a performance penalty or not.
# Fix:
# export RADV_DEBUG=zerovram,nodcc
# export RADV_PERFTEST=sam,nggc,cswave32

# SteamVR doesn't start on Wayland
# If you have environment variables that force Qt or SDL apps to run in Wayland mode, SteamVR might not start at all.
# Fix:
# export QT_QPA_PLATFORM=xcb
# export SDL_VIDEODRIVER=x11

echo "Running alvr_launcher"
"${ALVR_SCRIPTS_PATH}/ALVR ${ALVR_VERSION}/bin/alvr_launcher"
