# Load the rails application
require File.expand_path('../application', __FILE__)


# Initialize the rails application
SampleApp::Application.initialize!

require 'will_paginate'
SPECIES = ["Manatee", "Jellyfish", "Immortal Jellyfish", "Dolphin", "Octopus", "Squid", "Starfish", "Swordfish", "Clam", "Whale", "Blowfish"]

