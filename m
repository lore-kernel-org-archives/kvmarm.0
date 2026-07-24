Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B494908CA
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 06:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784873812; cv=none; b=FyavcP2jUHv4w7HBhqhueGUEOFPhPyr+QubgrysvbEC/LUDs8+lqZmfkS6yDO2IwolrPUS8R0qqiOx7nnnPInI6mW1Pw3OXLDU+0FEbq2m7ZwyoxAPURx+6lco5jVYjD58cwrbmKt1bqmT7iIfm/5iFQQEWLMLrBn4Q0e2B4Va8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784873812; c=relaxed/simple;
	bh=vxES7cHybLG/UVSGP1XrqkYyzggNhlIUBrwkKRJmCvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j2yOUAFXxrZUWLvDVrSIgveXrbVyMehqIgEeMr1cgsyI5a1rRT98KCrBYIggxTsFX4sICyEog5h++QFLxYxz4XEGUNo6hQvj3asUo1eySWBUDzgo2/KYrAh4yyOArK/0Y4YEUtrUHgSiA/mOTQ/RVDih7kOBc5ntS3kLamClvfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=RIS83Uzx; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="RIS83Uzx"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784873807; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=zC7eAhDlNrYkTxhODTTpYL33+TbjyH7/GlX2hOaaZfE=;
	b=RIS83Uzxga5DZUFL52Z36227mmpJ4CMqhRJnR0NJAt5Jo7DnkEzEFCUt9RUEVkPKw+OY4w+XWz5Dhy9iGySsQfK/1rXHsE6u5AW7j+Har+sGh4Jqjd/e6cHwYtxMgoofsY8USRo8qtgtBI22mH3jhpqVtKxD31KNtUupojQcB+8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X7iD4Pd_1784873806;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X7iD4Pd_1784873806 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Jul 2026 14:16:46 +0800
Date: Fri, 24 Jul 2026 14:16:46 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 20/28] KVM: arm64: Add sanitisation for NVHCR_EL2
Message-ID: <vtyzpvpqv2fbzldllzcbsks3sd7ktkwwylatmeeibfmchqydyh@pxhok4n4mswr>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-21-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722074234.3330999-21-maz@kernel.org>

On Wed, Jul 22, 2026 at 08:42:26AM +0800, Marc Zyngier wrote:
> Just like any other VNCR-based register, NVHCR_EL2 requires some
> level of sanitisation. Being specified as a live copy of HCR_EL2,
> it adopts the exact same format, but depends on FEAT_NV3 instead.
>
> A subtle aspect is that we only want to apply the sanitisation if
> FEAT_NV3 is actually present, as the VNCR location is otherwise
> used to back accesses to HCR_EL2.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/config.c | 15 +++++++++++++++
>  arch/arm64/kvm/nested.c |  4 ++++
>  2 files changed, 19 insertions(+)
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 467f57eb8e6bb..1053676551aff 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -1019,6 +1019,9 @@ static const struct reg_bits_to_feat_map hcr_feat_map[] = {
>  static const DECLARE_FEAT_MAP(hcr_desc, HCR_EL2,
>  			      hcr_feat_map, FEAT_AA64EL2);
>
> +static const DECLARE_FEAT_MAP(nvhcr_desc, NVHCR_EL2,
> +			      hcr_feat_map, FEAT_NV3);
> +
>  static const struct reg_bits_to_feat_map sctlr2_feat_map[] = {
>  	NEEDS_FEAT(SCTLR2_EL1_NMEA	|
>  		   SCTLR2_EL1_EASE,
> @@ -1393,6 +1396,7 @@ void __init check_feature_map(void)
>  	check_reg_desc(&hdfgwtr2_desc);
>  	check_reg_desc(&hcrx_desc);
>  	check_reg_desc(&hcr_desc);
> +	check_reg_desc(&nvhcr_desc);
>  	check_reg_desc(&sctlr2_desc);
>  	check_reg_desc(&tcr2_el2_desc);
>  	check_reg_desc(&sctlr_el1_desc);
> @@ -1592,6 +1596,17 @@ struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
>  	case HCR_EL2:
>  		resx = compute_reg_resx_bits(kvm, &hcr_desc, 0, 0);
>  		break;
> +	case NVHCR_EL2:
> +		/*
> +		 * Only apply sanitisation if we do have FEAT_NV3.
> +		 * Otherwise, the register aliases with HCR_EL2 in VNCR,
> +		 * and we're better off relying on data transfers between
> +		 * NVHCR_EL2 and HCR_EL2 to sanitise things.
> +		 */
> +		resx = (kvm_has_nv3(kvm) ?
> +			compute_reg_resx_bits(kvm, &nvhcr_desc, 0, 0) :
> +			(typeof(resx)){});
> +		break;

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>  	case SCTLR2_EL1:
>  	case SCTLR2_EL2:
>  		resx = compute_reg_resx_bits(kvm, &sctlr2_desc, 0, 0);
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 35a1c42ad3f84..f646894fec9a9 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1830,6 +1830,10 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
>  	resx = get_reg_fixed_bits(kvm, HCR_EL2);
>  	set_sysreg_masks(kvm, HCR_EL2, resx);
>
> +	/* NVHCR_EL2 */
> +	resx = get_reg_fixed_bits(kvm, NVHCR_EL2);
> +	set_sysreg_masks(kvm, NVHCR_EL2, resx);
> +
>  	/* HCRX_EL2 */
>  	resx = get_reg_fixed_bits(kvm, HCRX_EL2);
>  	set_sysreg_masks(kvm, HCRX_EL2, resx);
> --
> 2.47.3
