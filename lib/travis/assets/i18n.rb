# TODO stolen from i18n_js. need to turn this crap into a rake-pipeline filter
#
require 'fileutils'
require 'i18n'
require 'json'

module Travis
  class Assets
    module I18n
      extend self

      def export
        ::I18n.load_path += Dir["#{Travis::Assets.root}/config/locales/**/*.yml"]

        translation_segments.each do |filename, translations|
          save(translations, filename)
        end
      end

      protected

        def export_dir
          "#{Travis::Assets.root}/assets/javascripts/i18n"
        end

        def segments_per_locale(pattern,scope)
          ::I18n.available_locales.each_with_object({}) do |locale, segments|
            result = scoped_translations("#{locale}.#{scope}")
            unless result.empty?
              segment_name = ::I18n.interpolate(pattern, :locale => locale)
              segments[segment_name] = result
            end
          end
        end

        def segment_for_scope(scope)
          if scope == "*"
            translations
          else
            scoped_translations(scope)
          end
        end

        def configured_segments
          config[:translations].each_with_object({}) do |options, segments|
            options.reverse_merge!(:only => "*")
            if options[:file] =~ ::I18n::INTERPOLATION_PATTERN
              segments.merge!(segments_per_locale(options[:file],options[:only]))
            else
              result = segment_for_scope(options[:only])
              segments[options[:file]] = result unless result.empty?
            end
          end
        end

        def translation_segments
          { "#{export_dir}/translations.js" => translations }
        end

        def save(translations, file)
          FileUtils.mkdir_p File.dirname(file)

          File.open(file, "w+") do |f|
            f << %(var I18n = I18n || {};\n)
            f << %(I18n.translations = );
            f << translations.to_json
            f << %(;)
          end
        end

        def scoped_translations(scopes) # :nodoc:
          result = {}

          [scopes].flatten.each do |scope|
            deep_merge! result, filter(translations, scope)
          end

          result
        end

        # Filter translations according to the specified scope.
        def filter(translations, scopes)
          scopes = scopes.split(".") if scopes.is_a?(String)
          scopes = scopes.clone
          scope = scopes.shift

          if scope == "*"
            results = {}
            translations.each do |scope, translations|
              tmp = scopes.empty? ? translations : filter(translations, scopes)
              results[scope.to_sym] = tmp unless tmp.nil?
            end
            return results
          elsif translations.has_key?(scope.to_sym)
            return {scope.to_sym => scopes.empty? ? translations[scope.to_sym] : filter(translations[scope.to_sym], scopes)}
          end
          nil
        end

        # Initialize and return translations
        def translations
          ::I18n.backend.instance_eval do
            init_translations unless initialized?
            translations
          end
        end

        # deep_merge by Stefan Rusterholz, see http://www.ruby-forum.com/topic/142809
        MERGER = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &MERGER) : v2 }

        def deep_merge(target, hash) # :nodoc:
          target.merge(hash, &MERGER)
        end

        def deep_merge!(target, hash) # :nodoc:
          target.merge!(hash, &MERGER)
        end
    end
  end
end

