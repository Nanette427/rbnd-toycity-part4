class Module
  def create_finder_methods(*attributes)
    key   = attributes[0]
    value = attributes[1]
    Product.all.each do |product|
      next if product.send(key) != value
      return product
    end
  end
end
