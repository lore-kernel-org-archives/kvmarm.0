Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10756126BF1
	for <kvmarm@lists.linux.dev>; Thu,  1 May 2025 10:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746094658; cv=none; b=u1Y5mWNsAxXg1Zdy0aamE0Cggkh6bMG2Kn9YOv0Z+Q4Dl3/p/ipiPtCYggTkJUg/GvZ2s4BlgrViGpx0Ur2xoTkRkIgbTWRBpHqyOrv4ZPhLTvFwvZ8WpdtEgdaWCjjEPEF9WpbwYaad/UKA7EsBkJja7Q8FAlBjE3iyUdI5paI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746094658; c=relaxed/simple;
	bh=vO7a5PYXV1zVWqM0nrFivNPwc8aC6yEAAZw2CN1waFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZtESVNwwsLQwYO9J2mGttkDOXJ2fcEBvURF75oTkaqi8zKXIWjelvzAGBGJZMWhUpCEdtuWDSD/ZV4+P9EKig24kqr+u8ICFhmS/K14LPG6aRDjN1HnN7SLjbSNGvMj8/mwHQe1LSwV4NBbJ409CZ5BSHWi/Oa0X/Igyq9/z3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E96E71063;
	Thu,  1 May 2025 03:17:27 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7FB663F673;
	Thu,  1 May 2025 03:17:33 -0700 (PDT)
Date: Thu, 1 May 2025 11:17:30 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 13/42] arm64: Add syndrome information for trapped
 LD64B/ST64B{,V,V0}
Message-ID: <20250501101730.GF1859293@e124191.cambridge.arm.com>
References: <20250426122836.3341523-1-maz@kernel.org>
 <20250426122836.3341523-14-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250426122836.3341523-14-maz@kernel.org>

On Sat, Apr 26, 2025 at 01:28:07PM +0100, Marc Zyngier wrote:
> Provide the architected EC and ISS values for all the FEAT_LS64*
> instructions.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/esr.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index e4f77757937e6..a0ae66dd65da9 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -20,7 +20,8 @@
>  #define ESR_ELx_EC_FP_ASIMD	UL(0x07)
>  #define ESR_ELx_EC_CP10_ID	UL(0x08)	/* EL2 only */
>  #define ESR_ELx_EC_PAC		UL(0x09)	/* EL2 and above */
> -/* Unallocated EC: 0x0A - 0x0B */
> +#define ESR_ELx_EC_OTHER	UL(0x0A)
> +/* Unallocated EC: 0x0B */
>  #define ESR_ELx_EC_CP14_64	UL(0x0C)
>  #define ESR_ELx_EC_BTI		UL(0x0D)
>  #define ESR_ELx_EC_ILL		UL(0x0E)
> @@ -181,6 +182,11 @@
>  #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
>  #define ESR_ELx_xVC_IMM_MASK	((UL(1) << 16) - 1)
>  
> +/* ISS definitions for LD64B/ST64B instructions */
> +#define ESR_ELx_ISS_OTHER_ST64BV	(0)
> +#define ESR_ELx_ISS_OTHER_ST64BV0	(1)
> +#define ESR_ELx_ISS_OTHER_LDST64B	(2)
> +
>  #define DISR_EL1_IDS		(UL(1) << 24)
>  /*
>   * DISR_EL1 and ESR_ELx share the bottom 13 bits, but the RES0 bits may mean

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
