			.data
board:			.space		216
player1_wins:			.word			0
player2_wins:			.word			0
player1_text:		.asciz		"\nPlayer 1: "
player2_text:		.asciz		"Player 2: "
wins_text:		.asciz		" vitórias\n"
menu_text:		.asciz		"\nFila 4 - Menu principal:\n\n1 - Configurações\n2 - Jogar\n3 - Sair\n\nOpção: "
invalid_opt_text:	.asciz		"\nOpção inválida!\n"
config_menu_text:	.asciz		"\nConfigurações:\n\n1 - Quantidade de jogadores\n2 - Tamanho do tabuleiro\n3 - Dificuldade\n4 - Zerar placar\n5 - Ver configurações\n6 - Voltar\n\nOpção: "
players_text:		.asciz		"\nEscolha a quantidade de jogadores: (1 ou 2): "
print_players_text:	.asciz		"\nQuantidade de jogadores: "
print_board_text:	.asciz		"\nTamanho do tabuleiro: "
print_difficulty_text:	.asciz		"\nDificuldade: "
board_text:		.asciz		"\nEscolha o tamanho do tabuleiro:\n\n1 - Tabuleiro 7x6\n2 - Tabuleiro 9x6\n\nOpção: "
board_9x6_text:		.asciz		"Tabuleiro 9x6"
board_7x6_text:		.asciz		"Tabuleiro 7x6"
difficulty_text:	.asciz		"\nEscolha a dificuldade:\n\n1 - Fácil\n2 - Médio\n\nOpção: "
easy_text:		.asciz		"Fácil"
medium_text:		.asciz		"Médio"
choose_column:	.asciz		"\nEscolha uma coluna (Jogador "
choose_column2:	.asciz		"): "
bot_column:	.asciz		"\nO bot escolheu a coluna "
column_full_text:		.asciz		"\nColuna cheia, escolha novamente!\n"
tie_text:			.asciz		"\nEmpate!\n"
player_text:			.asciz		"\nO jogador "
win_text:			.asciz		" venceu!\n"
dash:		.asciz		"-"
linebreak:		.asciz		"\n"
space:			.asciz		" "
			.text
# ======================== MAIN MENU ===========================
			# config defaults
			li s7, 1 # 1 player
			li s8, 7 # 7x6 board
			li s9, 1 # easy

main:
			# print menu
			la a0, menu_text
			li a7, 4
			ecall
		
			# a0 <- user menu option
			li a7, 5
			ecall
		
			# check config option selected
			li s1, 1
			bne a0, s1, skip_config
			call config_menu
			j main
skip_config:
			# check config option selected
			li s1, 2
			bne a0, s1, skip_play
			call play
			j main
skip_play:
			# check config option selected
			li s1, 3
			bne a0, s1, invalid_opt
			j end
invalid_opt:
			# no valid opt, return to menu
			la a0, invalid_opt_text
			li a7, 4
			ecall
			j main
	
# ======================== CONFIG MENU ===========================		
config_menu:
			mv s11, ra
config_menu_opts:
			# print config menu
			la a0, config_menu_text
			li a7, 4
			ecall
			
			# a0 <- user config menu option
			li a7, 5
			ecall
			
			# check players option selected
			li s1, 1
			bne a0, s1, skip_players
			call players_config
			j config_menu_opts
skip_players:
			# check board option selected
			li s1, 2
			bne a0, s1, skip_board
			call board_config
			j config_menu_opts
skip_board:
			# check difficulty option selected
			li s1, 3
			bne a0, s1, skip_difficulty
			call difficulty_config
			j config_menu_opts
skip_difficulty:
			# check reset option selected
			li s1, 4
			bne a0, s1, skip_reset
			call reset_count
			j config_menu_opts
skip_reset:
			# check reset option selected
			li s1, 5
			bne a0, s1, skip_print_config
			call print_config
			j config_menu_opts
skip_print_config:
			# check reset option selected
			li s1, 6
			bne a0, s1, invalid_config_opt
			
			mv ra, s11
			ret
invalid_config_opt:
			# no valid opt, return to menu
			la a0, invalid_opt_text
			li a7, 4
			ecall
			j config_menu_opts
			
