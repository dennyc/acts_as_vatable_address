require 'active_record'

module ActsAsVatableAddress
  module Address
    def self.included(base)
      base.extend ClassMethods
    end

    def home_country?
      vatable_country && (vatable_country[:iso] == home_country_code)
    end

    def eu?
      vatable_country.present?
    end

    def eu_without_home_country?
      !home_country? && eu?
    end

    def third_country?
      if eu?
        country = vatable_country
        if country.has_key?('non_vat')
          country['non_vat'].find do |non_vat|
            postcode_value =~ Regexp.new(non_vat.to_s)
          end
        else
          false
        end
      else
        true
      end       
    end

    def vatable?
      !eu_without_home_country? 
    end

    module ClassMethods
      def acts_as_vatable_address(home_country_code, options = {})
        
        class_attribute :vatable_countries
        self.vatable_countries ||= YAML.load_file(File.join(File.dirname(__FILE__),"../data/eu_countries.yml"))
        
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
              result = self.class.vatable_countries.find do |code, data|
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
              result = self.class.vatable_countries[country_value]
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

          #{country_finder}
        EOV
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActsAsVatableAddress::Address)