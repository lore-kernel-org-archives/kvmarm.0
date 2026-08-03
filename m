Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197343DBD5B;
	Mon,  3 Aug 2026 09:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785749050; cv=none; b=iVWf8xG3jpFMoRdf9chVZq68Vn/ojAwoPifWH36pt9E7kOlI+xMgjqcp2oOuN9P92yMSacyO6GibJlwdhf1vaBDnesA1z7/kVPi1fBo8POWAGG9trJQkQD6RkWbTCNt04nId0k9yko1LgnO3e7+mlfazmaLV2B1sCxxGtNtF5MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785749050; c=relaxed/simple;
	bh=/7HcoJR5GQ19u6GuAu06Tp/ii3tLfMUBosEC13MJJz8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cf0B+VNt37PKSvU8zXGTgFgGHH8XQxE/AcwcdZn7gtCqPzf4tS1fHXMINus1xY7JvngEbcyUdd6xAniKfdNJXF6xvMMXa8CBgb2LczkZqobZ8oSPFgbkf07vVbQXeyLFyg6+bJDGx9SK/LxzkQKz+yANd7YeHrjfdukeOpETB/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fk/MWK9g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fk/MWK9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C7E1F000E9;
	Mon,  3 Aug 2026 09:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785749048;
	bh=Xh79zzKDCqpl09g2vA5ho0/GHhk2rTU2ns2fNvakUNU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Fk/MWK9gsocBUB50UtZc7dNU9rvcdl098vrMwbJXUdhD8on88GVapLUrX4x5xJkZq
	 /U2gmLrnuHpggyGfmYHdghmaxTvnjL5CR+HhGghBNE35KsBAem7PZqckcIh5D0aIU8
	 nN9eyVp3MtsNQ/1tkn44AxGvBvXHguJyEug+D5qA0nkr4Y2iWdia4tVjeBj2DkjjW/
	 Mv5pw/cLzPbZXjff8ug3HwndscSMsBEtt+/eYGKtPif14SCH7gBpIqHkv0IYbKICQA
	 e7AfQpBsscK5fsvhncb2GMNonHNqRw81cHwxvBuF9AZAKpqM0a2elJ6NiUimiVEuqr
	 tK/haoL0sa6/g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] arm64: errata: Add NXP iMX8QM workaround for A53
 cache coherency issue
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?UGVuZyBGYW4gKE9TUyk=?= <peng.fan@oss.nxp.com>
Cc: Frank.Li@kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, imx@lists.linux.dev
In-Reply-To: <20260803-imx8qm-cache-coherency-v3-1-c518d0da3d3b@nxp.com>
References: <20260803-imx8qm-cache-coherency-v3-1-c518d0da3d3b@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 09:24:08 +0000
Message-Id: <20260803092408.69C7E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Trapping EL0 cache maintenance instructions breaks AArch32 compat =
applications because compat trap handlers are not implemented.
- [High] Missing Context Synchronization Event (ISB) immediately after writ=
ing to the SCTLR_EL1 control-plane system register.
--

--- Patch [1]: [PATCH v3] arm64: errata: Add NXP iMX8QM workaround for A53 =
cache coherency issue ---
commit ea6ce757f778ea074d9d845a9b2aa0e396e921d8
Author: Peng Fan <peng.fan@nxp.com>
Subject: arm64: errata: Add NXP iMX8QM workaround for A53 cache coherency i=
ssue

This patch adds a workaround for the i.MX8QM cache coherency issue ERR05010=
4.
It downgrades targeted TLBI operations to broadcast-all variants, upgrades
IC IVAU to IC IALLUIS for kernel and userspace, and disables KVM.

Link: https://lore.kernel.org/all/20230420112952.28340-1-iivanov@suse.de/
Link: https://www.nxp.com/docs/en/errata/IMX8_1N94W.pdf

> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errat=
a.c
> index 5db8f0619e4bc..4ba68c1f29b29 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c

> [ ... ]

> @@ -200,6 +202,28 @@ cpu_enable_cache_maint_trap(const struct arm64_cpu_c=
apabilities *__unused)
>  	sysreg_clear_set(sctlr_el1, SCTLR_EL1_UCI, 0);
>  }
> =20
> +#ifdef CONFIG_NXP_IMX8QM_ERRATUM_ERR050104
> +static bool
> +is_imx8qm_soc(const struct arm64_cpu_capabilities *entry, int scope)
> +{
> +	WARN_ON(preemptible());
> +
> +	return of_machine_is_compatible("fsl,imx8qm");
> +}
> +
> +static void
> +cpu_enable_imx8qm_err050104(const struct arm64_cpu_capabilities *__unuse=
d)
> +{
> +	cpu_enable_cache_maint_trap(__unused);

[Severity: High]
This is a pre-existing issue, but does trapping EL0 cache maintenance
instructions break AArch32 compat applications here?

The cpu_enable_cache_maint_trap() function clears SCTLR_EL1.UCI, which
causes EL0 cache maintenance instructions to trap to EL1. While AArch64
instructions trap as ESR_ELx_EC_SYS64 and are handled by
user_cache_maint_handler(), AArch32 CP15 instructions trap as
ESR_ELx_EC_CP15_32.

Looking at cp15_32_hooks[] in arch/arm64/kernel/traps.c, it lacks definitio=
ns
to catch trapped AArch32 CP15 cache maintenance instructions. This means the
trap falls through to do_el0_undef() which injects SIGILL, crashing valid
AArch32 userspace applications on affected systems.

[Severity: High]
This is also a pre-existing issue in cpu_enable_cache_maint_trap(), but does
the call here extend an unsynchronized execution window?

cpu_enable_cache_maint_trap() updates SCTLR_EL1 but misses the required
context synchronization event (isb) immediately after the write:

cpu_enable_cache_maint_trap()
    sysreg_clear_set(sctlr_el1, SCTLR_EL1_UCI, 0);
    /* missing isb() */

When called from cpu_enable_imx8qm_err050104(), execution continues to
kvm_disable_mode() without a barrier.

The ARM64 subsystem guidelines state that every write to a control-plane
system register must be followed by an isb() as the very next instruction,
otherwise the CPU operates under a stale configuration for several cycles.

> +
> +	/*
> +	 * TLB maintenance cannot be guaranteed correct for guests, so
> +	 * disable KVM as if kvm-arm.mode=3Dnone was passed on the command line.
> +	 */
> +	kvm_disable_mode();
> +}
> +#endif

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803-imx8qm-cac=
he-coherency-v3-1-c518d0da3d3b@nxp.com?part=3D1
