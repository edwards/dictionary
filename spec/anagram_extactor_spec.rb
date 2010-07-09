require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Dictionary::AnagramExtractor do

  before(:each) do
    @extractor = Dictionary::AnagramExtractor.new
  end

  describe ".file=" do

    it "should raise an error if file not found" do
      lambda { @extractor.file = 'extras/notfound.txt' }.should\
        raise_error(Dictionary::Error::FileNotFoundError)
    end

    it "should set it to the absolute path" do
      @extractor.file = 'extras/english.txt'
      Pathname.new(@extractor.file).should be_absolute
    end

    it "should clear the anagram list" do
      @extractor.file = 'extras/english.txt'
      @extractor.extract!        
      
      lambda { @extractor.file = 'extras/english.txt' }.should change(@extractor, :anagrams)
      @extractor.anagrams.should be_empty
    end

  end

  describe ".extract!" do

    before(:each) do
      @extractor.file = 'extras/english.txt'
    end

    it "should return an Array" do
      @extractor.extract!.should be_an_instance_of(Array)
    end

    it "should return four matches" do
      @extractor.extract!.size.should == 5
    end

    it "should return four matches even if words are capitalized" do
      @extractor.file = 'extras/capitalized_english.txt'
      @extractor.extract!.size.should == 5
    end

    it "should contain mary and army as anagrams" do
      @extractor.extract!.should include('mary', 'army')
    end

  end

  describe "export" do
    before(:each) do
      @location = "#{Dir.pwd}/example.txt"
    end

    after(:each) do
      FileUtils.rm_rf @location
    end

    it "should raise an error if the output file already exists" do
      lambda { @extractor.export 'extras/english.txt' }.should\
        raise_error(Dictionary::Error::FileAlreadyExistsError)
    end

    it "should raise an error if the path of the file does not exist" do
      lambda { @extractor.export 'chunky/bacon.txt' }.should\
        raise_error(Dictionary::Error::PathNotFoundError)
    end

    it "should return the location of the output" do
      @extractor.export('example.txt').should == @location
    end

    it "should write a file" do
      @extractor.export 'example.txt'
      File.exists?(@location).should be_true
    end

    it "should contain all the lines in @anagrams" do
      @extractor.file = 'extras/english.txt'
      @extractor.extract!
      @extractor.export 'example.txt'

      File.read(@location).split("\n").size.should == 5
    end

  end

end
