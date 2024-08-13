"""
    location_bin_center(id)

Calculates the center of the bin (x, y) corresponding to a given channel ID in the detector's
coordinate system.

# Arguments
- `id`: A `NamedTuple` or object with attributes `_module`, `_quarter`, `_station`, `_layer`,
  `_mat`, and `_sipm`, representing the components of the channel ID.

# Details
- `x` is computed by determining the coarse position based on the module and quarter, and then
  refining it with the mat and SiPM information.
- `y` is computed by combining the station and layer information with the quarter's contribution.
"""
function location_bin_center(id)
    course_x = -id._module * (2isodd(id._quarter) - 1)
    course_y = 4 * (id._station - 1) + id._layer
    #
    fine_x = (4 * id._mat + id._sipm + 0.5) / 16
    reverted = id._quarter ∈ [0, 3]
    if reverted
        fine_x = 1 - fine_x
    end
    fine_y = div(id._quarter, 2) / 2
    #
    x = course_x + fine_x
    y = course_y + fine_y
    (; x, y)
end
