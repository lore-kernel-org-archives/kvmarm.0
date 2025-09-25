Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37673279DC9
	for <kvmarm@lists.linux.dev>; Thu, 25 Sep 2025 11:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758798761; cv=none; b=Xb+B31mV+3um07LoR4nq3415FUYore49MJjpIwCTuhIGoMXNjMrYzAfW3QHkc6deOPSNkDJ9ySLq937PNqEnoSSvv66YXx9eJMYHfnFgZG0sg00np3PsGP9AnQoyUwzJx+Mof/uF7u42NTYg2weMfjzQdNqOExrYAqqXAfHMsrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758798761; c=relaxed/simple;
	bh=AZJmcnOsI+FoVdFLhr5+UdUHIUAOKZpJluPbwDdbxak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e7VMf5iCso2Ld0zuspvWjm9Z6QKahy/QTXV0yyIYDNgFPlzL1QH6IszYIBry4p16vIAjEG2CwFmYnH/n8eIZhUrMLzONRAtBJuiA4Ri9bWw90qxZGTgWBKSrswrtjACveNq9gAbFDba6c0YMK4vBTqOi2jJ9wBQkBq/vzSfkV/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B2071692;
	Thu, 25 Sep 2025 04:12:31 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A32343F5A1;
	Thu, 25 Sep 2025 04:12:38 -0700 (PDT)
Date: Thu, 25 Sep 2025 12:12:36 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 2/2] KVM: arm64: nv: Use FGT write trap of MDSCR_EL1 when
 available
Message-ID: <20250925111236.GB435166@e124191.cambridge.arm.com>
References: <20250924235150.617451-1-oliver.upton@linux.dev>
 <20250924235150.617451-3-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924235150.617451-3-oliver.upton@linux.dev>

On Wed, Sep 24, 2025 at 04:51:50PM -0700, Oliver Upton wrote:
> Marc reports that the performance of running an L3 guest has regressed
> by 60% as a result of setting MDCR_EL2.TDA to hide bad architecture.
> That's of course terrible for the single user of recursive NV ;-)
> 
> While there's nothing to be done on non-FGT systems, take advantage of
> the precise write trap of MDSCR_EL1 and leave the rest of the debug
> registers untrapped.
> 
> Reported-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/config.c | 10 +++++++++-
>  arch/arm64/kvm/nested.c |  9 ++++++---
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index b1cf7660efe1..24bb3f36e9d5 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1489,6 +1489,14 @@ static void __compute_hfgwtr(struct kvm_vcpu *vcpu)
>  		*vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_TCR_EL1;
>  }
>  
> +static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
> +{
> +	__compute_fgt(vcpu, HDFGWTR_EL2);
> +
> +	if (is_hyp_ctxt(vcpu))
> +		*vcpu_fgt(vcpu, HDFGWTR_EL2) |= HDFGWTR_EL2_MDSCR_EL1;
> +}
> +
>  void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
>  {
>  	if (!cpus_have_final_cap(ARM64_HAS_FGT))
> @@ -1498,7 +1506,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
>  	__compute_hfgwtr(vcpu);
>  	__compute_fgt(vcpu, HFGITR_EL2);
>  	__compute_fgt(vcpu, HDFGRTR_EL2);
> -	__compute_fgt(vcpu, HDFGWTR_EL2);
> +	__compute_hdfgwtr(vcpu);
>  	__compute_fgt(vcpu, HAFGRTR_EL2);
>  
>  	if (!cpus_have_final_cap(ARM64_HAS_FGT2))
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index d828c60c6300..5009bfe849ff 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1830,13 +1830,16 @@ void kvm_nested_setup_mdcr_el2(struct kvm_vcpu *vcpu)
>  {
>  	u64 guest_mdcr = __vcpu_sys_reg(vcpu, MDCR_EL2);
>  
> +	if (is_nested_ctxt(vcpu))
> +		vcpu->arch.mdcr_el2 |= (guest_mdcr & NV_MDCR_GUEST_INCLUDE);
>  	/*
>  	 * In yet another example where FEAT_NV2 is fscking broken, accesses
>  	 * to MDSCR_EL1 are redirected to the VNCR despite having an effect
>  	 * at EL2. Use a big hammer to apply sanity.
> +	 *
> +	 * Unless of course we have FEAT_FGT, in which case we can precisely
> +	 * trap MDSCR_EL1.
>  	 */
> -	if (is_hyp_ctxt(vcpu))
> +	else if (!cpus_have_final_cap(ARM64_HAS_FGT))
>  		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
> -	else
> -		vcpu->arch.mdcr_el2 |= (guest_mdcr & NV_MDCR_GUEST_INCLUDE);
>  }
> -- 
> 2.47.3
> 
