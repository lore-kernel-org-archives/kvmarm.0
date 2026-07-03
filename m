Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131F7358388
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 10:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783073790; cv=none; b=vBk1aXCAZGOOR515Z24rmiN9knpotOCkuOO8aYt87OPsCbytJEVFGebkx4TiQtOtMxOdRKB2wOgyvB03aHuppY/J08LW4dj7O5uzICkekluk6dlmnRu2jjjkPz/Ua7Fh1LPcXlOFGJphI0VKuak9RlhnVOMWZP/VciRhL3zFBGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783073790; c=relaxed/simple;
	bh=akJ/4WynMwhxRqSCP81P4Ru7jrSDX/553yca9nVPu8s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uWWJ0OzGUs969k8080wKFKVm36xy6FwsL7fsGvMqEIl6IK1h46PKe2LpMjykbN/D66g1bs4LwllMHu8lkjHEGxcKfh6j3jPCPApTZoHx7kCz0jgBxs8v9U2ZJJWG/uFRDOKW+9gWFHp9KPi/tydGW8GvFUEONEMy+3J8F3bSu3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FoPDlX7p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FoPDlX7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC881F000E9;
	Fri,  3 Jul 2026 10:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783073788;
	bh=RlCcnJ0T3P+C0ewWZYAbzyyc3SkEkUCDfWs5q7m6wDE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FoPDlX7pT4iwBiFR0xCO68Dc6iJ7rveTnaVzudapSkZnxilnhreghjK82VI3a4a85
	 sjCwXNNvmE8MrbPAKpqCHr89eUA4gfRRQBAx03TLNfm3RxXnspP7CpKm6Bx86P+O7F
	 S4+DBY5GKaunjnZYFAPwvyr75nOiiJ/m9bsenQFwCFZlB5IU3Xsxk6Wp0PUiFc0ARQ
	 L/LsGPqA7Vdw3qRN/fM72T89c722hdyhw/z4+tXvYbZ5OlkrHDvI6z04P0aNT+Oy++
	 PzbHH/d2flkHFNKVDJUhOwQB//qYVF8VYJ5GrU78jacDKrHn+aPOYozWm8+R85h+Vj
	 W2wjOPX51Dgmw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/17] arm64/hyp-stub: Enable access to ALLINT
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703100135.2512312-9-ruanjinjie@huawei.com>
References: <20260703100135.2512312-1-ruanjinjie@huawei.com>
 <20260703100135.2512312-9-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:16:27 +0000
Message-Id: <20260703101628.5AC881F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Missing `isb()` instruction after writing to the control-plane sys=
tem register `SYS_HCRX_EL2`.
- [High] Uninitialized register `x1` used for NMI feature check, leading to=
 dead code / skipped initialization.
--

commit e25e512407767afb5fe8ee7e72e600b4c00a8c3a
Author: Mark Brown <broonie@kernel.org>
Subject: arm64/hyp-stub: Enable access to ALLINT

This commit updates HCRX_EL2 to ensure TALLINT is not set when support
for NMIs is detected. This allows the system to use NMIs without them
being trapped.

Link: https://lore.kernel.org/r/20221112151708.175147-7-broonie@kernel.org

> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/=
el2_setup.h
> index aa8ec9df80243..73b8997f8d432 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -600,6 +600,19 @@
> =20
>  	msr_s	SYS_SMPRIMAP_EL2, xzr		// Make all priorities equal
>  .Lskip_sme_\@:
> +
> +	// NMIs
> +	__check_override id_aa64pfr1, ID_AA64PFR1_EL1_NMI_SHIFT, 4, .Linit_nmi_=
\@, .Lskip_nmi_\@, x1, x2

[Severity: High]
Is it possible that x1 is uninitialized here?

When compiled for the host kernel context, the __check_override macro
expects its first temporary register (x1) to be preloaded with the target
system register value.=20

Because this calls __check_override directly instead of using the
check_override wrapper, and lacks a preceding mrs x1, id_aa64pfr1_el1
instruction, it looks like it might evaluate leftover garbage in x1 from
the preceding SME block.=20

Could this cause the NMI setup to be silently skipped?

> +
> +.Linit_nmi_\@:
> +	mrs	x1, id_aa64mmfr1_el1		// HCRX_EL2 present?
> +	ubfx	x1, x1, #ID_AA64MMFR1_EL1_HCX_SHIFT, #4
> +	cbz	x1, .Lskip_nmi_\@
> +
> +	mrs_s	x1, SYS_HCRX_EL2
> +	and	x1, x1, # ~HCRX_EL2_TALLINT_MASK	// Don't trap ALLINT
> +	msr_s	SYS_HCRX_EL2, x1

[Severity: High]
Does this control-plane register write require synchronization?

Writes to SYS_HCRX_EL2 typically require an immediate isb() to ensure the
context synchronization event completes before subsequent instructions
execute.=20

Since this macro is expanded in callers like __finalise_el2, the
instruction immediately following this msr_s might observe undefined
pipeline state. Should an isb() be added as the very next instruction?

> +.Lskip_nmi_\@:
>  .endm
> =20
>  #endif /* __ARM_KVM_INIT_H__ */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703100135.2512=
312-1-ruanjinjie@huawei.com?part=3D8
