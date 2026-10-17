##
# Who v2.0.1 by MC_8@undernet - Carl M. Gregory <gregory@worldinter.net>
#  This script will only work on eggdrop 1.5+ series.
#
# If you have any questions/comments/idea/suggestions/bug reports, please email me.
#
# My SVS Website - http://mc.purehype.net/
##

##
# This script will perform 'who' lookup via IRC then display it's results.  If
# there are no matches found it will try and DNS your entry then 'who' that
# as well.
##

##
# HISTORY
##
# v2.0.1 (03.17.01)
#  MC_8 - Liar - The bot was repsonding to * and ? as if it were a trigger as well, fixed.
#  MC_8 - Fixed problem with returning resolved information, problem with upper cased
#         characters within hostnames.
#  MC_8 - Fixed, `Tcl error [mc:az:trigger]: bad option "tolwoer": must be bytelength,
#         compare, equal, first, index, is, last, length, map, match, range, repeat,
#         replace, tolower, toupper, totitle, trim, trimleft, trimright, wordend, or
#         wordstart`.
#
# v2.0 (02.02.01)
#  MC_8 - Added ability to specify what channels this script is to be active on.
#         It explains how to do this feature below in the settings section of this
#         script.
#  MC_8 - Added SVS
#  MC_8 - Added ignore flag'd users option.
#  MC_8 - This script will work on eggdrop 1.5.1 or above only.
#  MC_8 - Can perform many who's simultaneously.
#  MC_8 - Script uses egdrop's internal dns lookup module, better pervents
#         the bot lagging up.
#  MC_8 - Added ability to specify more than just 1 trigger.
#  MC_8 - Made script independent of moretools.
#
# v1.2  (12.31.99)
#  MC_8 - Fixed the " ***WHO [!who] NOT loaded, please load moretools.tcl v1.0.1+ " even though it was loaded.
#
# v1.0-1.1  (??.??.99)
#  MC_8 - AZ0R0S - Inital releases.
##

##
# Settings
##

# Note:
#  There is one setting you set from dcc chat with the bot using .chanset.
#   <+/->mc.who  Setting this to +mc.who on the specific channel will 
#                enable the channel to to use this script.
#
#  Example from dcc chat with the bot:
#   .chanset #channel +mc.who

# What trigger(s) do you want this script to function on?
# Seperate each different trigger with a space.
set mc_az(trigger) "!who `who -who"

# What flaged users should have access to the commands?
# Set it to -|- to allow anyone to access the commands.
# Flag structure is <global>|<channel>
set mc_az(flags) ovs|ovs

# What flaged users should NOT have access to the commands?
# Set to -|- to turn this feature off.
# Flag structur is <global>|<channel>
set mc_az(ign:flags) kb|kb

# What's the max. limit of results you want to post?
set mc_az(limit) 4

# How do you want the script to display the results?
#  0 = MSG publicly to channel
#  1 = MSG privately to the user
#  2 = NOTICE privately to the user
set mc_az(meth) 0

## MC SVS (Script Version Server) v1.1 ##
# Do you want the bot to connection to MC_8's SVS to see if there are newer versions
# of this script avilable?  It will only tell you -- It's up to you to get the newest
# version (I decided not to auto update the code, there may be new features in the
# newest script that may require your attention).
# 0=no/1=yes
set mc_az(svs:enabled) 1

# Once a day the script will check with the SVS -- this specifies when
# that should happen.  The setting should be the hour (military).
# examples:
#  set mc_az(svs:check) 0  ;#This is at Midnight
#  set mc_az(svs:check) 5  ;#This is at 5am
#  set mc_az(svs:check) 13  ;#This is at 1pm
#  set mc_az(svs:check) 23  ;#This is at 11pm
set mc_az(svs:check) 3

# Upon finding a newer version, who do you want to notify via note?
# Seperate each user with a " " (space).
set mc_az(svs:notify) "MC_8"



#### Coding below...
set mc_az(version) v2.0.1
set mc_az(svs:script) "who 002000001000"
set mc_az(svs:server) "mc.purehype.net 8085"

if {$numversion < "1050100"} {
 putlog "Who $mc_az(version) by MC_8 is for eggdrop 1.5.1+ only."
 putlog "Who $mc_az(version) will not work with eggdrop $version."
 putlog "Who $mc_az(version) not loaded."
 return 1
};setudef flag mc.who

set temp 0
foreach mod [modules] {if {[lindex $mod 0] == "dns"} {set temp 1 ; break}}
if {!$temp} {loadmodule dns}

