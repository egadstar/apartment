module Apartment

  module Adapters

    class AbstractJDBCAdapter < AbstractAdapter

      #   @constructor
      #   @param {Hash} config Database config
      #
      def initialize(config)
        super(config)
        @current_database = current_database
      end


      #   Get the current database name
      #
      #   @return {String} current database name
      #
      def current_database
        @current_database = Apartment.connection.current_database
      end

      #   Drop the database
      #
      #   @param {String} database Database name
      #
      def drop(database)
        super(database)
      rescue ActiveRecord::JDBCError
        raise DatabaseNotFound, "The database #{environmentify(database)} cannot be found"
      end

      #   Connect to db, do your biz, switch back to previous db
      #
      #   @param {String?} database Database or schema to connect to
      #
      def process(database = nil)
        current_db = @current_database
        switch(database)
        yield if block_given?

      ensure
        switch(current_db) rescue reset
      end

    protected

      #   Create the database
      #
      #   @param {String} database Database name
      #
      def create_database(database)
        super(database)

      rescue ActiveRecord::JDBCError
        raise DatabaseExists, "The database #{environmentify(database)} already exists."
      end

      #   Connect to new database
      #
      #   @param {String} database Database name
      #
      def connect_to_new(database)
        super(database)

      rescue ActiveRecord::JDBCError
        raise DatabaseNotFound, "The database #{environmentify(database)} cannot be found."
      end

      #   Return a new config that is multi-tenanted
      #
      def multi_tenantify(database)
        @config.clone.tap do |config|
          config[:url] = "#{config[:url].gsub(/(\S+)\/.+$/, '\1')}/#{environmentify(database)}"
        end
      end

    end
  end
end
