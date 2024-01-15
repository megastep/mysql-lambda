MYSQL_VERSION = 8.0.33
POSTGRESQL_VERSION = 10.14
MONGODB_VERSION = 100.4.0

all: mysql-$(MYSQL_VERSION)-layer.zip mariadb-layer.zip postgresql-$(POSTGRESQL_VERSION)-layer.zip mongodb-tools-$(MONGODB_VERSION)-layer.zip

mysql: mysql-$(MYSQL_VERSION)-layer.zip
mariadb: mariadb-layer.zip
postgresql: postgresql-$(POSTGRESQL_VERSION)-layer.zip
mongodb: mongodb-tools-$(MONGODB_VERSION)-layer.zip

mysql-$(MYSQL_VERSION)-layer.zip:
	docker build --platform linux/amd64 -f Dockerfile.mysql . -t mysql-layer --build-arg VERSION=$(MYSQL_VERSION)
	docker container cp $(shell docker container create mysql-layer):/root/mysql-$(MYSQL_VERSION)-layer.zip .

mariadb-layer.zip:
	docker build --platform linux/amd64 -f Dockerfile.mariadb . -t mariadb-layer
	docker container cp $(shell docker container create mariadb-layer):/root/mariadb-layer.zip .

postgresql-$(POSTGRESQL_VERSION)-layer.zip:
	docker build --platform linux/amd64 -f Dockerfile.postgresql . -t postgresql-layer --build-arg VERSION=$(POSTGRESQL_VERSION)
	docker container cp $(shell docker container create postgresql-layer):/root/postgresql-$(POSTGRESQL_VERSION)-layer.zip .

mongodb-tools-$(MONGODB_VERSION)-layer.zip:
	docker build --platform linux/amd64 -f Dockerfile.mongodb . -t mongodb-layer --build-arg VERSION=$(MONGODB_VERSION)
	docker container cp $(shell docker container create mongodb-layer):/root/mongodb-tools-$(MONGODB_VERSION)-layer.zip .

clean:
	rm -f *.zip
