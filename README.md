[errbit](https://github.com/errbit/errbit)

Replacement for Airbrake.

You may need to install `docker`, `docker-compose` and these images:

```
oss get /downloads/images/ruby-2.3.0.tar.gz | docker load
oss get /downloads/images/mongo-3.2.1.tar.gz | docker load
```

To build and run:

```
docker-compose build
docker-compose up -d
```

To create admin:

```
docker exec -it errbit_app_1 bash
rails c
User.create!(admin: true, name: 'tech', email: 'admin@example.com', password: 'password')
```
