# SHELL := /bin/bash

# .PHONY: all build test deps deps-cleancache

# GOCMD=go
# LINT=golangci-lint
# BUILD_DIR=build
# BINARY_DIR=$(BUILD_DIR)/bin
# CODE_COVERAGE=code-coverage


# all: test build

# ${BINARY_DIR}:
# 	mkdir -p $(BINARY_DIR)

# build: ${BINARY_DIR} ## Compile the code, build Executable File
# 	$(GOCMD) build -o $(BINARY_DIR) -v ./cmd/main

# run: ## Start application
# 	$(GOCMD) fmt ./...
# 	$(GOCMD) vet ./...
# 	$(LINT) run ./...
# 	$(GOCMD) run ./...


# test: ## Run tests
# 	$(GOCMD) test ./... -cover

# #  mockgen: ## Generate mock repository and usecase functions 
# # mockgen -source=pkg/repository/interface/user.go -destination=pkg/mock/repoMock/user_repo.go -package=mockD

# test-coverage: ## Run tests and generate coverage file
# 	$(GOCMD) test ./... -coverprofile=$(CODE_COVERAGE).out
# 	$(GOCMD) tool cover -html=$(CODE_COVERAGE).out

# deps: ## Install dependencies
# 	# go get $(go list -f '{{if not (or .Main .Indirect)}}{{.Path}}{{end}}' -m all)
# 	$(GOCMD) get -u -t -d -v ./...
# 	$(GOCMD) mod tidy
# 	$(GOCMD) mod vendor

# deps-cleancache: ## Clear cache in Go module
# 	$(GOCMD) clean -modcache

wire: ## Generate wire_gen.go
	cd internal/di && wire

swag: ## Generate swagger docs
	swag init -g internal/api/server.go -o ./api/docs

fmt: ##Format swagger annotations
	swag fmt internal/api
proto: #generates proto code
	protoc internal/proto/*.proto --go_out=. --go-grpc_out=.

# help: ## Display this help screen
# 	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# cert:
#     cd cert; ./gen.sh; cd ..