; extends
(macro_invocation
  macro: (scoped_identifier
    path: (identifier) @_sqlx
    name: (identifier) @_query)
  (#eq? @_sqlx "sqlx")
  (#match? @_query "^query")
  (token_tree
    (raw_string_literal
      (string_content) @injection.content))
  (#set! injection.language "sql"))
