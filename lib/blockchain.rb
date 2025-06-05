# /home/victor/blockchain/lib/blockchain.rb
require 'digest'
require 'json'
require 'time'

module Blockchain
  class Block
    attr_reader :index, :timestamp, :data, :previous_hash, :hash

    def initialize(index:, data:, previous_hash:, timestamp: nil, hash: nil)
      @index = index
      @timestamp = timestamp || Time.now.utc
      @data = data
      @previous_hash = previous_hash
      @hash = hash || calculate_hash
    end

    def calculate_hash
      Digest::SHA256.hexdigest("#{index}#{timestamp}#{JSON.dump(data)}#{previous_hash}")
    end
  end

  class Chain
    attr_reader :blocks

    def initialize(blocks = nil)
      @blocks = blocks || [create_genesis_block]
    end

    def create_genesis_block
      Block.new(index: 0, data: 'Genesis Block', previous_hash: '0')
    end

    def latest_block
      @blocks.last
    end

    def add_block(data)
      new_block = Block.new(
        index: blocks.size,
        data: data,
        previous_hash: latest_block.hash
      )
      blocks << new_block
    end

    def valid?
      blocks.each_cons(2) do |previous, current|
        return false if current.previous_hash != previous.hash
        return false if current.hash != current.calculate_hash
      end
      true
    end
  end

  class Service
    FILE_PATH = 'db/blockchain.json'

    def self.chain
      @chain ||= load_chain || Chain.new
    end

    def self.add_block(data)
      chain.add_block(data)
      save_chain
      force_reload!
    end

    def self.save_chain
      File.open(FILE_PATH, 'w') do |file|
        file.write(JSON.pretty_generate(chain.blocks.map do |block|
          {
            index: block.index,
            timestamp: block.timestamp,
            data: block.data,
            previous_hash: block.previous_hash,
            hash: block.hash
          }
        end))
      end
    end

    def self.load_chain
      return nil unless File.exist?(FILE_PATH)

      data = JSON.parse(File.read(FILE_PATH))
      blocks = data.map do |b|
        Block.new(
          index: b["index"],
          timestamp: Time.parse(b["timestamp"]),
          data: b["data"],
          previous_hash: b["previous_hash"],
          hash: b["hash"]
        )
      end
      Chain.new(blocks)
    rescue
      nil
    end

    def self.force_reload!
      @chain = load_chain
    end
  end
end
