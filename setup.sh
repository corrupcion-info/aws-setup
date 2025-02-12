sudo yum install -y docker
sudo systemctl start docker.service
DOCKERHUB_TOKEN=$(aws secretsmanager get-secret-value --secret-id dockerhub --query SecretString --output text)
sudo docker login --username corrupcion --password $DOCKERHUB_TOKEN
sudo docker pull corrupcion/corrupcion:latest
sudo docker run --hostname certbot -p 80:80 -v /opt/certbot/certbot_logs:/var/log/letsencrypt -v /etc/letsencrypt:/etc/letsencrypt certbot/certbot certonly --non-interactive --standalone --email corrupcion.es@protonmail.com --agree-tos --no-eff-email -d corrupcion.info
sudo docker run -p 80:80 -p 443:443 -v /etc/letsencrypt:/etc/letsencrypt -v /var/lib/letsencrypt:/var/lib/letsencrypt -ti --rm --entrypoint gunicorn corrupcion/corrupcion:latest -b 0.0.0.0:443 --certfile=/etc/letsencrypt/live/corrupcion.info/fullchain.pem --keyfile=/etc/letsencrypt/live/corrupcion.info/privkey.pem app:app
