Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E932BE650
	for <kvmarm@lists.linux.dev>; Wed, 20 Aug 2025 15:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755702694; cv=none; b=po75AKuxKTTFqlgac5HPCSopnYZgzdvcHX9DTRjdTW9Hke0vbXCbjvLNh/HFNX/aOZ2e0czhXCyEZrUsWrQXXCMwJRVNCzH2TxppKUdnVK2qrrUrgImEXr/shNwU0u2ZtZECHyd4lUZIu70rBxJge38UzY66HCXU0E5RF4WaRbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755702694; c=relaxed/simple;
	bh=VO9xsHFrbCLcnL58Q9qnzWr6MpdRTRLszsyRW06VVfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XLoOq0bUqhS/CSv/HxW4WWwKEMXjmwXc+LJ4oqQ4q2ASwJqBUgMDHc4mpnlUpCv/G067/Of8rWwTCpGoCu/Pww6nBdH4MrOCxe23+CoDS+RsqZgUQfnDn181q1xUSLGaJgHxTq8zvOmNJ1GGhm3YjkkuKfWEZqLerhdzXvaGtqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63D991D31;
	Wed, 20 Aug 2025 08:11:24 -0700 (PDT)
Received: from e133380.arm.com (e133380.arm.com [10.1.197.68])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C9CFA3F738;
	Wed, 20 Aug 2025 08:11:28 -0700 (PDT)
Date: Wed, 20 Aug 2025 16:11:25 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, broonie@kernel.org,
	oliver.upton@linux.dev, anshuman.khandual@arm.com, robh@kernel.org,
	james.morse@arm.com, mark.rutland@arm.com, joey.gouly@arm.com,
	ahmed.genidi@arm.com, kevin.brodsky@arm.com,
	scott@os.amperecomputing.com, mbenes@suse.cz,
	james.clark@linaro.org, frederic@kernel.org, rafael@kernel.org,
	pavel@kernel.org, ryan.roberts@arm.com, suzuki.poulose@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 4/5] arm64: initialise SCTLR2_EL1 at cpu_soft_restart()
Message-ID: <aKXlnZ8HXHBZMj4T@e133380.arm.com>
References: <20250813120118.3953541-1-yeoreum.yun@arm.com>
 <20250813120118.3953541-5-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250813120118.3953541-5-yeoreum.yun@arm.com>

Hi,

On Wed, Aug 13, 2025 at 01:01:17PM +0100, Yeoreum Yun wrote:
> SCTLR2_EL1 register is optional starting from ARMv8.8/ARMv9.3,
> and becomes mandatory from ARMv8.9/ARMv9.4
> and serveral architectural feature are controled by bits in
> these registers.
> 
> Before, launching new kernel via kexec, initialise SCTLR2_EL1 explicitly.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  arch/arm64/kernel/cpu-reset.S | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/kernel/cpu-reset.S b/arch/arm64/kernel/cpu-reset.S
> index c87445dde674..123564af345b 100644
> --- a/arch/arm64/kernel/cpu-reset.S
> +++ b/arch/arm64/kernel/cpu-reset.S
> @@ -37,6 +37,12 @@ SYM_TYPED_FUNC_START(cpu_soft_restart)
>  	 * regime if HCR_EL2.E2H == 1
>  	 */
>  	msr	sctlr_el1, x12
> +
> +alternative_if ARM64_HAS_SCTLR2
> +	mov_q	x12, INIT_SCTLR2_EL1
> +	msr_s	SYS_SCTLR2_EL1, x12
> +alternative_else_nop_endif
> +

It would be better to do this based on the ID regs.

Although the previous kernel _shouldn't_ have used SCTLR2 if the
capability ARM64_HAS_SCTLR2 did not get enabled, it would be better to
enforce a clean state here for the new kernel.

If so, maybe one of the macros that you already defined can be used
here?  (But it's also fine to open-code it.)

>  	isb
>  
>  	cbz	x0, 1f				// el2_switch?

[...]

In the case where the el2_switch argument in non-zero, don't we also
need to do something to reinitialise SCTLR2_EL2 after switching back
to EL2, in the HVC_SOFT_RESTART handler?

Maybe I missed something.

Cheers
---Dave
