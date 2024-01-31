Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C9637EF1B
	for <kvmarm@lists.linux.dev>; Wed, 31 Jan 2024 17:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706721369; cv=none; b=nVj8YR3mJ6p+0/qgqjSgmnUmITJac8s3vQp95IzHfvNw+BI4VySQcT8Gav414h3wwXVqL3jgW1TK2+6KGYi2DxstMrpaTGaNJZ+AI3XYFzTyL8bogV3FGgWuNuSYUsbmoVdiX4AyYYLSIbYZAzwi8qezcmpzYtUSoHQ0pBf5qhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706721369; c=relaxed/simple;
	bh=VlvVebKdPcF0SjX9lk32KCHgnTy41UmQrMDci2govWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLjVDnBOX0ehyt9lUhYZzNsde89S9PCq5P+FWvT7MXzsFyN1DVBwpE1ACv3yR3T6bHGaANv47z3g3qJ9+19vbBsQ6FD1umlsRXy6TMxEWvd/11IYfrGF/FUnibaRg6E/njl9xm9uY+9bq21fyT+HH0HPv4qjdSO4GFt1lZkFrmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A4528DA7;
	Wed, 31 Jan 2024 09:16:49 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 15E523F762;
	Wed, 31 Jan 2024 09:16:04 -0800 (PST)
Date: Wed, 31 Jan 2024 17:16:02 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 04/25] KVM: arm64: nv: Add sanitising to EL2
 configuration registers
Message-ID: <20240131171602.GF2284078@e124191.cambridge.arm.com>
References: <20240130204533.693853-1-maz@kernel.org>
 <20240130204533.693853-5-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130204533.693853-5-maz@kernel.org>

On Tue, Jan 30, 2024 at 08:45:11PM +0000, Marc Zyngier wrote:
> We can now start making use of our sanitising masks by setting them
> to values that depend on the guest's configuration.
> 
> First up are VTTBR_EL2, VTCR_EL2, VMPIDR_EL2 and HCR_EL2.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 56 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index c976cd4b8379..ee461e630527 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -181,7 +181,7 @@ u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg sr)
>  	return v;
>  }
>  
> -static void __maybe_unused set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
> +static void set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
>  {
>  	int i = sr - __VNCR_START__;
>  
> @@ -191,6 +191,7 @@ static void __maybe_unused set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u
>  
>  int kvm_init_nv_sysregs(struct kvm *kvm)
>  {
> +	u64 res0, res1;
>  	int ret = 0;
>  
>  	mutex_lock(&kvm->arch.config_lock);
> @@ -209,6 +210,59 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
>  		kvm->arch.id_regs[i] = limit_nv_id_reg(IDX_IDREG(i),
>  						       kvm->arch.id_regs[i]);
>  
> +	/* VTTBR_EL2 */
> +	res0 = res1 = 0;
> +	if (!kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16))
> +		res0 |= GENMASK(63, 56);
> +	set_sysreg_masks(kvm, VTTBR_EL2, res0, res1);

CnP?

> +
> +	/* VTCR_EL2 */
> +	res0 = GENMASK(63, 32) | GENMASK(30, 20);
> +	res1 = BIT(31);
> +	set_sysreg_masks(kvm, VTCR_EL2, res0, res1);
> +
> +	/* VMPIDR_EL2 */
> +	res0 = GENMASK(63, 40) | GENMASK(30, 24);
> +	res1 = BIT(31);
> +	set_sysreg_masks(kvm, VMPIDR_EL2, res0, res1);
> +
> +	/* HCR_EL2 */
> +	res0 = BIT(48);
> +	res1 = HCR_RW;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, TWED, IMP))
> +		res0 |= GENMASK(63, 59);
> +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, MTE, MTE2))
> +		res0 |= (HCR_TID5 | HCR_DCT | HCR_ATA);
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, EVT, TTLBxS))
> +		res0 |= (HCR_TTLBIS | HCR_TTLBOS);
> +	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, CSV2, CSV2_2) &&
> +	    !kvm_has_feat(kvm, ID_AA64PFR1_EL1, CSV2_frac, CSV2_1p2))
> +		res1 = HCR_ENSCXT;

I'm confused here. If the VM doesn't have either CSV2_2 or CSV2_1p2.. HCR_ENSCXT is res1, that means we wouldn't trap?

The Arm ARM says:

	EnSCXT, bit [53]
		When FEAT_CSV2_2 is implemented or FEAT_CSV2_1p2 is implemented:

			[..]

		Otherwise:
			RES0

And if you actually meant res1, then you need: res1 |= HCR_ENSCXT, otherwise you override the HCR_RW res1 bit!

> +	if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, EVT, IMP))
> +		res0 |= (HCR_TID4 | HCR_TICAB | HCR_TOCU);

minor nitpick: can you reverse these TOCU | TICAB | TID4 so it matches the relative positions in the register..

> +	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, V1P1))
> +		res0 |= HCR_AMVOFFEN;

We currently mask out ID_AA64PFR0_EL1.AMU (read_sanitised_id_aa64pfr0_el1 and
part of the .val in the sys_regs_desc[]), can't hurt to be feature proof.

> +	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, V1P1))
> +		res0 |= HCR_FIEN;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, FWB, IMP))
> +		res0 |= HCR_FWB;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, NV, NV2))
> +		res0 |= HCR_NV2;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, NV, IMP))
> +		res0 |= (HCR_AT | HCR_NV1 | HCR_NV);
> +	if (!(__vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_ADDRESS) &&
> +	      __vcpu_has_feature(&kvm->arch, KVM_ARM_VCPU_PTRAUTH_ADDRESS)))
> +		res0 |= (HCR_API | HCR_APK);
> +	if (!kvm_has_feat(kvm, ID_AA64ISAR0_EL1, TME, IMP))
> +		res0 |= BIT(39);
> +	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP))
> +		res0 |= (HCR_TERR | HCR_TEA);

Same annoying nitpick, flip the values order to match the positions.

> +	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, LO, IMP))
> +		res0 |= HCR_TLOR;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, IMP))
> +		res1 |= HCR_E2H;
> +	set_sysreg_masks(kvm, HCR_EL2, res0, res1);
> +
>  out:
>  	mutex_unlock(&kvm->arch.config_lock);
>  

I need a lie down now.

Thanks,
Joey
