##
# Who v3.0
#  by MC_8 - Carl M. Gregory <mc8@purehype.net>
#  This script will only run on eggdrop 1.5.5 or greater.
#  This script will only run with the dns module compiled.
#
#    R.I.P. Mom, To always be remembered; Nancy Marie Gregory.
#
# My Website - http://mc.purehype.net:81/
# Have a bug?  http://mc.purehype.net:81/bugzilla/
##

##
# This script will perform 'who' lookup via IRC then display it's results.  If
# there are no matches found it will try and DNS your entry then 'who' that as
# well.
##

##
# Commands
##
# DCC:
#   chanset <channel> <+/->mc.who
#     This will enable, +, or disable, -, the script for the particular channel.
#
# PUB:
#   <trigger> <lookup>
#     This preforms a WHO lookup on <lookup>.  The <trigger> is specified below
#     in the configurations section.
##

##
# Configurations
##
#

# What trigger(s) do you want this script to function on?  Seperate each
# different trigger with a space.
set mc_who(trigger) "!who `who -who"

# What flaged users should have access to the commands?  Set to "-|-" to allow
# anyone to access the commands.  Flag structure is <global>|<channel>
set mc_who(flags) "ovs|ovs"

# What flaged users should NOT have access to the commands?  Set to "" to turn
# this feature off.  Flag structur is <global>|<channel>
set mc_who(ign:flags) "kb|kb"

# What's the max. limit of results you want to post?
set mc_who(limit) 4

# Language
#   These can be multi line, seperate each command with a new line.
#   Valid commands:
#     /msg <nick|channel> <text>    - Sends a message to <nick|channel>.
#     /notice <nick|channel> <text> - Sends a notice to <nick|channel>.
#   Valid replacments:
#     %nick         - The nick that triggered the command.
#     %ident        - The ident of the nick that triggered the command.
#     %host         - The hostname or IP of the nick that triggered the command.
#     %channel      - The channel the command was triggered in.
#     %lookup       - This is the what the nick requested be looked up via WHO.
#     %number       - The current number that's being displayed.
#     %total        - The total matches found from WHO.
#     %found_nick   - The nick of the person found from the WHO lookup.
#     %found_ident  - The ident of the person found from the WHO lookup.
#     %found_host   - The hostname or IP of the person found from the WHO
#                     lookup.
#     %found_away   - If the found nick is away or not.  Will either be 'Away'
#                     or 'Not Away'.
#     %found_status - Will be the status of the nick found.  Will either be
#                     'Regular User' or 'IRC Operator'.
#     %resolve_host - Should the WHO lookup find no match, it will try and DNS
#                     the lookup.  This will be replace to what it resolves to,
#                     should it resolve.
#     %resolved_as  - If the WHO lookup was an ip, this will be 'host'.
#                     If the WHO lookup was a hostname, this will be 'ip'.
#                     Assuming it resolves, of course.
#--
# What do you want said when first doing a /who lookup?
# who=lookup
set mc_who(lang:start_of_post) {
  /msg %channel Looking up %lookup ...
}
#--
# How you want the found results to be displayed?
# num=number, total, who=lookup, nick=found_nick, ident=found_ident,
# host=found_host, away=found_away, oper=found_status
set mc_who(lang:post) {
  /msg %channel (%number/%total) %lookup> %found_nick (%found_ident@%found_host) [%found_away / %found_status]
}
#--
# What do you want to state when no matches were found, but you were able to
# resolve the lookup and are about to do a WHO lookup on that.
# who=lookup, resolve_type=resolve_as, resolve
set mc_who(lang:tring_resolve) {
  /msg %channel No matches found for %lookup, trying resolved %resolved_as: %resolve_host ...
}
#--
# What do you want to say if you could find no matches to the WHO lookup?
# who=lookup
set mc_who(lang:not_found) {
  /msg %channel %lookup not found.
}
#--
# What do you want to state when the query has been truncated?
set mc_who(lang:truncated) {
  /msg %channel Too many lines in the output, query truncated.
}
#--
# What do you want to say at the end of the post?
set mc_who(lang:end_of_post) {
}


