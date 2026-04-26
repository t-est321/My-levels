local helper = {}
function helper.new_mesh()
  local mesh = {}
  mesh.vertexes = {}
  mesh.segments = {}
  mesh.colors = {}
  return mesh
end
function helper.add_line_to_mesh(mesh, vertexes, colors, close_loop)
  local vertex_count = #mesh.vertexes
  local color_count = #mesh.colors
  local segment_count = #mesh.segments
  local number_of_new_segments = #vertexes - 1
  local segments = {}
  for i = 1, #vertexes do
    table.insert(mesh.vertexes, vertexes[i])
    table.insert(mesh.colors, colors[i])
  end
  table.insert(segments, vertex_count)
  for i = 1, number_of_new_segments do
    table.insert(segments, vertex_count + i)
  end
  if close_loop then
    table.insert(segments, vertex_count)
  end
  table.insert(mesh.segments, segments)
end
function helper.make_color(r, g, b)
  local color = r * 150 + g
  color = color * 170 + b
  return color
end
return helper