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
    end

    describe '#generate_code' do
      it 'returns an array' do
        expect(session.generate_code).to be_an(Array)
      end

      it 'has 4 elements by default' do
        expect(session.generate_code.size).to eq(4)
      end

      it 'all elements between 1..6' do
        expect(session.generate_code).to all(satisfy { |v| (1..6).cover? v })
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
          let(:code) { [6,6,6,6] }

          context 'which is wrong' do
            it 'loses the game ;(' do
              # WHERE IS CODE? OMG!!111
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
              expect(session.guess(code)).to_not be_an(Array) # => WRONG
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

    end

    describe '#win' do

    end

    describe '#lose' do

    end

    describe '#save_score' do

    end
  end
end
