module MasterRecord
  def self.string
    lambda{|val| "'#{val}'"}
  end

  def self.integer
    lambda{|val| val.to_s}
  end
  module Factory
    def self.build(prefix,datum,field_info)
      raise "must use ruby version 1.9.1" unless RUBY_VERSION >= '1.9.1'
      fields = field_info.keys.map{|k| ":" + k.to_s}
      module_info = "#{prefix}Records ={\n"
      data_set = []
      count = 0
      datum.each do |data|
        rec = "    '#{data[0]}' => {\n"
        i = 0
        rec += field_info.map{|k,v|i+=1;"      :#{k.to_s} => #{v.call(data[i])},"}.join("\n")
        rec += "\n    }"
        data_set.push(rec)
      end
      module_info += data_set.join(",\n") + "}"
      module_contents = <<EOF
# coding: utf-8
module ::#{prefix}Data
  #{module_info}
end
EOF
      module_contents
    end
  end
end
