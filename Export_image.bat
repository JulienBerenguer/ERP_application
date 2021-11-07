:: Help : https://stackoverflow.com/questions/35575674/how-to-save-all-docker-images-and-copy-to-another-machine

docker save $(docker images | awk '{if ($1 ~ /^(erp|php|mysql|phpmyadmin)/) print $3}') -o ./dist/ERP_application.tar

::IDS=$(docker images | awk '{if ($1 ~ /^(erp|php|mysql|phpmyadmin)/) print $3}')
::docker save $IDS -o ./dist/ERP_application.tar