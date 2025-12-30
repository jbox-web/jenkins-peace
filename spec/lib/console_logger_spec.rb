require 'spec_helper'

RSpec.describe Jenkins::Peace::ConsoleLogger do

  let(:logger) { Jenkins::Peace::ConsoleLogger.new([]) }

  describe '.info' do
    it 'should render colored message' do
      # allow_any_instance_of(Jenkins::Peace::ConsoleLogger).to receive(:logger).and_return([])
      expect(logger.info('foo')).to eq ["\e[32mfoo\e[0m\n"]
    end
  end


  describe '.warn' do
    it 'should render colored message' do
      # allow_any_instance_of(Jenkins::Peace::ConsoleLogger).to receive(:logger).and_return([])
      expect(logger.warn('bar')).to eq ["\e[33mbar\e[0m\n"]
    end
  end


  describe '.error' do
    it 'should render colored message' do
      # allow_any_instance_of(Jenkins::Peace::ConsoleLogger).to receive(:logger).and_return([])
      expect(logger.error('boo')).to eq ["\e[31mboo\e[0m\n"]
    end
  end

end
