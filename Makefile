PYTHON ?= python
PIP ?= $(PYTHON) -m pip
TOX ?= tox

config:
	$(PIP) install pycodestyle
	$(PIP) install flake8
	$(PIP) install twine
	$(PIP) install wheel
	$(PIP) install tox


lint-pycodestyle:
	@echo "\n==> Pycodestyle Linting:"
	@find pyravin -type f -name \*.py | while read file; do echo "$$file" && pycodestyle --config=./pycodestyle --first "$$file" || exit 1; done


lint-flake8:
	@echo "\n==> Flake8 Linting:"
	@find pyravin -type f -name \*.py | while read file; do echo "$$file" && flake8 --config=flake8.ini "$$file" || exit 1; done


lint: lint-pycodestyle lint-flake8
	@echo "\n==> All linting cases passed!"


test:
	@echo "\n==> Run Test Cases:"
	$(TOX)


ci: test lint
	@echo "\n==> All quality checks passed"


build:
	rm -rf build dist
	$(PYTHON) setup.py sdist bdist_wheel


upload:
	$(PYTHON) -m twine upload --repository-url https://test.pypi.org/legacy/ dist/*


release:
	$(PYTHON) -m twine upload --repository-url https://upload.pypi.org/legacy/ dist/*


test_install:
	$(PYTHON) -m pip install --index-url https://test.pypi.org/simple/ pyravin


install:
	$(PYTHON) -m pip install pyravin


develop:
	$(PYTHON) setup.py develop


.PHONY: ci
