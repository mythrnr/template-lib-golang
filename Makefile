.PHONY: cover godoc lint mock pull test tidy

overridefile ?= override
target ?= .
lint_target ?= ./...

cover:
	docker-compose \
		-f docker-compose.yml \
		-f docker-compose.$(overridefile).yml \
		run --rm app sh scripts/cover.sh $(target)

godoc:
	docker-compose up docs godoc

lint:
	docker-compose \
		-f docker-compose.yml \
		-f docker-compose.$(overridefile).yml \
		run --rm --no-deps app golangci-lint run \
			--config=./.golangci.yml \
			--print-issued-lines=false $(lint_target)

mock:
	docker-compose run --rm --no-deps app \
		sh scripts/genmock.sh $(target)

pull:
	docker-compose \
		-f docker-compose.yml \
		-f docker-compose.$(overridefile).yml pull

test:
	docker-compose \
		-f docker-compose.yml \
		-f docker-compose.$(overridefile).yml \
		run --rm app sh scripts/test.sh $(target)

tidy:
	docker-compose \
		-f docker-compose.yml \
		-f docker-compose.$(overridefile).yml \
		run --rm --no-deps app go mod tidy
