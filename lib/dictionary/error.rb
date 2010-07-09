# Module for Exceptions from the Dictionary Module.
module Dictionary::Error
  # A FileNotFoundError may be raised by an AnagramExtactor class if the source file is not
  # found.
  #
  # @see Dictionary::AnagramExtractor#initialize
  # @see Dictionary::AnagramExtractor#file=
  class FileNotFoundError < StandardError
  end

  # A PathNotFoundError may be raised by an AnagramExtactor class if the path to a file is not
  # found.
  #
  # @see Dictionary::AnagramExtractor#export
  # @see Dictionary::AnagramExtractor#file=  
  class PathNotFoundError < StandardError
  end

  # A FileAlreadyExistsError may be raised by an AnagramExtactor class if the file already exists.
  #
  # @see Dictionary::AnagramExtractor#export
  # @see Dictionary::AnagramExtractor#file=  
  class FileAlreadyExistsError < StandardError
  end
end
