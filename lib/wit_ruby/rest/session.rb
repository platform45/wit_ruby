## session.rb
## Handles all the neccesary methods to do certain API RESTful calls.
## Documentation from Wit for these methods - https://wit.ai/docs/api

module Wit
  module REST
    class Session
      ## Initialize with the given client.
      def initialize(client)
        @client = client
      end
      ## GET - extracted meaning form a sentence
      def send_message(message)
         return @client.get("/message?q=#{message}")
      end

      ## POST - extract meaning from a audio file
      ## Do check the certain documentation of what the specific audio file
      ## should be.
      def send_sound_message(sound)
      end

      ## GET - returns stored message for specific id.
      ## TODO - possibly renaming as it is ambigious compared to send_message.
      def get_message(message_id)

      end

      ## GET - returns either a list of intents if no id is given.
      ##     - returns the specific intent of the id given.
      def get_intent(intent_id = nil)
      end

      ## TODO - look into corpus

      ## GET - returns a list of available entities given this instance with the
      ##       given token if no id is given.
      ##     - returns the specific entity and its parameters with a given id.
      ## TODO - notify Wit.ai to fix their documentations as there is a wrong
      ##      - description.
      def entities(entity_id = nil)

      end

      ## POST - creates a new entity with the given attributes.
      def create_entity(new_entity)
      end

      ## PUT - updates a given entity with the specific entity id.
      def update_entity(entity_id)
      end

      ## DELETE - deletes the given entity with the entity id.
      def delete_entity(entity_id)
      end

      ## POST - adds the possible value into the list of values for the given
      ##      - entity with the id.
      def add_value(entity_id, new_value)

      end

      ## DELETE - deletes the value from the list of values in the entity with
      ##        - with the given value.
      def delete_value(entity_id, delete_value)

      end

      ## POST - adds a new expression to the value of the entity.
      def add_expression(entity_id, value, new_expression)

      end

      ## DELETE - deleetes the expression in the value of the entity.
      def delete_expression(entity_id, value, expression)

      end



    end
  end
end
