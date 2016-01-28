From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v10 04/21] KVM: ARM64: Add access handler for PMCR register
Date: Thu, 28 Jan 2016 16:36:35 +0100
Message-ID: <20160128153635.GB3807@hawk.localdomain>
References: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
 <1453866709-20324-5-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0630407A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2016 10:31:41 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SUFyAdAN1Ifh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Jan 2016 10:31:40 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 654FF40B40
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2016 10:31:40 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1453866709-20324-5-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, shannon.zhao@linaro.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 27, 2016 at 11:51:32AM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Add reset handler which gets host value of PMCR_EL0 and make writable
> bits architecturally UNKNOWN except PMCR.E which is zero. Add an access
> handler for PMCR.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 42 ++++++++++++++++++++++++++++++++++++++++--
>  include/kvm/arm_pmu.h     |  4 ++++
>  2 files changed, 44 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index eec3598..97fea84 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -34,6 +34,7 @@
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_host.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/pmu.h>
>  
>  #include <trace/events/kvm.h>
>  
> @@ -439,6 +440,43 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
>  }
>  
> +static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	u64 pmcr, val;
> +
> +	asm volatile("mrs %0, pmcr_el0\n" : "=r" (pmcr));
> +	/* Writable bits of PMCR_EL0 (ARMV8_PMCR_MASK) is reset to UNKNOWN
> +	 * except PMCR.E resetting to zero.
> +	 */
> +	val = ((pmcr & ~ARMV8_PMCR_MASK) | (ARMV8_PMCR_MASK & 0xdecafbad))
> +	      & (~ARMV8_PMCR_E);
> +	vcpu_sys_reg(vcpu, PMCR_EL0) = val;
> +}
> +
> +static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			const struct sys_reg_desc *r)
> +{
> +	u64 val;
> +
> +	if (!kvm_arm_pmu_v3_ready(vcpu))
> +		return trap_raz_wi(vcpu, p, r);
> +
> +	if (p->is_write) {
> +		/* Only update writeable bits of PMCR */
> +		val = vcpu_sys_reg(vcpu, PMCR_EL0);
> +		val &= ~ARMV8_PMCR_MASK;
> +		val |= p->regval & ARMV8_PMCR_MASK;
> +		vcpu_sys_reg(vcpu, PMCR_EL0) = val;
> +	} else {
> +		/* PMCR.P & PMCR.C are RAZ */
> +		val = vcpu_sys_reg(vcpu, PMCR_EL0)
> +		      & ~(ARMV8_PMCR_P | ARMV8_PMCR_C);
> +		p->regval = val;

Should we also be setting the IMP, IDCODE, and N fields here to the
values of the host PE?

> +	}
> +
> +	return true;
> +}
> +
>  /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
>  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
>  	/* DBGBVRn_EL1 */						\
> @@ -623,7 +661,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  
>  	/* PMCR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b000),
> -	  trap_raz_wi },
> +	  access_pmcr, reset_pmcr, },
>  	/* PMCNTENSET_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b001),
>  	  trap_raz_wi },
> @@ -885,7 +923,7 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	{ Op1( 0), CRn( 7), CRm(14), Op2( 2), access_dcsw },
>  
>  	/* PMU */
> -	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), trap_raz_wi },
> +	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), access_pmcr },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index be220ee..32fee2d 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -34,9 +34,13 @@ struct kvm_pmu {
>  	struct kvm_pmc pmc[ARMV8_MAX_COUNTERS];
>  	bool ready;
>  };
> +
> +#define kvm_arm_pmu_v3_ready(v)		((v)->arch.pmu.ready)
>  #else
>  struct kvm_pmu {
>  };
> +
> +#define kvm_arm_pmu_v3_ready(v)		(false)
>  #endif
>  
>  #endif
> -- 
> 2.0.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
