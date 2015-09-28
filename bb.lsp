(defun c:bb 


		(/ 
		
		; VARIABLES		
		lista_blocos
		slideant
		grupos
		dcl_id
		ads
		ins
		bloco
		lista_subs
		IL
		biblioteca
		
		; INTERNAL FUNCTIONS
		filtrar
		levantar_grupos
		listadados
		atualizar_subgrupo
		atualizar_blocos
		atualizar_imagens
		proximo
		anterior
		ativar_imagem
		ativar_icone
		bloco_selecionado
		inserir_desc
		inserir
		
		)
		
		
;--------------------------------------------------------------------------------------------------------------------
;	Filtra a linha de dados devolvendo uma lista.
;	Ex: |NOME|LEGE|LEGE|INFO1|INFO2|INFO3|...
;	Retorna: '((0 . "NOME")(1 . "LEGE")(2 . "LEGE")(3 . "INFO1")(4 . "INFO2")(5 . "INFO3"))
(defun filtrar (texto / Ic Ig temp lista carac)

	(setq Ic 2)
	(setq Ig 0)
	(setq temp "")
	(setq lista (list))

	(if (= (substr texto 1 1) "|")
		(repeat (- (strlen texto) 1)
			(setq carac (substr texto Ic 1))
			(if (= carac "|") 
				(setq 	lista (cons (cons Ig temp) lista)
						Ig (+ Ig 1)
						temp ""
				)
				(setq temp (strcat temp carac))
			)
			(setq Ic ( + Ic 1))
		)
	)
	
	(reverse lista)
	
)
;	Retorna lista com nomes de todos os grupos e subgrupos.
;	Ex. '(("Elétrica" "Interruptores" "Iluminação")("Hidráulica" "Ralos" "Caixas"))
;	Globais: biblioteca
(defun levantar_grupos (/ ini linha lista lista_temp)

	(setq 	ini (open biblioteca "r")
			linha ""
			lista (list)
	)

	(while linha
		(setq linha (read-line ini))
		(if linha
			(progn
				(if (= (substr linha 1 1) ">")
					(if (> (length lista_temp) 0)
						(setq 	lista (cons (reverse lista_temp) lista)
								lista_temp (list (substr linha 2))
						)
						(setq lista_temp (list (substr linha 2)))
					)
				)
				(if (= (substr linha 1 1) "[")
					(setq 	lista_temp (cons (vl-string-trim "]" (substr linha 2)) lista_temp))
				)
			)
		)
	)

	(if (> (length lista_temp) 0) (setq lista (cons (reverse lista_temp) lista)))
	(close ini)
	(reverse lista)

)
;
;	Levanta informações referente a um bloco.
;	Globais: biblioteca
(defun listadados (bloco / linha info ini)

	(if bloco
		(progn
			(setq ini (open biblioteca "r"))
			
			(setq linha "")
			(while linha
				(setq linha (read-line ini))
				(if linha 
					(if (vl-string-search (strcat bloco "|") linha)
						(setq info (filtrar linha))
					)
				)
			)
			
			(close ini)
		)
	)

	info

)
;
;--------------------------------------------------------------------------------------------------------------------
;	È ativado ao alterar a lista de grupos.
;	Colocando o valor do subgrupo, é obrigatorio ter um subgrupo.
;	Globais: grupos, lista_subs
(defun atualizar_subgrupo (/)
	
	(if (> (length (nth (atoi (get_tile "grupos")) grupos)) 1)
		(progn
			(setq lista_subs (cdr (nth (atoi (get_tile "grupos")) grupos)))
			(start_list "subgrupos" 3 0)
			(foreach ads lista_subs (add_list ads))
			(end_list)
			
			(set_tile "leg1" "")
			(set_tile "leg2" "")
			
			(atualizar_blocos)
		)
		(progn
			(start_list "subgrupos" 3 0)
			(end_list)
			(start_list "bloco" 3 0)
			(end_list)
			(set_tile "leg1" "")
			(set_tile "leg2" "")
			(alert "É necessário um subgrupo!")
		)
	)
	
)
;	Faz uma analise no arquivo de biblioteca, colocando os blocos referente ao subgrupo.
;	E ao fim, inicia a função (atualizar_imagens IL) com a variavel global IL.
;	Globais: lista_blocos IL
(defun atualizar_blocos (/ temp subgrupo ini linha ads)

	(setq subgrupo (nth (atoi (get_tile "subgrupos")) lista_subs))
	
	(set_tile "leg1" "")
	(set_tile "leg2" "")
	
	(setq ini (open biblioteca "r"))

	(setq linha "")
	(setq lista_blocos (list))


	(while linha
		(setq linha (read-line ini))
		(if linha 
			(progn
				(if (= linha (strcat "[" subgrupo "]"))
					(while linha
						(setq linha (read-line ini))
						(if linha
							(progn
								(if (= (substr linha 1 1) "|")
									(progn
										(setq temp (filtrar linha))
										(setq lista_blocos (cons (cdr (assoc 0 temp)) lista_blocos))
									)
								)
								(if (or (= (substr linha 1 1) ">") (= (substr linha 1 1) "["))
									(setq linha nil)
								)							
							)							
						)
					)	
				)
			)
		)
	)

	(close ini)
	(setq lista_blocos (reverse lista_blocos))

	(start_list "bloco" 3 0)
	(foreach ads lista_blocos (add_list ads))
	(end_list)

	(setq IL 1)
	(atualizar_imagens IL)

)
;	Atualiza as imagens.
;	Função interna de apoio.
;	Globais: slideant IL
(defun atualizar_imagens 

		(
		IL 
		/ 
		ads
		x 
		y 
		Ic 
		lista_temp
		redefinir
		)
		
;----------------------------------------------------------------
;
;
;
	(defun redefinir (Cm lista_blocos / Ic lista_temp ads)
		
		(setq Ic 1)
		(foreach ads lista_blocos
			(progn
				(if (and (>= Ic Cm) (< Ic (+ Cm 12)))
					(setq lista_temp (cons ads lista_temp))
				)
				(setq Ic (+ Ic 1))
			)
		)
		(reverse lista_temp)
		
	)	
;
;
;
;----------------------------------------------------------------

	(setq lista_temp (redefinir IL lista_blocos))
	(setq slideant nil)

	(foreach ads (list "sld1" "sld2" "sld3" "sld4" "sld5" "sld6" "sld7" "sld8" "sld9" "sld10" "sld11" "sld12")
		(progn
			(setq x (dimx_tile ads))
			(setq y (dimx_tile ads))

			(start_image ads)
			(fill_image 0 0 x y 0)
			(slide_image 0 -47 x y "")
			(end_image)		
		)
	)
	
	(setq Ic 1)
	(foreach ads lista_temp
		(progn
			
			(setq x (dimx_tile (strcat "sld" (itoa Ic))))
			(setq y (dimx_tile (strcat "sld" (itoa Ic))))

			(start_image (strcat "sld" (itoa Ic)))
			(fill_image 0 0 x y 0)
			(slide_image 0 -47 x y ads)
			(end_image)		
			
			(setq Ic (+ Ic 1))
		)
	)

)
;	Função do botão proximo.
;	Funções que atualiza as imagens e ativa a primeira da proxima lista.
;	Globais: IL
(defun proximo ()
	(setq IL (+ IL 12))
	(atualizar_imagens IL)
	(set_tile "bloco" (itoa (- IL 1)))
	(ativar_imagem 1)
	(setq bloco (nth (atoi (get_tile "bloco")) lista_blocos))
	(inserir_desc bloco)	
)
;	Função do botão anterior.
;	Funções que atualiza as imagens e ativa a primeira da lista anterior.
;	Globais: IL lista_blocos
(defun anterior (/)
	(setq IL (- IL 12))
	(if (< IL 0) (setq IL 1))
	(atualizar_imagens IL)
	(set_tile "bloco" (itoa (- IL 1)))
	(ativar_imagem 1)
	(setq bloco (nth (atoi (get_tile "bloco")) lista_blocos))
	(inserir_desc bloco)
)
;	Ativa pela imagem.
;	Entrada: numero referente ao slide.
;	Globais: slideant
(defun ativar_imagem (slide)

	(if slideant
		(mode_tile slideant 4)
	)
	(mode_tile (strcat "sld" (itoa slide)) 4)
	(setq slideant (strcat "sld" (itoa slide)))
	
)
;	Ativa pelo icone.
;	Entrada: numero referente ao slide.
;	Globais: lista_blocos
(defun ativar_icone (icone /)

	(ativar_imagem icone)
	(set_tile "bloco" (itoa (+ (- IL 2) icone)))
	(setq bloco (nth (atoi (get_tile "bloco")) lista_blocos))
	(inserir_desc bloco)

)
;
;	Ao selecionar o bloco atualiza as informações.
;	Globais: lista_blocos
(defun bloco_selecionado (/ It pos teste)

	(setq bloco (nth (atoi (get_tile "bloco")) lista_blocos))
	(setq pos (+ (vl-position bloco lista_blocos) 1))
	
	(setq It 1)
	(setq teste T)

	(while teste
		(if (and (>= pos It) (< pos (+ It 12)))
			(progn
				(if (/= It IL)
					(progn
						(atualizar_imagens It)
						(setq IL It)
					)
				)
				(setq teste nil)
			)
			(setq It (+ It 12))
		)
	)
	
	(ativar_imagem (+ (- pos It) 1))
	(inserir_desc bloco)
)
;
;	Pesquisa e insere as descrições.
;	Globais: biblioteca
(defun inserir_desc (bloco / linha info ini)

	(if bloco
		(progn
			(setq ini (open biblioteca "r"))
			
			(setq linha "")
			(while linha
				(setq linha (read-line ini))
				(if linha 
					(if (vl-string-search (strcat bloco "|") linha)
						(setq info (filtrar linha))
					)
				)
			)
			
			(close ini)
			
			(if info
				(progn
					(set_tile "leg1" (cdr (assoc 1 info)))
					(set_tile "leg2" (cdr (assoc 2 info)))
				)
			)
		)
		(progn
			(set_tile "leg1" "")
			(set_tile "leg2" "")
		)
	)

)
;
;	Finaliza o dialog e ativa a função de inserir o bloco.
;	Globais: ins bloco
(defun inserir ()

	(if bloco 
		(progn
			(setq ins T)
			(done_dialog)
		)
		(alert "Selecione o bloco!")
	)

)
;
;
;
;--------------------------------------------------------------------------------------------------------------------


	(setq biblioteca (findfile "bb.ini"))
	(setq dcl_id (load_dialog (findfile "bb.dcl")))
	(setq grupos (levantar_grupos))
	
	(new_dialog "bb" dcl_id)

	(start_list "grupos" 3 0)
	(foreach ads grupos (add_list (car ads)))
	(end_list)

	(atualizar_subgrupo)

	(action_tile "inserir" "(inserir)")
	(action_tile "sair" "(setq ins nil) (done_dialog)")
	(action_tile "editar" "(editar bloco)")
	(action_tile "novo" "(novo)")
	
	(action_tile "ant" "(anterior)")
	(action_tile "prox" "(proximo)")
	(action_tile "grupos" "(atualizar_subgrupo)")
	(action_tile "subgrupos" "(atualizar_blocos)")
	(action_tile "bloco" "(bloco_selecionado)")

	(action_tile "sld1" "(ativar_icone 1)")
	(action_tile "sld2" "(ativar_icone 2)")
	(action_tile "sld3" "(ativar_icone 3)")
	(action_tile "sld4" "(ativar_icone 4)")
	(action_tile "sld5" "(ativar_icone 5)")
	(action_tile "sld6" "(ativar_icone 6)")
	(action_tile "sld7" "(ativar_icone 7)")
	(action_tile "sld8" "(ativar_icone 8)")
	(action_tile "sld9" "(ativar_icone 9)")
	(action_tile "sld10" "(ativar_icone 10)")
	(action_tile "sld11" "(ativar_icone 11)")
	(action_tile "sld12" "(ativar_icone 12)")

	(start_dialog)
	(unload_dialog dcl_id)

	(if ins
		(command "_.insert" bloco pause pause pause)
	)
	
	(princ)
	
)