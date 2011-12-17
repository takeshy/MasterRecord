require 'yaml'
module MasterRecord
  class YAML
    include Enumerable
    def each
      @datum.each do|k,v|
        yield ([k] + @fields.map{|name,t| v[name.to_s]}).flatten
      end
    end

    def self.load_file(fields,file)
      datum = ::YAML.load_file(file)
      new(fields,datum)
    end

    def initialize(fields,datum)
      @fields = fields
      @datum = datum
    end
  end
end
