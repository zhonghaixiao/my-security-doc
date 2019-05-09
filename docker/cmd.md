- docker exec -it id /bin/bash
- docker rm -vf bmweb
- docker run --name bmweb_ro --volume /g/test:/usr/local/apache2/htdocs/:ro -p 80:80 httpd:latest
- docker inspect -f "{{json.Volumes}}" cass-shared


































