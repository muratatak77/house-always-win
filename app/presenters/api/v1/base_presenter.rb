module Api
  module V1
    class BasePresenter
      def initialize(object)
        @object = object
      end
      
      def as_json
        raise NotImplementedError, "Subclasses must implement as_json"
      end
      
      private
      
      attr_reader :object
    end
  end
end