#!/usr/bin/env escript

%% SPDX-License-Identifier: Apache-2.0
%% SPDX-FileCopyrightText: 2021 The Elixir Team
%% SPDX-FileCopyrightText: 2012 Plataformatec

%% -*- erlang -*-

main([Version]) ->
  Source = "lib/elixir/src/elixir.app.src",
  Target = "lib/elixir/ebin/elixir.app",
  {ok, [{application, Name, Props0}]} = file:consult(Source),
  Ebin = filename:dirname(Target),
  Files = filelib:wildcard(filename:join(Ebin, "*.beam")),
  Mods = [list_to_atom(filename:basename(F, ".beam")) || F <- Files],
  Props1 = lists:keyreplace(modules, 1, Props0, {modules, Mods}),
  Props = lists:keyreplace(vsn, 1, Props1, {vsn, Version}),
  AppDef = io_lib:format("~tp.~n", [{application, Name, Props}]),
  ok = file:write_file(Target, AppDef),
  io:format("Generated ~ts app~n", [Name]).
