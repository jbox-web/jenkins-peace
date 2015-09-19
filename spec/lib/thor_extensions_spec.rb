require 'spec_helper'

describe Jenkins::Peace::ThorExtensions do

  VALID_LIST = [[
    "\e[32m1.629\e[0m",
    File.join(ENV['HOME'], '.jenkins', 'war-files', '1.629', 'jenkins.war'),
    File.join(ENV['HOME'], '.jenkins', 'wars', '1.629', 'WEB-INF', 'lib', 'jenkins-core-1.629.jar'),
    "\e[31mfalse\e[0m"
  ]]


  def build_klass
    klass = Class.new(Thor)
    klass.send(:include, Jenkins::Peace::ThorExtensions)
    klass.new([])
  end

  let(:helper) { build_klass }


  describe '.green' do
    it { expect(helper.green('foo')).to eq "\e[32mfoo\e[0m" }
  end


  describe '.red' do
    it { expect(helper.red('bar')).to eq "\e[31mbar\e[0m" }
  end


  describe '.bold' do
    it { expect(helper.bold('boo')).to eq "\e[1mboo\e[0m" }
  end


  describe '.formated_headers' do
    it { expect(helper.formated_headers).to eq ["\e[1mVersion\e[0m", "\e[1mLocation\e[0m", "\e[1mClasspath\e[0m", "\e[1mInstalled\e[0m"] }
  end


  describe '.download_it_first!' do
    it 'should display help message' do
      expect(helper).to receive(:say).with("War file doesn't exist, you should install it first with : jenkins.peace install <version>", :yellow)
      expect(helper).to receive(:say).with('Exiting !', :yellow)
      helper.download_it_first!
    end
  end


  describe '.yes_no_question' do
    describe 'should ask question to user' do
      context 'when answer is yes' do
        it 'should continue' do
          expect(helper).to receive(:yes?).with('ok?', :bold).and_return(true)
          expect(helper).to receive(:say).with('Done !', :green)
          helper.yes_no_question('ok?')
        end
      end

      context 'when answer is no' do
        it 'should stop' do
          expect(helper).to receive(:yes?).with('ok?', :bold).and_return(false)
          expect(helper).to receive(:say).with('Canceled !', :yellow)
          helper.yes_no_question('ok?')
        end
      end
    end
  end


  describe '.formated_war_files_list' do
    context 'when no wars file are installed' do
      it 'should return an empty array' do
        expect_any_instance_of(Jenkins::Peace).to receive(:all_war_files).and_return([])
        expect(helper.formated_war_files_list).to eq []
      end
    end

    context 'when wars file are installed' do
      it 'should return a formated war files list (an array of array)' do
        expect(Jenkins::Peace).to receive(:list).and_return([Jenkins::Peace.build_war_file('1.629')])
        expect(helper.formated_war_files_list).to eq VALID_LIST
      end
    end
  end

end
