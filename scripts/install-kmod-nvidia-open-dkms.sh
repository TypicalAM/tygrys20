#!/usr/bin/bash
set -euxo pipefail

K_VRA=$(rpm -q --qf "%{VERSION}-%{RELEASE}.%{ARCH}\n" kernel-core)
dnf install -y dkms
dkms install -m nvidia -v 580.105.08 -k ${K_VRA} --force --verbose
dnf remove -y dkms
dnf clean all
rm -rf /var/lib/dkms /usr/src/nvidia-* /var/lib/dnf /var/cache/* /var/log/dnf5.log
