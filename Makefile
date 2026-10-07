.PHONY: install serve build lint

install:
	python3 -m venv .venv
	.venv/bin/pip install -r requirements.txt

serve:
	.venv/bin/mkdocs serve

build:
	.venv/bin/mkdocs build --strict

lint:
	npx markdownlint-cli2
	vale docs *.md