# ======================== SET PLAYER ===========================
# s7 <- 1: 1 player
# s7 <- 2: 2 player
players_config:
			# ask for player quantity
			la a0, players_text
			li a7, 4
			ecall
		
			# a0 <- player quantity
			li a7, 5
			ecall
			
			li s2, 1
			li s3, 2
			blt a0, s2, invalid_players
			bgt a0, s3, invalid_players
			mv s7, a0
			ret
invalid_players:
			la a0, invalid_opt_text
			li a7, 4
			ecall
			j players_config
			
# ======================== SET BOARD ===========================
# s8 <- 7: 7x6
# s8 <- 9: 9x6
board_config:
			# ask for board size
			la a0, board_text
			li a7, 4
			ecall
		
			# a0 <- board size
			li a7, 5
			ecall
			
			li s2, 1
			bne a0, s2, not_7
			li s2, 7
			mv s8, s2
			ret
not_7:
			li s3, 2
			bne a0, s3, invalid_board
			li s3, 9
			mv s8, s3
			ret
invalid_board:
			la a0, invalid_opt_text
			li a7, 4
			ecall
			j board_config
			
# ======================== SET DIFFICULTY ===========================
# s9 <- 1: easy
# s9 <- 2: medium
difficulty_config:
			# ask for difficulty
			la a0, difficulty_text
			li a7, 4
			ecall
		
			# a0 <- difficulty
			li a7, 5
			ecall
			
			li s2, 1
			li s3, 2
			blt a0, s2, invalid_difficulty
			bgt a0, s3, invalid_difficulty
			mv s9, a0
			ret
invalid_difficulty:
			la a0, invalid_opt_text
			li a7, 4
			ecall
			j difficulty_config
			
# ======================== RESET COUNT ===========================
reset_count:
			la t0, player1_wins
			sw zero, 0(t0)
			la t0, player1_wins
			sw zero, 0(t0)

			ret
			
# ======================== PRINT CONFIG ===========================
print_config:
			# print player quantity text
			la a0, print_players_text
			li a7, 4
			ecall
		
			# print player quantity
			mv a0, s7
			li a7, 1
			ecall
			
			# print board size text
			la a0, print_board_text
			li a7, 4
			ecall
		
			# print board size
			li s3, 7
			bne s8, s3, print_9x6
			la a0, board_7x6_text
			li a7, 4
			ecall
			j skip_board_print
print_9x6:
			la a0, board_9x6_text
			li a7, 4
			ecall
skip_board_print:
			# print difficulty text
			la a0, print_difficulty_text
			li a7, 4
			ecall
			
			# print difficulty
			li s3, 1
			bne s9, s3, print_medium
			la a0, easy_text
			li a7, 4
			ecall
			j skip_difficulty_print
print_medium:
			la a0, medium_text
			li a7, 4
			ecall
skip_difficulty_print:
			la a0, linebreak
			li a7, 4
			ecall
			
			ret

# ======================== PRINT SCOREBOARD ===========================
print_scoreboard:
			mv t0, a0
			mv t1, a1

			# player 1 wins
			la a0, player1_text
			li a7, 4
			ecall

			la a0, player1_wins
			lw a0, 0(a0)
			li a7, 1
			ecall

			la a0, wins_text
			li a7, 4
			ecall

			# player 2 wins
			la a0, player2_text
			li a7, 4
			ecall

			la a0, player2_wins
			lw a0, 0(a0)
			li a7, 1
			ecall

			la a0, wins_text
			li a7, 4
			ecall

			mv a0, t0
			mv a1, t1
			ret

# ======================== PLAY ===========================
play:
			mv s11, ra

			call print_scoreboard

			# a0 <- board address
			# a1 <- board size
			call setup_board
			call setup_print_board

			mv t5, a0
			
			# a2 <- current player
			li a2, 1

round_loop:
			# ask player to choose a column
			la a0, choose_column
			li a7, 4
			ecall
			mv a0, a2
			li a7, 1
			ecall
			la a0, choose_column2
			li a7, 4
			ecall
			li a7, 5
			ecall
			# a0 <- column index

			mv a3, a0
			mv a0, t5

			call round
			call setup_print_board

			li t1, 1
			beq a2, t1, swap_to_player_2
			li a2, 1
			j skip_player_swap

