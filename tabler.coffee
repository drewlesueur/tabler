#!/usr/bin/env coffee

_ = require "underscore"
_s = require "underscore.string"

process.stdin.resume()
process.stdin.setEncoding('utf8')

raw = ""
process.stdin.on 'data', (chunk) ->
	raw += chunk.toString()

process.stdin.on 'end', ->

	lines = raw.split "\n"

	data_lines = _.select lines, (line) ->
		line.indexOf("|") != -1

	data_lines = _.map data_lines, (line) ->
		items = _.reject line.split("|"), (item) -> item == ""
		_.map items, (item) -> item.trim()

	maxes = _.map data_lines[0], (value, index) ->
		max = _.max data_lines, (line) ->
			line[index].length		
		max[index].length
	
	ret = _.map data_lines, (line) ->
		padded_lines = _.map line, (item, index) ->
			_s.rpad item, maxes[index], " "
		"| " + padded_lines.join(" | ") + " |"

	cap_lines = _.map maxes, (max) -> _s.rpad "", max + 2, "-"
	cap = "+" + cap_lines.join("+") + "+"

	ret.unshift(cap)
	ret.push(cap)
	ret.splice(2, 0,  cap)
			
	ret = ret.join "\n"	
	
	console.log ret

###
show| character| character 2
The Office | Michael | Dwight
The Simpsons | Homer | Marge
Seinfeld | Jerry | George

turns into 

+--------------+-----------+--------------+
| show         | character | character 2 |
+--------------+-----------+--------------+
| The Office   | Michael   | Dwight       |
| The Simpsons | Homer     | Marge        |
| Seinfeld     | Jerry     | George       |
+--------------+-----------+--------------+
###
