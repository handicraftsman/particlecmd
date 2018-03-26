class ParticleCMD::Info
  attr_accessor :positionals, :flags, :options
  
  def initialize(argv)
    @positionals = []
    @flags       = []
    @options     = {}
    argv.each do |word|
      if word[0] == '-'
        i = word.match(/-+(.+?)(=(.+))?$/)
        if i[3]
          @options[i[1]] = i[3]
        else
          @flags << i[1]
        end
      else
        @positionals << word
      end
    end
  end
end