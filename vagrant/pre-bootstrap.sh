# Pipe details to log, echo summary to /dev/tty
echo "Provisioning..."
/vagrant/bootstrap.sh > /vagrant/provision.log
echo "Provisioning finished. Logged to /vagrant/provision.log"