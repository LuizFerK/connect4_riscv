			.data
board:			.space		216
menu_text:		.asciz		"\nFila 4 - Menu principal:\n\n1 - Configurações\n2 - Jogar\n3 - Sair\n\nOpção: "
invalid_opt_text:	.asciz		"\nOpção inválida!\n"
config_menu_text:	.asciz		"\nConfigurações:\n\n1 - Quantidade de jogadores\n2 - Tamanho do tabuleiro\n3 - Dificuldade\n4 - Zerar contadores\n5 - Ver configurações\n6 - Voltar\n\nOpção: "
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
linebreak:		.asciz		"\n"
space:			.asciz		" "
			.text
# ======================== MAIN MENU ===========================
main:
			# config defaults
			li s7, 1 # 1 player
			li s8, 1 # 7x6 board
			li s9, 1 # easy

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
# s8 <- 1: 7x6
# s8 <- 2: 9x6
board_config:
			# ask for board size
			la a0, board_text
			li a7, 4
			ecall
		
			# a0 <- board size
			li a7, 5
			ecall
			
			li s2, 1
			li s3, 2
			blt a0, s2, invalid_board
			bgt a0, s3, invalid_board
			mv s8, a0
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
			li s3, 1
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
			
# ======================== PLAY ===========================
play:
			mv s11, ra
			call setup_board
			call setup_print_board
			
			mv ra, s11
			ret
			
# ======================== SETUP BOARD ===========================
setup_board:
			mv s10, ra
			
			la a0, board
			li t1, 1
			bne s8, t1, board9
			li a1, 7
			j set_board
board9:
			li a1, 9
set_board:
			# a0 <- board address
			# a1 <- board columns
			call build_board
			
			mv ra, s10
			ret
			
# ======================== BUILD BOARD ===========================
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
			li t1, 1
			bne s8, t1, print_board9
			li a1, 7
			j print_set_board
print_board9:
			li a1, 9
print_set_board:
			# a0 <- board address
			# a1 <- board columns
			call print_board
			
			mv ra, s10
			ret
			
# ======================== PRINT BOARD ===========================
print_board:
			mv s6, ra
			mv s5, a0

			li s1, 6 # s1 <- max row index
			mv s2, a1 # s2 <- max column index
			
			li s3, 0 # s3 <- current row index
			
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
			ecall
			
			la a0, space
			li a7, 4
			ecall
			
			addi s4, s4, 1
			j board_column_loop
end_board_column_loop:
			ret	
		
# ======================== END ===========================
end:
			li a7, 10
			ecall
