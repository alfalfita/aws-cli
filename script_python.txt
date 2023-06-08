#!/bin/bash
yum update -y
yum install -y python3
#yum install -y python-pip
yum install python3-pip
#in a virtual environment or using Python 2
pip install Flask

#for python 3 (could also be pip3.10 depending on your version)
pip3 install Flask

#if you get permissions error
sudo pip3 install Flask
pip install Flask --user

#if you don't have pip in your PATH environment variable
python -m pip install Flask

#for python 3 (could also be pip3.10 depending on your version)
python3 -m pip install Flask

pip install -y flask

yum install  -y git
git clone https://github.com/alfalfita/aws-cli.git
cd aws-cli/python
python3 helloworld.py
