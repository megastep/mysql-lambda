# AWS Lambda Layers for MySQL, MariaDB, PostgreSQL and MongoDB Tools commands

These layers add the `mysql`, `psql`, `mongodump`, `mongorestore` client commands in the form of a layer to be used with [AWS Lambda](https://aws.amazon.com/lambda/).

This is useful for Lambda functions that need to run MySQL, PostgreSQL or MongoDB commands to quickly import data to a RDS server, for example. It can be easier than using the MySQL API in the language of your choice. Particularly useful in coordination with a [Bash lambda](https://github.com/gkrizek/bash-lambda-layer) layer.

The layers (in the form of zip files) are built in Docker using the official AmazonLinux image, to match the typicial Lambda runtime environment.

- The MySQL layer is built from the official source (v8.0.18)
- The MariaDB layer is built from the binary files in the current `mariadb` AmazonLinux package.
- The PostgreSQL layer is built from the official source (v9.2.24)
- The MongoDB Tools layer is built from the official source (v100.4.0)

## Download

Pre-built zip archives that can be uploaded to your AWS account are available on the [releases](https://github.com/megastep/mysql-lambda/releases) page.

## Building the layers

If you have a working Docker setup, you just need to enter `make` to build both the MySQL and MariaDB layers. Alternatively:

- `make mysql` builds the MySQL variant from source.
- `make mariadb` builds the MariaDB variant from the pre-built packages.
- `make postgresql` builds the PostgreSQL variant from source.
- `make mongodb` builds the MongoDB variant from source.

Note that the MySQL 8.0, PostgreSQL and MongoDB variants take considerably longer to build from source.

### Author

[Stephane Peter](https://stephanepeter.com/) ([@megastep](https://github.com/megastep)) - [Sponsor me!](https://github.com/sponsors/megastep)
