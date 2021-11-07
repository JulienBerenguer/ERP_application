:: Help : https://stackoverflow.com/questions/35575674/how-to-save-all-docker-images-and-copy-to-another-machine

:: Save in .tar file (Caution : to modify if any new container is added)
docker save $(docker images | awk '{if ($1 ~ /^(erp|php|mysql|phpmyadmin)/) print $3}') -o ./dist/ERP_application.tar

:: Same in two lines (Caution : do not work in windows)
::IDS=$(docker images | awk '{if ($1 ~ /^(erp|php|mysql|phpmyadmin)/) print $3}')
::docker save $IDS -o ./dist/ERP_application.tar

:: More secure : export all containers, just be sure there is only those you want in Docker
::docker save $(docker images -q) -o /path/to/save/mydockersimages.tar

:: If each container needs it's .tar file
::docker images | awk '{if ($1 ~ /^(erp|php|mysql|phpmyadmin)/) print $1 " " $2 " " $3 }' | tr -c "a-z A-Z0-9_.\n-" "%" | while read REPOSITORY TAG IMAGE_ID
::do
::  echo "== Saving $REPOSITORY $TAG $IMAGE_ID =="
::  docker  save   -o /path/to/save/$REPOSITORY-$TAG-$IMAGE_ID.tar $IMAGE_ID
::done

:: Export all containers IDs used, can be useful for a modification of this file
docker images | sed '1d' | awk '{print $1 " " $2 " " $3}' > ./dist/ImagesUsed.list

