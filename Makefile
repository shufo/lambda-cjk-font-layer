# constants
export PROJECT = $(shell basename `pwd`)

MAKEFLAGS += --always-make
MAKEFLAGS += --silent
MAKEFLAGS += --ignore-errors
MAKEFLAGS += --no-print-directory

.PHONY: build
ifeq (build,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
build: ## build and push nginx image to ECR : ## make build
	make build-ttc

.PHONY: build-ttc
ifeq (build-ttc,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
build-ttc: ## build-ttc and push nginx image to ECR : ## make build-ttc
	make clean
	mkdir -p .fonts .fontconfig
	[ ! -f ./.fonts/NotoSansCJK-Regular.ttc ] && wget -N https://github.com/googlefonts/noto-cjk/raw/main/Sans/OTC/NotoSansCJK-Regular.ttc -P .fonts/
	[ ! -f ./.fonts/NotoSerifCJK-Regular.ttc ] && wget -N https://github.com/googlefonts/noto-cjk/raw/main/Serif/OTC/NotoSerifCJK-Regular.ttc -P .fonts/
	docker run -it -u root -e HOME=/root -v $(shell pwd):/root -w /root --entrypoint sh lambci/lambda:python3.6 -c "fc-cache -fv && grep Noto /var/cache/fontconfig/* | cut -d' ' -f 3 | xargs -i cp {} .fontconfig/"
	mkdir -p target/fonts
	cp -fR .fonts .fontconfig target/fonts/
	(cd target && zip -FS -9 -r ../noto_cjk_font_layer.zip *)

.PHONY: build-ttc-cache
ifeq (build-ttc-cache,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
build-ttc-cache:
	make clean
	mkdir -p .fonts .fontconfig
	[ ! -f ./.fonts/NotoSansCJK-Regular.ttc ] && wget -N https://github.com/googlefonts/noto-cjk/raw/main/Sans/OTC/NotoSansCJK-Regular.ttc -P .fonts/
	[ ! -f ./.fonts/NotoSerifCJK-Regular.ttc ] && wget -N https://github.com/googlefonts/noto-cjk/raw/main/Serif/OTC/NotoSerifCJK-Regular.ttc -P .fonts/
	docker run -it -u root -e HOME=/root -v $(shell pwd):/root -w /root --entrypoint sh lambci/lambda:python3.6 -c "fc-cache -fv && grep Noto /var/cache/fontconfig/* | cut -d' ' -f 3 | xargs -i cp {} .fontconfig/"


.PHONY: build-noto
ifeq (build-noto,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
build-noto: ## build-noto and push nginx image to ECR : ## make build-noto
	make clean
	mkdir -p .fonts .fontconfig
	[ ! -f ./.fonts/NotoSansCJK$(word 1, $(RUN_ARGS))-$(word 2, $(RUN_ARGS) Regular).otf ] && wget -N https://github.com/googlefonts/noto-cjk/raw/main/Sans/OTC/NotoSansCJK$(word 1, $(RUN_ARGS))-$(word 2, $(RUN_ARGS) Regular).otf -P .fonts/
	[ ! -f ./.fonts/NotoSerifCJK$(word 1, $(RUN_ARGS))-$(word 2, $(RUN_ARGS) Regular).otf ] && wget -N https://github.com/googlefonts/noto-cjk/raw/main/Serif/OTC/NotoSerifCJK$(word 1, $(RUN_ARGS))-$(word 2, $(RUN_ARGS) Regular).otf -P .fonts/
	docker run -it -u root -e HOME=/root -v $(shell pwd):/root -w /root --entrypoint sh lambci/lambda:python3.6 -c "fc-cache -fv && grep Noto /var/cache/fontconfig/* | cut -d' ' -f 3 | xargs -i cp {} .fontconfig/"
	mkdir -p target/fonts
	cp -fR .fonts .fontconfig target/fonts/
	(cd target && zip -FS -9 -r ../noto_$(word 1, $(RUN_ARGS))_$(word 2, $(RUN_ARGS) Regular)_font_layer.zip *)

.PHONY: build-ipa
ifeq (build-ipa,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
build-ipa: ## build-ipa and push nginx image to ECR : ## make build-ipa
	make clean
	mkdir -p .fonts .fontconfig
	[ ! -f ./.fonts/IPAfont00303.zip ] && wget -N https://ipafont.ipa.go.jp/IPAfont/IPAfont00303.zip -P .fonts/
	unzip -o ./.fonts/IPAfont00303.zip -d .fonts/
	cp ./.fonts/IPAfont00303/*.ttf .fonts/
	rm -fR .fonts/IPAfont00303/ ./.fonts/IPAfont00303.zip
	docker run -it -u root -e HOME=/root -v $(shell pwd):/root -w /root --entrypoint sh lambci/lambda:python3.6 -c "fc-cache -fv && grep ipa /var/cache/fontconfig/* | cut -d' ' -f 3 | xargs -i cp {} .fontconfig/"
	mkdir -p target/fonts
	cp -fR .fonts .fontconfig target/fonts/
	(cd target && zip -FS -9 -r ../ipa_font_layer.zip *)

.PHONY: clean
ifeq (clean,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
clean: ## clean and push nginx image to ECR : ## make clean
	rm -fR .fonts .fontconfig target *.zip noto_*


.PHONY: help
help: ## Show this help message : ## make help
	@echo -e "\nUsage: make [command] [args]\n"
	@grep -P '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ": ## "}; {printf "\t\033[36m%-20s\033[0m \033[33m%-30s\033[0m (e.g. \033[32m%s\033[0m)\n", $$1, $$2, $$3}'
	@echo -e "\n"

.DEFAULT_GOAL := help
