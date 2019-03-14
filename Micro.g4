// Define a grammar called Micro
grammar Micro;

// Regular expressions
    KEYWORD        :  ( 'PROGRAM'
                   |    'BEGIN'
                   |    'END'
                   |    'FUNCTION'
                   |    'READ'
                   |    'WRITE'
                   |    'IF'
                   |    'ELSE'
                   |    'ENDIF'
                   |    'FOR'
                   |    'ENDFOR'
                   |    'RETURN'
                   |    'INT'
                   |    'VOID'
                   |    'STRING'
                   |    'FLOAT' )
                   ;

    OPERATOR       :  ( ':='
                   |    '+'
                   |    '-'
                   |    '*'
                   |    '/'
                   |    '='
                   |    '!='
                   |    '<'
                   |    '>'
                   |    '('
                   |    ')'
                   |    ';'
                   |    ','
                   |    '<='
                   |    '>=' )
                   ;

    IDENTIFIER     :  (( [A-Z] | [a-z] )+ ( [A-Z] | [a-z] | [0-9] )*) ;
    INTLITERAL     :  ( [0-9]+ );
    FLOATLITERAL   :  ( [0-9]* '.' [0-9]+);
    STRINGLITERAL  :  ( '"' ~ ('"') * '"');
    COMMENT        :  ( '--' .*? '\n') -> skip ; // skip comments
    WS             :  ( ' '
                   |    '\t'
                   |    '\r'
                   |    '\n' )+ -> skip
                   ;  // skip spaces, tabs, newlines


/*	Grammar	rules	*/
/*	Capital	case	symbols	are	terminals	*/
/*	Small	case	symbols	are	non-terminals	*/

	/* Program */
    program	 :  'PROGRAM' id 'BEGIN' pgm_body 'END' ;
	id		 :	IDENTIFIER ;
	pgm_body :	decl func_declarations ;
	decl     :	string_decl	decl
	         |  var_decl decl
	         |
	         ;

	/* String Declaration */
	string_decl	:  'STRING' id	':=' str ';' ;
	str         :  STRINGLITERAL ;

	/* Variable Declaration	*/
	var_decl  :	var_type id_list ';' ;
	var_type  :	'FLOAT'
	          | 'INT'
	          ;
	any_type  :	var_type
	          | 'VOID'
	          ;
	id_list   :	id id_tail ;
	id_tail   :	',' id id_tail
	          |
	          ;

	/* Function Parameter List */
	param_decl_list : param_decl param_decl_tail
	                |
                    ;
	param_decl      : var_type id ;
	param_decl_tail	: ',' param_decl param_decl_tail
	                |
                    ;

	/* Function	Declarations */
	func_declarations  : func_decl func_declarations
	                   |
	                   ; 
	func_decl          : 'FUNCTION' any_type id	'(' param_decl_list ')' 'BEGIN'	func_body 'END' ;
	func_body          : decl stmt_list ;

	/* Statement List */
	stmt_list  :  stmt stmt_list
	           |
	           ;
	stmt       :  basic_stmt
	           |  if_stmt
	           |  for_stmt
	           ;
	basic_stmt :  assign_stmt
	           |  read_stmt
	           |  write_stmt
	           |  return_stmt
	           ;

	/* Basic Statements	*/
	assign_stmt :	assign_expr	';' ;
	assign_expr	: 	id ':=' expr ;
	read_stmt   :	'READ' '(' id_list ')' ';' ;
	write_stmt  :	'WRITE' '('	id_list	')' ';' ;
	return_stmt :	'RETURN' expr ';' ;

    /* if_stmt */
    if_stmt   :	'IF' '(' cond ')' decl stmt_list else_part 'ENDIF' ;
    else_part :	'ELSE' decl	stmt_list
              |
              ;
    cond      :	expr compare expr ;
    compare   : '='
              | '!='
              | '<='
              | '>='
              |	'<'
              | '>'
              ;

    /* for_stmt */
    for_stmt  : 'FOR' '(' init_expr ';' cond ';' incr_expr	')'	decl stmt_list 'ENDFOR' ;
    init_expr : assign_expr
              |
              ;
    incr_expr : assign_expr
              |
              ;

    /* Expressions */
    expr            :	expr_prefix	term ;
    expr_prefix     :	expr_prefix	term addop
                    |
                    ;
    term            :	factor_prefix factor ;
    factor_prefix   :	factor_prefix factor mulop
                    |
                    ;
    factor          :	primary
                    |   call_expr
                    ;
    primary	        :	'('	expr ')'
                    |   id
                    |	INTLITERAL
                    |   FLOATLITERAL
                    ;
    call_expr       :	id '(' expr_list ')' ;
    expr_list       :	expr expr_list_tail
                    |
                    ;
    expr_list_tail	:	',' expr expr_list_tail
                    |
                    ;
    addop	        :	'+'
                    |	'-'
                    ;
    mulop           :	'*'
                    |   '/'
                    ;
