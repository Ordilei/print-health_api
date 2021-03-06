require 'rubygems'
require 'bundler'
Bundler.require
require 'sinatra/base'
require 'tokamak/hook/sinatra'
require 'models/produto'
require "controllers/base_controller"
require 'controllers/produtos_controller'
require 'will_paginate/array'

class ProdutosApi < Sinatra::Base

	configure do 
		ENV['RACK_ENV'] ||= 'developmemt'
		Mongoid.load!("config/mongoid.yml")		
	end

	use ProdutosController
end

def String.underscore
	gsub(/::/, '/').
		gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
		gsub(/([a-z\d])([A-Z])/,'\1_\2').
		tr("-", "_").
		downcase
end