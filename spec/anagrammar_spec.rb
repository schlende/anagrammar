require 'spec_helper'

describe Anagrammar do
	
	before :all do
		@anagrammar = Anagrammar.new()
		@anagrammar.load_words("dictionaries/words")
		puts "Dictinary loaded"
	end

	describe "#new" do
		it "returns a Annagrammar object" do
			@anagrammar.should be_an_instance_of Anagrammar
		end
	end

	describe "#load_words" do
		it "loads a bunch of words from a file into a trie" do
			#@anagrammar.load_words("dictionaries/words")
			@anagrammar.word_count.should_not eql(0)
			@anagrammar.root_node.children["d"].children["o"].children["g"].should_not eql(nil)
			@anagrammar.root_node.children["g"].children["o"].children["d"].should_not eql(nil)
		end
	end

	describe "#find_anagrams_for" do
		it "returns dog, god when you enter dog -- Can handle basic anagrams" do
			responses = @anagrammar.get_anagrams_for("dog", 3)
			responses.should include("god")
			responses.should include("dog")
		end

		it "returns dog, god when you enter d og -- Can handle spaces in inputs" do
			responses = @anagrammar.get_anagrams_for("d og", 3)

			responses.should include("god")
			responses.should include("dog")
		end

		it "returns self cuscus for Success -- Can split word results" do
			responses = @anagrammar.get_anagrams_for("successful")
			responses.should include("self cuscus")
		end

		it "returns happy happy joy joy for 'happyhappy' -- Can handle repeat words" do
			responses = @anagrammar.get_anagrams_for("happyhappy")
			responses.should include("happy happy")
		end

		it "returns Miming Smug Hon with imsingingsong as input" do
			responses = @anagrammar.get_anagrams_for("imsingingsong")
			responses.should include("noggin missing")
		end

		it "returns bonny only returns bonny not ebony etc... -- Can handle doulbe letters" do
			responses = @anagrammar.get_anagrams_for("bonny")
			responses.should include("bonny")
			responses.should_not include("ebony")
		end
	end
end
