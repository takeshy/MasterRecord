require 'csv'
module MasterRecord
  class CSV
    include Enumerable

    def each
      @datum.each do|data|
        yield data
      end
    end

    def self.load_file(file,headers=false)
      contents = File.read(file)
      if headers
        new(contents.sub(/^[^\n]+\n/,''))
      else
        new(contents)
      end
    end

    def initialize(datum)
      @datum = ::CSV.parse(datum)
    end
  end
end
