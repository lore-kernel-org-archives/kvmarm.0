Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1632C3B4432
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 10:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074447; cv=none; b=mBPpy5Sycqhy65671MGd7Ik5LxR9WbT7qSztLJ59k9omVEsMXB6Ebpq40+8hkAJqldLCCsNeoS9Yih7HOZGUg4lAmlEt6HTr5MDgVpnbz4+/sliYT7BpgiHMM2+cK3xFsLg7A+Z1nSlq/a1UHH6mTSCj7bhSU4Z8EekLDSkf68A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074447; c=relaxed/simple;
	bh=V7aliVCKrH+2PKOBxNFT2n07OZBT6KnC0ON46xZrQuQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mZ/QGFlKShJrUFKBCo/SPaltmmCFnUJGV1fthHElzn+2xeRglZOTpOoELdnFCZfxmXo8/kvDCM+DgpJYm5Lh//bsVZmclVMiwehG3E81H0Ht0gZbELrByD2KbCuuU9Ykub4qO7Q+S4GDiQm6Hha0eowq7WdXatBFqcJ7tkpxLWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RVQFJgk3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RVQFJgk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A47D1F000E9;
	Fri,  3 Jul 2026 10:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783074445;
	bh=EjlkIEM/4xX3K205S7KioqEyN19nQCsxa5ftMsqHKwA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RVQFJgk3ygTL5io4mJeVE1LmzIDDGjZWH0RQaewMH36P40AloAbYit2NA6T2bwP8X
	 UcaeHqoVgNHCF4W3rwd9Di6yjDOJOkVEIEYl1dM/Pj4N0OV02kBeeHxQI41h379uGU
	 r87EOR9XTXxZVtT1PbhbtPD/+KhMBLp9uvH2LkXNLtax/OeXwoq36ShxAGyx/4vFco
	 4zTwwqWqwGbBd9rlbUJ/FTyeOhQRYQc+joOZuOP4tHUwKvj69yOLUiVngVH+MPdm13
	 gNNL2VE4XMhXNilguXhr+jtgpZK7HnFTPzrc2JUmpRlMI9LJASScJTDtpcyjSuFVFz
	 TRlwtXuDaIumQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 12/17] arm64/nmi: Manage masking for superpriority
 interrupts along with DAIF
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703100135.2512312-13-ruanjinjie@huawei.com>
References: <20260703100135.2512312-1-ruanjinjie@huawei.com>
 <20260703100135.2512312-13-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:27:25 +0000
Message-Id: <20260703102725.7A47D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Kprobes IRQ flag save/restore drops ALLINT state, inadvertently un=
masking NMIs upon return.
- [High] `exception_exit_restore_mask` fails to restore the `allint` field,=
 leaving NMIs unmasked during critical exception exit.
- [Medium] Returning `struct exception_mask` by value copies uninitialized =
memory when `system_uses_nmi()` is false.
--

commit 0abc1ecd8853e1c8db5ff01b3c4dad448c23b517
Author: Mark Brown <broonie@kernel.org>

arm64/nmi: Manage masking for superpriority interrupts along with DAIF

This patch updates DAIF management routines to also mask and unmask=20
superpriority interrupts (NMIs) when asynchronous exceptions are handled.=20
It modifies both inline C functions and assembly macros to track and=20
restore the ALLINT state.

Link: https://lore.kernel.org/r/20221112151708.175147-11-broonie@kernel.org

> diff --git a/arch/arm64/include/asm/exception_masks.h b/arch/arm64/includ=
e/asm/exception_masks.h
> index fbbba769ca031..3dd41998f705c 100644
> --- a/arch/arm64/include/asm/exception_masks.h
> +++ b/arch/arm64/include/asm/exception_masks.h
[ ... ]
> @@ -87,7 +94,8 @@ static inline void local_exception_save_mask(struct exc=
eption_mask *mask)
>  	if (system_uses_irq_prio_masking())
>  		mask->pmr =3D gic_read_pmr();
> =20
> -	mask->allint =3D 0;
> +	if (system_uses_nmi())
> +		mask->allint =3D read_sysreg_s(SYS_ALLINT);
>  }

[Severity: Medium]
Does this leave mask->allint uninitialized on systems where system_uses_nmi=
()
is false?

When local_exception_save_and_mask() allocates mask on the stack and return=
s=20
it by value, returning the struct with an uninitialized field could copy=20
uninitialized memory and trigger KMSAN warnings.

[ ... ]
> @@ -118,6 +126,9 @@ static inline void local_exception_restore(const stru=
ct exception_mask mask)
>  		pmr_sync();
>  	}
> =20
> +	if (system_uses_nmi())
> +		write_sysreg_s(mask.allint, SYS_ALLINT);
> +
>  	write_sysreg(mask.daif, daif);

[Severity: High]
Does exception_exit_restore_mask() also need to be updated to restore the=20
allint field?

Unlike local_exception_restore(), it appears exception_exit_restore_mask() =
was
not updated to restore SYS_ALLINT, which might leave NMIs unmasked during=20
exception exit paths when returning to user or kernel mode.

[ ... ]
> diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probe=
s/kprobes.c
> index 70d311e415ac9..8045245ebbdde 100644
> --- a/arch/arm64/kernel/probes/kprobes.c
> +++ b/arch/arm64/kernel/probes/kprobes.c
> @@ -197,12 +197,19 @@ static void __kprobes kprobes_save_local_irqflag(st=
ruct kprobe_ctlblk *kcb,
>  {
>  	kcb->saved_irqflag =3D regs->pstate & DAIF_MASK;
>  	regs->pstate |=3D DAIF_MASK;
> +
> +	if (system_uses_nmi())
> +		regs->pstate |=3D ALLINT_ALLINT;
>  }
> =20
>  static void __kprobes kprobes_restore_local_irqflag(struct kprobe_ctlblk=
 *kcb,
>  						struct pt_regs *regs)
>  {
>  	regs->pstate &=3D ~DAIF_MASK;
> +
> +	if (system_uses_nmi())
> +		regs->pstate &=3D ~ALLINT_ALLINT;
> +
>  	regs->pstate |=3D kcb->saved_irqflag;

[Severity: High]
Does this sequence inadvertently drop the ALLINT state and permanently unma=
sk=20
NMIs upon returning from the kprobe?=20

In kprobes_save_local_irqflag(), DAIF_MASK does not include ALLINT_ALLINT, =
so=20
the original NMI mask state is not saved in kcb->saved_irqflag. When=20
kprobes_restore_local_irqflag() later clears ALLINT_ALLINT and restores=20
saved_irqflag, any previously masked NMIs could become unexpectedly unmaske=
d.

>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703100135.2512=
312-1-ruanjinjie@huawei.com?part=3D12
