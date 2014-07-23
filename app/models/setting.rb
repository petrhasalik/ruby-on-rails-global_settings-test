class Setting < ActiveRecord::Base
  ## Validations
  validates_presence_of :name, :value
  validates_uniqueness_of :name

  ## Callbacks
  before_save :name_to_underscore
  after_save :flush_old_cache

  class << self
    def find_or_set(name, default_value = nil)
      name = name.to_s.underscore
      Rails.cache.fetch(["settings", name]) { 
        value = get(name)
        value = set(name, default_value) unless value
      
        convert_to_right_class(value) 
      }
    end

    def set(name, value)
      return nil if value.blank?
      setting = where(name: name).first_or_initialize
      setting.value = value
      setting.save
      setting.value
    end

    def get(name)
      where(name: name).first.try(:value)
    end

    def convert_to_right_class(value)
      if /^[-]?[\d]+([\.,][\d]+){0,1}$/ === value
        if /[\.,]/ === value
          return Float(value.gsub(",","."))
        else
          return Integer(value)
        end
      else
        return nil if value.nil?
        return true if value.downcase == "true"
        return false if value.downcase == "false"
        return value
      end
    end
  end

  def name_to_underscore
    self.name = name.to_s.gsub(" ", "_").underscore
  end

  def flush_old_cache
    Rails.cache.delete(["settings", name])
  end
end
