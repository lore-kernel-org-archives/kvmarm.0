Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15CB357CE5
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 10:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783073948; cv=none; b=l6EUyLDCuHPizHICJQtPnDupy+cBJp8X25N1UhIvuCmHJBpZQJ7qPVACzDK7PASuHEaU0EpQ0fuqe13NJzXZRJVN35toAw3EBZSqKF8n/oWQ8coSnoqZYbm0Tac8fuMT4TWYCv/R/a7e1Swse9iSz0TXZEqsVydS2KwcJDk6Wow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783073948; c=relaxed/simple;
	bh=XJxFjcg6a6Ff2u/ZuI82PCDc98CFsdrms3bLSldUb/I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hUPH8j8iRkVZ9AgmNdQDVWY83wTx+6+AORc/3R79KOWkdhAP9ZA8JH1jxjGS5HNWLLIJVbQkEjTc3fH+OGudWabUyMJbhSgQQpcvgVXi98ewsIgWdjYb5ctF2puY4fw9MiRCIHZsmaUKBd6L57KWIobrI6hT1RD1An0V2+JPZBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nvyyyt2I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nvyyyt2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6C21F000E9;
	Fri,  3 Jul 2026 10:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783073946;
	bh=TYpdiRurvwlpR1iweOflMo7IYbZdi9WYeiMwVgyKAE0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nvyyyt2IXDxbwh4MmB1Q/eB8DOhjshAgZoaScfHGttbFXD+i+sqvnTE7OSxpSc1wh
	 79hBkY2gbEGQlUp/+ArER7ucvU8lVJBUE9qbz8pghs6VAZAXjoD2WnViK1yLm+2Owi
	 VysLGqrpIq0gKPv4ONdMy7jOw7CGipyhVbzfDxbPjG0yNZAti8wMDAeq8OUJ3SzCXo
	 dsFen8kweyGY11VpFbtHwceA3dwbL2gr7VA7GKiq/JDa1n8vX99hIbxUz7vp3CCbnL
	 oK1kDake2PqNOORoUqtnjlxyfmznuFhl88vP7POAR+0WLSkIvHbKrh48SdZDqsvX2d
	 kNi0Q6GhCOnPA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 15/17] arm64/nmi: Add handling of superpriority
 interrupts as NMIs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703100135.2512312-16-ruanjinjie@huawei.com>
References: <20260703100135.2512312-1-ruanjinjie@huawei.com>
 <20260703100135.2512312-16-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:19:05 +0000
Message-Id: <20260703101906.0D6C21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The early return for superpriority NMIs in `el1_interrupt()` skips=
 restoring the DAIF exception mask, leaving Debug and SError exceptions unm=
asked during the kernel exception exit sequence.
--

commit d42506f146936c84b19bd8abaf9cf4045e0c586d
Author: Mark Brown <broonie@kernel.org>

arm64/nmi: Add handling of superpriority interrupts as NMIs

This commit introduces superpriority interrupts as NMIs to allow prompt
handling of time-critical interrupts. It updates EL1 and EL0 interrupt entry
paths to check isr_el1 for superpriority status before unmasking normal
interrupts, routing them to newly added root handlers.

Link: https://lore.kernel.org/r/20221112151708.175147-13-broonie@kernel.org

> diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-c=
ommon.c
> index dc223085e7735..4115a5e7c3925 100644
> --- a/arch/arm64/kernel/entry-common.c
> +++ b/arch/arm64/kernel/entry-common.c
[ ... ]
> @@ -537,11 +549,20 @@ static __always_inline void __el1_irq(struct pt_reg=
s *regs,
> =20
>  	arm64_exit_to_kernel_mode(regs, state);
>  }
> -static void noinstr el1_interrupt(struct pt_regs *regs,
> -				  void (*handler)(struct pt_regs *))
> +static void noinstr el1_interrupt(struct pt_regs *regs, u64 nmi_flag,
> +				  void (*handler)(struct pt_regs *),
> +				  void (*nmi_handler)(struct pt_regs *))
>  {
>  	struct exception_mask mask =3D irq_entry_unmask_debug_serror(regs);
> =20
> +	if (system_uses_nmi()) {
> +		/* Is there a NMI to handle? */
> +		if (read_sysreg(isr_el1) & nmi_flag) {
> +			__el1_nmi(regs, nmi_handler);
> +			return;

[Severity: High]
Does this early return path in el1_interrupt() bypass the required
exception_exit_restore_mask(mask) call at the end of the function?

It looks like this might leave Debug and SError exceptions unmasked during =
the
kernel exception exit sequence. If an asynchronous SError or hardware
breakpoint triggers during the assembly exception return sequence after this
point, it could clobber the exception state and cause a fatal recursive fau=
lt.

> +		}
> +	}
> +
>  	if (IS_ENABLED(CONFIG_ARM64_PSEUDO_NMI) && regs_irqs_disabled(regs))
>  		__el1_pnmi(regs, handler);
>  	else

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703100135.2512=
312-1-ruanjinjie@huawei.com?part=3D15
