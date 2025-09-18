Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AC92750ED
	for <kvmarm@lists.linux.dev>; Thu, 18 Sep 2025 06:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758175662; cv=none; b=fhdbvLUSn1CBvcT0SWwRtgly2+BNZSzQFagX9+YMpnh/bZvyKQNiUzcl7PIdagR2wg3hSTGwBwc1D3hS9Q00UTN1j3ICNOwfl9j+QVHNzViso/7LPYMiCG/l1Qt8zmAlDuUVU1tHwAuu2nlyGMfiGnedtNDM051jxrDcfb45kyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758175662; c=relaxed/simple;
	bh=yMwsXpcqfTbbjk40fWwvqn9XcBKpI5TzVe2G2N02rlE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JDUTwcPsElk/S0V9+JUgdtO20oPUIzOuRtZZNTlpq1IVF/VcDGsSHshqNNWF6GT/frGgIZt8B896tvDbJQjWW+YMdNETko7qoiAVeX8rrOBS4us0ysIZUIDvKsBspCd1WThJF6Am1Gj/iZ4XJPJcfS/+W6BUuOeiDbYXqCjiA4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bpXOi0qE; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bpXOi0qE"
Date: Wed, 17 Sep 2025 23:07:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758175656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=syQQWcaVehYQIN6zPapR1D5/yZmbi0VQ1aDexidfpWM=;
	b=bpXOi0qEdNeh4GOx7Ii1VMyunAhNE59E1CrB1Iyjq1zQyDFT17I9G9twaK+exuHKLmSQ3/
	dh7WjDpvxndnHEkt+CGIC+LGLUUlS68YLt/z0rMh2GUKt2w6As4REFFqwXewHA6rUVZC4R
	iD3Trol7iojf8NdDRFxdNDRvT4GfMhE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jinqian Yang <yangjinqian1@huawei.com>
Subject: Re: [PATCH 1/8] KVM: arm64: Enforce absence of FEAT_FGT on FGT
 registers
Message-ID: <aMuhni_SDxQaAtiU@linux.dev>
References: <20250917165840.1633412-1-maz@kernel.org>
 <20250917165840.1633412-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917165840.1633412-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey,

On Wed, Sep 17, 2025 at 05:58:33PM +0100, Marc Zyngier wrote:

Did you mean to add changelogs to these patches?

> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/config.c | 201 +++++++++++++++++++++++++++-------------
>  1 file changed, 137 insertions(+), 64 deletions(-)
> 
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index da66c4a147752..42b834c82a20d 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -8,11 +8,16 @@
>  #include <asm/sysreg.h>
>  
>  struct reg_bits_to_feat_map {
> -	u64		bits;
> +	union {
> +		u64	bits;
> +		u64	*res0p;
> +	};
>  
>  #define	NEVER_FGU	BIT(0)	/* Can trap, but never UNDEF */
>  #define	CALL_FUNC	BIT(1)	/* Needs to evaluate tons of crap */
>  #define	FIXED_VALUE	BIT(2)	/* RAZ/WI or RAO/WI in KVM */
> +#define	RES0_POINTER	BIT(3)	/* Pointer to RES0 value instead of bits */
> +
>  	unsigned long	flags;
>  
>  	union {
> @@ -28,9 +33,16 @@ struct reg_bits_to_feat_map {
>  	};
>  };
>  
> -#define __NEEDS_FEAT_3(m, f, id, fld, lim)		\
> +struct reg_to_feat_map {
> +	const char				*name;
> +	const struct reg_bits_to_feat_map	feat_map;

Some documentation might help with confusion between this and
bit_feat_map. IIUC you're using a single NEEDS_FEAT() expression to RES0
the whole sucker based on whether or not the FEAT_XXX for the EL2
register is present?

> +	const struct reg_bits_to_feat_map	*bit_feat_map;
> +	const unsigned int			bit_feat_map_sz;
> +};

Ok, differentiating "reg_to_feat_map" and "reg_bits_to_feat_map" is a
bit hard on the reader... Could this maybe be called "reg_feat_map_desc"
or similar?

This refactoring could also be done as a separate patch.
 
Thanks,
Oliver
