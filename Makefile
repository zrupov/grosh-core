# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: geth android ios grosh-cross evm all test clean
.PHONY: grosh-linux grosh-linux-386 grosh-linux-amd64 grosh-linux-mips64 grosh-linux-mips64le
.PHONY: grosh-linux-arm grosh-linux-arm-5 grosh-linux-arm-6 grosh-linux-arm-7 grosh-linux-arm64
.PHONY: grosh-darwin grosh-darwin-386 grosh-darwin-amd64
.PHONY: grosh-windows grosh-windows-386 grosh-windows-amd64

GOBIN = ./build/bin
GO ?= latest

grosh:
	build/env.sh go run build/ci.go install ./cmd/grosh
	@echo "Done building."
	@echo "Run \"$(GOBIN)/grosh\" to launch grosh."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/grosh.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Grosh.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

lint: ## Run linters.
	build/env.sh go run build/ci.go lint

clean:
	./build/clean_go_build_cache.sh
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

grosh-cross: grosh-linux grosh-darwin grosh-windows grosh-android grosh-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/grosh-*

grosh-linux: grosh-linux-386 grosh-linux-amd64 grosh-linux-arm grosh-linux-mips64 grosh-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/grosh-linux-*

grosh-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/gorsh
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/grosh-linux-* | grep 386

grosh-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/grosh
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/grosh-linux-* | grep amd64

grosh-linux-arm: grosh-linux-arm-5 grosh-linux-arm-6 grosh-linux-arm-7 grosh-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/grosh-linux-* | grep arm

grosh-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/grosh
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/grosh-linux-* | grep arm-5

grosh-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/grosh
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/grosh-linux-* | grep arm-6

grosh-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/grosh
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/grosh-linux-* | grep arm-7

grosh-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/grosh
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/grosh-linux-* | grep arm64

grosh-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/grosh
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/grosh-linux-* | grep mips

grosh-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/grosh
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/grosh-linux-* | grep mipsle

grosh-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/grosh
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/grosh-linux-* | grep mips64

grosh-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/grosh
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/grosh-linux-* | grep mips64le

grosh-darwin: grosh-darwin-386 grosh-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/grosh-darwin-*

grosh-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/grosh
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/grosh-darwin-* | grep 386

grosh-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/grosh
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/grosh-darwin-* | grep amd64

grosh-windows: grosh-windows-386 grosh-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/grosh-windows-*

grosh-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/grosh
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/grosh-windows-* | grep 386

grosh-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/grosh
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/grosh-windows-* | grep amd64
