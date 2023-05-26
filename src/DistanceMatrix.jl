using HTTP
using JSON

mutable struct Point 
    x :: Float64 
    y :: Float64
    Point() = new()
end

function getPointsFromFile() :: Vector{Point}
    points = Vector{Point}()
    
    path = (@__DIR__) * "/../data/coordinate.txt"
    open(path, "r") do io
        
        lines = readlines(io)
        for line in lines 
            lineArray = split(line, " ")
            x = parse(Float64, lineArray[1])
            y = parse(Float64, lineArray[2])    

            point = Point()
            point.x = x
            point.y = y
            push!(points, point)
        end
    end

    return points
end

function generateApiUrl(a, b)
    pointAEncoding = "$(a.y),$(a.x)"
    pointBEncoding = "$(b.y),$(b.x)"
    apiUrl = "http://router.project-osrm.org/route/v1/driving/$pointAEncoding;$pointBEncoding?overview=false"

    return apiUrl
end

function callApi(url :: String) 
    return HTTP.request("GET", url)
end

function processApiRes(res)
    res_text = String(res.body)
    res_json = JSON.parse(res_text)
    res_json_routes_array = res_json["routes"]
    res_json_routes = res_json_routes_array[1]
    distanceCost = res_json_routes["distance"]
    timeCost = res_json_routes["duration"]

    return timeCost, distanceCost
end

function getCost(a :: Point, b :: Point)   
    apiUrl = generateApiUrl(a, b)
    res = callApi(apiUrl)
    timeCost, distanceCost = processApiRes(res)
    
    return timeCost, distanceCost
end

function getDistanceMatrix(points :: Vector{Point})
    matrixDim = length(points)
    distanceMatrix = Matrix{Float64}(undef, matrixDim, matrixDim)
    timeMatrix = Matrix{Float64}(undef, matrixDim, matrixDim)
    
    for (indexA, pointA) in enumerate(points)
        for (indexB, pointB) in enumerate(points)
            timeCost, distanceCost = getCost(pointA, pointB)
            distanceMatrix[indexA, indexB] = distanceCost
            timeMatrix[indexA, indexB] = timeCost
        end
    end

    return timeMatrix, distanceMatrix
end

function printMatrixInFile(m, fileName)
    dim = size(m,1)

    path = (@__DIR__) * "/../data/$(fileName).txt"
    open(path, "w") do io
        write(io, "[\n")
        for r in 1:dim
            write(io, "[ ")
            for c in 1:dim
                write(io, "$(m[r,c]) ")
            end
            write(io, "]\n")
        end
        write(io, "]")
    end
end

@info "Getting points from input"
points = getPointsFromFile()

@info "Generating distance matrix"
tm, dm = getDistanceMatrix(points)

@info "Printing distance matrix in file"
printMatrixInFile(dm, "dm")

@info "Printing time matrix in file"
printMatrixInFile(tm, "tm")