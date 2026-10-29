Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793296078;
	b=3R24snbcyxWx6Ij8kPK/e1ZTwBOuf+UD38NmF5xn3W7ML8hosBNFulusL2hg9tZkfwYG
	 LFOdbSiatoarU9wcKf7c47V4n0Vkly/wKqgucGeVTBMamfvivaCuCvV5T8HwFNeWEQEo+
	 CtBlBfdvFbHYKjDwEP9FEDYMPGsUdiBYxhBW4/Pg7Ei4peb/0KSBAWM7dSfIchUbTbXdZ
	 OOxI55leVAgdxwucozMTAwel8aXV79FGQaGfv0o3rLP0ZaqxVJlVv9+e8T5dRAzzrfcSc
	 iiyqbrH7Rp3ZdZY/uMgQzlNsAtlYDrcLVjLmwes/4NIS0F0aQti/bDCYxLG54MzJvJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793296078;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=C1qVyaNAsqSgFRygYkb470TRs5P9I5eHBZ1RH/YvP80=;
	b=Dg9t5fIaKIwwIUD5RV55hEavy2nJD41WYyIO+NoSSneIBUpMKvPbH/FXHcJrZbhB7M1N
	 7oTP8KXTYM+RETLAlWrh7+VAwxsR+stShgYwXIUo9dXOaMb5wHzNNo2ibL1SiEJC8zznu
	 CgQlHtkZWI245nwtRXqWYdqFcfyJ+u21p+d5+BdHpsDFTVcILlxYBZECx2xhukCz4cuLp
	 V5+s+eF3Oq4x0aqlsGVy7lISi7WR46kOMF6sNc5CxEtzd4HxbK/YknjazPws9+E87yuBJ
	 3z+DBbPp1qBbo2Kjg787WFOJhCk5Vwh9NJ3W31B+TAIovYEFRI2sdfW7MxcvkPX6Pgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BvIzDU88;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B23606A31A;
	Thu, 29 Oct 2026 17:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BvIzDU88
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D3F1F01824;
	Thu, 29 Oct 2026 17:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793296078;
	bh=C1qVyaNAsqSgFRygYkb470TRs5P9I5eHBZ1RH/YvP80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BvIzDU88haRFrjaB++4TIsTwsVPuSqyVnjza8CGYJg9xF1YgdDFo7r07B9J5ucUnr
	 MVRDEd9aloSA/hwWIauZ/kHAJesCuCJoSljiUZKwddOfOMgK8ijk5hwMhLNUul3DFY
	 vB5a1qIEtaLfewyE04hEi1WSiV4tNaVShlu1wRvWCRVDK+4B32o+flVsb9N8geCt/I
	 XJyqYmqOL5n3Ey58r8SRTdgbLB4l/2vccEjUy2g28bbdrIt66VnX3hzksSgvaNaaK1
	 qmzwXuujBtJzbWbseYmcz6miy9LYwj3S23pMd77suWmt7SrN8didHiIhVPgjHqOPeQ
	 HFx4VxtsMrwpQ==
Date: Thu, 29 Oct 2026 17:47:52 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 18/28] KVM: arm64: config: Use functions from
 spe.c to test FEAT_SPE_{FnE,FDS}
Message-ID: <auOBFeXOmUYNHeAV@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-19-alexandru.elisei@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-19-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:06:13PM +0100, Alexandru Elisei wrote:
> KVM's FGU mechanism will trap the registers introduced by FEAT_SPE_FnE and
> FEAT_SPE_FDS if the feature is not present for the VM. Move the functions
> that check for the presence of these features out of config.c and into
> spe.c, since that's where the bulk of SPE virtualization lies.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Aside from naming nit below, LGTM and:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/arm64/include/asm/kvm_spe.h | 11 +++++++++++
>  arch/arm64/kvm/config.c          | 30 +++++-------------------------
>  arch/arm64/kvm/spe.c             | 22 ++++++++++++++++++++++
>  3 files changed, 38 insertions(+), 25 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_spe.h b/arch/arm64/include/asm/kvm_spe.h
> index 3d8e9720daca..618051dcf59f 100644
> --- a/arch/arm64/include/asm/kvm_spe.h
> +++ b/arch/arm64/include/asm/kvm_spe.h
> @@ -43,6 +43,9 @@ u8 kvm_spe_get_pmsver(struct kvm *kvm);
>
>  bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val);
>  u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg);
> +
> +bool kvm_spe_has_feat_spe_fne(struct kvm *kvm);
> +bool kvm_spe_has_feat_spe_fds(struct kvm *kvm);

