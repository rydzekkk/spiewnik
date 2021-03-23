using SonglistGenerator;
using Xunit;

namespace SonglistGeneratorTests
{
    public class CaretsWrapperTests
    {
        [Theory]
        [ClassData(typeof(CaretsWrapperTestData))]
        public void CaretsWrapper_ShouldWrapAllCaretsInSongs(string _, string input, string expectedOutput)
        {
            // act
            var result = CaretsWrapper.WrapCarets(input);

            // assert
            Assert.Equal(expectedOutput, result);
        }
    }
}
