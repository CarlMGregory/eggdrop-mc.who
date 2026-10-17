##
# Who v2.1.3 by MC_8 - Carl M. Gregory <mc8@purehype.net>
#  This script will only work on eggdrop 1.5.5 or greater.
#
# My SVS Website - http://mc.purehype.net:81/
##

##
# This script will perform 'who' lookup via IRC then display it's
# results.  If there are no matches found it will try and DNS your
# entry then 'who' that as well.
##

##
# HISTORY  ( <Fixed by> - [Found by] - <Info> )
##
# v2.1.3 (01.13.02)
#  MC_8 - - Added error catching system, gives a good debug for bug
#           reports.
#  MC_8 - - Adjusted some minor things, possibly causing bugs in older
#           tcl versions.
#  MC_8 - - Updated the replace procedure.
#
# v2.1.2 (11.17.01)
#  MC_8 - - Updated SVS from v1.3 to v2.0.
#
# v2.1.1 (11.10.01)
#  MC_8 -        - Fixed special character handeling when being dns'd
#                  after not being found by a server WHO.
#  MC_8 - fudded - Script was reacting to wild card triggers (ie, a *).
#
# v2.1 (11.07.01)
#  MC_8 - - Updated SVS from v1.1 to v1.3.
#  MC_8 - - Recoded the whole script.  It was old and ugly.
#
# v2.0.1 (03.17.01)
#  MC_8 - Liar - The bot was repsonding to * and ? as if it were a
#                trigger as well, fixed.
#  MC_8 -      - Fixed problem with returning resolved information,
#                problem with upper cased characters within hostnames.
#  MC_8 -      - Fixed, 'Tcl error [mc:who:trigger]: bad option 
#                "tolwoer": must be bytelength, compare, equal, first,
#                index, is, last, length, map, match, range, repeat,
#                replace, tolower, toupper, totitle, trim, trimleft,
#                trimright, wordend, or wordstart'.
#
# v2.0 (02.02.01)
#  MC_8 - - Added ability to specify what channels this script is to be
#           active on.  It explains how to do this feature below in the
#           settings section of this script.
#  MC_8 - - Added SVS
#  MC_8 - - Added ignore flag'd users option.
#  MC_8 - - This script will work on eggdrop 1.5.1 or above only.
#  MC_8 - - Can perform many who's simultaneously.
#  MC_8 - - Script uses egdrop's internal dns lookup module, better
#           pervents the bot lagging up.
#  MC_8 - - Added ability to specify more than just 1 trigger.
#  MC_8 - - Made script independent of moretools.
#
# v1.2  (12.31.99)
#  MC_8 - - Fixed the " ***WHO [!who] NOT loaded, please load
#           moretools.tcl v1.0.1+ " even though it was loaded.
#
# v1.0-1.1  (??.??.99)
#  MC_8 - AZ0R0S - Inital releases.
##

##
# Settings
##

# Note:
#  There is one setting you set from dcc chat with the bot using
#  .chanset.
#   <+/->mc.who  Setting this to +mc.who on the specific channel will 
#                enable the channel to to use this script.
#
#  Example from dcc chat with the bot:
#   .chanset #channel +mc.who

# What trigger(s) do you want this script to function on?  Seperate 
# each different trigger with a space.
set mc_who(trigger) "!who `who -who"

# What flaged users should have access to the commands?  Set to "-|-" 
# to allow anyone to access the commands.  Set to "" for registered 
# users only (users added to the bot via .+user or .adduser).  Flag 
# structure is <global>|<channel>
set mc_who(flags) "ovs|ovs"

# What flaged users should NOT have access to the commands?  Set to 
# "-|-" to ignore registered users (users added to the bot via .+user 
# or .adduser).  Set to "" to turn this feature off.  Flag structur is 
# <global>|<channel>
set mc_who(ign:flags) "kb|kb"

# What's the max. limit of results you want to post?
set mc_who(limit) 4

# How do you want the script to display the results?
#  0 = MSG publicly to channel
#  1 = MSG privately to the user
#  2 = NOTICE privately to the user
set mc_who(meth) 0


## MC SVS (Script Version Service) v2.0 ##
# [0=no/1=yes] Do you want the bot to connection to MC_8's SVS to see 
# if there are newer versions of this script avilable?  It will only 
# tell you -- It's up to you to get the newest version (I decided not 
# to auto update the code, there may be new features in the newest 
# script that may require your attention).
set mc_who(svs:enabled) 1

# Once a day the script will check with the SVS -- this specifies when
# that should happen.  The setting should be the hour (military).
# examples:
#  set mc_who(svs:check) 0   ;#This is at Midnight
#  set mc_who(svs:check) 5   ;#This is at 5am
#  set mc_who(svs:check) 13  ;#This is at 1pm
#  set mc_who(svs:check) 23  ;#This is at 11pm
set mc_who(svs:check) 3

