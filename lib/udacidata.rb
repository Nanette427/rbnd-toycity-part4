require_relative 'find_by'
require_relative 'errors'
require 'csv'
require 'pry'

class Udacidata

  @@CSV_FILE = File.dirname(__FILE__) + "/../data/data.csv"


  # Return the created product.
  # Create a new product and add the
  # corresponding entry in the CSV file
  #
  # Params:
  #  +options+:: a hash with product attribute
  #    +brand+:: the brand
  #    +name+:: the name
  #    +price+:: the price
  def self.create(options={})
    brand = options[:brand]
    name  = options[:name]
    price = options[:price]

    # Create the product
    product = self.new(brand: brand, name: name, price: price)
    # Save the product in the database
    CSV.open(@@CSV_FILE, "a+") do |csv|
      csv << [product.id, product.brand, product.name, product.price]
    end
    product
  end

  # Return all the products
  def self.all
    products = []
    CSV.foreach(@@CSV_FILE, {:headers=>:first_row}) do |row|
      (id, brand, name, price) = row["id"], row["brand"], row["product"], row["price"]
      products << self.new(id: id, brand: brand, name: name, price: price)
    end
    products
  end

  # Return the n first products.
  # Can be a single product or
  # an array of products
  #
  # Params:
  #  +n+:: the number of product
  def self.first(n=0)
    list = self.all[0..n-1]
    n == 0 ? list[0] : list
  end


  # Return the n first products.
  # Can be a single product or
  # an array of products
  #
  # Params:
  #  +n+:: the number of product
  def self.last(n=0)
    all   = self.all
    return all[-1] if n == 0
    index = all.size - n
    list  = all[index..-1]
  end

  # Return a specific product
  #
  # Params:
  #  +id+:: Id of the product
  def self.find(id)
     self.all.detect do |product|
        product.id == id
     end
  end

  # Return the destroyed product
  #
  # Params:
  #  +id+:: Id of the product
  def self.destroy(id)
    all             = self.all
    destroy_product = self.find(id)
    all.reject! { |product| product.id == destroy_product.id }
    CSV.open(@@CSV_FILE, "wb") do |csv|
      csv << ["id", "brand", "product", "price"]
        all.each do |product|
        csv << [product.id, product.brand, product.name, product.price]
      end
    end
    destroy_product
  end

  # Redefine method_missing to implement all
  # the find_by method.
  #
  # Params:
  #  +method_name+::the method_name
  #  +arguments+:: extra aurguments in
  #  case of `find_by` method, this will be the
  # value we search.
  def self.method_missing(method_name, *arguments)
    if method_name =~ /^find_by_(.*)$/
      key   = $1.to_sym
      value = arguments[0]
      self.all.each do |product|
        next if product.send(key) != value
        return product
      end
    else
      super
    end
  end

  # Return an Array of product
  # that respond to the selection
  #
  # Params:
  #  +options+:: hash of constraint
  def self.where(options={})
    selection = []
    should_respond_to_count = options.length

    self.all.each do |product|
      respond_to_count = 0
      # Consider that we can select on multiple field
      options.each do |key,value|
        respond_to_count += 1 if product.send(key) == value
      end
      selection << product if should_respond_to_count == respond_to_count
    end

    selection
  end

  # Update an entry in the database
  #
  # Params:
  #  +options+:: hash of field to update
  def update(options={})
    # Update the product
    options.each do |key,value|
      self.send("#{key}=", value) if self.respond_to?(key)
    end

    # Update the database
    all = Product.all
    CSV.open(@@CSV_FILE, "wb") do |csv|
      csv << ["id", "brand", "product", "price"]
        all.each do |product|
        product     = self if product.id == self.id
        csv << [product.id, product.brand, product.name, product.price]
      end
    end

    return self
  end

end
