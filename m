Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9085B384
	for <kvmarm@lists.linux.dev>; Fri, 17 Nov 2023 00:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LW8AzmmM"
Date: Thu, 16 Nov 2023 16:45:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700181974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wLCHIPPHQnh+TerLv7FNVJlueF0YzfrwwPbp4bziUuU=;
	b=LW8AzmmMGWBg2QgYvXbRyRx37Xc9DoZb+EEOIpe7eP/UAY61NHL043GDkjguuxwUcA1caj
	Ajn/AO3KAErAO6vdgvQgZ1qunyMbLl0hmad/UEGMsHmDZeTtef7X1VY0zdlJ0YtvSx7Rbj
	v5bQrVGsF3eoimfmhm9cZfCT5Q33+Vg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 01/12] arm64: cpufeatures: Correctly handle signed values
Message-ID: <ZVa3xlbovFlWc6Ai@thinky-boi>
References: <20231113174244.3026520-1-maz@kernel.org>
 <20231113174244.3026520-2-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113174244.3026520-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 13, 2023 at 05:42:33PM +0000, Marc Zyngier wrote:
> Although we've had signed values for some features such as PMUv3
> and FP, the code that handles the comparaison with some limit
> has a couple of annoying issues:
> 
> - the min_field_value is always unsigned, meaning that we cannot
>   easily compare it with a negative value
> 
> - it is not possible to have a range of values, let alone a range
>   of negative values
> 
> Fix this by:
> 
> - adding an upper limit to the comparison, defaulting to all bits
>   being set to the maximum positive value
> 
> - ensuring that the signess of the min and max values are taken into
>   account
> 
> A ARM64_CPUID_FIELDS_NEG() macro is provided for signed features, but
> nothing is using it yet.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/cpufeature.h |  1 +
>  arch/arm64/kernel/cpufeature.c      | 66 +++++++++++++++++++++++++----
>  2 files changed, 58 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index f6d416fe49b0..5f3f62efebd5 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -363,6 +363,7 @@ struct arm64_cpu_capabilities {
>  			u8 field_pos;
>  			u8 field_width;
>  			u8 min_field_value;
> +			u8 max_field_value;
>  			u8 hwcap_type;
>  			bool sign;
>  			unsigned long hwcap;
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 646591c67e7a..e52d2c2b757f 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -140,12 +140,43 @@ void dump_cpu_features(void)
>  	pr_emerg("0x%*pb\n", ARM64_NCAPS, &system_cpucaps);
>  }
>  
> +#define __ARM64_EXPAND_RFV(reg, field, val)	reg##_##field##_##val

It might be a good idea to move this to sysreg.h and share it with other
callsites that manually concatenate at the moment. I added one instance
of this to ID_REG_LIMIT_FIELD_ENUM() in sys_regs.c, for example.

Kind of a nitpick, but it'd be nice to avoid churn if the underlying
naming scheme changes in the future. Otherwise this looks reasonable
to me.

-- 
Thanks,
Oliver
