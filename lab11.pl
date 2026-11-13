:- dynamic letter/1.

name_game :-
    retractall(letter(_)),
    assertz(letter(a)),
    assertz(letter(b)),
    assertz(letter(c)),
    write('Hi, This is the "Name Game".'), nl,
    write('Add, delete or move English letters to create your name.'), nl,
    name_menu.

name_menu :-
    nl,
    write('Choose from the following:'), nl,
    write('1- Display the current set of letters'), nl,
    write('2- Add a letter'), nl,
    write('3- Add a letter at the top'), nl,
    write('4- Add a letter at the bottom'), nl,
    write('5- Delete a letter'), nl,
    write('6- Delete all letters'), nl,
    write('7- Exit'), nl,
    write('Enter your choice (end with a period): '),
    read(Choice),
    ( Choice == 7 ->
        write('Goodbye!'), nl
    ; Choice == end_of_file ->
        write('Goodbye!'), nl
    ; handle_choice(Choice),
      name_menu
    ).

handle_choice(Choice) :-
    ( Choice == 1 ->
        display_letters
    ; Choice == 2 ->
        add_letter(bottom)
    ; Choice == 3 ->
        add_letter(top)
    ; Choice == 4 ->
        add_letter(bottom)
    ; Choice == 5 ->
        delete_letter
    ; Choice == 6 ->
        retractall(letter(_)),
        write('All letters deleted.'), nl
    ; write('Invalid choice. Enter a number from 1 to 7.'), nl
    ).

% findall preserves the order of the letter facts in the database.
display_letters :-
    findall(Letter, letter(Letter), Letters),
    write('Current letters: '), write(Letters), nl,
    write('Name: '),
    print_name(Letters), nl.

print_name([]).
print_name([Head|Tail]) :-
    write(Head),
    print_name(Tail).

add_letter(Position) :-
    write('Enter one English letter (end with a period): '),
    read(Letter),
    ( english_letter(Letter) ->
        ( Position == top ->
            asserta(letter(Letter))
        ; assertz(letter(Letter))
        ),
        write('Letter added.'), nl
    ; write('Invalid input. Enter one English letter, such as a.'), nl
    ).

% retract removes only the FIRST occurrence, preserving other copies.
delete_letter :-
    write('Enter the letter to delete (end with a period): '),
    read(Letter),
    ( english_letter(Letter) ->
        ( retract(letter(Letter)) ->
            write('Letter deleted.'), nl
        ; write('That letter is not in the current set.'), nl
        )
    ; write('Invalid input. Enter one English letter, such as a.'), nl
    ).

% Validate before accessing the database; variables must not match any letter.
english_letter(Letter) :-
    atom(Letter),
    atom_codes(Letter, [Code]),
    ( Code >= 65, Code =< 90
    ; Code >= 97, Code =< 122
    ).