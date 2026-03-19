Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C3D37E2E6
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 13:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773927148; cv=none; b=Fu+oWmWJ4g6dVUQqYJl3a6y+x+n/b0VHWkSrQ8vzw0DRb7aqGxLLd5j8A6TLpYsZNG9OxxDmFxaTgXqO3XXfK6ZyC0qK9bHfFNsvysMS4WDLmTJCyC9+by/7dubbkelko1AUjIoI1BZ6CUYjJjgdpdC+MVe87ScTkbR4vqvhV0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773927148; c=relaxed/simple;
	bh=fv2RZ8oUz3S5TdoJKUecgYfd31nIaoj1pTV8+h7c6G4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K89UcRD4M/1xIHLkh4Ty3JOgQfWiTvUQdZJ9wOCQQVAl1BR9L090Nd5xJ6ndzoLs48ENV2oCs5QqHQLWKkZgmsNiQ0nsZLQcIjZcZTLiWKT8loa8f9THtvT/4UW6E5VbwDkPgrcV21Kq4DGPxLa8IKForxkhSt12y9KEmLgL8+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJfkiQ62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJfkiQ62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E42C2BCB0;
	Thu, 19 Mar 2026 13:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773927148;
	bh=fv2RZ8oUz3S5TdoJKUecgYfd31nIaoj1pTV8+h7c6G4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PJfkiQ62e2TWYYLFZ5sLrfZL+iiRJgGOIFBHm1ggmiWFHV1dUtQRYOfIoOlYSObcJ
	 rojT+BUKZpSZ/UDou3AWVJhMc7ycc/wL7sBNLMdiHqJAygYMCruYsgV63B5qUAMWY9
	 wYdIcxuSCRDhYXXy30y0apf5axHdmax60FORjONvGriBrJpxNL90OFm9kCevI7IrDg
	 CLRXtwfxVbx4jbf6HUit+5PvVwNW92Vcfx4X01vgpRf0MlxXD6uuK5iL6+hUhCrUTe
	 55uEzr5eMVVFkrddu63safROg6lEf3Ll7ioZh9OoY/HV5nS6Ho0dGJJJHxn5aviKLj
	 utSiDICey+iCw==
Date: Thu, 19 Mar 2026 13:32:22 +0000
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 3/4] arm64: errata: Work around early CME DVMSync
 acknowledgement
Message-ID: <abv65n3fhvYDEez0@willie-the-truck>
References: <20260318191918.2653160-1-catalin.marinas@arm.com>
 <20260318191918.2653160-4-catalin.marinas@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318191918.2653160-4-catalin.marinas@arm.com>

Hi Catalin,

Just a handful of minor comments below.

Are you planning to take this for 7.1 or would you like me to take it
via for-next/fixes? I'm leaning towards the former so it can simmer in
-next for a bit...

On Wed, Mar 18, 2026 at 07:19:15PM +0000, Catalin Marinas wrote:
> C1-Pro acknowledges DVMSync messages before completing the SME/CME
> memory accesses. Work around this by issuing an IPI to the affected CPUs
> if they are running in EL0 with SME enabled.
> 
> Note that we avoid the local DSB in the IPI handler as the kernel runs
> with SCTLR_EL1.IESB=1 This is sufficient to complete SME memory accesses
> at EL0 on taking an exception to EL1. On the return to user path, no
> barrier is necessary either. See the comment in sme_set_active() and the
> more detailed explanation in the link below.

Missing link?

> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/Kconfig                | 12 +++++
>  arch/arm64/include/asm/cpucaps.h  |  2 +
>  arch/arm64/include/asm/cputype.h  |  2 +
>  arch/arm64/include/asm/fpsimd.h   | 21 ++++++++
>  arch/arm64/include/asm/mmu.h      |  1 +
>  arch/arm64/include/asm/tlbflush.h | 22 +++++++++
>  arch/arm64/kernel/cpu_errata.c    | 30 ++++++++++++
>  arch/arm64/kernel/entry-common.c  |  3 ++
>  arch/arm64/kernel/fpsimd.c        | 81 +++++++++++++++++++++++++++++++
>  arch/arm64/kernel/process.c       |  7 +++
>  arch/arm64/tools/cpucaps          |  1 +
>  11 files changed, 182 insertions(+)

