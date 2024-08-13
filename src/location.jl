
const points_per_module_x = 32
const n_points_x = 32 * 6

const n_points_y = 3 * 4 * 2

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
    fine_x = 2 * (4 * _mat + _sipm) + 1
    reverted = _quarter ∈ [0, 3]
    if reverted
        fine_x = points_per_module_x - fine_x
    end
    fine_y = div(_quarter, 2)
    #
    x = (points_per_module_x * course_x + fine_x) * sign_x
    y = 2 * course_y + fine_y
    (; x, y)
end

"""
    standard_map(id2values)

Creates a 2D array with the values of a given dictionary of channel IDs.
Default values are `NaN`, only sipm present in the list are updated with the provided values.

# Arguments
- `id2values`: A list of pais of channel IDs and values.
"""
function standard_map(id2values)
    ids = first.(id2values)
    values = last.(id2values)
    #
    M = fill(NaN, n_points_y, n_points_x)
    for (id, val) in id2values
        ChannelID(id) |> location_bin_center |> xy -> begin
            x, y = xy
            i = div(x + n_points_x + 1, 2)
            j = y + 1
            M[j, i] = val
        end
    end
    return M
end
