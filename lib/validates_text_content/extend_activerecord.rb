module ActiveRecord
  module Validations
    module ClassMethods  
    
      def validates_text_content(*attr_names)
        config = { :message => " - Correct capitalization and punctuation are required. (ie: All sentences should begin with a capital letter and end with a punctuation mark, etc.)"}
        configuration.update(attr_names.last) if attr_names.last.is_a?(Hash)
        validates_each attr_names do |model, attr, value|
          if( value.nil? || value.length == 0 )
            error = true
          else
            error = false
            # The text should start with a capital letter
            error = true if( value.match(/[A-Z]/).nil? )
            
            # The text should contain at least one punctuation mark
            error = true if( value.match(/[\.?!]/).nil? )
            
            # There should be at least one 'e' per 30 characters
            error = true if( value.downcase.count('e') < (value.downcase.gsub(/[^a-z]*/, '').length / 30) )
            
            # There should be at least one space per 20 characters
            error = true if( value.downcase.count(' ') < (value.length / 20) )
            
            # The text should be at least 25% lowercase
            error = true if( value.gsub(/[^a-z]*/, '').length < (value.downcase.gsub(/[^a-z]*/, '').length / 4) )
          end
          
          model.errors.add( attr, config[:message] ) if( error )
        end
      end   
      
    end
  end  
end