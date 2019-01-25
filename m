From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH 10/14] KVM: arm/arm64: consolidate arch timer trap handlers
Date: Fri, 25 Jan 2019 12:33:30 +0000
Message-ID: <d9e59695-bc87-e2b5-f0d0-7bc172d2d83c@arm.com>
References: <20190124140032.8588-1-christoffer.dall@arm.com>
 <20190124140032.8588-11-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92B464A3B0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 07:33:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v6Op5tHkEUJ9 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jan 2019 07:33:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CC244A3A2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 07:33:34 -0500 (EST)
In-Reply-To: <20190124140032.8588-11-christoffer.dall@arm.com>
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
To: Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

I'm wondering, could this patch be split in two? One for the
introduction of kvm_arm_timer_read_sysreg() +
kvm_arm_timer_write_sysreg() and the other for merging the handlers into
a single function?



On 24/01/2019 14:00, Christoffer Dall wrote:
> From: Andre Przywara <andre.przywara@arm.com>
> 
> At the moment we have separate system register emulation handlers for
> each timer register. Actually they are quite similar, and we rely on
> kvm_arm_timer_[gs]et_reg() for the actual emulation anyways, so let's
> just merge all of those handlers into one function, which just marshalls
> the arguments and then hands off to a set of common accessors.
> This makes extending the emulation to include EL2 timers much easier.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> [Fixed 32-bit VM breakage and reduced to reworking existing code]
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> [Fixed 32bit host, general cleanup]
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/coproc.c           |  23 +++---
>  arch/arm64/include/asm/sysreg.h |   4 +
>  arch/arm64/kvm/sys_regs.c       |  80 +++++++++++---------
>  include/kvm/arm_arch_timer.h    |  23 ++++++
>  virt/kvm/arm/arch_timer.c       | 129 +++++++++++++++++++++++++++-----
>  5 files changed, 196 insertions(+), 63 deletions(-)
> 
> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> index 222c1635bc7a..51863364f8d1 100644
> --- a/arch/arm/kvm/coproc.c
> +++ b/arch/arm/kvm/coproc.c
> @@ -293,15 +293,16 @@ static bool access_cntp_tval(struct kvm_vcpu *vcpu,
>  			     const struct coproc_params *p,
>  			     const struct coproc_reg *r)
>  {
> -	u64 now = kvm_phys_timer_read();
> -	u64 val;
> +	u32 val;
>  
>  	if (p->is_write) {
>  		val = *vcpu_reg(vcpu, p->Rt1);
> -		kvm_arm_timer_set_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL, val + now);
> +		kvm_arm_timer_write_sysreg(vcpu,
> +					   TIMER_PTIMER, TIMER_REG_TVAL, val);
>  	} else {
> -		val = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL);
> -		*vcpu_reg(vcpu, p->Rt1) = val - now;
> +		val = kvm_arm_timer_read_sysreg(vcpu,
> +						TIMER_PTIMER, TIMER_REG_TVAL);
> +		*vcpu_reg(vcpu, p->Rt1) = val;
>  	}
>  
>  	return true;
> @@ -315,9 +316,11 @@ static bool access_cntp_ctl(struct kvm_vcpu *vcpu,
>  
>  	if (p->is_write) {
>  		val = *vcpu_reg(vcpu, p->Rt1);
> -		kvm_arm_timer_set_reg(vcpu, KVM_REG_ARM_PTIMER_CTL, val);
> +		kvm_arm_timer_write_sysreg(vcpu,
> +					   TIMER_PTIMER, TIMER_REG_CTL, val);
>  	} else {
> -		val = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_PTIMER_CTL);
> +		val = kvm_arm_timer_read_sysreg(vcpu,
> +						TIMER_PTIMER, TIMER_REG_CTL);
>  		*vcpu_reg(vcpu, p->Rt1) = val;
>  	}
>  
> @@ -333,9 +336,11 @@ static bool access_cntp_cval(struct kvm_vcpu *vcpu,
>  	if (p->is_write) {
>  		val = (u64)*vcpu_reg(vcpu, p->Rt2) << 32;
>  		val |= *vcpu_reg(vcpu, p->Rt1);
> -		kvm_arm_timer_set_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL, val);
> +		kvm_arm_timer_write_sysreg(vcpu,
> +					   TIMER_PTIMER, TIMER_REG_CVAL, val);
>  	} else {
> -		val = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL);
> +		val = kvm_arm_timer_read_sysreg(vcpu,
> +						TIMER_PTIMER, TIMER_REG_CVAL);
>  		*vcpu_reg(vcpu, p->Rt1) = val;
>  		*vcpu_reg(vcpu, p->Rt2) = val >> 32;
>  	}
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 3e5650903d6d..6482e8bcf1b8 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -392,6 +392,10 @@
>  #define SYS_CNTP_CTL_EL0		sys_reg(3, 3, 14, 2, 1)
>  #define SYS_CNTP_CVAL_EL0		sys_reg(3, 3, 14, 2, 2)
>  
> +#define SYS_AARCH32_CNTP_TVAL		sys_reg(0, 0, 14, 2, 0)
> +#define SYS_AARCH32_CNTP_CTL		sys_reg(0, 0, 14, 2, 1)
> +#define SYS_AARCH32_CNTP_CVAL		sys_reg(0, 2, 0, 14, 0)
> +
>  #define __PMEV_op2(n)			((n) & 0x7)
>  #define __CNTR_CRm(n)			(0x8 | (((n) >> 3) & 0x3))
>  #define SYS_PMEVCNTRn_EL0(n)		sys_reg(3, 3, 14, __CNTR_CRm(n), __PMEV_op2(n))
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 1a5bea4285e4..65ea63366c67 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -990,44 +990,51 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	{ SYS_DESC(SYS_PMEVTYPERn_EL0(n)),					\
>  	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
>  
> -static bool access_cntp_tval(struct kvm_vcpu *vcpu,
> -		struct sys_reg_params *p,
> -		const struct sys_reg_desc *r)
> +static bool access_arch_timer(struct kvm_vcpu *vcpu,
> +			      struct sys_reg_params *p,
> +			      const struct sys_reg_desc *r)
>  {
> -	u64 now = kvm_phys_timer_read();
> -	u64 cval;
> +	enum kvm_arch_timers tmr;
> +	enum kvm_arch_timer_regs treg;
> +	u64 reg = reg_to_encoding(r);
>  
> -	if (p->is_write) {
> -		kvm_arm_timer_set_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL,
> -				      p->regval + now);
> -	} else {
> -		cval = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL);
> -		p->regval = cval - now;
> +	switch (reg) {
> +	case SYS_CNTP_TVAL_EL0:
> +	case SYS_CNTP_CTL_EL0:
> +	case SYS_CNTP_CVAL_EL0:
> +	case SYS_AARCH32_CNTP_TVAL:
> +	case SYS_AARCH32_CNTP_CTL:
> +	case SYS_AARCH32_CNTP_CVAL:
> +		tmr = TIMER_PTIMER;
> +		break;
> +	default:
> +		BUG();
>  	}
>  
> -	return true;
> -}
> +	switch (reg) {

I find having two consecutive switch on the same element a bit weird
(and takes a lot of space).

Either I'd merge the two since the valid cases are the same, or I'd put
them in separate function "reg_get_timer(reg)",
"reg_get_timer_reg(reg)". (Can probably fit those in
include/kvm/arm_arch_timer.h)

> +	case SYS_CNTP_CVAL_EL0:
> +	case SYS_AARCH32_CNTP_CVAL:
> +		treg = TIMER_REG_CVAL;
> +		break;
>  
> -static bool access_cntp_ctl(struct kvm_vcpu *vcpu,
> -		struct sys_reg_params *p,
> -		const struct sys_reg_desc *r)
> -{
> -	if (p->is_write)
> -		kvm_arm_timer_set_reg(vcpu, KVM_REG_ARM_PTIMER_CTL, p->regval);
> -	else
> -		p->regval = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_PTIMER_CTL);
> +	case SYS_CNTP_TVAL_EL0:
> +	case SYS_AARCH32_CNTP_TVAL:
> +		treg = TIMER_REG_TVAL;
> +		break;
>  
> -	return true;
> -}
> +	case SYS_CNTP_CTL_EL0:
> +	case SYS_AARCH32_CNTP_CTL:
> +		treg = TIMER_REG_CTL;
> +		break;
> +
> +	default:
> +		BUG();
> +	}
>  
> -static bool access_cntp_cval(struct kvm_vcpu *vcpu,
> -		struct sys_reg_params *p,
> -		const struct sys_reg_desc *r)
> -{
>  	if (p->is_write)
> -		kvm_arm_timer_set_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL, p->regval);
> +		kvm_arm_timer_write_sysreg(vcpu, tmr, treg, p->regval);
>  	else
> -		p->regval = kvm_arm_timer_get_reg(vcpu, KVM_REG_ARM_PTIMER_CVAL);
> +		p->regval = kvm_arm_timer_read_sysreg(vcpu, tmr, treg);
>  
>  	return true;
>  }
> @@ -1392,9 +1399,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_TPIDR_EL0), NULL, reset_unknown, TPIDR_EL0 },
>  	{ SYS_DESC(SYS_TPIDRRO_EL0), NULL, reset_unknown, TPIDRRO_EL0 },
>  
> -	{ SYS_DESC(SYS_CNTP_TVAL_EL0), access_cntp_tval },
> -	{ SYS_DESC(SYS_CNTP_CTL_EL0), access_cntp_ctl },
> -	{ SYS_DESC(SYS_CNTP_CVAL_EL0), access_cntp_cval },
> +	{ SYS_DESC(SYS_CNTP_TVAL_EL0), access_arch_timer },
> +	{ SYS_DESC(SYS_CNTP_CTL_EL0), access_arch_timer },
> +	{ SYS_DESC(SYS_CNTP_CVAL_EL0), access_arch_timer },
>  
>  	/* PMEVCNTRn_EL0 */
>  	PMU_PMEVCNTR_EL0(0),
> @@ -1715,10 +1722,9 @@ static const struct sys_reg_desc cp15_regs[] = {
>  
>  	{ Op1( 0), CRn(13), CRm( 0), Op2( 1), access_vm_reg, NULL, c13_CID },
>  
> -	/* CNTP_TVAL */
> -	{ Op1( 0), CRn(14), CRm( 2), Op2( 0), access_cntp_tval },
> -	/* CNTP_CTL */
> -	{ Op1( 0), CRn(14), CRm( 2), Op2( 1), access_cntp_ctl },
> +	/* Arch Tmers */
> +	{ SYS_DESC(SYS_AARCH32_CNTP_TVAL), access_arch_timer },
> +	{ SYS_DESC(SYS_AARCH32_CNTP_CTL), access_arch_timer },
>  
>  	/* PMEVCNTRn */
>  	PMU_PMEVCNTR(0),
> @@ -1795,7 +1801,7 @@ static const struct sys_reg_desc cp15_64_regs[] = {
>  	{ Op1( 1), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, c2_TTBR1 },
>  	{ Op1( 1), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_ASGI1R */
>  	{ Op1( 2), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_SGI0R */
> -	{ Op1( 2), CRn( 0), CRm(14), Op2( 0), access_cntp_cval },
> +	{ SYS_DESC(SYS_AARCH32_CNTP_CVAL),    access_arch_timer },
>  };
>  
>  /* Target specific emulation tables */
> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index d6e6a45d1d24..d26b7fde9935 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -22,6 +22,19 @@
>  #include <linux/clocksource.h>
>  #include <linux/hrtimer.h>
>  
> +enum kvm_arch_timers {
> +	TIMER_PTIMER,
> +	TIMER_VTIMER,
> +	NR_KVM_TIMERS
> +};
> +
> +enum kvm_arch_timer_regs {
> +	TIMER_REG_CNT,
> +	TIMER_REG_CVAL,
> +	TIMER_REG_TVAL,
> +	TIMER_REG_CTL,
> +};
> +
>  struct arch_timer_context {
>  	/* Registers: control register, timer value */
>  	u32				cnt_ctl;
> @@ -87,5 +100,15 @@ bool kvm_arch_timer_get_input_level(int vintid);
>  
>  #define vcpu_vtimer(v)	(&(v)->arch.timer_cpu.vtimer)
>  #define vcpu_ptimer(v)	(&(v)->arch.timer_cpu.ptimer)
> +#define vcpu_get_timer(v,t)					\
> +	(t == TIMER_VTIMER ? vcpu_vtimer(v) : vcpu_ptimer(v))
> +
> +u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
> +			      enum kvm_arch_timers tmr,
> +			      enum kvm_arch_timer_regs treg);
> +void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
> +				enum kvm_arch_timers tmr,
> +				enum kvm_arch_timer_regs treg,
> +				u64 val);
> 
>  #endif
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 4986028d9829..9502bb91776b 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -25,6 +25,7 @@
>  
>  #include <clocksource/arm_arch_timer.h>
>  #include <asm/arch_timer.h>
> +#include <asm/kvm_emulate.h>
>  #include <asm/kvm_hyp.h>
>  
>  #include <kvm/arm_vgic.h>
> @@ -52,6 +53,13 @@ static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx);
>  static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
>  				 struct arch_timer_context *timer_ctx);
>  static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx);
> +static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
> +				struct arch_timer_context *timer,
> +				enum kvm_arch_timer_regs treg,
> +				u64 val);
> +static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
> +			      struct arch_timer_context *timer,
> +			      enum kvm_arch_timer_regs treg);
>  
>  u64 kvm_phys_timer_read(void)
>  {
> @@ -628,24 +636,25 @@ static void kvm_timer_init_interrupt(void *info)
>  
>  int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
>  {
> -	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> -	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> -
>  	switch (regid) {
>  	case KVM_REG_ARM_TIMER_CTL:
> -		vtimer->cnt_ctl = value & ~ARCH_TIMER_CTRL_IT_STAT;
> +		kvm_arm_timer_write(vcpu,
> +				    vcpu_vtimer(vcpu), TIMER_REG_CTL, value);
>  		break;
>  	case KVM_REG_ARM_TIMER_CNT:
>  		update_vtimer_cntvoff(vcpu, kvm_phys_timer_read() - value);
>  		break;
>  	case KVM_REG_ARM_TIMER_CVAL:
> -		vtimer->cnt_cval = value;
> +		kvm_arm_timer_write(vcpu,
> +				    vcpu_vtimer(vcpu), TIMER_REG_CVAL, value);
>  		break;
>  	case KVM_REG_ARM_PTIMER_CTL:
> -		ptimer->cnt_ctl = value & ~ARCH_TIMER_CTRL_IT_STAT;
> +		kvm_arm_timer_write(vcpu,
> +				    vcpu_ptimer(vcpu), TIMER_REG_CTL, value);
>  		break;
>  	case KVM_REG_ARM_PTIMER_CVAL:
> -		ptimer->cnt_cval = value;
> +		kvm_arm_timer_write(vcpu,
> +				    vcpu_ptimer(vcpu), TIMER_REG_CVAL, value);
>  		break;
>  
>  	default:
> @@ -672,26 +681,112 @@ static u64 read_timer_ctl(struct arch_timer_context *timer)
>  
>  u64 kvm_arm_timer_get_reg(struct kvm_vcpu *vcpu, u64 regid)
>  {
> -	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
> -	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
> -
>  	switch (regid) {
>  	case KVM_REG_ARM_TIMER_CTL:
> -		return read_timer_ctl(vtimer);
> +		return kvm_arm_timer_read(vcpu,
> +					  vcpu_vtimer(vcpu), TIMER_REG_CTL);
>  	case KVM_REG_ARM_TIMER_CNT:
> -		return kvm_phys_timer_read() - vtimer->cntvoff;
> +		return kvm_arm_timer_read(vcpu,
> +					  vcpu_vtimer(vcpu), TIMER_REG_CNT);
>  	case KVM_REG_ARM_TIMER_CVAL:
> -		return vtimer->cnt_cval;
> +		return kvm_arm_timer_read(vcpu,
> +					  vcpu_vtimer(vcpu), TIMER_REG_CVAL);
>  	case KVM_REG_ARM_PTIMER_CTL:
> -		return read_timer_ctl(ptimer);
> -	case KVM_REG_ARM_PTIMER_CVAL:
> -		return ptimer->cnt_cval;
> +		return kvm_arm_timer_read(vcpu,
> +					  vcpu_ptimer(vcpu), TIMER_REG_CTL);
>  	case KVM_REG_ARM_PTIMER_CNT:
> -		return kvm_phys_timer_read();
> +		return kvm_arm_timer_read(vcpu,
> +					  vcpu_vtimer(vcpu), TIMER_REG_CNT);
> +	case KVM_REG_ARM_PTIMER_CVAL:
> +		return kvm_arm_timer_read(vcpu,
> +					  vcpu_ptimer(vcpu), TIMER_REG_CVAL);
>  	}
>  	return (u64)-1;
>  }
>  
> +static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
> +			      struct arch_timer_context *timer,
> +			      enum kvm_arch_timer_regs treg)
> +{
> +	u64 val;
> +
> +	switch (treg) {
> +	case TIMER_REG_TVAL:
> +		val = kvm_phys_timer_read() - timer->cntvoff - timer->cnt_cval;
> +		break;
> +
> +	case TIMER_REG_CTL:
> +		val = read_timer_ctl(timer);
> +		break;
> +
> +	case TIMER_REG_CVAL:
> +		val = timer->cnt_cval;
> +		break;
> +
> +	case TIMER_REG_CNT:
> +		val = kvm_phys_timer_read() - timer->cntvoff;

Unless you really don't want people to read this register, you might
want to add a "break;" here :) .

> +
> +	default:
> +		BUG();
> +	}
> +
> +	return val;
> +}

Cheers,

-- 
Julien Thierry
