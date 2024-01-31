Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23BCE84A45
	for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 15:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706713521; cv=none; b=DIEkhI2OMgzTgJdNB5qYdBNDqXbs3rkXgAXHOGHhZoHs/YOS5WlUhpEohl67zbb5Iz9uzULADGvyHkQhQMwSzmfdkndP31aWSK7TCSGy4gcQ3iBwwV8hsk0fQWANPCuZEehfgHutHL57sPM5QD9dYM8OfOuXyMAlnN9v0BrcIpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706713521; c=relaxed/simple;
	bh=RPn+5TmyBMnSQo+TKTl8fARDecepPVA1vhPC7HNhGV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LEWaRBQzBEqWiRWtt8zJ2UvMFESweTFbYVwF5SlHs/N5Az7VW1mHYwd3f9qfZ2uRht16Nj7gRIOd3Ej0SCzVAMA1M9Cz0w84INlBvC4bEpyBeULbByi2gz4nRkEfat3g0K25Kc4kqjvaZpT9uamgCMpx92Qda8s93bTeAKzO30o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3CC2DA7;
	Wed, 31 Jan 2024 07:06:01 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C9443F762;
	Wed, 31 Jan 2024 07:05:17 -0800 (PST)
Date: Wed, 31 Jan 2024 15:05:15 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 21/25] KVM: arm64: Make TLBI OS/Range UNDEF if not
 advertised to the guest
Message-ID: <20240131150515.GE2284078@e124191.cambridge.arm.com>
References: <20240130204533.693853-1-maz@kernel.org>
 <20240130204533.693853-22-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130204533.693853-22-maz@kernel.org>

On Tue, Jan 30, 2024 at 08:45:28PM +0000, Marc Zyngier wrote:
> Outer Shareable and Range TLBI instructions shouldn't be made available
> to the guest if they are not advertised. Use FGU to disable those,
> and set HCR_EL2.TLBIOS in the case the host doesn't have FGT. Note
> that in that later case, we cannot efficiently disable TLBI Range
> instructions, as this would require to trap all TLBIs.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 39e7c7f74717..f07ee7c89822 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -3948,6 +3948,14 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
>  
>  	mutex_lock(&kvm->arch.config_lock);
>  
> +	/*
> +	 * In the absence of FGT, we cannot independently trap TLBI
> +	 * Range instructions. This isn't great, but trapping all
> +	 * TLBIs would be far worse. Live with it...
> +	 */
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TLB, OS))
> +		vcpu->arch.hcr_el2 |= HCR_TTLBOS;
> +
>  	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
>  		goto out;
>  
> @@ -3960,6 +3968,32 @@ void kvm_init_sysreg(struct kvm_vcpu *vcpu)
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

Commit message update *and* a comment, generous!

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

Thanks,
Joey
