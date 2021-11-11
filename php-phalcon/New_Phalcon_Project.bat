cd ../
docker-compose exec php-phalcon-environment composer init
docker-compose exec php-phalcon-environment composer require --dev phalcon/devtools:4.0.2
docker-compose exec php-phalcon-environment ./vendor/bin/phalcon project application simple