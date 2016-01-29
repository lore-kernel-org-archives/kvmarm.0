From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v10 15/21] KVM: ARM64: Add access handler for PMUSERENR
 register
Date: Fri, 29 Jan 2016 12:08:40 +0100
Message-ID: <20160129110840.GA4340@hawk.localdomain>
References: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
 <1453866709-20324-16-git-send-email-zhaoshenglong@huawei.com>
 <20160128195814.GF16453@hawk.localdomain>
 <56AB16B6.8060208@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56AB16B6.8060208@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jan 29, 2016 at 03:37:26PM +0800, Shannon Zhao wrote:
> 
> 
> On 2016/1/29 3:58, Andrew Jones wrote:
> > On Wed, Jan 27, 2016 at 11:51:43AM +0800, Shannon Zhao wrote:
> >> > From: Shannon Zhao <shannon.zhao@linaro.org>
> >> > 
> >> > This register resets as unknown in 64bit mode while it resets as zero
> >> > in 32bit mode. Here we choose to reset it as zero for consistency.
> >> > 
> >> > PMUSERENR_EL0 holds some bits which decide whether PMU registers can be
> >> > accessed from EL0. Add some check helpers to handle the access from EL0.
> >> > 
> >> > When these bits are zero, only reading PMUSERENR will trap to EL2 and
> >> > writing PMUSERENR or reading/writing other PMU registers will trap to
> >> > EL1 other than EL2 when HCR.TGE==0. To current KVM configuration
> >> > (HCR.TGE==0) there is no way to get these traps. Here we write 0xf to
> >> > physical PMUSERENR register on VM entry, so that it will trap PMU access
> >> > from EL0 to EL2. Within the register access handler we check the real
> >> > value of guest PMUSERENR register to decide whether this access is
> >> > allowed. If not allowed, return false to inject UND to guest.
> >> > 
> >> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> >> > ---
> >> >  arch/arm64/include/asm/pmu.h |   9 ++++
> >> >  arch/arm64/kvm/hyp/hyp.h     |   1 +
> >> >  arch/arm64/kvm/hyp/switch.c  |   3 ++
> >> >  arch/arm64/kvm/sys_regs.c    | 100 ++++++++++++++++++++++++++++++++++++++++---
> >> >  4 files changed, 107 insertions(+), 6 deletions(-)
> >> > 
> >> > diff --git a/arch/arm64/include/asm/pmu.h b/arch/arm64/include/asm/pmu.h
> >> > index 6f14a01..eb3dc88 100644
> >> > --- a/arch/arm64/include/asm/pmu.h
> >> > +++ b/arch/arm64/include/asm/pmu.h
> >> > @@ -69,4 +69,13 @@
> >> >  #define	ARMV8_EXCLUDE_EL0	(1 << 30)
> >> >  #define	ARMV8_INCLUDE_EL2	(1 << 27)
> >> >  
> >> > +/*
> >> > + * PMUSERENR: user enable reg
> >> > + */
> >> > +#define ARMV8_USERENR_MASK	0xf		/* Mask for writable bits */
> >> > +#define ARMV8_USERENR_EN	(1 << 0) /* PMU regs can be accessed at EL0 */
> >> > +#define ARMV8_USERENR_SW	(1 << 1) /* PMSWINC can be written at EL0 */
> >> > +#define ARMV8_USERENR_CR	(1 << 2) /* Cycle counter can be read at EL0 */
> >> > +#define ARMV8_USERENR_ER	(1 << 3) /* Event counter can be read at EL0 */
> >> > +
> >> >  #endif /* __ASM_PMU_H */
> >> > diff --git a/arch/arm64/kvm/hyp/hyp.h b/arch/arm64/kvm/hyp/hyp.h
> >> > index fb27517..9a28b7bd8 100644
> >> > --- a/arch/arm64/kvm/hyp/hyp.h
> >> > +++ b/arch/arm64/kvm/hyp/hyp.h
> >> > @@ -22,6 +22,7 @@
> >> >  #include <linux/kvm_host.h>
> >> >  #include <asm/kvm_mmu.h>
> >> >  #include <asm/sysreg.h>
> >> > +#include <asm/pmu.h>
> >> >  
> >> >  #define __hyp_text __section(.hyp.text) notrace
> >> >  
> >> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> >> > index ca8f5a5..1a7d679 100644
> >> > --- a/arch/arm64/kvm/hyp/switch.c
> >> > +++ b/arch/arm64/kvm/hyp/switch.c
> >> > @@ -37,6 +37,8 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
> >> >  	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
> >> >  	write_sysreg(1 << 15, hstr_el2);
> >> >  	write_sysreg(CPTR_EL2_TTA | CPTR_EL2_TFP, cptr_el2);
> >> > +	/* Make sure we trap PMU access from EL0 to EL2 */
> >> > +	write_sysreg(ARMV8_USERENR_MASK, pmuserenr_el0);
> >> >  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
> >> >  }
> >> >  
> >> > @@ -45,6 +47,7 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
> >> >  	write_sysreg(HCR_RW, hcr_el2);
> >> >  	write_sysreg(0, hstr_el2);
> >> >  	write_sysreg(read_sysreg(mdcr_el2) & MDCR_EL2_HPMN_MASK, mdcr_el2);
> >> > +	write_sysreg(0, pmuserenr_el0);
> >> >  	write_sysreg(0, cptr_el2);
> >> >  }
> >> >  
> >> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> >> > index eefc60a..084e527 100644
> >> > --- a/arch/arm64/kvm/sys_regs.c
> >> > +++ b/arch/arm64/kvm/sys_regs.c
> >> > @@ -453,6 +453,37 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> >> >  	vcpu_sys_reg(vcpu, PMCR_EL0) = val;
> >> >  }
> >> >  
> >> > +static bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)
> >> > +{
> >> > +	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
> >> > +
> >> > +	return !((reg & ARMV8_USERENR_EN) || vcpu_mode_priv(vcpu));
> >> > +}
> >> > +
> >> > +static bool pmu_write_swinc_el0_disabled(struct kvm_vcpu *vcpu)
> >> > +{
> >> > +	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
> >> > +
> >> > +	return !((reg & (ARMV8_USERENR_SW | ARMV8_USERENR_EN))
> >> > +		 || vcpu_mode_priv(vcpu));
> >> > +}
> >> > +
> >> > +static bool pmu_access_cycle_counter_el0_disabled(struct kvm_vcpu *vcpu)
> >> > +{
> >> > +	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
> >> > +
> >> > +	return !((reg & (ARMV8_USERENR_CR | ARMV8_USERENR_EN))
> >> > +		 || vcpu_mode_priv(vcpu));
> >> > +}
> >> > +
> >> > +static bool pmu_access_event_counter_el0_disabled(struct kvm_vcpu *vcpu)
> >> > +{
> >> > +	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
> >> > +
> >> > +	return !((reg & (ARMV8_USERENR_ER | ARMV8_USERENR_EN))
> >> > +		 || vcpu_mode_priv(vcpu));
> >> > +}
> >> > +
> >> >  static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >> >  			const struct sys_reg_desc *r)
> >> >  {
> >> > @@ -461,6 +492,9 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >> >  	if (!kvm_arm_pmu_v3_ready(vcpu))
> >> >  		return trap_raz_wi(vcpu, p, r);
> >> >  
> >> > +	if (pmu_access_el0_disabled(vcpu))
> >> > +		return false;
> > Based on the function name I'm not sure I like embedding vcpu_mode_priv.
> > It seems a condition like
> > 
> >   if (!vcpu_mode_priv(vcpu) && !pmu_access_el0_enabled(vcpu))
> >       return false;
> > 
> 
> I don't think so. The return vlaue of pmu_access_el0_enabled doesn't
> make sense if it doesn't check vcpu mode and it doesn't reflect the
> meaning of the function name because if pmu_access_el0_enabled returns
> false which should mean the EL0 access is disabled but actually the vcpu
> mode might not be EL0.

I think it always makes sense to simply check if some bit or bits are
set in some register, without having the answer mixed up with other
state. Actually, maybe we should just drop these helpers and check the
register for the appropriate bits directly whenever needed,

  pmuserenr_el0 = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
  restricted = !vcpu_mode_priv(vcpu) && !(pmuserenr_el0 & ARMV8_USERENR_EN);
  ...

  if (restricted && !(pmuserenr_el0 & ARMV8_USERENR_CR))
     return false;


Or whatever... I won't complain about this anymore.

> 
> > would be more clear here and the other callsites below. (I also prefer
> > checking for enabled vs. disabled)
> > 
> >> > +
> >> >  	if (p->is_write) {
> >> >  		/* Only update writeable bits of PMCR */
> >> >  		val = vcpu_sys_reg(vcpu, PMCR_EL0);
> >> > @@ -484,6 +518,9 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >> >  	if (!kvm_arm_pmu_v3_ready(vcpu))
> >> >  		return trap_raz_wi(vcpu, p, r);
> >> >  
> >> > +	if (pmu_access_event_counter_el0_disabled(vcpu))
> >> > +		return false;
> >> > +
> >> >  	if (p->is_write)
> >> >  		vcpu_sys_reg(vcpu, PMSELR_EL0) = p->regval;
> >> >  	else
> >> > @@ -501,7 +538,7 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >> >  	if (!kvm_arm_pmu_v3_ready(vcpu))
> >> >  		return trap_raz_wi(vcpu, p, r);
> >> >  
> >> > -	if (p->is_write)
> >> > +	if (p->is_write || pmu_access_el0_disabled(vcpu))
> >> >  		return false;
> >> >  
> >> >  	if (!(p->Op2 & 1))
> >> > @@ -534,6 +571,9 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >> >  	if (!kvm_arm_pmu_v3_ready(vcpu))
> >> >  		return trap_raz_wi(vcpu, p, r);
> >> >  
> >> > +	if (pmu_access_el0_disabled(vcpu))
> >> > +		return false;
> >> > +
> >> >  	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 1) {
> >> >  		/* PMXEVTYPER_EL0 */
> >> >  		idx = vcpu_sys_reg(vcpu, PMSELR_EL0) & ARMV8_COUNTER_MASK;
> >> > @@ -574,11 +614,17 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
> >> >  	if (r->CRn == 9 && r->CRm == 13) {
> >> >  		if (r->Op2 == 2) {
> >> >  			/* PMXEVCNTR_EL0 */
> >> > +			if (pmu_access_event_counter_el0_disabled(vcpu))
> >> > +				return false;
> >> > +
> >> >  			idx = vcpu_sys_reg(vcpu, PMSELR_EL0)
> >> >  			      & ARMV8_COUNTER_MASK;
> >> >  			reg = PMEVCNTR0_EL0 + idx;
> >> >  		} else if (r->Op2 == 0) {
> >> >  			/* PMCCNTR_EL0 */
> >> > +			if (pmu_access_cycle_counter_el0_disabled(vcpu))
> >> > +				return false;
> >> > +
> >> >  			idx = ARMV8_CYCLE_IDX;
> >> >  			reg = PMCCNTR_EL0;
> >> >  		} else {
> >> > @@ -586,6 +632,9 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
> >> >  		}
> >> >  	} else if (r->CRn == 14 && (r->CRm & 12) == 8) {
> >> >  		/* PMEVCNTRn_EL0 */
> >> > +		if (pmu_access_event_counter_el0_disabled(vcpu))
> >> > +			return false;
> >> > +
> >> >  		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
> >> >  		reg = PMEVCNTR0_EL0 + idx;
> >> >  	} else {
> >> > @@ -596,10 +645,14 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
> >> >  		return false;
> >> >  
> >> >  	val = kvm_pmu_get_counter_value(vcpu, idx);
> >> > -	if (p->is_write)
> >> > +	if (p->is_write) {
> >> > +		if (pmu_access_el0_disabled(vcpu))
> >> > +			return false;
> >> > +
> > This check isn't necessary because at this point we've either already
> > checked ARMV8_USERENR_EN with one of the other tests, or we've BUGed.
> > 
> No. For example to cycle counter, if the CR bit is 1 but EN is zero,
> pmu_access_cycle_counter_el0_disabled will return false and this means
> EL0 could read this cycle counter but it can't write this register
> because the CR bit only affects the read access.
> 
> "1 EL0 using AArch64: EL0 read accesses to the PMCCNTR_EL0 are not
> trapped to EL1."
> 
> So within the write access branch, it needs to check if the EN bit is 1.

Oh yeah. Thanks for the clarification.

> 
> >> >  		vcpu_sys_reg(vcpu, reg) += (s64)p->regval - val;
> >> > -	else
> >> > +	} else {
> >> >  		p->regval = val;
> >> > +	}
> > It's nasty to have to add 3 checks to access_pmu_evcntr. Can we instead
> > just have another helper that takes a reg_idx argument, i.e.
> > 
> > static bool pmu_reg_access_el0_disabled(struct kvm_vcpu *vcpu, u64 idx)
> > {
> >   if (idx == PMCCNTR_EL0)
> >      return pmu_access_cycle_counter_el0_disabled
> >   if (idx >= PMEVCNTR0_EL0 && idx <= PMEVCNTR30_EL0)
> >      return pmu_access_event_counter_el0_disabled
> > ...
> > 
> > and call it once after the pmu_counter_idx_valid check?
> > 
> No, I don't think this is nasty because through above if (r->CRn == 9 &&
> r->CRm == 13) else, we already know the type of the counter, i.e. cycle
> or event counter, and we could call different checker directly other
> than re-distinguishing the type.
> 
> What I considered here before is trying to shorten the code path to make
> it effective. So I dropped early switch...case implementation. Therefore
> we could have a small gap of perf event value between guest and host.
> 
> Thanks,
> -- 
> Shannon
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
