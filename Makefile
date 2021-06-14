MYSQL_VERSION = 8.0.18
POSTGRESQL_VERSION = 10.14

all: mysql-$(MYSQL_VERSION)-layer.zip mariadb-layer.zip postgresql-$(POSTGRESQL_VERSION)-layer.zip

mysql: mysql-$(MYSQL_VERSION)-layer.zip
mariadb: mariadb-layer.zip
postgresql: postgresql-$(POSTGRESQL_VERSION)-layer.zip

mysql-$(MYSQL_VERSION)-layer.zip:
	docker build -f Dockerfile.mysql . -t mysql-layer --build-arg VERSION=$(MYSQL_VERSION)
	docker container cp $(shell docker container create mysql-layer):/root/mysql-$(MYSQL_VERSION)-layer.zip .

mariadb-layer.zip:
	docker build -f Dockerfile.mariadb . -t mariadb-layer
	docker container cp $(shell docker container create mariadb-layer):/root/mariadb-layer.zip .

postgresql-$(POSTGRESQL_VERSION)-layer.zip:
        docker build -f Dockerfile.postgresql . -t postgresql-layer --build-arg VERSION=$(POSTGRESQL_VERSION)
        docker container cp $(shell docker container create postgresql-layer):/root/postgresql-$(POSTGRESQL_VERSION)-layer.zip .

clean:
	rm -f *.zip
