using DotnetService;
using Grpc.Core;

namespace dotnetservice.Services
{
    public class SpikeService : DotnetService.SpikeService.SpikeServiceBase
    {
        public override Task<SpikeResponse> TriggerSpike(SpikeRequest request, ServerCallContext context)
        {
            // CPU spike
            Task.Run(() =>
            {
                for (int i = 0; i < request.CpuIntensity * 1000000; i++)
                {
                    _ = i * i;
                }
            });

            // Memory spike
            var memoryList = new List<byte[]>();
            memoryList.Add(new byte[request.MemoryMb * 1024 * 1024]);

            return Task.FromResult(new SpikeResponse
            {
                Success = true,
                Message = "Spike triggered successfully"
            });
        }
    }
}
