Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE89C16FF3B
	for <kvmarm@lists.linux.dev>; Thu, 24 Oct 2024 10:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729765313; cv=none; b=Yv/fzqNL2SBsIS+lYr2dwg0hfZXLjVxnCRlg1nOlDiuoNhoVAHO223We/XKmWsLQumnybCBjExGGMotVduI5xPfOhYcqIDFmu2HW/JsEsh74k9uKwKursn72+70+N1HDpGS47nA7/doyTFZlcqICbApSia9zqGBhsi86riqeyvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729765313; c=relaxed/simple;
	bh=o7V1fEUBye7S5nTTQDp6lzZ3iKL73ESUhBqYHqHHr10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tXtnpPQ93oKsPEcLkj5FnZXtPQNs9YdnA2mMtbUHIuhPykdetnbH47t790wKfxAXtiYynyMIQqjX4ubKBfjuXfFlH2SO4qQ2taC8dUyFOT2j4Nw/ssfysmqShzZSpWaBIJa+15+bIbK3er4EkGLMqhm+dlb+r6zU0PXfFv1gW1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 83B1F339;
	Thu, 24 Oct 2024 03:22:19 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A91F53F71E;
	Thu, 24 Oct 2024 03:21:48 -0700 (PDT)
Date: Thu, 24 Oct 2024 11:21:46 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v5 12/37] KVM: arm64: Sanitise TCR2_EL2
Message-ID: <20241024102146.GB1382116@e124191.cambridge.arm.com>
References: <20241023145345.1613824-1-maz@kernel.org>
 <20241023145345.1613824-13-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023145345.1613824-13-maz@kernel.org>

On Wed, Oct 23, 2024 at 03:53:20PM +0100, Marc Zyngier wrote:
> TCR2_EL2 is a bag of control bits, all of which are only valid if
> certain features are present, and RES0 otherwise.
> 
> Describe these constraints and register them with the masking
> infrastructure.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index b20b3bfb9caec..b4b3ec88399b3 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1179,6 +1179,28 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
>  		res0 |= ~(res0 | res1);
>  	set_sysreg_masks(kvm, HAFGRTR_EL2, res0, res1);
>  
> +	/* TCR2_EL2 */
> +	res0 = TCR2_EL2_RES0;
> +	res1 = TCR2_EL2_RES1;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, D128, IMP))
> +		res0 |= (TCR2_EL2_DisCH0 | TCR2_EL2_DisCH1 | TCR2_EL2_D128);
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, MEC, IMP))
> +		res0 |= TCR2_EL2_AMEC1 | TCR2_EL2_AMEC0;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, HAFDBS, HAFT))
> +		res0 |= TCR2_EL2_HAFT;
> +	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, THE, IMP))
> +		res0 |= TCR2_EL2_PTTWI | TCR2_EL2_PnCH;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, AIE, IMP))
> +		res0 |= TCR2_EL2_AIE;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1POE, IMP))
> +		res0 |= TCR2_EL2_POE | TCR2_EL2_E0POE;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
> +		res0 |= TCR2_EL2_PIE;
> +	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, VH, IMP))
> +		res0 |= (TCR2_EL2_E0POE | TCR2_EL2_D128 |
> +			 TCR2_EL2_AMEC1 | TCR2_EL2_DisCH0 | TCR2_EL2_DisCH1);
> +	set_sysreg_masks(kvm, TCR2_EL2, res0, res1);
> +
>  	/* SCTLR_EL1 */
>  	res0 = SCTLR_EL1_RES0;
>  	res1 = SCTLR_EL1_RES1;

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
