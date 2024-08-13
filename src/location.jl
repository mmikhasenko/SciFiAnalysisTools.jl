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
    @unpack _station, _layer, _module, _quarter, _mat, _sipm = id
    #
    sign_x = (2 * isodd(_quarter) - 1)
    course_x = _module
    course_y = 4 * (_station - 1) + _layer
    #
    Nx = 32
    fine_x = 2 * (4 * _mat + _sipm) + 1
    reverted = _quarter ∈ [0, 3]
    if reverted
        fine_x = Nx - fine_x
    end
    fine_y = div(_quarter, 2)
    #
    x = (Nx * course_x + fine_x) * sign_x
    y = 2 * course_y + fine_y
    (; x, y)
end