## SVS Client (Script Version Service) v3.2.1 ##
# Once a day, the SVS Client will connect to MC_8's SVS Server to determine if
# there is a newer version of this script available.  This will only notify
# users of the new version via a note.  It's up to the owner of the bot to
# download, adjust settings then install the script.

# If a newer version is found, whom do you want to notify?  The notification is
# sent via a note.  Seperate each user with a space, or set this to "" to
# disable SVS notification.  For those whom know TCL; do not put this in list
# format, keep it in string format.
set mc_who(svs:notify) "MC_8"

# Would you like to restrict the concept of a new version to stable releases
# only?
#   0 = No, inform of both stable and beta release versions.
#   1 = Yes, inform of only stable release versions.
set mc_who(svs:mode) 0


#
##

##
# Done with configurations, do not edit past here unless you know TCL.
##
#

#Script:mc_who

set mc_who(script)      "Who"
set mc_who(version)     "v3.0"
set mc_who(svs:script)  "who"
set mc_who(svs:version) "003000000000"
set mc_who(svs:server)  "mc.svs.purehype.net"
set mc_who(svs:port)    "81"
set mc_who(svs:get)     "/index.tcl"
set mc_who(svs:query)   "svs=$mc_who(svs:script)&version=$mc_who(svs:version)"

catch {unset temp}
if {![info exists numversion] || ($numversion < "1050500")} {
  set temp(tag) "$mc_who(script) $mc_who(version)"
  putlog "$temp(tag) by MC_8 will only work on eggdrop 1.5.5 or greater."
  putlog "$temp(tag)  will not work with eggdrop $version."
  putlog "$temp(tag)  not loaded."
  return 1
}

setudef flag mc.who


# Error system, v3.0
proc mc:who:error {command error arg} {
  global mc_who version lastbind errorInfo
  putlog "Error in script $mc_who(script) $mc_who(version)."
  putlog "    Error System: v3.0"
  putlog "       Last Bind: [expr {[info exists lastbind]?$lastbind:"-NULL-"}]"
  putlog "         Command: $command"
  putlog "       Arguments: $arg"
  putlog "       Error Msg: $error"
  putlog "    Egg. Version: [expr {[info exists version]?$version:"-NULL-"}]"
  putlog "     TCL Version: [info tclversion]"
  putlog "  TCL Patchlevel: [info patchlevel]"
  putlog "*** Please submit this bug so MC_8 can fix it.  Visit"
  putlog "*** http://mc.purehype.net:81/bugzilla/ to properly report the bug."
  putlog \
    "*** Please include ALL info. in the bug report, including the next(s)."
  error $errorInfo
}

proc mc:who:errchk {command arg} {
  if {![catch {eval $command $arg} return]} {return $return}
  mc:who:error $command $return $arg
  return 0
}
# ^


set temp() 0
foreach temp(module) [modules] {
  if {[lindex $temp(module) 0] == "dns"} {
    set temp() 1
    break
  }
}
if {!$temp()} {loadmodule dns}
set temp() 0
foreach temp(module) [modules] {
  if {[lindex $temp(module) 0] == "dns"} {
    set temp() 1
    break
  }
}
if {!$temp()} {
  set temp(tag) "$mc_who(script) $mc_who(version)"
  putlog "$temp(tag) by MC_8 could not be loaded:  DNS module will not load."
  return 1
}

# Reset the binds on script load -- (re)?(hash|start).  Possible script owner
# changed the `trigger` configuration variable.
foreach temp(bind) [binds mc:who:pub] {
  unbind [lindex $temp(bind) 0] [lindex $temp(bind) 1] [lindex $temp(bind) 2] \
    [lindex $temp(bind) 4]
}
foreach temp(trigger) [split $mc_who(trigger)] {
  bind pub $mc_who(flags) $temp(trigger) mc:who:pub
}
# ^

