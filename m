Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77EC2433BA5
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 16:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783356636; cv=none; b=CToC+huzse5XjJtVwobWevjlJNb7VTV+GjKKbEAI+/+z4FMmak5Se9Sry0VNHbJT9L9TpYdQ2LlucyhyxoXWpgBB8IcjToGeFhut58EApya2AKYRTIQWWy1zULyqR/ohmKRhP+aK88O4ynsX22vCyoV+N+yLge4Ytvv8n29TlE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783356636; c=relaxed/simple;
	bh=5gx+Hq/B19DUpaW5zl4vaiXMuJrfZXsmj7Pmu9/QLwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YBNd/36j97PIKCYchJOc52lGov9GQf4TXJTIzQl5Klenu2FdibAq1eqnZTW8ziMQa2Z5t/CHmY+znikkKM6Ll+JTBfSVzYkKn1VlDKOS+EHnJBe1TZIa2fYjFS6KbMhc//YHmS/ROeZXLU4/cqPTmPWEKq/MQRPFydG+psr5/8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hNv9JPEj; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hNv9JPEj"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22F9C2364;
	Mon,  6 Jul 2026 09:50:28 -0700 (PDT)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F7973F905;
	Mon,  6 Jul 2026 09:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783356632; bh=5gx+Hq/B19DUpaW5zl4vaiXMuJrfZXsmj7Pmu9/QLwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hNv9JPEjnVTehVG+ZStiuTwlfTXVkMkPoxNVCJhaCqaFApAK4IPvL9LwBdg3LYTRt
	 Y1aWoF6YkgPgJYL2vGqYNko1vxaHnflWKWrTDhqRERY/3P/19mXsAi5jbcNBbrmrI1
	 ncZ/rSgj/cZI1XPtw0gQ2a3Ei0zX2lNe0CrsNKlo=
Date: Mon, 6 Jul 2026 17:50:14 +0100
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [PATCH 07/22] KVM: arm64: nv: Set dirty state at stage-2
Message-ID: <bnjj67ht3pepmu4hd6jztiymzkkna57atvjr6eec25otuac3jc@jmgtpj4im3ew>
References: <20260623184201.1518871-1-oupton@kernel.org>
 <20260623184201.1518871-8-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623184201.1518871-8-oupton@kernel.org>

Hi Oliver,

On Tue, Jun 23, 2026 at 11:41:46AM -0700, Oliver Upton wrote:
> Set the dirty state on descriptors at stage-2 for write accesses when
> DBM is set.
> 
> Signed-off-by: Oliver Upton <oupton@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 43 +++++++++++++++++++++++++++++++----------
>  1 file changed, 33 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index a70af3b3f05d..e5a407fc0880 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -132,6 +132,7 @@ struct s2_walk_info {
>  	unsigned int	t0sz;
>  	bool		be;
>  	bool		ha;
> +	bool		hd;
>  };
>  
>  struct s2_walk_step {
> @@ -227,6 +228,20 @@ static int read_guest_s2_desc(struct kvm_vcpu *vcpu, struct s2_walk_step *ws,
>  	return 0;
>  }
>  
> +static bool should_set_dirty_state(struct s2_walk_info *wi, struct s2_walk_step *ws,
> +				   struct kvm_s2_trans *out, struct kvm_walk_access *access)
> +{
> +	switch (access->type) {
> +	/* R_RKMHW */

Just saying that I found that R_RKMHW is not about this behavior anymore
in the latest M.c Arm ARM. This is covered by R_ZYGHJ now.

Thanks,
Wei-Lin Chang

> +	case WALK_ACCESS_CMO:
> +	case WALK_ACCESS_AT:
> +		return false;
> +	default:
> +		/* R_NSXRD */
> +		return access->write && wi->hd && out->writable;
> +	}
> +}
> +
>  static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
>  			      struct s2_walk_step *ws, struct kvm_s2_trans *out,
>  			      struct kvm_walk_access *access)
> @@ -239,6 +254,9 @@ static int handle_desc_update(struct kvm_vcpu *vcpu, struct s2_walk_info *wi,
>  	if (wi->ha)
>  		new |= KVM_PTE_LEAF_ATTR_LO_S2_AF;
>  
> +	if (should_set_dirty_state(wi, ws, out, access))
> +		new |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +
>  	if (old == new)
>  		return 0;
>  
> @@ -403,16 +421,6 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
>  		return 1;
>  	}
>  
> -	ret = handle_desc_update(vcpu, wi, &ws, out, access);
> -	if (ret)
> -		return ret;
> -
> -	if (!(ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_AF)) {
> -		out->esr = compute_fsc(ws.level, ESR_ELx_FSC_ACCESS);
> -		out->desc = ws.desc;
> -		return 1;
> -	}
> -
>  	addr_bottom += contiguous_bit_shift(ws.desc, wi, ws.level);
>  
>  	/* Calculate and return the result */
> @@ -422,6 +430,20 @@ static int walk_nested_s2_pgd(struct kvm_vcpu *vcpu, struct kvm_walk_access *acc
>  	compute_s2_permissions(vcpu, wi, &ws, out);
>  	out->level = ws.level;
>  	out->desc = ws.desc;
> +
> +	ret = handle_desc_update(vcpu, wi, &ws, out, access);
> +	if (ret)
> +		return ret;
> +
> +	if (!(ws.desc & KVM_PTE_LEAF_ATTR_LO_S2_AF)) {
> +		*out = (struct kvm_s2_trans) {
> +			.esr	= compute_fsc(ws.level, ESR_ELx_FSC_ACCESS),
> +			.desc	= ws.desc,
> +		};
> +
> +		return 1;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -518,6 +540,7 @@ static void setup_s2_walk(struct kvm_vcpu *vcpu, struct s2_walk_info *wi)
>  			      ps_to_output_size(FIELD_GET(VTCR_EL2_PS_MASK, vtcr), false));
>  	wi->ha = vtcr & VTCR_EL2_HA;
>  	wi->be = vcpu_read_sys_reg(vcpu, SCTLR_EL2) & SCTLR_ELx_EE;
> +	wi->hd = wi->ha && (vtcr & VTCR_EL2_HD);
>  }
>  
>  int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, struct kvm_walk_access *access,
> -- 
> 2.47.3
> 
