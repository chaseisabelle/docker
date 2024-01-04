.PHONY: parse-release-tag
parse-release-tag:
	@echo "${input}" | grep -oP "(?<=release\/)([a-zA-Z0-9]+)-[0-9]+(\.[0-9]+)?(\.[0-9]+)?"

.PHONY: parse-release-target
parse-release-target:
	@make parse-release-tag | grep -oP "[a-zA-Z0-9]+" | head -n 1

.PHONY: parse-release-version
parse-release-version:
	@make parse-release-tag | grep -oP "[0-9]+(\.[0-9]+)?(\.[0-9]+)?" | tail -n 1

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
build-for-local:
	make build-with-options \
		target="${target}" \
		version="${version}" \
		options="--output type=tar,dest=tmp/${target}-${version}.tar"
	docker load --input "tmp/${target}-${version}.tar"

.PHONY: latest-protoc-version
latest-protoc-version:
	docker run --rm chaseisabelle/protoc:latest --version | ggrep -oP "[0-9]+(\.[0-9]+)?(\.[0-9]+)?"