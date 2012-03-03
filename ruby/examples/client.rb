#!/usr/bin/env ruby

require 'redis'

require_relative '../lib/redisrpc'
require_relative './calc'

def assert(cond)
    if not cond
        fail 'assertion failed'
    end
end

def do_calculations(calculator)
    calculator.clr
    calculator.add 5
    calculator.sub 3
    calculator.mul 4
    calculator.div 2
    assert calculator.val == 4
    begin
        calculator.missing_method
        assert false
    rescue NoMethodError
    rescue RedisRPC::RemoteException
    end
end

# 1. Local object
calculator = Calculator.new
do_calculations calculator

# 2. Remote object, should act like local object
redis_server = Redis.new
input_queue = 'calc'
calculator = RedisRPC::Client.new redis_server, 'calc'
do_calculations calculator
puts 'success!'
