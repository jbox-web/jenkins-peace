require 'spec_helper'

describe Jenkins::Peace::ContentDownloader do

  VALID_URL    = 'http://jenkins.mirror.isppower.de/war/1.658/jenkins.war'
  REDIRECT_URL = 'http://mirrors.jenkins-ci.org/war/latest/jenkins.war'
  INVALID_URL  = 'http://mirrors.jenkins-ci.org/war/120000/jenkins.war'


  def logger
    Jenkins::Peace::ConsoleLogger.new([])
  end


  def build_content_downloader
    Jenkins::Peace::ContentDownloader.new('/tmp/jenkins-test.war', logger)
  end

  let(:content_downloader) { build_content_downloader }


  describe '#start_http_session' do
    it 'should start a http session' do
      uri = URI(VALID_URL)
      expect(Net::HTTP).to receive(:start).with(uri.host, uri.port)
      content_downloader.start_http_session(VALID_URL)
    end
  end


  describe '#build_progress_bar' do
    it 'should return a progress bar object' do
      allow_any_instance_of(ProgressBar).to receive(:create)
      content_downloader.build_progress_bar(100)
    end
  end


  describe '#download' do
    context 'when url is valid' do
      it 'should download file' do
        expect(content_downloader).to receive(:download_content).with(VALID_URL)
        content_downloader.download(VALID_URL)
      end
    end

    context 'when url is valid and redirecting' do
      it 'should redirect' do
        expect(content_downloader).to receive(:download_content)
        expect_any_instance_of(Jenkins::Peace::ConsoleLogger).to receive(:info)
        content_downloader.download(REDIRECT_URL)
      end
    end

    context 'when url is invalid' do
      it 'should not download file' do
        expect_any_instance_of(Jenkins::Peace::ConsoleLogger).to receive(:error)
        content_downloader.download(INVALID_URL)
      end
    end
  end


  describe '#download_content' do
    context 'when url is valid' do
      it 'should download file' do
        expect_any_instance_of(Jenkins::Peace::ConsoleLogger).to receive(:info).with("Downloading   : '#{VALID_URL}'")
        expect(content_downloader).to receive(:start_http_session).with(VALID_URL)
        content_downloader.download_content(VALID_URL)
      end
    end

    context 'when url is invalid' do
      it 'should not download file' do
        expect_any_instance_of(Jenkins::Peace::ConsoleLogger).to receive(:error)
        content_downloader.download_content(INVALID_URL)
      end
    end
  end

end
