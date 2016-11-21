require 'spec_helper'

describe Jenkins::Peace::WarFile do

  def build_war_file(version)
    Jenkins::Peace.build_war_file(version)
  end


  def base_dir
    File.join(WAR_FILES_CACHE, '1.630')
  end


  def lib_dir
    File.join(WAR_UNPACKED_CACHE, '1.630')
  end


  def location
    File.join(WAR_FILES_CACHE, '1.630', 'jenkins.war')
  end


  def classpath
    File.join(WAR_UNPACKED_CACHE, '1.630', 'WEB-INF/lib/jenkins-core-1.630.jar')
  end


  def url
    'http://mirrors.jenkins-ci.org/war/1.630/jenkins.war'
  end


  let(:war_file) { build_war_file('1.630') }

  it { expect(war_file.base_dir).to eq base_dir }
  it { expect(war_file.lib_dir).to eq lib_dir }
  it { expect(war_file.location).to eq location }
  it { expect(war_file.classpath).to eq classpath }
  it { expect(war_file.url).to eq url }
  it { expect(war_file.file_name).to eq 'jenkins.war' }


  describe '#latest_version?' do
    it 'should return true if version is latest' do
      war_file = build_war_file('latest')
      expect(war_file.latest_version?).to be true
    end
  end


  describe '#real_version' do
    context 'when version is numeric' do
      it 'should return the real version' do
        war_file = build_war_file('1.630')
        expect(war_file.real_version).to eq '1.630'
      end
    end

    context 'when version is latest' do
      it 'should return the real version' do
        war_file = build_war_file('latest')
        expect(war_file).to receive(:find_core_librairy).and_return('jenkins-core-1.631.jar')
        expect(war_file.real_version).to eq '1.631'

        expect(war_file).to receive(:find_core_librairy).and_return('jenkins-core-2.33.jar')
        expect(war_file.real_version).to eq '2.33'
      end
    end
  end


  describe '#install!' do
    it 'should install war file' do
      expect(war_file).to receive(:download!)
      expect(war_file).to receive(:unpack!)
      war_file.install!
    end
  end


  describe '#download!' do
    it 'should download war file' do
      expect(FileUtils).to receive(:mkdir_p).with(base_dir)
      expect(war_file).to receive(:fetch_content).with(url, location)
      war_file.download!
    end
  end


  describe '#remove!' do
    it 'should remove war file' do
      expect(FileUtils).to receive(:rm_rf).with(base_dir)
      expect(FileUtils).to receive(:rm_rf).with(lib_dir)
      war_file.remove!
    end
  end


  describe '#unpack!' do
    it 'should unpack war file' do
      expect(FileUtils).to receive(:mkdir_p).with(lib_dir)
      expect(war_file).to receive(:execute_command).with("cd #{lib_dir} && jar xvf #{location}")
      war_file.unpack!
    end
  end


  describe '#exists?' do
    it 'should return true if war file exists' do
      expect(File).to receive(:exists?).with(location)
      war_file.exists?
    end
  end


  describe '#unpacked?' do
    it 'should return true if war file has been unpacked' do
      expect(File).to receive(:exists?).with(lib_dir).and_return(true)
      expect(File).to receive(:exists?).with(classpath)
      war_file.unpacked?
    end
  end


  describe '#installed?' do
    it 'should return true if war file has been installed' do
      expect(war_file).to receive(:exists?).and_return(true)
      expect(war_file).to receive(:unpacked?)
      war_file.installed?
    end
  end


  describe '#build_command_line' do
    it 'should return the command line to start the server' do
      expect(FileUtils).to receive(:mkdir_p)
      expect(war_file.build_command_line).to eq SERVER_COMMAND_LINE
    end
  end


  describe '#start!' do
    it 'should start the Jenkins server' do
      expect(FileUtils).to receive(:mkdir_p)
      expect(war_file).to receive(:exec).with(*SERVER_COMMAND_LINE)
      war_file.start!
    end

    context 'when kill option is passed' do
      it 'should send 0 on socket' do
        expect(TCPSocket).to receive(:open).with('localhost', 4000)
        war_file.start!(kill: true, control: 4000)
      end
    end
  end

end
