From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v6 07/21] KVM: ARM64: PMU: Add perf event map and
 introduce perf event creating function
Date: Wed, 9 Dec 2015 08:23:18 +0000
Message-ID: <20151209082318.0de1d861@arm.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
	<1449578860-15808-8-git-send-email-zhaoshenglong@huawei.com>
	<5666FAB6.4070903@arm.com>
	<5667DA61.8080106@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5667DA61.8080106@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 9 Dec 2015 15:38:09 +0800
Shannon Zhao <zhaoshenglong@huawei.com> wrote:

> 
> 
> On 2015/12/8 23:43, Marc Zyngier wrote:
> > On 08/12/15 12:47, Shannon Zhao wrote:
> >> From: Shannon Zhao <shannon.zhao@linaro.org>
> >> +/**
> >> + * kvm_pmu_get_counter_value - get PMU counter value
> >> + * @vcpu: The vcpu pointer
> >> + * @select_idx: The counter index
> >> + */
> >> +u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
> >> +{
> >> +	u64 counter, enabled, running;
> >> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> >> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> >> +
> >> +	if (!vcpu_mode_is_32bit(vcpu))
> >> +		counter = vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + select_idx);
> >> +	else
> >> +		counter = vcpu_cp15(vcpu, c14_PMEVCNTR0 + select_idx);
> >> +
> >> +	if (pmc->perf_event)
> >> +		counter += perf_event_read_value(pmc->perf_event, &enabled,
> >> +						 &running);
> >> +
> >> +	return counter & pmc->bitmask;
> > 
> > This one confused me for a while. Is it the case that you return
> > whatever is in the vcpu view of the counter, plus anything that perf
> > itself has counted? If so, I'd appreciate a comment here...
> > 
> Yes, the real counter value is the current counter value plus the value
> perf event counts. I'll add a comment.
> 
> >> +}
> >> +
> >> +static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u32 select_idx)
> >> +{
> >> +	if (!vcpu_mode_is_32bit(vcpu))
> >> +		return (vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMCR_E) &
> >> +		       (vcpu_sys_reg(vcpu, PMCNTENSET_EL0) >> select_idx);
> > 
> > This looks wrong. Shouldn't it be:
> > 
> > return ((vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMCR_E) &&
> >         (vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & (1 << select_idx)));
> > 
> >> +	else
> >> +		return (vcpu_sys_reg(vcpu, c9_PMCR) & ARMV8_PMCR_E) &
> >> +		       (vcpu_sys_reg(vcpu, c9_PMCNTENSET) >> select_idx);
> >> +}
> > 
> > Also, I don't really see why we need to check the 32bit version, which
> > has the exact same content.
> > 
> >> +
> >> +static inline struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
> >> +{
> >> +	struct kvm_pmu *pmu;
> >> +	struct kvm_vcpu_arch *vcpu_arch;
> >> +
> >> +	pmc -= pmc->idx;
> >> +	pmu = container_of(pmc, struct kvm_pmu, pmc[0]);
> >> +	vcpu_arch = container_of(pmu, struct kvm_vcpu_arch, pmu);
> >> +	return container_of(vcpu_arch, struct kvm_vcpu, arch);
> >> +}
> >> +
> >> +/**
> >> + * kvm_pmu_stop_counter - stop PMU counter
> >> + * @pmc: The PMU counter pointer
> >> + *
> >> + * If this counter has been configured to monitor some event, release it here.
> >> + */
> >> +static void kvm_pmu_stop_counter(struct kvm_pmc *pmc)
> >> +{
> >> +	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
> >> +	u64 counter;
> >> +
> >> +	if (pmc->perf_event) {
> >> +		counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
> >> +		if (!vcpu_mode_is_32bit(vcpu))
> >> +			vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + pmc->idx) = counter;
> >> +		else
> >> +			vcpu_cp15(vcpu, c14_PMEVCNTR0 + pmc->idx) = counter;
> > 
> > Same thing - we don't need to make a difference between 32 and 64bit.
> > 
> So it's fine to drop all the vcpu_mode_is_32bit(vcpu) check of this
> series? The only one we should take care is the PMCCNTR, right?

Yes, mostly. As long as you only reason on the 64bit register set,
you're pretty safe, and that in turn solves all kind of ugly endianness
issues.

> >> +
> >> +		perf_event_release_kernel(pmc->perf_event);
> >> +		pmc->perf_event = NULL;
> >> +	}
> >> +}
> >> +
> >> +/**
> >> + * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
> >> + * @vcpu: The vcpu pointer
> >> + * @data: The data guest writes to PMXEVTYPER_EL0
> >> + * @select_idx: The number of selected counter
> >> + *
> >> + * When OS accesses PMXEVTYPER_EL0, that means it wants to set a PMC to count an
> >> + * event with given hardware event number. Here we call perf_event API to
> >> + * emulate this action and create a kernel perf event for it.
> >> + */
> >> +void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
> >> +				    u32 select_idx)
> >> +{
> >> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> >> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> >> +	struct perf_event *event;
> >> +	struct perf_event_attr attr;
> >> +	u32 eventsel;
> >> +	u64 counter;
> >> +
> >> +	kvm_pmu_stop_counter(pmc);
> > 
> > Wait. I didn't realize this before, but you have the vcpu right here.
> > Why don't you pass it as a parameter to kvm_pmu_stop_counter and avoid
> > the kvm_pmc_to_vcpu thing altogether?
> > 
> Yeah, we could pass vcpu as a parameter for this function. But the
> kvm_pmc_to_vcpu helper is also used in kvm_pmu_perf_overflow() and
> within kvm_pmu_perf_overflow it needs the pmc->idx, we couldn't pass
> vcpu as a parameter, so this helper is necessary for kvm_pmu_perf_overflow.

OK. Then keep the helper with kvm_pmu_perf_overflow, and pass the the
vcpu as a parameter to the leaf functions.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
