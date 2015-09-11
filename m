From: Shannon Zhao <shannon.zhao@linaro.org>
Subject: Re: [PATCH v2 08/22] KVM: ARM64: PMU: Add perf event map and introduce
 perf event creating function
Date: Fri, 11 Sep 2015 21:35:22 +0800
Message-ID: <55F2D89A.5060907@linaro.org>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com> <1441961715-11688-9-git-send-email-zhaoshenglong@huawei.com> <55F2B52F.8000300@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55F2B52F.8000300@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 2015/9/11 19:04, Marc Zyngier wrote:
> On 11/09/15 09:55, Shannon Zhao wrote:
>> From: Shannon Zhao <shannon.zhao@linaro.org>
>>
>> When we use tools like perf on host, perf passes the event type and the
>> id of this event type category to kernel, then kernel will map them to
>> hardware event number and write this number to PMU PMEVTYPER<n>_EL0
>> register. While we're trapping and emulating guest accesses to PMU
>> registers, we get the hardware event number and map it to the event type
>> and the id reversely. Then call perf_event kernel API to create an event
>> for it.
>>
>> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> ---
>>   arch/arm64/include/asm/pmu.h |   2 +
>>   arch/arm64/kvm/Makefile      |   1 +
>>   include/kvm/arm_pmu.h        |  15 +++
>>   virt/kvm/arm/pmu.c           | 240 +++++++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 258 insertions(+)
>>   create mode 100644 virt/kvm/arm/pmu.c
>>
>> diff --git a/arch/arm64/include/asm/pmu.h b/arch/arm64/include/asm/pmu.h
>> index 95681e6..42e7093 100644
>> --- a/arch/arm64/include/asm/pmu.h
>> +++ b/arch/arm64/include/asm/pmu.h
>> @@ -33,6 +33,8 @@
>>   #define ARMV8_PMCR_D		(1 << 3) /* CCNT counts every 64th cpu cycle */
>>   #define ARMV8_PMCR_X		(1 << 4) /* Export to ETM */
>>   #define ARMV8_PMCR_DP		(1 << 5) /* Disable CCNT if non-invasive debug*/
>> +/* Determines which PMCCNTR_EL0 bit generates an overflow */
>> +#define ARMV8_PMCR_LC		(1 << 6)
>>   #define	ARMV8_PMCR_N_SHIFT	11	 /* Number of counters supported */
>>   #define	ARMV8_PMCR_N_MASK	0x1f
>>   #define	ARMV8_PMCR_MASK		0x3f	 /* Mask for writable bits */
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index f90f4aa..78db4ee 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -27,3 +27,4 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3.o
>>   kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3-emul.o
>>   kvm-$(CONFIG_KVM_ARM_HOST) += vgic-v3-switch.o
>>   kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>> +kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>> index 64af88a..387ec6f 100644
>> --- a/include/kvm/arm_pmu.h
>> +++ b/include/kvm/arm_pmu.h
>> @@ -36,4 +36,19 @@ struct kvm_pmu {
>>   #endif
>>   };
>>
>> +#ifdef CONFIG_KVM_ARM_PMU
>> +unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
>> +					unsigned long select_idx);
>> +void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
>> +				    unsigned long select_idx);
>> +#else
>> +unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
>> +					unsigned long select_idx)
>> +{
>> +	return 0;
>> +}
>> +void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
>> +				    unsigned long select_idx) {}
>> +#endif
>> +
>>   #endif
>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>> new file mode 100644
>> index 0000000..0c7fe5c
>> --- /dev/null
>> +++ b/virt/kvm/arm/pmu.c
>> @@ -0,0 +1,240 @@
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
>> +/* PMU HW events mapping. */
>> +static struct kvm_pmu_hw_event_map {
>> +	unsigned eventsel;
>> +	unsigned event_type;
>> +} kvm_pmu_hw_events[] = {
>> +	[0] = { 0x11, PERF_COUNT_HW_CPU_CYCLES },
>> +	[1] = { 0x08, PERF_COUNT_HW_INSTRUCTIONS },
>> +	[2] = { 0x04, PERF_COUNT_HW_CACHE_REFERENCES },
>> +	[3] = { 0x03, PERF_COUNT_HW_CACHE_MISSES },
>> +	[4] = { 0x10, PERF_COUNT_HW_BRANCH_MISSES },
>
> How about using enum armv8_pmuv3_perf_types here?
>
>> +};
>> +
>> +/* PMU HW cache events mapping. */
>> +static struct kvm_pmu_hw_cache_event_map {
>> +	unsigned eventsel;
>> +	unsigned cache_type;
>> +	unsigned cache_op;
>> +	unsigned cache_result;
>> +} kvm_pmu_hw_cache_events[] = {
>> +	[0] = { 0x12, PERF_COUNT_HW_CACHE_BPU, PERF_COUNT_HW_CACHE_OP_READ,
>> +		      PERF_COUNT_HW_CACHE_RESULT_ACCESS },
>> +	[1] = { 0x12, PERF_COUNT_HW_CACHE_BPU, PERF_COUNT_HW_CACHE_OP_WRITE,
>> +		      PERF_COUNT_HW_CACHE_RESULT_ACCESS },
>> +};
>> +
>> +static void kvm_pmu_set_evttyper(struct kvm_vcpu *vcpu, unsigned long idx,
>> +				 unsigned long val)
>> +{
>> +	if (!vcpu_mode_is_32bit(vcpu))
>> +		vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + idx) = val;
>> +	else
>> +		vcpu_cp15(vcpu, c14_PMEVTYPER0 + idx) = val;
>> +}
>> +
>> +static unsigned long kvm_pmu_get_evttyper(struct kvm_vcpu *vcpu,
>> +					  unsigned long idx)
>> +{
>> +	if (!vcpu_mode_is_32bit(vcpu))
>> +		return vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + idx)
>> +		       & ARMV8_EVTYPE_EVENT;
>> +	else
>> +		return vcpu_cp15(vcpu, c14_PMEVTYPER0 + idx)
>> +		       & ARMV8_EVTYPE_EVENT;
>> +}
>> +
>> +/**
>> + * kvm_pmu_stop_counter - stop PMU counter for the selected counter
>> + * @vcpu: The vcpu pointer
>> + * @select_idx: The counter index
>> + *
>> + * If this counter has been configured to monitor some event, disable and
>> + * release it.
>> + */
>> +static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu,
>> +				 unsigned long select_idx)
>> +{
>> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>> +
>> +	if (pmc->perf_event) {
>> +		perf_event_disable(pmc->perf_event);
>> +		perf_event_release_kernel(pmc->perf_event);
>> +		pmc->perf_event = NULL;
>> +	}
>> +	kvm_pmu_set_evttyper(vcpu, select_idx, ARMV8_EVTYPE_EVENT);
>> +}
>> +
>> +/**
>> + * kvm_pmu_get_counter_value - get PMU counter value
>> + * @vcpu: The vcpu pointer
>> + * @select_idx: The counter index
>> + */
>> +unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
>> +					unsigned long select_idx)
>> +{
>> +	u64 enabled, running;
>> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>> +	unsigned long counter;
>> +
>> +	if (!vcpu_mode_is_32bit(vcpu))
>> +		counter = vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + select_idx);
>> +	else
>> +		counter = vcpu_cp15(vcpu, c14_PMEVCNTR0 + select_idx);
>> +
>> +	if (pmc->perf_event) {
>> +		counter += perf_event_read_value(pmc->perf_event,
>> +						&enabled, &running);
>> +	}
>> +	return counter;
>> +}
>> +
>> +/**
>> + * kvm_pmu_find_hw_event - find hardware event
>> + * @pmu: The pmu pointer
>> + * @event_select: The number of selected event type
>> + *
>> + * Based on the number of selected event type, find out whether it belongs to
>> + * PERF_TYPE_HARDWARE. If so, return the corresponding event id.
>> + */
>> +static unsigned kvm_pmu_find_hw_event(struct kvm_pmu *pmu,
>> +				      unsigned long event_select)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(kvm_pmu_hw_events); i++)
>> +		if (kvm_pmu_hw_events[i].eventsel == event_select)
>> +			return kvm_pmu_hw_events[i].event_type;
>> +
>> +	return PERF_COUNT_HW_MAX;
>> +}
>> +
>> +/**
>> + * kvm_pmu_find_hw_cache_event - find hardware cache event
>> + * @pmu: The pmu pointer
>> + * @event_select: The number of selected event type
>> + *
>> + * Based on the number of selected event type, find out whether it belongs to
>> + * PERF_TYPE_HW_CACHE. If so, return the corresponding event id.
>> + */
>> +static unsigned kvm_pmu_find_hw_cache_event(struct kvm_pmu *pmu,
>> +					    unsigned long event_select)
>> +{
>> +	int i;
>> +	unsigned config;
>
> Please use an explicitely sized type (u32, u64).
>
ok.

>> +
>> +	for (i = 0; i < ARRAY_SIZE(kvm_pmu_hw_cache_events); i++)
>> +		if (kvm_pmu_hw_cache_events[i].eventsel == event_select) {
>> +			config = (kvm_pmu_hw_cache_events[i].cache_type & 0xff)
>> +		     | ((kvm_pmu_hw_cache_events[i].cache_op & 0xff) << 8)
>> +		     | ((kvm_pmu_hw_cache_events[i].cache_result & 0xff) << 16);
>
> I don't understand what this does. You only update a local variable?
>
Oh, sorry, forgot "return config".

>> +		}
>> +
>> +	return PERF_COUNT_HW_CACHE_MAX;
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
>> +void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
>> +				    unsigned long select_idx)
>> +{
>> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>> +	struct perf_event *event;
>> +	struct perf_event_attr attr;
>> +	unsigned config, type = PERF_TYPE_RAW;
>> +	unsigned int new_eventsel, old_eventsel;
>> +	u64 counter;
>> +	int overflow_bit, pmcr_lc;
>> +
>> +	old_eventsel = kvm_pmu_get_evttyper(vcpu, select_idx);
>> +	new_eventsel = data & ARMV8_EVTYPE_EVENT;
>> +	if (new_eventsel == old_eventsel) {
>> +		if (pmc->perf_event)
>> +			local64_set(&pmc->perf_event->count, 0);
>> +		return;
>> +	}
>> +
>> +	kvm_pmu_stop_counter(vcpu, select_idx);
>> +	kvm_pmu_set_evttyper(vcpu, select_idx, data);
>> +
>> +	config = kvm_pmu_find_hw_event(pmu, new_eventsel);
>> +	if (config != PERF_COUNT_HW_MAX) {
>> +		type = PERF_TYPE_HARDWARE;
>> +	} else {
>> +		config = kvm_pmu_find_hw_cache_event(pmu, new_eventsel);
>> +		if (config != PERF_COUNT_HW_CACHE_MAX)
>> +			type = PERF_TYPE_HW_CACHE;
>> +	}
>> +
>> +	if (type == PERF_TYPE_RAW)
>> +		config = new_eventsel;
>> +
>> +	memset(&attr, 0, sizeof(struct perf_event_attr));
>> +	attr.type = type;
>> +	attr.size = sizeof(attr);
>> +	attr.pinned = 1;
>> +	attr.disabled = 1;
>> +	attr.exclude_user = data & ARMV8_EXCLUDE_EL0 ? 1 : 0;
>> +	attr.exclude_kernel = data & ARMV8_EXCLUDE_EL1 ? 1 : 0;
>> +	attr.exclude_host = 1; /* Don't count host events */
>> +	attr.config = config;
>> +
>> +	overflow_bit = 31; /* Generic counters are 32-bit registers*/
>> +	if (new_eventsel == 0x11) {
>> +		/* Cycle counter overflow on increment that changes PMCCNTR[63]
>> +		 * or PMCCNTR[31] from 1 to 0 according to the value of
>> +		 * ARMV8_PMCR_LC
>> +		 */
>> +		if (!vcpu_mode_is_32bit(vcpu))
>> +			pmcr_lc = vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMCR_LC;
>> +		else
>> +			pmcr_lc = vcpu_cp15(vcpu, c9_PMCR) & ARMV8_PMCR_LC;
>> +
>> +		overflow_bit = pmcr_lc ? 63 : 31;
>> +	}
>> +	counter = kvm_pmu_get_counter_value(vcpu, select_idx);
>> +	/* The initial sample period (overflow count) of an event. */
>> +	attr.sample_period = (-counter) & (((u64)1 << overflow_bit) - 1);
>> +
>> +	event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);
>> +	if (IS_ERR(event)) {
>> +		printk_once("kvm: pmu event creation failed %ld\n",
>> +			    PTR_ERR(event));
>> +		return;
>> +	}
>> +	pmc->perf_event = event;
>> +}
>>
>
> Having had a chat with Will, it appears that a much better solution
> would be to ask perf to use raw events instead of trying to map things
> to perf events (which the guest has already done).
>
> See drivers/oprofile/oprofile_perf.c::op_perf_setup().
>
> Thoughts?
>

Yeah, directly using PERF_TYPE_RAW event looks simpler. But should we 
check whether the value of event number written to PMXEVTYPER_EL0 is 
valid? Or That is guaranteed by guest?

-- 
Shannon
