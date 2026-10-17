##
# Who v2.1 by MC_8 - Carl M. Gregory <gregory@worldinter.net>
#  This script will only work on eggdrop 1.5.1 (or greater) only.
#
# My SVS Website - http://mc.purehype.net:81/
##

##
# This script will perform 'who' lookup via IRC then display it's results.  If
# there are no matches found it will try and DNS your entry then 'who' that
# as well.
##

##
# HISTORY
##
# v2.1 (11.07.01)
#  MC_8 - Updated SVS from v1.1 to v1.3.
#  MC_8 - Recoded the whole script.  It was old and ugly.
#
# v2.0.1 (03.17.01)
#  MC_8 - Liar - The bot was repsonding to * and ? as if it were a trigger as well, fixed.
#  MC_8 - Fixed problem with returning resolved information, problem with upper cased
#         characters within hostnames.
#  MC_8 - Fixed, `Tcl error [mc:who:trigger]: bad option "tolwoer": must be bytelength,
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
#  MC_8 - Fixed the " ***WHO [!who] NOT loaded, please load moretools.tcl v1.0.1+ "
#         even though it was loaded.
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
set mc_who(trigger) "!who `who -who"

# What flaged users should have access to the commands?
# Set to "-|-" to allow anyone to access the commands.
# Set to "" for registered users only (users added to the 
#  bot via .+user or .adduser.
# Flag structure is <global>|<channel>
set mc_who(flags) "ovs|ovs"

# What flaged users should NOT have access to the commands?
# Set to "-|-" to ignore registered users (users added to
#  the bot via .+user or .adduser.
# Set to "" to turn this feature off.
# Flag structur is <global>|<channel>
set mc_who(ign:flags) "kb|kb"

# What's the max. limit of results you want to post?
set mc_who(limit) 4

# How do you want the script to display the results?
#  0 = MSG publicly to channel
#  1 = MSG privately to the user
#  2 = NOTICE privately to the user
set mc_who(meth) 0


## MC SVS (Script Version Service) v1.3 ##
# Do you want the bot to connection to MC_8's SVS to see if there are newer versions
# of this script avilable?  It will only tell you -- It's up to you to get the newest
# version (I decided not to auto update the code, there may be new features in the
# newest script that may require your attention).
# 0=no/1=yes
set mc_who(svs:enabled) 1

# Once a day the script will check with the SVS -- this specifies when
# that should happen.  The setting should be the hour (military).
# examples:
#  set mc_who(svs:check) 0  ;#This is at Midnight
#  set mc_who(svs:check) 5  ;#This is at 5am
#  set mc_who(svs:check) 13  ;#This is at 1pm
#  set mc_who(svs:check) 23  ;#This is at 11pm
set mc_who(svs:check) 3

# Upon finding a newer version of this script, who do you want this script
# to send a note to telling them of this newer version?
# If more than 1 user is to be notified, seperate each user with a
# ' ' (space).
set mc_who(svs:notify) "MC_8"

# Do you want even beta version notified to whomever you have set?  Or just
# stable releases of the script?
#  0 = Tell me about all version, even beta versions.
#  1 = Just tell me about new stable versions.
set mc_who(svs:stableonly) 0


## Language
set mc_who(lang:001) "Looking up %who ..."              ;# who
set mc_who(lang:002) "(%num/%total) %who> %nick (%ident@%host) \[%away / %oper\]"
                                                        ;# num total who nick ident host away oper
set mc_who(lang:003) "No matches found for %who, trying resolved %resolve_type: %resolve"
                                                        ;# who resolve_type resolve
set mc_who(lang:004) "%who not found."                  ;# who
set mc_who(lang:005) "Too many lines in the output, restrict your query."
                                                        ;# 




##
# Coding below, do not edit below here
# unless you know what your doing.
##

set mc_who(version) v2.1
set mc_who(svs:script) "who 002001000000"
set mc_who(svs:server) "mc.purehype.net 8085"

