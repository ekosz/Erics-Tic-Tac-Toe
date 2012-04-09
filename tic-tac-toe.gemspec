# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tic-tac-toe/version"

Gem::Specification.new do |s|
  s.name        = "Erics Tic Tac Toe"
  s.version     = TicTacToe::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eric Koslow"]
  s.email       = ["ekoslow@gmail.com"]
  s.homepage    = "https://github.com/ekosz/Tic-Tac-Toe"
  s.summary     = %q{A game of Tic Tac Toe}
  s.description = %q{Plays the perfect game of Tic Tac Toe everytime. This computer can not lose.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'minitest'
  s.add_development_dependency "rake"
end

