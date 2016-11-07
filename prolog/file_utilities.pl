:- module(file_utilities, [find_files/3]).
:- meta_predicate find_files(3, -,?, ?).

find_files(Dir,FilePredicate,DirPredicate) :-
  working_directory(CWD,CWD),
  absolute_file_name(Dir,XAbs),
  directory_files(XAbs,Files),
  traverse_files(Files,XAbs,FilePredicate,DirPredicate),
  working_directory(_,CWD).

traverse_files([],_,_,_) :- !.
traverse_files([.|Files],CWD,FilePredicate,DirPredicate) :- traverse_files(Files,CWD,FilePredicate,DirPredicate).
traverse_files([..|Files],CWD,FilePredicate,DirPredicate) :- traverse_files(Files,CWD,FilePredicate,DirPredicate).
traverse_files([File|Files],CWD,FilePredicate,DirPredicate) :-
  working_directory(_,CWD),
  absolute_file_name(File,FileA),
  exists_file(FileA),
  call(FilePredicate,FileA),
  traverse_files(Files,CWD,FilePredicate,DirPredicate).
traverse_files([File|Files],CWD,FilePredicate,DirPredicate) :-
  working_directory(_,CWD),
  absolute_file_name(File,FileA),
  exists_directory(FileA),
  call(DirPredicate,FileA),
  find_files(FileA,FilePredicate,DirPredicate),
  traverse_files(Files,CWD,FilePredicate,DirPredicate).
traverse_files([_|Files],CWD,FilePredicate,DirPredicate) :-
  traverse_files(Files,CWD,FilePredicate,DirPredicate).
