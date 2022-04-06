.PHONY: deps
deps:
	bundle install
	bundle clean --force

.PHONY: docker-setup
docker-setup:
	docker-compose build --pull
	docker-compose run --rm web /bin/bash -c " \
		set -ex; \
		make deps; \
		RAILS_ENV=test bundle exec rails db:drop db:create db:migrate db:seed; \
        RAILS_ENV=development bundle exec rails db:create;"

.PHONY: docker-bash
docker-bash:
	docker-compose run --rm web /bin/bash -c "make deps && exec /bin/bash"

.PHONY: docker-dev
docker-dev:
	docker-compose up web

.PHONY: server
server:
	docker-compose run --rm --service-ports web /bin/bash -c "make deps; rm tmp/pids/server.pid; bundle exec rails s -b 0.0.0.0 -p 8080"
