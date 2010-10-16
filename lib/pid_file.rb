class PidFile
  def initialize(filename)
    @filename = filename
  end

  def running?
    running = false
    if File.exist?(@filename)
      begin
        Process.getpgid(File.read(@filename).to_i)
        running = true
      rescue Errno::ESRCH
        File.delete(@filename)
      end
    end
    running
  end
end