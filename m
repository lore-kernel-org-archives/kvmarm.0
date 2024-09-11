Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFA37155747
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 14:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726064123; cv=none; b=MD3B2M8Ccp9c8OSke4Etw/3025GHBbd2LbBB8i297qK4UPt/SL0k3s6l/owVJAEOhXrad7HYGvbY6wNfjZj7d9cb3QrQ+4Tmv72O7kl1CmJoK9z40u0aF2YmLqxtE5F0+xmTj536gULajceTH51OfrhwkwEmt6U/1kM+ZR1SSDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726064123; c=relaxed/simple;
	bh=C/fI7kaD7EtAk3Iav89lmxsAr0NqFH6Ak9vhkIs7pSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bCTr33DSrlef846CVzTMSahNmfm7nXLW5NgMNTvPXtqE18bVF0M3BEJCrWuux2cOu77/+Dt7zzb/Y9+sWJV17BmD62r2giifbINhnI6jT6IE97kFKX/wQJPZXmhuVl2tEew2dPE7GNVRVjWL0kQCqrPC9EOUwzPONZohfZOADFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 701331007;
	Wed, 11 Sep 2024 07:15:49 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8BC303F73B;
	Wed, 11 Sep 2024 07:15:18 -0700 (PDT)
Date: Wed, 11 Sep 2024 15:15:13 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 18/24] KVM: arm64: Split S1 permission evaluation into
 direct and hierarchical parts
Message-ID: <20240911141513.GA1080224@e124191.cambridge.arm.com>
References: <20240911135151.401193-1-maz@kernel.org>
 <20240911135151.401193-19-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911135151.401193-19-maz@kernel.org>

