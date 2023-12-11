Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C62439AE5
	for <kvmarm@lists.linux.dev>; Mon, 11 Dec 2023 12:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n/SHKe9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741CEC433C9;
	Mon, 11 Dec 2023 12:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702297462;
	bh=9ZR/KI9bilrK7x+pGjSrgoz9tqBVoMt461DcppvfjDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n/SHKe9Va+B+GflMO8XbJfT7cO5ZXBoHY7bqqGFaH4e2gOG5RwkXgPXX05R+9XBpJ
	 mBaBEEWte3J0FOXdFSp84gqFQ0l6TrEiKz2oKNl/Rj9KIwof7zg7cK9ki5pU/2XpUl
	 sYUpVo7D5SsiItbVkycS857Wh9QhYl5jIIuYjC61RjAKYmgXeUk5fZArnj44xA1uJz
	 VPM2ohhYUHXwgJid4vSzXnj6NwRpv23L5qDgxe1K1kx3AS86jSPNPt8D0BKS4T0f+s
	 uYtrE24S8cXHbIN0KJ4Ah9sy66k5EG0woSLfYFmHFgo4Bm3Ikb+LKa0V11dJPFVGny
	 cm7HxOGw4ORxg==
Date: Mon, 11 Dec 2023 12:24:16 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 02/13] arm64: cpufeatures: Correctly handle signed
 values
Message-ID: <20231211122416.GA25277@willie-the-truck>
References: <20231127114559.990314-1-maz@kernel.org>
 <20231127114559.990314-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127114559.990314-3-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Nov 27, 2023 at 11:45:48AM +0000, Marc Zyngier wrote:
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
>  arch/arm64/kernel/cpufeature.c      | 65 +++++++++++++++++++++++++----
>  2 files changed, 57 insertions(+), 9 deletions(-)
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
> index 646591c67e7a..bc8787f28ffd 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -140,12 +140,42 @@ void dump_cpu_features(void)
>  	pr_emerg("0x%*pb\n", ARM64_NCAPS, &system_cpucaps);
>  }
>  
> +#define __ARM64_MAX_POSITIVE(reg, field)				\
> +		((reg##_##field##_SIGNED ?				\
> +		  BIT(reg##_##field##_WIDTH - 1) :			\
> +		  BIT(reg##_##field##_WIDTH)) - 1)
> +
> +#define __ARM64_MIN_NEGATIVE(reg, field)  BIT(reg##_##field##_WIDTH - 1)

I'm struggling to grok these two macros. For example, let's say I have a
4-bit signed field. In that case, the maximum positive value is 7 (0b0111)
and the minimum negative value is -8 (0b1000), but the macros above appear
to give 0b1000 for both.

Will
