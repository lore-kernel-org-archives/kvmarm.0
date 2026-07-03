Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01BD3B6C18
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 10:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783073759; cv=none; b=jz5HuYALCsxa5pIR+SZ/OWBWBwnQuUZBzGCSRcnoFoTEk2RRgMyZiWF7/ZEgm6vPu6kszcsvxyin0x5dci/7tRIvaHFxD7KNetINNxmIUEQF0W0pbGoJJ6X2wLQGcA7y2dI4Bg0MOnVZX1xlycg+BItisz36e7p/jjbIeLX2Uaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783073759; c=relaxed/simple;
	bh=OOL+t+5P4F3Lqxoy6dRaAa0g91ml6rep7oUMQTQ8zKw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oQ+AAhcrlAgDx/eoYRvAqhTErSVVWkF9Gx8MPuC6fyyi+Zrdt2rpwfVZBfCkcSnSzprrCwdtdx3yb9K/Y/QU4poAimuXcFfDo5UZ2eudg8f2qDE1bT5ivjiHiZPI8vdS+RhUhvUeahy0aMBHznCJ/33f0VPyu7WlULTHkK3xbCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0cLU/A+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0cLU/A+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FB71F000E9;
	Fri,  3 Jul 2026 10:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783073756;
	bh=PIFWawAHhqW+xvR6etkAKAlOVO4mLL7AKAJyBTKEORw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q0cLU/A+LPNucHKs1P6/nf6NbTIifmP4Vnn8hhuRzGSXGymgAOk1igbku30czTFRa
	 3pr44JkE2oXr749voyEklwVcgvT/uza7rhS0avrqI9aN8sG6A4UEx8Z5IU8cDg7tQd
	 IGYIvo1j9tFGlNCJQkVGNU8EzkG1QSMl2eq6vTJn0hL0rKgOAxZ6iFGiSipWc5+PF5
	 l6yl3CDFfBXJjGxOdAa91+uYCHE0Rdv4arj1+W97Pk3Jv0xFsXvfQHtM811YMKBg74
	 eJE3x2u3aF/4/QSvI0ga4yMU5r4d9ysubJFG4anMR1s1syJYtqKDHeBTlQUMqEiKHR
	 IFZOmRefU1sLQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/17] arm64: Rework exception masking into abstract
 logical mask
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260703100135.2512312-3-ruanjinjie@huawei.com>
References: <20260703100135.2512312-1-ruanjinjie@huawei.com>
 <20260703100135.2512312-3-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:15:55 +0000
Message-Id: <20260703101555.E5FB71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] The `pmr` and `allint` fields of `struct exception_mask` are left =
uninitialized when hardware features are disabled, causing Undefined Behavi=
or and KMSAN panics.
- [High] Missing `__always_inline` on exception mask helpers leads to noins=
tr violations.
- [High] `arm64_make_errctx_mask` incorrectly masks pseudo-NMIs during SErr=
or handling.
- [High] Unnecessary `pmr_sync()` (DSB barrier) executes unconditionally on=
 masked restore paths.

Pre-existing issues:
- [High] Missing `isb()` after writing to the control-plane system register=
 `mdscr_el1`.
--

commit 464598f1f40c66ead1ff67f84cc61270622c7aa4
Author: Jinjie Ruan <ruanjinjie@huawei.com>

arm64: Rework exception masking into abstract logical mask

The current pseudo-NMI implementation in arm64 bodges the GICv3 PMR state
into the DAIF management code. Introduce a new abstract exception_mask
that explicitly treats DAIF, PMR, and ALLINT as separate elements to cleanly
track the exact hardware masking state.

Link: https://lore.kernel.org/linux-arm-kernel/Y5c9SLeJacLYHmP7@FVFF77S0Q05=
N/