swap_to_player_2:
			li t4, 1
			bne s7, t4, skip_bot_round
			call bot_round

			j skip_player_swap

skip_bot_round:
			li a2, 2

skip_player_swap:
			j round_loop

end_round_loop:
			mv ra, s11
			ret
			
# ======================== SETUP BOARD ===========================
setup_board:
			mv s10, ra
			
			la a0, board
			mv a1, s8
			# a0 <- board address
			# a1 <- board columns
			call build_board
			
			mv ra, s10
			ret
			
# ======================== BUILD BOARD ===========================
# inicia_tabuleiro
# a0 <- board address
# a1 <- board columns
build_board:
			li t2, 6
			mul s2, a1, t2 # s2 <- board cells
			
			li s1, 0 # s1 <- loop counter
build_board_loop:
			beq s1, s2, end_build_board_loop
			
			add t1, s1, s1
			add t1, t1, t1
			add t1, a0, t1
			
			sw zero, 0(t1)
			
			addi s1, s1, 1
			j build_board_loop

end_build_board_loop:
			ret
			
# ======================== SETUP PRINT BOARD ===========================
setup_print_board:
			mv s10, ra
			
			la a0, board
			mv a1, s8
			# a0 <- board address
			# a1 <- board columns
			call print_board
			
			mv ra, s10
			ret
			
# ======================== PRINT BOARD ===========================
# imprime_tabuleiro
# a0 <- board address
# a1 <- board columns
print_board:
			mv s6, ra
			mv s5, a0

			li s1, 6 # s1 <- max row index
			mv s2, a1 # s2 <- max column index
			
			li s3, 0 # s3 <- current row index
			
			la a0, linebreak
			li a7, 4
			ecall

header_loop:
			beq s3, a1, end_header_loop

			mv a0, s3
			li a7, 1
			ecall
			la a0, space
			li a7, 4
			ecall

			addi s3, s3, 1
			j header_loop

end_header_loop:
			li s3, 0

			la a0, linebreak
			li a7, 4
			ecall
			
print_board_row_loop:
			beq s3, s1, end_print_board_row_loop
			
			call board_column
			
			la a0, linebreak
			li a7, 4
			ecall
			
			addi s3, s3, 1
			j print_board_row_loop

end_print_board_row_loop:
			mv a0, s5
			mv ra, s6
			ret
			
# ======================== PRINT BOARD COLUMN ===========================
board_column:
			# s1 <- max row index
			# s2 <- max column index
			# s3 <- current row index
			li s4, 0 # s4 <- current column index

board_column_loop:
			beq s4, s2, end_board_column_loop
			
			add t1, s3, s3
			add t1, t1, t1 # t1 <- row address
			
			li t2, 24
			mul t2, s4, t2 # t2 <- column address
			
			add t3, t2, t1
			add t3, s5, t3 # t3 <- cell address
			
			lw a0, 0(t3)
			li a7, 1

			bne a0, zero, print_cell_value
			la a0, dash
			li a7, 4

print_cell_value:
			ecall
			
			la a0, space
			li a7, 4
			ecall
			
			addi s4, s4, 1
			j board_column_loop
end_board_column_loop:
			ret	

# ======================== ROUND ===========================
round:
			# a0 <- board address
			# a1 <- board size
			# a2 <- current player
			# a3 <- column index

			mv s10, a0
			mv t3, ra

			blt a3, zero, column_index_error
			addi t2, a1, -1
			bgt a3, t2, column_index_error

			li s0, 24
			mul s0, a3, s0
			add s0, s0, s10 # s0 <- first cell of selected column address
			lw t2, 0(s0) # t2 <- first cell of selected column

			bne t2, zero, column_full

			addi s0, s0, 20

			call insert_loop

			# return the check result in a register
			call check_end
			# beq to check if the game ends (go to main_menu)

			mv a0, s10
			mv ra, t3
			ret
			
column_full:
			# column full, return to round
			la a0, column_full_text
			li a7, 4
			ecall
			mv a0, s10
			j round_loop

column_index_error:
			# no valid column, return to round
			la a0, invalid_opt_text
			li a7, 4
			ecall
			mv a0, s10
			j round_loop

# ======================== INSERT LOOP ===========================
insert_loop:
			# s0 <- current cell address
			lw t2, 0(s0) # t2 <- current cell value
			bne t2, zero, skip_cell

			sw a2, 0(s0) # put player on cell

			j end_insert_loop