proc mc:who:pub {nick uhost handle channel arg} {
  return [mc:who:errchk mc:who:pub_ [list $nick $uhost $handle $channel $arg]]
}
proc mc:who:pub_ {nick uhost handle channel arg} {
  global mc_who

  if {(![mc:who:chanflag $channel mc.who]) ||
      (($mc_who(ign:flags) != "") &&
       ([matchattr $handle $mc_who(ign:flags) $channel]))} {
    return 0
  }

  set lookup [lindex [split $arg] 0]
  set temp(post) [mc:who:list replace $mc_who(lang:start_of_post)]
  mc:who:list add_query [list $lookup $nick $channel $temp(post)]
}

bind evnt - init-server mc:who:evnt
proc mc:who:evnt {type} {
  return [mc:who:errchk mc:who:evnt_ [list $type]]
}
proc mc:who:evnt_ {type} {
  global mc_who
  foreach array [array names mc_who :*] {
    unset mc_who($array)
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
      # gatechk #chan mc8 hostname *.undernet.org MC_8 H+x :3 Carl M. Gregory
      mc:who:unlist [split $arg] "" "" ident host "" nick status
      set status [string tolower $status]

      set away "Not Away"
      if {[string index $status 0] == "g"} {set away "Away"}

      set oper "Regular User"
      if {[string index $status 1] == "*"} {set oper "IRC Operator"}

      lappend mc_who(:found:) [list $nick $ident $host $away $oper]
    }

    315 {
      # gatechk MC_8 :End of /WHO list.
      mc:who:unlist [split $arg] botnick lookup

      if {![info exists mc_who(:found:)]} {
        dnslookup [list $lookup] mc:who:dnslookup [list $lookup]
      } else {
        mc:who:list display $lookup
      }
    }

  }; return 0
}

proc mc:who:dnslookup {ip host status lookup} {
  return [mc:who:errchk mc:who:dnslookup_ [list $ip $host $status $lookup]]
}
proc mc:who:dnslookup_ {ip host status lookup} {
  global mc_who

  if {!$status} {
    mc:who:list display $lookup
    return 0
  }

  if {$lookup == $ip} {
    set resolve $host
    set resolved_as host
  } else {
    set resolve $ip
    set resolved_as ip
  }

  set llookup [string tolower $lookup]
  set lresolve [string tolower $resolve]

  if {![info exists mc_who(:dns:$llookup)]} {set mc_who(:dns:$llookup) ""}

  if {[lsearch -exact $mc_who(:dns:$llookup) $lresolve] != "-1"} {
    mc:who:list display $lookup
    return 1
  }

  mc:who:list reset [list $llookup $lresolve]
  lappend mc_who(:dns:$lresolve) $llookup

  foreach temp(entry) [mc:who:list get_query $lresolve] {
    mc:who:unlist $temp(entry) nick channel

    set temp(post) [mc:who:list replace $mc_who(lang:tring_resolve)]
    mc:who:list post [list $lresolve $temp(post)]
  }
  putserv "WHO $resolve"
}

