From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 06/21] KVM: ARM64: Add reset and access handlers for
 PMCEID0 and PMCEID1 register
Date: Mon, 30 Nov 2015 11:42:30 +0000
Message-ID: <20151130114230.136abc6f@arm.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>
 <1446186123-11548-7-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7547F41280
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2015 06:41:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KWaWTlaHBtp4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Nov 2015 06:41:19 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1734340F90
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2015 06:41:18 -0500 (EST)
In-Reply-To: <1446186123-11548-7-git-send-email-zhaoshenglong@huawei.com>
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
Cc: kvm@vger.kernel.org, shannon.zhao@linaro.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 30 Oct 2015 14:21:48 +0800
Shannon Zhao <zhaoshenglong@huawei.com> wrote:

> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Add reset handler which gets host value of PMCEID0 or PMCEID1. Since
> write action to PMCEID0 or PMCEID1 is ignored, add a new case for this.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 35d232e..cb82b15 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -469,6 +469,19 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	vcpu_sysreg_write(vcpu, r, val);
>  }
>  
> +static void reset_pmceid(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	u64 pmceid;
> +
> +	if (r->reg == PMCEID0_EL0 || r->reg == c9_PMCEID0)

That feels wrong. We should only reset the 64bit view of the sysregs,
as the 32bit view is directly mapped to it.

> +		asm volatile("mrs %0, pmceid0_el0\n" : "=r" (pmceid));
> +	else
> +		/* PMCEID1_EL0 or c9_PMCEID1 */
> +		asm volatile("mrs %0, pmceid1_el0\n" : "=r" (pmceid));
> +
> +	vcpu_sysreg_write(vcpu, r, pmceid);
> +}
> +
>  /* PMU registers accessor. */
>  static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>  			    const struct sys_reg_params *p,
> @@ -486,6 +499,9 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>  			vcpu_sys_reg(vcpu, r->reg) = val;
>  			break;
>  		}
> +		case PMCEID0_EL0:
> +		case PMCEID1_EL0:
> +			return ignore_write(vcpu, p);
>  		default:
>  			vcpu_sys_reg(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt);
>  			break;
> @@ -710,10 +726,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  access_pmu_regs, reset_unknown, PMSELR_EL0 },
>  	/* PMCEID0_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b110),
> -	  trap_raz_wi },
> +	  access_pmu_regs, reset_pmceid, PMCEID0_EL0 },
>  	/* PMCEID1_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b111),
> -	  trap_raz_wi },
> +	  access_pmu_regs, reset_pmceid, PMCEID1_EL0 },
>  	/* PMCCNTR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b000),
>  	  trap_raz_wi },
> @@ -943,6 +959,9 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
>  			vcpu_cp15(vcpu, r->reg) = val;
>  			break;
>  		}
> +		case c9_PMCEID0:
> +		case c9_PMCEID1:
> +			return ignore_write(vcpu, p);
>  		default:
>  			vcpu_cp15(vcpu, r->reg) = *vcpu_reg(vcpu, p->Rt);
>  			break;
> @@ -1000,8 +1019,10 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmu_cp15_regs,
>  	  reset_unknown_cp15, c9_PMSELR },
> -	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), trap_raz_wi },
> -	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), trap_raz_wi },
> +	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmu_cp15_regs,
> +	  reset_pmceid, c9_PMCEID0 },
> +	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmu_cp15_regs,
> +	  reset_pmceid, c9_PMCEID1 },

and as a consequence, this hunk should be reworked.

>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), trap_raz_wi },

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
