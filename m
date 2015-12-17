From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v7 07/19] KVM: ARM64: PMU: Add perf event map and
 introduce perf event creating function
Date: Thu, 17 Dec 2015 15:22:27 +0000
Message-ID: <20151217152054.GB11796@leverpostej>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
 <1450169379-12336-8-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1450169379-12336-8-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 15, 2015 at 04:49:27PM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> When we use tools like perf on host, perf passes the event type and the
> id of this event type category to kernel, then kernel will map them to
> hardware event number and write this number to PMU PMEVTYPER<n>_EL0
> register. When getting the event number in KVM, directly use raw event
> type to create a perf_event for it.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/include/asm/pmu.h |   3 ++
>  arch/arm64/kvm/Makefile      |   1 +
>  include/kvm/arm_pmu.h        |  11 ++++
>  virt/kvm/arm/pmu.c           | 122 +++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 137 insertions(+)
>  create mode 100644 virt/kvm/arm/pmu.c

[...]

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
> +void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
> +				    u64 select_idx)
> +{
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> +	struct perf_event *event;
> +	struct perf_event_attr attr;
> +	u64 eventsel, counter;
> +
> +	kvm_pmu_stop_counter(vcpu, pmc);
> +	eventsel = data & ARMV8_EVTYPE_EVENT;
> +
> +	memset(&attr, 0, sizeof(struct perf_event_attr));
> +	attr.type = PERF_TYPE_RAW;
> +	attr.size = sizeof(attr);
> +	attr.pinned = 1;
> +	attr.disabled = kvm_pmu_counter_is_enabled(vcpu, select_idx);
> +	attr.exclude_user = data & ARMV8_EXCLUDE_EL0 ? 1 : 0;
> +	attr.exclude_kernel = data & ARMV8_EXCLUDE_EL1 ? 1 : 0;
> +	attr.exclude_hv = 1; /* Don't count EL2 events */
> +	attr.exclude_host = 1; /* Don't count host events */
> +	attr.config = eventsel;
> +
> +	counter = kvm_pmu_get_counter_value(vcpu, select_idx);
> +	/* The initial sample period (overflow count) of an event. */
> +	attr.sample_period = (-counter) & pmc->bitmask;
> +
> +	event = perf_event_create_kernel_counter(&attr, -1, current, NULL, pmc);

As far as I can see, this is going to result in unreliable counts on a
big.LITTLE system, even if the VCPUs are constrained to one class of
core.

As this is a task-bound event (cpu == -1, task is current), the perf
core will stop as soon as one PMU driver agrees to handle the event. The
event will then only count on CPUs handled by that driver.

If you're unlucky, the set of CPUs handled by that driver is not the
same as the set of CPUs your VM is constrained to. e.g. your VM might be
on little cores, but the big PMU driver accepted the event, and only
counts on big cores.

I'm not sure how we can solve that.

Thanks,
Mark.

> +	if (IS_ERR(event)) {
> +		printk_once("kvm: pmu event creation failed %ld\n",
> +			    PTR_ERR(event));
> +		return;
> +	}
> +
> +	pmc->perf_event = event;
> +}
> -- 
> 2.0.4
> 
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
