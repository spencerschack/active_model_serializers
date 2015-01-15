module ActiveModel
  class Serializer
    module Preloading

      private

      # Attempts to automatically reduce the number of N+1 queries by
      # detecting which associations will be needed.
      def preload_associations!
        # The only way we can preload associations is if object is a
        # ActiveRecord::Relation and has not been loaded.
        if object.respond_to?(:loaded?) && !object.loaded?
          serializer = options[:each_serializer] ||
            options[:serializer] ||
            object.klass.active_model_serializer
          if serializer
            includes_options = serializer.includes_for(object.klass)
            @object = object.includes(includes_options)
          end
        end
      end

    end
  end
end