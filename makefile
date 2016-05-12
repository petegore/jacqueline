sf=bin/console
tmpdir=symfony_tmp_clone

init-project: install-symfony all

all: install-hook-precommit vendor-install db-restore build-assets

install-symfony:
	@git clone git@github.com:symfony/symfony-standard.git $(tmpdir)
	@cp -rn $(tmpdir)/app/* app/
	@mv $(tmpdir)/bin .
	@mv $(tmpdir)/src .
	@mv $(tmpdir)/tests .
	@mv $(tmpdir)/var .
	@mv $(tmpdir)/web .
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
	@rm -r web/assets/
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
