Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE793B7B96
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 10:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783073873; cv=none; b=prBc5jlYfxiCjlPUuOWK82nLblOtBK2DDSliThziPjONIWGO2pMgDX1Xwue8kBF2oVBWOkYlKRxpJoAG2/ONBhdaar3h5ZN5DEiaYl/wQNuB2o2bKfv3Mvf8QrmlzWYLuE1mL3NkBCxIGUhVa918m0NhMuy8RLe3dOLy/G6KuKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783073873; c=relaxed/simple;
	bh=3TCBPOzM6DBTGylMkiw4tsthr8gbTWmvhH+J1h7xFaQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jVDK4jjs68APQh+E/2tNue+yGXcPyks8cpGgOzrhAgyPGBZjA2Vov+fucH+7eol+Pp4D+W9HK1kYvEDAQHQTSpCuttv6iabBIUzRRkhwVNUJrY0nd1Db58nwk8v3WNTlqr3/VjZQBactaE0XJTozSNc9wSlimrxJrKyvPG03sqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y8rd1Ge4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y8rd1Ge4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076651F000E9;
	Fri,  3 Jul 2026 10:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783073871;
	bh=nF8SIk1n9ZTyDQko1532Rk5Ga5etMwMv060Cd3BBq1Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y8rd1Ge4jGuYzTbVXNO7e+/wvL1qtZi11oaBeLB+aBNGckoIRMlznUKUgd7earhuv
	 Fz2fXgeqcyPgSXkrlbOh/+s0NyvNxdv28uwCuQ2HlFJdYuVHG+77STnV89hAIIkOHe
	 XoJPfmZmoezmNlgQ7vKeQQxdxPtcdxG1VO30jrb8brEF3urmTOOTMel2ViO1Hkw982
	 gD9Mv6uG+FtzcKCIpQSVht4CcX0jQvBBL2yvKnryjFyDOZinrVMm2YRupTlvZrcmkr
	 dayjvqTdsptxRHepjrAej7QduOrR+hR8nAE2zPqN8PV9OGanUpPHPGl9KD+4uDeKmR
	 Xj9SEriaU68wA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/17] arm64: entry: Add entry-specific helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260703100135.2512312-5-ruanjinjie@huawei.com>
References: <20260703100135.2512312-1-ruanjinjie@huawei.com>
 <20260703100135.2512312-5-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:17:50 +0000
Message-Id: <20260703101751.076651F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [Medium] The new exception mask abstraction introduces unnecessary system=
 register reads on exception entry that are immediately discarded, causing =
overhead on hot paths.
- [Medium] exception_exit_restore_mask() fails to restore PMR and ALLINT, d=
irectly contradicting its explicit description in the commit message.

Pre-existing issues:
- [High] Missing pmr_sync() barrier on the PMR unmasking path in local_exce=
ption_inherit().
--

commit 2feb968bf7f065e9063df058fc7166adcf349514
Author: Jinjie Ruan <ruanjinjie@huawei.com>
Date:   Fri Jul 3 10:01:22 2026 +0000

arm64: entry: Add entry-specific helpers

The existing hacks to bodge pseudo-NMI into the DAIF management code
are convoluted and difficult to maintain. To pave the way for real
hardware NMI support (FEAT_NMI) without compounding the existing
complexity, we need to abstract the low-level exception masking
and unmasking operations into entry-specific helpers.

Link: https://lore.kernel.org/linux-arm-kernel/Y5c9SLeJacLYHmP7@FVFF77S0Q05=
N/

> diff --git a/arch/arm64/include/asm/exception_masks.h b/arch/arm64/includ=
e/asm/exception_masks.h
> index 0a21fb97c3ca8..2c87f7c90f628 100644
> --- a/arch/arm64/include/asm/exception_masks.h
> +++ b/arch/arm64/include/asm/exception_masks.h

[ ... ]

> +static __always_inline struct exception_mask el1_sync_entry_unmask_inher=
it(struct pt_regs *regs)
> +{
> +	struct exception_mask orig;
> +
> +	local_exception_save_mask(&orig);
> +	local_exception_inherit(regs);

[Severity: High]
This is a pre-existing issue, but does local_exception_inherit() miss a
required pmr_sync() barrier?

When el1_sync_entry_unmask_inherit() calls local_exception_inherit(), it
writes regs->pmr to ICC_PMR_EL1 to unmask interrupts:

	if (system_uses_irq_prio_masking())
		gic_write_pmr(regs->pmr);

Unmasking interrupts via PMR typically requires a pmr_sync() barrier (DSB) =
so
the priority change is immediately visible to the GIC redistributor. Without
this barrier, the redistributor might delay interrupt delivery.

> +
> +	return orig;
> +}

[ ... ]

> +/*
> + * Mask all exceptions, ready to return to interrupted context
> + */
> +static __always_inline void exception_exit_restore_mask(struct exception=
_mask mask)
> +{
> +	write_sysreg(mask.daif, daif);
> +}

[Severity: Medium]
Does this function fully match its description in the commit message?

The commit message states that exception_exit_restore_mask() restores both
the DAIF and PMR states:

"- exception_exit_restore_mask(): A unified exit-side helper to safely
   restore the hardware exception mask states (DAIF and PMR)..."
  =20
However, the implementation only restores DAIF and drops the PMR and ALLINT
states. While kernel_exit and eret might handle those separately in practic=
e,
the documented API contract seems inconsistent with the implementation.

> diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-c=
ommon.c
> index 6fdf74ff48352..dc223085e7735 100644
> --- a/arch/arm64/kernel/entry-common.c
> +++ b/arch/arm64/kernel/entry-common.c

[ ... ]

> @@ -824,7 +849,7 @@ static void noinstr el0_interrupt(struct pt_regs *reg=
s,
>  {
>  	arm64_enter_from_user_mode(regs);
> =20
> -	write_sysreg(DAIF_PROCCTX_NOIRQ, daif);
> +	irq_entry_unmask_debug_serror(regs);

[Severity: Medium]
Does discarding the return value of irq_entry_unmask_debug_serror()
introduce unnecessary overhead on the hot EL0 interrupt path?

irq_entry_unmask_debug_serror() calls local_exception_save_mask(), which
executes multiple volatile 'mrs' instructions to read DAIF, PMR, and ALLINT.
Since these reads are performed via asm volatile, the compiler cannot optim=
ize
them out even though the returned exception_mask is ignored here.

> =20
>  	if (regs->pc & BIT(55))
>  		arm64_apply_bp_hardening();

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703100135.2512=
312-1-ruanjinjie@huawei.com?part=3D4
