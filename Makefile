SHELL := /bin/bash
# .PHONY: bundled_off prod_web prod_worker prod_scheduler docs remove_running_dev_image clean

store_backend:
	docker build -t saleor_backend --file ./saleor/Dockerfile saleor

dashboard:
	docker build --pull -t saleor_dashboard --file saleor-dashboard/Dockerfile saleor-dashboard --build-arg API_URI=http://ec2-34-200-107-237.compute-1.amazonaws.com:8000/graphql/

saleorfront:
	docker build -t storefront --file ./storefront/Dockerfile storefront --build-arg NEXT_PUBLIC_SALEOR_API_URL=http://ec2-34-200-107-237.compute-1.amazonaws.com:8000/graphql/ --build-arg NEXT_PUBLIC_STOREFRONT_URL=http://ec2-34-200-107-237.compute-1.amazonaws.com:3000/

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