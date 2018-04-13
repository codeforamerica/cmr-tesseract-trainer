# This script will convert all words to uppercase and remove duplicates

path = 'inputs/word_list'
lines = IO.readlines(path)
          .map(&:upcase)
          .uniq
          .sort
File.open(path, 'w') do |file|
  file.puts lines
end
