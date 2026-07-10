Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B96062E5B02
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 15:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783696654; cv=none; b=feteieTqbAZU6yeRasVPB/ZtbYkjNFNW5fGHqHNWxVO0KJYhFXMlx8l13opsymzZBamLL/k+IRQN4IWWqNkI33xR8fMl36ISUSSQBu54vVYBBm5C/Gj7jCl4Az+iaHsR43IhpwIyvp/1DmtHve/FBTuSQ8oMZ1kunlQs/B2lFJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783696654; c=relaxed/simple;
	bh=x2bMRixpySIA8bXaE0N2byG8u/ToD1VsGMdDAYwuZa0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZ+TmCL+BvDK5L5TjbrzbygGh2uZkkPHPl/rRsORsr342L37tS016vLTZAWsbN7RyaEr+yVDV3I2y/AggUE3maeMlcCYKs81AhCMl/LGO1lBiahSUENnbnxEPYaL9SRGJNuXWKrvbJcWW4pYxNqehg/VAMdTRGhoiGYE1Sx+694=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=O9b+/YZD; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="O9b+/YZD"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E98251E7D;
	Fri, 10 Jul 2026 08:17:27 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.2.213.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 01FC23F85F;
	Fri, 10 Jul 2026 08:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783696652; bh=x2bMRixpySIA8bXaE0N2byG8u/ToD1VsGMdDAYwuZa0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O9b+/YZDvSisRbgsHzuwT4U7jkim3TbDKLh0zyHOnwvS2D8jKQiLnRIe5dgOqx1zz
	 Mc53vLRTR3612TOmuSlWaUzbKuXxZePiIpXJPkl7mYebYGkRJX3H6rXuBbF9ZYy/xT
	 Pgfqt41E1ODrU+WkVIwYUFiSyE/C30UVbHkkO5Vk=
Date: Fri, 10 Jul 2026 16:17:28 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 17/28] KVM: arm64: Add NV3 control bits to HCRX_EL2
 sanitisation
Message-ID: <20260710151728.GE12293@e124191.cambridge.arm.com>
References: <20260702160248.1377250-1-maz@kernel.org>
 <20260702160248.1377250-18-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702160248.1377250-18-maz@kernel.org>

On Thu, Jul 02, 2026 at 05:02:37PM +0100, Marc Zyngier wrote:
> Expose the FEAT_NV3 control bits to the sanitisation code so that
> KVM stops moaning about the unattributed bits.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Joey Gouly <joey.gouly@arm.com>

> ---
>  arch/arm64/kvm/config.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 8d5e4aacf49c4..b9a9d65b973e6 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -225,6 +225,7 @@ struct reg_feat_map_desc {
>  #define FEAT_HCX		ID_AA64MMFR1_EL1, HCX, IMP
>  #define FEAT_S2PIE		ID_AA64MMFR3_EL1, S2PIE, IMP
>  #define FEAT_GCIE		ID_AA64PFR2_EL1, GCIE, IMP
> +#define FEAT_NV3		ID_AA64MMFR4_EL1, NV_frac, NV3
>  
>  static bool not_feat_aa64el3(struct kvm *kvm)
>  {
> @@ -904,6 +905,11 @@ static const DECLARE_FEAT_MAP_FGT(hdfgwtr2_desc, hdfgwtr2_masks,
>  
>  
>  static const struct reg_bits_to_feat_map hcrx_feat_map[] = {
> +	NEEDS_FEAT(HCRX_EL2_NVTGE		|
> +		   HCRX_EL2_NVnTTLB		|
> +		   HCRX_EL2_NVnTTLBIS		|
> +		   HCRX_EL2_NVnTTLBOS,
> +		   FEAT_NV3),
>  	NEEDS_FEAT(HCRX_EL2_SRMASKEn, FEAT_SRMASK),
>  	NEEDS_FEAT(HCRX_EL2_PACMEn, feat_pauth_lr),
>  	NEEDS_FEAT(HCRX_EL2_EnFPM, FEAT_FPMR),
> -- 
> 2.47.3
> 
