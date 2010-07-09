require 'pathname'

# Module that contains the AnagramExtractor.
module Dictionary
  base_dir = File.expand_path(File.dirname(__FILE__) + '/dictionary') + '/'
  autoload :AnagramExtractor, base_dir + 'anagram_extractor.rb'
  autoload :Error, base_dir + 'error.rb'

  # Extracts the anagrams from a file, and exports the results.
  #
  # @param [String, Pathname] file the location of the dictionary
  # @param [String, Pathname] export_location the export location for the results.
  # @return [String] The result of the extraction.
  def self.extract_anagrams(file, export_location)
    extractor = AnagramExtractor.new(file)
    extractor.extract!
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
