hex_to_bin = Dict(
    '0' => "0000",
    '1' => "0001",
    '2' => "0010",
    '3' => "0011",
    '4' => "0100",
    '5' => "0101",
    '6' => "0110",
    '7' => "0111",
    '8' => "1000",
    '9' => "1001",
    'A' => "1010",
    'B' => "1011",
    'C' => "1100",
    'D' => "1101",
    'E' => "1110",
    'F' => "1111",
)

binary = join([hex_to_bin[c] for c in strip(readline())])
total_version = 0

function eat(idx::Int, len::Int)::Tuple{Int,Int}
    value = parse(Int, binary[idx:idx+len-1]; base = 2)
    value, idx + len
end

function visit(idx::Int)::Tuple{Int,Int}
    global total_version, binary

    version, idx = eat(idx, 3)
    typeId, idx = eat(idx, 3)
    total_version += version
    if typeId == 4
        literal = 0
        while true
            num, idx = eat(idx, 5)
            more = num & 16
            literal = (literal << 4) + (num - more)
            if more == 0
                break
            end
        end
        literal, idx
    else
        lengthId, idx = eat(idx, 1)
        values = []
        if lengthId == 0
            # Total length in bits
            subSize, idx = eat(idx, 15)
            ending = idx + subSize
            while idx < ending
                value, idx = visit(idx)
                push!(values, value)
            end
        else
            # Number of sub-packets
            numPackets, idx = eat(idx, 11)
            for _ = 1:numPackets
                value, idx = visit(idx)
                push!(values, value)
            end
        end

        value = 0
        if typeId == 0
            value = +(values...)
        elseif typeId == 1
            value = *(values...)
        elseif typeId == 2
            value = min(values...)
        elseif typeId == 3
            value = max(values...)
        elseif typeId == 5
            value = values[1] > values[2] ? 1 : 0
        elseif typeId == 6
            value = values[1] < values[2] ? 1 : 0
        elseif typeId == 7
            value = values[1] == values[2] ? 1 : 0
        else
            error("invalid packet id: $typeId")
        end
        value, idx
    end
end

value, _ = visit(1)
println(total_version)
println(value)
