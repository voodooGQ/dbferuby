# frozen_string_literal: true

class SpecHelperFunctions
  def self.suppress_output(override: false)
    original_stdout, original_stderr = $stdout.clone, $stderr.clone
    unless override
      $stderr.reopen File.new("/dev/null", "w")
      $stdout.reopen File.new("/dev/null", "w")
    end
    yield
  ensure
    $stdout.reopen original_stdout
    $stderr.reopen original_stderr
  end
end
