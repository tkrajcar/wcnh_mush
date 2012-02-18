require 'wcnh'

module Shiprace

  MAX_RACERS = 10
  RACE_OBJ = "#639"
  RACE_CHAN = "100.00"
  RACE_HANDLE = "ESRL Announcer"
  FILE_SHIPS = File.expand_path('./ships.txt', File.dirname(__FILE__))
  FILE_NAMES = File.expand_path('./names.txt', File.dirname(__FILE__))

  def self.purchase(dbref)
    wallet = Econ::Wallet.find_or_create_by(id: dbref)
    bank = Econ::Wallet.find_or_create_by(id: RACE_OBJ)
    wager = 10

    return "> ".red + "Betting is currently closed." unless Racer.all.length > 0
    return "> ".red + "You need at least 10c to place a bet." unless wallet.balance > wager
    return "> ".red + "You cannot have more than 3 tickets for one race." unless Ticket.where(dbref: dbref).length < 3

    racer = Racer.all.shuffle.first
    ticket = racer.tickets.create!(dbref: dbref, wager: wager)
    
    wallet.balance = wallet.balance - wager
    wallet.save
    bank.balance = bank.balance + wager
    bank.save

    Logs.log_syslog("SHIPRACE","#{R.penn_name(R["enactor"])} purchased a race ticket for #{wager}c.")
    return "> ".green + "You placed a bet of #{wager}c on the #{racer.ship} piloted by #{racer.name}"
  end

  def self.tickets
    tickets = Ticket.all
    return "> ".red + "No tickets purchased in the current race." unless tickets.count > 0
    ret = titlebar("Race Tickets Purchased") + "\n"
    ret << " Buyer".ljust(25).yellow + "Ship".ljust(25).yellow + "Pilot".ljust(21).yellow + "Wager".yellow + "\n"
    tickets.each do |ticket|
      ret << " #{R.penn_name(ticket.dbref).ljust(23)} #{ticket.racer.ship.ljust(24)} #{ticket.racer.name.ljust(20)} #{ticket.wager}\n"
    end
    ret << footerbar
    ret
  end

  def self.buildroster
    names = []
    ships = []
    roster = {}

    File.open(FILE_NAMES, "r") do |file|
      while line = file.gets
        names.<< line.chomp
      end
    end

    File.open(FILE_SHIPS, "r") do |file|
      while line = file.gets
        ships.<< line.chomp
      end
    end

    ships.shuffle!
    names.shuffle!
    MAX_RACERS.times { roster["#{names.shift} #{names.shift}"] = ships.shift }
    roster.each { |name, ship| Racer.create!(name: name, ship: ship) }

    return roster.length
  end

  def self.roster
    roster = Racer.all
    return "> ".red + "The race roster is currently empty." unless roster.length > 0
    ret = titlebar("Racing League Roster") + "\n"
    ret << " ## Ship".ljust(35).yellow + "Pilot".yellow + "\n"
    roster.each_with_index do |racer, num|
      ret << " #{num.next.to_s.ljust(2)} #{racer.ship.ljust(30)} #{racer.name}\n"
    end
    ret << footerbar
    ret
  end

  def self.runrace
    racers = Racer.all.sort { |a, b| a.skillcheck <=> b.skillcheck }.reverse
    turn1, turn2 = racers[rand(racers.length)], racers[rand(racers.length)]
    victor = racers.first
    winners = victor.tickets
    bank = Econ::Wallet.find_or_create_by(id: RACE_OBJ)
    pot = (bank.balance * 0.75).to_i

    Comms.channel_emit(RACE_CHAN,RACE_HANDLE,"Welcome to the Enigma Sector Racing League!")
    Comms.channel_emit(RACE_CHAN,RACE_HANDLE,"We have #{racers.length} competitors in tonight's race through the Damioyn System!  Use race/roster to check the roster!")
    Comms.channel_emit(RACE_CHAN,RACE_HANDLE,"3.. 2.. 1.. And they're off!")
    Comms.channel_emit(RACE_CHAN,RACE_HANDLE,"As they pass Damioyn III, #{turn1.name} in the #{turn1.ship} is in the lead!")
    Comms.channel_emit(RACE_CHAN,RACE_HANDLE,"#{turn2.name} in the #{turn2.ship} is leading the pack as they pass Damioyn VI!")
    Comms.channel_emit(RACE_CHAN,RACE_HANDLE,"At the Damioyn VIII finish line, it's the #{victor.ship} piloted by #{victor.name}!")
    Comms.channel_emit(RACE_CHAN,RACE_HANDLE,"There were #{winners.length} winning tickets with a jackpot of #{pot} credits.")

    if winners.length > 0
      bank.balance = bank.balance - pot
      bank.save
    end
    
    winners_names = []
    winners.each { |winner| winners_names.<< R.penn_name(winner.dbref) }
    Logs.log_syslog("SHIPRACE","Completing race.  Jackpot: #{pot}. #{winners.length} winners: #{winners_names.join(", ")}")

    winners.each do |winner|
      wallet = Econ::Wallet.find_or_create_by(id: winner.dbref)
      wallet.balance = wallet.balance + (pot / winners.length)
      wallet.save
      R.mailsend(winner.dbref,"Ship Race Winner!/You won #{pot / winners.length} credits in a ship race by betting on the #{victor.ship} piloted by #{victor.name}!")
    end

    Ticket.destroy_all
    Racer.destroy_all
    self.buildroster

    return
  end

  class Racer
      include Mongoid::Document
      field :name, type: String
      field :ship, type: String
      field :dbref, type: String
      field :skill, type: Integer, default: lambda { rand(6) + 1 }
      has_many :tickets, :class_name => "Shiprace::Ticket"

      def skillcheck
        rand(5) - 2 + self.skill
      end
  end

  class Ticket
      include Mongoid::Document
      field :dbref, type: String
      field :wager, type: Integer
      belongs_to :racer, :class_name => "Shiprace::Racer"
  end

end