skip_cell:
			addi s0, s0, -4
			j insert_loop

end_insert_loop:
			ret

# ======================== BOT ROUND ===========================
bot_round:
			mv t6, ra
			mv t0, a0
			mv t1, a1

bot_round_rand_num:
			# a0 <- random number between 0 and 6 or 8
			li a0, 0
			mv a1, s8
			li a7, 42
			ecall

			li t2, 24
			mul t2, a0, t2
			add t2, t2, t0
			lw t2, 0(t2) # t2 <- value of the first cell on selected column

			bne t2, zero, bot_round_rand_num

			mv a3, a0

			la a0, bot_column
			li a7, 4
			ecall
			mv a0, a3
			li a7, 1
			ecall
			la a0, linebreak
			li a7, 4
			ecall

			li a2, 2 # bot plays as player 2
			mv a1, t1
			mv a0, t0
			call round

			

			call setup_print_board

			li a2, 1 # after the bot play, switch back to player 1
			
			mv ra, t6
			ret

# ======================== CHECK IF THE GAME ENDED ===========================
# verifica_vencedor
# TODO: params and returns
check_end:
			mv t0, ra

			call check_tie
			call check_cols
			call check_rows
			call check_diag

			mv ra, t0
			ret

# ======================== CHECK TIE ===========================
check_tie:
			li t1, 0

check_tie_loop:
			beq t1, s8, tie

			li t2, 24
			mul t2, t2, t1
			add t2, t2, s10
			lw t2, 0(t2) # t2 <- value of the first cell in each column

			beq t2, zero, end_check_tie_loop

			addi t1, t1, 1
			j check_tie_loop

end_check_tie_loop:
			ret

# ======================== TIE GAME ===========================
tie:
			call setup_print_board

			la a0, tie_text
			li a7, 4
			ecall

			j main

# ======================== CHECK COLS ===========================
check_cols:
			mv s11, ra
			li a4, 0
col_loop:
			beq a4, s8, end_col_loop
			li s6, 24
			mul s6, a4, s6
			add s6, s6, s10
			call check_col

			addi a4, a4, 1
			j col_loop
end_col_loop:
			mv ra, s11
			ret

# ======================== CHECK COL ===========================
check_col:
			li t1, 0 # t1 <- current row
			li a5, 6 # a5 <- rows
			li t4, 1 # t4 <- last player
			li s2, 0 # s2 <- consecutive player cell
			li a6, 4

check_col_loop:
			beq t1, a5, end_check_col_loop

			mul t2, t1, a6
			add t2, t2, s6
			lw t2, 0(t2) # t2 <- current value of the column

			beq t2, zero, reset_col_count
			beq t2, t4, col_skip_change_player

			li a7, 1
			beq t4, a7, col_change_to_two
			li t4, 1
			j col_end_swap_if
col_change_to_two:
			li t4, 2
col_end_swap_if:
			li s2, 0

col_skip_change_player:
			addi s2, s2, 1
			beq s2, a6, current_player_win
			j skip_col_cell

reset_col_count:
			li s2, 0

skip_col_cell:
			addi t1, t1, 1
			j check_col_loop

end_check_col_loop:
			ret

# ======================== CHECK ROWS ===========================
check_rows:
			mv s11, ra
			li a4, 0
row_loop:
			beq a4, s8, end_row_loop
			li s6, 4
			mul s6, a4, s6
			add s6, s6, s10
			call check_row

			addi a4, a4, 1
			j row_loop
end_row_loop:
			mv ra, s11
			ret

# ======================== CHECK ROW ===========================
check_row:
			li t1, 0 # t1 <- current row
			li a5, 6 # a5 <- rows
			li t4, 1 # t4 <- last player
			li s2, 0 # s2 <- consecutive player cell
			li a6, 4

check_row_loop:
			beq t1, a5, end_check_row_loop

			li t2, 24
			mul t2, t2, t1
			add t2, t2, s6
			lw t2, 0(t2) # t2 <- current value of the rowumn

			beq t2, zero, reset_row_count
			beq t2, t4, skip_change_player

			li a7, 1
			beq t4, a7, change_to_two
			li t4, 1
			j end_swap_if
