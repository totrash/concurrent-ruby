require "benchmark"
require "benchmark/ips"
require "concurrent"

module Concurrent
  RSpec.describe Map do
    context "concurrency" do
      let(:hsh) { Concurrent::Hash.new }
      let(:map) { Concurrent::Map.new }

      it "should be faster in conncurent env" do
        Benchmark.ips do |bm|
          bm.report "Hash" do
            (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
              in_thread do
                1000.times do |j|
                  key = i * 1000 + j
                  hsh[key] = i
                  hsh[key]
                  hsh.delete(key)
                end
              end
            end.map(&:join)
            expect(hsh).to be_empty
          end
          bm.report "Map" do
            (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
              in_thread do
                1000.times do |j|
                  key = i * 1000 + j
                  map[key] = i
                  map[key]
                  map.delete(key)
                end
              end
            end.map(&:join)
          end
          bm.compare!
        end
      end
    end

    context "without concurrency" do
      let(:hsh) { Concurrent::Hash.new }
      let(:map) { Concurrent::Map.new }

      it "should be faster without conncurency" do
        Benchmark.ips do |bm|
          bm.report "Hash" do
            (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
              1000.times do |j|
                key = i * 1000 + j
                hsh[key] = i
                hsh[key]
                hsh.delete(key)
              end
            end
            expect(hsh).to be_empty
          end
          bm.report "Map" do
            (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
              1000.times do |j|
                key = i * 1000 + j
                map[key] = i
                map[key]
                map.delete(key)
              end
            end
          end
          bm.compare!
        end
      end
    end
  end
end
