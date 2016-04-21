#!/usr/bin/env bash

# Katana source
cd ~
git clone https://github.com/Unity-Technologies/katana.git
cd katana
git checkout katana

virtualenv --no-site-packages katana-venv/
source katana-venv/bin/activate
 
cd ~/katana
pip install -e master
pip install -v mock
pip install pyflakes
pip install -e slave 

#trial buildbot.test
#trial buildslave.test

buildbot create-master testmaster
cd testmaster

# Update the configuration
mv master.cfg.sample master.cfg
read -d '' katanaupdateddbconfig << EOF
c['db'] = {
   # This specifies what database buildbot uses to store its state.  You can leave
   # this at its default for all but the largest installations.
   'db_url': "mysql://myuser:mypassword@localhost/katana-dev?max_idle=300",
   'db_poll_interval': 2,
}
EOF
export katanaupdateddbconfig
perl -p -i -e 'BEGIN{undef $/;} s/c\[\047db\047] = {([^}]*)}/$ENV{katanaupdateddbconfig}/gms' master.cfg

echo -e "\n\nc['multiMaster'] = True" >> master.cfg

buildslave create-slave  build-slave-01 localhost:9989 build-slave-01 builduser
buildslave create-slave  build-slave-02 localhost:9989 build-slave-02 builduser 

read -d '' katanaupdatedslavesconfig << EOF
c['slaves'] = [BuildSlave("build-slave-01", "builduser", max_builds=1, friendlyName="mac-slave-01"),
              BuildSlave("build-slave-02", "builduser", max_builds=1, friendlyName="mac-slave-02")]
EOF
export katanaupdatedslavesconfig
perl -p -i -e 'BEGIN{undef $/;} s/c\[\047slaves\047] = ([^\n]*)/$ENV{katanaupdatedslavesconfig}/gms' master.cfg

perl -p -i -e 'BEGIN{undef $/;} s/"example-slave"/"build-slave-01", "build-slave-02"/gms' master.cfg

buildbot --verbose upgrade-master ~/katana/testmaster
buildbot start ~/katana/testmaster

buildslave start build-slave-01
buildslave start build-slave-02

#buildbot stop ~/katana/testmaster
#buildbot --verbose upgrade-master ~/katana/testmaster
#buildbot start ~/katana/testmaster
