## Environment setup

### Linux misc/utils
X11 clipboard: 

    sudo apt-get install xclip

curl:

    sudo apt-get install curl

vim (proper):
    
    sudo apt-get install vim

screen:

    sudo apt-get install screen

python-dev libs for various installs (e.g. mercurial):
    
    sudo apt-get install python-dev

### .vimrc
Copy to `~/.vimrc`

### ctags
To install: `apt-get install exuberant-ctags`.

Generate .tags file in git project dir: `ctags -R -f .tags`

.vimrc setting: `set tags=./.tags;`

### Composer
Start a Laravel or Symfony project

    composer create-project symfony/framework-standard-edition /path 2.4.*
    composer create-project laravel/laravel --prefer-dist
    
See vagrant provision file for more details on Composer and PHP dependencies
    
### python
#### pip on Ubuntu 12.04
No separate pip packages for python2/3. Manually use get-pip.py

    wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py
    sudo python2 get-pip.py
    sudo python3 get-pip.py

Some wheels may not work. e.g. When installing mako on python3. Use `pip install --no-use-wheel mako`.

### Google App Engine
Get the SDK

    wget http://googleappengine.googlecode.com/files/google_appengine_1.8.9.zip
    unzip google_app_engine_1.8.9.zip

Add SDK to PATH in `~/.bashrc~`

    export PATH=$PATH:/home/kenley/google_appengine

Run locally: `./dev_appserver.py /path/to/project`

Deploy projects: `./appcfg.py update /path/to/project`

#### djangoappengine
It is needed to provide GAE backends for django to interface with
    
    git clone https://github.com/GoogleCloudPlatform/appengine-django-skeleton.git <project_name>
    cd appengine-django-skeleton
    sudo pip install mercurial
    ./build.sh

Don't run dev\_appserver directly, use djangoappengine's manage.py
Server binds to 127.0.0.1 by default, must bind to 0.0.0.0 to allow other hosts on network to access (including host of VM). 
Use local smtp debug server instead of actually sending emails
Add `--log_level=debug` to see logging.debug() messages

    ./manage.py runserver 0.0.0.0:8000 --smtp_host=localhost --smtp_port=1025
    python -m smtpd -n -c DebuggingServer localhost:1025 

Use djangoappengine's manage.py to deploy instead of appcfg, 

    ./manage.py deploy

`manage.py remote` to execute commands on the production App Engine 

### git
#### config
    git config --global user.name "Kenley Cheung"
    git config --global user.email "winnt253@hotmail.com"
    git config --global core.editor /usr/bin/vi
    git config --global push.default simple

#### gitignore
Copy .gitignore into ~/.gitignore
    
    git config --global core.excludesfile ~/.gitignore

Create .gitignore in repository root and childrens as necessary

#### setup ssh pair
    ssh-keygen
    cat ~/.ssh/id_rsa.pub | xclip -selection clipboard

Configure on github/bitbucket

## TODO
pre-commit hooks to copy ~/.vimrc and ~/.gitignore
