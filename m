From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 14/18] KVM: ARM64: Add reset and access handlers for
 PMUSERENR_EL0 register
Date: Fri, 17 Jul 2015 17:01:53 +0200
Message-ID: <20150717150153.GX14024@cbox>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
 <1436149068-3784-15-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436149068-3784-15-git-send-email-shannon.zhao@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: shannon.zhao@linaro.org
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, marc.zyngier@arm.com, alex.bennee@linaro.org, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 06, 2015 at 10:17:44AM +0800, shannon.zhao@linaro.org wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Since the reset value of PMUSERENR_EL0 is UNKNOWN, use reset_unknown for
> its reset handler. Add access handler which emulates writing and reading
> PMUSERENR_EL0 register.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 15 ++++++++++++++-
>  include/kvm/arm_pmu.h     |  1 +
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ec80937..d5984d0 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -522,6 +522,19 @@ static bool access_pmovsclr(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +/* PMUSERENR_EL0 accessor. */
> +static bool access_pmuserenr(struct kvm_vcpu *vcpu,
> +			     const struct sys_reg_params *p,
> +			     const struct sys_reg_desc *r)
> +{
> +	if (p->is_write)
> +		vcpu->arch.pmu.user_enable |= *vcpu_reg(vcpu, p->Rt);
> +	else
> +		*vcpu_reg(vcpu, p->Rt) = vcpu->arch.pmu.user_enable;
> +
> +	return true;
> +}
> +
>  /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
>  #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
>  	/* DBGBVRn_EL1 */						\
> @@ -746,7 +759,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  access_pmxevcntr, reset_unknown, PMXEVCNTR_EL0 },
>  	/* PMUSERENR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b000),
> -	  trap_raz_wi },
> +	  access_pmuserenr, reset_unknown, PMUSERENR_EL0 },
>  	/* PMOVSSET_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b011),
>  	  access_pmovsset, reset_unknown, PMOVSSET_EL0 },
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index dee8356..4f3d8a6 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -39,6 +39,7 @@ struct kvm_pmu {
>  	/* IRQ pending flag */
>  	bool irq_pending;
>  	struct irq_work irq_work;
> +	u32 user_enable;

why not store this in PMUSERENR_EL0 and get VM migration of this state
included for free?

Also, I assume the functionality to respect these flags are implemented
in a later patch or simply not supported?  It would have been good to
note this in the cover letter.

-Christoffer

>  	struct kvm_pmc pmc[ARMV8_MAX_COUNTERS];
>  #endif
>  };
> -- 
> 2.1.0
> 
