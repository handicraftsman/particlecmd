class ParticleCMD::Result
  attr_accessor :extra, :positionals, :flags, :options
  
  def initialize
    @extra       = []
    @positionals = {}
    @flags       = {}
    @options     = {}
  end
end