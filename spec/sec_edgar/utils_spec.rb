require 'spec_helper'

describe String do
  describe '#blank?' do
    it 'correctly identifies blank strings' do
      expect("").to be_blank
      expect("\n").to be_blank
      expect("\t").to be_blank
      expect(" \t").to be_blank
    end

    it 'correctly returns false for non whitespace strings' do
      expect("test \n").not_to be_blank
      expect(" test \n").not_to be_blank
      expect("\ntest \n").not_to be_blank
    end
  end
end
