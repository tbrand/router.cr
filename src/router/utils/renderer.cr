module Router
  macro def_view(view, file, props)
    record {{view.id.camelcase}}{% for prop, typ in props %},{{prop.id}} : {{typ.id}}{% end %} do
      ECR.def_to_s "{{file.id}}"
    end
  end

  macro def_view(view, file, **props)
    def_view({{view}}, {{file}}, {{props}})
  end

  macro render_view(view, *vals)
    {{view.id.camelcase}}.new({% for val, i in vals %}{{val}}{% if i != vals.size - 1 %},{% end %}{% end %}).to_s
  end
end
