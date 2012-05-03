-module(fix_tests).
-author('Max Lapshin <max@maxidoors.ru>').

-include_lib("eunit/include/eunit.hrl").
-include("../include/admin.hrl").
-include("../include/business.hrl").


fix_decode_1_test() ->
  ?assertMatch({ok, #heartbeat{signature = <<"A",1,"89=234">>}, <<>>}, fix:decode(<<"8=FIX.4.4",1,"9=22",1,"35=0",1,"93=8",1,"89=A",1,"89=234",1,"10=999",1>>)).


fix_decode_2_test() ->
  {ok, Record, <<>>} =
  fix:decode(<<"8=FIX.4.4",1,"9=135",1,"35=V",1,"49=SENDER",1,"56=TARGET",1,"34=31",1,"43=N",1,"52=20120502-13:08:35",1,"262=42",1,"263=1",1,"264=0",1,"265=0",1,"267=2",1,"269=0",1,"269=1",1,"146=1",1,"55=URKA",1,"461=EXXXXX",1,"207=MICEX",1,"10=158",1,"">>),
  ?assertMatch(#market_data_request{
    sender_comp_id = <<"SENDER">>,
    target_comp_id = <<"TARGET">>,
    msg_seq_num = 31,
    md_req_id = <<"42">>,
    sending_time = <<"20120502-13:08:35">>,
    subscription_request_type = <<"1">>,
    market_depth = 0,
    md_update_type = 0,
    fields = [
      {poss_dup_flag,false},
      {no_md_entry_types,2},
      {md_entry_type, <<"0">>},
      {md_entry_type, <<"1">>},
      {no_related_sym,1},
      {symbol,<<"URKA">>},
      {cfi_code,<<"EXXXXX">>},
      {security_exchange,<<"MICEX">>}
    ]
  }, Record).
  
  