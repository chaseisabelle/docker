.PHONY: target
target:
	@echo "${input}" | echo release/protoc-0.0.0 | grep -oP "(?<=release\/)([a-zA-Z0-9]+)-[0-9]+(\.[0-9]+)?(\.[0-9]+)?" | grep -oP "[a-zA-Z0-9]+" | head -n 1

.PHONY: version
version:
	@echo "${input}" | grep -oP "(?<=release\/)([a-zA-Z0-9]+)-[0-9]+(\.[0-9]+)?(\.[0-9]+)?" | grep -oP "[0-9]+(\.[0-9]+)?(\.[0-9]+)?" | tail -n 1

.PHONY: build
build:
	docker buildx build --target "${target}" -t "chaseisabelle/${target}:${version}" --platform=linux/amd64,linux/arm64 --push .

.PHONY: push
push:
	docker push "chaseisabelle/${target}:${version}"
