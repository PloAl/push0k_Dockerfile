### Сервер push сообщений push0k
Ubuntu 16.04, PostgreSQL 9.6, node.js 10.15 + push0k 1901
Более подробное описание по ссылкам <https://github.com/PloAl/push0k> <https://infostart.ru/public/716689/>


#### Загрузить образ:

`docker pull ploal/push0k`

Также образ можно собрать из Dockerfile репозитория.

#### Запуск
`docker run --name push0k -d --restart=always --net host --tmpfs="/var/lib/postgresql/9.6/main/pg_stat_tmp:rw,noatime,nodiratime,size=500M,mode=700,uid=799,gid=799" ploal/push0k:1901 /usr/bin/supervisord -c /etc/supervisor/supervisord.conf`

Если контейнер запускается в более ранней версии docker 17.05, из строки запуска следует убрать параметр `--tmpfs="/var/lib/postgresql/9.6/main/pg_stat_tmp:rw,noatime,nodiratime,size=500M,mode=700,uid=799,gid=799"` , данный параметр создает RAM диск для записи статистики postgreSQL, в версиях ниже 17.05 параметр недоступен.

После команды запуска можно подключаться к контейнеру 
* **порт администрирования push0k:** `2016`
* **порт сервера postgreSQL:** `5432`

Сетевой ip адрес совпадает с адресом компьютера где установлен docker. По умолчанию в postgreSQL устанавливается пароль `YourPassword`. Пароль можно изменить в консоли контейнера команда: `sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'YourPassword'"`