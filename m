Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7123E5EE92
	for <kvmarm@lists.linux.dev>; Tue, 23 Jan 2024 13:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706017743; cv=none; b=u7cpJJEnxFFEC5NlKxT3R8MyKBclnD5UvMDZVSayfGsm8K/cpxC1n7PWqjLPQO/SRpW8HlBSqpoNXgWv+LSXybB3f2twKZ+UhZSppoC3nrhWowPviPqOmcWca/BoCgIrw7PhXfV23Dk6sx3FFdHEnym8QaOCIwlhXIHn1lk2eCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706017743; c=relaxed/simple;
	bh=xsT0XNdnFm+n3ODYXR/JJOrdpKT7UtAhXIBcHk0UIvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ufeQXVQrc5h/8kMKEy0G9r6v9NYe72buhUUl7ebSJizh0RRoXdnLD5nWObUxA6Mm/LhncypiDRQwtgA299R5UUzepSyh374RNkoIRhiGUFGhFTiQVxe4aWg/uKyUhtN59wCOzUwZcFqLJN9MGB25TPKpa++qXO9GI+oFNskAN6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19F701FB;
	Tue, 23 Jan 2024 05:49:46 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6EA503F762;
	Tue, 23 Jan 2024 05:48:59 -0800 (PST)
Date: Tue, 23 Jan 2024 13:48:57 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 03/25] KVM: arm64: nv: Add sanitising to VNCR-backed
 sysregs
Message-ID: <20240123134857.GB1283334@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-4-maz@kernel.org>

Hi,

On Mon, Jan 22, 2024 at 08:18:30PM +0000, Marc Zyngier wrote:
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
>  arch/arm64/include/asm/kvm_host.h | 25 +++++++++++++++++++
>  arch/arm64/kvm/arm.c              |  1 +
>  arch/arm64/kvm/nested.c           | 41 ++++++++++++++++++++++++++++++-
>  3 files changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index c0cf9c5f5e8d..fe35c59214ad 100644
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
> @@ -868,7 +880,20 @@ static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
>  
>  #define ctxt_sys_reg(c,r)	(*__ctxt_sys_reg(c,r))
>  
> +#if defined (__KVM_NVHE_HYPERVISOR__)
>  #define __vcpu_sys_reg(v,r)	(ctxt_sys_reg(&(v)->arch.ctxt, (r)))
> +#else
> +u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *, enum vcpu_sysreg);
> +#define __vcpu_sys_reg(v,r)						\
> +	(*({								\
> +		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;	\
> +		u64 *__r = __ctxt_sys_reg(ctxt, (r));			\
> +		if (unlikely(cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) && \
> +			     r >= __VNCR_START__ && ctxt->vncr_array))	\
> +			*__r = kvm_vcpu_sanitise_vncr_reg((v), (r));	\
> +		__r;							\
> +	}))
> +#endif

Can you not use vcpu_has_nv() here? I see that __ctxt_sys_reg() does a similar
check, but vcpu_has_nv() covers !__KVM_NVHE_HYPERVISOR__, ARM64_HAS_NESTED_VIRT
and KVM_ARM_VCPU_HAS_EL2 (which I guess is what the ctxt->vncr_array check is
doing?) I can see it's defined in kvm_nested.h, which includes kvm_host.h, so
maybe that's an issue.

#define __vcpu_sys_reg(v,r)						\
	(*({								\
		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;	\
		u64 *__r = __ctxt_sys_reg(ctxt, (r));			\
		if (unlikely(vcpu_has_nv(v) && r >= __VNCR_START__))	\
			*__r = kvm_vcpu_sanitise_vncr_reg((v), (r));	\
		__r;							\
	}))

And since vcpu_has_nv() already checks __KVM_NVHE_HYPERVISOR__, you don't need
to define __vcpu_sys_reg() twice.

Also maybe move that derefence into the macro, like: *__r;, instead of being
after the first (.

I'm not sure about the ctxt->vncr_array check, so maybe that's still important.

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

Thanks,
Joey
