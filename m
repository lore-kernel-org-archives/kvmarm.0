Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8F0612A14E
	for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 14:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706712738; cv=none; b=msnIreN4rRyYAux933Op67RZdTO1+ojMy7RDmjxs1qkCZhM6Ke0xCv339l7EMsTjAKFmoHebdXt41Yi4Y6XfaXo+1xBDlQ6MRiYwiWajawPg6toRiN3UrnwC4N4t6HOG8NwuDOHxYtJLIFTVZr0M1zfWVTgbWiUhNrP90+Rpx08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706712738; c=relaxed/simple;
	bh=vDnoPMhwCSUoFYOLaPXqb/Xq8w03zNThQFN3HZYt7YI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WbRMod0EXntcVaQuLblvHSU/yIl2XS8MdMewvH7O1eEyCNnZ+zCF4H0wfe6ZrfeWoSyBvubWiGQy8C9JL4KZMfC7gE7+kbI/4aGrb7SXMDrAzT1OIG7BPI2cOmetezQB1kYDHHzWp/4C7x8DmsD1szdRtmBzOLYmuC5BN+HEl0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABCF6DA7;
	Wed, 31 Jan 2024 06:52:58 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 169223F762;
	Wed, 31 Jan 2024 06:52:13 -0800 (PST)
Date: Wed, 31 Jan 2024 14:52:11 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 03/25] KVM: arm64: nv: Add sanitising to VNCR-backed
 sysregs
Message-ID: <20240131145211.GB2284078@e124191.cambridge.arm.com>
References: <20240130204533.693853-1-maz@kernel.org>
 <20240130204533.693853-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130204533.693853-4-maz@kernel.org>

Hello,

On Tue, Jan 30, 2024 at 08:45:10PM +0000, Marc Zyngier wrote:
> VNCR-backed "registers" are actually only memory. Which means that
> there is zero control over what the guest can write, and that it
> is the hypervisor's job to actually sanitise the content of the
> backing store. Yeah, this is fun.
> 
> In order to preserve some form of sanity, add a repainting mechanism
> that makes use of a per-VM set of RES0/RES1 masks, one pair per VNCR
> register. These masks get applied on access to the backing store via
> __vcpu_sys_reg(), ensuring that the state that is consumed by KVM is
> correct.
> 
> So far, nothing populates these masks, but stay tuned.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 22 ++++++++++++++++-
>  arch/arm64/kvm/arm.c              |  1 +
>  arch/arm64/kvm/nested.c           | 41 ++++++++++++++++++++++++++++++-
>  3 files changed, 62 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c0cf9c5f5e8d..816288e2d735 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -238,6 +238,8 @@ static inline u16 kvm_mpidr_index(struct kvm_mpidr_data *data, u64 mpidr)
>  	return index;
>  }
>  
> +struct kvm_sysreg_masks;
> +
>  struct kvm_arch {
>  	struct kvm_s2_mmu mmu;
>  
> @@ -312,6 +314,9 @@ struct kvm_arch {
>  #define KVM_ARM_ID_REG_NUM	(IDREG_IDX(sys_reg(3, 0, 0, 7, 7)) + 1)
>  	u64 id_regs[KVM_ARM_ID_REG_NUM];
>  
> +	/* Masks for VNCR-baked sysregs */
> +	struct kvm_sysreg_masks	*sysreg_masks;
> +
>  	/*
>  	 * For an untrusted host VM, 'pkvm.handle' is used to lookup
>  	 * the associated pKVM instance in the hypervisor.
> @@ -474,6 +479,13 @@ enum vcpu_sysreg {
>  	NR_SYS_REGS	/* Nothing after this line! */
>  };
>  
> +struct kvm_sysreg_masks {
> +	struct {
> +		u64	res0;
> +		u64	res1;
> +	} mask[NR_SYS_REGS - __VNCR_START__];
> +};
> +
>  struct kvm_cpu_context {
>  	struct user_pt_regs regs;	/* sp = sp_el0 */
>  
> @@ -868,7 +880,15 @@ static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
>  
>  #define ctxt_sys_reg(c,r)	(*__ctxt_sys_reg(c,r))
>  
> -#define __vcpu_sys_reg(v,r)	(ctxt_sys_reg(&(v)->arch.ctxt, (r)))
> +u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *, enum vcpu_sysreg);
> +#define __vcpu_sys_reg(v,r)						\
> +	(*({								\
> +		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;	\
> +		u64 *__r = __ctxt_sys_reg(ctxt, (r));			\
> +		if (vcpu_has_nv((v)) && (r) >= __VNCR_START__)		\
> +			*__r = kvm_vcpu_sanitise_vncr_reg((v), (r));	\
> +		__r;							\
> +	}))
>  
>  u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg);
>  void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg);
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index a25265aca432..c063e84fc72c 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -206,6 +206,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  		pkvm_destroy_hyp_vm(kvm);
>  
>  	kfree(kvm->arch.mpidr_data);
> +	kfree(kvm->arch.sysreg_masks);
>  	kvm_destroy_vcpus(kvm);
>  
>  	kvm_unshare_hyp(kvm, kvm + 1);
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index d55e809e26cb..c976cd4b8379 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -163,15 +163,54 @@ static u64 limit_nv_id_reg(u32 id, u64 val)
>  
>  	return val;
>  }
> +
> +u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg sr)
> +{
> +	u64 v = ctxt_sys_reg(&vcpu->arch.ctxt, sr);
> +	struct kvm_sysreg_masks *masks;
> +
> +	masks = vcpu->kvm->arch.sysreg_masks;
> +
> +	if (masks) {
> +		sr -= __VNCR_START__;
> +
> +		v &= ~masks->mask[sr].res0;
> +		v |= masks->mask[sr].res1;
> +	}
> +
> +	return v;
> +}
> +
> +static void __maybe_unused set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
> +{
> +	int i = sr - __VNCR_START__;
> +
> +	kvm->arch.sysreg_masks->mask[i].res0 = res0;
> +	kvm->arch.sysreg_masks->mask[i].res1 = res1;
> +}
> +
>  int kvm_init_nv_sysregs(struct kvm *kvm)
>  {
> +	int ret = 0;
> +
>  	mutex_lock(&kvm->arch.config_lock);
>  
> +	if (kvm->arch.sysreg_masks)
> +		goto out;
> +
> +	kvm->arch.sysreg_masks = kzalloc(sizeof(*(kvm->arch.sysreg_masks)),
> +					 GFP_KERNEL);
> +	if (!kvm->arch.sysreg_masks) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
>  	for (int i = 0; i < KVM_ARM_ID_REG_NUM; i++)
>  		kvm->arch.id_regs[i] = limit_nv_id_reg(IDX_IDREG(i),
>  						       kvm->arch.id_regs[i]);
>  
> +out:
>  	mutex_unlock(&kvm->arch.config_lock);
>  
> -	return 0;
> +	return ret;
>  }

Used suggestion from v1 to use vcpu_has_nv()/collapse macros.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
