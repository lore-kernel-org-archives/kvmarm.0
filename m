From: Wei Huang <wei@redhat.com>
Subject: Re: [PATCH v3 07/20] KVM: ARM64: PMU: Add perf event map and
 introduce perf event creating function
Date: Fri, 16 Oct 2015 01:08:39 -0500
Message-ID: <56209467.3010800@redhat.com>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
 <1443133885-3366-8-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1443133885-3366-8-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 09/24/2015 05:31 PM, Shannon Zhao wrote:
> When we use tools like perf on host, perf passes the event type and the
> id of this event type category to kernel, then kernel will map them to
> hardware event number and write this number to PMU PMEVTYPER<n>_EL0
> register. When getting the event number in KVM, directly use raw event
> type to create a perf_event for it.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/include/asm/pmu.h |   2 +
>  arch/arm64/kvm/Makefile      |   1 +
>  include/kvm/arm_pmu.h        |  13 ++++
>  virt/kvm/arm/pmu.c           | 154 +++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 170 insertions(+)
>  create mode 100644 virt/kvm/arm/pmu.c
> 
> diff --git a/arch/arm64/include/asm/pmu.h b/arch/arm64/include/asm/pmu.h
> index b9f394a..2c025f2 100644
> --- a/arch/arm64/include/asm/pmu.h
> +++ b/arch/arm64/include/asm/pmu.h
> @@ -31,6 +31,8 @@
>  #define ARMV8_PMCR_D		(1 << 3) /* CCNT counts every 64th cpu cycle */
>  #define ARMV8_PMCR_X		(1 << 4) /* Export to ETM */
>  #define ARMV8_PMCR_DP		(1 << 5) /* Disable CCNT if non-invasive debug*/
> +/* Determines which PMCCNTR_EL0 bit generates an overflow */
> +#define ARMV8_PMCR_LC		(1 << 6)
>  #define	ARMV8_PMCR_N_SHIFT	11	 /* Number of counters supported */
>  #define	ARMV8_PMCR_N_MASK	0x1f
>  #define	ARMV8_PMCR_MASK		0x3f	 /* Mask for writable bits */
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 1949fe5..18d56d8 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -27,3 +27,4 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3-emul.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += vgic-v3-switch.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
> +kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index bb0cd21..b48cdc6 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -37,4 +37,17 @@ struct kvm_pmu {
>  #endif
>  };
>  
> +#ifdef CONFIG_KVM_ARM_PMU
> +unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx);
> +void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
> +				    u32 select_idx);
> +#else
> +unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
> +{
> +	return 0;
> +}
> +void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
> +				    u32 select_idx) {}
> +#endif
> +
>  #endif
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> new file mode 100644
> index 0000000..002ec79
> --- /dev/null
> +++ b/virt/kvm/arm/pmu.c
> @@ -0,0 +1,154 @@
> +/*
> + * Copyright (C) 2015 Linaro Ltd.
> + * Author: Shannon Zhao <shannon.zhao@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/cpu.h>
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +#include <linux/perf_event.h>
> +#include <asm/kvm_emulate.h>
> +#include <kvm/arm_pmu.h>
> +
> +static void kvm_pmu_set_evttyper(struct kvm_vcpu *vcpu, u32 idx, u32 val)
> +{
> +	if (!vcpu_mode_is_32bit(vcpu))
> +		vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + idx) = val;
> +	else
> +		vcpu_cp15(vcpu, c14_PMEVTYPER0 + idx) = val;
> +}
> +
> +static unsigned long kvm_pmu_get_evttyper(struct kvm_vcpu *vcpu, u32 idx)
> +{
> +	if (!vcpu_mode_is_32bit(vcpu))
> +		return vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + idx)
> +		       & ARMV8_EVTYPE_EVENT;
> +	else
> +		return vcpu_cp15(vcpu, c14_PMEVTYPER0 + idx)
> +		       & ARMV8_EVTYPE_EVENT;
> +}
> +
> +/**
> + * kvm_pmu_stop_counter - stop PMU counter for the selected counter
> + * @vcpu: The vcpu pointer
> + * @select_idx: The counter index
> + *
> + * If this counter has been configured to monitor some event, disable and
> + * release it.
> + */
> +static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, u32 select_idx)
> +{
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];

A small suggestion (optional). It might be cleaner to define a macro and
use it here. Something like in arm_pmu.h :