nit: Please update Documentation/arch/arm64/silicon-errata.rst

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 38dba5f7e4d2..f07cdb6ada08 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1175,6 +1175,18 @@ config ARM64_ERRATUM_4311569
>  
>  	  If unsure, say Y.
>  
> +config ARM64_ERRATUM_SME_DVMSYNC

Any reason not to call this ARM64_ERRATUM_4193714 like we do for other
hardware bugs?

> +	bool "C1-Pro: 4193714: SME DVMSync early acknowledgement"
> +	depends on ARM64_SME
> +	default y
> +	help
> +	  Enable workaround for C1-Pro acknowledging the DVMSync before
> +	  the SME memory accesses are complete. This would cause TLB
> +	  maintenance for processes using SME to also issue an IPI to
> +	  the affected CPUs.

s/would/will/

> +
> +	  If unsure, say Y.
> +
>  config CAVIUM_ERRATUM_22375
>  	bool "Cavium erratum 22375, 24313"
>  	default y
> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index 177c691914f8..d0e6cff93876 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -64,6 +64,8 @@ cpucap_is_possible(const unsigned int cap)
>  		return IS_ENABLED(CONFIG_ARM64_WORKAROUND_REPEAT_TLBI);
>  	case ARM64_WORKAROUND_SPECULATIVE_SSBS:
>  		return IS_ENABLED(CONFIG_ARM64_ERRATUM_3194386);
> +	case ARM64_WORKAROUND_SME_DVMSYNC:
> +		return IS_ENABLED(CONFIG_ARM64_ERRATUM_SME_DVMSYNC);
>  	case ARM64_MPAM:
>  		/*
>  		 * KVM MPAM support doesn't rely on the host kernel supporting MPAM.
> diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
> index 08860d482e60..7b518e81dd15 100644
> --- a/arch/arm64/include/asm/cputype.h
> +++ b/arch/arm64/include/asm/cputype.h
> @@ -98,6 +98,7 @@
>  #define ARM_CPU_PART_CORTEX_A725	0xD87
>  #define ARM_CPU_PART_CORTEX_A720AE	0xD89
>  #define ARM_CPU_PART_NEOVERSE_N3	0xD8E
> +#define ARM_CPU_PART_C1_PRO		0xD8B
>  
>  #define APM_CPU_PART_XGENE		0x000
>  #define APM_CPU_VAR_POTENZA		0x00
> @@ -189,6 +190,7 @@
>  #define MIDR_CORTEX_A725 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A725)
>  #define MIDR_CORTEX_A720AE MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A720AE)
>  #define MIDR_NEOVERSE_N3 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_N3)
> +#define MIDR_C1_PRO MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_C1_PRO)
>  #define MIDR_THUNDERX	MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX)
>  #define MIDR_THUNDERX_81XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_81XX)
>  #define MIDR_THUNDERX_83XX MIDR_CPU_MODEL(ARM_CPU_IMP_CAVIUM, CAVIUM_CPU_PART_THUNDERX_83XX)

I'd probably do the CPU part as a separate patch, as folks often backport
those once they get multiple users in the tree (e.g. for perf or other
errata).

> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index 1d2e33559bd5..129c29aa0fc4 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -428,6 +428,24 @@ static inline size_t sme_state_size(struct task_struct const *task)
>  	return __sme_state_size(task_get_sme_vl(task));
>  }
>  
> +void sme_enable_dvmsync(void);
> +void sme_set_active(unsigned int cpu);
> +void sme_clear_active(unsigned int cpu);
> +
> +static inline void sme_enter_from_user_mode(void)
> +{
> +	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_SME_DVMSYNC) &&
> +	    test_thread_flag(TIF_SME))
> +		sme_clear_active(smp_processor_id());
> +}
> +
> +static inline void sme_exit_to_user_mode(void)
> +{
> +	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_SME_DVMSYNC) &&
> +	    test_thread_flag(TIF_SME))
> +		sme_set_active(smp_processor_id());
> +}

nit: You could push smp_processor_id() down into sme_{set,clear}_active()
since they are always called for the running CPU.

Will
