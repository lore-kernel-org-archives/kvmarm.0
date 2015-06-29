From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 06/11] KVM: arm: add trap handlers for 32-bit debug
 registers
Date: Mon, 29 Jun 2015 23:16:41 +0200
Message-ID: <20150629211641.GO11332@cbox>
References: <1434969694-7432-1-git-send-email-zhichao.huang@linaro.org>
 <1434969694-7432-7-git-send-email-zhichao.huang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1434969694-7432-7-git-send-email-zhichao.huang@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Zhichao Huang <zhichao.huang@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, alex.bennee@linaro.org, will.deacon@arm.com, huangzhichao@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 22, 2015 at 06:41:29PM +0800, Zhichao Huang wrote:
> Add handlers for all the 32-bit debug registers.
> 
> Signed-off-by: Zhichao Huang <zhichao.huang@linaro.org>
> ---
>  arch/arm/include/asm/kvm_asm.h  |  12 ++++
>  arch/arm/include/asm/kvm_host.h |   3 +
>  arch/arm/kernel/asm-offsets.c   |   1 +
>  arch/arm/kvm/coproc.c           | 122 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 138 insertions(+)
> 
> diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
> index 25410b2..ba65e05 100644
> --- a/arch/arm/include/asm/kvm_asm.h
> +++ b/arch/arm/include/asm/kvm_asm.h
> @@ -52,6 +52,18 @@
>  #define c10_AMAIR1	30	/* Auxilary Memory Attribute Indirection Reg1 */
>  #define NR_CP15_REGS	31	/* Number of regs (incl. invalid) */
>  
> +/* 0 is reserved as an invalid value. */
> +#define cp14_DBGBVR0	1	/* Debug Breakpoint Control Registers (0-15) */
> +#define cp14_DBGBVR15	16
> +#define cp14_DBGBCR0	17	/* Debug Breakpoint Value Registers (0-15) */
> +#define cp14_DBGBCR15	32
> +#define cp14_DBGWVR0	33	/* Debug Watchpoint Control Registers (0-15) */
> +#define cp14_DBGWVR15	48
> +#define cp14_DBGWCR0	49	/* Debug Watchpoint Value Registers (0-15) */
> +#define cp14_DBGWCR15	64
> +#define cp14_DBGDSCRext	65	/* Debug Status and Control external */
> +#define NR_CP14_REGS	66	/* Number of regs (incl. invalid) */
> +
>  #define ARM_EXCEPTION_RESET	  0
>  #define ARM_EXCEPTION_UNDEFINED   1
>  #define ARM_EXCEPTION_SOFTWARE    2
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index d71607c..3d16820 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -124,6 +124,9 @@ struct kvm_vcpu_arch {
>  	struct vgic_cpu vgic_cpu;
>  	struct arch_timer_cpu timer_cpu;
>  
> +	/* System control coprocessor (cp14) */
> +	u32 cp14[NR_CP14_REGS];
> +
>  	/*
>  	 * Anything that is not used directly from assembly code goes
>  	 * here.
> diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
> index 871b826..9158de0 100644
> --- a/arch/arm/kernel/asm-offsets.c
> +++ b/arch/arm/kernel/asm-offsets.c
> @@ -172,6 +172,7 @@ int main(void)
>  #ifdef CONFIG_KVM_ARM_HOST
>    DEFINE(VCPU_KVM,		offsetof(struct kvm_vcpu, kvm));
>    DEFINE(VCPU_MIDR,		offsetof(struct kvm_vcpu, arch.midr));
> +  DEFINE(VCPU_CP14,		offsetof(struct kvm_vcpu, arch.cp14));
>    DEFINE(VCPU_CP15,		offsetof(struct kvm_vcpu, arch.cp15));
>    DEFINE(VCPU_VFP_GUEST,	offsetof(struct kvm_vcpu, arch.vfp_guest));
>    DEFINE(VCPU_VFP_HOST,		offsetof(struct kvm_vcpu, arch.host_cpu_context));
> diff --git a/arch/arm/kvm/coproc.c b/arch/arm/kvm/coproc.c
> index 16d5f69..59b65b7 100644
> --- a/arch/arm/kvm/coproc.c
> +++ b/arch/arm/kvm/coproc.c
> @@ -220,6 +220,47 @@ bool access_vm_reg(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static bool trap_debug32(struct kvm_vcpu *vcpu,
> +			const struct coproc_params *p,
> +			const struct coproc_reg *r)
> +{
> +	if (p->is_write)
> +		vcpu->arch.cp14[r->reg] = *vcpu_reg(vcpu, p->Rt1);
> +	else
> +		*vcpu_reg(vcpu, p->Rt1) = vcpu->arch.cp14[r->reg];
> +
> +	return true;
> +}
> +
> +/* DBGIDR (RO) Debug ID */
> +static bool trap_dbgidr(struct kvm_vcpu *vcpu,
> +			const struct coproc_params *p,
> +			const struct coproc_reg *r)
> +{
> +	u32 val;
> +
> +	if (p->is_write)
> +		return ignore_write(vcpu, p);
> +
> +	ARM_DBG_READ(c0, c0, 0, val);
> +	*vcpu_reg(vcpu, p->Rt1) = val;
> +
> +	return true;
> +}
> +
> +/* DBGDSCRint (RO) Debug Status and Control Register */
> +static bool trap_dbgdscr(struct kvm_vcpu *vcpu,
> +			const struct coproc_params *p,
> +			const struct coproc_reg *r)
> +{
> +	if (p->is_write)
> +		return ignore_write(vcpu, p);
> +
> +	*vcpu_reg(vcpu, p->Rt1) = vcpu->arch.cp14[r->reg];
> +
> +	return true;
> +}
> +
>  /*
>   * We could trap ID_DFR0 and tell the guest we don't support performance
>   * monitoring.  Unfortunately the patch to make the kernel check ID_DFR0 was
> @@ -375,7 +416,88 @@ static const struct coproc_reg cp15_regs[] = {
>  	{ CRn(15), CRm( 0), Op1( 4), Op2( 0), is32, access_cbar},
>  };
>  
> +#define DBG_BCR_BVR_WCR_WVR(n)					\
> +	/* DBGBVRn */						\
> +	{ CRn( 0), CRm((n)), Op1( 0), Op2( 4), is32,		\
> +	  trap_debug32,	reset_val, (cp14_DBGBVR0 + (n)), 0 },	\
> +	/* DBGBCRn */						\
> +	{ CRn( 0), CRm((n)), Op1( 0), Op2( 5), is32,		\
> +	  trap_debug32,	reset_val, (cp14_DBGBCR0 + (n)), 0 },	\
> +	/* DBGWVRn */						\
> +	{ CRn( 0), CRm((n)), Op1( 0), Op2( 6), is32,		\
> +	  trap_debug32,	reset_val, (cp14_DBGWVR0 + (n)), 0 },	\
> +	/* DBGWCRn */						\
> +	{ CRn( 0), CRm((n)), Op1( 0), Op2( 7), is32,		\
> +	  trap_debug32,	reset_val, (cp14_DBGWCR0 + (n)), 0 }
> +
> +/* No OS DBGBXVR machanism implemented. */
> +#define DBGBXVR(n)						\
> +	{ CRn( 1), CRm((n)), Op1( 0), Op2( 1), is32, trap_raz_wi }
> +
> +/*
> + * Trapped cp14 registers. We generally ignore most of the external
> + * debug, on the principle that they don't really make sense to a
> + * guest. Revisit this one day, whould this principle change.

s/whould/should/

> + */
>  static const struct coproc_reg cp14_regs[] = {
> +	/* DBGIDR */
> +	{ CRn( 0), CRm( 0), Op1( 0), Op2( 0), is32, trap_dbgidr},
> +	/* DBGDTRRXext */
> +	{ CRn( 0), CRm( 0), Op1( 0), Op2( 2), is32, trap_raz_wi },
> +	DBG_BCR_BVR_WCR_WVR(0),
> +	/* DBGDSCRint */
> +	{ CRn( 0), CRm( 1), Op1( 0), Op2( 0), is32, trap_dbgdscr,
> +				NULL, cp14_DBGDSCRext },
> +	DBG_BCR_BVR_WCR_WVR(1),
> +	/* DBGDSCRext */
> +	{ CRn( 0), CRm( 2), Op1( 0), Op2( 2), is32, trap_debug32,
> +				reset_val, cp14_DBGDSCRext, 0 },
> +	DBG_BCR_BVR_WCR_WVR(2),
> +	/* DBGDTRRXext */
> +	{ CRn( 0), CRm( 3), Op1( 0), Op2( 2), is32, trap_raz_wi },

isn't this the DBGDTRTXext register?

> +	DBG_BCR_BVR_WCR_WVR(3),
> +	DBG_BCR_BVR_WCR_WVR(4),
> +	/* DBGDTR[RT]Xint */
> +	{ CRn( 0), CRm( 5), Op1( 0), Op2( 0), is32, trap_raz_wi },
> +	DBG_BCR_BVR_WCR_WVR(5),
> +	DBG_BCR_BVR_WCR_WVR(6),
> +	/* DBGVCR */
> +	{ CRn( 0), CRm( 7), Op1( 0), Op2( 0), is32, trap_debug32 },
> +	DBG_BCR_BVR_WCR_WVR(7),
> +	DBG_BCR_BVR_WCR_WVR(8),
> +	DBG_BCR_BVR_WCR_WVR(9),
> +	DBG_BCR_BVR_WCR_WVR(10),
> +	DBG_BCR_BVR_WCR_WVR(11),
> +	DBG_BCR_BVR_WCR_WVR(12),
> +	DBG_BCR_BVR_WCR_WVR(13),
> +	DBG_BCR_BVR_WCR_WVR(14),
> +	DBG_BCR_BVR_WCR_WVR(15),
> +
> +	DBGBXVR(0),
> +	/* DBGOSLAR */
> +	{ CRn( 1), CRm( 0), Op1( 0), Op2( 4), is32, trap_raz_wi },
> +	DBGBXVR(1),
> +	/* DBGOSLSR */
> +	{ CRn( 1), CRm( 1), Op1( 0), Op2( 4), is32, trap_raz_wi },
> +	DBGBXVR(2),
> +	DBGBXVR(3),
> +	/* DBGOSDLRd */
> +	{ CRn( 1), CRm( 3), Op1( 0), Op2( 4), is32, trap_raz_wi },
> +	DBGBXVR(4),
> +	DBGBXVR(5),
> +	/* DBGPRSRa */
> +	{ CRn( 1), CRm( 5), Op1( 0), Op2( 4), is32, trap_raz_wi },
> +
> +	DBGBXVR(6),
> +	DBGBXVR(7),
> +	DBGBXVR(8),
> +	DBGBXVR(9),
> +	DBGBXVR(10),
> +	DBGBXVR(11),
> +	DBGBXVR(12),
> +	DBGBXVR(13),
> +	DBGBXVR(14),
> +	DBGBXVR(15),
>  };
>  
>  /* Target specific emulation tables */
> -- 
> 1.7.12.4
> 
Otherwise this looks ok,
-Christoffer
