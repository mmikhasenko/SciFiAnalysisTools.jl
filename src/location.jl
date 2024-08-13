
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
