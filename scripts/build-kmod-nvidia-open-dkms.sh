#!/usr/bin/bash
set -euxo pipefail

ARCH=$(uname -m)
K_VRA=$(rpm -q --qf "%{VERSION}-%{RELEASE}.%{ARCH}\n" kernel-core)

source /etc/os-release

curl https://developer.download.nvidia.com/compute/cuda/repos/fedora42/x86_64/cuda-fedora42.repo \
    -o /etc/yum.repos.d/nvidia.repo

dnf install -y --no-docs --best kmod-nvidia-open-dkms

# Rerunning DKMS is necessary because the RPM's post-install scriptlet targets the
# host kernel c.f `rpm -q --scripts kmod-nvidia-open-dkms`.
# We explicitly use the `-k` option to build the NVIDIA modules against the
# kernel version shipped within this image.
# Also, we do the installation on the final image as the dkms install runs the depmod and
# dracut utilities.
dkms build -m nvidia -v 580.105.08 -k $K_VRA --verbose
