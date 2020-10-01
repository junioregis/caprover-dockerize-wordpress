APP := wp_template
CMD := docker-compose --project-name=$(APP) --file docker-compose.dev.yml

build:
	$(CMD) build
	$(CMD) pull

start:
	$(CMD) up -d --remove-orphans

stop:
	$(CMD) down

terminal:
	$(CMD) exec app bash

logs:
	$(CMD) logs -f app db

help:
	@echo "Usage: make build|start|stop|terminal|logs|help"
