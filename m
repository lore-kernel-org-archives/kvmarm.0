Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A299D5B670
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 14:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706799374; cv=none; b=Z2CZRZO7mtyvVJglN4mEtXq1HpN5hdQnrytlaagku+2udc1EBB8+9VqrvbqFulQQQ10jrLNjM2csT1/jo+RAI4P+oFDA3n9d4dzvUXVoPa9e20AzPrI4PMuUV/kGE1fAwxEt02/wjJVkmWO1Jt9a+yHNJNYqivVer6rOLdSIwTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706799374; c=relaxed/simple;
	bh=ZLCduID2/j7D+zjrlCVL2fhGLgA8sn8xXW5rtCJVfsk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MTLa6ffzvT/OocG4mnbYao51qt0eQdnFMnBLAm5Ai4NqYS+62WRVEIKeg0l2I2/0xil95dfmO295Cg5ro+V7DAv+7Qr9J8xJOwjr/U3D8dYtZL0Xt9lnpNZxRwdxV7iThvfstY2M2R3ULcjSFQcUEx4uS2lpmm/cRvGrF15r5To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6EB92DA7;
	Thu,  1 Feb 2024 06:56:53 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F2533F738;
	Thu,  1 Feb 2024 06:56:09 -0800 (PST)
Date: Thu, 1 Feb 2024 14:56:07 +0000
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
Message-ID: <20240201145607.GH2284078@e124191.cambridge.arm.com>
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

Just want to clarify this bit actually, this is restricting the (first level
only?) nested EL1 to run as AArch64?
Should we be sanitising ID_AA64PFR0_EL1.EL1=0b0001?

> +	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, TWED, IMP))
> +		res0 |= GENMASK(63, 59);
> +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, MTE, MTE2))
> +		res0 |= (HCR_TID5 | HCR_DCT | HCR_ATA);
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, EVT, TTLBxS))
> +		res0 |= (HCR_TTLBIS | HCR_TTLBOS);
> +	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, CSV2, CSV2_2) &&
> +	    !kvm_has_feat(kvm, ID_AA64PFR1_EL1, CSV2_frac, CSV2_1p2))
> +		res1 = HCR_ENSCXT;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, EVT, IMP))
> +		res0 |= (HCR_TID4 | HCR_TICAB | HCR_TOCU);
> +	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, V1P1))
> +		res0 |= HCR_AMVOFFEN;
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
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, LO, IMP))
> +		res0 |= HCR_TLOR;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR4_EL1, E2H0, IMP))
> +		res1 |= HCR_E2H;
> +	set_sysreg_masks(kvm, HCR_EL2, res0, res1);
> +
>  out:
>  	mutex_unlock(&kvm->arch.config_lock);
>  

Thanks,
Joey
