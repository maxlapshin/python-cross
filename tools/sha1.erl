#!/usr/bin/env escript
%%
%%

-mode(compile).

main([]) ->
  io:fwrite(standard_error, "~s path1 path2 path3\n",[escript:script_name()]),
  erlang:stop(2);

main(Paths) ->
  [hash(Path) || Path <- Paths],
  ok.


hash(Path) ->
  case file:open(Path, [binary,read]) of
    {ok, F} ->
      H1 = crypto:hash_init(sha),
      H2 = hash(F,H1),
      file:write_file(Path++".sha1", [io_lib:format("~2.16.0b",[X]) || <<X:8>> <= crypto:hash_final(H2) ]);
    {error, enoent} ->
      ok
  end.


hash(F,H1) ->
  case file:read(F, 65536) of
    {ok, Bin} ->
      hash(F,crypto:hash_update(H1,Bin));
    _ ->
      file:close(F),
      H1
  end.