proc mc:who:list {command {arg ""}} {
  return [mc:who:errchk mc:who:list_ [list $command $arg]]
}
proc mc:who:list_ {command arg} {
  global mc_who
  switch -- $command {

    "replace" {
      set nick [uplevel 3 {expr {[info exists nick]?$nick:""}}]
      set uhost [uplevel 3 {expr {[info exists uhost]?$uhost:""}}]
      set split_uhost [split $uhost @]
      set ident [join [lrange $split_uhost 0 [expr [llength $split_uhost]-2]] @]
      set host [lindex $split_uhost end]
      set channel [uplevel 3 {expr {[info exists channel]?$channel:""}}]
      set lookup [uplevel 3 {expr {[info exists lookup]?$lookup:""}}]
      set number [uplevel 3 {expr {[info exists number]?$number:""}}]
      set total [uplevel 3 {expr {[info exists total]?$total:""}}]
      set found_nick [uplevel 3 {
        expr {[info exists found_nick]?$found_nick:""}}]
      set found_ident [uplevel 3 {expr {[info exists found_ident]?
        $found_ident:""}}]
      set found_host [uplevel 3 {
        expr {[info exists found_host]?$found_host:""}}]
      set found_away [uplevel 3 {
        expr {[info exists found_away]?$found_away:""}}]
      set found_status [uplevel 3 {expr {[info exists found_status]?
        $found_status:""}}]
      set resolve [uplevel 3 {expr {[info exists resolve]?$resolve:""}}]
      set resolved_as [uplevel 3 {expr {[info exists resolved_as]?
        $resolved_as:""}}]
      return [mc:who:replace -- $arg [list \
        %nick         $nick \
        %ident        $ident \
        %host         $host \
        %channel      $channel \
        %lookup       $lookup \
        %number       $number \
        %total        $total \
        %found_nick   $found_nick \
        %found_ident  $found_ident \
        %found_host   $found_host \
        %found_away   $found_away \
        %found_status $found_status \
        %resolve_host $resolve \
        %resolved_as  $resolved_as]]
    }

    "add_query" {
      mc:who:unlist $arg lookup nick channel post
      set llookup [string tolower $lookup]
      set nick [string tolower $nick]
      set channel [string tolower $channel]
      set list [list $nick $channel]

      if {![info exists mc_who(:query:$llookup)]} {
        lappend mc_who(:query:$llookup) $list
        set do 1
        putserv "WHO $lookup"
      } \
      elseif {[lsearch -exact $mc_who(:query:$llookup) $list] == "-1"} {
        lappend mc_who(:query:$llookup) $list
        set do 1
      } \
      else {
        set do 0
      }

      if {$do} {
        mc:who:list post [list $llookup $post]
      }
    }

    "get_query" {
      return [expr {[info exists mc_who(:query:$arg)]?$mc_who(:query:$arg):""}]
    }

    "post" {
      mc:who:unlist $arg llookup post

      if {![info exists mc_who(:posted:$llookup)]} {
        set mc_who(:posted:$llookup) ""
      }

      foreach temp(line) [split $post \n] {
        set temp(line) [string trim $temp(line) " \t"]
        if {$temp(line) == ""} {continue}
        set temp(line) [split $temp(line)]
        set temp(to) [lindex $temp(line) 1]
        set temp(msg) [join [lrange $temp(line) 2 end]]
        switch -- [string tolower [lindex $temp(line) 0]] {
          "/msg" {set temp(method) "PRIVMSG"}
          "/notice" {set temp(method) "NOTICE"}
        }
        set do "$temp(method) $temp(to) :$temp(msg)"
        if {[lsearch -exact mc_who(:posted:$llookup) $do] == "-1"} {
          putserv $do
          lappend mc_who(:posted:$llookup) $do
        }
      }
    }

    "unset" {
      foreach temp(array_name) [array names mc_who :*:$arg] {
        unset mc_who($temp(array_name))
      }
      catch {unset mc_who(:found:)}
    }

    "reset" {
      mc:who:unlist $arg llookup lresolve

      foreach temp(array_name) [array names mc_who :*:$llookup] {
        regexp -- {^:([^:]*):(.*)$} $temp(array_name) -> name host
        set mc_who(:$name:$lresolve) $mc_who(:$name:$host)
        unset mc_who(:$name:$host)
      }
    }

    "display" {
      set lookup $arg
      set llookup [string tolower $lookup]

      set total [expr {[info exists mc_who(:found:)]?
        [llength $mc_who(:found:)]:0}]

      foreach temp(entry) [mc:who:list get_query $llookup] {
        mc:who:unlist $temp(entry) nick channel
        if {![info exists mc_who(:found:)]} {
          set temp(post) [mc:who:list replace $mc_who(lang:not_found)]
          mc:who:list post [list $llookup $temp(post)]
          continue
        }
        set number 1
        foreach temp(found) $mc_who(:found:) {
          set found_nick [lindex $temp(found) 0]
          set found_ident [lindex $temp(found) 1]
          set found_host [lindex $temp(found) 2]
          set found_away [lindex $temp(found) 3]
          set found_status [lindex $temp(found) 4]
          if {$number > $mc_who(limit)} {
            set temp(post) [mc:who:list replace $mc_who(lang:truncated)]
            mc:who:list post [list $llookup $temp(post)]
            break
          }
          set temp(post) [mc:who:list replace $mc_who(lang:post)]
          mc:who:list post [list $llookup $temp(post)]
          incr number
        }
      }
      mc:who:list unset $llookup
    }

  }
}