> diff --git a/arch/arm64/include/asm/exception_masks.h b/arch/arm64/includ=
e/asm/exception_masks.h
> new file mode 100644
> index 0000000000000..0a21fb97c3ca8
> --- /dev/null
> +++ b/arch/arm64/include/asm/exception_masks.h
> @@ -0,0 +1,141 @@
[ ... ]
> +static inline struct exception_mask arm64_make_procctx_mask(void)
> +{
> +	struct exception_mask mask;
> +
> +	mask.daif =3D DAIF_PROCCTX;
> +	if (system_uses_irq_prio_masking())
> +		mask.pmr =3D GIC_PRIO_IRQON;

[Severity: High]
Does this leave the pmr field in the returned mask uninitialized when
system_uses_irq_prio_masking() is false? Returning this struct by value
might propagate garbage data and trigger use-of-uninitialized-value KMSAN
panics during exception entry paths.

> +
> +	mask.allint =3D 0;
> +
> +	return mask;
> +}
> +
> +static inline struct exception_mask arm64_make_errctx_mask(void)
> +{
> +	struct exception_mask mask;
> +
> +	mask.daif =3D DAIF_ERRCTX;
> +	if (system_uses_irq_prio_masking())
> +		mask.pmr =3D GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET;

[Severity: High]
Could this construction inadvertently mask pseudo-NMIs during system error
handling? By statically setting mask.daif =3D DAIF_ERRCTX, the I-bit is left
set, which masks NMIs at the CPU PSTATE level. The legacy code cleared the
I-bit and set PMR to GIC_PRIO_IRQOFF to allow NMIs while blocking normal
IRQs.

> +
> +	mask.allint =3D 0;
> +
> +	return mask;
> +}
[ ... ]
> +/* Mask all exceptions immediately */
> +static inline void local_exception_mask(void)
> +{

[Severity: High]
Should local_exception_mask() be marked __always_inline? If the compiler
decides not to inline it, calling it from noinstr exception entry and exit
paths (like arm64_exit_to_kernel_mode) violates noinstr constraints and
can lead to recursive panics when tracing is enabled.

> +	WARN_ON(system_has_prio_mask_debugging() &&
> +		(read_sysreg_s(SYS_ICC_PMR_EL1) =3D=3D (GIC_PRIO_IRQOFF |
> +						    GIC_PRIO_PSR_I_SET)));
[ ... ]
> +static inline void local_exception_save_mask(struct exception_mask *mask)
> +{
> +	mask->daif =3D read_sysreg(daif);
> +	if (system_uses_irq_prio_masking())
> +		mask->pmr =3D gic_read_pmr();

[Severity: High]
Is it possible this conditionally populates the mask and leaves the pmr fie=
ld
uninitialized when hardware priority masking is disabled? Since the caller
might return this struct by value, it could propagate uninitialized memory.

> +
> +	mask->allint =3D 0;
> +}
[ ... ]
> +static inline void local_exception_restore(const struct exception_mask m=
ask)
> +{

[Severity: High]
Could the lack of __always_inline on local_exception_restore() also cause
noinstr violations? Similar to local_exception_mask(), compiler heuristics
deciding to out-of-line this function would break the noinstr invariant
during exception handling.

> +	bool irq_disabled =3D mask.daif & PSR_I_BIT;
[ ... ]
> +	if (!irq_disabled)
> +		trace_hardirqs_on();
> +
> +	if (system_uses_irq_prio_masking()) {
> +		gic_write_pmr(mask.pmr);
> +		pmr_sync();
> +	}

[Severity: High]
Is this pmr_sync() execution necessary when interrupts remain disabled?
The legacy code placed the synchronization barrier inside the !irq_disabled
branch, as writing to the pmr register to mask interrupts is
architecturally self-synchronizing. Executing a pipeline-draining dsb
instruction unconditionally adds overhead on masked restore paths like
kernel exception exits.

> +
> +	write_sysreg(mask.daif, daif);
[ ... ]
> diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug=
-monitors.c
> index 29307642f4c90..5b53034428e46 100644
> --- a/arch/arm64/kernel/debug-monitors.c
> +++ b/arch/arm64/kernel/debug-monitors.c
[ ... ]
> @@ -40,10 +40,11 @@ u8 debug_monitors_arch(void)
>   */
>  static void mdscr_write(u64 mdscr)
>  {
> -	unsigned long flags;
> -	flags =3D local_daif_save();
> +	struct exception_mask mask;
> +
> +	mask =3D local_exception_save_and_mask();
>  	write_sysreg(mdscr, mdscr_el1);

[Severity: High]
This is a pre-existing issue, but does mdscr_write() require a subsequent
isb() before returning after writing to the control-plane system register
mdscr_el1? Without synchronization, the cpu pipeline might operate under an
undefined debug configuration for several cycles when reached via debug
mechanisms like ptrace.

> -	local_daif_restore(flags);
> +	local_exception_restore(mask);
>  }
>  NOKPROBE_SYMBOL(mdscr_write);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703100135.2512=
312-1-ruanjinjie@huawei.com?part=3D2
