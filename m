From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v2 5/5] KVM: arm/arm64: support chained PMU counters
Date: Thu, 14 Feb 2019 11:42:15 +0000
Message-ID: <236797c3-9f3a-91d4-c859-e8eb4d3eb3ee@arm.com>
References: <1549299218-44714-1-git-send-email-andrew.murray@arm.com>
 <1549299218-44714-6-git-send-email-andrew.murray@arm.com>
 <11a8c800-5c1d-08ce-9d85-402ca89727a3@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 298094A1FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Feb 2019 06:42:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VnR7N0gOSixB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Feb 2019 06:42:23 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C403F40217
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Feb 2019 06:42:23 -0500 (EST)
In-Reply-To: <11a8c800-5c1d-08ce-9d85-402ca89727a3@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: julien.thierry@arm.com, andrew.murray@arm.com, christoffer.dall@arm.com, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 05/02/2019 14:33, Julien Thierry wrote:
> Hi Andrew,
> 
> On 04/02/2019 16:53, Andrew Murray wrote:
>> Emulate chained PMU counters by creating a single 64 bit event counter
>> for a pair of chained KVM counters.
>>
>> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
>> ---
>>   include/kvm/arm_pmu.h |   1 +
>>   virt/kvm/arm/pmu.c    | 321 +++++++++++++++++++++++++++++++++++++++++---------
>>   2 files changed, 269 insertions(+), 53 deletions(-)
>>
>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> index b73f31b..8e691ee 100644
>> --- a/include/kvm/arm_pmu.h
>> +++ b/include/kvm/arm_pmu.h
>> @@ -29,6 +29,7 @@ struct kvm_pmc {
>>   	u8 idx;	/* index into the pmu->pmc array */
>>   	struct perf_event *perf_event;
>>   	u64 bitmask;
>> +	u64 overflow_count;
>>   };
>>   
>>   struct kvm_pmu {
>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>> index a64aeb2..9318130 100644
>> --- a/virt/kvm/arm/pmu.c
>> +++ b/virt/kvm/arm/pmu.c
>> @@ -24,9 +24,25 @@
>>   #include <kvm/arm_pmu.h>
>>   #include <kvm/arm_vgic.h>
>>   
>> +#define ARMV8_PMUV3_PERFCTR_CHAIN 0x1E
> 
> I find it a bit awkward to have this redefined here.
> 
> Maybe we could define a helper in kvm_host.h:
> bool kvm_pmu_typer_is_chain(u64 typer);
> 
> That would always return false for arm32?

We don't support ARMv7 host, so that doesn't matter. But
it is a good idea to wrap it in a function here.

>>   		kvm_vcpu_kick(vcpu);
>> @@ -440,6 +632,10 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>>   	    select_idx != ARMV8_PMU_CYCLE_IDX)
>>   		return;
>>   
>> +	/* Handled by even event */
>> +	if (eventsel == ARMV8_PMUV3_PERFCTR_CHAIN)
>> +		return;
>> +
>>   	memset(&attr, 0, sizeof(struct perf_event_attr));
>>   	attr.type = PERF_TYPE_RAW;
>>   	attr.size = sizeof(attr);
>> @@ -452,6 +648,9 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>>   	attr.config = (select_idx == ARMV8_PMU_CYCLE_IDX) ?
>>   		ARMV8_PMUV3_PERFCTR_CPU_CYCLES : eventsel;
>>   
>> +	if (kvm_pmu_event_is_chained(vcpu, select_idx))
>> +		attr.config1 |= 0x1;
> 
> I'm not very familiar with the usage of perf attributes configs, but is
> there any chance we could name this flag? Even if only for the local
> file? Something like PERF_ATTR_CFG1_KVM_PMU_CHAINED (unless there is an
> existing naming convention for event attributes).

There is ARPMU_EVT_64BIT in "linux/perf/arm_pmu.h". But in general we don't
specify where the Bit goes in (i.e, CFG1 etc).

Cheers
Suzuki
