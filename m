Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 118C95C908
	for <kvmarm@lists.linux.dev>; Tue, 23 Jan 2024 11:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706010503; cv=none; b=FUPZVH/UJHeuddq+tbfiAGjjvrVwswj2SFqjlxg7wciZOr9NlYSfrXkgzY/dS+ON1OHyvBu4EANNR/rMIUNjLxiGSfdS1HzoKskXwXStxIy/hs1feUXwbpw6lhl/9aaj4NpHvYE+KB2PXhJd4etAC/HOWYW0a5l0VdP5QuPVd7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706010503; c=relaxed/simple;
	bh=MyR0UWGrR9UUIcTGMYu/Cqde/QEggU6wiO+OSEyEu1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=abOBz1Gpu4XcfFWAdDoVCtElC47VbWXUQjBnTA4nkOEhQKxBY5+isuQsLGEmv06eop4U5NCt9/jw65isOHwgbY90zD6ZbGniDcTzIB6eDOk7Y/GaGY2lkjXDLNqQ3w9tvVpuTRo2GpwHY7nC9oW9QrQwo/w7a0oJxsxk1dTFxSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C36F51FB;
	Tue, 23 Jan 2024 03:49:05 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C91C3F762;
	Tue, 23 Jan 2024 03:48:19 -0800 (PST)
Date: Tue, 23 Jan 2024 11:48:10 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 22/25] KVM: arm64: Make PIR{,E0}_EL1 UNDEF if S1PIE is
 not advertised to the guest
Message-ID: <20240123114810.GA1283334@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-23-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-23-maz@kernel.org>

Hello,

On Mon, Jan 22, 2024 at 08:18:49PM +0000, Marc Zyngier wrote:
> As part of the ongoing effort to honor the guest configuration,
> add the necessary checks to make PIR_EL1 and co UNDEF if not
> advertised to the guest, and avoid context switching them.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 15 ++++++++++++++-
>  arch/arm64/kvm/sys_regs.c                  |  4 ++++
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index bb6b571ec627..b34743292ca7 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -37,6 +37,19 @@ static inline bool ctxt_has_mte(struct kvm_cpu_context *ctxt)
>  	return kvm_has_mte(kern_hyp_va(vcpu->kvm));
>  }
>  
> +static inline bool ctxt_has_s1pie(struct kvm_cpu_context *ctxt)
> +{
> +	struct kvm_vcpu *vcpu = ctxt->__hyp_running_vcpu;
> +
> +	if (!cpus_have_final_cap(ARM64_HAS_S1PIE))
> +		return false;
> +
> +	if (!vcpu)
> +		vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);
> +
> +	return kvm_has_feat(kern_hyp_va(vcpu->kvm), ID_AA64MMFR3_EL1, S1PIE, IMP);
> +}
> +
>  static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  {
>  	ctxt_sys_reg(ctxt, SCTLR_EL1)	= read_sysreg_el1(SYS_SCTLR);
> @@ -55,7 +68,7 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>  	ctxt_sys_reg(ctxt, CONTEXTIDR_EL1) = read_sysreg_el1(SYS_CONTEXTIDR);
>  	ctxt_sys_reg(ctxt, AMAIR_EL1)	= read_sysreg_el1(SYS_AMAIR);
>  	ctxt_sys_reg(ctxt, CNTKCTL_EL1)	= read_sysreg_el1(SYS_CNTKCTL);
> -	if (cpus_have_final_cap(ARM64_HAS_S1PIE)) {
> +	if (ctxt_has_s1pie(ctxt)) {
>  		ctxt_sys_reg(ctxt, PIR_EL1)	= read_sysreg_el1(SYS_PIR);
>  		ctxt_sys_reg(ctxt, PIRE0_EL1)	= read_sysreg_el1(SYS_PIRE0);
>  	}

Missing the corresponding change in __sysreg_restore_el1_state().

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3c939ea4a28f..bcde43b81755 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3990,6 +3990,10 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
>  						HFGITR_EL2_TLBIRVAAE1OS	|
>  						HFGITR_EL2_TLBIRVAE1OS);
>  
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
> +		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
> +						HFGxTR_EL2_nPIR_EL1);
> +
>  	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
>  out:
>  	mutex_unlock(&kvm->arch.config_lock);

Thanks,
Joey
