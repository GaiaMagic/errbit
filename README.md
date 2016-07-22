[errbit](https://github.com/errbit/errbit)

Replacement for Airbrake.

You may need to install `docker`, `docker-compose` and these images and [wechat-notify](https://github.com/caiguanhao/wechat-notify):

```
oss get /downloads/images/ruby-2.3.0.tar.gz | docker load
oss get /downloads/images/mongo-3.2.1.tar.gz | docker load
oss get /downloads/server/wechat-notify/linux/wechat-notify .
```

To build and run:

```
docker-compose build
docker-compose up -d
```

No admin by default; enter Rails' console in the container to create one:

```
docker exec -it errbit_app_1 bash
rails c
User.create!(admin: true, name: 'tech', email: 'admin@example.com', password: 'password')
```

Nginx config example:

```
server {
	listen 80;
	server_name <SERVER_NAME>;
	return 301 https://$host$request_uri;
}

server {
	listen 443 ssl http2;
	# listen 10.12.34.123:443 ssl http2;
	server_name <SERVER_NAME>;
	access_log /data/log/nginx/misc/airbrake.access.log;
	error_log  /data/log/nginx/misc/airbrake.error.log;
	client_max_body_size 2m;
	location /api/ {
		# allow 10.0.0.0/8;
		# deny all;
		try_files $uri @airbrake;
	}
	location / {
		try_files $uri @airbrake;
	}
	location @airbrake {
		proxy_pass http://127.0.0.1:44444;
		proxy_set_header Host              $http_host;
		proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;
		proxy_intercept_errors on;
	}
}
```
