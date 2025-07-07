Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21EA322B8A6
	for <kvmarm@lists.linux.dev>; Mon,  7 Jul 2025 16:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751907526; cv=none; b=ZnjkqJaWwMffBrELW6NWRpBWUVucXYAS2zOKppmdvg5jtTpYoAY267lUt1znv0nAuhCpG7JwJnBScnXjNvjDhg+kzBsueJHFqBp54cqXYSR4w3I2b12moWN6A1y1lVOZ9qexYOcxrrFZedeKH/dv8Y0ExTlbnSS4PEiq76HF6KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751907526; c=relaxed/simple;
	bh=lY8irBtYxVyHLKyGJiGCmG2opDnFdh+FVadST8BlZQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IsrxdTVZKhG9Pu66bilLrt0uEcY99X/K1d1tMKcYPlMUKDDPpRAFIGtEInZdNrvMMubeGTPRmjBpkigZbJdfTSihZAleR90hY8O74Na6jz+GT84WHz6v4AMbxYzjO5IEcF5CP5YoxHDkGglxuUwe7A9k1Yv4Le9d6mZzdnGks5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 405C6168F;
	Mon,  7 Jul 2025 09:58:32 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 093CC3F66E;
	Mon,  7 Jul 2025 09:58:40 -0700 (PDT)
Date: Mon, 7 Jul 2025 17:58:38 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Shuah Khan <shuah@kernel.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 07/22] perf: arm_pmuv3: Generalize counter bitmasks
Message-ID: <aGv8vgrZTET0aXjQ@J2N7QTR9R3>
References: <20250626200459.1153955-1-coltonlewis@google.com>
 <20250626200459.1153955-8-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250626200459.1153955-8-coltonlewis@google.com>

On Thu, Jun 26, 2025 at 08:04:43PM +0000, Colton Lewis wrote:
> The OVSR bitmasks are valid for enable and interrupt registers as well as
> overflow registers. Generalize the names.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

FWIW, this looks fine to me, so:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  drivers/perf/arm_pmuv3.c       |  4 ++--
>  include/linux/perf/arm_pmuv3.h | 14 +++++++-------
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> index 6358de6c9fab..3bc016afea34 100644
> --- a/drivers/perf/arm_pmuv3.c
> +++ b/drivers/perf/arm_pmuv3.c
> @@ -513,7 +513,7 @@ static u64 armv8pmu_pmcr_n_read(void)
>  
>  static int armv8pmu_has_overflowed(u64 pmovsr)
>  {
> -	return !!(pmovsr & ARMV8_PMU_OVERFLOWED_MASK);
> +	return !!(pmovsr & ARMV8_PMU_CNT_MASK_ALL);
>  }
>  
>  static int armv8pmu_counter_has_overflowed(u64 pmnc, int idx)
> @@ -749,7 +749,7 @@ static u64 armv8pmu_getreset_flags(void)
>  	value = read_pmovsclr();
>  
>  	/* Write to clear flags */
> -	value &= ARMV8_PMU_OVERFLOWED_MASK;
> +	value &= ARMV8_PMU_CNT_MASK_ALL;
>  	write_pmovsclr(value);
>  
>  	return value;
> diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
> index d698efba28a2..fd2a34b4a64d 100644
> --- a/include/linux/perf/arm_pmuv3.h
> +++ b/include/linux/perf/arm_pmuv3.h
> @@ -224,14 +224,14 @@
>  				 ARMV8_PMU_PMCR_LC | ARMV8_PMU_PMCR_LP)
>  
>  /*
> - * PMOVSR: counters overflow flag status reg
> + * Counter bitmask layouts for overflow, enable, and interrupts
>   */
> -#define ARMV8_PMU_OVSR_P		GENMASK(30, 0)
> -#define ARMV8_PMU_OVSR_C		BIT(31)
> -#define ARMV8_PMU_OVSR_F		BIT_ULL(32) /* arm64 only */
> -/* Mask for writable bits is both P and C fields */
> -#define ARMV8_PMU_OVERFLOWED_MASK	(ARMV8_PMU_OVSR_P | ARMV8_PMU_OVSR_C | \
> -					ARMV8_PMU_OVSR_F)
> +#define ARMV8_PMU_CNT_MASK_P		GENMASK(30, 0)
> +#define ARMV8_PMU_CNT_MASK_C		BIT(31)
> +#define ARMV8_PMU_CNT_MASK_F		BIT_ULL(32) /* arm64 only */
> +#define ARMV8_PMU_CNT_MASK_ALL		(ARMV8_PMU_CNT_MASK_P | \
> +					 ARMV8_PMU_CNT_MASK_C | \
> +					 ARMV8_PMU_CNT_MASK_F)
>  
>  /*
>   * PMXEVTYPER: Event selection reg
> -- 
> 2.50.0.727.gbf7dc18ff4-goog
> 
