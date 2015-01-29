#!/usr/bin/env ruby

require './lib/P2t/app'

app = P2t::Application.new
app.update_trello_cards
