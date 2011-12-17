module MasterRecord
  class TSV
    include Enumerable

    def each
      @datum.each do|data|
        yield data.chomp.split("\t")
      end
    end

    def self.load_file(file,headers=false)
      contents = File.readlines(file)
      if headers
        new(contents[1 .. -1])
      else
        new(contents)
      end
    end

    def initialize(datum)
      @datum = datum
    end
  end
end
