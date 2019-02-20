From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v5 12/26] KVM: arm64: Support runtime sysreg visibility
 filtering
Date: Wed, 20 Feb 2019 14:33:44 +0000
Message-ID: <2819c91f-3a28-b878-0ea1-d20afcf05895@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-13-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8378E4A2E4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Feb 2019 09:33:53 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jHm3FNfcO-0P for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Feb 2019 09:33:52 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B2F14A2AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Feb 2019 09:33:52 -0500 (EST)
In-Reply-To: <1550519559-15915-13-git-send-email-Dave.Martin@arm.com>
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
To: Dave Martin <Dave.Martin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 18/02/2019 19:52, Dave Martin wrote:
> Some optional features of the Arm architecture add new system
> registers that are not present in the base architecture.
> 
> Where these features are optional for the guest, the visibility of
> these registers may need to depend on some runtime configuration,
> such as a flag passed to KVM_ARM_VCPU_INIT.
> 
> For example, ZCR_EL1 and ID_AA64ZFR0_EL1 need to be hidden if SVE
> is not enabled for the guest, even though these registers may be
> present in the hardware and visible to the host at EL2.
> 
> Adding special-case checks all over the place for individual
> registers is going to get messy as the number of conditionally-
> visible registers grows.
> 
> In order to help solve this problem, this patch adds a new sysreg
> method restrictions() that can be used to hook in any needed
> runtime visibility checks.  This method can currently return
> REG_NO_USER to inhibit enumeration and ioctl access to the register
> for userspace, and REG_NO_GUEST to inhibit runtime access by the
> guest using MSR/MRS.
> 
> This allows a conditionally modified view of individual system
> registers such as the CPU ID registers, in addition to completely
> hiding register where appropriate.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>

Reviewed-by: Julien Thierry <julien.thierry@arm.com>

> 
> ---
> 
> Changes since v4:
> 
>  * Move from a boolean sysreg property that just suppresses register
>    enumeration via KVM_GET_REG_LIST, to a multi-flag property that
>    allows independent runtime control of MRS/MSR and user ioctl access.
> 
>    This allows registers to be either hidden completely, or to have
>    hybrid behaviours (such as the not-enumerated, RAZ, WAZ behaviour of
>    "non-present" CPU ID regs).
> ---
>  arch/arm64/kvm/sys_regs.c | 24 +++++++++++++++++++++---
>  arch/arm64/kvm/sys_regs.h | 13 +++++++++++++
>  2 files changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 71c5825..3f1243e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1863,6 +1863,12 @@ static void perform_access(struct kvm_vcpu *vcpu,
>  {
>  	trace_kvm_sys_access(*vcpu_pc(vcpu), params, r);
>  
> +	/* Check for regs disabled by runtime config */
> +	if (restrictions(vcpu, r) & REG_NO_GUEST) {
> +		kvm_inject_undefined(vcpu);
> +		return;
> +	}
> +
>  	/*
>  	 * Not having an accessor means that we have configured a trap
>  	 * that we don't know how to handle. This certainly qualifies
> @@ -2370,6 +2376,10 @@ int kvm_arm_sys_reg_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>  	if (!r)
>  		return get_invariant_sys_reg(reg->id, uaddr);
>  
> +	/* Check for regs disabled by runtime config */
> +	if (restrictions(vcpu, r) & REG_NO_USER)
> +		return -ENOENT;
> +
>  	if (r->get_user)
>  		return (r->get_user)(vcpu, r, reg, uaddr);
>  
> @@ -2391,6 +2401,10 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>  	if (!r)
>  		return set_invariant_sys_reg(reg->id, uaddr);
>  
> +	/* Check for regs disabled by runtime config */
> +	if (restrictions(vcpu, r) & REG_NO_USER)
> +		return -ENOENT;
> +
>  	if (r->set_user)
>  		return (r->set_user)(vcpu, r, reg, uaddr);
>  
> @@ -2447,7 +2461,8 @@ static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
>  	return true;
>  }
>  
> -static int walk_one_sys_reg(const struct sys_reg_desc *rd,
> +static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
> +			    const struct sys_reg_desc *rd,
>  			    u64 __user **uind,
>  			    unsigned int *total)
>  {
> @@ -2458,6 +2473,9 @@ static int walk_one_sys_reg(const struct sys_reg_desc *rd,
>  	if (!(rd->reg || rd->get_user))
>  		return 0;
>  
> +	if (restrictions(vcpu, rd) & REG_NO_USER)
> +		return 0;
> +
>  	if (!copy_reg_to_user(rd, uind))
>  		return -EFAULT;
>  
> @@ -2486,9 +2504,9 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
>  		int cmp = cmp_sys_reg(i1, i2);
>  		/* target-specific overrides generic entry. */
>  		if (cmp <= 0)
> -			err = walk_one_sys_reg(i1, &uind, &total);
> +			err = walk_one_sys_reg(vcpu, i1, &uind, &total);
>  		else
> -			err = walk_one_sys_reg(i2, &uind, &total);
> +			err = walk_one_sys_reg(vcpu, i2, &uind, &total);
>  
>  		if (err)
>  			return err;
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index 174ffc0..12f196f 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -69,8 +69,15 @@ struct sys_reg_desc {
>  			const struct kvm_one_reg *reg, void __user *uaddr);
>  	int (*set_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  			const struct kvm_one_reg *reg, void __user *uaddr);
> +
> +	/* Return mask of REG_* runtime restriction flags */
> +	unsigned int (*restrictions)(const struct kvm_vcpu *vcpu,
> +				     const struct sys_reg_desc *rd);
>  };
>  
> +#define REG_NO_USER	(1 << 0) /* hidden from userspace ioctl interface */
> +#define REG_NO_GUEST	(1 << 1) /* hidden from guest */
> +
>  static inline void print_sys_reg_instr(const struct sys_reg_params *p)
>  {
>  	/* Look, we even formatted it for you to paste into the table! */
> @@ -109,6 +116,12 @@ static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r
>  	__vcpu_sys_reg(vcpu, r->reg) = r->val;
>  }
>  
> +static inline unsigned int restrictions(const struct kvm_vcpu *vcpu,
> +					const struct sys_reg_desc *r)
> +{
> +	return unlikely(r->restrictions) ? r->restrictions(vcpu, r) : 0;
> +}
> +
>  static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
>  			      const struct sys_reg_desc *i2)
>  {
> 

-- 
Julien Thierry
