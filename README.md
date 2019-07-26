# E-College API

ecollegeapi belongs to a fictional E-College. The purpose of it is to demonstarate how to create an API for beginners.

## Background

* It explains how to create a Ruby server with Sinatra web framework.
* It teaches how to make HTTP requests to remote resources.
* It gives a general explanation on how to setup and build a minimal web application with Ruby and Sinatra.

## Technologies

* Ruby
* Sinatra
* ActiveRecord
* PostgreSQL

## Installation

Make sure you have Ruby installed on your local system. If not, you can download it from [this website](https://www.ruby-lang.org/en/downloads/).

You should also have git installed on your local computer. Download git from [git-scm.com](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).


To clone the repository to your local setup, open your bash/terminal, copy and paste each of the following code, and press enter.

`gem install bundler`

`git clone https://github.com/annessca/ecollegeapi.git`

`cd ecollegeapi`

`bundle install`

Take a break from the terminal and create a PostgreSQL database named **ecollege**

`rake db:migrate`

`rake db:seed`

Follow the tutorial on the [Lixy](http://www.lixy.tech/blog) official website.


