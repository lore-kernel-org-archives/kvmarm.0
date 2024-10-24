Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A131B1E0487
	for <kvmarm@lists.linux.dev>; Thu, 24 Oct 2024 14:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729778574; cv=none; b=H/k/zcSnbzn6SV9D/x2MJOFS/3uSUSK52SLkke9sn2YUbszBKQ30/8GuLryw31HChdM9/zCfqR+N3OGIeD5o9v+OMVz4b/AAiMWjrv/VAfNEsh20IOvUlfuVQVavrRg2i5zr2G88LacEiJPDKmpUJEwByyIYcWIQuftInitXKZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729778574; c=relaxed/simple;
	bh=WTVSSKaRkVuI5BHzYDpJ9AqxA/a6j08fSZclAZICZ5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ezq7WXwkhSqxD1fr1LkTGhwJ/yWmsk94sIJJRbumwskE884fYxouE1GLPS/URcji1bWWgLrAYR9rs0enlMNhPUBtBmRVqUmoucY3nkqQKxAMpWr+SRskSHccO/muWgMpyPkyRVsu2KJk+lxmlAXPsb9tiabU4wWWHYpN8+1ELNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB013339;
	Thu, 24 Oct 2024 07:03:20 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF1CC3F528;
	Thu, 24 Oct 2024 07:02:49 -0700 (PDT)
Date: Thu, 24 Oct 2024 15:02:47 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v5 20/37] KVM: arm64: Disable hierarchical permissions
 when S1PIE is enabled
Message-ID: <20241024140247.GC1403933@e124191.cambridge.arm.com>
References: <20241023145345.1613824-1-maz@kernel.org>
 <20241023145345.1613824-21-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023145345.1613824-21-maz@kernel.org>

On Wed, Oct 23, 2024 at 03:53:28PM +0100, Marc Zyngier wrote:
> S1PIE implicitly disables hierarchical permissions, as specified in
> R_JHSVW, by making TCR_ELx.HPDn RES1.
> 
> Add a predicate for S1PIE being enabled for a given translation regime,
> and emulate this behaviour by forcing the hpd field to true if S1PIE
> is enabled for that translation regime.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/at.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index adcfce3f67f03..f5bd750288ff5 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -93,6 +93,23 @@ static enum trans_regime compute_translation_regime(struct kvm_vcpu *vcpu, u32 o
>  	}
>  }
>  
> +static bool s1pie_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
> +{
> +	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
> +		return false;
> +
> +	switch (regime) {
> +	case TR_EL2:
> +	case TR_EL20:
> +		return vcpu_read_sys_reg(vcpu, TCR2_EL2) & TCR2_EL2_PIE;
> +	case TR_EL10:
> +		return  (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En) &&
> +			(__vcpu_sys_reg(vcpu, TCR2_EL1) & TCR2_EL1x_PIE);
> +	default:
> +		BUG();
> +	}
> +}
> +
>  static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
>  			 struct s1_walk_result *wr, u64 va)
>  {
> @@ -186,6 +203,8 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
>  		    (va55 ?
>  		     FIELD_GET(TCR_HPD1, tcr) :
>  		     FIELD_GET(TCR_HPD0, tcr)));
> +	/* R_JHSVW */
> +	wi->hpd |= s1pie_enabled(vcpu, wi->regime);
>  
>  	/* Someone was silly enough to encode TG0/TG1 differently */
>  	if (va55) {
> -- 
> 2.39.2
> 
