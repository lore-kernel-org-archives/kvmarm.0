From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 06/18] KVM: ARM64: Add reset and access handlers for
 PMCEID0_EL0 and PMCEID1_EL0 register
Date: Fri, 17 Jul 2015 15:51:07 +0200
Message-ID: <20150717135107.GQ14024@cbox>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
 <1436149068-3784-7-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD0A758C48
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 09:38:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BCU87ujOV3gK for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2015 09:38:54 -0400 (EDT)
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
 [209.85.217.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A800058C42
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 09:38:54 -0400 (EDT)
Received: by lbbyj8 with SMTP id yj8so61630885lbb.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2015 06:50:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1436149068-3784-7-git-send-email-shannon.zhao@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: shannon.zhao@linaro.org
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 06, 2015 at 10:17:36AM +0800, shannon.zhao@linaro.org wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Add reset handler which gets host value of PMCEID0_EL0 or PMCEID1_EL0.
> Add access handler which emulates writing and reading PMCEID0_EL0 or
> PMCEID1_EL0 register.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 69c8c48..1df9ef3 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -246,6 +246,19 @@ static void reset_pmcr_el0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  				       | (ARMV8_PMCR_MASK & 0xdecafbad);
>  }
>  
> +static void reset_pmceid(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> +{
> +	u32 pmceid;
> +
> +	if (r->reg == PMCEID0_EL0) {
> +		asm volatile("mrs %0, pmceid0_el0\n" : "=r" (pmceid));
> +		vcpu_sys_reg(vcpu, r->reg) = pmceid;
> +	} else {

add /* PMCEID1_EL1 */
> +		asm volatile("mrs %0, pmceid1_el0\n" : "=r" (pmceid));
> +		vcpu_sys_reg(vcpu, r->reg) = pmceid;
> +	}
> +}
> +
>  /* PMCR_EL0 accessor. Only called as long as MDCR_EL2.TPMCR is set. */
>  static bool access_pmcr(struct kvm_vcpu *vcpu,
>  			const struct sys_reg_params *p,
> @@ -299,6 +312,25 @@ static bool access_pmselr(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +/* PMCEID0_EL0 and PMCEID1_EL0 accessor. */
> +static bool access_pmceid(struct kvm_vcpu *vcpu,
> +			  const struct sys_reg_params *p,
> +			  const struct sys_reg_desc *r)
> +{
> +	unsigned long val;
> +
> +	if (p->is_write) {
> +		return ignore_write(vcpu, p);
> +	} else {
> +		if (!p->is_aarch32)
> +			val = vcpu_sys_reg(vcpu, r->reg);
> +		else
> +			val = vcpu_cp15(vcpu, r->reg);
> +		*vcpu_reg(vcpu, p->Rt) = val;
> +		return true;
> +	}
> +}
> +
>  /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
>  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
>  	/* DBGBVRn_EL1 */						\
> @@ -508,10 +540,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  access_pmselr, reset_unknown, PMSELR_EL0 },
>  	/* PMCEID0_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b110),
> -	  trap_raz_wi },
> +	  access_pmceid, reset_pmceid, PMCEID0_EL0, },
>  	/* PMCEID1_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b111),
> -	  trap_raz_wi },
> +	  access_pmceid, reset_pmceid, PMCEID1_EL0, },
>  	/* PMCCNTR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b000),
>  	  trap_raz_wi },
> -- 
> 2.1.0
> 
same comment wrt. 32-bit table.

-Christoffer
