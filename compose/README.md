# How to run

```
just compose-image kinoite
podman load -i kinoite.ociarchive
podman tag <SHA256> docker.io/typicalam/kinoite:43
podman push docker.io/typicalam/kinoite:43
```

Time to build is `0.16s user 0.19s system 0% cpu 12:54.96 total` on my machine.

Most of this was taken from https://pagure.io/workstation-ostree-config
