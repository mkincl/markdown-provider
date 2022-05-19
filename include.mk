NAME := markdown
VERSION := v1

# Container target
IMAGE_REGISTRY := ghcr.io/carlsmedstad
IMAGE_MARKDOWN := $(IMAGE_REGISTRY)/mkincl-$(NAME):$(VERSION)

.PHONY: enter-container-$(NAME)
enter-container-$(NAME):
	docker run --rm --interactive --tty --pull always --volume "$$(pwd)":/pwd --workdir /pwd $(IMAGE_MARKDOWN)

# Generic targets
.PHONY: lint lint-$(NAME)
lint: lint-$(NAME)

# Actual targets
.PHONY: lint-$(NAME)-markdownlint lint-$(NAME)-markdown-link-check
lint-$(NAME): lint-$(NAME)-markdownlint lint-$(NAME)-markdown-link-check

lint-$(NAME)-markdownlint:
	markdownlint .

MARKDOWN_FILES = $(shell find . -type f -iname '*.md')

MARKDOWN_LINK_CHECK_CONFIG ?= .markdown-link-check.json
ifeq ("$(wildcard $(MARKDOWN_LINK_CHECK_CONFIG))","")
MARKDOWN_LINK_CHECK_CONFIG_ARG =
else
MARKDOWN_LINK_CHECK_CONFIG_ARG = --config $(MARKDOWN_LINK_CHECK_CONFIG)
endif

lint-$(NAME)-markdown-link-check:
	markdown-link-check $(MARKDOWN_LINK_CHECK_CONFIG_ARG) --quiet	$(MARKDOWN_FILES)
