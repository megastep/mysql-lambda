MYSQL_VERSION = 5.7.34

all: mysql-$(MYSQL_VERSION)-layer.zip mariadb-layer.zip

mysql: mysql-$(MYSQL_VERSION)-layer.zip
mariadb: mariadb-layer.zip

mysql-$(MYSQL_VERSION)-layer.zip:
	docker build -f Dockerfile.mysql . -t mysql-layer --build-arg VERSION=$(MYSQL_VERSION)
	docker container cp $(shell docker container create mysql-layer):/root/mysql-$(MYSQL_VERSION)-layer.zip .

mariadb-layer.zip:
	docker build -f Dockerfile.mariadb . -t mariadb-layer
	docker container cp $(shell docker container create mariadb-layer):/root/mariadb-layer.zip .

clean:
	rm -f *.zip

