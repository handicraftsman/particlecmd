class ParticleCMD::Definition
  attr_accessor :name
  
  def initialize(name)
    @name        = name
    @positionals = []
    @flags       = []
    @options     = []
    @collecting  = false
    yield self
  end

  def self.from_string(name, string)
    d = new name do end
    string.split.each do |word|
      if word[0] == '-'
        i = word.match(/-+(.+?)(=(.+))?$/)
        if i[3]
          d.option i[1], argname: i[3]
        else
          d.flag i[1]
        end
      else
        d.positional word
      end
    end
    d
  end

  def description(type, name, desc)
    case type
      when :positional
        @positionals
      when :flag
        @flags
      when :option
        @options
      else
        raise RuntimeError.new "Invalid argument type: #{type}"
    end.find { |i| i[:name] == name }[:description] = desc
  end

  def collect_extra
    @collecting = true
  end

  def positional(name, **_opts)
    opts = {
      name: name,
      description: ''
    }.merge _opts
    @positionals << opts
  end

  def flag(name, **_opts)
    opts = {
      name: name,
      description: ''
    }.merge _opts
    @flags << opts
  end

  def option(name, **_opts)
    opts = {
      name: name,
      description: '',
      argname: 'VALUE',
      default: nil
    }.merge _opts
    @options << opts
  end

  def command_signature(include_name = true)
    s = ''
    s << "#{@name} " if include_name
    @positionals.each do |p|
      s << "#{p[:name]} "
    end
    @flags.each do |f|
      s << "[--#{f[:name]}] "
    end
    @options.each do |o|
      s << "[--#{o[:name]}=#{o[:argname]}] "
    end
    s
  end

  def command_description
    s = ''

    nm = [
      (@positionals.map { |p| p[:name].length }.max or 0),
      (@flags.map { |f| f[:name].length + 2 }.max or 0),
      (@options.map { |o| o[:name].length + o[:argname].length + 3 }.max or 0)
    ].max

    @positionals.each do |p|
      s << (sprintf "    %*s  %s\n", nm, p[:name], p[:description])
    end
    @flags.each do |f|
      s << (sprintf "    %*s  %s\n", nm, "--#{f[:name]}", f[:description])
    end
    @options.each do |o|
      s << (sprintf "    %*s=%s  %s", nm-2, "--#{o[:name]}", o[:argname], o[:description])
    end
    s
  end

  def help_message
    'Usage: ' + command_signature + "\nArguments:\n" + command_description
  end

  def match(info)
    if @collecting
      return nil if @positionals.length > info.positionals.length
    else
      return nil if @positionals.length != info.positionals.length
    end
    return nil if @flags.length < info.flags.length
    return nil if @options.length < info.options.length
    return nil unless (info.flags - @flags.map { |f| f[:name] }).empty?
    return nil unless (info.options.keys - @options.map { |o| o[:name] }).empty?
    
    res = ParticleCMD::Result.new

    for i in 0..(@positionals.length - 1) do
      res.positionals[@positionals[i][:name]] = info.positionals[i]
    end

    for i in 0..(@flags.length - 1) do
      n = @flags[i][:name]
      res.flags[n] = if info.flags.include? n
        true
      else
        false
      end
    end

    for i in 0..(@options.length - 1) do
      n = @options[i][:name]
      res.options[n] = if info.options.include? n
        info.options[n]
      else
        nil
      end
    end

    if @collecting && @positionals.length < info.positionals.length
      res.extra = info.positionals[@positionals.length, info.positionals.length]
    end

    res
  end
end