# Upon finding a newer version of this script, who do you want this 
# script to send a note to telling them of this newer version?  If more 
# than 1 user is to be notified, seperate each user with a ' ' (space).
set mc_who(svs:notify) "MC_8"

# Do you want even beta version notified to whomever you have set?  Or 
# just stable releases of the script?
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

set mc_who(script)      "Who"
set mc_who(version)     "v2.1.3"
set mc_who(svs:script)  "who"
set mc_who(svs:version) "002001003000"
set mc_who(svs:server)  "mc.purehype.net"
set mc_who(svs:port)    "81"
set mc_who(svs:get)     "/"
set mc_who(svs:query)   "svs=$mc_who(svs:script)&version=$mc_who(svs:version)"

if {$numversion < "1050500"} {
 putlog "$mc_who(script) $mc_who(version) by MC_8 will only work on eggdrop 1.5.5 or greater."
 putlog "$mc_who(script) $mc_who(version)  will not work with eggdrop $version."
 putlog "$mc_who(script) $mc_who(version)  not loaded."
 return 1
}

setudef flag mc.who

proc mc:who:error {bindproc error {arg ""}} {
 global mc_who version lastbind
 putlog "Error in script $mc_who(script) $mc_who(version)."
 putlog "       Last bind: $lastbind"
 putlog "       Procedure: $bindproc"
 putlog "            Args: $arg"
 putlog " Eggdrop version: $version"
 putlog "     TCL version: [info tclversion]"
 putlog "*** Please email this bug information to MC_8, his latest"
 putlog "*** email address should be on http://mc.purehype.net:81/"
 putlog "*** Please include the next line in the email as well."
 error $error
}

proc mc:who:errchk {command arg} {
 if {[catch {eval $command $arg} return]} {
  mc:who:error $command $return $arg; return 0
 }; return $return
}

set temp 0
foreach mod [modules] {if {[lindex $mod 0] == "dns"} {set temp 1 ; break}}
if {!$temp} {loadmodule dns}
set temp 0
foreach mod [modules] {if {[lindex $mod 0] == "dns"} {set temp 1 ; break}}
if {!$temp} {
 putlog "$mc_who(script) $mc_who(version) by MC_8 could not be loaded:  DNS module will not load."
 return 1
}

