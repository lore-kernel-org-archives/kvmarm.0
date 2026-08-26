Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71215439F75
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 13:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787752045; cv=none; b=PiwkV11/PpIqyIDy2tv7F0fCZ1bwWxTovqtX7fX/ut46qrZHmVr10gZOOaF7NlpS5BTl+XjoEBq54dUIN5FykgazduigfL5sKTmWTMAHtsPl22UWxuB5BBPKMcrdhAA21bMbkZgf2LnFVM7VSPXUbtH3GIsVQcHQwfmiXy2if/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787752045; c=relaxed/simple;
	bh=0MnDj5WVVF2UqScVMHonzHxzntwHpQhPH6FsUHivT6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MPbsiuE0RAbB5R3SJcqxQNQjwZnEu0NmuIsJ/nrDhPod6iNeMqz+3nUd0DASwF+U0gUSajw/tGwU9AFdg/wM8WKb41RQgLLpXaC8Aa07s8tl3Wz5hFC5PxQHNRqYcHvXDHODz18GyCxomu+4wh9fPQby8P3QsKIUc68mZBedaXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tC5bvxId; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tC5bvxId"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C390C165C;
	Wed, 26 Aug 2026 06:47:17 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 342213F66F;
	Wed, 26 Aug 2026 06:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787752041; bh=0MnDj5WVVF2UqScVMHonzHxzntwHpQhPH6FsUHivT6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tC5bvxIdWvmRxIuRkRf6JLXg+FELB2OCTOgsxM5Q51LLmhDrWY0Dr9VUL5cQGf+Ea
	 LeK7MLeBD3kLs0MS2zzgrPNINKHEr7YtJs/S2+Lr2nSaODBYCdla5qy1jvkMNJzDtg
	 H/+O7uJjLYi/4ZhCvCYI86lWe9UMKxnFvS6gSnUA=
Date: Wed, 26 Aug 2026 14:47:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v4 1/2] arm64: Apply overrides to CPU local capabilities
Message-ID: <ao7uY-dpJocX6ety@arm.com>
References: <20260825164219.3347229-1-fuad.tabba@linux.dev>
 <20260825164219.3347229-2-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825164219.3347229-2-fuad.tabba@linux.dev>

On Tue, Aug 25, 2026 at 05:42:18PM +0100, Fuad Tabba wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> If an override has been applied, make sure we apply that for the
> secondary CPUs too, to limit the features.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Link: https://lore.kernel.org/all/afc5bd00-28ca-413b-b047-ee53589c285d@arm.com/
> Cc: stable@vger.kernel.org
> [Fuad: whitespace and comment fixes]
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

For completeness, we should add:

Fixes: b3341ae0efa2  ("arm64: cpufeature: Use IDreg override in __read_sysreg_by_encoding()")

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 9a22df0c5120f..88b15b5ef2f7f 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -1232,10 +1232,43 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
>  		init_cpu_ftr_reg(SYS_GMID_EL1, info->reg_gmid);
>  }
>  
> +/*
> + * Sanitise the register fields to clamp the values to the overrides that
> + * have been applied.
> + */
> +static u64 override_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 val)
> +{
> +	const struct arm64_ftr_bits *ftrp;
> +
> +	if (!reg || !reg->override->mask)
> +		return val;
> +
> +	for (ftrp = reg->ftr_bits; ftrp->width; ftrp++) {
> +		u64 ftr_mask = arm64_ftr_mask(ftrp);
> +		s64 ftr_val, ftr_ovr, ftr_safe;
> +
> +		/* Skip the fields not overridden */
> +		if ((ftr_mask & reg->override->mask) != ftr_mask)
> +			continue;
> +
> +		ftr_val = arm64_ftr_value(ftrp, val);
> +		ftr_ovr = arm64_ftr_value(ftrp, reg->override->val);
> +		ftr_safe = arm64_ftr_safe_value(ftrp, ftr_ovr, ftr_val);
> +
> +		if (ftr_safe != ftr_val)
> +			val = arm64_ftr_set_value(ftrp, val, ftr_safe);
> +	}
> +
> +	return val;
> +}
> +
>  static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
>  {
>  	const struct arm64_ftr_bits *ftrp;
>  
> +	/* Apply the overrides */
> +	new = override_cpu_ftr_reg(reg, new);

Not sure we need this. The init value has already been clamped, made
safe, so it won't change the result.

Otherwise:

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
