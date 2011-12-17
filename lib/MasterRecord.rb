# coding: utf-8
require 'master_record/factory'
require 'master_record/csv'
require 'master_record/tsv'
require 'master_record/yaml'
module MasterRecord
  def self.included(c)
    fields = c.const_get("#{c}Fields")
    c.instance_variable_set("@fields",fields)
    def c.fields
      @fields
    end

    def c.create_master_record(datum)
      Factory.build(self.to_s,datum,@fields)
    end

    def c.load_data(datum)
      Object.send(:remove_const,"#{self}Data") if Object.const_defined?("#{self}Data")
      eval(create_master_record(datum))
      self.reload
    end

    def c.reload
      klass = Object.const_get("#{self}Data")
      master_records = klass.const_get("#{self}Records")
      self.instance_variable_set("@master_records",master_records)
    end

    data_exist =  Class.const_defined?("#{c}Data".to_sym)

    if data_exist
      klass = Object.const_get("#{c}Data")
      master_records = klass.const_get("#{c}Records")
      c.instance_variable_set("@master_records",master_records)
    end

    fields.keys.each do |f|
      define_method(f) { @info.send(:fetch, f) }
      c.define_singleton_method("find_by_#{f}".to_sym)do|target| 
        @master_records.select{|k,v| v[f] == target}.map{|k,v|c.new(k)}
      end
      c.define_singleton_method("find_one_by_#{f}".to_sym)do|target| 
        @master_records.detect{|k,v| break c.new(k) if v[f] == target}
      end
    end


    def initialize(id)
      @id = id.to_s
      @identity = "#{self.class.name}@#{id}"
      rec = self.class.instance_variable_get("@master_records")
      @info = rec[@id]
    end

    attr_reader :identity, :id

    def c.all
      @master_records.keys.map do |id|
        self.new(id)
      end
    end

    def c.find(identity=nil)
      return all unless identity
      identity = identity.to_s
      if identity.include?("@")
        id = identity.split("@")[-1]
      else
        id = identity
      end
      if @master_records[id]
        new(id)
      else
        nil
      end
    end
  end
end
