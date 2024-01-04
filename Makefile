.PHONY: target
target:
	echo "${input}" | docker run --rm ubuntu grep -oP "(?<=release\/)[a-zA-Z0-9-]+"

.PHONY: version
version:
	echo "${input}" | docker run --rm ubuntu grep -oP "(?<=release\/$target-)[0-9]+\.[0-9]+(\.[0-9]+)?"

.PHONY: build
build:
	docker build --target "${target}" -t "chaseisabelle/${target}:${version}" .

.PHONY: push
push:
	docker push "chaseisabelle/${target}:${version}"

.PHONY: build-protoc
build-protoc:
	make build target=protoc version="${version}"

.PHONY: build-sqlboiler
build-sqlboiler:
	make build target=sqlboiler version="${version}"

.PHONY: build-oapi
build-oapi:
	make build target=oapi version="${version}"

.PHONY: build-swagger
build-swagger:
	make build target=swagger version="${version}"