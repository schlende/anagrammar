
class AnagramTrieNode
	attr_accessor :letter, :final, :depth, :children
	
	def initialize(letter='', final=false, depth=0)
		self.children = {}
		self.letter = letter
		self.depth = depth
		self.final = final
	end
	
	def add(letters)
		letters.downcase!

		node = self
		index = 0
		for letter in letters.chars.to_a
			if node.children[letter] == nil
				node.children[letter] = AnagramTrieNode.new(letter, index==letters.length - 1, index + 1)
			end

			node = node.children[letter]	

			index += 1
		end
	end
end

class Anagrammar
	attr_accessor :word_count, :root_node, :dic_load_time, :found_anagrams

	def initialize()
		@word_count = 0
		@root_node = AnagramTrieNode.new
	end

	def load_words(file)
		start_time = Time.now
		file = File.new(file, "r")

		while (line = file.gets)
			new_word = String.new(line.chop).downcase 
			
			@root_node.add(new_word)

			@word_count += 1
		end

		file.close

		@dic_load_time = Time.now - start_time
	end

	def get_anagrams_for(word, min_word_length=3, limit=1000)
		word = word.gsub(/\s/, '')
		letter_counts = get_letter_counts(word)
		
		@found_anagrams = 0

		return get_anagrams_for_recursive(letter_counts, [], @root_node, word.length, min_word_length, limit)
	end

	private
	def get_anagrams_for_recursive(letter_counts, path, node, input_length, min_word_length, limit)
		anagrams = []

		#Deal with a complete word
		if node.final and node.depth >= min_word_length 
			anagram = path.join('')
			length =  anagram.gsub(/\s/,'').length

			if length >= input_length
				@found_anagrams += 1
				anagrams << anagram
			end

			#Need more letters to complete word
			path << (' ')
			anagrams.concat(get_anagrams_for_recursive(letter_counts, path, @root_node, 
				input_length, min_word_length, limit))
			
			#Out of matches. Remove what we've got so far
			path.pop()
		end

		if @found_anagrams >= limit
			return anagrams
		end

		#Traverse until we find a word
		node.children.each do | letter, new_node |
			count = letter_counts[letter]

			if count == nil
				count = 0
			end

			if count != 0
				#There are possible words in this branch
				letter_counts[letter] = count - 1
				path << letter
			
				#puts "#{letter} #{path} #{new_node.depth}"

				#Keep on traversing until we have nothing left to traverse
				anagrams.concat(get_anagrams_for_recursive(letter_counts, path, new_node, input_length, 
					min_word_length, limit))

				path.pop()
				letter_counts[letter] = count
			end
		end

		return anagrams
	end

	def get_letter_counts(word)	
		counts = {}
		
		characters = word.chars.to_a
		
		characters.each do | letter |
			if counts[letter] == nil
				counts[letter] = 0
			end
			
			counts[letter] += 1
		end
	
		return counts
	end
end
