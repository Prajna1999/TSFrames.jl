using Test
using TSFrames
using DataFrames
using Dates


@testset "TSFrame setindex! Tests" begin
    dates = Date(2024, 1, 1):Day(1):Date(2024, 1, 10)
    test_df = DataFrame(
        Index=dates,
        data1=randn(10),
        data2=randn(10)
    )
    test_ts = TSFrame(test_df)
    @test typeof(test_ts.coredata) == DataFrame

    @testset "Basic single value assignment" begin
        # Test case 1: Setting single value with integer indices
        test_value = 99.9

        # Store original value
        original_value = test_ts[1, 1]

        # Perform the assignment
        test_ts[1, 1] = test_value

        # Test assertions
        @test test_ts[1, 1] == test_value
        @test test_ts[2, 1] != test_value  # Check other values weren't affected

        # Reset for next test
        test_ts[1, 1] = original_value

    end
end