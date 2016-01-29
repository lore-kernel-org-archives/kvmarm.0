From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v10 08/21] KVM: ARM64: Add access handler for event type
 register
Date: Fri, 29 Jan 2016 12:25:32 +0100
Message-ID: <20160129112532.GB4340@hawk.localdomain>
References: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
 <1453866709-20324-9-git-send-email-zhaoshenglong@huawei.com>
 <20160128201159.GH16453@hawk.localdomain>
 <56AAC368.8020605@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56AAC368.8020605@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 29, 2016 at 09:42:00AM +0800, Shannon Zhao wrote:
> 
> 
> On 2016/1/29 4:11, Andrew Jones wrote:
> > On Wed, Jan 27, 2016 at 11:51:36AM +0800, Shannon Zhao wrote:
> >> > From: Shannon Zhao <shannon.zhao@linaro.org>
> >> > 
> >> > These kind of registers include PMEVTYPERn, PMCCFILTR and PMXEVTYPER
> >> > which is mapped to PMEVTYPERn or PMCCFILTR.
> >> > 
> >> > The access handler translates all aarch32 register offsets to aarch64
> >> > ones and uses vcpu_sys_reg() to access their values to avoid taking care
> >> > of big endian.
> >> > 
> >> > When writing to these registers, create a perf_event for the selected
> >> > event type.
> >> > 
> >> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> >> > ---
> >> >  arch/arm64/kvm/sys_regs.c | 140 +++++++++++++++++++++++++++++++++++++++++++++-
> >> >  1 file changed, 138 insertions(+), 2 deletions(-)
> >> > 
> >> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> >> > index 06257e2..298ae94 100644
> >> > --- a/arch/arm64/kvm/sys_regs.c
> >> > +++ b/arch/arm64/kvm/sys_regs.c
> >> > @@ -513,6 +513,54 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >> >  	return true;
> >> >  }
> >> >  
> >> > +static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
> >> > +{
> >> > +	u64 pmcr, val;
> >> > +
> >> > +	pmcr = vcpu_sys_reg(vcpu, PMCR_EL0);
> >> > +	val = (pmcr >> ARMV8_PMCR_N_SHIFT) & ARMV8_PMCR_N_MASK;
> >> > +	if (idx >= val && idx != ARMV8_CYCLE_IDX)
> >> > +		return false;
> >> > +
> >> > +	return true;
> >> > +}
> >> > +
> >> > +static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >> > +			       const struct sys_reg_desc *r)
> >> > +{
> >> > +	u64 idx, reg;
> >> > +
> >> > +	if (!kvm_arm_pmu_v3_ready(vcpu))
> >> > +		return trap_raz_wi(vcpu, p, r);
> >> > +
> >> > +	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 1) {
> >> > +		/* PMXEVTYPER_EL0 */
> >> > +		idx = vcpu_sys_reg(vcpu, PMSELR_EL0) & ARMV8_COUNTER_MASK;
> >> > +		reg = PMEVTYPER0_EL0 + idx;
> >> > +	} else if (r->CRn == 14 && (r->CRm & 12) == 12) {
> >> > +		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
> >> > +		if (idx == ARMV8_CYCLE_IDX)
> >> > +			reg = PMCCFILTR_EL0;
> >> > +		else
> >> > +			/* PMEVTYPERn_EL0 */
> >> > +			reg = PMEVTYPER0_EL0 + idx;
> >> > +	} else {
> >> > +		BUG();
> >> > +	}
> >> > +
> >> > +	if (!pmu_counter_idx_valid(vcpu, idx))
> >> > +		return false;
> >> > +
> >> > +	if (p->is_write) {
> >> > +		kvm_pmu_set_counter_event_type(vcpu, p->regval, idx);
> >> > +		vcpu_sys_reg(vcpu, reg) = p->regval & ARMV8_EVTYPE_MASK;
> >> > +	} else {
> >> > +		p->regval = vcpu_sys_reg(vcpu, reg) & ARMV8_EVTYPE_MASK;
> > Related to my comment in 5/21. Why should we need to mask it here when
> > reading it, since it was masked on writing?
> > 
> But what if guest reads this register before writing to it?

Oh, I see. The need comes from the use of the reset_unknown reset function.
It might be nice to have a reset_unknown_mask function that uses r->val
as the mask, as there are many registers that have RES0/1 and/or RO fields.

Thanks,
drew