These both say spe twice, can probably cut the 2nd one in each case I think
:) Could you drop the 'feat' too, kvm_spe_has_fne() and kvm_spe_has_fds()
seem better!

>  #else
>  struct kvm_spe {
>  };
> @@ -99,6 +102,14 @@ static inline u64 kvm_spe_read_sysreg(struct kvm_vcpu *vcpu, int reg)
>  {
>  	return 0;
>  }
> +static inline bool kvm_spe_has_feat_spe_fne(struct kvm *kvm)
> +{
> +	return false;
> +}
> +static inline bool kvm_spe_has_feat_spe_fds(struct kvm *kvm)
> +{
> +	return false;
> +}
>  #endif /* CONFIG_KVM_ARM_SPE */
>
>  #endif /* __ARM64_KVM_SPE_H__ */
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 1053676551af..78e414ed736d 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -7,6 +7,7 @@
>  #include <linux/kvm_host.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_nested.h>
> +#include <asm/kvm_spe.h>
>  #include <asm/sysreg.h>
>
>  /*
> @@ -159,7 +160,6 @@ struct reg_feat_map_desc {
>  #define FEAT_GICv3		ID_AA64PFR0_EL1, GIC, IMP
>  #define FEAT_LOR		ID_AA64MMFR1_EL1, LO, IMP
>  #define FEAT_SPEv1p2		ID_AA64DFR0_EL1, PMSVer, V1P2
> -#define FEAT_SPEv1p4		ID_AA64DFR0_EL1, PMSVer, V1P4
>  #define FEAT_SPEv1p5		ID_AA64DFR0_EL1, PMSVer, V1P5
>  #define FEAT_ATS1A		ID_AA64ISAR2_EL1, ATS1A, IMP
>  #define FEAT_SPECRES2		ID_AA64ISAR1_EL1, SPECRES, COSP_RCTX
> @@ -292,26 +292,6 @@ static bool feat_sme_smps(struct kvm *kvm)
>  		(read_sysreg_s(SYS_SMIDR_EL1) & SMIDR_EL1_SMPS));
>  }
>
> -static bool feat_spe_fds(struct kvm *kvm)
> -{
> -	/*
> -	 * Revisit this if KVM ever supports SPE -- this really should
> -	 * look at the guest's view of PMSIDR_EL1.
> -	 */
> -	return (kvm_has_feat(kvm, FEAT_SPEv1p4) &&
> -		(read_sysreg_s(SYS_PMSIDR_EL1) & PMSIDR_EL1_FDS));
> -}
> -
> -static bool feat_spe_fne(struct kvm *kvm)
> -{
> -	/*
> -	 * Revisit this if KVM ever supports SPE -- this really should
> -	 * look at the guest's view of PMSIDR_EL1.
> -	 */
> -	return (kvm_has_feat(kvm, FEAT_SPEv1p2) &&
> -		(read_sysreg_s(SYS_PMSIDR_EL1) & PMSIDR_EL1_FnE));
> -}
> -
>  static bool feat_trbe_mpam(struct kvm *kvm)
>  {
>  	/*
> @@ -547,7 +527,7 @@ static const struct reg_bits_to_feat_map hdfgrtr_feat_map[] = {
>  		   HDFGRTR_EL2_PMBPTR_EL1	|
>  		   HDFGRTR_EL2_PMBLIMITR_EL1,
>  		   FEAT_SPE),
> -	NEEDS_FEAT(HDFGRTR_EL2_nPMSNEVFR_EL1, feat_spe_fne),
> +	NEEDS_FEAT(HDFGRTR_EL2_nPMSNEVFR_EL1, kvm_spe_has_feat_spe_fne),
>  	NEEDS_FEAT(HDFGRTR_EL2_nBRBDATA		|
>  		   HDFGRTR_EL2_nBRBCTL		|
>  		   HDFGRTR_EL2_nBRBIDR,
> @@ -615,7 +595,7 @@ static const struct reg_bits_to_feat_map hdfgwtr_feat_map[] = {
>  		   HDFGWTR_EL2_PMBPTR_EL1	|
>  		   HDFGWTR_EL2_PMBLIMITR_EL1,
>  		   FEAT_SPE),
> -	NEEDS_FEAT(HDFGWTR_EL2_nPMSNEVFR_EL1, feat_spe_fne),
> +	NEEDS_FEAT(HDFGWTR_EL2_nPMSNEVFR_EL1, kvm_spe_has_feat_spe_fne),
>  	NEEDS_FEAT(HDFGWTR_EL2_nBRBDATA		|
>  		   HDFGWTR_EL2_nBRBCTL,
>  		   FEAT_BRBE),
> @@ -851,7 +831,7 @@ static const struct reg_bits_to_feat_map hdfgrtr2_feat_map[] = {
>  		   HDFGRTR2_EL2_nPMSSDATA,
>  		   FEAT_PMUv3_SS),
>  	NEEDS_FEAT(HDFGRTR2_EL2_nPMIAR_EL1, FEAT_SEBEP),
> -	NEEDS_FEAT(HDFGRTR2_EL2_nPMSDSFR_EL1, feat_spe_fds),
> +	NEEDS_FEAT(HDFGRTR2_EL2_nPMSDSFR_EL1, kvm_spe_has_feat_spe_fds),
>  	NEEDS_FEAT(HDFGRTR2_EL2_nPMBMAR_EL1, FEAT_SPE_nVM),
>  	NEEDS_FEAT(HDFGRTR2_EL2_nSPMACCESSR_EL1	|
>  		   HDFGRTR2_EL2_nSPMCNTEN	|
> @@ -884,7 +864,7 @@ static const struct reg_bits_to_feat_map hdfgwtr2_feat_map[] = {
>  		   feat_pmuv3p9),
>  	NEEDS_FEAT(HDFGWTR2_EL2_nPMSSCR_EL1, FEAT_PMUv3_SS),
>  	NEEDS_FEAT(HDFGWTR2_EL2_nPMIAR_EL1, FEAT_SEBEP),
> -	NEEDS_FEAT(HDFGWTR2_EL2_nPMSDSFR_EL1, feat_spe_fds),
> +	NEEDS_FEAT(HDFGWTR2_EL2_nPMSDSFR_EL1, kvm_spe_has_feat_spe_fds),
>  	NEEDS_FEAT(HDFGWTR2_EL2_nPMBMAR_EL1, FEAT_SPE_nVM),
>  	NEEDS_FEAT(HDFGWTR2_EL2_nSPMACCESSR_EL1	|
>  		   HDFGWTR2_EL2_nSPMCNTEN	|
> diff --git a/arch/arm64/kvm/spe.c b/arch/arm64/kvm/spe.c
> index 8c173a1f48bd..3b285b45332b 100644
> --- a/arch/arm64/kvm/spe.c
> +++ b/arch/arm64/kvm/spe.c
> @@ -113,6 +113,28 @@ void kvm_spe_destroy_vm(struct kvm *kvm)
>  	module_put(spe_pmu->pmu.module);
>  }
>
> +bool kvm_spe_has_feat_spe_fds(struct kvm *kvm)
> +{
> +	struct arm_spe_pmu *spe_pmu = kvm->arch.kvm_spe.spe_pmu;
> +
> +	if (!spe_pmu)
> +		return false;
> +
> +	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P4) &&
> +	       FIELD_GET(PMSIDR_EL1_FDS, spe_pmu->pmsidr_el1);
> +}
> +
> +bool kvm_spe_has_feat_spe_fne(struct kvm *kvm)
> +{
> +	struct arm_spe_pmu *spe_pmu = kvm->arch.kvm_spe.spe_pmu;
> +
> +	if (!spe_pmu)
> +		return false;
> +
> +	return kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P2) &&
> +	       FIELD_GET(PMSIDR_EL1_FnE, spe_pmu->pmsidr_el1);
> +}
> +
>  bool kvm_spe_write_sysreg(struct kvm_vcpu *vcpu, int reg, u64 val)
>  {
>  	struct kvm_spe *kvm_spe = &vcpu->kvm->arch.kvm_spe;
> --
> 2.43.0
>
>

--
Cheers, Lorenzo
