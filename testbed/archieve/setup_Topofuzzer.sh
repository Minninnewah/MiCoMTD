
# Setup environment
sudo apt update
sudo apt install python3.6 -y
sudo apt install python3-pip -y
pip3 install virtualenv

# Install mininet
sudo apt install mininet -y
mn --version
sudo mn --switch ovsbr --test pingall

# Setup redis
sudo apt install redis -y

# install TopoFuzzer
git clone https://github.com/wsoussi/TopoFuzzer.git
cd TopoFuzzer
git checkout v0.1-fixes
python3.6 -m virtualenv venv
source venv/bin/activate
pip3 install -r requirements.txt


# Manual configuration
echo "Set redis to use the external IP of your machine or VM. To do this edit /etc/redis/redis.conf by changing the line bind 127.0.0.1::1 to bind 0.0.0.0 and uncommenting # requirepass <yourpassword>. Then restart redis with sudo /etc/init.d/redis-server restart"

echo "1. change the file TopoFuzzer/settings.py to put the host IP and the redis port in the correspondent field TOPOFUZZER_IP, REDIS_PORT (default port is 6379), and REDIS_PASSWORD to <yourpassword>."
echo "2. also in TopoFuzzer/settings.py, add the public IP of your hosting machine to ALLOWED_HOSTS"
echo "3. python3 manage.py makemigrations and python3 manage.py migrate"
echo "4. python manage.py createsuperuser"
echo "5. python manage.py runserver 0:8000"