#define VCPU_TO_PMU(vcpu)  (&(vcpu)->arch.pmu)

> +
> +	if (pmc->perf_event) {
> +		perf_event_disable(pmc->perf_event);
> +		perf_event_release_kernel(pmc->perf_event);
> +		pmc->perf_event = NULL;
> +	}
> +	kvm_pmu_set_evttyper(vcpu, select_idx, ARMV8_EVTYPE_EVENT);
> +}
> +
> +/**
> + * kvm_pmu_get_counter_value - get PMU counter value
> + * @vcpu: The vcpu pointer
> + * @select_idx: The counter index
> + */
> +unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
> +{
> +	u64 enabled, running;
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> +	u64 counter;
> +
> +	if (!vcpu_mode_is_32bit(vcpu))
> +		counter = vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + select_idx);

The select_idx is from PMSELR_EL0. According to PMUv3 spec, PMSELR_EL0
is the register that "selects the current event counter PMEVCNTR<x> or
the cycle counter, CCNT". The code here always reads the counter value
from PMEVCNTR. It doesn't read the value from cycle counter when
select_idx=0b11111. We might waste some perf counter resources here.

> +	else
> +		counter = vcpu_cp15(vcpu, c14_PMEVCNTR0 + select_idx);
> +
> +	if (pmc->perf_event) {
> +		counter += perf_event_read_value(pmc->perf_event,
> +						&enabled, &running);
> +	}
> +	return counter;
> +}
> +
> +/**
> + * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
> + * @vcpu: The vcpu pointer
> + * @data: The data guest writes to PMXEVTYPER_EL0
> + * @select_idx: The number of selected counter
> + *
> + * When OS accesses PMXEVTYPER_EL0, that means it wants to set a PMC to count an
> + * event with given hardware event number. Here we call perf_event API to
> + * emulate this action and create a kernel perf event for it.
> + */
> +void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
> +				    u32 select_idx)
> +{
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> +	struct perf_event *event;
> +	struct perf_event_attr attr;
> +	u32 new_eventsel, old_eventsel;
> +	u64 counter;
> +	int overflow_bit, pmcr_lc;
> +
> +	old_eventsel = kvm_pmu_get_evttyper(vcpu, select_idx);
> +	new_eventsel = data & ARMV8_EVTYPE_EVENT;
> +	if (new_eventsel == old_eventsel) {
> +		if (pmc->perf_event)
> +			local64_set(&pmc->perf_event->count, 0);
> +		return;
> +	}
> +
> +	kvm_pmu_stop_counter(vcpu, select_idx);
> +	kvm_pmu_set_evttyper(vcpu, select_idx, data);
> +
> +	memset(&attr, 0, sizeof(struct perf_event_attr));
> +	attr.type = PERF_TYPE_RAW;
> +	attr.size = sizeof(attr);
> +	attr.pinned = 1;
> +	attr.disabled = 1;
> +	attr.exclude_user = data & ARMV8_EXCLUDE_EL0 ? 1 : 0;
> +	attr.exclude_kernel = data & ARMV8_EXCLUDE_EL1 ? 1 : 0;
> +	attr.exclude_host = 1; /* Don't count host events */
> +	attr.config = new_eventsel;
> +
> +	overflow_bit = 31; /* Generic counters are 32-bit registers*/
> +	if (new_eventsel == 0x11) {
> +		/* Cycle counter overflow on increment that changes PMCCNTR[63]
> +		 * or PMCCNTR[31] from 1 to 0 according to the value of
> +		 * ARMV8_PMCR_LC
> +		 */
> +		if (!vcpu_mode_is_32bit(vcpu))
> +			pmcr_lc = vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMCR_LC;
> +		else
> +			pmcr_lc = vcpu_cp15(vcpu, c9_PMCR) & ARMV8_PMCR_LC;
> +
> +		overflow_bit = pmcr_lc ? 63 : 31;
> +	}
> +	counter = kvm_pmu_get_counter_value(vcpu, select_idx);
> +	/* The initial sample period (overflow count) of an event. */
> +	attr.sample_period = (-counter) & (((u64)1 << overflow_bit) - 1);
> +
> +	event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);
> +	if (IS_ERR(event)) {
> +		printk_once("kvm: pmu event creation failed %ld\n",
> +			    PTR_ERR(event));
> +		return;
> +	}
> +	pmc->perf_event = event;
> +}
> 
