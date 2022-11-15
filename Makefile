CONTAINERS := postgres

MAKE = make --no-print-directory
DOCKER = docker
# ls -1 ./docker/_compose/docker-compose.*
DOCKER_COMPOSE = ./vendor/bin/sail
CLI = $(DOCKER_COMPOSE) exec -T cli

# DOCKER ###############################################################################################################

start: ##@docker start containers
	#$(MAKE) -s copy-dist-files
	$(DOCKER_COMPOSE) up --build --detach
.PHONY: start

logs: ##@docker show server logs
	$(DOCKER_COMPOSE) logs -f --tail=all
.PHONY: logs

stop: ##@docker stop containers
	$(DOCKER_COMPOSE) stop --timeout 1
.PHONY: stop


restart: ##@docker restart containers
	$(MAKE) stop
	sleep 3
	$(MAKE) start
.PHONY: restart

rebuild: ##@docker removes images
	#$(MAKE) -s copy-dist-files
	$(DOCKER_COMPOSE) down --remove-orphans --volumes
	$(MAKE) setup
.PHONY: rebuild

clean: ##@docker stop and remove containers
	$(MAKE) stop
	$(DOCKER_COMPOSE) down --remove-orphans --volumes --rmi all
.PHONY: clean

stats: ##@docker list docker stats
	$(DOCKER) stats --format "table {{.Container}}\t{{.Name}}\t{{.CPUPerc}}\t{{.MemPerc}}\t{{.BlockIO}}"
.PHONY: stats

# COMPOSER #############################################################################################################

composer-install: ##@composer run 'composer install'
	$(CLI) composer install --ansi
.PHONY: composer-install

composer-autoload: ##@composer run 'composer dump-autoload'
	$(CLI) composer dump-autoload --ansi  --classmap-authoritative
.PHONY: composer-autoload

# SETUP ################################################################################################################

setup: ##@setup Create dev enviroment
	#$(MAKE) etc-hosts
	$(MAKE) start
	$(MAKE) codebase-update
	#$(CLI) sh -c "while ! nc -z postgres 5432; do sleep 0.1; done"
	#$(CLI) chown www-data -R data
.PHONY: setup

codebase-update:
	#$(MAKE) composer-install
	#$(MAKE) composer-autoload
.PHONY: codebase-update

etc-hosts:
	sudo sed -i '' '/\.bc/d' /etc/hosts
	#sudo sed -i '' '/localunixsocket\.local/d' /etc/hosts
	sudo sh -c "echo '${PROJECT_IP} auth-batchcloud-de.bc' >> /etc/hosts"
	# thanks to https://github.com/docker/compose/issues/3419#issuecomment-221793401
	#grep -q "^${PROJECT_IP} localunixsocket\\.local$$" /etc/hosts || sudo sh -c "echo '${PROJECT_IP} localunixsocket.local' >> /etc/hosts"
.PHONY: etc-hosts
