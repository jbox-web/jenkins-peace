require 'spec_helper'

RSpec.describe Jenkins::Peace do

  def stub_all_war_files_with_return(value)
    expect_any_instance_of(Jenkins::Peace).to receive(:all_war_files).at_least(:once).and_return(value)
  end


  describe '.jenkins_war_url' do
    it { expect(described_class.jenkins_war_url).to eq JENKINS_WAR_URL }
  end


  describe '.base_path' do
    it { expect(described_class.base_path).to eq BASE_PATH }
  end


  describe '.war_files_cache' do
    it { expect(described_class.war_files_cache).to eq WAR_FILES_CACHE }
  end


  describe '.war_unpacked_cache' do
    it { expect(described_class.war_unpacked_cache).to eq WAR_UNPACKED_CACHE }
  end


  describe '.server_path' do
    it { expect(described_class.server_path).to eq SERVER_PATH }
  end


  describe '.infos' do
    it {
      expect(described_class.infos).to eq({
        base_path:          BASE_PATH,
        war_files_cache:    WAR_FILES_CACHE,
        war_unpacked_cache: WAR_UNPACKED_CACHE,
        server_path:        SERVER_PATH,
        jenkins_war_url:    JENKINS_WAR_URL
      })
    }
  end


  describe '.list' do
    context 'when no war file is installed' do
      it 'should return empty array' do
        stub_all_war_files_with_return([])
        expect(described_class.list).to eq []
      end
    end

    context 'when war files are installed' do
      it 'should return a list of war files' do
        stub_all_war_files_with_return(['1.629', '1.628', '1.630'])
        allow_any_instance_of(Jenkins::Peace::WarFile).to receive(:installed?).and_return(true)
        expect(described_class.list.first).to be_instance_of(Jenkins::Peace::WarFile)
        expect(described_class.list.first.version).to eq '1.630'
      end
    end
  end


  describe '.latest_war_file' do
    context 'when no war file is installed' do
      it 'should return nil' do
        stub_all_war_files_with_return([])
        expect(described_class.latest_war_file).to be nil
      end
    end

    context 'when war files are installed' do
      it 'should return the last war file installed' do
        stub_all_war_files_with_return(['1.629', '1.628'])
        allow_any_instance_of(Jenkins::Peace::WarFile).to receive(:installed?).and_return(true)
        expect(described_class.latest_war_file).to be_instance_of(Jenkins::Peace::WarFile)
        expect(described_class.latest_war_file.version).to eq '1.629'
      end
    end
  end


  describe '.latest_version' do
    context 'when no war file is installed' do
      it 'should return nil' do
        stub_all_war_files_with_return([])
        expect(described_class.latest_version).to be nil
      end
    end

    context 'when war files are installed' do
      it 'should return the classpath of the last war file installed' do
        stub_all_war_files_with_return(['1.629', '1.628'])
        allow_any_instance_of(Jenkins::Peace::WarFile).to receive(:installed?).and_return(true)
        expect(described_class.latest_version).to eq File.join(ENV['HOME'], '.jenkins/wars/1.629/WEB-INF/lib/jenkins-core-1.629.jar')
      end
    end
  end


  describe '.clean!' do
    it 'should remove all war files' do
      stub_all_war_files_with_return(['1.629', '1.628'])
      allow_any_instance_of(Jenkins::Peace::WarFile).to receive(:remove!)
      described_class.clean!
    end
  end


  describe '.download' do
    it 'should download a war file' do
      expect_any_instance_of(Jenkins::Peace::WarFile).to receive(:download!)
      expect(described_class.download('1.628')).to be_instance_of(Jenkins::Peace::WarFile)
    end
  end


  describe '.install' do
    it 'should install a war file' do
      expect_any_instance_of(Jenkins::Peace::WarFile).to receive(:install!)
      expect(described_class.install('1.628')).to be_instance_of(Jenkins::Peace::WarFile)
    end
  end


  describe '.unpack' do
    it 'should unpack a war file' do
      expect_any_instance_of(Jenkins::Peace::WarFile).to receive(:unpack!)
      expect(described_class.unpack('1.628')).to be_instance_of(Jenkins::Peace::WarFile)
    end
  end


  describe '.remove' do
    it 'should remove a war file' do
      expect_any_instance_of(Jenkins::Peace::WarFile).to receive(:exists?).and_return(true)
      expect_any_instance_of(Jenkins::Peace::WarFile).to receive(:remove!)
      expect(described_class.remove('1.628')).to be_instance_of(Jenkins::Peace::WarFile)
    end
  end


  describe '.all_war_files' do
    it 'should return a list of war files' do
      expect(FileUtils).to receive(:mkdir_p).with(WAR_FILES_CACHE)
      expect(Pathname).to receive(:new).with(WAR_FILES_CACHE).and_return(OpenStruct.new(children: []))
      described_class.all_war_files
    end
  end


  describe 'check_for_presence_and_execute' do
    context 'when file doesnt exist' do
      it 'should check for file existence before executing method' do
        war_file = described_class.build_war_file('1.628')
        expect_any_instance_of(Jenkins::Peace::WarFile).to receive(:exists?).and_return(false)
        expect_any_instance_of(Jenkins::Peace::WarFile).to receive(:download!)
        described_class.check_for_presence_and_execute(war_file, :download!)
      end
    end

    context 'when file exists' do
      context 'and overwrite is false' do
        it 'should do nothing' do
          war_file = described_class.build_war_file('1.628')
          expect_any_instance_of(Jenkins::Peace::WarFile).to receive(:exists?).at_least(:twice).and_return(true)
          expect_any_instance_of(Jenkins::Peace::WarFile).to_not receive(:download!)
          described_class.check_for_presence_and_execute(war_file, :download!, false)
        end
      end

      context 'and overwrite is true' do
        it 'should execute method' do
          war_file = described_class.build_war_file('1.628')
          expect_any_instance_of(Jenkins::Peace::WarFile).to receive(:exists?).at_least(:twice).and_return(true)
          expect_any_instance_of(Jenkins::Peace::WarFile).to receive(:download!)
          described_class.check_for_presence_and_execute(war_file, :download!, true)
        end
      end
    end
  end

end
