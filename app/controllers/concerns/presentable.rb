module Presentable
  extend ActiveSupport::Concern
  
  # Class methods
  class_methods do
    def presenter_class
      "#{self.name.deconstantize}::#{self.name.demodulize.sub('Controller', 'Presenter')}".constantize
    rescue NameError
      Api::V1::BasePresenter
    end
  end
  
  # Instance method
  def present(object)
    self.class.presenter_class.new(object).as_json
  end
end