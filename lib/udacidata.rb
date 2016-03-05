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

  def self.all
    products = []
    CSV.foreach(@@CSV_FILE, {:headers=>:first_row}) do |row|
      (brand, name, price) = row
      products << self.new(brand: brand, name: name, price: price)
    end
    products
  end

  def self.first(n=0)
  end

  def last(n=0)
  end

  def destroy
  end

  def update
  end

  def find
  end

  def find_by
  end

  def where
  end
end
