#!/bin/bash

[ -d "/usr/share/jwtracker" ] && [ ! -L "/usr/share/jwtracker" ] && echo "Directory /usr/share/jwtracker already exists." || sudo mkdir /usr/share/jwtracker 

sudo gem install http

sudo cp modules/*.rb /usr/share/jwtracker/

echo "Copied to /usr/bin/"

sudo cp jwtracker /bin/

sudo chmod +x /bin/jwtracker
