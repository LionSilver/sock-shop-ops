COMPOSE := docker compose -f deploy/compose/docker-compose.yml

.PHONY: up down ps logs pull restart

up:
	$(COMPOSE) up -d
	@echo ""
	@echo "Sock Shop: http://localhost:80  (alt: http://localhost:8080)"
	@echo "Status:    make ps"

down:
	$(COMPOSE) down -v

ps:
	$(COMPOSE) ps

logs:
	$(COMPOSE) logs -f --tail=100

pull:
	$(COMPOSE) pull

restart:
	$(COMPOSE) restart
