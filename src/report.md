# Simple Docker

Введение в докер. Разработка простого докер-образа для собственного сервера.

## Contents

1. [Chapter I](#chapter-i)
2. [Chapter II](#chapter-ii) \
    2.1. [nginx](#nginx) \
    2.2. [Docker](#docker) \
    2.3. [Dockle](#dockle)
3. [Chapter III](#chapter-iii) \
    3.1. [Готовый докер](#part-1-готовый-докер) \
    3.2. [Операции с контейнером](#part-2-операции-с-контейнером) \
    3.3. [Мини веб-сервер](#part-3-мини-веб-сервер) \
    3.4. [Свой докер](#part-4-свой-докер) \
    3.5. [Dockle](#part-5-dockle) \
    3.6. [Базовый Docker Compose](#part-6-базовый-docker-compose)


## Part 1. Готовый докер
**== Задание ==**

##### Взяла официальный докер-образ с **nginx** и выкачала его при помощи 
```
docker pull
```
![docker pull](/src/image/1.png)
##### Проверила наличие докер-образа через 
```
docker images
```
![docker images](/src/image/2.png)
##### Запустила докер-образ через 
```
docker run -d [image_id|repository]
```
и проверила, что образ запустился через 
```
docker ps
```
![docker run](/src/image/3.png)
##### Посмотрела информацию о контейнере через 
```
docker inspect [container_id|container_name]
```
![docker inspect](/src/image/4.png)
![docker inspect](/src/image/5.png)
![docker inspect](/src/image/6.png)
![docker inspect](/src/image/7.png)
![docker inspect](/src/image/8.png)
![docker inspect](/src/image/9.png)
##### По выводу команды определить и поместить в отчёт размер контейнера, список замапленных портов и ip контейнера.

Узнала размер контейнера использовав команду:
```
docker inspect --size <container_id|container_name> -f '{{ .SizeRootFs }}'
```
![docker inspect](/src/image/10.png)

Список замапленных портов указан в блоке NetworkSettings:
![docker inspect](/src/image/11.png)
Узнала ip контейнера использовав команду 
```
docker inspect --format '{{ .NetworkSettings.IPAddress }}' <container_id_or_name>
```

![docker inspect](/src/image/12.png)

##### Остановила докер контейнер через 
```
docker stop [container_id|container_name]
```
![docker inspect](/src/image/13.png)
##### Проверила, что контейнер остановился через 
```
docker ps
```
![docker inspect](/src/image/14.png)

##### Запустила докер с портами 80 и 443 в контейнере, замапленными на такие же порты на локальной машине, через команду *run* и проверила, что в браузере по адресу *localhost:80* доступна стартовая страница **nginx**.
```
docker run -p 80:80 -p 443:443 -d nginx
```
```
curl localhost:80
```
![docker inspect](/src/image/15.png)



##### Перезапустила докер контейнер через и проверила, что контейнер запустился.
```
docker restart [container_id|container_name]
```

```
docker ps
```
![docker restart](/src/image/16.png)


## Part 2. Операции с контейнером

##### Прочитала конфигурационный файл *nginx.conf* внутри докер контейнера через команду *exec*.
```
docker exec -it c14d9d3bf3e9 /bin/bash
```
![docker restart](/src/image/20.png)
![docker restart](/src/image/21.png)
##### Создла на локальной машине файл *nginx.conf*.
![docker restart](/src/image/22.png)

##### Настрила в нем по пути */status* отдачу страницы статуса сервера **nginx**.
![docker restart](/src/image/022.png)

`stub_status on` — включает страницу состояния.

`access_log off` — отключает логирование для этого пути.

`allow 127.0.0.1` — разрешает доступ только с локального хоста (вы можете изменить это, чтобы разрешить доступ с других IP-адресов).

`deny all` — запрещает доступ всем остальным.
Примечание: Вы можете настроить доступ и для других IP-адресов, заменив `127.0.0.1` на нужный IP или диапазон.

Проверка конфигурации Nginx: После внесения изменений в конфигурацию, проверьте её на наличие ошибок с помощью команды:
```
nginx -t
```
![docker restart](/src/image/23.png)

##### Скопировала созданный файл *nginx.conf* внутрь докер-образа через команду `docker cp`.

```
docker cp ./nginx.conf c14d9d3bf3e9:/etc/nginx/nginx.conf
```
![docker restart](/src/image/24.png)

`./nginx.conf` — путь к файлу на вашей локальной машине.

`c14d9d3bf3e9:/etc/nginx/nginx.conf` — путь, куда файл будет скопирован в контейнере.

Проверка успешности копирования: Вы можете проверить, что файл был успешно скопирован, с помощью команды `docker exec`:

```
docker exec c14d9d3bf3e9 ls /etc/nginx/nginx.conf
```
![docker restart](/src/image/25.png)




##### Перезапустила **nginx** внутри докер-образа через команду *exec*.
После того как файл был скопирован в контейнер, чтобы изменения вступили в силу, нужно перезапустить Nginx.

```
docker exec d6110f99d426 nginx -t  # Проверка конфигурации
```
![docker restart](/src/image/26.png)
```
docker exec d6110f99d426 nginx -s reload  # Перезапуск Nginx
```

![docker restart](/src/image/27.png)

##### Проверила, что по адресу *localhost:80/status* отдается страничка со статусом сервера **nginx** использовав команду:
```
curl -i http://localhost:80
```
![docker restart](/src/image/28.png)
либо написав  в браузере:
```
http://localhost/status
```
![docker restart](/src/image/29.png)
##### Экспортируй контейнер в файл *container.tar* через команду *export*.

```
docker export d6110f99d426 > container.tar
```
Проверила экспортированный файл.

```
ls -lh container.tar
```
![docker restart](/src/image/30.png)

##### Остановила контейнер.
```
docker stop d6110f99d426 
```
Проверила, что контейнер остановлен:

```
docker ps
```
![docker restart](/src/image/31.png)

##### Удалила образ через `docker rmi [image_id|repository]`, не удаляя перед этим контейнеры.

Остановила сперва контейнер не удаляя его использовав команду:

```
docker stop [container_id]
```
![docker restart](/src/image/32.png)

```
docker rmi [image_id|repository]
```

![docker restart](/src/image/33.png)

##### Удалила остановленный контейнер использовав команду 

```
docker rm <container_id_or_name>
```

![docker restart](/src/image/34.png)

##### Импортировала контейнер обратно через команду *import*.
```
docker import -c 'CMD ["nginx", "-g", "daemon off;"]' -c 'ENTRYPOINT ["/docker-entrypoint.sh"]' container.tar nginx_v2
```

##### Запустила импортированный контейнер.
```
docker run -p 80:80 -p 443:443 -d <IMAGE ID>
```
![docker restart](/src/image/35.png)
##### Проверила, что по адресу *localhost:80/status* отдается страничка со статусом сервера **nginx**.

![docker restart](/src/image/36.png)

## Part 3. Мини веб-сервер

##### Напиши мини-сервер на **C** и **FastCgi**, который будет возвращать простейшую страничку с надписью `Hello World!`.

В macOS, вы можете установить библиотеку FastCGI с помощью Homebrew.

Шаг 1: Установка Homebrew (если он еще не установлен)

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

```
После установки, вам может потребоваться добавить Homebrew в ваш PATH. Следуйте инструкциям, которые появятся после завершения установки.

Шаг 2: Установка FastCGI с помощью Homebrew

```
brew install fcgi
```
Шаг 3: Мини сервер на C и FastCgi, который будет возвращать простейшую страничку с надписью `Hello World!`

```
#include <fcgi_stdio.h>
#include <stdlib.h>

int main (void) {
    while (FCGI_Accept() >= 0) {
        printf("Status: 200 OK\r\n");
        printf("Content-type: text/html\r\n\r\n");
        printf("<!doctype><html><body>\nHello World!\n</body></html>\n");
    }
    return EXIT_SUCCESS;
}
```
Компилиция:

```
gcc -o main hello.c -I/opt/homebrew/Cellar/fcgi/2.4.3/include -L/opt/homebrew/Cellar/fcgi/2.4.3/lib -lfcgi

```

Запустила написанный мини сервер через spawn-fcgi на порту 8080:

```
spawn-fcgi -p 8080 -n ./server
```

##### Написала свой *nginx.conf*, который будет проксировать все запросы с 81 порта на *127.0.0.1:8080*.

![docker restart](/src/image/37.png)


##### Проверила, что в браузере по *localhost:81* отдается написанная мной страничка. 
```
curl localhost:81
```
![docker restart](/src/image/38.png)

![docker restart](/src/image/39.png)
##### Положила файл *nginx.conf* по пути *./nginx/nginx.conf* (это понадобится позже).
```
docker cp nginx/nginx.conf 17f51d056e85:/etc/nginx/nginx.conf
```
## Part 4. Свой докер

4.1 Создала Dockerfile на основе nginx
```
FROM nginx
RUN apt-get update && apt-get install -y gcc spawn-fcgi libfcgi-dev
EXPOSE 81
COPY hello.c /
COPY nginx.conf etc/nginx
RUN gcc hello.c -o hello -lfcgi
ENTRYPOINT spawn-fcgi -p 8080 ./hello && nginx -g 'daemon off;'
```
*При написании докер-образа избегай множественных вызовов команд RUN*

