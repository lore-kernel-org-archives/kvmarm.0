Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3B6D1FBEAB
	for <kvmarm@lists.linux.dev>; Tue, 11 Feb 2025 12:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739276595; cv=none; b=F6mtbuGA01tMVxqshvrMarEzS495OaR0lvNM8MeQfTjitL7EeH4qFDsWVgBa2uhynjZcIZLuQ63sgCH/8ByheVkTVq8A49mATVv5SQ6Owc8MqScHOtNi6B/5/hceiV7WlUieAo5Huo564k0ziedEeo6FjrzmSJRZS9EMoWpfZHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739276595; c=relaxed/simple;
	bh=WYbPqzeflxnkGcTvDdUhO/YJKcv6y3fF1K7+EzKaJgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TzjPE1bywRcYF4kyy4j9A9Hf+5W1xI41xyZbWVVQuA70CxvBi8qJjwOTidFdd0MXp86Xi3cH7+YGc9RBhBbWKcMWonmLCR2c4p7k0yighKtDfIiPMpxJ/TIU4GKo/5ySxT2gkbWZlVpSWBFcYceeuKb7g6OI8i6bB2EP80dWDxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 729301424;
	Tue, 11 Feb 2025 04:23:33 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8026A3F6A8;
	Tue, 11 Feb 2025 04:23:10 -0800 (PST)
Date: Tue, 11 Feb 2025 12:23:08 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 02/18] arm64: Add syndrome information for trapped
 LD64B/ST64B{,V,V0}
Message-ID: <Z6tBLIsEejdCRQKP@J2N7QTR9R3>
References: <20250210184150.2145093-1-maz@kernel.org>
 <20250210184150.2145093-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210184150.2145093-3-maz@kernel.org>

On Mon, Feb 10, 2025 at 06:41:33PM +0000, Marc Zyngier wrote:
> Provide the architected EC and ISS values for all the FEAT_LS64*
> instructions.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/esr.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index d1b1a33f9a8b0..d5c2fac21a16c 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -20,7 +20,8 @@
>  #define ESR_ELx_EC_FP_ASIMD	UL(0x07)
>  #define ESR_ELx_EC_CP10_ID	UL(0x08)	/* EL2 only */
>  #define ESR_ELx_EC_PAC		UL(0x09)	/* EL2 and above */
> -/* Unallocated EC: 0x0A - 0x0B */
> +#define ESR_ELx_EC_LS64B	UL(0x0A)

This EC code has been generalised recently. In the latest ARM ARM (ARM
DDI 0487 L.a), which can be found at:

  https://developer.arm.com/documentation/ddi0487/la/?lang=en

... the table on page D24-7333 refers to it as:

| Trapped execution of any instruction not covered by other EC values.

... and the corresponding ISS description is named:

| ISS encoding for an exception from any other instruction

... so maybe it makes sense to call it 'ESR_ELx_EC_OTHER_INSN',
'ESR_ELx_EC_INSN_MISC', or something of that rough shape?

With that, the PSB CSYNC oddity in patch 15 makes a bit more sense,
though the L.a release of the ARM ARM is still missing the description
of that.

Mark.

> +/* Unallocated EC: 0x0B */
>  #define ESR_ELx_EC_CP14_64	UL(0x0C)
>  #define ESR_ELx_EC_BTI		UL(0x0D)
>  #define ESR_ELx_EC_ILL		UL(0x0E)
> @@ -174,6 +175,11 @@
>  #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
>  #define ESR_ELx_xVC_IMM_MASK	((UL(1) << 16) - 1)
>  
> +/* ISS definitions for LD64B/ST64B instructions */
> +#define ESR_ELx_ISS_ST64BV	(0)
> +#define ESR_ELx_ISS_ST64BV0	(1)
> +#define ESR_ELx_ISS_LDST64B	(2)
> +
>  #define DISR_EL1_IDS		(UL(1) << 24)
>  /*
>   * DISR_EL1 and ESR_ELx share the bottom 13 bits, but the RES0 bits may mean
> -- 
> 2.39.2
> 
