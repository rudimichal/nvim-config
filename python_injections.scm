;extends

(string
    (string_content) @injection.content 
        (#match? @injection.content "\\V/>\\|</\\|{{\\|{%")
        (#set! injection.language "htmldjango"))
