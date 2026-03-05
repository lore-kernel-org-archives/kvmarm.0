Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5C53A451C
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721138; cv=none; b=de3F+ZtujV2ULeiydzVq/AlTUZHgkcak68yzvFwNKhghFR3pfD5z//s/OsPcWxTnwTMhjs60TSrVGOUKyQ9VQcZ1B3JT/kO8GSoeXP19D4XXMGZYZKrRK1+dHneDI0m5Z0r6OlFa7JLAxKTwk1I2vH/gh96gbyP68GqQ+B9AyAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721138; c=relaxed/simple;
	bh=BDxRqGoVPIAZP5jThA2TA1n7z0JYbMMJCM69Dd0B96Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uWWlQlfpsVMcjU8LVABAR/rOi0LP+AW33PWv8VEME2P0/CBbBrNkr79tNpUQSv68H6XX41Oc7dfCMcE3D1VC8zS0cRR42snqaJtJZy2XQ6yRNwa2bgRw0f57unU+dZMRft7RWLx5mTrHaNzT8bFs20HhAMM/UKKvzmChTz51GbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6BMuB0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6BMuB0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A87C116C6;
	Thu,  5 Mar 2026 14:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721137;
	bh=BDxRqGoVPIAZP5jThA2TA1n7z0JYbMMJCM69Dd0B96Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f6BMuB0LQdQojB3SzJVF9cI/GNdjZ45yhkZv+0JndOxbsgW6Vl/hDYpq0QPcMKtYZ
	 SY9Q4MyF0P76suZ/AszzmZNjB3ZXonECq1868uUCyaw9UvQ+b2JL2ytjyiliWXUr0c
	 F69z9IR4flhpaVv7sz5fsNLsttVVpefU+nUnlB+2I6v0tWq5YQBT668+Yb+v1VWxuC
	 1gV+MRpdNXgdgZGIDOHHMQC/dVJZkI/dBQtEjEzrro4Q9jiMHyS3+waWrW4FtDhqWe
	 h4cM2WIlOqd+ScCMfHaahf7CsHuKlMbiqLva0QDQcxzbPH5MODVf3X3+mjXp/nNtK3
	 EC0FX8Hsh+S9Q==
Date: Thu, 5 Mar 2026 14:32:11 +0000
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/4] arm64: errata: Work around early CME DVMSync
 acknowledgement
Message-ID: <aamT6-Mvr9nI1unq@willie-the-truck>
References: <20260302165801.3014607-1-catalin.marinas@arm.com>
 <20260302165801.3014607-4-catalin.marinas@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302165801.3014607-4-catalin.marinas@arm.com>

On Mon, Mar 02, 2026 at 04:57:56PM +0000, Catalin Marinas wrote:
> C1-Pro acknowledges DVMSync messages before completing the SME/CME
> memory accesses. Work around this by issuing an IPI+DSB to the affected
> CPUs if they are running in EL0 with SME enabled.

Just to make sure I understand the implications, but this _only_ applies
to explicit memory accesses from the SME unit and not, for example, to
page-table walks initiated by SME instructions?

> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/Kconfig                | 12 +++++
>  arch/arm64/include/asm/cpucaps.h  |  2 +
>  arch/arm64/include/asm/cputype.h  |  2 +
>  arch/arm64/include/asm/fpsimd.h   | 29 +++++++++++
>  arch/arm64/include/asm/mmu.h      |  1 +
>  arch/arm64/include/asm/tlbflush.h | 17 +++++++
>  arch/arm64/kernel/cpu_errata.c    | 19 ++++++++
>  arch/arm64/kernel/entry-common.c  |  3 ++
>  arch/arm64/kernel/fpsimd.c        | 81 +++++++++++++++++++++++++++++++
>  arch/arm64/kernel/process.c       |  7 +++
>  arch/arm64/tools/cpucaps          |  1 +
>  11 files changed, 174 insertions(+)

[...]

