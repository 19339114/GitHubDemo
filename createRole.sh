#!/bin/bash
if [ $# == 1 ]; then
  if [ -f "$1.yml" ]; then
    printf "\nError, unable to continue as the file \"$1.yml\" already exists.\n\n"
    exit 1
  fi
  cat << EOF > "$1.yml"
- hosts: localhost
  vars_files:
    - /ansible/secret.yml
  #become: true
  roles:
  - $1
EOF
  mkdir "./roles/$1/files" -p
  mkdir "./roles/$1/tasks" -p
  touch "./roles/$1/tasks/main.yml"
  cat << EOF > "./roles/$1/tasks/main.yml"
- name: "Update and upgrade apt packages"
  become: true
  apt:
    upgrade: 'yes'
    update_cache: yes

- name: "Installing dependencies"
  apt:
    pkg: [ nano, htop, tree ]
    state: latest
EOF
  nano "./roles/$1/tasks/main.yml"
  exit 0
elif [ $# == 2 ]; then
  if [ $2 == "--remove" ]; then
    rm "$1.yml"
    rm -rf "./roles/$1"
    exit 0
  fi
else
  printf "\nPlease enter a playbook name.\n\n"
fi
