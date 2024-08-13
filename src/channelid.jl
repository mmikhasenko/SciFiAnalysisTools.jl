
# taken from the code,
# - [scurvefit](https://gitlab.cern.ch/pacific-calibration/scurvefit/-/blob/master/scurvefit/objects/include/SFChannelId.h)
const masks = (
    _channel = 0x7f,    # 00000000000001111111
    _sipm = 0x180,   # 00000000000110000000
    _mat = 0x600,   # 00000000011000000000
    _module = 0x3800,  # 00000011100000000000
    _quarter = 0xc000,  # 00001100000000000000
    _layer = 0x30000, # 00110000000000000000
    _station = 0xc0000, # 11000000000000000000
)

"""
    TLQMD(ch_id)

Converts a given channel ID object into a formatted string representation.

Args:
    id: An object representing the channel ID with attributes `_station`, `_layer`,
        `_quarter`, `_module`, `_mat`, and `_sipm`.

Returns:
    A string in the format "T{station}L{layer}Q{quarter}M{module}_mat{mat}_sipm{sipm}".
"""
TLQMD(ch_id) =
    "T$(ch_id._station)L$(ch_id._layer)Q$(ch_id._quarter)M$(ch_id._module)_mat$(ch_id._mat)_sipm$(ch_id._sipm)"


function take_bits(input, mask)
    shift_amount = trailing_zeros(mask)
    return (input & mask) >> shift_amount
end

"""
    ChannelID(id)

Converts a given channel ID as hex into a ChannelID which is a `NamedTuple`.
THe extraction of each field uses predefined bit masks (`SciFiAnalysisTools.masks`) and bit algebra.

# Arguments
- `id`: An integer or hex representing the encoded channel ID.
"""
function ChannelID(id)
    names = keys(masks)
    vals = take_bits.(id, values(masks))
    #
    NamedTuple{names}(vals .|> Int)
end

"""
    id2hex(ch_id)

Encodes a channel ID, provided as a `ChannelID` named tuple, into a hexadecimal value by
applying bitwise operations according to predefined masks.

# Arguments
- `ch_id`: a `ChannelID` named tuple containing components of the channel ID.
"""
function id2hex(ch_id)
    id = 0x0
    for (name, value) in pairs(ch_id)
        mask = masks[name]
        shift_amount = trailing_zeros(mask)
        id |= (UInt32(value) << shift_amount) & mask
    end
    return id
end
