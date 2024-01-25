Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9844C51001
	for <kvmarm@lists.linux.dev>; Thu, 25 Jan 2024 13:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706189453; cv=none; b=IM97kwacy/Aqqa474Cinygvo0YKDUivNVxAsElWuJ/XHkjbGHaAsmbi3lJQEypE+4xR0543PSDEX9eX+93JGVAjqubsc1QOJuZf85/YGFGogjUAuqB6RgIaRO0/luVyA9T2I7XVeFhXc66L57mbC21zrdDI8Pzx3qHIvDtA+DVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706189453; c=relaxed/simple;
	bh=oV6ygTLBYKMaWOfWcDorYF4Z6RcphDpNEfJG4Gywya4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kig0ms2gXEnkmbKB3Ak4xoS+unNbaJOwGEBiYCr1mRCjZCVXqUC1MKlqaCENuixDfEKbalDEJUSk0aOnryxMWp5g5B9qcY+1B8E+Dhed7b9uxcATe+MPVzziBgYs3UcXZXv1S+oy1kDG7A+NVjpwvfqpDDnslyZr3brE6gOf0lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34D741FB;
	Thu, 25 Jan 2024 05:31:35 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 62FDC3F5A1;
	Thu, 25 Jan 2024 05:30:49 -0800 (PST)
Date: Thu, 25 Jan 2024 13:30:47 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 21/25] KVM: arm64: Make TLBI OS/Range UNDEF if not
 advertised to the guest
Message-ID: <20240125133047.GD1535978@e124191.cambridge.arm.com>
References: <20240122201852.262057-1-maz@kernel.org>
 <20240122201852.262057-22-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240122201852.262057-22-maz@kernel.org>

Question,

On Mon, Jan 22, 2024 at 08:18:48PM +0000, Marc Zyngier wrote:
> Outer Shareable and Range TLBI instructions shouldn't be made available
> to the guest if they are not advertised. Use FGU to disable those,
> and set HCR_EL2.TLBIOS in the case the host doesn't have FGT.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index a62efd8a2959..3c939ea4a28f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3949,6 +3949,9 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
>  
>  	mutex_lock(&kvm->arch.config_lock);
>  
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
> +		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
> +
>  	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
>  		goto out;
>  
> @@ -3961,6 +3964,32 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
>  				       HFGxTR_EL2_nSMPRI_EL1_MASK	|
>  				       HFGxTR_EL2_nTPIDR2_EL0_MASK);
>  
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
> +		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_TLBIRVAALE1OS|
> +						HFGITR_EL2_TLBIRVALE1OS	|
> +						HFGITR_EL2_TLBIRVAAE1OS	|
> +						HFGITR_EL2_TLBIRVAE1OS	|
> +						HFGITR_EL2_TLBIVAALE1OS	|
> +						HFGITR_EL2_TLBIVALE1OS	|
> +						HFGITR_EL2_TLBIVAAE1OS	|
> +						HFGITR_EL2_TLBIASIDE1OS	|
> +						HFGITR_EL2_TLBIVAE1OS	|
> +						HFGITR_EL2_TLBIVMALLE1OS);
> +
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, RANGE))
> +		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_TLBIRVAALE1	|
> +						HFGITR_EL2_TLBIRVALE1	|
> +						HFGITR_EL2_TLBIRVAAE1	|
> +						HFGITR_EL2_TLBIRVAE1	|
> +						HFGITR_EL2_TLBIRVAALE1IS|
> +						HFGITR_EL2_TLBIRVALE1IS	|
> +						HFGITR_EL2_TLBIRVAAE1IS	|
> +						HFGITR_EL2_TLBIRVAE1IS	|
> +						HFGITR_EL2_TLBIRVAALE1OS|
> +						HFGITR_EL2_TLBIRVALE1OS	|
> +						HFGITR_EL2_TLBIRVAAE1OS	|
> +						HFGITR_EL2_TLBIRVAE1OS);
> +
>  	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
>  out:
>  	mutex_unlock(&kvm->arch.config_lock);

I think I'm right in saying..

If the VM is running on a platform with ID_AA64ISAR0_EL1.TLB=0b010 (Outer
Shareable and TLB range maintenance instructions are implemented.) but without
support for FEAT_FGT, and the VMM sets the ID reg to ID_AA64ISAR0_EL1.TLB=0,
this change will trap the TLBI *OS instructions but not the following: 

    TLBI RVAAE1
    TLBI RVAAE1IS
    TLBI RVAALE1
    TLBI RVAALE1IS
    TLBI RVAE1
    TLBI RVAE1IS
    TLBI RVALE1
    TLBI RVALE1IS

These TLB range instructions only trap with HCR_EL2.TTLB, however that traps
all TLB instructions. You may have left this off intentionally, if so can you
add something to the commit message.

Thanks,
Joey
