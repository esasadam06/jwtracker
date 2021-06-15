#!/bin/bash
[ -d "/usr/share/jwtracker" ] && [ ! -L "/usr/share/jwtracker" ] && echo "Directory /usr/share/jwtracker already exists." || sudo mkdir /usr/share/jwtracker

sudo cp module/*.rb /usr/share/jwtracker/

sudo cp jwtracker /usr/bin/