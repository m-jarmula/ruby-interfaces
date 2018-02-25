module Contractable
  def self.prepended(base)
    class << base
      attr_reader :contracts

      define_method(:contract) do |contracts|
        @contracts = Array(contracts)
      end
    end
  end
end
