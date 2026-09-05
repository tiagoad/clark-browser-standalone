.PHONY: lint test

lint:
	shellcheck -a clark-standalone

test:
	./scripts/e2e-tests.sh

update-readme:
	./scripts/update-readme.sh
