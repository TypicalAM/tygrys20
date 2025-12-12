# Tyrgrys20

My bootc system based on fedora bootc.

```sh
sudo podman login --authfile=/etc/ostree/auth.json docker.piaseczny.dev
sudo rpm-ostree rebase ostree-unverified-registry:docker.piaseczny.dev/machine/tygrys20:latest
```

# TODO

- [-] Secure boot (???)
- [-] uki
- [ ] Automatic after snapper
- [x] h264 - vlc & firefox
- [x] Testing on sencond machine
- [x] U2F with polkit
- [x] Looking glass client
- [x] Enable na supergfxctl
- [x] Refind update
- [x] Nvidia specialization image with VFIO configs ready