change_to_two:
			li t4, 2
end_swap_if:
			li s2, 0

skip_change_player:
			addi s2, s2, 1
			beq s2, a6, current_player_win
			j skip_row_cell

reset_row_count:
			li s2, 0

skip_row_cell:
			addi t1, t1, 1
			j check_row_loop

end_check_row_loop:
			ret

# ======================== CHECK DIAGONALS ===========================
check_diag:
			mv a5, ra

			li s5, -2

			li a7, 24
			mul a7, s5, a7
			add s6, s10, a7 # s6 <- board address

check_diag_loop:
			li t2, 3
			sub t2, s8, t2

			beq s5, t2, end_check_diag_loop

			call diag_desc
			addi s6, s6, 20
			call diag_asc
			addi s6, s6, 4

			addi s5, s5, 1
			j check_diag_loop

end_check_diag_loop:
			mv ra, a5
			ret

# ======================== CHECK DESCENDING DIAGONAL ===========================
diag_desc:
			li a6, 0
			li s3, 6
			li t4, 1 # t4 <- last player
			li s2, 0 # s2 <- consecutive player cell

diag_desc_loop:
			beq a6, s3, end_diag_desc_loop

			li s0, 28
			mul s0, a6, s0
			add s0, s0, s6

			# address should not exceed 212 of displacement
			sub s4, s0, s10
			li a7, 212

			bgt s4, a7, skip_diag_desc_cell
			blt s4, zero, skip_diag_desc_cell

			lw s0, 0(s0)

			beq s0, zero, diag_desc_reset_count
			beq s0, t4, diag_desc_skip_change_player

			li t2, 1
			beq t4, t2, diag_desc_change_to_two
			li t4, 1
			j diag_desc_end_swap_if
diag_desc_change_to_two:
			li t4, 2
diag_desc_end_swap_if:
			li s2, 0

diag_desc_skip_change_player:
			addi s2, s2, 1
			li t2, 4
			beq s2, t2, current_player_win
			j skip_diag_desc_cell

diag_desc_reset_count:
			li s2, 0

skip_diag_desc_cell:
			addi a6, a6, 1
			j diag_desc_loop

end_diag_desc_loop:
			ret

# ======================== CHECK ASCENDING DIAGONAL ===========================
diag_asc:
			li a6, 0
			li s3, 6
			li t4, 1 # t4 <- last player
			li s2, 0 # s2 <- consecutive player cell

diag_asc_loop:
			beq a6, s3, end_diag_asc_loop

			li s0, 20
			mul s0, a6, s0
			add s0, s0, s6

			# address should not exceed 212 of displacement
			sub s4, s0, s10
			li a7, 212

			bgt s4, a7, skip_diag_cell
			blt s4, zero, skip_diag_cell

			lw s0, 0(s0)

			beq s0, zero, diag_asc_reset_count
			beq s0, t4, diag_skip_change_player

			li t2, 1
			beq t4, t2, diag_change_to_two
			li t4, 1
			j diag_end_swap_if
diag_change_to_two:
			li t4, 2
diag_end_swap_if:
			li s2, 0

diag_skip_change_player:
			addi s2, s2, 1
			li t2, 4
			beq s2, t2, current_player_win
			j skip_diag_cell

diag_asc_reset_count:
			li s2, 0

skip_diag_cell:
			addi a6, a6, 1
			j diag_asc_loop

end_diag_asc_loop:
			ret

# ======================== CURRENT PLAYER WINS ===========================
current_player_win:
			# t4 <- current player
			call setup_print_board

			# print who wins
			la a0, player_text
			li a7, 4
			ecall
			mv a0, t4
			li a7, 1
			ecall
			la a0, win_text
			li a7, 4
			ecall

			# increase player win count
			li t0, 1
			beq t4, t0, player_1_wins_game

			la a0, player2_wins
			lw a1, 0(a0)
			addi a1, a1, 1
			sw a1, 0(a0)

			j win_end_if

player_1_wins_game:
			la a0, player1_wins
			lw a1, 0(a0)
			addi a1, a1, 1
			sw a1, 0(a0)

win_end_if:
			call print_scoreboard

			j main

# ======================== END ===========================
end:
			li a7, 10
			ecall
