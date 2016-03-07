require 'terminal-table'

module Analyzable

  # Return average price of a
  # list of product
  #
  # Params:
  #  +products+:: an array of product
  def average_price(products=[])
    total = 0
    products.each {|product| total += product.price.to_f}
    (total / products.size).round(2)
  end

  # Return a report (format == string)
  #
  # Params:
  #  +products+:: an array of products
  def print_report(products=[])
    rows  = []
    products.each do |product|
      rows << [product.id, product.brand, product.name, product.price]
    end
    table = Terminal::Table.new :headings => ['id', 'brand', 'name', 'price'], :rows => rows
    table.to_s
  end

  # Return a hash, where key == brand
  # and value == number of product
  #
  # Params:
  #  +products+:: an array of products
  def count_by_brand(products=[])
    brands    = products.map(&:brand)
    by_brands = Hash.new(0)
    brands.each { |brand| by_brands[brand] += 1 }
    by_brands
  end

  # Return a hash, where key == name
  # and value == number of product
  #
  # Params:
  #  +products+:: an array of products
  def count_by_name(products=[])
    names = products.map(&:name)
    by_names = Hash.new(0)
    names.each { |name| by_names[name] += 1 }
    by_names
  end

end
