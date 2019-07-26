# Environment is configured for both development and production

configure :production, :development do
	set :show_exceptions, true

	db = URI.parse(ENV['DATABASE_URL'] || 'postgres://postgres:anneralphessien@localhost/ecollege')

	ActiveRecord::Base.establish_connection(
		adapter:  db.scheme == 'postgres' ? 'postgresql' : db.scheme,
		host:     db.host,
		username: db.user,
		password: db.password,
		database: db.path[1..-1],
		encoding: 'utf8'
	)

	#ActiveRecord::Base.class_eval do
	  #def self.populate_database(records={})
	    #records[:to] ||= 1
	    #if self.connection.adapter_name == 'PostgreSQL'
	    	#self.connection.execute "ALTER SEQUENCE #{self.table_name}_id_seq RESTART WITH #{records[:to]};"
	    #else
	    	# No fallback
	    #end
	  #end
	#end
end