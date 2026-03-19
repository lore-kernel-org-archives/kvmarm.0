Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88BC0391E72
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 17:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773941918; cv=none; b=J7yo4de4OXtXfVr4++wbfQ1MrK+9raH/duj8RzSbDpXme1vdv7Aa3IGusccydviKZV4mZMPK9mCz+IQmygAGJrTiUFR5Ir+vqQXgi2qjpxBJo9EO/rosM3ggfPEvo3+yE+IZbGUyqpfnUZ+yKKDaiU+8KmmXQzBXvEyF2GCJMeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773941918; c=relaxed/simple;
	bh=3fkMLmiY/1+Pjxhlr18iH2quTT6g5owce7pjUEMOb2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dKyzdumRGAGJLM4rQRJ+kO2eXbKghnX+juBoCL5IqE6SN3bqyYV6LQ7OPDaFUqC2/TOeJ98dtlXn3MH9oQXxY1jLgfJasTKzGgX/J4gO6LgeuoFHQNJGMa8t1vS3ecnnmeUSbG/qEDwVc2VDXxlX3rgAyitO2Sv4asY9upmvdqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 89A0D2247;
	Thu, 19 Mar 2026 10:38:25 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0DCF03F778;
	Thu, 19 Mar 2026 10:38:29 -0700 (PDT)
Date: Thu, 19 Mar 2026 17:38:27 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 03/11] arm64: Add logic to fully remove features from
 sanitised id registers
Message-ID: <abw0k4V_RROnqkUQ@arm.com>
References: <20260302115653.1517326-1-maz@kernel.org>
 <20260302115653.1517326-4-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302115653.1517326-4-maz@kernel.org>

On Mon, Mar 02, 2026 at 11:56:44AM +0000, Marc Zyngier wrote:
> We currently make support for some features such as Pointer Auth,
> SVE or S1POE a compile time decision.
> 
> However, while we hide that feature from userspace when such support
> is disabled, we still leave the value provided by the HW visible to
> the rest of the kernel, including KVM.
> 
> This has the potential to result in ugly state leakage, as half of
> the kernel knows about the feature, and the other doesn't.
> 
> Short of completely banning such compilation options and restore
> universal knowledge, introduce the possibility to fully remove such
> knowledge from the sanitised id registers.

I wouldn't oppose to it really. If there are features affecting the
kernel compilation (e.g. kasan/mte), we need configs but for most
features I don't think we should bother, especially if they don't
take significantly more code/data memory when not present. It makes it
easier for us to reason about.

Of course, I'd keep the command-line overriding, it helps with
debugging.

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 102c5bac4d502..965dd2acf0640 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -192,7 +192,7 @@ void dump_cpu_features(void)
>  #define __ARM64_FTR_BITS(SIGNED, VISIBLE, STRICT, TYPE, SHIFT, WIDTH, SAFE_VAL) \
>  	{						\
>  		.sign = SIGNED,				\
> -		.visible = VISIBLE,			\
> +		.visibility = VISIBLE,			\
>  		.strict = STRICT,			\
>  		.type = TYPE,				\
>  		.shift = SHIFT,				\
> @@ -1063,16 +1063,33 @@ static void init_cpu_ftr_reg(u32 sys_reg, u64 new)
>  				ftrp->shift);
>  		}
>  
> -		val = arm64_ftr_set_value(ftrp, val, ftr_new);
> -
>  		valid_mask |= ftr_mask;
>  		if (!ftrp->strict)
>  			strict_mask &= ~ftr_mask;
> -		if (ftrp->visible)
> +
> +		switch (ftrp->visibility) {
> +		case FTR_VISIBLE:
> +			val = arm64_ftr_set_value(ftrp, val, ftr_new);
>  			user_mask |= ftr_mask;
> -		else
> +			break;
> +		case FTR_ALL_HIDDEN:
> +			/*
> +			 * ALL_HIDDEN and HIGHER_SAFE are incompatible.
> +			 * Only hide from userspace, and log the oddity.
> +			 */
> +			if (WARN_ON(ftrp->type == FTR_HIGHER_SAFE))
> +				val = arm64_ftr_set_value(ftrp, val, ftr_new);
> +			else
> +				val = arm64_ftr_set_safe_value(ftrp, val);
>  			reg->user_val = arm64_ftr_set_safe_value(ftrp,
>  								 reg->user_val);

IIUC, if a feature is now disabled in .config and marked as
FTR_ALL_HIDDEN, we end up with a 0 field in the sanitised sysreg (or
whatever the safe value is). We now have a discrepancy between VHE and
nVHE in finalise_el2_state. The check_override_idreg macro uses the
sanitised sysregs for nVHE and the actual hw ones with VHE. Maybe not an
issue in the cases you are targeting but it's something that may bite us
in the future.

One ugly workaround is to add #ifdefs or .ifs to el2_setup.h. A slightly
better one (I think) would be to force the above visibility into the
override masks/values rather than adding FTR_ALL_HIDDEN. Let the
override checks end up with a safe value.

And, of course, my preferred way would be to drop this config-based
visibility altogether ;).

-- 
Catalin
