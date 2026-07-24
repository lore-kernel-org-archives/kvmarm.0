Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBE33D966A;
	Fri, 24 Jul 2026 11:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784891648; cv=none; b=ZL7ejuRL3J8PTg355Didc7AN29cexdgpo3UCZQaxy6kGHRCAtjuMnrarlsarluQ7OQB1APLjliRyHRQTq/ASNxBjuOqRobAvEYV1YudtoRw+MVcz7GaiwkIRP1OmE8uKh6RT2JoZfTKSw8lsPjk5aGUGVxqaJWPFQiJKFx3UqVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784891648; c=relaxed/simple;
	bh=pMRPCcjl9nneZtAle9i2qbjBVV/CatUiFvTpL/FRiZM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gjDfGvBAGKvKXH5tZbyFzyNU+fyP7CJeoDXenWfMFYlVHUnaYW8Xig2SfnBnTNFxc46yCn0r6QPxuQPHfYOnBGOZ05MKMyY7fVjwIY/rChxxDnL/T/ai8SNzavlBgQcKtmriLHIuW3oCLTvkZfx98GsQQGurW+EPMwaqzw0VXcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XG4txERN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XG4txERN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DD51F01833;
	Fri, 24 Jul 2026 11:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784891646;
	bh=Kbt6JMPp9cMJ8mDKiYO7rOrtIviIoXzOWUa/QOEQyJw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XG4txERNdIEVt1QGeaGhd0Cwt/pV4LBEPmXZEITcOVMVBUbew0yVHSoCoay2jWRjH
	 gcFJNCLzj9tw2b8JPO5nWWePGgDoJZ+gGYBMVvHtshrILWM+wqDPhNHvD2GPsj0Bnh
	 X6NL6GDfDcEIgu8MQOEg0/EYjJpn5JKIwt2HJgrHw/Ji4NNBf4ohJW5rEEToB/7ymj
	 6adVisnqgb3OAR76qZmfsfis+yYrJjkWhaLogbRrjyYRU3lErZQ4VUFNIn+oHtloYf
	 8k/n5nrCJTemWiGP2/45wB0ckrESOzdeK3ZGNWLV5I+xm63A/XNTyoPF6Vr4nDG+oy
	 qsLGNdGtkYoIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 06/48] arm64/sysreg: Update ICC_CR0_EL1 with LINK and
 LINK_IDLE fields
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260724104819.1296803-7-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-7-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:14:04 +0000
Message-Id: <20260724111405.63DD51F01833@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing Context Synchronization Event (`isb()`) immediately follow=
ing writes to `ICC_*_EL1` control registers.
- [High] CONSTRAINED UNPREDICTABLE behavior risk in `GIC CDEOI` system inst=
ruction encoding.
--

--- Patch [6]: [PATCH v4 06/48] arm64/sysreg: Update ICC_CR0_EL1 with LINK =
and LINK_IDLE fields ---
commit 5e4759df2a3d62aee0191d703caed6bd54abb692
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

arm64/sysreg: Update ICC_CR0_EL1 with LINK and LINK_IDLE fields

These fields have been added to the architecture since this register
was added to the generator, and were hence missing.

> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 7cb61aca3797f..03f5e1755a633 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -3736,7 +3736,9 @@ Sysreg	ICC_CR0_EL1	3	1	12	0	1
>  Res0	63:39
>  Field	38	PID
>  Field	37:32	IPPT
> -Res0	31:1
> +Res0	31:3
> +Field	2	LINK_IDLE
> +Field	1	LINK
>  Field	0	EN
>  EndSysreg

[Severity: High]
This is a pre-existing issue, but since this patch updates the ICC_CR0_EL1
sysreg definitions, is it possible that context synchronization events are
missing after writes to these control registers?

For example, in drivers/irqchip/irq-gic-v5.c:gicv5_cpu_disable_interrupts(),
SYS_ICC_CR0_EL1 is written without an immediate isb():

drivers/irqchip/irq-gic-v5.c:gicv5_cpu_disable_interrupts() {
	cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 0);
	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
}

A similar pattern occurs in gicv5_cpu_enable_interrupts(), write_ppi_sysreg=
_s(),
and gicv5_ppi_priority_init() for registers like SYS_ICC_PCR_EL1,=20
SYS_ICC_PPI_SPENDR0_EL1, and SYS_ICC_PPI_PRIORITYR0_EL1. Is there a risk of
operating under a stale pipeline configuration if an ISB does not immediate=
ly
follow these writes?

[Severity: High]
This is a pre-existing issue, but while reviewing the GICv5 interactions,
does the CDEOI instruction encoding rely on compiler constraints instead of
hardcoding the required register?

In drivers/irqchip/irq-gic-v5.c:gicv5_handle_irq(), the instruction is
emitted using:

drivers/irqchip/irq-gic-v5.c:gicv5_handle_irq() {
	gic_insn(0, CDEOI);
}

If the compiler allocates a general-purpose register containing 0 instead of
explicitly using XZR (register 31), could this lead to a misencoded system
instruction and CONSTRAINED UNPREDICTABLE behavior?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D6
