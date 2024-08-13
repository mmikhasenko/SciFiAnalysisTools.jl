

const masks = (
    _channel = 0x7f,    # 00000000000001111111
    _sipm = 0x180,   # 00000000000110000000
    _mat = 0x600,   # 00000000011000000000
    _module = 0x3800,  # 00000011100000000000
    _quarter = 0xc000,  # 00001100000000000000
    _layer = 0x30000, # 00110000000000000000
    _station = 0xc0000, # 11000000000000000000
)

TLQMD(ch_id) =
    "T$(ch_id._station)L$(ch_id._layer)Q$(ch_id._quarter)M$(ch_id._module)_mat$(ch_id._mat)_sipm$(ch_id._sipm)"


function take_bits(input, mask)
    shift_amount = trailing_zeros(mask)
    return (input & mask) >> shift_amount
end

function ChannelID(id)
    names = keys(masks)
    vals = take_bits.(id, values(masks))
    #
    NamedTuple{names}(vals .|> Int)
end

function id2hex(ch_id)
    id = 0x0
    for (name, value) in pairs(ch_id)
        mask = masks[name]
        shift_amount = trailing_zeros(mask)
        id |= (UInt32(value) << shift_amount) & mask
    end
    return id
end
