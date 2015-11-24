require 'spec_helper'

describe Codebreaker::ConsoleInterface do
  before do
    @console = Codebreaker::ConsoleInterface.new
    $stdout = fake = StringIO.new
  end

  describe '#start' do
    before do
      allow(@console).to receive(:welcome)
      allow(@console).to receive(:play)
      allow(@console).to receive(:goodbye)
    end

    it 'calls #welcome' do
      expect(@console).to receive(:welcome)
      @console.start
    end

    it 'calls #play' do
      expect(@console).to receive(:play)
      @console.start
    end

    it 'calls #goodbye' do
      expect(@console).to receive(:goodbye)
      @console.start
    end
  end

  describe '#welcome' do
    it 'displays Welcome Message' do
      expect{ @console.welcome }.to output(Codebreaker::ConsoleInterface::Welcome_text+"\n").to_stdout
    end

    it 'creates a new Game' do
      expect{ @console.welcome }.to change{@console.instance_variable_get('@session')}
    end
  end

  describe '#play' do
    before do
      allow(@console).to receive(:select_difficulty)
      allow(@console).to receive(:difficulty_info)
      allow(@console).to receive(:guessing)
      allow(@console).to receive(:results)
      allow(@console).to receive(:ask_for_replay)
    end

    it 'selects difficulty' do
      expect(@console).to receive(:select_difficulty)
      @console.play
    end

    it 'shows difficulty' do
      expect(@console).to receive(:difficulty_info)
      @console.play
    end

    it 'starts guessing' do
      expect(@console).to receive(:guessing)
      @console.play
    end

    it 'sets @played flag' do
      expect{@console.play}.to change{@console.instance_variable_get('@played')}.to(true)
    end

    it 'displays results' do
      expect(@console).to receive(:results)
      @console.play
    end

    it 'asks for replay' do
      expect(@console).to receive(:ask_for_replay)
      @console.play
    end

    context 'reply "y"' do
      it 'starts over again' do
        allow(@console).to receive(:ask_for_replay).and_return('y','n')
        expect(@console).to receive(:select_difficulty).twice
        @console.play
      end
    end

    context 'reply else' do
      it 'breakes the loop' do
        allow(@console).to receive(:ask_for_replay) {'n'}
        expect(@console).to receive(:select_difficulty).once
        @console.play
      end
    end
  end

  describe '#select_difficulty' do
    before { @console.instance_variable_set('@session', Codebreaker::Game.new)}

    it 'displays difficulty info' do
      allow(@console).to receive(:gets).and_return("easy")
      @console.select_difficulty
      expect($stdout.string).to match(Codebreaker::ConsoleInterface::Diff_select_text)
    end

    it 'asks user to input choice' do
      allow(@console).to receive(:gets).and_return("easy")
      expect(@console).to receive(:gets)
      @console.select_difficulty
    end

    context 'by default' do
      it 'calls restart when played' do
        @console.instance_variable_set('@played',true)
        allow(@console).to receive(:gets).and_return("\n")
        expect(@console.instance_variable_get('@session')).to receive(:restart)
        @console.select_difficulty
      end
    end

    context 'otherwise' do
      it 'calls start with new difficulty' do
        allow(@console).to receive(:gets).and_return("easy")
        expect(@console.instance_variable_get('@session')).to receive(:start)
        @console.select_difficulty
      end
    end
  end

  describe '#difficulty_info' do
    before { @console.instance_variable_set('@session', Codebreaker::Game.new)}

    it 'displays symbols range' do
      expect{@console.difficulty_info}
        .to output(/#{@console.instance_variable_get('@session').symbols_range}/).to_stdout
    end

    it 'displays symbols count' do
      expect{@console.difficulty_info}
        .to output(/#{@console.instance_variable_get('@session').symbols_count}/).to_stdout
    end

    it 'displays attempts' do
      expect{@console.difficulty_info}
        .to output(/#{@console.instance_variable_get('@session').attempts}/).to_stdout
    end

    it 'displays hints left' do
      expect{@console.difficulty_info}
        .to output(/#{@console.instance_variable_get('@session').hints_left}/).to_stdout
    end
  end

  describe '#guessing' do
    before do
      @console.instance_variable_set('@session', Codebreaker::Game.new)
      @console.instance_variable_get('@session').instance_variable_set('@attempts', 1)
      @console.instance_variable_get('@session').instance_variable_set('@secret', [3,2,3,4])
    end

    it 'asks for guess' do
      allow(@console).to receive(:gets).and_return("1234")
      expect{@console.guessing}
        .to output(/#{Codebreaker::ConsoleInterface::Ask_for_guess_text}/).to_stdout
    end

    context 'guess' do
      it 'calls guess on Game' do
        allow(@console).to receive(:gets).and_return("1234")
        allow(@console.instance_variable_get('@session')).to receive(:guess).and_return([1,1])
        expect(@console.instance_variable_get('@session')).to receive(:guess)
        @console.guessing
      end

      it 'displays the response' do
        allow(@console).to receive(:gets).and_return("1234")
        allow(@console.instance_variable_get('@session')).to receive(:guess).and_return([1,1])
        @console.guessing
        expect($stdout.string)
          .to match(/\+\-/)
      end
    end

    context 'hint' do
      before do
        @console.instance_variable_get('@session').instance_variable_set('@hints_left', 1)
        @console.instance_variable_get('@session').instance_variable_set('@elements_revealed', [])
      end

      it 'shows one of the symbols of code' do
        allow(@console).to receive(:gets).and_return("hint")
        allow(@console.instance_variable_get('@session')).to receive(:rand).and_return(3)
        @console.guessing
        expect($stdout.string)
          .to match(/['*','*','*',4]/)
      end
    end
  end

  describe '#results' do
    context 'won game' do
      before do
        @console.instance_variable_set('@session', Codebreaker::Game.new)
        @console.instance_variable_get('@session').instance_variable_set('@max_attempts', 10)
        @console.instance_variable_get('@session').instance_variable_set('@attempts', 5)
        @console.instance_variable_get('@session').instance_variable_set('@score', 7)
        @console.instance_variable_get('@session').instance_variable_set('@state', :won)
      end

      it 'displays victory text' do
        expect{@console.results}
          .to output(/#{Codebreaker::ConsoleInterface::Win_text}/).to_stdout
      end

      it 'shows attempts taken' do
        expect{@console.results}
          .to output(/#{Codebreaker::ConsoleInterface::Win_text}/).to_stdout
      end

      it 'shows result score' do
        expect{@console.results}
          .to output(/7/).to_stdout
      end
    end

    context 'lost game' do
      before do
        @console.instance_variable_set('@session', Codebreaker::Game.new)
        @console.instance_variable_get('@session').instance_variable_set('@state', :lost)
        @console.instance_variable_get('@session').instance_variable_set('@secret', 'SeCrEt')
      end

      it 'displays lose text' do
        expect{@console.results}
          .to output(/#{Codebreaker::ConsoleInterface::Lose_text}/).to_stdout
      end

      it 'displays the real answer' do
        expect{@console.results}
          .to output(/SeCrEt/).to_stdout
      end
    end
  end

  describe '#ask_for_replay' do
    it 'shows replay message' do
      allow(@console).to receive(:gets).and_return("")
      expect{@console.ask_for_replay}
        .to output("#{Codebreaker::ConsoleInterface::Replay_text}\n").to_stdout
    end

    it 'asks for answer' do
      allow(@console).to receive(:gets).and_return("")
      expect(@console).to receive(:gets)
      @console.ask_for_replay
    end
  end

  describe '#goodbye' do
    it 'displays bye-bye text' do
      expect{@console.goodbye}
        .to output(/#{Codebreaker::ConsoleInterface::Bye_text}/).to_stdout
    end
  end
end
