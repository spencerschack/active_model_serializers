module ActiveModel
  class Serializer
    module Caching
      def to_json(*args)
        cache_method('to-json') { super }
      end

      def serialize(*args)
        cache_method('serialize') { serialize_object }
      end

      def as_json(*args)
        cache_method('as-json') { super }
      end

      def serializable_hash(*args)
        cache_method('serializable-hash') { super }
      end

      private

      def cache_method key
        if caching_enabled?
          key = expand_cache_key([self.class.to_s.underscore, cache_key, key])
          cache.fetch key do
            yield
          end
        else
          yield
        end
      end

      def caching_enabled?
        perform_caching && cache && respond_to?(:cache_key)
      end

      def expand_cache_key(*args)
        ActiveSupport::Cache.expand_cache_key(args)
      end
    end
  end
end