On Wed, Sep 11, 2024 at 02:51:45PM +0100, Marc Zyngier wrote:
> The AArch64.S1DirectBasePermissions() pseudocode deals with both
> direct and hierarchical S1 permission evaluation. While this is
> probably convenient in the pseudocode, we would like a bit more
> flexibility to slot things like indirect permissions.
> 
> To that effect, split the two permission check parts out of
> handle_at_slow() and into their own functions. The permissions
> are passed around in a new s1_perms type that contains the
> individual permissions across the flow.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/at.c | 164 ++++++++++++++++++++++++++------------------
>  1 file changed, 99 insertions(+), 65 deletions(-)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index 73b2ee662f371..d6ee3a5c30bc2 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -47,6 +47,10 @@ struct s1_walk_result {
>  	bool	failed;
>  };
>  
> +struct s1_perms {
> +	bool	ur, uw, ux, pr, pw, px;
> +};
> +
>  static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool ptw, bool s2)
>  {
>  	wr->fst		= fst;
> @@ -764,111 +768,141 @@ static bool pan3_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
>  	return sctlr & SCTLR_EL1_EPAN;
>  }
>  
> -static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
> +static void compute_s1_direct_permissions(struct kvm_vcpu *vcpu,
> +					  struct s1_walk_info *wi,
> +					  struct s1_walk_result *wr,
> +					  struct s1_perms *s1p)
>  {
> -	bool perm_fail, ur, uw, ux, pr, pw, px;
> -	struct s1_walk_result wr = {};
> -	struct s1_walk_info wi = {};
> -	int ret, idx;
> -
> -	ret = setup_s1_walk(vcpu, op, &wi, &wr, vaddr);
> -	if (ret)
> -		goto compute_par;
> -
> -	if (wr.level == S1_MMU_DISABLED)
> -		goto compute_par;
> -
> -	idx = srcu_read_lock(&vcpu->kvm->srcu);
> -
> -	ret = walk_s1(vcpu, &wi, &wr, vaddr);
> -
> -	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> -
> -	if (ret)
> -		goto compute_par;
> -
> -	/* FIXME: revisit when adding indirect permission support */
> -	/* AArch64.S1DirectBasePermissions() */
> -	if (wi.regime != TR_EL2) {
> -		switch (FIELD_GET(PTE_USER | PTE_RDONLY, wr.desc)) {
> +	/* Non-hierarchical part of AArch64.S1DirectBasePermissions() */
> +	if (wi->regime != TR_EL2) {
> +		switch (FIELD_GET(PTE_USER | PTE_RDONLY, wr->desc)) {
>  		case 0b00:
> -			pr = pw = true;
> -			ur = uw = false;
> +			s1p->pr = s1p->pw = true;
> +			s1p->ur = s1p->uw = false;
>  			break;
>  		case 0b01:
> -			pr = pw = ur = uw = true;
> +			s1p->pr = s1p->pw = s1p->ur = s1p->uw = true;
>  			break;
>  		case 0b10:
> -			pr = true;
> -			pw = ur = uw = false;
> +			s1p->pr = true;
> +			s1p->pw = s1p->ur = s1p->uw = false;
>  			break;
>  		case 0b11:
> -			pr = ur = true;
> -			pw = uw = false;
> +			s1p->pr = s1p->ur = true;
> +			s1p->pw = s1p->uw = false;
>  			break;
>  		}
>  
> -		switch (wr.APTable) {
> +		/* We don't use px for anything yet, but hey... */
> +		s1p->px = !((wr->desc & PTE_PXN) || s1p->uw);
> +		s1p->ux = !(wr->desc & PTE_UXN);
> +	} else {
> +		s1p->ur = s1p->uw = s1p->ux = false;
> +
> +		if (!(wr->desc & PTE_RDONLY)) {
> +			s1p->pr = s1p->pw = true;
> +		} else {
> +			s1p->pr = true;
> +			s1p->pw = false;
> +		}
> +
> +		/* XN maps to UXN */
> +		s1p->px = !(wr->desc & PTE_UXN);
> +	}
> +}
> +
> +static void compute_s1_hierarchical_permissions(struct kvm_vcpu *vcpu,
> +						struct s1_walk_info *wi,
> +						struct s1_walk_result *wr,
> +						struct s1_perms *s1p)
> +{

How about:

	if (wi->hpd)
		return;

> +	/* Hierarchical part of AArch64.S1DirectBasePermissions() */
> +	if (wi->regime != TR_EL2) {
> +		switch (wr->APTable) {
>  		case 0b00:
>  			break;
>  		case 0b01:
> -			ur = uw = false;
> +			s1p->ur = s1p->uw = false;
>  			break;
>  		case 0b10:
> -			pw = uw = false;
> +			s1p->pw = s1p->uw = false;
>  			break;
>  		case 0b11:
> -			pw = ur = uw = false;
> +			s1p->pw = s1p->ur = s1p->uw = false;
>  			break;
>  		}
>  
> -		/* We don't use px for anything yet, but hey... */
> -		px = !((wr.desc & PTE_PXN) || wr.PXNTable || uw);
> -		ux = !((wr.desc & PTE_UXN) || wr.UXNTable);
> -
> -		if (op == OP_AT_S1E1RP || op == OP_AT_S1E1WP) {
> -			bool pan;
> -
> -			pan = *vcpu_cpsr(vcpu) & PSR_PAN_BIT;
> -			pan &= ur || uw || (pan3_enabled(vcpu, wi.regime) && ux);
> -			pw &= !pan;
> -			pr &= !pan;
> -		}
> +		s1p->px &= !wr->PXNTable;
> +		s1p->ux &= !wr->UXNTable;
>  	} else {
> -		ur = uw = ux = false;
> +		if (wr->APTable & BIT(1))
> +			s1p->pw = false;
>  
> -		if (!(wr.desc & PTE_RDONLY)) {
> -			pr = pw = true;
> -		} else {
> -			pr = true;
> -			pw = false;
> -		}
> +		/* XN maps to UXN */
> +		s1p->px &= !wr->UXNTable;
> +	}
> +}
>  
> -		if (wr.APTable & BIT(1))
> -			pw = false;
> +static void compute_s1_permissions(struct kvm_vcpu *vcpu, u32 op,
> +				   struct s1_walk_info *wi,
> +				   struct s1_walk_result *wr,
> +				   struct s1_perms *s1p)
> +{
> +	compute_s1_direct_permissions(vcpu, wi, wr, s1p);
> +	compute_s1_hierarchical_permissions(vcpu, wi, wr, s1p);
>  
> -		/* XN maps to UXN */
> -		px = !((wr.desc & PTE_UXN) || wr.UXNTable);
> +	if (op == OP_AT_S1E1RP || op == OP_AT_S1E1WP) {
> +		bool pan;
> +
> +		pan = *vcpu_cpsr(vcpu) & PSR_PAN_BIT;
> +		pan &= s1p->ur || s1p->uw || (pan3_enabled(vcpu, wi->regime) && s1p->ux);
> +		s1p->pw &= !pan;
> +		s1p->pr &= !pan;
>  	}
> +}
> +
> +static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
> +{
> +	struct s1_walk_result wr = {};
> +	struct s1_walk_info wi = {};
> +	struct s1_perms s1p = {};
> +	bool perm_fail = false;
> +	int ret, idx;
> +
> +	ret = setup_s1_walk(vcpu, op, &wi, &wr, vaddr);
> +	if (ret)
> +		goto compute_par;
> +
> +	if (wr.level == S1_MMU_DISABLED)
> +		goto compute_par;
> +
> +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> +
> +	ret = walk_s1(vcpu, &wi, &wr, vaddr);
> +
> +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +
> +	if (ret)
> +		goto compute_par;
>  
> -	perm_fail = false;
> +	compute_s1_permissions(vcpu, op, &wi, &wr, &s1p);
>  
>  	switch (op) {
>  	case OP_AT_S1E1RP:
>  	case OP_AT_S1E1R:
>  	case OP_AT_S1E2R:
> -		perm_fail = !pr;
> +		perm_fail = !s1p.pr;
>  		break;
>  	case OP_AT_S1E1WP:
>  	case OP_AT_S1E1W:
>  	case OP_AT_S1E2W:
> -		perm_fail = !pw;
> +		perm_fail = !s1p.pw;
>  		break;
>  	case OP_AT_S1E0R:
> -		perm_fail = !ur;
> +		perm_fail = !s1p.ur;
>  		break;
>  	case OP_AT_S1E0W:
> -		perm_fail = !uw;
> +		perm_fail = !s1p.uw;
>  		break;
>  	case OP_AT_S1E1A:
>  	case OP_AT_S1E2A:
> -- 
> 2.39.2
> 
