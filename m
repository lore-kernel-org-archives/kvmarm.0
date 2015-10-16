From: Wei Huang <wei@redhat.com>
Subject: Re: [PATCH v3 04/20] KVM: ARM64: Add reset and access handlers for
 PMCR_EL0 register
Date: Fri, 16 Oct 2015 00:35:50 -0500
Message-ID: <56208CB6.1050508@redhat.com>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
 <1443133885-3366-5-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1E3A411E3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Oct 2015 01:33:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xhyDQOAGpCkv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Oct 2015 01:33:34 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F5E8407A0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Oct 2015 01:33:33 -0400 (EDT)
In-Reply-To: <1443133885-3366-5-git-send-email-shannon.zhao@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 09/24/2015 05:31 PM, Shannon Zhao wrote:
> Add reset handler which gets host value of PMCR_EL0 and make writable
> bits architecturally UNKNOWN. Add a common access handler for PMU
> registers which emulates writing and reading register and add emulation
> for PMCR.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 81 +++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 79 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index b41607d..60c0842 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -33,6 +33,7 @@
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_host.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/pmu.h>
>  
>  #include <trace/events/kvm.h>
>  
> @@ -446,6 +447,53 @@ static void reset_mpidr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	vcpu_sys_reg(vcpu, MPIDR_EL1) = (1ULL << 31) | mpidr;
>  }
>  
> +static void vcpu_sysreg_write(struct kvm_vcpu *vcpu,
> +			      const struct sys_reg_desc *r, u64 val)
> +{
> +	if (!vcpu_mode_is_32bit(vcpu))
> +		vcpu_sys_reg(vcpu, r->reg) = val;
> +	else
> +		vcpu_cp15(vcpu, r->reg) = lower_32_bits(val);
> +}
> +
> +static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	u64 pmcr, val;
> +
> +	asm volatile("mrs %0, pmcr_el0\n" : "=r" (pmcr));
> +	/* Writable bits of PMCR_EL0 (ARMV8_PMCR_MASK) is reset to UNKNOWN*/
> +	val = (pmcr & ~ARMV8_PMCR_MASK) | (ARMV8_PMCR_MASK & 0xdecafbad);

Two comments:
(1) In Patch 1, ARMV8_PMCR_MASK is defined as 0x3f. According to ARMv8
spec, PMCR_EL0.LC (bit 6) is also writable. Should ARMV8_PMCR_MASK be 0x7f?
(2) According to spec the PMCR_EL0.E bit reset to 0, not UNKNOWN.


> +	vcpu_sysreg_write(vcpu, r, val);
> +}
> +
> +/* PMU registers accessor. */
> +static bool access_pmu_regs(struct kvm_vcpu *vcpu,
> +			    const struct sys_reg_params *p,
> +			    const struct sys_reg_desc *r)
> +{
> +	unsigned long val;
> +
> +	if (p->is_write) {
> +		switch (r->reg) {
> +		case PMCR_EL0: {
> +			/* Only update writeable bits of PMCR */
> +			val = vcpu_sys_reg(vcpu, r->reg);
> +			val &= ~ARMV8_PMCR_MASK;
> +			val |= *vcpu_reg(vcpu, p->Rt) & ARMV8_PMCR_MASK;
> +			vcpu_sys_reg(vcpu, r->reg) = val;
> +			break;
> +		}
> +		default:
> +			vcpu_sys_reg(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt);
> +			break;
> +		}
> +	} else {
> +		*vcpu_reg(vcpu, p->Rt) = vcpu_sys_reg(vcpu, r->reg);
> +	}
> +
> +	return true;
> +}
> +
>  /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
>  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
>  	/* DBGBVRn_EL1 */						\
> @@ -637,7 +685,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  
>  	/* PMCR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b000),
> -	  trap_raz_wi },
> +	  access_pmu_regs, reset_pmcr, PMCR_EL0, },
>  	/* PMCNTENSET_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b001),
>  	  trap_raz_wi },
> @@ -871,6 +919,34 @@ static const struct sys_reg_desc cp14_64_regs[] = {
>  	{ Op1( 0), CRm( 2), .access = trap_raz_wi },
>  };
>  
> +/* PMU CP15 registers accessor. */
> +static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
> +				 const struct sys_reg_params *p,
> +				 const struct sys_reg_desc *r)
> +{
> +	unsigned long val;
> +
> +	if (p->is_write) {
> +		switch (r->reg) {
> +		case c9_PMCR: {
> +			/* Only update writeable bits of PMCR */
> +			val = vcpu_cp15(vcpu, r->reg);
> +			val &= ~ARMV8_PMCR_MASK;
> +			val |= *vcpu_reg(vcpu, p->Rt) & ARMV8_PMCR_MASK;
> +			vcpu_cp15(vcpu, r->reg) = val;
> +			break;
> +		}
> +		default:
> +			vcpu_cp15(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt);
> +			break;
> +		}
> +	} else {
> +		*vcpu_reg(vcpu, p->Rt) = vcpu_cp15(vcpu, r->reg);
> +	}
> +
> +	return true;
> +}
> +
>  /*
>   * Trapped cp15 registers. TTBR0/TTBR1 get a double encoding,
>   * depending on the way they are accessed (as a 32bit or a 64bit
> @@ -899,7 +975,8 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	{ Op1( 0), CRn( 7), CRm(14), Op2( 2), access_dcsw },
>  
>  	/* PMU */
> -	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), trap_raz_wi },
> +	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), access_pmu_cp15_regs,
> +	  reset_pmcr, c9_PMCR },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
> 
