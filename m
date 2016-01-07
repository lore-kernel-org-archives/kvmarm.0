From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v8 16/20] KVM: ARM64: Add access handler for PMUSERENR
 register
Date: Thu, 7 Jan 2016 19:15:05 +0800
Message-ID: <568E48B9.8040006@huawei.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com> <1450771695-11948-17-git-send-email-zhaoshenglong@huawei.com> <568E3A6C.2010404@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <568E3A6C.2010404@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/1/7 18:14, Marc Zyngier wrote:
> On 22/12/15 08:08, Shannon Zhao wrote:
>> > From: Shannon Zhao <shannon.zhao@linaro.org>
>> > 
>> > This register resets as unknown in 64bit mode while it resets as zero
>> > in 32bit mode. Here we choose to reset it as zero for consistency.
>> > 
>> > PMUSERENR_EL0 holds some bits which decide whether PMU registers can be
>> > accessed from EL0. Add some check helpers to handle the access from EL0.
>> > 
>> > When these bits are zero, only reading PMUSERENR will trap to EL2 and
>> > writing PMUSERENR or reading/writing other PMU registers will trap to
>> > EL1 other than EL2 when HCR.TGE==0. To current KVM configuration
>> > (HCR.TGE==0) there is no way to get these traps. Here we write 0xf to
>> > physical PMUSERENR register on VM entry, so that it will trap PMU access
>> > from EL0 to EL2. Within the register access handler we check the real
>> > value of guest PMUSERENR register to decide whether this access is
>> > allowed. If not allowed, forward this trap to EL1.
>> > 
>> > Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
>> > ---
>> >  arch/arm64/include/asm/pmu.h |   9 ++++
>> >  arch/arm64/kvm/hyp/switch.c  |   3 ++
>> >  arch/arm64/kvm/sys_regs.c    | 122 +++++++++++++++++++++++++++++++++++++++++--
>> >  3 files changed, 129 insertions(+), 5 deletions(-)
>> > 
>> > diff --git a/arch/arm64/include/asm/pmu.h b/arch/arm64/include/asm/pmu.h
>> > index 2588f9c..1238ade 100644
>> > --- a/arch/arm64/include/asm/pmu.h
>> > +++ b/arch/arm64/include/asm/pmu.h
>> > @@ -67,4 +67,13 @@
>> >  #define	ARMV8_EXCLUDE_EL0	(1 << 30)
>> >  #define	ARMV8_INCLUDE_EL2	(1 << 27)
>> >  
>> > +/*
>> > + * PMUSERENR: user enable reg
>> > + */
>> > +#define ARMV8_USERENR_MASK	0xf		/* Mask for writable bits */
>> > +#define ARMV8_USERENR_EN	(1 << 0) /* PMU regs can be accessed at EL0 */
>> > +#define ARMV8_USERENR_SW	(1 << 1) /* PMSWINC can be written at EL0 */
>> > +#define ARMV8_USERENR_CR	(1 << 2) /* Cycle counter can be read at EL0 */
>> > +#define ARMV8_USERENR_ER	(1 << 3) /* Event counter can be read at EL0 */
>> > +
>> >  #endif /* __ASM_PMU_H */
>> > diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>> > index ca8f5a5..a85375f 100644
>> > --- a/arch/arm64/kvm/hyp/switch.c
>> > +++ b/arch/arm64/kvm/hyp/switch.c
>> > @@ -37,6 +37,8 @@ static void __hyp_text __activate_traps(struct kvm_vcpu *vcpu)
>> >  	/* Trap on AArch32 cp15 c15 accesses (EL1 or EL0) */
>> >  	write_sysreg(1 << 15, hstr_el2);
>> >  	write_sysreg(CPTR_EL2_TTA | CPTR_EL2_TFP, cptr_el2);
>> > +	/* Make sure we trap PMU access from EL0 to EL2 */
>> > +	write_sysreg(15, pmuserenr_el0);
> Please use the ARMV8_USERENR_* constants here instead of a magic number
> (since you went through the hassle of defining them!).
> 
Ok.

>> >  	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>> >  }
>> >  
>> > @@ -45,6 +47,7 @@ static void __hyp_text __deactivate_traps(struct kvm_vcpu *vcpu)
>> >  	write_sysreg(HCR_RW, hcr_el2);
>> >  	write_sysreg(0, hstr_el2);
>> >  	write_sysreg(read_sysreg(mdcr_el2) & MDCR_EL2_HPMN_MASK, mdcr_el2);
>> > +	write_sysreg(0, pmuserenr_el0);
>> >  	write_sysreg(0, cptr_el2);
>> >  }
>> >  
>> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> > index 04281f1..ac0cbf8 100644
>> > --- a/arch/arm64/kvm/sys_regs.c
>> > +++ b/arch/arm64/kvm/sys_regs.c
>> > @@ -453,11 +453,47 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>> >  	vcpu_sys_reg(vcpu, r->reg) = val;
>> >  }
>> >  
>> > +static inline bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu)
> Please drop all the inline attributes. The compiler knows its stuff well
> enough to do it automagically, and this is hardly a fast path...
> 
>> > +{
>> > +	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
>> > +
>> > +	return !((reg & ARMV8_USERENR_EN) || vcpu_mode_priv(vcpu));
>> > +}
>> > +
>> > +static inline bool pmu_write_swinc_el0_disabled(struct kvm_vcpu *vcpu)
>> > +{
>> > +	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
>> > +
>> > +	return !((reg & (ARMV8_USERENR_SW | ARMV8_USERENR_EN))
>> > +		 || vcpu_mode_priv(vcpu));
>> > +}
>> > +
>> > +static inline bool pmu_access_cycle_counter_el0_disabled(struct kvm_vcpu *vcpu)
>> > +{
>> > +	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
>> > +
>> > +	return !((reg & (ARMV8_USERENR_CR | ARMV8_USERENR_EN))
>> > +		 || vcpu_mode_priv(vcpu));
>> > +}
>> > +
>> > +static inline bool pmu_access_event_counter_el0_disabled(struct kvm_vcpu *vcpu)
>> > +{
>> > +	u64 reg = vcpu_sys_reg(vcpu, PMUSERENR_EL0);
>> > +
>> > +	return !((reg & (ARMV8_USERENR_ER | ARMV8_USERENR_EN))
>> > +		 || vcpu_mode_priv(vcpu));
>> > +}
>> > +
>> >  static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>> >  			const struct sys_reg_desc *r)
>> >  {
>> >  	u64 val;
>> >  
>> > +	if (pmu_access_el0_disabled(vcpu)) {
>> > +		kvm_forward_trap_to_el1(vcpu);
>> > +		return true;
>> > +	}
> So with the patch I posted earlier
> (http://www.spinics.net/lists/arm-kernel/msg472693.html), all the
> instances similar to that code can be rewritten as
> 
> +       if (pmu_access_el0_disabled(vcpu))
> +               return false;
> 
> You can then completely drop both patch 15 and my original patch to fix
> the PC stuff (which is far from being perfect, as noted by Peter).
Yeah, will fix this.

Thanks,
-- 
Shannon

