NAME := markdown
VERSION := v1

# Container target
IMAGE_MARKDOWN := ghcr.io/mkincl/$(NAME)-provider:$(VERSION)

.PHONY: enter-container-$(NAME)
enter-container-$(NAME):
	docker run --rm --interactive --tty --pull always --volume "$$(pwd)":/pwd --workdir /pwd $(IMAGE_MARKDOWN)

# Generic targets
.PHONY: lint lint-$(NAME)
lint: lint-$(NAME)

# Which files to act on. This is overrideable.
FILES_MARKDOWN = $(shell find . -type f -iname '*.md')

.PHONY: has-files-markdown
has-files-markdown:
	@for file in $(FILES_MARKDOWN); do exit 0; done; echo "FILES_MARKDOWN is empty"; exit 1

# Specific targets
.PHONY: lint-$(NAME)-markdownlint lint-$(NAME)-markdown-link-check
lint-$(NAME): lint-$(NAME)-markdownlint lint-$(NAME)-markdown-link-check

lint-$(NAME)-markdownlint: has-files-markdown
	markdownlint $(FILES_MARKDOWN)

MARKDOWN_LINK_CHECK_CONFIG ?= .markdown-link-check.json
ifeq ("$(wildcard $(MARKDOWN_LINK_CHECK_CONFIG))","")
MARKDOWN_LINK_CHECK_CONFIG_ARG =
else
MARKDOWN_LINK_CHECK_CONFIG_ARG = --config $(MARKDOWN_LINK_CHECK_CONFIG)
endif

lint-$(NAME)-markdown-link-check: has-files-markdown
	markdown-link-check $(MARKDOWN_LINK_CHECK_CONFIG_ARG) --quiet $(FILES_MARKDOWN)
