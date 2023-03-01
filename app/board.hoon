/-  *board
/+  dbug, default-agent, server, schooner
/*  board-ui  %html  /app/board/html
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0  [%0 =bords]
+$  card  card:agent:gall
--
%-  agent:dbug
^-  agent:gall
=|  state-0
=*  state  -
|_  =bowl:gall
+*  this  .
    def  ~(. (default-agent this %.n) bowl)
++  on-init
  ^-  (quip card _this)
  :_  this(bords (~(put by bords) our.bowl ['' 0xff.ffff 0x00.0000]))
  :~
    :*  %pass  /eyre/connect  %arvo  %e
        %connect  `/apps/board  %board
    ==
    :*  %pass  /newpals  %agent
        [our.bowl %pals]  %watch  /targets
    ==  
  ==
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-  -.old
    %0  `this(state old)
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  ?+    mark  (on-poke:def mark vase)
      %handle-http-request
    ?>  =(src.bowl our.bowl)
    =^  cards  state
      (handle-http !<([@ta =inbound-request:eyre] vase))
    [cards this]
  ==
  ++  handle-http
    |=  [eyre-id=@ta =inbound-request:eyre]
    ^-  (quip card _state)
    =/  ,request-line:server
      (parse-request-line:server url.request.inbound-request)
    =+  send=(cury response:schooner eyre-id)
    ?.  authenticated.inbound-request
      :_  state
      %-  send
      [302 ~ [%login-redirect './apps/board']]
    ::
    ?+    method.request.inbound-request  
      [(send [405 ~ [%stock ~]]) state]
      ::
        %'POST'
      ?~  body.request.inbound-request
        [(send [405 ~ [%stock ~]]) state]
      =/  json  (de-json:html q.u.body.request.inbound-request)
      =/  action  (dejs-action +.json)
      (handle-action action) 
      :: 
        %'GET'
      ?+    site  
          :_  state 
          (send [404 ~ [%plain "404 - Not Found"]])
        ::
          [%apps %board ~]
        :_  state
        %-  send
        :+  200  ~  
        :-  %html  board-ui
        ::
          [%apps %board %state ~]
        :_  state
        %-  send
        :+  200  ~ 
        [%json (enjs-state +.state)]
      == 
    ==
  ::
  ++  enjs-state
    =,  enjs:format
    |=  =^bords
    ^-  json
    :-  %a
    %+  turn
      ~(tap by bords)
    |=  =bord
    :-  %a
    :~
        [%s content:bord]
        [%s (scot %ux bg-color:bord)]
        [%s (scot %ux text-color:bord)]
    ==
  ::
  ++  dejs-action
    =,  dejs:format
    |=  jon=json
    ^-  action
    %.  jon
    %-  of
    :~  [%edit-board (at ~[so nu nu])]
        [%follow (se %p)]
        [%unfollow (se %p)]
    ==
  ::
  ++  handle-action
    |=  =action:feature
    ^-  (quip card _state)
    ?>  =(src.bowl our.bowl)
    ?-    -.action
        %edit-board
      :_  state(~(put by bords) our.bowl bord:action)
      :~  :*  %give  %fact  ~[/board-out]
              %board-update 
              !>(`update`[%new-board bord:action])
          ==  
      ==
      ::
        %follow
      :_  state
      :~  :*  %pass  /boards-in
              %agent  [ship:action %board]
              %watch  /board-out
          ==
      ==
      ::
        %unfollow
      :_  state(~(del by bords) ship:action)
      :~  :*  %pass  /boards-in
              %agent  [ship:action %board]
              %leave
          ==
      ==
      ::
    ==
  --
++  on-peek  on-peek:def
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [%http-response *]
    `this
    ::
      [%board-out ~]
    :_  this
    :~  :*  %give  %fact  ~
            %board-update 
            !>(`update`[%new-board (~(got by bords) our.bowl)])
        ==  
    ==
  ==
::
++  on-leave  on-leave:def
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  |^
  ?+    wire  (on-agent:def wire sign)
      [%newpals ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      ?+    p.cage.sign  (on-agent:def wire sign)
          %pals-effect
        =/  neweffect  !<(effect:pals q.cage.sign)
        ?+    -.neweffect  (on-agent:def wire sign)
            %meet
          :_  this
          :~  
            :*  %pass  /boards-in
                %agent  [+.neweffect %board]
                %watch  /board-out
            ==
          ==
        ==
      ==
    ==
    ::
      [%boards-in ~]
    ?+    -.sign  (on-agent:def wire sign)
        %fact
      ?+    p.cafe.sign  (on-agent:def wire sign)
          %board-update
        =/  newupdate  !<(update q.cage.sign)
        ?-    -.newupdate
            %new-board
          `this(~(put by bords) src.bowl +.newupdate)
        ==
      ==
    ==
++  on-arvo  on-arvo:def
++  on-fail  on-fail:def
--