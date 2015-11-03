From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v4 07/21] KVM: ARM64: PMU: Add perf event map and introduce
 perf event creating function
Date: Tue, 3 Nov 2015 10:33:32 +0800
Message-ID: <56381CFC.2070407@huawei.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>
 <1446186123-11548-8-git-send-email-zhaoshenglong@huawei.com>
 <5637C3D7.2010801@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0195249776
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2015 21:35:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5gCR-mGWYIa0 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2015 21:35:29 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C05894976C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2015 21:35:26 -0500 (EST)
In-Reply-To: <5637C3D7.2010801@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/11/3 4:13, Christopher Covington wrote:
> On 10/30/2015 02:21 AM, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>
>> When we use tools like perf on host, perf passes the event type and the
>> id of this event type category to kernel, then kernel will map them to
>> hardware event number and write this number to PMU PMEVTYPER<n>_EL0
>> register. When getting the event number in KVM, directly use raw event
>> type to create a perf_event for it.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> ---
>>  arch/arm64/include/asm/pmu.h |   2 +
>>  arch/arm64/kvm/Makefile      |   1 +
>>  include/kvm/arm_pmu.h        |  13 +++++
>>  virt/kvm/arm/pmu.c           | 117 +++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 133 insertions(+)
>>  create mode 100644 virt/kvm/arm/pmu.c
>>
>> diff --git a/arch/arm64/include/asm/pmu.h b/arch/arm64/include/asm/pmu.h
>> index b9f394a..2c025f2 100644
>> --- a/arch/arm64/include/asm/pmu.h
>> +++ b/arch/arm64/include/asm/pmu.h
>> @@ -31,6 +31,8 @@
>>  #define ARMV8_PMCR_D		(1 << 3) /* CCNT counts every 64th cpu cycle */
>>  #define ARMV8_PMCR_X		(1 << 4) /* Export to ETM */
>>  #define ARMV8_PMCR_DP		(1 << 5) /* Disable CCNT if non-invasive debug*/
>> +/* Determines which PMCCNTR_EL0 bit generates an overflow */
>> +#define ARMV8_PMCR_LC		(1 << 6)
>>  #define	ARMV8_PMCR_N_SHIFT	11	 /* Number of counters supported */
>>  #define	ARMV8_PMCR_N_MASK	0x1f
>>  #define	ARMV8_PMCR_MASK		0x3f	 /* Mask for writable bits */
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 1949fe5..18d56d8 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -27,3 +27,4 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3-emul.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += vgic-v3-switch.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>> +kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> index 254d2b4..1908c88 100644
>> --- a/include/kvm/arm_pmu.h
>> +++ b/include/kvm/arm_pmu.h
>> @@ -38,4 +38,17 @@ struct kvm_pmu {
>>  #endif
>>  };
>>  
>> +#ifdef CONFIG_KVM_ARM_PMU
>> +unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx);
>> +void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
>> +				    u32 select_idx);
>> +#else
>> +unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
>> +{
>> +	return 0;
>> +}
>> +void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
>> +				    u32 select_idx) {}
>> +#endif
>> +
>>  #endif
>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>> new file mode 100644
>> index 0000000..900a64c
>> --- /dev/null
>> +++ b/virt/kvm/arm/pmu.c
>> @@ -0,0 +1,117 @@
>> +/*
>> + * Copyright (C) 2015 Linaro Ltd.
>> + * Author: Shannon Zhao <shannon.zhao@linaro.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include <linux/cpu.h>
>> +#include <linux/kvm.h>
>> +#include <linux/kvm_host.h>
>> +#include <linux/perf_event.h>
>> +#include <asm/kvm_emulate.h>
>> +#include <kvm/arm_pmu.h>
>> +
>> +/**
>> + * kvm_pmu_get_counter_value - get PMU counter value
>> + * @vcpu: The vcpu pointer
>> + * @select_idx: The counter index
>> + */
>> +unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
>> +{
>> +	u64 counter, enabled, running;
>> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>> +
>> +	if (!vcpu_mode_is_32bit(vcpu))
>> +		counter = vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + select_idx);
>> +	else
>> +		counter = vcpu_cp15(vcpu, c14_PMEVCNTR0 + select_idx);
>> +
>> +	if (pmc->perf_event)
>> +		counter += perf_event_read_value(pmc->perf_event, &enabled,
>> +						 &running);
>> +
>> +	return counter & pmc->bitmask;
>> +}
>> +
>> +/**
>> + * kvm_pmu_stop_counter - stop PMU counter
>> + * @pmc: The PMU counter pointer
>> + *
>> + * If this counter has been configured to monitor some event, release it here.
>> + */
>> +static void kvm_pmu_stop_counter(struct kvm_pmc *pmc)
>> +{
>> +	struct kvm_vcpu *vcpu = pmc->vcpu;
>> +	u64 counter;
>> +
>> +	if (pmc->perf_event) {
>> +		counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
>> +		if (!vcpu_mode_is_32bit(vcpu))
>> +			vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + pmc->idx) = counter;
>> +		else
>> +			vcpu_cp15(vcpu, c14_PMEVCNTR0 + pmc->idx) = counter;
>> +
>> +		perf_event_release_kernel(pmc->perf_event);
>> +		pmc->perf_event = NULL;
>> +	}
>> +}
>> +
>> +/**
>> + * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
>> + * @vcpu: The vcpu pointer
>> + * @data: The data guest writes to PMXEVTYPER_EL0
>> + * @select_idx: The number of selected counter
>> + *
>> + * When OS accesses PMXEVTYPER_EL0, that means it wants to set a PMC to count an
>> + * event with given hardware event number. Here we call perf_event API to
>> + * emulate this action and create a kernel perf event for it.
>> + */
>> +void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
>> +				    u32 select_idx)
>> +{
>> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>> +	struct perf_event *event;
>> +	struct perf_event_attr attr;
>> +	u32 eventsel;
>> +	u64 counter;
>> +
>> +	kvm_pmu_stop_counter(pmc);
>> +	eventsel = data & ARMV8_EVTYPE_EVENT;
>> +
>> +	memset(&attr, 0, sizeof(struct perf_event_attr));
>> +	attr.type = PERF_TYPE_RAW;
>> +	attr.size = sizeof(attr);
>> +	attr.pinned = 1;
>> +	attr.disabled = 1;
> 
> Should this value be calculated from PMCR.E and PMCNTENSET/CLR state?
> 
Sure.

>> +	attr.exclude_user = data & ARMV8_EXCLUDE_EL0 ? 1 : 0;
>> +	attr.exclude_kernel = data & ARMV8_EXCLUDE_EL1 ? 1 : 0;
>> +	attr.exclude_hv = 1; /* Don't count EL2 events */
> 
> Should this be calculated from PMXEVTYPER.NSH?
> 
As discussed with Christoffer before, it's unlikely to support
nested-virtualiztion on ARMv8 and guest will not see EL2. So it doesn't
need to take care the value of PMXEVTYPER.NSH since it should not count
EL2 events.

>> +	attr.exclude_host = 1; /* Don't count host events */
>> +	attr.config = eventsel;
>> +
>> +	counter = kvm_pmu_get_counter_value(vcpu, select_idx);
>> +	/* The initial sample period (overflow count) of an event. */
>> +	attr.sample_period = (-counter) & pmc->bitmask;
>> +
>> +	event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);
>> +	if (IS_ERR(event)) {
>> +		printk_once("kvm: pmu event creation failed %ld\n",
>> +			    PTR_ERR(event));
>> +		return;
>> +	}
>> +
>> +	pmc->perf_event = event;
>> +}
>>
> 
> 

-- 
Shannon
