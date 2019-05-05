class AddSubcategoryIdInProduct < ActiveRecord::Migration[5.2]
  def change
  	add_column :products, :subcategory_id, :integer
  	#有一種寫法是:integer後面直接放index: true
  	#但不支援SQLite3，所以這裡index要另外add_index處理
  	add_index :products, :subcategory_id 
  	#前一個migration是直接用belongs_to，migrate時就會產生相對應的***_id
  	#但因為products這個table已經存在了，所以用add_column的方式加入
  end
end
