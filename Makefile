up:
	docker run -d  --name="mysql5.5-wordpress"  -e MYSQL_ROOT_PASSWORD=root -p 3306:3306    -v `pwd`/mysql-data/var/lib/mysql:/var/lib/mysql:rw  mysql:5.5;
	docker run -d   --privileged=true --name="wordpress" --link mysql5.5-wordpress:mysql  -p 80:80  -v `pwd`/vhosts:/etc/apache2/vhosts:rw    -v `pwd`:/var/www/html:rw rtancman/php:php53-apache22;

down:
	docker rm wordpress mysql5.5-wordpress;

kill:
	docker kill wordpress mysql5.5-wordpress;

restart:
	docker restart mysql5.5-wordpress wordpress ;

mysqlIp:
	docker exec -it wordpress env | grep MYSQL_PORT_3306_TCP_ADDR;

status:
	docker ps -a;

connectPython:
	docker exec -it wordpress bash;

connectMysql:
	docker exec -it mysql5.5-wordpress bash;