if {$numversion < "1050100"} {
 putlog "Who $mc_who(version) by MC_8 is for eggdrop 1.5.1 (or greater) only."
 putlog "Who $mc_who(version) will not work with eggdrop $version."
 putlog "Who $mc_who(version) not loaded."
 return 1
}; setudef flag mc.who

set temp 0
foreach mod [modules] {if {[lindex $mod 0] == "dns"} {set temp 1 ; break}}
if {!$temp} {loadmodule dns}
set temp 0
foreach mod [modules] {if {[lindex $mod 0] == "dns"} {set temp 1 ; break}}
if {!$temp} {
 putlog "Who $mc_who(version) by MC_8 could not be loaded:  DNS module will not load."
 return 1
}

bind pubm - * mc:who:pubm
proc mc:who:pubm {nick uhost hand chan arg} {
 global mc_who
 scan $arg "%s %s" cmd who
 if {(![mc:who:chanflag $chan mc.who]) ||
     ((![matchattr $hand $mc_who(flags) $chan]) && ($mc_who(flags) != "-|-")) ||
     (([matchattr $hand $mc_who(ign:flags) $chan]) && ($mc_who(ign:flags) != "")) ||
     (![string match "* [string tolower $cmd] *" " $mc_who(trigger) "]) ||
     (![info exists who])} {return 0}
 lappend mc_who(:post:[string tolower $who]:) [list $nick $chan]
 switch -- $mc_who(meth) {
  1 {set meth "PRIVMSG $nick"}
  2 {set meth "NOTICE $nick"}
  default {set meth "PRIVMSG $chan"}
 }
 if {![info exists mc_who(:posted:[string tolower $who]:)]} {
  set mc_who(:posted:[string tolower $who]:) ""
 }
 if {[lsearch -exact $mc_who(:posted:[string tolower $who]:) $meth] == "-1"} {
  lappend mc_who(:posted:[string tolower $who]:) $meth
  puthelp "$meth :[mc:who:replace $mc_who(lang:001) [list %who $who]]"
  puthelp "WHO $who"
 }
}

bind evnt - init-server mc:who:evnt
proc mc:who:evnt {type} {
 global mc_who
 foreach array [array names mc_who] {
  if {[regexp -- {^:} $array]} {unset mc_who($array)}
 }
}

bind raw - 315 mc:who:raw
bind raw - 352 mc:who:raw
proc mc:who:raw {server num arg} {
 global mc_who
 switch -- $num {
  352 {
   scan $arg "%s %s %s %s %s %s %s %s %\[^\0\]\0" a chan ident host server nick status hop name
   if {[string index [string tolower $status] 0] == "g"} {set away "Away"} \
   else {set away "Not Away"}
   if {[string index [string tolower $status] 1] == "*"} {set oper "IRC Operator"} \
   else {set oper "Regular User"}
   lappend mc_who(:found:) [list $nick $ident $host $away $oper]
  }
  315 {
   scan $arg "%s %s" a who
   if {![info exists mc_who(:post:[string tolower $who]:)]} {
    set mc_who(:post:[string tolower $who]:) ""
   }
   if {![info exists mc_who(:found:)]} {dnslookup $who mc:who:dnslookup $who} \
   else {mc:who:display $who}
  }
 }; return 0
}

