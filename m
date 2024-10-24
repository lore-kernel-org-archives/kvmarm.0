Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80C87154420
	for <kvmarm@lists.linux.dev>; Thu, 24 Oct 2024 15:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729784189; cv=none; b=qVvznM9UClwHdsj0+D6BCK0jJhUEp8tXMurBp8mUpKQ0dLTd384H1xcavc+6qAHu3R5kOBBN299j08PfUkQkYWNtQAFhecGhWi5oxq8ZqWbMR0YrezzM0ce8aWjWXl8l896jfA/bnVHCEUG2gNVU5emUcQGKP5j+4Y2UwtAT29A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729784189; c=relaxed/simple;
	bh=yC0V756RRZAsCmqtJnjm53GOiOV+CVBZkn7D76jUupU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hpRX7uOAAINlCoAz7D6xvoLyheUo+6+p0cQ5vIr8C3uwuobHBV18JbfXsHaeJ6Ej0J3fCUs7XzKVOOTWMW8VRPLoFqK1O8UYA70/cnlGtBQ0WjcHoqNasq+0TYVUxFEJkuBSOiK0HtdsLenWbwliOxNfrFb8VO6kBHe7bjjnheo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B1A2E339;
	Thu, 24 Oct 2024 08:36:56 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D73ED3F528;
	Thu, 24 Oct 2024 08:36:25 -0700 (PDT)
Date: Thu, 24 Oct 2024 16:36:23 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v5 34/37] KVM: arm64: Disable hierarchical permissions
 when POE is enabled
Message-ID: <20241024153623.GF1403933@e124191.cambridge.arm.com>
References: <20241023145345.1613824-1-maz@kernel.org>
 <20241023145345.1613824-35-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023145345.1613824-35-maz@kernel.org>

On Wed, Oct 23, 2024 at 03:53:42PM +0100, Marc Zyngier wrote:
> The hierarchical permissions must be disabled when POE is enabled
> in the translation regime used for a given table walk.
> 
> We store the two enable bits in the s1_walk_info structure so that
> they can be retrieved down the line, as they will be useful.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/at.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
> 
> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> index ef1643faedeb4..8d1dc6327ec5b 100644
> --- a/arch/arm64/kvm/at.c
> +++ b/arch/arm64/kvm/at.c
> @@ -24,6 +24,8 @@ struct s1_walk_info {
>  	unsigned int		txsz;
>  	int 	     		sl;
>  	bool	     		hpd;
> +	bool			e0poe;
> +	bool			poe;
>  	bool	     		be;
>  	bool	     		s2;
>  };
> @@ -110,6 +112,34 @@ static bool s1pie_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
>  	}
>  }
>  
> +static void compute_s1poe(struct kvm_vcpu *vcpu, struct s1_walk_info *wi)
> +{
> +	u64 val;
> +
> +	if (!kvm_has_s1poe(vcpu->kvm)) {
> +		wi->poe = wi->e0poe = false;
> +		return;
> +	}
> +
> +	switch (wi->regime) {
> +	case TR_EL2:
> +	case TR_EL20:
> +		val = vcpu_read_sys_reg(vcpu, TCR2_EL2);
> +		wi->poe = val & TCR2_EL2_POE;
> +		wi->e0poe = (wi->regime == TR_EL20) && (val & TCR2_EL2_E0POE);
> +		break;
> +	case TR_EL10:
> +		if (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En) {
> +			wi->poe = wi->e0poe = false;
> +			return;
> +		}
> +
> +		val = __vcpu_sys_reg(vcpu, TCR2_EL1);
> +		wi->poe = val & TCR2_EL1x_POE;
> +		wi->e0poe = val & TCR2_EL1x_E0POE;
> +	}
> +}
> +
>  static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
>  			 struct s1_walk_result *wr, u64 va)
>  {
> @@ -206,6 +236,12 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
>  	/* R_JHSVW */
>  	wi->hpd |= s1pie_enabled(vcpu, wi->regime);
>  
> +	/* Do we have POE? */
> +	compute_s1poe(vcpu, wi);
> +
> +	/* R_BVXDG */
> +	wi->hpd |= (wi->poe || wi->e0poe);
> +
>  	/* Someone was silly enough to encode TG0/TG1 differently */
>  	if (va55) {
>  		wi->txsz = FIELD_GET(TCR_T1SZ_MASK, tcr);
> -- 
> 2.39.2
> 
