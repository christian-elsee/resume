export NAME := $(shell basename "$$PWD" )
export SHA := $(shell git rev-parse --short HEAD)
export TS  := $(shell date +%s)

.DEFAULT_GOAL := @goal
.ONESHELL:
.POSIX:

## workflow
@goal: distclean dist build

dist: ;: ## dist
	mkdir -p $@

## ad hoc
push: branch := $(shell git branch --show-current)
push: ;: ## push
	test "$(branch)"

	# ensure working tree is clean for push
	git status --porcelain \
		| xargs \
		| grep -qv .

	ssh-agent bash -c \
		"<secrets/key.gpg gpg -d | ssh-add - \
			&& git push origin $(branch) -f"

