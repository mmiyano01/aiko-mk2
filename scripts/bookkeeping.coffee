{LineRawMessageListener, LineImageListener, LineVideoListener, LineAudioListener, LineLocationListener,
LineStickerListener, LineContactListener, LineRawOperationListener, LineFriendListener, LineBlockListener,
LineTextAction, LineImageAction, LineVideoAction, LineAudioAction, LineLocationAction, LineStickerAction
} = require 'hubot-line'

module.exports = (robot) ->
 robot.hear /add expense (.*) (.*)/i, (msg) ->
    @exec = require('child_process').exec
    command = "sh scripts/shell/auth.sh #{msg.message.user.name}"
    @exec command, (error, stdout) ->
      reporter = stdout.replace(/\s/g, "");
      msg.send "auth failed. try again" if error?
      
      @exec = require('child_process').exec
      command = "sh scripts/shell/add_expense.sh #{reporter} #{msg.match[1]} #{msg.match[2]}"
      @exec command, (error, stdout) ->
        msg.send error if error?
        msg.send "money money money!" if stdout? 
