bb : dialog {
label = "Biblioteca";


:row {
:column {

: column {

: text { label = "Grupo:";}

: popup_list {
width = 25;
key = "grupos";
}

: popup_list {
width = 25;
key = "subgrupos";
}


: text { label = "Blocos:";}

: list_box {
key = "bloco";
width = 25;
height = 27;
}

spacer;

}
}

: column {

		: row {
		
			fixed_height = true;
			height = 8;
			
			: icon_image {
			key = "sld1";
			fixed_width = true;
			width = 20;
			fixed_height = true;
			height = 8;
			color = 0;
			}
			: icon_image {
			key = "sld2";
			fixed_width = true;
			width = 20;
			fixed_height = true;
			height = 8;
			color = 0;
			}
			: icon_image {
			key = "sld3";
			fixed_width = true;
			width = 20;
			fixed_height = true;
			height = 8;
			color = 0;
			}
			: icon_image {
			key = "sld4";
			fixed_width = true;
			width = 20;
			fixed_height = true;
			height = 8;
			color = 0;
			}
		}
		: row {
		
			fixed_height = true;
			height = 8;
			
			: icon_image {
			key = "sld5";
			fixed_width = true;
			width = 20;
			fixed_height = true;
			height = 8;
			color = 0;
			}
			: icon_image {
			key = "sld6";
			fixed_width = true;
			width = 20;
			fixed_height = true;
			height = 8;
			color = 0;
			}
			: icon_image {
			key = "sld7";
			fixed_width = true;
			width = 20;
			fixed_height = true;
			height = 8;
			color = 0;
			}
			: icon_image {
			key = "sld8";
			fixed_width = true;
			width = 20;
			fixed_height = true;
			height = 8;
			color = 0;
			}
		}
		: row {
			fixed_height = true;
			height = 8;
			
			: icon_image {
			key = "sld9";
			fixed_width = true;
			width = 20;
			fixed_height = true;
			height = 8;
			color = 0;
			}
			: icon_image {
			key = "sld10";
			fixed_width = true;
			width = 20;
			fixed_height = true;
			height = 8;
			color = 0;
			}
			: icon_image {
			key = "sld11";
			fixed_width = true;
			width = 20;
			fixed_height = true;
			height = 8;
			color = 0;
			}
			: icon_image {
			key = "sld12";
			fixed_width = true;
			width = 20;
			fixed_height = true;
			height = 8;
			color = 0;
			}
		}
		
		: row {
		fixed_height = true;
		height = 1;

			: button {
			fixed_width = true;
			width = 20;
			height = 1;	
			key = "ant";
			label = "< Anterior";
			}
			
			: button {
			fixed_width = true;
			width = 20;
			height = 1;
			key = "prox";
			label = "Proximo >";
			}
			
		}
		:column {
		label = "Descrição";
		: text {
		key = "leg1";
		}
		: text {
		key = "leg2";
		}
		spacer;
		}
		spacer;

}

}




: row {

	fixed_width = true;
	alignment = centered;
	
	: button {
	key = "inserir";
	label = "Inserir";
	is_default = true;
	fixed_width = true;
	width = 35;
	height = 2;
	}

	: spacer { width = 22; }
	
	: button {
	key = "sair";
	label = "Sair";
	is_cancel = true;
	fixed_width = true;
	width = 35;
	height = 2;
	}

}
}


