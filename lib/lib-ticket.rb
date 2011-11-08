require 'wcnh'

module Ticket
  R = PennJSON::Remote

  # Open a new ticket
  def self.open(title, data)
    return ">".bold.cyan + " Sorry, guests can't open new tickets." unless !R.haspower(R["enactor"], "guest").to_bool
    t = Ticket.create!(title: title, body: data, requester: R["enactor"])
    team_notify("#{R.penn_name(R["enactor"]).bold} has opened a new ticket ##{t.number.to_s.bold.yellow}: #{title.bold.white}.")
    return ">".bold.cyan + " Ticket ##{t.number.to_s.bold} opened. We'll respond as soon as possible."
  end

  def self.list(page = 1)
    page = page.to_i
    return ">".bold.cyan + " Invalid page number." unless page > 0
    if R.orflags(R["enactor"],"Wr").to_bool
      list_output(Ticket.all, "All +Tickets",page,true)
    else
      list_output(Ticket.where(requester: R["enactor"]), "Your Opened +Tickets",page,false)
    end
  end

  def self.mine(page)
    page = page.to_i
    return ">".bold.cyan + " Invalid page number." unless page > 0

    list_output(Ticket.where(assignee: R["enactor"]).where(status: "open"), "Your Assigned +Tickets", page,true)
  end

  def self.assign(ticket,victim)
    return ">".bold.cyan + " Invalid ticket!" unless t = Ticket.where(number: ticket).first
    p = R.pmatch(victim)
    return ">".bold.cyan + " Invalid assignee!" unless R.orflags(p,"Wr").to_bool || victim == "none"
    t.assignee = (victim == "none" ? nil : p)
    t.updated = DateTime.now
    t.save
    team_notify("#{R.penn_name(R["enactor"]).bold} has assigned ticket ##{t.number.to_s.bold.white} to #{victim == "none" ? "nobody".bold.yellow : R.penn_name(p).bold.yellow}.")
    ">".bold.cyan + " Ticket #{t.number.to_s.bold} assigned to #{victim == "none" ? "nobody".bold : R.penn_name(p).bold}."
  end

  def self.view(ticket)
    t = Ticket.where(number: ticket).first
    isadmin = R.orflags(R["enactor"],"Wr").to_bool
    return ">".bold.cyan + " Invalid ticket!" unless (!t.nil? && (t.requester == R["enactor"] || isadmin))
    ret = titlebar("Ticket #{t.number.to_s}: #{t.title[0..60]}") + "\n"
    ret << "Requester: ".cyan + R.penn_name(t.requester || "")[0..20].ljust(20)
    ret << "Opened:  ".cyan + t.opened.strftime("%m/%d/%y %H:%M").ljust(20)
    ret << "Status: ".cyan + (t.status == "open" ? "Open".bold.on_blue : "Closed".green ) + "\n"
    if isadmin
      ret << "Assigned:  ".cyan + (t.assignee ? R.penn_name(t.assignee)[0..20].ljust(20) : "None".ljust(20))
    else
      ret << "Assigned:  ".cyan + (t.assignee ? "Yes".ljust(20) : "No".ljust(20))
    end
    ret << "Updated: ".cyan + (t.updated ? t.updated.strftime("%m/%d/%y %H:%M").ljust(20) : "Never".ljust(20)) + "\n"
    ret << ">------------------------------------BODY-------------------------------------<".red + "\n"
    ret << t.body + "\n"
    comments = t.comments
    if !isadmin
      comments = comments.where(private: false)
    end
    if comments.length > 0
      ret << ">----------------------------------COMMENTS-----------------------------------<".red + "\n"
      comments.each do |c|
        if c.private
          ret << "ADMIN-".bold.red
        end
        ret << "#{R.penn_name(c.author).white.bold} at #{c.timestamp.strftime("%m/%d/%y %H:%M").bold}: " .cyan
        ret << c.text << "\n"
      end
    end
    ret << footerbar
    ret
  end

  def self.comment(ticket,comment,privacy = true)
    t = Ticket.where(number: ticket).first
    return ">".bold.cyan + " Invalid ticket!" unless (!t.nil? && (t.requester == R["enactor"] || R.orflags(R["enactor"],"Wr").to_bool))
    t.comments.create!(author: R["enactor"], text: comment, private: privacy)
    t.updated = DateTime.now
    t.save
    team_notify("#{R.penn_name(R["enactor"]).bold} has added an #{privacy ? "admin-" : ""}comment to ticket ##{t.number.to_s.bold.yellow}.")
    if(!privacy && R["enactor"] != t.requester)
      R.pemit(t.requester,">".bold.cyan + " #{R.penn_name(R["enactor"]).bold} has added a new comment to +ticket ##{t.number.to_s.bold.yellow}. You can review it via #{("+ticket/view " + t.number.to_s).bold}.")
    end
    ">".bold.cyan + " Added comment to ticket #{t.number.to_s.bold}."
  end

  def self.close(ticket)
    t = Ticket.where(number: ticket).first
    return ">".bold.cyan + " Invalid ticket!" unless (!t.nil? && (t.requester == R["enactor"] || R.orflags(R["enactor"],"Wr").to_bool))
    return ">".bold.cyan + " Ticket already closed!" unless t.status == "open"
    t.updated = DateTime.now
    t.status = "closed"
    t.save
    t.comments.create!(author: R["enactor"], text: "Ticket closed.", private: false)
    team_notify("#{R.penn_name(R["enactor"]).bold} has closed ticket ##{t.number.to_s.bold.yellow}.")
    if R["enactor"] != t.requester
      R.mailsend(t.requester, "+Ticket #{t.number.to_s} Closed/Your +ticket ##{t.number.to_s} has been closed. Please review any comments via +ticket/view #{t.number.to_s}. If the matter is still not resolved, please add a new comment using +ticket/comment #{t.number.to_s}=<your notes> and +ticket/reopen #{t.number.to_s}.")
    end
    ">".bold.cyan + " Closed ticket #{t.number.to_s.bold}."
  end

  def self.reopen(ticket)
    t = Ticket.where(number: ticket).first
    return ">".bold.cyan + " Invalid ticket!" unless (!t.nil? && (t.requester == R["enactor"] || R.orflags(R["enactor"],"Wr").to_bool))
    return ">".bold.cyan + " Ticket already open!" unless t.status == "closed"
    t.updated = DateTime.now
    t.status = "open"
    t.save
    t.comments.create!(author: R["enactor"], text: "Ticket reopened.", private: false)
    team_notify("#{R.penn_name(R["enactor"]).bold} has reopened ticket ##{t.number.to_s.bold.yellow}.")
    ">".bold.cyan + " Reopened ticket #{t.number.to_s.bold}."
  end

  ## internal functions

  # notify admin about ticket system activity
  def self.team_notify(message)
    R.cemit("Ticket",message.cyan,"1")
  end

  # Given a Mongoid criteria, a title, and a page number, return a ticket list.
  def self.list_output(criteria, title, page = 1, show_assigned = false)
    ret = titlebar(title + " (Page #{page})") + "\n"
    ret << "XXXX #{"Requester".ljust(15)} S Assign Opened   Updated  Title".cyan + "\n"
    criteria.desc(:status).desc(:opened).skip(20 * (page.to_i - 1)).limit(20).each do |t|
      ret << t.number.to_s.rjust(4).yellow.bold + " "
      ret << R.penn_name(t.requester ||= "")[0...15].ljust(16)
      ret << (t.status == "open" ? "O".bold.on_blue + " " : "C ".green)
      ret << (t.assignee ? (show_assigned ? R.penn_name(t.assignee)[0...6].ljust(7) : "Yes    ") : "       ")
      ret << t.opened.strftime("%m/%d/%y ").cyan
      ret << (t.updated.nil? ? "         " : t.updated.strftime("%m/%d/%y "))
      ret << t.title[0..30]
      ret << "\n"
    end
    ret << footerbar()
    ret
  end

  class Ticket
    include Mongoid::Document
    field :number, :type => Integer, :default => lambda {Counters.next("ticket")}
    field :title, :type => String
    field :body, :type => String
    field :assignee, :type => String
    field :requester, :type => String
    field :status, :type => String, :default => "open"
    field :opened, :type => DateTime, :default => lambda { DateTime.now }
    field :updated, :type => DateTime

    embeds_many :comments, :class_name => "Ticket::Comment"
  end

  class Comment
    include Mongoid::Document
    embedded_in :tickets, :class_name => "Ticket::Ticket"
    field :author, :type => String
    field :timestamp, :type => DateTime, :default => lambda { DateTime.now }
    field :text, :type => String
    field :private, :type => Boolean, :default => true
  end
end