proc mc:who:dnslookup {ip host status who} {
 global mc_who
 if {!$status} {mc:who:display $who;return}
 if {$who == $ip} {set resolve $host;set res_t host} \
 else {set resolve $ip;set res_t ip}
 if {![info exists mc_who(:dns:[string tolower $who]:)]} {
  set mc_who(:dns:[string tolower $who]:) ""
 }
 if {[lsearch -exact $mc_who(:dns:[string tolower $who]:) [string tolower $resolve]] != "-1"} {
  mc:who:display $who; return 1
 }
 set mc_who(:post:[string tolower $resolve]:) $mc_who(:post:[string tolower $who]:)
 unset mc_who(:post:[string tolower $who]:)
 set mc_who(:posted:[string tolower $resolve]:) $mc_who(:posted:[string tolower $who]:)
 unset mc_who(:posted:[string tolower $who]:)
 set mc_who(:dns:[string tolower $resolve]:) $mc_who(:dns:[string tolower $who]:)
 unset mc_who(:dns:[string tolower $who]:)
 lappend mc_who(:dns:[string tolower $resolve]:) $who
 set posted ""
 foreach post $mc_who(:post:[string tolower $resolve]:) {
  set nick [lindex $post 0]; set chan [lindex $post 1]
  switch -- $mc_who(meth) {
   1 {set meth "PRIVMSG $nick"}
   2 {set meth "NOTICE $nick"}
   default {set meth "PRIVMSG $chan"}
  }
  if {[lsearch -exact $posted $meth] != "-1"} {continue}
  lappend posted $meth
  puthelp "$meth :[mc:who:replace $mc_who(lang:003) [list %who $who %resolve_type $res_t %resolve $resolve]]"
 }; puthelp "WHO $resolve"
}

proc mc:who:display {who} {
 global mc_who
 set posted ""
 if {![info exists mc_who(:post:[string tolower $who]:)]} {
  set mc_who(:post:[string tolower $who]:) ""
 }
 foreach post $mc_who(:post:[string tolower $who]:) {
  set nick [lindex $post 0]; set chan [lindex $post 1]
  switch -- $mc_who(meth) {
   1 {set meth "PRIVMSG $nick"}
   2 {set meth "NOTICE $nick"}
   default {set meth "PRIVMSG $chan"}
  }
  if {[lsearch -exact $posted $meth] != "-1"} {continue}
  lappend posted $meth
  if {![info exists mc_who(:found:)]} {
   puthelp "$meth :[mc:who:replace $mc_who(lang:004) [list %who $who]]"
  } else {
   puthelp "$meth : "
   set i 1
   foreach found $mc_who(:found:) {
    if {$i > $mc_who(limit)} {puthelp "$meth :$mc_who(lang:005)"; break} \
    else {
     puthelp "$meth :[mc:who:replace $mc_who(lang:002) [list %nick [lindex $found 0] %ident [lindex $found 1] %host [lindex $found 2] %away [lindex $found 3] %oper [lindex $found 4] %num $i %total [llength $mc_who(:found:)] %who $who]]"
     incr i 1
    }
   }
  }
 }
 unset mc_who(:post:[string tolower $who]:)
 catch {unset mc_who(:found:)}
 catch {unset mc_who(:dns:[string tolower $who]:)}
 catch {unset mc_who(:post:[string tolower $who]:)}
 catch {unset mc_who(:posted:[string tolower $who]:)}
}

proc mc:who:chanflag {channel flag} {
 if {![validchan $channel]} {return -code error "no such channel record"}
 set list [channel info $channel]
 for {set i 0} {![regexp -- {^[0-9]*:[0-9]*$} [lindex $list $i]]} {incr i} {}
 for {} {[regexp -- {^[0-9]*:[0-9]*$} [lindex $list $i]]} {incr i} {}
 set list [lrange $list $i end]
 foreach info [string tolower $list] {
  if {[string range $info 1 end] != [string tolower $flag]} {continue}
  if {[string index $info 0] == "-"} {
   return 0
  } elseif {[string index $info 0] == "+"} {return 1} else {return 2}
 };return -1
}

proc mc:who:replace {string subs} {
 if {[llength $subs] == "1"} {set subs [lindex $subs 0]}
 for {set i 0} {[lindex $subs $i] != ""} {incr i 2} {
  regsub -all -- [lindex $subs $i] $string [lindex $subs [expr $i+1]] string
 };return $string
}

