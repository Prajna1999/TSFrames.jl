# import all packages at the top level. These statements
# include all these packages into the global scope of current module
module DataObjects


using Random
using DataFrames
using Dates

export DATA_SIZE, COLUMN_NO
export random, data_vector, data_array, data_array_long
export column_vector, index_range, index_integer, index_integer
export df_vector, df_integer_index, df_timetype_index, df_timetype_index_long_columns


# constants
const DATA_SIZE = 400
const COLUMN_NO = 100

# function and variables
const random(x) = rand(MersenneTwister(123), x)
data_vector = randn(DATA_SIZE)
const integer_data_vector = rand(-100:100, DATA_SIZE)
const data_array = Array([data_vector data_vector])
const data_array_long = reduce(hcat, [randn(DATA_SIZE) for i in 1:COLUMN_NO])

const column_vector = ["data$i" for i in 1:COLUMN_NO]

const index_range = 1:DATA_SIZE
const index_integer = collect(index_range)
const index_timetype = Date(2007, 1, 1) + Day.(0:(DATA_SIZE-1))

const df_vector = DataFrame([data_vector], ["data"])
const df_integer_index = DataFrame(Index=index_integer, data=data_vector)
const df_timetype_index = DataFrame(Index=index_timetype, data=data_vector)
const df_timetype_index_long_columns = insertcols!(
    DataFrame(data_array_long, column_vector), 1, :Index => index_timetype)
end