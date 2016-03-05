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

  def destroy
  end

  def update
  end



  def find_by
  end

  def where
  end
end