bind pubm - * mc:az:trigger 
proc mc:az:trigger {nick uhost hand chan args} {
 global mc_az
 set args [string tolower [split [join $args]]];set chan [string tolower $chan]
 foreach info [channel info $chan] {
  if {[string range $info 1 e] == "mc.who"} {
   if {[string index $info 0] == "-"} {return}
  }
 }
 if {![matchattr $hand $mc_az(flags) $chan] && ($mc_az(flags) != "-|-")} {return}
 if {[matchattr $hand $mc_az(ign:flags) $chan]} {return}
 set i 1
 foreach trigger $mc_az(trigger) {
  if {[string tolower [lindex $args 0]] == [string tolower $trigger]} {set i 0;break}
 }
 if {$i} {return}
 if {[lindex $args 1] == "0"} {set args "[lindex $args 0] * [lrange $args 2 e]"}
 if {[info exists mc_az(![lindex $args 1])]} {
  set mc_az(![lindex $args 1]) "$mc_az(![lindex $args 1]) $nick@$chan"
 } {
  set mc_az(![lindex $args 1]) $nick@$chan
 }
 switch -- $mc_az(meth) {
  1 {puthelp "PRIVMSG $nick :Looking up [lindex $args 1]..."}
  2 {puthelp "NOTICE $nick :Looking up [lindex $args 1]..."}
  default {
   set postit 1
   if {[llength $mc_az(![lindex $args 1])] > 1} {
    foreach post $mc_az(![lindex !$args 1]) {
     if {([lindex [split $post @] 0] != $nick) && ([lindex [split $post @] 1] == $chan)} {
      set postit 0
     }
    }
   };if {$postit} {puthelp "PRIVMSG $chan :Looking up [lindex $args 1]..."}
  }
 };if {[llength $mc_az(![lindex $args 1])] == 1} {puthelp "WHO [lindex $args 1]"}
}

bind raw - 315 mc:az:who;bind raw - 352 mc:az:who
proc mc:az:who {server num info} { 
 global mc_az;set info [string tolower [split $info]]
 switch -- $num {
  352 {
   set uhost "[lindex $info 5]![lindex $info 2]@[lindex $info 3]"
   if {[string index [lindex $info 6] 0] == "g"} {set status "-Away-"} {
    set status "-Not Away-"
   }
   if {[string index [lindex $info 6] 1] == "*"} {
    set status "$status -IRC Operator-"
   }
   if {[info exists mc_az(passv)]} {
    set mc_az(passv) "$mc_az(passv) {{[mc:az:inter:filt $uhost]} {$status}}"
   } {set mc_az(passv) "{{[mc:az:inter:filt $uhost]} {$status}}"}
  }
  315 {
   if {![info exists mc_az(![lindex $info 1])]} {
    if {[info exists mc_az(passv)]} {unset mc_az(passv)}
    return 0
   }
   if {![info exists mc_az(passv)]} {
    if {[info exists mc_az(dns:[lindex $info 1])]} {
     unset mc_az(dns:[lindex $info 1])
     mc:az:who:complete [lindex $info 1] "+001 No matches found for [lindex $info 1]."
    } {dnslookup [split [lindex $info 1]] mc:az:dnslookup [split [lindex $info 1]]}
   } {mc:az:who:complete [lindex $info 1] $mc_az(passv);unset mc_az(passv)}
  }
 };return 0
}

proc mc:az:dnslookup {ip host status iphost} {
 global mc_az
 if {$status} {
  if {$iphost == $ip} {set resolve [string tolower $host];set horip hostname} {
   set resolve $ip;set horip ip
  }
  set mc_az(!$resolve) $mc_az(!$iphost)
  unset mc_az(!$iphost)
  foreach post $mc_az(!$resolve) {
   set nick [lindex [split $post @] 0]
   set chan [lindex [split $post @] 1]
   switch -- $mc_az(meth) {
    1 {set meth "PRIVMSG $nick"}
    2 {set meth "NOTICE $nick"}
    default {set meth "PRIVMSG $chan"}
   }
   if {!$mc_az(meth)} {
    if {![info exists temp]} {set temp ""}
    if {[string match "* $chan *" " $temp "]} {continue}
    set temp "$temp $chan"
   }
   puthelp "$meth :No matches found for $iphost, trying resolved $horip $resolve"
  }
  set mc_az(dns:$resolve) 1
  puthelp "WHO $resolve"
 } {mc:az:who:complete $iphost "+001 No matches found for $iphost."}
}

