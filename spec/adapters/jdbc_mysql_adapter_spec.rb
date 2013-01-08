require 'spec_helper'
require 'apartment/adapters/jdbc_mysql_adapter'

describe Apartment::Adapters::JDBCMysqlAdapter, jruby: true do

  let(:config) { Apartment::Test.config['connections']['mysql'] }
  subject { Apartment::Database.jdbc_mysql_adapter config.symbolize_keys }

  def database_names
    ActiveRecord::Base.connection.execute("SELECT schema_name FROM information_schema.schemata").collect { |row| row['schema_name'] }
  end

  let(:default_database) { subject.process { ActiveRecord::Base.connection.current_database } }

  it_should_behave_like "a generic apartment adapter"
  it_should_behave_like "a connection based apartment adapter"

end

