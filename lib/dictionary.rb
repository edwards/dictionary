require 'pathname'

# Module that contains the AnagramExtractor.
module Dictionary
  base_dir = File.expand_path(File.dirname(__FILE__) + '/dictionary') + '/'
  autoload :AnagramExtractor, base_dir + 'anagram_extractor.rb'
  autoload :Error, base_dir + 'error.rb'
  autoload :AnagramExtractorC, base_dir + '../../ext/anagram_extractor_c.o'

  # Extracts the anagrams from a file, and exports the results.
  #
  # @param [String, Pathname] file the location of the dictionary.
  # @param [String, Pathname] export_location the export location for the results.
  # @param [true, false] in_c run the extraction in C.
  # @return [String] The result of the extraction.
  def self.extract_anagrams(file, export_location, in_c)
    extractor = AnagramExtractor.new(file)
    extractor.extract! in_c
    extractor.export(export_location)
    "Exported anagram list to #{export_location}."
  rescue Error::FileNotFoundError
    "The source file seems to be missing."
  rescue Error::PathNotFoundError
    "The export path does not exist."
  rescue Error::FileAlreadyExistsError
    "The export file already exists."
  end
end