## More Tools quick procs.
## -- http://mc.purehype.net:81/script_info.tcl?script=moretools

# badargs <args> <min_llength> <max_llength|end> <argNames>
#     version:
#       v1.0
proc mc:who:badargs {{args ""}} {
  if {[llength $args] < 4} {
    error {
  wrong # args: should be "mc:who:badargs args min_llength max_llength argNames"
    }
  }

  set index 0
  foreach varName [list args min max names] {
    set check_$varName [lindex $args $index]
    incr index
  }

  if {[regexp -- {([^0-9])} $check_min -> bad]} {
    error "bad number \"$bad\" in: $check_min"
  }
  if {[regexp -- {([^0-9])} $check_max -> bad] && ($check_max != "end")} {
    error "bad number \"$bad\" in: $check_max"
  }

  # Make sure $check_args is in list format, if not then make it so.
  # Were not going to use 2list here, don't want to evoke a 'too many nested
  # calls to Tcl_EvalObj' error since '2list' uses on this proc.
  if {[catch {llength $check_args} llength]} {
    set check_args [split $check_args]
    set llength $check_args
  }

  if {($llength < $check_min) || (($llength != "end") &&
      ($llength > $check_max))} {
    if {[info level] == "1"} {return 1}
    error "wrong # args: should be \"[lindex [info level -1] 0] $check_names\""
  }; return 0
}

# 2list <text>
#     version:
#       v1.0
proc mc:who:2list {{args ""}} {
  mc:who:badargs $args 1 1 "text"
  mc:who:unlist $args text

  return [expr {([catch {llength $text}])?[split $text]:$text}]
}

# unlist <argsList> [varName1] [varName2] ... [varNameN]
#     version:
#       v1.0
proc mc:who:unlist {{args ""}} {
  mc:who:badargs $args 1 end "argsList ?varName varName ...?"
  set argList [lindex $args 0]
  set argList [expr {([catch {llength $argList}])?[split $argList]:$argList}]
  set argNames [lrange $args 1 end]
  if {![llength $argNames]} {
    return [expr {(![catch {llength $argList}])?
      [join $argList]:$argList}]
  }
  for {set index 0} {$index < [llength $argNames]} {incr index 1} {
    set argName     [lindex $argNames $index]
    set argListItem [lindex $argList  $index]

    set argName_ [expr {([catch {llength $argName}])?[split $argName]:$argName}]
    set setTo   [lindex $argName_ 1]
    set argName [lindex $argName_ 0]

    if {$argName == ""} {continue}

    upvar 1 $argName var

    if {[expr $index+1] > [llength $argList]} {
      if {[llength $argName_] == "2"} {set var $setTo}
    } else {
      if {$argName == "args"} {
        set var [lrange $argList $index end]
        incr index [expr [llength $var]-1]
      } else {set var $argListItem}
    }
  }; return $index
}

# chanflag <channel> <flag>
#     version:
#       v3.1
proc mc:who:chanflag {{args ""}} {
  mc:who:badargs $args 2 2 "channel flag"
  mc:who:unlist $args channel flag

  if {![validchan $channel]} {error "no such channel record"}

  # Try the 'channel' commands' 'get' option first, it's faster since it is
  # written in C by the eggdrop development team.
  if {![catch {channel get $channel $flag} output]} {return $output}

  set temp(chaninfo) [string tolower [channel info $channel]]
  if {[lsearch -exact $temp(chaninfo) +[string tolower $flag]] >= "0"} {
    return 1
  }; return 0
}

