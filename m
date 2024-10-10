Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73E229AF
	for <kvmarm@lists.linux.dev>; Thu, 10 Oct 2024 07:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728545606; cv=none; b=X/SS56cjLi/xgv63ORA4J3Flhn0G/ilR7adTD+yiKZVuck2qEBLSVCdX1/XO7LlDoiLK5MCZfRAHazFof/Omid0Bw4iBQGL6K3oAu8+n14fdzBvsme9fRni5thfE4Ofx79XUVjvpzPaSbGOtypc7kESHXPcSMzlrp3Q4rYhJ2HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728545606; c=relaxed/simple;
	bh=Be0eJLXFlq7mjBiqgm4yOnVtUooau0HPh3foygd6C4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BgTO8tYfNGawZGBzLAO4fRGTKo1zqKBzgjh/uRRtwHGiJBG/MWWQyGi5T5Roi6rScbxPgNvi28baeDs3ZTgFsoMYwb7tZ82yeApnJ6Lcm/xJ/LSaEQ2iObqgEIjtkRIKBQpo8KNyOSgjx1n6FqnxvAp6fUN2+H7QTJdsqHeeRig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BRLh0JkD; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BRLh0JkD"
Date: Thu, 10 Oct 2024 00:33:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728545601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bq7NXyz5reRJAmTWnErzz1mr3r4s/qAHH6pxo4WQPzI=;
	b=BRLh0JkDroH7pRT/zrCFJMCckodJTMpEDRiX+emcN+x2wLF3zd7VMLcw94j9x61PculbU8
	HMTAg75//P8k6Q++uPvDS5pQFfIW/KkLxvIEjoMogF6RPw8fT79eVDZosx0WOvk9gXy/In
	CLdHLkKoKr2kzli3QVEd3jIjXpxx1AM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v4 20/36] KVM: arm64: Disable hierarchical permissions
 when S1PIE is enabled
Message-ID: <ZweDOQnT4a0J4ekA@linux.dev>
References: <20241009190019.3222687-1-maz@kernel.org>
 <20241009190019.3222687-21-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009190019.3222687-21-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 09, 2024 at 08:00:03PM +0100, Marc Zyngier wrote:
> S1PIE implicitly disables hierarchical permissions, as specified in
> R_JHSVW, by making TCR_ELx.HPDn RES1.
> 
> Add a predicate for S1PIE being enabled for a given translation regime,
> and emulate this behaviour by forcing the hpd field to true if S1PIE
> is enabled for that translation regime.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
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

BUILD_BUG()?

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

-- 
Thanks,
Oliver
