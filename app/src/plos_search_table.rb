class PlosSearchTable
  include Aws::Record
  set_table_name "plos-search-#{Myenv.stage}"
  string_attr :id, hash_key: true
  string_attr :title
  string_attr :abstract

  class << self
    def create!
      return unless Myenv.dev? || Myenv.test?
      table_config.migrate!
    end

    def delete!
      return unless Myenv.dev? || Myenv.test?
      Aws::Record::TableMigration.new(self).delete!
    end

    private

    def table_config
      @table_config ||= Aws::Record::TableConfig.define do |t|
        t.model_class PlosSearchTable
        t.billing_mode 'PAY_PER_REQUEST'
      end
    end
  end
end
