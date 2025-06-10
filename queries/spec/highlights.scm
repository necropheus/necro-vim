; Palabras clave de definiciones
("pred") @keyword
("aux") @keyword
("proc") @keyword
("requiere") @keyword
("asegura") @keyword

; Palabras clave para TAD y sus componentes
("TAD") @keyword
("obs") @keyword
("Type") @keyword

; Nombre del TAD
((tad_definition name: (identifier)) @class)

; Observadores: resalta el nombre y el tipo observado
((obs_definition obsName: (identifier)) @field)
((obs_definition obsType: (obs_type)) @type)

; Alias de tipo dentro de un TAD
((type_alias name: (identifier)) @typeAlias)
((type_alias aliased: (type)) @type)

; Booleanos
(boolean) @constant

; Captura para "mod" (ahora se resalta como keyword)
(mod_operator) @keyword

; Captura del signo "=" en auxiliares
((aux_function assign: ("=")) @assignment)
; Capturar "res" como keyword especial; debe ir antes de la regla para variables
((non_binary_expr (identifier) @res_keyword (#eq? @res_keyword "res")))

; Resto de reglas (variables, parámetros, etc.)
((quantified_expr var: (identifier)) @variable)
((non_binary_expr (identifier) @variable (#match? @variable "^[a-z]$")))

(pred_definition (identifier) @function)
((aux_function name: (identifier)) @function)
((proc_function name: (identifier)) @function)

(parameter (identifier) @parameter)
(parameter (type) @type)

(atomic_type) @type
(uple_type) @type

((sequence_type seq_keyword: (seq_keyword) @type_keyword))
((sequence_type inner: (type)) @typeParameter)

(binary_operator) @operator
(quantified_expr) @keyword

((function_call function: (identifier)) @function)

(summation_expr) @function
(product_expr) @function

(number) @number

"(" @punctuation
")" @punctuation
"{" @punctuation
"}" @punctuation
"<" @punctuation
">" @punctuation
":" @punctuation
"," @punctuation
