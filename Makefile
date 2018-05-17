# Makefile for Docker Nginx/KeyCloak Composer with Posgres DB

include .env

help:
	@echo ""
	@echo "usage: make COMMAND"
	@echo ""
	@echo "Commands:"
	@echo "  clean               Clean directories for reset"
	@echo "  docker-start        Create and start containers"
	@echo "  docker-stop         Stop and clear all services"
	@echo "  gen-certs           Generate SSL certificates"
	@echo "  logs                Follow log output"

clean:
	@rm -Rf etc/ssl/*

ssl:
	@docker run --rm -v $(shell pwd)/etc/ssl:/certificates -e "SERVER=$(NGINX_HOST)" jacoelho/generate-certificate

start:
	@make ssl
	@make chown
	@docker-compose up -d

stop:
	@docker-compose down -v
	@make clean

logs:
	@docker-compose logs -f

chown: ssl
	@$(shell chown -Rf $(SUDO_USER):$(shell id -g -n $(SUDO_USER)) "$(shell pwd)/etc/ssl" 2> /dev/null)

.PHONY: clean start
