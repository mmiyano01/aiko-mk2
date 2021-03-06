{LineRawMessageListener, LineImageListener, LineVideoListener, LineAudioListener, LineLocationListener,
LineStickerListener, LineContactListener, LineRawOperationListener, LineFriendListener, LineBlockListener,
LineTextAction, LineImageAction, LineVideoAction, LineAudioAction, LineLocationAction, LineStickerAction
} = require 'hubot-line'

module.exports = (robot) ->
 robot.hear /add expense (.*) (.*) (.*)/i, (msg) ->
    @exec = require('child_process').exec
    command = "sh scripts/shell/auth.sh #{msg.message.user.name}"
    @exec command, (error, stdout) ->
      reporter = stdout.replace(/\s/g, "");
      msg.send "auth failed. try again" if error?
      #msg.send "ok, #{reporter}" if stdout?
      @exec = require('child_process').exec
      command = "sh scripts/shell/bookkeeping/add_expense.sh #{reporter} #{msg.match[1]} #{msg.match[2]} #{msg.match[3]}"
      @exec command, (error, stdout) ->
        msg.send error if error?
        msg.send "expense record added! ...ouch!" if stdout?

 robot.hear /show expense (.*) (.*)/i, (msg) ->
   @exec = require('child_process').exec
   command = "sh scripts/shell/auth.sh #{msg.message.user.name}"
   @exec command, (error, stdout) ->
     reporter = stdout.replace(/\s/g, "");
     msg.send "auth failed. try again" if error?
     #msg.send "ok, #{reporter}" if stdout?
     @exec = require('child_process').exec
     t_month = msg.match[1]
     t_year = msg.match[2]
     d = new Date
     year = d.getFullYear()

     command_m = "sh scripts/shell/bookkeeping/calc_expense.sh #{t_month} #{t_year} Masato Nina"
     @exec command_m, (error, stdout_m) ->
       ttl_m = stdout_m.replace(/\s/g, "");
       ttl_m = parseInt(ttl_m,10)
       msg.send error if error?
       #msg.send "Masato: #{ttl_m}" if stdout_m?
       @exec = require('child_process').exec

       command_n = "sh scripts/shell/bookkeeping/calc_expense.sh #{t_month} #{t_year} Nina Masato"
       @exec command_n, (error, stdout_n) ->
         ttl_n = stdout_n.replace(/\s/g, "");
         ttl_n = parseInt(ttl_n,10)
         msg.send error if error?
         #msg.send "Nina: #{ttl_n}" if stdout_n?
         #@exec = require('child_process').exec
         ttl_gap = ttl_n - ttl_m
         if ttl_gap > 0
           msg.send "Masato: #{ttl_n}  Nina: #{ttl_m}
                     Nina owes Masato #{ttl_gap}"
         else if ttl_gap < 0
           msg.send "Masato: #{ttl_n}  Nina: #{ttl_m}
                     Masato owes Nina #{ttl_gap * -1}"
         else if ttl_gap == 0
           msg.send "Masato: #{ttl_n}  Nina: #{ttl_m}
                     No money moevment"
         else
           msg.send "Something went wrong"

  robot.hear /show table expense (.*) (.*)/i, (msg) ->
    @exec = require('child_process').exec
    command = "sh scripts/shell/auth.sh #{msg.message.user.name}"
    @exec command, (error, stdout) ->
      reporter = stdout.replace(/\s/g, "");
      msg.send "auth failed. try again" if error?
      #msg.send "ok, #{reporter}" if stdout?
      @exec = require('child_process').exec
      t_month = msg.match[1]
      t_year = msg.match[2]
      d = new Date
      year = d.getFullYear()
      command = "sh scripts/shell/bookkeeping/table_expense.sh #{t_month} #{t_year}"
      @exec command, (error, stdout) ->
        msg.send "Something went wrong" if error?
        msg.send "#{t_year}-#{t_month}
                  #{stdout}" if stdout?

  robot.hear /delete previous expense/i, (msg) ->
    @exec = require('child_process').exec
    command = "sh scripts/shell/auth.sh #{msg.message.user.name}"
    @exec command, (error, stdout) ->
      reporter = stdout.replace(/\s/g, "");
      msg.send "auth failed. try again" if error?
      #msg.send "ok, #{reporter}" if stdout?
      @exec = require('child_process').exec
      command = "sh scripts/shell/bookkeeping/delete_previous.sh #{reporter}"
      @exec command, (error, stdout) ->
        msg.send error if error?
        msg.send "expense record deleted! lucky!" if stdout?
