From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v5 19/26] KVM: arm64: Enumerate SVE register indices for
 KVM_GET_REG_LIST
Date: Thu, 21 Feb 2019 16:28:11 +0000
Message-ID: <2b50c4cd-d729-4109-9e90-66a2a7b94cf9@arm.com>
References: <1550519559-15915-1-git-send-email-Dave.Martin@arm.com>
 <1550519559-15915-20-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 99D894A380
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Feb 2019 11:28:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WW3huASxegz3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Feb 2019 11:28:19 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 261ED4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Feb 2019 11:28:19 -0500 (EST)
In-Reply-To: <1550519559-15915-20-git-send-email-Dave.Martin@arm.com>
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
> This patch includes the SVE register IDs in the list returned by
> KVM_GET_REG_LIST, as appropriate.
> 
> On a non-SVE-enabled vcpu, no new IDs are added.
> 
> On an SVE-enabled vcpu, IDs for the FPSIMD V-registers are removed
> from the list, since userspace is required to access the Z-
> registers instead to access their context.  For the variably-sized
> SVE registers, the appropriate set of slice IDs are enumerated,
> depending on the maximum vector length for the vcpu.
> 
> Signed-off-by: Dave Martin <Dave.Martin@arm.com>

Reviewed-by: Julien Thierry <julien.thiery@arm.com>

> 
> ---
> 
> Changes since v4:
> 
>  * Drop KVM_SVE_SLICES(), which is no longer used due to the dropping of
>    register multi-slice support from the series.
> 
>  * Drop register multi-slice support.
> ---
>  arch/arm64/kvm/guest.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 8cfa889..4a2ad60 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -366,6 +366,14 @@ static int copy_core_reg_indices(const struct kvm_vcpu *vcpu,
>  			continue;
>  		}
>  
> +		/*
> +		 * The KVM_REG_ARM64_SVE regs must be used instead of
> +		 * KVM_REG_ARM_CORE for accessing the FPSIMD V-registers on
> +		 * SVE-enabled vcpus:
> +		 */
> +		if (vcpu_has_sve(vcpu) && core_reg_offset_is_vreg(i))
> +			continue;
> +
>  		if (uind) {
>  			if (put_user(reg, *uind))
>  				return -EFAULT;
> @@ -436,6 +444,44 @@ static int get_timer_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	return copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)) ? -EFAULT : 0;
>  }
>  
> +static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
> +{
> +	/* Only the first slice ever exists, for now */
> +	const unsigned int slices = 1;
> +
> +	if (!vcpu_has_sve(vcpu))
> +		return 0;
> +
> +	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */);
> +}
> +
> +static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu, u64 __user **uind)
> +{
> +	/* Only the first slice ever exists, for now */
> +	const unsigned int slices = 1;
> +	unsigned int i, n;
> +
> +	if (!vcpu_has_sve(vcpu))
> +		return 0;
> +
> +	for (i = 0; i < slices; i++) {
> +		for (n = 0; n < SVE_NUM_ZREGS; n++) {
> +			if (put_user(KVM_REG_ARM64_SVE_ZREG(n, i), (*uind)++))
> +				return -EFAULT;
> +		}
> +
> +		for (n = 0; n < SVE_NUM_PREGS; n++) {
> +			if (put_user(KVM_REG_ARM64_SVE_PREG(n, i), (*uind)++))
> +				return -EFAULT;
> +		}
> +
> +		if (put_user(KVM_REG_ARM64_SVE_FFR(i), (*uind)++))
> +			return -EFAULT;
> +	}
> +
> +	return 0;
> +}
> +
>  /**
>   * kvm_arm_num_regs - how many registers do we present via KVM_GET_ONE_REG
>   *
> @@ -446,6 +492,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
>  	unsigned long res = 0;
>  
>  	res += num_core_regs(vcpu);
> +	res += num_sve_regs(vcpu);
>  	res += kvm_arm_num_sys_reg_descs(vcpu);
>  	res += kvm_arm_get_fw_num_regs(vcpu);
>  	res += NUM_TIMER_REGS;
> @@ -466,6 +513,10 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>  	if (ret < 0)
>  		return ret;
>  
> +	ret = copy_sve_reg_indices(vcpu, &uindices);
> +	if (ret)
> +		return ret;
> +
>  	ret = kvm_arm_copy_fw_reg_indices(vcpu, uindices);
>  	if (ret)
>  		return ret;
> 

-- 
Julien Thierry
