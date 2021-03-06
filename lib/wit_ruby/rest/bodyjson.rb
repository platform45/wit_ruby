## bodyjson.rb
## Wrapper for JSON data that will be sent over to API
## @todo better seraching for specific hash

module Wit
  module REST
    class BodyJson < OpenStruct

      ## Allows for reading for values instance variable
      attr_reader :values

      ## Mainly generates instance variable to store values.
      ##
      ## @param possible_hash [Hash] used for OpenStruct if necessary
      def initialize(possible_hash=nil)
        ## Initialize instance variable for values
        if( !possible_hash.nil? && possible_hash.has_key?("values") )
          @values = possible_hash["values"]
          ## Delete values from it and pass it to OpenStruct constructor
          new_hash = possible_hash.clone
          deleted_value = new_hash.delete("values")
          new_hash_to_os = new_hash
        else
          @values = Array.new
          new_hash_to_os = possible_hash
        end
        super(new_hash_to_os)
      end


      ## Used to add value for an entity
      ##
      ## @param value [String] a possible value
      ## @param args [Array] posible expressions for the given value
      ## @return [Wit::REST::BodyJson] the current BodyJson with new value.
      ## @todo include metadata
      def add_value(value, *args)
        ## Check to see if the value already exists
        @values.each do |value_hash|
          if value_hash["value"] == value
            raise ValueAlreadyExists.new("The current value being inserted, \"#{value}\", already exists.")
          end
        end
        ## Adds it if it isn't there with the given expressions
        @values << {"value" => value,
                    "expressions" => args
                   }
        return self
      end

      ## Used to add an expression given a value.
      ##
      ## @param value [String] value that will have a new expression
      ## @param args [Array] new expressions for the value
      ## @return [Wit::REST::BodyJson] returns self with added expression to value
      def add_expression(value, *args)
        ## Look for it, and insert new expressions if found.
        ## If not found, raise error
        @values.each do |value_hash|
          if value_hash["value"] == value ## Found it and insert.
            ## Set union for arrays, removes duplicates
            value_hash["expressions"] = value_hash["expressions"] | args
          else ## Not found and raise error
            raise NotFound.new("The value, \"#{value}\", cannot be found.")
          end
        end

        return self
      end

      ## Overide values to instead go into OpenStruct to work directly on the instance.
      ##
      ## @param newValues [Array] new values as an array.
      def values=(newValues)
        @values = newValues
      end


      ## Used to convert the current hash to JSON
      ##
      ## @return [String] JSON string of the hash
      def json
        ## Use the current to_h method and MultiJson convert it
        MultiJson.dump(self.to_h)

      end

      ## Used to overide current to_h method for OpenStruct. Returns a hash
      ## with string equivalent for symbols and adds the current instance variable
      ## @values to it.
      ##
      ## @return [Hash] converted hash of the given BodyJson
      def to_h
        ## Use to_h on OpenStruct to get the current hash in the OpenStruct inheritance
        ## Depending on version of ruby, to_h might not be supported, so instead use table method
        ## to get the table instance variable
        current_os_hash = self.table
        ## Convert symbols to strings
        converted_hash = current_os_hash.reduce({}) do |memo, (k, v)|
          memo.merge({ k.to_s => v})
        end

        ## Merge values instance to this converted hash.
        converted_hash["values"] = self.values

        ## Return it.
        return converted_hash
      end

      ## Used to properly convert the value in instance to JSON specifically for value calls.
      ##
      ## @return [String] JSON string of the one hash value.
      def one_value_to_json
        ## Array of one hash, and convert it to JSON
        MultiJson.dump(@values[0])
      end

      ## Used to properly convert the first expression of the given value to JSON.
      ##
      ## @return [String] JSON string of the expression.
      def one_expression_to_json(value_add)
        @values.each do |value|
          if value["value"] == value_add
            ## Generate new hash with the given first expression and dump it.
            expression_hash = {"expression" => value["expressions"][0]}
            return MultiJson.dump(expression_hash)
          end
        end
      end


    end

    class ValueAlreadyExists < Exception; end
    class NotFound < Exception; end
  end
end
