.PHONY: parse-release-target
parse-release-target:
	@echo "${tag}" | grep -oP "(?<=release\/)([a-zA-Z0-9]+)-[0-9]+(\.[0-9]+)?(\.[0-9]+)?" | \
		grep -oP "[a-zA-Z0-9]+" | head -n 1

.PHONY: parse-release-version
parse-release-version:
	@echo "${tag}" | grep -oP "(?<=release\/)([a-zA-Z0-9]+)-[0-9]+(\.[0-9]+)?(\.[0-9]+)?" | \
		grep -oP "[0-9]+(\.[0-9]+)?(\.[0-9]+)?" | tail -n 1

.PHONY: build-and-push
build-and-push:
	make build-with-options \
		target="${target}" \
		version="${version}" \
		options="--push --platform=linux/amd64,linux/arm64"

.PHONY: build-with-options
build-with-options:
	docker buildx build \
		--tag "chaseisabelle/${target}:${version}" \
		--target "${target}" \
		${options} \
		.

.PHONY: build-for-local
build-for-local: # @todo fix this nonsense
	make build-with-options \
		target="${target}" \
		version="${version}" \
		options="--output type=tar,dest=tmp/${target}-${version}.tar"
	docker load --input "tmp/${target}-${version}.tar"

.PHONY: tag-and-push-release
tag-and-push-release:
	git tag "release/${target}-${version}"
	git push --tags

.PHONY: compare-protoc-versions
compare-protoc-versions:
	make build-with-options target=protoc version=local
	$(eval local_protoc_version := $(shell docker run --rm --entrypoint=protoc chaseisabelle/protoc:local --version | grep -oP "[0-9]+(\.[0-9]+)?(\.[0-9]+)?"))
	$(eval latest_protoc_version := $(shell docker run --rm --entrypoint=protoc chaseisabelle/protoc:latest --version | grep -oP "[0-9]+(\.[0-9]+)?(\.[0-9]+)?"))
	$(eval local_gengo_version := $(shell docker run --rm --entrypoint=protoc-gen-go chaseisabelle/protoc:local --version | grep -oP "[0-9]+(\.[0-9]+)?(\.[0-9]+)?"))
	$(eval latest_gengo_version := $(shell docker run --rm --entrypoint=protoc-gen-go chaseisabelle/protoc:latest --version | grep -oP "[0-9]+(\.[0-9]+)?(\.[0-9]+)?"))
	$(eval local_gengogrpc_version := $(shell docker run --rm --entrypoint=protoc-gen-go-grpc chaseisabelle/protoc:local --version | grep -oP "[0-9]+(\.[0-9]+)?(\.[0-9]+)?"))
	$(eval latest_gengogrpc_version := $(shell docker run --rm --entrypoint=protoc-gen-go-grpc chaseisabelle/protoc:latest --version | grep -oP "[0-9]+(\.[0-9]+)?(\.[0-9]+)?"))
	@echo local protoc version: $(local_protoc_version)
	@echo latest protoc version: $(latest_protoc_version)
	@echo local gen-go version: $(local_gengo_version)
	@echo latest gen-go version: $(latest_gengo_version)
	@echo local gen-go-grpc version: $(local_gengogrpc_version)
	@echo latest gen-go-grpc version: $(latest_gengogrpc_version)
