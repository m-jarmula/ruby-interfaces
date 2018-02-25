module Interfaceable
  def self.prepended(base)
    class << base
      attr_reader :contracts, :interfaces

      define_method(:implements) do |interfaces|
        interfaces = Array(interfaces)
        @interfaces = interfaces
        @contracts = interfaces.flat_map(&:contracts).uniq
      end
    end
  end

  def initialize(*args)
    super
    check_contracts
  end

  def implements?(interface)
    interfaces.include?(interface)
  end

  private

  def check_contracts
    return unless contracts
    contracts.each(&method(:check_contract))
  end

  def contracts
    @contracts ||= self.class.contracts
  end

  def check_contract(contract)
    return if respond_to?(contract)
    raise NotImplementedError, error_message(contract)
  end

  def interfaces
    @interfaces ||= self.class.interfaces
  end

  def error_message(contract)
    "Class needs to implement method #{contract}"
  end
end
