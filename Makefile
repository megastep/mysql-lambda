MYSQL_VERSION = 8.0.33
POSTGRESQL_VERSION = 15.3
MONGODB_VERSION = 100.4.0

all: mysql-$(MYSQL_VERSION)-layer.zip mariadb-layer.zip postgresql-$(POSTGRESQL_VERSION)-layer.zip mongodb-tools-$(MONGODB_VERSION)-layer.zip

mysql: mysql-$(MYSQL_VERSION)-layer.zip
mariadb: mariadb-layer.zip
postgresql: postgresql-$(POSTGRESQL_VERSION)-layer.zip
mongodb: mongodb-tools-$(MONGODB_VERSION)-layer.zip

mysql-$(MYSQL_VERSION)-layer.zip:
	docker build -f Dockerfile.mysql . -t mysql-layer --build-arg VERSION=$(MYSQL_VERSION)
	container_id=$$(docker container create mysql-layer) && \
	docker container cp $$container_id:/root/mysql-$(MYSQL_VERSION)-layer.zip . && \
	docker container rm $$container_id

mariadb-layer.zip:
	docker build -f Dockerfile.mariadb . -t mariadb-layer
	container_id=$$(docker container create mariadb-layer) && \
	docker container cp $$container_id:/root/mariadb-layer.zip . && \
	docker container rm $$container_id

postgresql-$(POSTGRESQL_VERSION)-layer.zip:
	docker build -f Dockerfile.postgresql . -t postgresql-layer --build-arg VERSION=$(POSTGRESQL_VERSION)
	container_id=$$(docker container create postgresql-layer) && \
	docker container cp $$container_id:/root/postgresql-$(POSTGRESQL_VERSION)-layer.zip . && \
	docker container rm $$container_id

mongodb-tools-$(MONGODB_VERSION)-layer.zip:
	docker build -f Dockerfile.mongodb . -t mongodb-layer --build-arg VERSION=$(MONGODB_VERSION)
	container_id=$$(docker container create mongodb-layer) && \
	docker container cp $$container_id:/root/mongodb-tools-$(MONGODB_VERSION)-layer.zip . && \
	docker container rm $$container_id

clean:
	rm -f *.zip