bind pubm - * mc:who:pubm
proc mc:who:pubm {nick uhost hand chan arg} {
 return [mc:who:errchk mc:who:pubm_ [list $nick $uhost $hand $chan $arg]]
}
proc mc:who:pubm_ {nick uhost hand chan arg} {
 global mc_who
 scan $arg "%s %s" cmd who
 if {(![mc:who:chanflag $chan mc.who]) ||
     ((![matchattr $hand $mc_who(flags) $chan]) && ($mc_who(flags) != "-|-")) ||
     (([matchattr $hand $mc_who(ign:flags) $chan]) && ($mc_who(ign:flags) != "")) ||
     ([lsearch -exact [string tolower $mc_who(trigger)] [string tolower $cmd]] == "-1") ||
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
 return [mc:who:errchk mc:who:evnt_ [list $type]]
}
proc mc:who:evnt_ {type} {
 global mc_who
 foreach array [array names mc_who] {
  if {[regexp -- {^:} $array]} {unset mc_who($array)}
 }
}

bind raw - 315 mc:who:raw
bind raw - 352 mc:who:raw
proc mc:who:raw {server num arg} {
 return [mc:who:errchk mc:who:raw_ [list $server $num $arg]]
}
proc mc:who:raw_ {server num arg} {
 global mc_who
 switch -- $num {
  352 {
   scan "$arg\015" "%s %s %s %s %s %s %s %s %\[^\015\]\015" a chan ident host server nick status hop name
   set away "Not Away"; if {[string index [string tolower $status] 0] == "g"} {set away "Away"}
   set oper "Regular User"; if {[string index [string tolower $status] 1] == "*"} {set oper "IRC Operator"}
   lappend mc_who(:found:) [list $nick $ident $host $away $oper]
  }
  315 {
   scan $arg "%s %s" a who
   if {![info exists mc_who(:post:[string tolower $who]:)]} {
    set mc_who(:post:[string tolower $who]:) ""
   }
   if {![info exists mc_who(:found:)]} {dnslookup [list $who] mc:who:dnslookup [list $who]} \
   else {mc:who:display $who}
  }
 }; return 0
}

proc mc:who:dnslookup {ip host status who} {
 global mc_who
 if {!$status} {mc:who:display $who; return}
 if {$who == $ip} {set resolve $host;set res_t host} \
 else {set resolve $ip; set res_t ip}
 if {![info exists mc_who(:dns:[string tolower $who]:)]} {set mc_who(:dns:[string tolower $who]:) ""}
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

# v1.0
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
# v1.0
proc mc:who:replace {text subs} {
 if {![catch {string map -nocase $subs $text} output]} {return $output}
 for {set i 0} {[lindex $subs $i] != ""} {incr i 2} {
  regsub -all -- [lindex $subs $i] $text [lindex $subs [expr $i+1]] text
 }; return $text
}

## SVS v2.0
if {(![info exists mc_who(svs:enabled)]) ||
    (![regexp -- {^(0|1)$} $mc_who(svs:enabled)])} {set mc_who(svs:enabled) 0}
if {(![info exists mc_who(svs:check)]) ||
    ([regexp -- {[^0-9]} $mc_who(svs:check)])} {set mc_who(svs:check) 0}
if {![info exists mc_who(svs:notify)]} {set mc_who(svs:notify) $owner}
if {(![info exists mc_who(svs:stableonly)]) ||
    (![regexp -- {^(0|1)$} $mc_who(svs:stableonly)])} {set mc_who(svs:stableonly) 0}
foreach bind [binds mc:who:svs:time] {
 unbind [lindex $bind 0] [lindex $bind 1] [lindex $bind 2] [lindex $bind 4]
}
foreach command [info commands mc:who:svs:time] {rename $command ""}
if {$mc_who(svs:enabled)} {
 if {($mc_who(svs:check) > "23") || ($mc_who(svs:check) < "0")} {set mc_who(svs:check) 00}
 if {[string length $mc_who(svs:check)] == "1"} {set mc_who(svs:check) 0$mc_who(svs:check)}
 bind time - "00 $mc_who(svs:check) *" mc:who:svs:time
 proc mc:who:svs:time {{args ""}} {
  global mc_who
  if {[catch {socket -async $mc_who(svs:server) $mc_who(svs:port)} sid]} {;\
   putlog "SVS Error\[$mc_who(svs:script)/$mc_who(svs:version)\]:  $sid"
   return 1
  }
  fconfigure $sid -blocking 0 -buffering line
  set tout [after 60000 "mc:who:svs:interface $sid timeout"]
  fileevent $sid readable "mc:who:svs:interface $sid $tout"
  puts $sid "GET $mc_who(svs:get)?$mc_who(svs:query) HTTP/1.0\
           \nHost: $mc_who(svs:server)\n"
  flush $sid
 }
}
proc mc:who:svs:interface {sid tout} {
 global mc_who
 if {$tout == "timeout"} {
  putlog "SVS Warning\[$mc_who(svs:script)/$mc_who(svs:version)\]:  SVS Server timed out."
  close $sid
  return 0
 }; after cancel $tout
 set temp 0
 while {![eof $sid]} {
  gets $sid get
  if {$temp < "2"} {
   if {$get == ""} {incr temp; if {$temp == "1"} {set temp 2}}
   continue
  }; if {$get == ""} {continue}
  switch -- [lindex $get 0] {
   003 {
    set reply [lrange $get 1 end]
    if {[lindex $reply 0] != $mc_who(svs:script)} {
     putlog "SVS Error\[$mc_who(svs:script)/$mc_who(svs:version)\]:  SVS Server sent wrong info, got [lindex $reply 0]"
     break   
    }
    if {$mc_who(svs:stableonly)} {
     set temp [string range $mc_who(svs:version) 0 8]999
    } else {set temp [string range $mc_who(svs:version) 0 11]}
    if {[lindex $reply 1] > $temp} {
     set note [lindex $reply 5]
     regsub -- %0 $note [lindex $reply 0] note
     regsub -- %1 $note [lindex $reply 1] note
     regsub -- %2 $note [lindex $reply 2] note
     regsub -- %3 $note [lindex $reply 3] note
     regsub -- %4 $note [lindex $reply 4] note
     regsub -- %version $note $mc_who(version) note
     foreach to [split $mc_who(svs:notify) ",; "] {
      if {$to == ""} {continue}
      regsub -- %nick $note $to outnote
      if {[string match *$outnote* [set unotes [notes $to -[notes $to]]]]} {
       set temp 0
       foreach unote $unotes {
        if {$outnote == [lindex $unote 2]} {set temp 1; break}
       }; if {$temp} {continue}
      }
      switch -- [sendnote SVS $to $outnote] {
       0 {
        if {![validuser $notify]} {set x "invalid user"} else {set x "unknown error"}
        putlog "SVS Error\[$mc_who(svs:script)/$mc_who(svs:version)\]:  Trying to send note to $to, $x."
       }
       3 {putlog "SVS Error\[$mc_who(svs:script)/$mc_who(svs:version)\]:  Trying to send note to $to, notebox too full!"}
      }
     }
    }
   }
  }
 }; close $sid
}
## ^

putlog "$mc_who(script) $mc_who(version) by MC_8 loaded."
