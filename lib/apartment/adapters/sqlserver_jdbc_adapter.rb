module Apartment

  module Database
    def self.sqlserver_jdbc_adapter(config)
      config['default_schema'] = 'dbo' if config['default_schema'].eql?('public')
      Adapters::SqlServerJDBCAdapter.new config
    end
  end

  module Adapters
    class SqlServerJDBCAdapter < AbstractJDBCAdapter

      #   Get the current database name
      #
      #   @return {String} current database name
      #
      def current_database
        @current_database = Apartment.connection.database_name
      end

      def current
        current_database
      end
    end
  end
end