Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E25202E401
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 11:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746097317; cv=none; b=XSte5Y+Pl7Sn1LP81lBiPOgSC1h/EpvIsKMmSnJaLd3n0L5FaYHs17BdvVeGrURNefLWfcVkDuEQ6e+EOVzDreHqHcaoDaVFX0fGye4WgNQyyIA4k/FMLEitCyF/dP+UkR9WCmu8G2n8hJ7eiOGkzLMOYGqdXX10tWlEfvGbSd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746097317; c=relaxed/simple;
	bh=GiCrzs2Fdvusv4yoGsES1ow6eU4r+keqOuYRsOqAxcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pISC4pQq/MGJOD7/RQWcd9hcemuz1bkdtCaP4imUnaY85kV7HM+7pCrN4DtIb1/rktCkF/fIydC7vl6xijs7tXtSw9dDsIkqJOchX/pPBNKm2jjIOsM18CwxzZjzumJww3GU+pm/eRkuYRflhvIbEcwJzrG71K0u2Gc/vhiucxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2237106F;
	Thu,  1 May 2025 04:01:47 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DFF63F5A1;
	Thu,  1 May 2025 04:01:53 -0700 (PDT)
Date: Thu, 1 May 2025 12:01:50 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 17/42] KVM: arm64: Handle trapping of FEAT_LS64*
 instructions
Message-ID: <20250501110150.GH1859293@e124191.cambridge.arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-18-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426122836.3341523-18-maz@kernel.org>

On Sat, Apr 26, 2025 at 01:28:11PM +0100, Marc Zyngier wrote:
> We generally don't expect FEAT_LS64* instructions to trap, unless
> they are trapped by a guest hypervisor.
> 
> Otherwise, this is just the guest playing tricks on us by using
> an instruction that isn't advertised, which we handle with a well
> deserved UNDEF.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/handle_exit.c | 56 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index b73dc26bc44b4..636c14ed2bb82 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -298,6 +298,61 @@ static int handle_svc(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +static int handle_other(struct kvm_vcpu *vcpu)
> +{
> +	bool is_l2 = vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu);
> +	u64 hcrx = __vcpu_sys_reg(vcpu, HCRX_EL2);
> +	u64 esr = kvm_vcpu_get_esr(vcpu);
> +	u64 iss = ESR_ELx_ISS(esr);
> +	struct kvm *kvm = vcpu->kvm;
> +	bool allowed, fwd = false;
> +
> +	/*
> +	 * We only trap for two reasons:
> +	 *
> +	 * - the feature is disabled, and the only outcome is to
> +	 *   generate an UNDEF.
> +	 *
> +	 * - the feature is enabled, but a NV guest wants to trap the
> +	 *   feature used my its L2 guest. We forward the exception in
> +	 *   this case.
> +	 *
> +	 * What we don't expect is to end-up here if the guest is
> +	 * expected be be able to directly use the feature, hence the
> +	 * WARN_ON below.
> +	 */
> +	switch (iss) {
> +	case ESR_ELx_ISS_OTHER_ST64BV:
> +		allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V);
> +		if (is_l2)
> +			fwd = !(hcrx & HCRX_EL2_EnASR);
> +		break;
> +	case ESR_ELx_ISS_OTHER_ST64BV0:
> +		allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA);
> +		if (is_l2)
> +			fwd = !(hcrx & HCRX_EL2_EnAS0);
> +		break;
> +	case ESR_ELx_ISS_OTHER_LDST64B:
> +		allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64);
> +		if (is_l2)
> +			fwd = !(hcrx & HCRX_EL2_EnALS);
> +		break;
> +	default:
> +		/* Clearly, we're missing something. */
> +		WARN_ON_ONCE(1);
> +		allowed = false;
> +	}
> +
> +	WARN_ON_ONCE(allowed && !fwd);
> +
> +	if (allowed && fwd)
> +		kvm_inject_nested_sync(vcpu, esr);
> +	else
> +		kvm_inject_undefined(vcpu);
> +
> +	return 1;
> +}
> +
>  static exit_handle_fn arm_exit_handlers[] = {
>  	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
>  	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
> @@ -307,6 +362,7 @@ static exit_handle_fn arm_exit_handlers[] = {
>  	[ESR_ELx_EC_CP14_LS]	= kvm_handle_cp14_load_store,
>  	[ESR_ELx_EC_CP10_ID]	= kvm_handle_cp10_id,
>  	[ESR_ELx_EC_CP14_64]	= kvm_handle_cp14_64,
> +	[ESR_ELx_EC_OTHER]	= handle_other,
>  	[ESR_ELx_EC_HVC32]	= handle_hvc,
>  	[ESR_ELx_EC_SMC32]	= handle_smc,
>  	[ESR_ELx_EC_HVC64]	= handle_hvc,
> -- 
> 2.39.2
> 
