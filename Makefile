.PHONY: target
target:
	@echo "${input}" | echo release/protoc-0.0.0 | grep -oP "(?<=release\/)([a-zA-Z0-9]+)-[0-9]+(\.[0-9]+)?(\.[0-9]+)?" | grep -oP "[a-zA-Z0-9]+" | head -n 1

.PHONY: version
version:
	@echo "${input}" | grep -oP "(?<=release\/)([a-zA-Z0-9]+)-[0-9]+(\.[0-9]+)?(\.[0-9]+)?" | grep -oP "[0-9]+(\.[0-9]+)?(\.[0-9]+)?" | tail -n 1

.PHONY: build
build:
	docker build --target "${target}" -t "chaseisabelle/${target}:${version}" .

.PHONY: push
push:
	docker push "chaseisabelle/${target}:${version}"

#.PHONY: build-protoc
#build-protoc:
#	make build target=protoc version="${version}"
#
#.PHONY: build-sqlboiler
#build-sqlboiler:
#	make build target=sqlboiler version="${version}"
#
#.PHONY: build-oapi
#build-oapi:
#	make build target=oapi version="${version}"
#
#.PHONY: build-swagger
#build-swagger:
#	make build target=swagger version="${version}"