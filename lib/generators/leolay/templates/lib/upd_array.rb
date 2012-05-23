class Array
  #Find in collection where :search condition is matched and return a fields if param :get is passed
  #otherwise it return the item
  #Example1 Articles.quickly :search => {:id => 1}, :get => :title
  #Example2 People.quickly :search => {:fiscal_code => ABCDFG01H02I100J}
  def item(options={})
    #:search     => {:id => 3}
    #:get        => :name
    options = {
      :search   => nil,
      :get      => nil
    }.merge(options)
    raise "Array.trova: specify required parameters!" unless options[:search]
    self.each do |item|
      condition = nil
      options[:search].each do |label, value|
        condition = (item[label] == value)
        break unless condition
      end
      next unless condition
      return (options[:get] ? item[options[:get]] : item)
    end
    nil
  end
end