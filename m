From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 13/15] KVM: arm: keep track of guest use of the debug
 registers
Date: Wed, 2 Sep 2015 18:01:03 +0200
Message-ID: <20150902160103.GP10991@cbox>
References: <1439213167-8988-1-git-send-email-zhichao.huang@linaro.org>
 <1439213167-8988-14-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1439213167-8988-14-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Zhichao Huang <zhichao.huang@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com, huangzhichao@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 10, 2015 at 09:26:05PM +0800, Zhichao Huang wrote:
> We trap debug register accesses from guest all the time, and read the
> BCR/WCR to indicate whether the guest has enabled any break/watch points
> or not.
> 
> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
> ---
>  arch/arm/include/asm/kvm_asm.h |  2 ++
>  arch/arm/kvm/coproc.c          | 75 +++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 72 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
> index 5b1c3eb..e9e1f0a 100644
> --- a/arch/arm/include/asm/kvm_asm.h
> +++ b/arch/arm/include/asm/kvm_asm.h
> @@ -65,7 +65,9 @@
>  #define NR_CP14_REGS	66	/* Number of regs (incl. invalid) */
>  
>  #define KVM_ARM_DEBUG_HOST_INUSE_SHIFT	0
> +#define KVM_ARM_DEBUG_GUEST_INUSE_SHIFT	1
>  #define KVM_ARM_DEBUG_HOST_INUSE	(1 << KVM_ARM_DEBUG_HOST_INUSE_SHIFT)
> +#define KVM_ARM_DEBUG_GUEST_INUSE	(1 << KVM_ARM_DEBUG_GUEST_INUSE_SHIFT)
>  
>  #define ARM_EXCEPTION_RESET	  0
>  #define ARM_EXCEPTION_UNDEFINED   1
> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> index b37afd6..d9dcd28b 100644
> --- a/arch/arm/kvm/coproc.c
> +++ b/arch/arm/kvm/coproc.c
> @@ -220,7 +220,22 @@ bool access_vm_reg(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> -static bool trap_debug32(struct kvm_vcpu *vcpu,
> +/* Indicate whether the guest has enabled any break/watch points or not. */
> +static bool guest_debug_in_use(struct kvm_vcpu *vcpu)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARM_MAX_BRP; i++)
> +		if (vcpu->arch.cp14[cp14_DBGBCR0 + i] & 0x1)
> +			return true;
> +	for (i = 0; i < ARM_MAX_WRP; i++)
> +		if (vcpu->arch.cp14[cp14_DBGWCR0 + i] & 0x1)
> +			return true;
> +
> +	return false;
> +}
> +
> +static bool __trap_debug32(struct kvm_vcpu *vcpu,
>  			const struct coproc_params *p,
>  			const struct coproc_reg *r)
>  {
> @@ -232,6 +247,56 @@ static bool trap_debug32(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +/*
> + * We want to avoid world-switching all the DBG registers all the
> + * time:
> + *
> + * When we are about to run a guest, we have the following cases:
> + *
> + * 1) Neither the host nor the guest has configured any [WB]points
> + * 2) Only the host has configured any [WB]points
> + * 3) Only the guest has configured any [WB]points
> + * 4) Both the host and the guest have configured any [WB]points
> + *
> + * - In case (1), KVM should enable trapping and swtich the register
						    switch
> + *   state on guest accesses.
> + * - In cases (2), (3), and (4) we must switch the register state on each
> + *   entry/exit.
> + *
> + * For ARMv7, if the CONFIG_HAVE_HW_BREAKPOINT is set, ARM_DSCR_MDBGEN
> + * is always set(ARM64 use it to indicate that debug registers are actively
        add space  ^
> + * in use).

While I like having the overall explanation of the flow somewhere, I
feel this is a strange place to put it.  Perhaps there is a more
suitable location?

> + *
> + * - We add a function reading the break/watch control variables directly to
> + *   indicate whether the host has enabled any break/watch points or not.
> + *   We only call the function upon guest entry, after preempt_disable() and
> + *   local_irq_disable(), so there is no race for it.

This paragraph of the commenting doesn't seem to fit with the rest, and
didn't we cover this already in a previous patch?

> + *
> + * - We trap debug register accesses from guest all the time, and read the
> + *   BCR/WCR to indicate whether the guest has enabled any break/watch points
> + *   or not.

do we trap all the time?  not if we're switching the state I suppose?

> + *
> + * For this, we can keep track of the host/guest use of debug registers,
> + * and skip the save/restore dance when neither the host nor the guest has
> + * configured any [WB]points.
> + */
> +static bool trap_debug32(struct kvm_vcpu *vcpu,
> +			const struct coproc_params *p,
> +			const struct coproc_reg *r)
> +{
> +	__trap_debug32(vcpu, p, r);
> +
> +	if (p->is_write) {
> +		if ((vcpu->arch.cp14[r->reg] & 0x1) ||
> +		    guest_debug_in_use(vcpu))
> +			vcpu->arch.debug_flags |= KVM_ARM_DEBUG_GUEST_INUSE;
> +		else
> +			vcpu->arch.debug_flags &= ~KVM_ARM_DEBUG_GUEST_INUSE;

I don't understand this logic, if we are enabling one of the w/b points
or if there was already an enabled w/b point, then we set the flag, but
if you disable a single one then you clear the flag?

It looks to me like you're mixing two approaches here;  either read
through all the registers whenever you need to know to set the flag or
not, or you keep track of this on every read/write of the registers.

> +	}
> +
> +	return true;
> +}
> +
>  /* DBGIDR (RO) Debug ID */
>  static bool trap_dbgidr(struct kvm_vcpu *vcpu,
>  			const struct coproc_params *p,
> @@ -419,13 +484,13 @@ static const struct coproc_reg cp15_regs[] = {
>  #define DBG_BCR_BVR_WCR_WVR(n)					\
>  	/* DBGBVRn */						\
>  	{ CRn( 0), CRm((n)), Op1( 0), Op2( 4), is32,		\
> -	  trap_debug32,	reset_val, (cp14_DBGBVR0 + (n)), 0 },	\
> +	  __trap_debug32, reset_val, (cp14_DBGBVR0 + (n)), 0 },	\
>  	/* DBGBCRn */						\
>  	{ CRn( 0), CRm((n)), Op1( 0), Op2( 5), is32,		\
>  	  trap_debug32,	reset_val, (cp14_DBGBCR0 + (n)), 0 },	\
>  	/* DBGWVRn */						\
>  	{ CRn( 0), CRm((n)), Op1( 0), Op2( 6), is32,		\
> -	  trap_debug32,	reset_val, (cp14_DBGWVR0 + (n)), 0 },	\
> +	  __trap_debug32, reset_val, (cp14_DBGWVR0 + (n)), 0 },	\
>  	/* DBGWCRn */						\
>  	{ CRn( 0), CRm((n)), Op1( 0), Op2( 7), is32,		\
>  	  trap_debug32,	reset_val, (cp14_DBGWCR0 + (n)), 0 }
> @@ -462,7 +527,7 @@ static const struct coproc_reg cp14_regs[] = {
>  	/* DBGDSAR (64bit) */
>  	{ CRn( 0), CRm( 2), Op1( 0), Op2( 0), is64, trap_raz_wi },
>  	/* DBGDSCRext */
> -	{ CRn( 0), CRm( 2), Op1( 0), Op2( 2), is32, trap_debug32,
> +	{ CRn( 0), CRm( 2), Op1( 0), Op2( 2), is32, __trap_debug32,
>  				reset_val, cp14_DBGDSCRext, 0 },
>  	DBG_BCR_BVR_WCR_WVR(2),
>  	/* DBGDTRTXext */
> @@ -474,7 +539,7 @@ static const struct coproc_reg cp14_regs[] = {
>  	DBG_BCR_BVR_WCR_WVR(5),
>  	DBG_BCR_BVR_WCR_WVR(6),
>  	/* DBGVCR */
> -	{ CRn( 0), CRm( 7), Op1( 0), Op2( 0), is32, trap_debug32 },
> +	{ CRn( 0), CRm( 7), Op1( 0), Op2( 0), is32, __trap_debug32 },
>  	DBG_BCR_BVR_WCR_WVR(7),
>  	DBG_BCR_BVR_WCR_WVR(8),
>  	DBG_BCR_BVR_WCR_WVR(9),
> -- 
> 1.7.12.4
> 

So __trap_debug32 is for the non-control registers and trap-debug32 is
for the control registers?

I think specifically naming the control register function
trap_debug_cr would be cleaner in that case.

Thanks,
-Christoffer

