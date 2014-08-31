require 'active_record'

module ActsAsVatableAddress
  module Address
    def self.included(base)
      base.const_set :VATABLE_COUNTRIES, YAML.load_file(File.join(File.dirname(__FILE__),"../data/eu_countries.yml"))
      base.extend ClassMethods
    end

    def home_country?
      eu? && (vatable_country[:iso] == home_country_code)
    end

    def eu?
      vatable_country.present?
    end

    def third_country?
      !eu?      
    end

    def vatable?
      home_country_without_third_country_territory? 
    end

    def home_country_third_country_territory?
      home_country? && eu_third_country_territory?
    end

    def home_country_without_third_country_territory?
      home_country? && !eu_third_country_territory?
    end

    def eu_without_home_country?
      !home_country? && eu?
    end

    def eu_third_country_territory?
      if eu?
        country = vatable_country
        if country.has_key?('non_vat')
          country['non_vat'].find do |non_vat|
            postcode_value =~ Regexp.new(non_vat.to_s)
          end.present?
        else
          false
        end
      else
        false
      end
    end

    def eu_without_third_country_territory?
      eu? && !eu_third_country_territory?
    end

    module ClassMethods
      def acts_as_vatable_address(home_country_code, options = {})
        default_options = {
          postcode: :postcode,
          country: :country,
          country_from: :name
        }

        options = default_options.merge(options)

        if options[:country_from] == :name
          country_finder = %(
            def vatable_country
              country = country_value
              result = VATABLE_COUNTRIES.find do |code, data|
                data['names'].values.find do |name|
                  name.to_s.upcase == country
                end
              end

              result ? result.last.merge({iso: result.first}) : nil
            end
          )
        elsif options[:country_from] == :iso
          country_finder = %(
            def vatable_country
              result = VATABLE_COUNTRIES[country_value]
              result ? result.merge({iso: country_value }) : nil
            end
          )
        else
          raise 'ActsAsVatableAddress: Invalid country_from value'
        end

        class_eval <<-EOV
          def home_country_code
            "#{home_country_code.to_s.upcase}"
          end

          def postcode_value
            #{options[:postcode]}.to_s
          end

          def country_value
            #{options[:country]}.to_s.upcase
          end

          private
          #{country_finder}
        EOV
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActsAsVatableAddress::Address)