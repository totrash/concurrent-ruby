require "benchmark"
require "benchmark/ips"
require "concurrent"

module Concurrent
  ITERATIONS = 10000

  RSpec.describe "Map|Performance" do
    let(:hsh) { Concurrent::Hash.new }
    let(:map) { Concurrent::Map.new }

    context "In conncurent env" do
      it "should be faster" do
        puts "-------"
        puts "WRITING/READING/DELETING [CONN]"
        puts "-------"

        Benchmark.ips do |bm|
          bm.report "Hash" do
            (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
              in_thread do
                ITERATIONS.times do |j|
                  key = i * 1000 + j
                  hsh[key] = i
                  hsh[key]
                  hsh.delete(key)
                end
              end
            end.map(&:join)
          end
          bm.report "Map" do
            (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
              in_thread do
                ITERATIONS.times do |j|
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

      it "should be faster" do
        puts "-------------------"
        puts "READING [CONN]"
        puts "-------------------"

        (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
          ITERATIONS.times do |j|
            key = i * 1000 + j
            hsh[key] = i
            map[key] = i
          end
        end

        Benchmark.ips do |bm|
          bm.report "Hash" do
            (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
              in_thread do
                ITERATIONS.times do |j|
                  key = i * 1000 + j
                  hsh[key]
                end
              end
            end.map(&:join)
          end

          bm.report "Map" do
            (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
              in_thread do
                ITERATIONS.times do |j|
                  key = i * 1000 + j
                  map[key]
                end
              end
            end.map(&:join)
          end
          bm.compare!
        end
      end

      it "should be faster" do
        puts "-------------------"
        puts "WRITING [CONN]"
        puts "-------------------"

        Benchmark.ips do |bm|
          bm.report "Hash" do
            (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
              in_thread do
                ITERATIONS.times do |j|
                  key = i * 1000 + j
                  hsh[key] = i
                end
              end
            end.map(&:join)
          end

          bm.report "Map" do
            (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
              in_thread do
                ITERATIONS.times do |j|
                  key = i * 1000 + j
                  map[key] = i
                end
              end
            end.map(&:join)
          end
          bm.compare!
        end
      end
    end

    context "Without conncurent env" do
      it "should be faster" do
        puts "-------------------"
        puts "WRITING/READING/DELETING"
        puts "-------------------"

        Benchmark.ips do |bm|
          bm.report "Hash" do
            (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
              ITERATIONS.times do |j|
                key = i * 1000 + j
                hsh[key] = i
                hsh[key]
                hsh.delete(key)
              end
            end
          end
          bm.report "Map" do
            (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
              ITERATIONS.times do |j|
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

      it "should be faster" do
        puts "-------------------"
        puts "READING"
        puts "-------------------"

        (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
          ITERATIONS.times do |j|
            key = i * 1000 + j
            hsh[key] = i
            map[key] = i
          end
        end
        Benchmark.ips do |bm|
          bm.report "Hash" do
            (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
              ITERATIONS.times do |j|
                key = i * 1000 + j
                hsh[key]
              end
            end
          end

          bm.report "Map" do
            (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
              ITERATIONS.times do |j|
                key = i * 1000 + j
                map[key]
              end
            end
          end
          bm.compare!
        end
      end

      it "should be faster" do
        puts "-------------------"
        puts "WRITING"
        puts "-------------------"

        Benchmark.ips do |bm|
          bm.report "Hash" do
            (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
              ITERATIONS.times do |j|
                key = i * 1000 + j
                hsh[key] = i
              end
            end
          end

          bm.report "Map" do
            (1..Concurrent::ThreadSafe::Test::THREADS).map do |i|
              ITERATIONS.times do |j|
                key = i * 1000 + j
                map[key] = i
              end
            end
          end
          bm.compare!
        end
      end
    end
  end
end
