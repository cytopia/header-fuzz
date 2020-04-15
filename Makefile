ifneq (,)
.error This Makefile requires GNU Make.
endif

# -------------------------------------------------------------------------------------------------
# Default configuration
# -------------------------------------------------------------------------------------------------
.PHONY: help install uninstall lint lint-file lint-bash

FL_VERSION = 0.3
FL_IGNORE_PATHS = .git/,.github/

# -------------------------------------------------------------------------------------------------
# Default Target
# -------------------------------------------------------------------------------------------------
help:
	@echo "lint             Lint source code"
	@echo "install          Install (required root or sudo)"
	@echo "Uninstall        Uninstall (required root or sudo)"


# -------------------------------------------------------------------------------------------------
# System targets
# -------------------------------------------------------------------------------------------------

install: header-fuzz
	install -d /usr/local/bin
	install -m 755 header-fuzz /usr/local/bin/header-fuzz


uninstall:
	rm /usr/local/bin/header-fuzz


# -------------------------------------------------------------------------------------------------
# Lint Targets
# -------------------------------------------------------------------------------------------------

lint: lint-file lint-bash

lint-file:
	@echo "# -------------------------------------------------------------------- #"
	@echo "# Lint files                                                           #"
	@echo "# -------------------------------------------------------------------- #"
	@docker run --rm -v $(PWD):/data cytopia/file-lint:$(FL_VERSION) file-crlf --text --ignore '$(FL_IGNORE_PATHS)' --path .
	@docker run --rm -v $(PWD):/data cytopia/file-lint:$(FL_VERSION) file-trailing-single-newline --text --ignore '$(FL_IGNORE_PATHS)' --path .
	@docker run --rm -v $(PWD):/data cytopia/file-lint:$(FL_VERSION) file-trailing-space --text --ignore '$(FL_IGNORE_PATHS)' --path .
	@docker run --rm -v $(PWD):/data cytopia/file-lint:$(FL_VERSION) file-utf8 --text --ignore '$(FL_IGNORE_PATHS)' --path .
	@docker run --rm -v $(PWD):/data cytopia/file-lint:$(FL_VERSION) file-utf8-bom --text --ignore '$(FL_IGNORE_PATHS)' --path .

lint-bash:
	@echo "# -------------------------------------------------------------------- #"
	@echo "# Lint shellcheck                                                      #"
	@echo "# -------------------------------------------------------------------- #"
	@docker run --rm -v $(PWD):/mnt koalaman/shellcheck:stable --shell=bash header-fuzz


# -------------------------------------------------------------------------------------------------
# Helper targets
# -------------------------------------------------------------------------------------------------

pull-docker-lint-file:
	docker pull cytopia/file-lint:$(FL_VERSION)

pull-docker-lint-bash:
	docker pull koalaman/shellcheck:stable
