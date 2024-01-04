### docker images

---
### images

- [protoc](protoc.md) - image for protobuf compiler and golang plugins
- [sqlboiler](sqlboiler.md) - image for sqlboiler and all known drivers
- [oapi](oapi.md) - image for golang openapi code generator
- [swagger](swagger.md) - image for swagger code generator

---
### usages

- `make build target=<target> version=<version>` - build an image
  - `target` - target in [Dockerfile](Dockerfile) and image sub-tag
  - `version` - version of the image
  - these are used by github actions to build+push images, but can be used locally
- `make local target=<target> version=<version>` - a wrapper for `build` 
  - used for debugging github actions locally
  - i've been messing with it so it probably doesn't work
