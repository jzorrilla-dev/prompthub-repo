[
  ["Desarrollo", "desarrollo"],
  ["Escritura", "escritura"],
  ["Diseño", "diseno"],
  ["Investigación", "investigacion"],
  ["Productividad", "productividad"],
  ["Marketing", "marketing"]
].each do |name, slug|
  Category.find_or_create_by!(slug: slug) { |category| category.name = name }
end