proc mc:az:who:complete {search passv} {
 global mc_az;set search [split $search]
 foreach post $mc_az(![join $search]) {
  set nick [lindex [split $post @] 0]
  set chan [lindex [split $post @] 1]
  switch -- $mc_az(meth) {
   1 {set meth "PRIVMSG $nick"}
   2 {set meth "NOTICE $nick"}
   default {set meth "PRIVMSG $chan"}
  }
  if {!$mc_az(meth)} {
   if {![info exists temp]} {set temp ""}
   if {[string match "* $chan *" " $temp "]} {continue}
   set temp "$temp $chan"
  }
  if {[lindex $passv 0] == "+001"} {
   puthelp "$meth : "
   puthelp "$meth :[join [lrange $passv 1 e]]"
  } {
   set i 1
   foreach pass $passv {
    if {$i > $mc_az(limit)} {
     puthelp "$meth :Too many lines in the output, restrict your query."
     break
    } {
     puthelp "$meth : "
     puthelp "$meth :nick!ident@host: [join [lindex $pass 0]] [lindex $pass 1]"
     incr i 1
    }
   }
  }
 };unset mc_az(![join $search])
}

if {$mc_az(svs:enabled)} {
 if {($mc_az(svs:check) > "23") || ($mc_az(svs:check) < "0")} {set mc_az(svs:check) 00}
 if {[string length $mc_az(svs:check)] == "1"} {set mc_az(svs:check) 0$mc_az(svs:check)}
 bind time - "00 $mc_az(svs:check) * * *" mc:az:svs:time
 proc mc:az:svs:time {min hour day month year} {
  global mc_az
  catch {control [connect [lindex $mc_az(svs:server) 0] [lindex $mc_az(svs:server) 1]] mc:az:svs:interface}
 }
}
proc mc:az:svs:interface {idx args} {
 global mc_az;set args [join $args]
 switch -- [lindex $args 0] {
  "" {return 1}
  000 {putdcc $idx q}
  002 {putdcc $idx [lindex $mc_az(svs:script) 0]}
  003 {
   set args [lrange $args 1 e]
   if {[lindex $args 0] != [lindex $mc_az(svs:script) 0]} {return 0}
   if {[lindex $args 1] > [lindex $mc_az(svs:script) 1]} {
    set note [mc:az:svs:replace [lindex $args 7] "%0 {[lindex $args 0]} %1 {[lindex $args 1]} %2 {[lindex $args 2]}"]
    set note [mc:az:svs:replace $note "%3 {[lindex $args 3]} %4 {[lindex $args 4]} %5 {[lindex $args 5]}"]
    set note [mc:az:svs:replace $note "%6 {[lindex $args 6]} %8 {[lindex $args 8]} %version {$mc_az(version)}"]
    set note [mc:az:svs:replace $note "%9 {[lindex $args 9]} %10 {[lindex $args 10]} %11 {[lindex $args 11]}"]
    set note [mc:az:svs:replace $note "%12 {[lindex $args 12]} %13 {[lindex $args 13]} %14 {[lindex $args 14]}"]
    set note [mc:az:svs:replace $note "%15 {[lindex $args 15]} %16 {[lindex $args 16]} %17 {[lindex $args 17]}"]
    set note [mc:az:svs:replace $note "%18 {[lindex $args 18]} %19 {[lindex $args 19]} %20 {[lindex $args 20]}"]
    foreach notify [join [split $mc_az(svs:notify) ",;"]] {
     switch -- [sendnote SVS $notify [mc:az:svs:replace $note "%nick {$notify}"]] {
      0 {putlog "MC SVS for [lindex $mc_az(svs:script) 0] had some errors updating $notify on current version of script; unknown reason!"}
      3 {putlog "MC SVS for [lindex $mc_az(svs:script) 0] had some errors updating $notify on current version of script; notebox too full!"}
     }
    }
   } ; putdcc $idx q
  }
 } ; return 0
}
proc mc:az:svs:replace {string subs} {
 if {[llength $subs] == "1"} {set subs [lindex $subs 0]}
 for {set i 0} {[lindex $subs $i] != ""} {incr i 2} {
  regsub -all -- [lindex $subs $i] $string [lindex $subs [expr $i+1]] string
 } ; return $string
}

proc mc:az:inter:filt {data} {
  regsub -all -- \\\\ $data \\\\\\\\ data ; regsub -all -- \\\[ $data \\\\\[ data ; regsub -all -- \\\] $data \\\\\] data
  regsub -all -- \\\} $data \\\\\} data ; regsub -all -- \\\{ $data \\\\\{ data ; regsub -all -- \\\" $data \\\\\" data ; return $data
}

putlog "Who $mc_az(version) by MC_8 loaded."
