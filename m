From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7 11/19] KVM: ARM64: Add access handler for PMINTENSET
 and PMINTENCLR register
Date: Tue, 15 Dec 2015 14:02:40 +0000
Message-ID: <56701D80.9010302@arm.com>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
 <1450169379-12336-12-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 714A841252
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 09:00:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fGPXkP4gttO0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Dec 2015 09:00:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D539411F6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 09:00:27 -0500 (EST)
In-Reply-To: <1450169379-12336-12-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 15/12/15 08:49, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Since the reset value of PMINTENSET and PMINTENCLR is UNKNOWN, use
> reset_unknown for its reset handler. Add a handler to emulate writing
> PMINTENSET or PMINTENCLR register.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index f216da7..594e53f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -648,6 +648,27 @@ static bool access_pmcntenset(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	return true;
>  }
>  
> +static bool access_pmintenset(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			      const struct sys_reg_desc *r)
> +{
> +	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
> +
> +	if (p->is_write) {
> +		if (r->Op2 & 0x1) {
> +			/* accessing PMINTENSET_EL1 */
> +			vcpu_sys_reg(vcpu, r->reg) |= (p->regval & mask);
> +		} else {
> +			/* accessing PMINTENCLR_EL1 */
> +			vcpu_sys_reg(vcpu, r->reg) &= mask;
> +			vcpu_sys_reg(vcpu, r->reg) &= ~p->regval;

This looks wrong. The first line doesn't have any effect (you shouldn't
be able to set bits that are not in the mask the first place). I'd
prefer something like:

		vcpu_sys_reg(vcpu, r->reg) &= ~(p->regval & mask);

which is symmetrical to the SET operator.

> +		}
> +	} else {
> +		p->regval = vcpu_sys_reg(vcpu, r->reg) & mask;
> +	}
> +
> +	return true;
> +}
> +
>  /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
>  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
>  	/* DBGBVRn_EL1 */						\
> @@ -806,10 +827,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  
>  	/* PMINTENSET_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b1001), CRm(0b1110), Op2(0b001),
> -	  trap_raz_wi },
> +	  access_pmintenset, reset_unknown, PMINTENSET_EL1 },
>  	/* PMINTENCLR_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b1001), CRm(0b1110), Op2(0b010),
> -	  trap_raz_wi },
> +	  access_pmintenset, NULL, PMINTENSET_EL1 },
>  
>  	/* MAIR_EL1 */
>  	{ Op0(0b11), Op1(0b000), CRn(0b1010), CRm(0b0010), Op2(0b000),
> @@ -1204,8 +1225,8 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_evtyper },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_evcntr },
>  	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), trap_raz_wi },
> -	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), trap_raz_wi },
> -	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), trap_raz_wi },
> +	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), access_pmintenset },
> +	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pmintenset },
>  
>  	{ Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, c10_PRRR },
>  	{ Op1( 0), CRn(10), CRm( 2), Op2( 1), access_vm_reg, NULL, c10_NMRR },
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
