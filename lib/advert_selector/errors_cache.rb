module AdvertSelector
  class ErrorsCache
    def self.cache_key
      'advert_selector_errors'
    end

    def self.errors
      arr = Rails.cache.read(cache_key)
      arr.blank? ? [] : arr.first(10)
    end

    def self.add(str)
      Rails.cache.write(cache_key, errors.push(str))
    end

    def self.clear()
      Rails.cache.write(cache_key, [])
    end

  end
end
