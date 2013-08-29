require "bundler/capistrano"
require "rvm/capistrano"

server "10.12.0.69", :web, :app, :db, primary: true

set :application, "capistrano" # Nome da app
set :user, "fabsoft" # usuario do SERVIDOR
set :deploy_to, "/home/#{user}/apps/#{application}" #Local no servidor onde vai ficar o projeto
set :use_sudo, false # Não executar os Comandos com 'sudo' no inicio

set :scm, "git" # Tipo: git, bitcucket...
set :repository, "git@github.com:felipegithub/capistra.git" #URL do repositorio
set :branch, "master"

set :rvm_ruby_string, :local              # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, "read-only"  

set :rails_env, "production"

#Parametros de conexão via ssh:
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup"

#Definição das 'Tarefas para Deploy:'
namespace :deploy do

	#Cria-se tarefas, como se fossem metodos que vão ser executados conforme o deploy ocorre
	task :setup_inicial_nginx, roles: :app do
		sudo "ln -nfs #{current_path}/config/nginx_site.conf /etc/nginx/sites-enabled/#{application}"
		sudo "service nginx restart"
		puts "Criou o Link do arquivo de configuração do ngingx"
	end
	
	after "deploy:setup", "deploy:setup_inicial_nginx"
	

end
