# @preprocessor typescript
@builtin "number.ne"
@builtin "whitespace.ne"

Main    -> _ Term _           {% d => d[1] %}
         | _ Matrix _         {% d => d[1] %}
         | _ "[" _ Matrix _ "]" _
                              {% d => d[3] %}
Matrix  -> "[" _ Row _ "]" _ ",":? _
                              {% d => [d[2]] %}
         | "[" _ Row _ "]" _ "," _ Matrix
                              {% d => [d[2]].concat(d[8]) %}
Row     -> Term               {% d => [d[0]] %}
         | Term _ "," _ Row   {% d => [d[0]].concat(d[4]) %}
Term    -> Subterm            {% id %}
         | Option             {% d => new GeneradorDeCasillaOpcion(d[0]) %}
         | "\"" _ Term _ "\"" {% d => d[2] %}
         | "'" _ Term _ "'"   {% d => d[2] %}
Option  -> Subterm _ "|" _ Subterm
                              {% d => [d[0],d[4]] %}
         | Subterm _ "|" _ Option 
                              {% d => [d[0]].concat(d[4]) %}
Subterm -> Atom               {% id %}
         | Maybe              {% id %}
Maybe   -> Atom _ "?"         {% d => new GeneradorDeCasillaMaybe(d[0]) %}
Maybe   -> Atom _ "?" _ "(" _ decimal _ ")"
                              {% d => new GeneradorDeCasillaMaybe(d[0],d[6]) %}
Atom    -> Id                 {% d => new GeneradorDeCasillaSimple(d[0]) %}
         | Bag                {% id %}
         | Col                {% id %}
         | Nil                {% id %}
         | "(" _ Term _ ")"   {% d => d[2] %}
Id      -> [a-zA-Z0-9]:+      {% d => d[0].join("") %}
Bag     -> "$"                {% d => new GeneradorDeCasillaBolsa() %}
         | "$" _ Id           {% d => new GeneradorDeCasillaBolsa(d[2]) %}
Col     -> "*"                {% d => new GeneradorDeCasillaColeccion() %}
         | "*" _ Id           {% d => new GeneradorDeCasillaColeccion(d[2]) %}
Nil     -> "-"                {% d => new GeneradorDeCasillaVacia() %}
