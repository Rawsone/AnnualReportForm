note
	description: "Summary description for {DATABASE_WORKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DATABASE_WORKER

create
	make

feature --creating database

	make
		do
			create db.make_create_read_write ("database.db")
		end

feature

	create_table (table_name: STRING; column_names: ARRAY [STRING]; column_types: ARRAY [STRING])
			--creating new table
		require
			column_names.capacity = column_types.capacity
		local
			db_insert: SQLITE_INSERT_STATEMENT
			sql_statement: STRING
			i: INTEGER
		do
			from
				sql_statement := "CREATE TABLE IF NOT EXISTS " + table_name + " ("
				sql_statement.append_string (column_names [1])
				sql_statement.append_string (" " + column_types [1])
				i := 2
			until
				i > column_names.capacity
			loop
				sql_statement.append_string (", " + column_names [i])
				sql_statement.append_string (" " + column_types [i])
				i := i + 1
			end
			sql_statement.append_string (");")
			create db_insert.make (sql_statement, db)
			db_insert.execute
		end

	insert (table_name: STRING; column_names: ARRAY [STRING]; elements: ARRAY [STRING])
		require
			column_names.capacity = elements.capacity
		local
			db_insert: SQLITE_INSERT_STATEMENT
			sql_statement: STRING
			i: INTEGER
		do
			from
				sql_statement := "INSERT INTO " + table_name + " ("
				sql_statement.append_string ("'" + column_names [1] + "'")
				i := 2
			until
				i > column_names.capacity
			loop
				sql_statement.append_string (", '" + column_names [i] + "'")
				i := i + 1
			end
			sql_statement.append_string (") VALUES (")
			from
				sql_statement.append_string ("'" + elements [1] + "'")
				i := 2
			until
				i > elements.capacity
			loop
				sql_statement.append_string (", '" + elements [i] + "'")
				i := i + 1
			end
			sql_statement.append_string (");")
			create db_insert.make (sql_statement, db)
			db_insert.execute
		end

	is_exist (table_name: STRING): BOOLEAN
		local
			db_query: SQLITE_QUERY_STATEMENT
			iterator: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			create db_query.make ("SELECT name FROM sqlite_master WHERE type = 'table' AND name = '" + table_name + "';", db)
			iterator := db_query.execute_new
			iterator.start
			Result := not iterator.after
		end

feature --database

	db: SQLITE_DATABASE

end
