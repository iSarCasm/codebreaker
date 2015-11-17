require 'spec_helper'

describe Codebreaker do
  it 'has a version number' do
    expect(Codebreaker::VERSION).not_to be nil
  end
end

describe Codebreaker::Game do
  describe 'instance' do
    let(:session) { Codebreaker::Game.new }

    describe '#start' do
      it 'resets number of attempts' do
        expect{ session.start }.to change{ session.attempts }.to(10)
      end

      it 'resets number of hints' do
        session.instance_variable_set(:@hints_left, 0)
        expect{ session.start }.to change{ session.hints_left }
      end

      it 'generates new code' do
        expect{ session.start }.to change{ session.secret }
      end

      it 'calls generate_code method' do
        expect(session).to receive(:generate_code)
        session.start
      end

      it 'changes state to :playing' do
        expect{ session.start }.to change{ session.state }.to(:playing)
      end

      it 'clears @elements_revealed' do
        session.instance_variable_set(:@elements_revealed, [[1,2,3], [3,2,1]])
        expect{ session.start }.to change{ session.elements_revealed }.to([])
      end
    end

    describe '#restart' do
      before { session.start(:hard) }

      it 'calls #start with previous difficulty' do
        expect(session).to receive(:start).with(:hard)
        session.restart
      end
    end

    describe '#guess' do
      before do
        session.start
      end

      it 'decrements attempts number' do
        expect{ session.guess([1,4,6,6]) }.to change{ session.attempts }.by(-1)
      end

      context 'last attempt' do
      before { session.instance_variable_set(:@attempts, 1) }
        context 'which is wrong' do
          let(:code) { [6,6,6,6] }

          it 'loses the game' do
            expect{session.guess(code)}.to change{session.state}.from(:playing).to(:lost)
          end
        end
      end


      { [1,2,2,4] =>   {[1,2,3,4] => [3,0], [1,1,1,1] => [1,0],
                        [6,5,2,2] => [1,1], [3,2,3,2] => [1,1],
                        [4,3,2,1] => [1,2], [5,2,3,4] => [2,0]},
        [4,5,6,6] =>   {[1,2,3,4] => [0,1], [1,1,1,1] => [0,0],
                        [6,5,2,2] => [1,1], [4,4,4,6] => [2,0],
                        [4,5,6,6] => [4,0], [5,4,6,6] => [2,2]},
        [1,1,1,2] =>   {[1,2,3,4] => [1,1], [1,1,1,1] => [3,0],
                        [6,5,2,2] => [1,0], [1,2,2,3] => [1,1],
                        [1,1,2,1] => [2,2], [5,2,3,4] => [0,1]} }.each do |secret, tests|
        context "secret is #{secret}" do
          before do
            session.instance_variable_set(:@secret, secret)
          end

          tests.each do |k, v|
            it "when #{k} returns #{v}" do
              expect(session.send(:guess, k)).to eq(v)
            end
          end
        end
      end

      context 'when guess length doesn`t match code length' do
        before do
          session.instance_variable_set(:@secret, [1,3,2,4])
          @code = [1,2,3,4,5,6,7,8]
        end

        it 'raises IndexError' do
          expect{ session.guess(@code) }.to raise_error(IndexError)
        end
      end
    end

    describe '#lost?' do
      it 'returns true when @state=:lost' do
        session.instance_variable_set(:@state, :lost)
        expect(session).to be_lost
      end

      it 'returns false when @state!=:lost' do
        session.instance_variable_set(:@state, :playing)
        expect(session).not_to be_lost
      end
    end

    describe '#won?' do
      it 'returns true when @state=:won' do
        session.instance_variable_set(:@state, :won)
        expect(session).to be_won
      end

      it 'returns false when @state!=:won' do
        session.instance_variable_set(:@state, :playing)
        expect(session).not_to be_won
      end
    end

    describe '#hint' do
      before do
        session.start
        session.instance_variable_set(:@hints_left, 10)
      end
      let(:unique_hints) { [session.hint, session.hint, session.hint, session.hint] }

      it 'reveals one element of code' do
        expect(session.hint.map.with_index{ |v, i| [v,session.secret[i]] }.any? do |x|
          x[0] == x[1]
        end).to be_truthy
      end

      it 'is unique' do
        expect(unique_hints.uniq).to contain_exactly(*unique_hints)
      end

      it 'decrements number of hints left' do
        expect{session.hint}.to change{session.hints_left}.by(-1)
      end

      context 'when no more hints' do
        before do
          session.instance_variable_set(:@hints_left, 0)
        end

        it 'raises an error' do
          expect{session.hint}.to raise_error RuntimeError
        end
      end
    end

    describe '#win' do
      before { session.start }

      it 'changes state to :won' do
        expect{ session.win }.to change{ session.state }.to(:won)
      end

      it 'changes score' do
        expect{ session.win }.to change{ session.score }
      end
    end

    describe '#lose' do
      before { session.start }

      it 'changes state to :lost' do
        expect{ session.lose }.to change{ session.state }.to(:lost)
      end

      it 'changes score' do
        expect{ session.win }.to change{ session.score }
      end
    end

    describe 'private' do
      describe '#extract_exact_matches' do
        before {session.start}

        { [1,2,2,4] =>   {[1,2,3,4] => 3, [1,1,1,1] => 1,
                          [6,5,2,2] => 1, [1,2,2,3] => 3,
                          [4,3,2,1] => 1, [5,2,3,4] => 2},
          [4,5,6,6] =>   {[1,2,3,4] => 0, [1,1,1,1] => 0,
                          [6,5,2,2] => 1, [4,4,4,6] => 2,
                          [4,5,6,6] => 4, [5,4,6,6] => 2},
          [1,1,1,2] =>   {[1,2,3,4] => 1, [1,1,1,1] => 3,
                          [6,5,2,2] => 1, [1,2,2,3] => 1,
                          [1,1,2,1] => 2, [5,2,3,4] => 0} }.each do |secret, tests|
          context "secret is #{secret}" do
            before do
              session.instance_variable_set(:@secret, secret)
            end

            tests.each do |k, v|
              it "when #{k} returns #{v}" do
                expect(session.send(:extract_exact_matches, secret.dup, k)).to eq(v)
              end
            end
          end
        end
      end

      describe '#extract_close_matches' do
        before {session.start}

        { [1,2,2,4] =>   {[1,2,3,4] => 3, [1,1,1,1] => 1,
                          [6,5,2,2] => 2, [1,2,2,3] => 3,
                          [4,3,2,1] => 3, [5,2,3,4] => 2},
          [4,5,6,6] =>   {[1,2,3,4] => 1, [1,1,1,1] => 0,
                          [6,5,2,2] => 2, [4,4,4,6] => 2,
                          [4,5,6,6] => 4, [5,4,6,6] => 4},
          [1,1,1,2] =>   {[1,2,3,4] => 2, [1,1,1,1] => 3,
                          [6,5,2,2] => 1, [1,2,2,3] => 2,
                          [1,1,2,1] => 4, [5,2,3,4] => 1} }.each do |secret, tests|
          context "secret is #{secret}" do
            before do
              session.instance_variable_set(:@secret, secret)
            end

            tests.each do |k, v|
              it "when #{k} returns #{v}" do
                expect(session.send(:extract_close_matches, secret.dup, k)).to eq(v)
              end
            end
          end
        end
      end

      describe '#generate_code' do
        before do
          session.start
        end

        context 'by default' do
          it 'has 4 elements' do
            expect(session.send(:generate_code).size).to eq(4)
          end

          it 'all elements between 1..6' do
            expect(session.send(:generate_code)).to all(satisfy { |v| (1..6).cover? v })
          end
        end
      end
    end
  end
end
