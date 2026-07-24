Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E613B47C4
	for <kvmarm@lists.linux.dev>; Fri, 24 Jul 2026 08:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784882596; cv=none; b=D/8cS5xk/L6St0meQXIkbsRXitRapEZUC4dhZnqY18ptJm5vDRef2EWINx/72wyRH4msDZCnaT7AHWQQC62kfvZkTncrHnqWYdd8RlsmY2A+YQeKjj7Ww1BeQJM7+M715qG0VjzhU3l6k1ibWLNIj/mp6f8hap2njNFoY1oKddM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784882596; c=relaxed/simple;
	bh=l5NvuKA/TMN0CQnv1qdbO7xX8bCXL+N19B+G8UN53XE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p6lxqhMOpb4Nm6v7PLXvbSMcSkwFdeBBMcAJPhzNyXCz8pCiW/xRJ0pLLHxeZpw5tnxCVtWogC5gAxoaF6H6JKu8mvgDFsIAEzKC5ay8uL0wMt86gPXZy4xGvzuuC5E2zmoajlCrG+jZfvEiHR7mn4TEovw4w/d3J4O6gKTKwis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ZOU7NpM9; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ZOU7NpM9"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1784882591; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=lg/EcGAZSO+Qz1w6Fca62WR0QTsDRF+HEAtmCs/sfmg=;
	b=ZOU7NpM9q6eLzcX3mhbJpndZaa2QvjIaIarItdNcj/T/2LY/VUi2wzl7UBvuHeWCKV8RMPAKedXZWs8miHXq1CRz9hbSePDVJYBhpzbrVQXz0YS1/hzt5wJwRIsMUib8blEW2kQxsDU+fRIBknX0Q9pKF2V+XpI0GAYL2TPtat4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=yaoyuan@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X7icg7Y_1784882590;
Received: from localhost(mailfrom:yaoyuan@linux.alibaba.com fp:SMTPD_---0X7icg7Y_1784882590 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Jul 2026 16:43:10 +0800
Date: Fri, 24 Jul 2026 16:43:10 +0800
From: Yao Yuan <yaoyuan@linux.alibaba.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Steffen Eiden <seiden@linux.ibm.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 27/28] KVM: arm64: Expose FEAT_NV3 to guests
Message-ID: <kw7jdrvszacuvzvgdwqooxqgzgvf2wjhf6heddnuydjr6vthlz@qqt63cqorpiq>
References: <20260722074234.3330999-1-maz@kernel.org>
 <20260722074234.3330999-28-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722074234.3330999-28-maz@kernel.org>

On Wed, Jul 22, 2026 at 08:42:33AM +0800, Marc Zyngier wrote:
> Further enable FEAT_NV3 by making it visible to NV guests.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/nested.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index f646894fec9a9..70d605e60cfb3 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1728,7 +1728,7 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
>  		 * You get EITHER
>  		 *
>  		 * - FEAT_VHE without FEAT_E2H0
> -		 * - FEAT_NV limited to FEAT_NV2(p1)
> +		 * - FEAT_NV limited to FEAT_NV2(p1)/NV3
>  		 * - HCR_EL2.NV1 being RES0
>  		 *
>  		 * OR
> @@ -1741,7 +1741,9 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
>  			val = 0;
>  		} else {
>  			val &= ID_AA64MMFR4_EL1_NV_frac;
> -			if (cpus_have_final_cap(ARM64_HAS_NV2P1))
> +			if (cpus_have_final_cap(ARM64_HAS_NV3))
> +				val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV3);
> +			else if (cpus_have_final_cap(ARM64_HAS_NV2P1))

Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>

>  				val = ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64MMFR4_EL1, NV_frac, NV2P1);
>  			else
>  				val = SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, NV_frac, NV2_ONLY);
> --
> 2.47.3
