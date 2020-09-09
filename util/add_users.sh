#!/bin/bash

# bash /path/to/file.csv

while read line; do
  a=($(echo "$line" | tr ',' '\n'))

  # add the user
  useradd -m -p $(openssl passwd -crypt "${a[1]}") -s /bin/false "${a[0]}"

  # other user specific stuff here

  usermod -a -G rstudio-user,student "${a[0]}"

  # create a home directory for the user   
  mkdir /home/"${a[0]}"

  # give user access over their directory
  chown "${a[0]}":"${a[0]}" /home/"${a[0]}"

  # set all user subdirectories to inherit user directories permissions
  #chmod g+s /home/"${a[0]}"

done <"$1"
