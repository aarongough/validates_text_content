ActiveRecord::Schema.define(:version => 0) do
  create_table :books, :force => true do  |t| 
    t.string    :title
    t.text      :content 
  end  
  
  create_table :articles, :force => true do  |t| 
    t.string    :title  
    t.text      :content
  end
end 