# replace [switches] <text> <substitutions>
#     version:
#       v1.3
proc mc:who:replace {{args ""}} {
  mc:who:badargs $args 2 4 "?switches? text substitutions"
  set switches ""
  for {set i 0} {[string match -* [set arg [lindex $args $i]]]} {incr i} {
    if {![regexp -- {^-(nocase|-)$} $arg -> switch]} {
      error "bad switch \"$arg\": must be -nocase, or --"
    }
    if {$switch == "-"} {
      incr i
      break
    }; lappend switches $switch
  }
  set nocase [expr {([lsearch -exact $switches "nocase"] >= "0") ? 1 : 0}]
  set text [lindex $args $i]
  set substitutions [lindex $args [expr $i+1]]
  mc:who:badargs [lrange $args $i end] 2 2 "?switches? text substitutions"

  # Check to see if $substitutions is in list format, if not make it so.
  set substitutions [mc:who:2list $substitutions]

  if {[info tclversion] >= "8.1"} {
    return [expr {($nocase)?
      [string map -nocase $substitutions $text]:
      [string map $substitutions $text]}]
  }

  set re_syntax {([][\\\*\+\?\{\}\,\(\)\:\.\^\$\=\!\|])}
  foreach {a b} $substitutions {
    regsub -all -- $re_syntax $a {\\\1} a
    if {$nocase} {regsub -all -nocase -- $a $text $b text} \
    else {regsub -all -- $a $text $b text}
  }; return $text
}

## End of More Tools quick procs.


## SVS v3.2.1
set mc_who(svs:client_version) "v3.2.1"
if {![info exists mc_who(svs:mode)] ||
    ![regexp -- {^(1|0)$} $mc_who(svs:mode)]} {
  set mc_who(svs:mode) 0
}
if {![info exists mc_who(svs:notify)]} {
  if {![info exists owner]} {set owner ""}
  set mc_who(svs:notify) $owner
}

bind time - "00 00 *" mc:who:do_svs
proc mc:who:do_svs {{args ""}} {
  global mc_who
  mc:who:do_svs_ $mc_who(svs:server) $mc_who(svs:port) $mc_who(svs:get)
}

proc mc:who:do_svs_ {svs_server svs_port svs_get} {
  global mc_who
  if {[catch {
          socket -async $svs_server $svs_port
             } sid]} {
    putloglev d * "$mc_who(script): SVS socket error: $sid"
    return 1
  }

  fconfigure $sid -blocking 1 -buffering line
  set tout \
    [after 60000 "mc:who:svs_talk $sid timeout $svs_server $svs_port"]
  fileevent $sid readable "mc:who:svs_talk $sid $tout"
  puts $sid "GET $svs_get?$mc_who(svs:query) HTTP/1.0\
           \nHost: $svs_server:$svs_port\n"
  flush $sid
}

