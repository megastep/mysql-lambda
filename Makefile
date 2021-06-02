MYSQL_VERSION = 5.7.34

mysql: mysql-$(MYSQL_VERSION)-layer.zip

mysql-$(MYSQL_VERSION)-layer.zip:
	docker build -f Dockerfile.mysql . -t mysql-layer --build-arg VERSION=$(MYSQL_VERSION)
	docker container cp $(shell docker container create mysql-layer):/root/mysql-$(MYSQL_VERSION)-layer.zip .

clean:
	rm -f *.zip

