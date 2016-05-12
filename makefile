sf=bin/console
tmpdir=symfony_tmp_clone

init-project: install-symfony install-hook-precommit vendor-install db-reset build-assets

all: install-hook-precommit vendor-install db-restore build-assets

install-symfony:
	@git clone git@github.com:symfony/symfony-standard.git $(tmpdir)
	@cp -rn $(tmpdir)/app/* app/
	@cp -rn $(tmpdir)/bin/* bin/
	@cp -rn $(tmpdir)/src/* src/
	@cp -rn $(tmpdir)/tests/* tests/
	@cp -rn $(tmpdir)/var/* var/
	@cp -rn $(tmpdir)/web/* web/
	@rm -rf $(tmpdir)

install-roles:
	@ansible-galaxy install -f -r ansible/requirements.yml

vendor-install:
	@composer install -n
	@npm install --loglevel info

db-restore: db-reset db-fixtures

db-reset:
	@$(sf) doctrine:database:drop --force -n || echo see https://github.com/doctrine/DoctrineBundle/issues/384
	@$(sf) doctrine:database:create || echo see https://github.com/doctrine/DoctrineBundle/issues/384
	@$(sf) doctrine:schema:create

db-fixtures:
	@$(sf) doctrine:fixtures:load --append -n

build-assets:
	@rm -r web/assets/ || true
	@gulp --dev

install-hook-precommit:
	@ln -s -f "../../bin/pre-commit" ".git/hooks/pre-commit"

#########################################################
#						TESTS							#
#########################################################
test-prepare-env:
	@$(sf) cache:clear --no-warmup --env=test
	@$(sf) doctrine:database:drop --env=test --force -n || echo see https://github.com/doctrine/DoctrineBundle/issues/384
	@$(sf) doctrine:database:create --env=test || echo see https://github.com/doctrine/DoctrineBundle/issues/384
	@$(sf) doctrine:schema:create --env=test
	@$(sf) doctrine:fixtures:load --env=test -n
