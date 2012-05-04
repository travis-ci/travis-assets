module Support
  module Setup
    def self.included(base)
      class << base
        def setup(&block)
          let(:root) { Pathname.new('tmp/spec') }

          before :each do
            mkdirs %w(
              assets/images
              assets/javascripts
              assets/stylesheets
              public
            )
            copy_files %w(
              AssetFile
              Manifest
            )

            instance_eval &block if block
          end

          after :each do
            root.rmtree rescue nil
          end
        end
      end
    end

    def mkdirs(paths)
      paths.each { |path| root.join(path).mkpath }
    end

    def copy_files(files)
      files.each { |file| FileUtils.cp(file, root) }
    end

    def manifest(content)
      File.open('tmp/spec/Manifest', 'w+') { |f| f.write(content) }
    end

    def asset(path, mtime = nil)
      path = root.join('assets').join(path)
      mtime ||= Time.now

      FileUtils.mkdir_p(path.dirname)
      FileUtils.touch(path)
      File.utime(mtime, mtime, path)
    end

    def touch(path, mtime)
      path = root.join('assets').join(path)
      File.utime(mtime, mtime, path)
    end
  end
end
