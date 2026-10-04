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
function helper.add_cube_to_mesh(mesh, center, side_length, color)
  local half = side_length / 2
  local x = center[1]
  local y = center[2]
  local z = center[3]
  local a = {x - half, y - half, z - half}
  local b = {x - half, y + half, z - half}
  local c = {x + half, y + half, z - half}
  local d = {x + half, y - half, z - half}
  local e = {x - half, y - half, z + half}
  local f = {x - half, y + half, z + half}
  local g = {x + half, y + half, z + half}
  local h = {x + half, y - half, z + half}
  helper.add_line_to_mesh(mesh, {a, b, c, d}, {color, color, color, color}, true)
  helper.add_line_to_mesh(mesh, {e, f, g, h}, {color, color, color, color}, true)
  helper.add_line_to_mesh(mesh, {a, e}, {color, color})
  helper.add_line_to_mesh(mesh, {b, f}, {color, color})
  helper.add_line_to_mesh(mesh, {c, g}, {color, color})
  helper.add_line_to_mesh(mesh, {d, h}, {color, color})
end
function helper.make_color(r, g, b, a)
  local color = r * 256 + g
  color = color * 256 + b
  color = color * 256 + a
  return color
end
return helper