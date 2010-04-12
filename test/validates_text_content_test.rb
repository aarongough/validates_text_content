require File.dirname(__FILE__) + '/test_helper.rb'

class ValidatesTextContentTest < Test::Unit::TestCase 
  load_schema 
  
  class Book < ActiveRecord::Base
    validates_text_content :content
  end  
  
  class Article < ActiveRecord::Base
    validates_text_content :content
  end  
  
  def setup
    @sample_book = @sample_article = { :title => "This is a test title", :content => "This is just some simple test content, isn't it nice!" }
  end
  
  def test_schema_has_loaded_correctly 
    assert Book.new(@sample_book).save
    assert Article.new(@sample_article).save
  end
  
  def test_items_with_junk_text_should_be_rejected
    junk_text = []
    junk_text << @sample_book.merge({ :content => 'this comment has absolutely no capitalization.' })
    junk_text << @sample_book.merge({ :content => 'This comment has no type of punctuation' })
    junk_text << @sample_book.merge({ :content => "Fdkjd dk dkkjhd kjdhkjd kjdhdhdl alkasla lka alk." })
    junk_text << @sample_book.merge({ :content => "THIS COMMENT IS ALL IN UPPERCASE. ME NO WANT." })
    junk_text << @sample_book.merge({ :content => "Thiscommenthasabsolutelynospacesthereisnowaythisisgood." })
    junk_text << @sample_book.merge({ :content => "THIS COMMENT is MORE THAN 80% CAPITALS." })
    junk_text << @sample_book.merge({ :content => "THIS pERSON hAS tHEIR cAPS-lOCK oN." })
    junk_text.each do |junk_text_item|
      @expected_book_count = Book.count
      assert_equal false, Book.new( junk_text_item ).save, "Text rejection failed on: #{junk_text_item.to_a.join(" : ")}"
      assert_equal @expected_book_count, Book.count
    end
  end
  
  def test_comments_with_good_content_should_be_created
    good_text = []
    good_text << @sample_book.merge({ :content => 'This is a very simple test comment.' })
    good_text << @sample_book.merge({ :content => 'Supercalifragilisticexpialadocious: a super long word!' })
    good_text << @sample_book.merge({ :content => 'How many words can I think of that don\'t contain an "e"?' })
    good_text << @sample_book.merge({ :content => 'WHAT?! You mean to tell *ME* that SONY/ERICSSON *CAN\'T* make a phone?' })
    good_text << @sample_book.merge({ :content => 'WHAT?! YOU MEAN TO TELL ME that SONY/ERICSSON *CAN\'T* make a phone?' })
    good_text << @sample_book.merge({ :content => 'ROFL! Who do I have to shag to get a comment around here?' })
    good_text << @sample_book.merge({ :content => 'I\'m a Klingon. It\'s kind of my thing to be angry for almost no good reason. Yesterday I tore the door off my fridge cause I was out of margarine. These things happen.' })
    good_text.each do |good_text_item|
      @expected_book_count = Book.count + 1
      assert Book.new( good_text_item ).save, "Text creation failed on: #{good_text_item.to_a.join(" : ")}"
      assert_equal @expected_book_count, Book.count
    end
  end
  
end
