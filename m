From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v3 00/20] KVM: ARM64: Add guest PMU support
Date: Tue, 27 Oct 2015 09:15:09 +0800
Message-ID: <562ED01D.4000308@linaro.org>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
 <20151026113349.GA20298@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151026113349.GA20298@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, wei@redhat.com, alex.bennee@linaro.org, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/10/26 19:33, Christoffer Dall wrote:
> On Thu, Sep 24, 2015 at 03:31:05PM -0700, Shannon Zhao wrote:
>> This patchset adds guest PMU support for KVM on ARM64. It takes
>> trap-and-emulate approach. When guest wants to monitor one event, it
>> will be trapped by KVM and KVM will call perf_event API to create a perf
>> event and call relevant perf_event APIs to get the count value of event.
>>
>> Use perf to test this patchset in guest. When using "perf list", it
>> shows the list of the hardware events and hardware cache events perf
>> supports. Then use "perf stat -e EVENT" to monitor some event. For
>> example, use "perf stat -e cycles" to count cpu cycles and
>> "perf stat -e cache-misses" to count cache misses.
>>
>> Below are the outputs of "perf stat -r 5 sleep 5" when running in host
>> and guest.
>>
>> Host:
>>  Performance counter stats for 'sleep 5' (5 runs):
>>
>>           0.551428      task-clock (msec)         #    0.000 CPUs utilized            ( +-  0.91% )
>>                  1      context-switches          #    0.002 M/sec
>>                  0      cpu-migrations            #    0.000 K/sec
>>                 48      page-faults               #    0.088 M/sec                    ( +-  1.05% )
>>            1150265      cycles                    #    2.086 GHz                      ( +-  0.92% )
>>    <not supported>      stalled-cycles-frontend
>>    <not supported>      stalled-cycles-backend
>>             526398      instructions              #    0.46  insns per cycle          ( +-  0.89% )
>>    <not supported>      branches
>>               9485      branch-misses             #   17.201 M/sec                    ( +-  2.35% )
>>
>>        5.000831616 seconds time elapsed                                          ( +-  0.00% )
>>
>> Guest:
>>  Performance counter stats for 'sleep 5' (5 runs):
>>
>>           0.730868      task-clock (msec)         #    0.000 CPUs utilized            ( +-  1.13% )
>>                  1      context-switches          #    0.001 M/sec
>>                  0      cpu-migrations            #    0.000 K/sec
>>                 48      page-faults               #    0.065 M/sec                    ( +-  0.42% )
>>            1642982      cycles                    #    2.248 GHz                      ( +-  1.04% )
>>    <not supported>      stalled-cycles-frontend
>>    <not supported>      stalled-cycles-backend
>>             637964      instructions              #    0.39  insns per cycle          ( +-  0.65% )
>>    <not supported>      branches
>>              10377      branch-misses             #   14.198 M/sec                    ( +-  1.09% )
>>
>>        5.001289068 seconds time elapsed                                          ( +-  0.00% )
> 
> This looks pretty cool!
> 
> I'll review your next patch set version in more detail.
> 
> Have you tried runnig a no-op cycle counter read test in the guest and
> in the host?
> 
> Basically something like:
> 
> static void nop(void *junk)
> {
> }
> 
> static void test_nop(void)
> {
> 	unsigned long before,after;
> 	before = read_cycles();
> 	isb();
> 	nop(NULL);
> 	isb();
> 	after = read_cycles();
> }
> 
> I would be very curious to see if we get a ~6000 cycles overhead in the
> guest compared to bare-metal, which I expect.
> 
Ok, I'll try this while I'm doing more tests on v4.

> If we do, we should consider a hot-path in the the EL2 assembly code to
> read the cycle counter to reduce the overhead to something more precise.
>  

-- 
Shannon
