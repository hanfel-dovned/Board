|%
+$  content  @t
+$  bg-color  @ux
+$  text-color  @ux
+$  bord  [=content =bg-color =text-color]
+$  bords  (map =ship =bord)
+$  following  (set =ship)
+$  action
  $%  [%edit-board =bord]
      [%follow =ship]
      [%unfollow =ship]
  ==
+$  update
  $%  [%new-board =bord]
  ==
--