From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v10 07/21] KVM: ARM64: PMU: Add perf event map and
 introduce perf event creating function
Date: Thu, 28 Jan 2016 16:45:36 +0000
Message-ID: <56AA45B0.3060205@arm.com>
References: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
 <1453866709-20324-8-git-send-email-zhaoshenglong@huawei.com>
 <20160128163115.GC3807@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160128163115.GC3807@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, Shannon Zhao <zhaoshenglong@huawei.com>, will.deacon@arm.com
Cc: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 28/01/16 16:31, Andrew Jones wrote:
> On Wed, Jan 27, 2016 at 11:51:35AM +0800, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>
>> When we use tools like perf on host, perf passes the event type and the
>> id of this event type category to kernel, then kernel will map them to
>> hardware event number and write this number to PMU PMEVTYPER<n>_EL0
>> register. When getting the event number in KVM, directly use raw event
>> type to create a perf_event for it.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  arch/arm64/include/asm/pmu.h |   3 ++
>>  arch/arm64/kvm/Makefile      |   1 +
>>  include/kvm/arm_pmu.h        |  10 ++++
>>  virt/kvm/arm/pmu.c           | 122 +++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 136 insertions(+)
>>  create mode 100644 virt/kvm/arm/pmu.c
>>
>> diff --git a/arch/arm64/include/asm/pmu.h b/arch/arm64/include/asm/pmu.h
>> index 4406184..2588f9c 100644
>> --- a/arch/arm64/include/asm/pmu.h
>> +++ b/arch/arm64/include/asm/pmu.h
>> @@ -21,6 +21,7 @@
>>  
>>  #define ARMV8_MAX_COUNTERS      32
>>  #define ARMV8_COUNTER_MASK      (ARMV8_MAX_COUNTERS - 1)
>> +#define ARMV8_CYCLE_IDX         (ARMV8_MAX_COUNTERS - 1)
> 
> I'm not sure we want to add this. It's name is wrong, as it's really
> PMCNTENSET_EL0.C, and just a few lines above we have the idx defined
> already (ARMV8_IDX_CYCLE_COUNTER), but as zero, because
> arch/arm64/kernel/perf_event.c maps it that way.
> 
> I think we should do the same with the pmc array, i.e. map the cycle
> counter to idx zero.

I tend to have the opposite view. Not for the sake of it, but because I
find it helpful to directly map the code to the architecture
documentation without having to bend another handful of neurons.

Will probably had some good reasons to structure it that way, but I
don't know the rational. Will?

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
