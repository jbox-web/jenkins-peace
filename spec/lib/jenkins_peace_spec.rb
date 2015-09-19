require 'spec_helper'

describe Jenkins::Peace do

  def helper
    Jenkins::Peace
  end

  JENKINS_WAR_URL    = 'http://mirrors.jenkins-ci.org/war/'
  BASE_PATH          = File.join(ENV['HOME'], '.jenkins')
  WAR_FILES_CACHE    = File.join(ENV['HOME'], '.jenkins', 'war-files')
  WAR_UNPACKED_CACHE = File.join(ENV['HOME'], '.jenkins', 'wars')
  SERVER_PATH        = File.join(ENV['HOME'], '.jenkins', 'server')


  def infos
    {
      base_path:          BASE_PATH,
      war_files_cache:    WAR_FILES_CACHE,
      war_unpacked_cache: WAR_UNPACKED_CACHE,
      server_path:        SERVER_PATH,
      jenkins_war_url:    JENKINS_WAR_URL
    }
  end


  describe '.jenkins_war_url' do
    it { expect(helper.jenkins_war_url).to eq JENKINS_WAR_URL }
  end


  describe '.base_path' do
    it { expect(helper.base_path).to eq BASE_PATH }
  end


  describe '.war_files_cache' do
    it { expect(helper.war_files_cache).to eq WAR_FILES_CACHE }
  end


  describe '.war_unpacked_cache' do
    it { expect(helper.war_unpacked_cache).to eq WAR_UNPACKED_CACHE }
  end


  describe '.server_path' do
    it { expect(helper.server_path).to eq SERVER_PATH }
  end


  describe '.infos' do
    it { expect(helper.infos).to eq infos }
  end


  def stub_with_return(method, value)
    expect_any_instance_of(Jenkins::Peace).to receive(method).at_least(:once).and_return(value)
  end


  describe '.list' do
    context 'when no war file is installed' do
      it 'should return empty array' do
        stub_with_return(:all_war_files, [])
        expect(helper.list).to eq []
      end
    end

    context 'when war files are installed' do
      it 'should return a list of war files' do
        stub_with_return(:all_war_files, ['1.629', '1.628', '1.630'])
        allow_any_instance_of(Jenkins::Peace::WarFile).to receive(:installed?).and_return(true)
        expect(helper.list.first).to be_instance_of(Jenkins::Peace::WarFile)
        expect(helper.list.first.version).to eq '1.630'
      end
    end
  end


  describe '.latest_war_file' do
    context 'when no war file is installed' do
      it 'should return nil' do
        stub_with_return(:all_war_files, [])
        expect(helper.latest_war_file).to be nil
      end
    end

    context 'when war files are installed' do
      it 'should return the last war file installed' do
        stub_with_return(:all_war_files, ['1.629', '1.628'])
        allow_any_instance_of(Jenkins::Peace::WarFile).to receive(:installed?).and_return(true)
        expect(helper.latest_war_file).to be_instance_of(Jenkins::Peace::WarFile)
        expect(helper.latest_war_file.version).to eq '1.629'
      end
    end
  end


  describe '.latest_version' do
    context 'when no war file is installed' do
      it 'should return nil' do
        stub_with_return(:all_war_files, [])
        expect(helper.latest_version).to be nil
      end
    end

    context 'when war files are installed' do
      it 'should return the classpath of the last war file installed' do
        stub_with_return(:all_war_files, ['1.629', '1.628'])
        allow_any_instance_of(Jenkins::Peace::WarFile).to receive(:installed?).and_return(true)
        expect(helper.latest_version).to eq File.join(ENV['HOME'], '.jenkins/wars/1.629/WEB-INF/lib/jenkins-core-1.629.jar')
      end
    end
  end


  describe '.clean!' do
    it 'should remove all war files' do
      stub_with_return(:all_war_files, ['1.629', '1.628'])
      allow_any_instance_of(Jenkins::Peace::WarFile).to receive(:remove!)
      helper.clean!
    end
  end


  describe '.download' do
    it 'shoud download a war file' do
      expect_any_instance_of(Jenkins::Peace::WarFile).to receive(:download!)
      expect(helper.download('1.628')).to be_instance_of(Jenkins::Peace::WarFile)
    end
  end


  describe '.install' do
    it 'shoud install a war file' do
      expect_any_instance_of(Jenkins::Peace::WarFile).to receive(:install!)
      expect(helper.install('1.628')).to be_instance_of(Jenkins::Peace::WarFile)
    end
  end


  describe '.unpack' do
    it 'shoud unpack a war file' do
      expect_any_instance_of(Jenkins::Peace::WarFile).to receive(:unpack!)
      expect(helper.unpack('1.628')).to be_instance_of(Jenkins::Peace::WarFile)
    end
  end


  describe '.remove' do
    it 'shoud remove a war file' do
      expect_any_instance_of(Jenkins::Peace::WarFile).to receive(:exists?).and_return(true)
      expect_any_instance_of(Jenkins::Peace::WarFile).to receive(:remove!)
      expect(helper.remove('1.628')).to be_instance_of(Jenkins::Peace::WarFile)
    end
  end

end