## SVS v1.3
if {![info exists mc_who(svs:enabled)]} {set mc_who(svs:enabled) 0}
if {($mc_who(svs:enabled) != "0") && ($mc_who(svs:enabled) != "1")} {set mc_who(svs:enabled) 0}
if {![info exists mc_who(svs:check)]} {set mc_who(svs:check) 0}
if {([catch {expr $mc_who(svs:check)+1}]) || (!$mc_who(svs:check))} {
 set mc_who(svs:check) 0
}
if {![info exists mc_who(svs:notify)]} {set mc_who(svs:notify) $owner}
if {![info exists mc_who(svs:stableonly)]} {set mc_who(svs:stableonly) 0}
if {($mc_who(svs:stableonly) != "0") && ($mc_who(svs:stableonly) != "1")} {
 set mc_who(svs:stableonly) 0
}
if {$mc_who(svs:enabled)} {
 if {($mc_who(svs:check) > "23") || ($mc_who(svs:check) < "0")} {set mc_who(svs:check) 00}
 if {[string length $mc_who(svs:check)] == "1"} {set mc_who(svs:check) 0$mc_who(svs:check)}
 if {$mc_who(svs:stableonly)} {
  set mc_who(svs:script) [string range $mc_who(svs:script) 0 [expr [string length $mc_who(svs:script)]-4]]999
 }
 catch {unbind time - "00 $mc_who(svs:oldcheck) * * *" mc:who:svs:time}
 set mc_who(svs:oldcheck) $mc_who(svs:check)
 bind time - "00 $mc_who(svs:check) * * *" mc:who:svs:time
 proc mc:who:svs:time {min hour day month year} {
  global mc_who
  catch {control [connect [lindex $mc_who(svs:server) 0] [lindex $mc_who(svs:server) 1]] mc:who:svs:interface}
 }
}
proc mc:who:svs:interface {idx args} {
 global mc_who;set args [join $args]
 switch -- [lindex $args 0] {
  "" {return 1}
  000 {putdcc $idx q}
  002 {putdcc $idx [lindex $mc_who(svs:script) 0]}
  003 {
   set args [lrange $args 1 e]
   if {[lindex $args 0] != [lindex $mc_who(svs:script) 0]} {return 0}
   putdcc $idx q
   if {[lindex $args 1] > [lindex $mc_who(svs:script) 1]} {
    set note [mc:who:replace [lindex $args 7] "%0 {[lindex $args 0]} %1 {[lindex $args 1]} %2 {[lindex $args 2]}"]
    set note [mc:who:replace $note "%3 {[lindex $args 3]} %4 {[lindex $args 4]} %5 {[lindex $args 5]}"]
    set note [mc:who:replace $note "%6 {[lindex $args 6]} %8 {[lindex $args 8]} %version {$mc_who(version)}"]
    set note [mc:who:replace $note "%9 {[lindex $args 9]} %10 {[lindex $args 10]} %11 {[lindex $args 11]}"]
    set note [mc:who:replace $note "%12 {[lindex $args 12]} %13 {[lindex $args 13]} %14 {[lindex $args 14]}"]
    set note [mc:who:replace $note "%15 {[lindex $args 15]} %16 {[lindex $args 16]} %17 {[lindex $args 17]}"]
    set note [mc:who:replace $note "%18 {[lindex $args 18]} %19 {[lindex $args 19]} %20 {[lindex $args 20]}"]
    foreach notify [join [split $mc_who(svs:notify) ",;"]] {
     set outnote [mc:who:replace $note "%nick {$notify}"]
     if {[string match "*$outnote*" "[notes $notify -[notes $notify]]"]} {
      set cont 0
      foreach unote [notes $notify -[notes $notify]] {
       if {$outnote == [lindex $unote 2]} {set cont 1;break}
      };if {$cont} {continue}
     }
     switch -- [sendnote SVS $notify $outnote] {
      0 {
       if {![validuser $notify]} {set x "invalid user"} else {set x "unknown reason"}
       putlog "MC SVS for [lindex $mc_bw(svs:script) 0] had some errors updating $notify on current version of script; $x"
      }
      3 {putlog "MC SVS for [lindex $mc_bw(svs:script) 0] had some errors updating $notify on current version of script; notebox too full!"}
     }
    }
   }
  }
 };return 0
}
## ^

putlog "Who $mc_who(version) by MC_8 loaded."
