module Dictionary
  # The class AnagramExtactor, contains the implementation to get all the anagrams
  # from a dictionary provided text file.
  #
  # @example Example Usage
  #   extractor = AnagramExtractor.new('my_dictionary.txt')
  #   extractor.extract!
  #   extractor.export('anagrams.txt')
  class AnagramExtractor
    # Holds the dictionary file.
    attr_reader :file
    # Holds the anagrams extracted.
    attr_reader :anagrams

    # An AnagramExtactor instance should be initialized with the location of the file to scan. 
    # 
    # @raise [Dictionary::Error::FileNotFoundError] if the provided file is not found.
    # @param [String, Pathname] file the location of the file.
    def initialize(file=nil)
      self.file = file if file
    end

    # Replaces the dictionary file. Also resets the dictionary and the extracted anagrams.
    #
    # @raise [Dictionary::Error::FileNotFoundError] if the provided file is not found.
    # @param [String, Pathname] file the location of the file.
    def file=(file)
      reset_dictionaries
      @file = get_full_location file
      raise Error::FileNotFoundError unless File.exists?(@file)
    end

    # Extracts the anagrams from the provided file.
    #
    # @return [Array] the anagram list.
    def extract!
      reset_dictionaries
      File.read(@file).each_line do |word|
        word = word.strip
        has_an_anagram = anagram_for? word
        @anagrams += [word, has_an_anagram] if has_an_anagram
        @dictionary << word
      end
      @anagrams
    end

    # Saves the anagram dictionary to a provided file.
    #
    # @param [String, Pathname] location the location of the file to write.
    # @raise [Dictionary::Error::FileAlreadyExistsError] if the file already exists.
    # @raise [Dictionary::Error::PathNotFoundError] if the export path does not exists.
    # @return [String] the full path to the exported file. 
    def export(location)
      location    = get_full_location location
      @anagrams ||= []

      raise Dictionary::Error::FileAlreadyExistsError if File.exists? location
      unless File.directory? File.dirname(location)
        raise Dictionary::Error::PathNotFoundError
      end
      File.open(location, 'w') { |file| file.puts @anagrams.join("\n") }
      location
    end

    private
      # Will return if a word has an anagram in the currently extracted dictionary.
      #
      # @private
      # @param [String] word the word to check
      # @return [nil, String] nil if the dictionary is empty or, there are no anagrams for 
      # this word. Else, the matching word.
      def anagram_for?(word)
        word_letters = word.downcase.scan(/\w/).sort
        @dictionary.find do |test_word|
          test_word_letters = test_word.downcase.scan(/\w/)
          test_word_letters.size == word_letters.size &&
            test_word_letters.sort == word_letters
        end
      end

      # Resets the dictionary and the anagrams.
      #
      # @return [nil]
      def reset_dictionaries
        @dictionary = []
        @anagrams   = []
      end

      # Standardizes the location of the passed file.
      #
      # @param [String, Pathname] file the file to scan.
      # @return [String] the standardized location.
      def get_full_location(file)
        file = "#{Dir.pwd}/#{file}" unless Pathname.new(file).absolute?
         File.expand_path(file)
      end
  end
end
