SHELL := /bin/bash
# .PHONY: bundled_off prod_web prod_worker prod_scheduler docs remove_running_dev_image clean
# export NEXT_PUBLIC_SALEOR_API_URL=https://storefront1.saleor.cloud/graphql/
# export NEXT_PUBLIC_STOREFRONT_URL=http://localhost:3000
store_backend:
	docker build -t saleor_backend --file ./saleor/Dockerfile saleor

dashboard:
	docker build --pull -t dashboard --file saleor-dashboard/Dockerfile saleor-dashboard

saleorfront:
	docker build -t saleorfront --file ./storefront/Dockerfile storefront

build: store_backend dashboard saleorfront


run:
	COMPOSE_HTTP_TIMEOUT=600 sudo docker-compose up -d


stop:
	COMPOSE_HTTP_TIMEOUT=600 sudo docker-compose down


# remove_running_dev_image:
#     $(eval RUNNING_CONTAINERS=$(shell sh -c 'docker ps -q --filter name=saleor_devserver'))
#     docker kill $(RUNNING_CONTAINERS) || true

clean: clean_docker
clean_docker:
	docker system prune --all
	docker rmi -f $(docker images -aq)

# clean_pyc:
#     find . -name "*.pyc" -delete
#     find . -type d -name __pycache__ -delete

restart: stop run 