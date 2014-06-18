module Worldly
  class Country
    Data = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'data/countries.yml')) || {}

    attr_reader :data, :code

    def initialize(code)
      @code = code.to_s.upcase
      @data = Data[@code]
    end

    def name
      @data['name']
    end

    def alpha2
      @data['alpha2']
    end

    def alpha3
      @data['alpha3']
    end

    def country_code
      @data['country_code']
    end

    def dialing_prefix
      @data['dialing_prefix']
    end

    def format
      @data['format'] || "{{address1}}\n{{address2}}\n{{city}}\n{{country}}"
    end

    def fields
      @data['fields'] || {'city' => 'City'}
    end

    def has_field?(f)
      fields.key?(f.to_s)
    end

    def all_fields(exclude_country=false)
      af = {
        'address1' => 'Address 1',
        'address2' => 'Address 2'
      }.merge(fields)
      af['country'] = 'Country' unless exclude_country
      af
    end

    def regions?
      @regions_exist ||= File.exist?(region_file_path)
    end

    def regions
      @regions ||= (regions? ? YAML.load_file(region_file_path) : {})
    end

    class << self

      def new(code)
        if Data.keys.include?(code.to_s.upcase)
          super
        end
      end

      def all
        Data.map{ |country, data| [data['name'], country] }.sort
      end

      def [](code)
        self.new(code.to_s.upcase)
      end
    end

    private

    def region_file_path
      File.join(File.dirname(__FILE__), '..', "data/regions/#{@code}.yaml")
    end

  end
end