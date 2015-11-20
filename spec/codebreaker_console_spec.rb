require 'spec_helper'

describe Codebreaker::ConsoleInterface do
  describe '#welcome' do
    it 'displays Welcome Message'

    it 'displays Welcome Screen'

    it 'creates a new Game'
  end

  describe '#play' do
    it 'selects difficulty'

    it 'shows difficulty'

    it 'starts guessing'

    it 'sets @played flag'

    it 'displays results'

    it 'asks for replay'

    context 'reply "y"' do
      it 'starts over again'
    end

    context 'reply else' do
      it 'breakes the loop'
    end
  end

  describe '#select_difficulty' do
    it 'displays difficulty info'

    it 'asks user to input choice'

    context 'by default' do
      it 'calls restart'
    end

    context 'otherwise' do
      it 'calls start with new difficulty'
    end
  end

  describe '#difficulty_info' do
    it 'displays symbols range'

    it 'displays symbols count'

    it 'displays attempts'

    it 'displays hints left'
  end

  describe '#guessing' do
    it 'asks for guess'

    context 'guess' do
      it 'calls guess on Game'

      it 'displays the response'
    end

    context 'hint' do
      it 'shows one of the symbols of code'
    end
  end

  describe '#results' do
    context 'won game' do
      it 'displays victory text'

      it 'shows attempts taken'

      it 'shows result score'
    end

    context 'lost game' do
      it 'displays lose text'

      it 'displays the real answer'
    end
  end

  describe '#ask_for_replay' do
    it 'shows replay message'

    it 'asks for answer'
  end

  describe '#goodbye' do
    it 'displays bye-bye text'
  end
end
