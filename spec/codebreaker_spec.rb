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

      it 'generates new code' do
        expect{ session.start }.to change{ session.answer }
      end

      it 'changes state to :playing' do
        expect{ session.start }.to change{ session.state }.to(:playing)
      end
    end

    describe '#generate_code' do
      before do
        session.start
      end

      it 'has 4 elements by default' do
        expect(session.send(:generate_code).size).to eq(4)
      end

      it 'all elements between 1..6' do
        expect(session.send(:generate_code)).to all(satisfy { |v| ('1'..'6').cover? v })
      end
    end

    describe '#guess' do
      context 'when guess length matches code length' do
        before do
          session.start
        end

        it 'decrements attempts number' do
          expect{ session.guess([1,4,6,6]) }.to change{ session.attempts }.by(-1)
        end

        context 'last attempt' do
        before { session.attempts = 1 }
          context 'which is wrong' do
            let(:code) { [6,6,6,6] }

            it 'loses the game' do
              expect{session.guess(code)}.to change{session.state}.from(:playing).to(:lost)
            end
          end
        end

        context 'given answer 1324' do
          before do
            session.answer = [1,3,2,4]
          end

          context 'and guess 1666' do
            let(:code) { [1,6,6,6] }

            it 'returns +' do
              expect(session.guess(code)).to contain_exactly('+')
            end
          end

          context 'and guess 4566' do
            let(:code) { [4,5,6,6] }

            it 'returns -' do
              expect(session.guess(code)).to contain_exactly('-')
            end
           end

          context 'and guess 1234' do
            let(:code) { [1,2,3,4] }

            it 'returns ++--' do
              expect(session.guess(code)).to contain_exactly('+','+','-','-')
            end
          end

          context 'and guess 1324' do
            let(:code) { [1,3,2,4] }

            it 'wins a game' do
              expect{session.guess(code)}.to change{session.state}.from(:playing).to(:won)
            end
          end
        end
      end

      context 'when guess length doesn`t match code length' do
        before do
          session.answer = [1,3,2,4]
          @code = [1,2,3,4,5,6,7,8]
        end

        it 'raises IndexError' do
          expect{ session.guess(@code) }.to raise_error(IndexError)
        end
      end
    end

    describe '#hint' do
      before do
        session.start
        session.hints_left = 10
      end
      let(:unique_hints) { [session.hint, session.hint, session.hint, session.hint] }

      it 'reveals one element of code' do
        expect(session.hint.map.with_index{ |v, i| [v,session.answer[i]] }.any? do |x|
          x[0] == x[1]
        end).to be_truthy
      end

      it 'is unique' do
        expect(unique_hints.uniq).to contain_exactly(*unique_hints)
      end

      it 'increments number of hints' do
        expect{session.hint}.to change{session.hints_left}.by(-1)
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
  end
end