proc mc:who:svs_talk {sid tout {svs_server ""} {svs_port ""}} {
  global mc_who
  set array [list svs temp $sid]
  if {$tout == "timeout"} {
    set temp(1) "$svs_server:$svs_port"
    putloglev d * \
      "$mc_who(script): SVS Warning: Timed out connecting to $temp(1)."
    catch {unset mc_who($array)}
    close $sid
    return 0
  }
  if {[eof $sid]} {
    catch {unset mc_who($array)}
    close $sid
    return 1
  }
  gets $sid get
  after cancel $tout
  if {![info exist mc_who($array)]} {
    if {$get == ""} {set mc_who($array) 1}
    return -1
  }
  if {($get == "") || [catch {llength $get}]} {
    return -2
  }
  switch -- [lindex $get 0] {
    200 {
      set temp(host) [lindex $get 1]
      set temp(port) [lindex $get 2]
      set temp(get) [lindex $get 3]
      set temp(cache) "$temp(host) at $temp(port)"
      putloglev d * \
        "$mc_who(script): SVS is being redirected to $temp(cache)."
      mc:who:do_svs_ $temp(host) $temp(port) $temp(get)
      close $sid
      return 200
    }
    003 {
      set temp(reply) [lrange $get 1 end]
      for {set number 0} {$number <= 5} {incr number} {
        set temp(reply:$number) [lindex $temp(reply) $number]
      }
      if {$temp(reply:0) != $mc_who(svs:script)} {
        set temp(1) "wanted $mc_who(svs:script), got $temp(reply:0)"
        putloglev d * "$mc_who(script): SVS Error: $temp(1)"
        unset mc_who($array)
        close $sid
        return -3
      }
      if {$mc_who(svs:mode)} {
        set temp(svs:version) [string range $mc_who(svs:version) 0 8]999
      } else {
        set temp(svs:version) [string range $mc_who(svs:version) 0 11]
      }
      if {$temp(reply:1) > $temp(svs:version)} {
        set temp(note) $temp(reply:5)
        regsub -all -- %0 $temp(note) $temp(reply:0) temp(note)
        regsub -all -- %1 $temp(note) $temp(reply:1) temp(note)
        regsub -all -- %2 $temp(note) $temp(reply:2) temp(note)
        regsub -all -- %3 $temp(note) $temp(reply:3) temp(note)
        regsub -all -- %4 $temp(note) $temp(reply:4) temp(note)
        regsub -all -- %version $temp(note) $mc_who(version) temp(note)
        foreach temp(to) [split $mc_who(svs:notify) ",; "] {
          if {[string trim $temp(to)] == ""} {continue}
          regsub -- %nick $temp(note) $temp(to) temp(note2)
          set temp(lunotes) [notes $temp(to) -[notes $temp(to)]]]
          if {[string match *$temp(note2)* $temp(lunotes)]} {
            set temp(found_note) 0
            foreach temp(unote) $temp(lunotes) {
              if {$temp(note2) == [lindex $temp(unote) 2]} {
                set temp(found_note) 1
                break
              }
            }
            if {$temp(found_note)} {continue}
          }
          set temp(error) "sending note to $temp(to) -> "
          switch -- [sendnote SVS $temp(to) $temp(note2)] {
            0 {
              if {![validuser $temp(to)]} {
                append temp(error) "invalid user"
              } else {append temp(error) "unknown error"}
              putloglev d * \
                "$mc_who(script): SVS sendnote error: $temp(error)"
            }
            3 {
              append temp(error) "notebox too full"
              putloglev d * \
                "$mc_who(script): SVS sendnote error: $temp(error)"
            }
          }
        }
      }
      unset mc_who($array)
      close $sid
      return 2
    }
  }
}
## ^

putlog "$mc_who(script) $mc_who(version) by MC_8 loaded."

##
# History  ( <Fixed by> - [Found by] - <Info> )
##
# v3.0 (02.12.03)
#  MC_8 -        - Upgraded SVS Client.  v2.0 -> v3.2.1
#  MC_8 - fyimc8 - Fixed 'can't set "temp": variable is array'.
#  MC_8 -        - Upgraded ECS, Error Catching System.  old -> v3.0
#  MC_8 -        - Upgraded/added tcl commands;
#                    chanflag  v1.0 -> v3.1
#                    replace   v1.0 -> v1.3
#                    unlist    none -> v1.0
#                    badargs   none -> v1.0
#                    2list     none -> v1.0
#  MC_8 -        - Rewrote the script's core coding.
#  MC_8 -        - Lowered the excess in processor usage by removing a pubm for
#                  *, and binding to pub for each specific trigger.
#  MC_8 -        - Added `lang:end_of_post` configuration variable.
#  MC_8 -        - Renamed configuration variables;
#                    lang:001 -> lang:start_of_post
#                    lang:002 -> lang:post
#                    lang:003 -> lang:tring_resolve
#                    lang:004 -> lang:not_found
#                    lang:005 -> lang:truncated
#  MC_8 -        - Removed `meth` configuration variable.
#  MC_8 -        - `lang:*` configuration variables now support multi lines, and
#                  include how to process the message better.
#
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
