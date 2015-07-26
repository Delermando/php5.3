up:
	docker run -d  --name="mysql5.5"  -e MYSQL_ROOT_PASSWORD=root -p 3306:3306    -v `pwd`/mysql-data/var/lib/mysql:/var/lib/mysql:rw  mysql:5.5;
	docker run -d   --privileged=true --name="php5.3" --link link-php5.3-mysql5.5:mysql5.5  -p 80:80  -v `pwd`/vhosts:/etc/apache2/vhosts:rw    -v `pwd`:/var/www/html:rw delermando/php5.3-mysql5.5;

down:
	docker rm php5.3 mysql5.5;

kill:
	docker kill php5.3 mysql5.5;

restart:
	docker restart mysql5.5 php5.3 ;

mysqlIp:
	docker exec -it php5.3 env | grep MYSQL_PORT_3306_TCP_ADDR;

status:
	docker ps -a;

connectPhp:
	docker exec -it php5.3 bash;

connectMysql:
	docker exec -it mysql5.5 bash;
