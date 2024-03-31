

class Machine
  attr_reader :running


  def pushi(val)
    val = val.to_i
    raise "pushi only valid for numbers 0 - 63" if val < 0 && val > 63
    @stack = [val] + @stack[0..-2]
  end

  # addition
  def addit
    result = @stack[0] + @stack[1]
    if result > 0xff
      @flags[:c] = 1
    else
      @flags[:c] = 0
    end
    if result == 0
      @flags[:z] = 1
    else
      @flags[:z] = 0
    end
    result &= 0xff

    @stack = [result] + @stack[2..-1] + [0]
  end

  # subtraction
  def subtr
    result = @stack[0] - @stack[1]
    if result < 0
      @flags[:c] = 1
    else
      @flags[:c] = 0
    end
    if result == 0
      @flags[:z] = 1
    else
      @flags[:z] = 0
    end
    result &= 0xff

    @stack = [result] + @stack[2..-1] + [0]
  end

  def pop2v(val)
    val = val.to_i
    @vars[val] = @stack[0]
    @stack = @stack[1..-1] + [0]
  end

  def pushv(val)
    val = val.to_i
    raise "pushv only valid from 0 - 15" if val < 0 && val > 15
    @stack = [@vars[val]] + @stack[0..-2]
  end

  def mr2pc
    @pc = @mr
  end

  def pc2mr
    @mr = @pc
  end

  # pop stack and jump by an offset if zero flag is set
  # if zero flag not set does nothing
  # if popped value has high flag not set
  # jump will add pc by popped value + 1
  def pjmpz
    loc = @stack[0]
    @stack = @stack[1..-1] + [0]

    if @flags[:z] == 1
      if (loc & 0x80) != 0
        @pc -= (loc & 0x7f) - 1
      else
        @pc += loc + 1
      end

    end

  end

  def appnd(val)
    val = val.to_i
    raise "appnd only valid from 1 - 3" if val < 1 && val > 3
    @stack[0] = @stack[0] + (val << 6)
  end

  def halt!
    @running = false
  end

  def initialize(instrs, instr_start = 0x400)
    @flags = {
      z: 0,
      c: 0,
      e: 0
    }
    @vars =  16.times.map{|x| 0}
    @stack = 8.times.map{|x| 0}
    @mr = 0
    @rs = 4.times.map{|x| 0}
    @mem =  0x200.times.map{|x| 0}

    @instr_start = instr_start
    @pc = instr_start
    @instrs = instrs

    @running = true
  end

  def step
    instr = @instrs[@pc - @instr_start]
    @pc += 1
    send(*instr)
    p instr
  end

  def stack_inspect
    @stack.map{|x| x.to_s(16).rjust(2, '0')}.join(' ')
  end

  def var_inspect
    @vars.map{|x| x.to_s(16).rjust(2, '0')}.join(' ')
  end

  def flag_titles
    @flags.map{|k,v| "#{k}"}.join(' ')
  end

  def flag_inspect
    @flags.map{|k,v| "#{v}"}.join(' ')
  end

  def mem_titles
      "         " + 16.times.map{|x| "-#{x.to_s(16)}"}.join(' ')
  end

  def mem_inspect
    @mem[0..0xff].each_slice(16).each_with_index.map do |line, idx|
      "     #{idx.to_s(16).rjust(2, '0')}- " + line.map{|x| x.to_s(16).rjust(2, '0')}.join(' ')
    end.join("\n")
  end

  def pc_inspect
    @pc.to_s(16).rjust(8, '0')
  end

  def mr_inspect
    @mr.to_s(16).rjust(8, '0')
  end

  def rs_inspect
    @rs.map{|x| x.to_s(16).rjust(8, '0')}.join(' ')
  end

  def inspect
    <<~INSPECT
      <Machine #{flag_titles}
         flags #{flag_inspect}
            pc #{pc_inspect}
            mr #{mr_inspect}
            rs #{rs_inspect}
         stack #{stack_inspect}
          vars #{var_inspect}
      #{mem_titles}
      #{mem_inspect}
      >
    INSPECT
  end
end


contents = File.read("main.asm")

lines = contents.split("\n")



instrs = []

lines.each do |line|
  next unless line.start_with?('; ')

  if line.start_with?('; offset')
    current_pos = line[8..-1].to_i
    next
  end

  toks = line[2..-1].split(' ')

  instrs << [toks[0].to_sym] + toks[1..-1]
end

machine = Machine.new(instrs)

#p instrs

24.times do
  break unless machine.running
  machine.step
end

p machine