> @@ -575,6 +576,14 @@ static const struct midr_range erratum_spec_ssbs_list[] = {
>  };
>  #endif
>  
> +#ifdef CONFIG_ARM64_ERRATUM_SME_DVMSYNC
> +static void cpu_enable_sme_dvmsync(const struct arm64_cpu_capabilities *__unused)
> +{
> +	if (this_cpu_has_cap(ARM64_WORKAROUND_SME_DVMSYNC))
> +		sme_enable_dvmsync();
> +}
> +#endif
> +
>  #ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_38
>  static const struct midr_range erratum_ac03_cpu_38_list[] = {
>  	MIDR_ALL_VERSIONS(MIDR_AMPERE1),
> @@ -901,6 +910,16 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
>  		.matches = need_arm_si_l1_workaround_4311569,
>  	},
>  #endif
> +#ifdef CONFIG_ARM64_ERRATUM_SME_DVMSYNC
> +	{
> +		.desc = "C1-Pro SME DVMSync early acknowledgement",
> +		.capability = ARM64_WORKAROUND_SME_DVMSYNC,
> +		.cpu_enable = cpu_enable_sme_dvmsync,
> +		/* C1-Pro r0p0 - r1p2 (the latter only when REVIDR_EL1[0]==0 */
> +		ERRATA_MIDR_RANGE(MIDR_C1_PRO, 0, 0, 1, 2),
> +		MIDR_FIXED(MIDR_CPU_VAR_REV(1, 2), BIT(0)),
> +	},
> +#endif

An alternative to this workaround is just to disable SME entirely, perhaps
by passing 'arm64.nosme' on the cmdline. Maybe we should disable the
workaround in that case?

> @@ -1358,6 +1360,85 @@ void do_sve_acc(unsigned long esr, struct pt_regs *regs)
>  	put_cpu_fpsimd_context();
>  }
>  
> +#ifdef CONFIG_ARM64_ERRATUM_SME_DVMSYNC
> +
> +/*
> + * SME/CME erratum handling
> + */
> +static cpumask_var_t sme_dvmsync_cpus;
> +static cpumask_var_t sme_active_cpus;
> +
> +void sme_set_active(unsigned int cpu)
> +{
> +	if (!cpus_have_final_cap(ARM64_WORKAROUND_SME_DVMSYNC))
> +		return;
> +	if (!cpumask_test_cpu(cpu, sme_dvmsync_cpus))
> +		return;
> +
> +	if (!test_bit(ilog2(MMCF_SME_DVMSYNC), &current->mm->context.flags))
> +		set_bit(ilog2(MMCF_SME_DVMSYNC), &current->mm->context.flags);
> +
> +	cpumask_set_cpu(cpu, sme_active_cpus);
> +
> +	/*
> +	 * Ensure subsequent (SME) memory accesses are observed after the
> +	 * cpumask and the MMCF_SME_DVMSYNC flag setting.
> +	 */
> +	smp_mb();

I can't convince myself that a DMB is enough here, as the whole issue
is that the SME memory accesses can be observed _after_ the TLB
invalidation. I'd have thought we'd need a DSB to ensure that the flag
updates are visible before the exception return.

> +void sme_do_dvmsync(void)
> +{
> +	/*
> +	 * This is called from the TLB maintenance functions after the DSB ISH
> +	 * to send hardware DVMSync message. If this CPU sees the mask as
> +	 * empty, the remote CPU executing sme_set_active() would have seen
> +	 * the DVMSync and no IPI required.
> +	 */
> +	if (cpumask_empty(sme_active_cpus))
> +		return;
> +
> +	preempt_disable();
> +	smp_call_function_many(sme_active_cpus, sme_dvmsync_ipi, NULL, true);
> +	preempt_enable();
> +}

Why do we care about all CPUs using SME, rather than limiting it to the
set of CPUs using SME with the mm we've invalidated? This looks like it
will result in unnecessary cross-calls when multiple tasks are using SME
(especially as the mm flag is only cleared on fork).

Will
