$stdout.sync = true

require 'guard'
require 'guard/guard'

module Guard
  class Assets < Guard
    def start
      UI.info "Guard::Assets is running."
      run
    end

    def run_all
      run
    end

    def reload
      run
    end

    def run_on_change(paths)
      run
    end

    private

      def run
        system('rake assets:compile')
      end
  end
end


