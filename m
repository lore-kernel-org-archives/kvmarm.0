Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2446A371072
	for <kvmarm@lists.linux.dev>; Fri,  3 Jul 2026 10:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074011; cv=none; b=rp6hHJ/4NUl2LJMG2pf//q5h6T+8Z27kgiiHgIxg4p6pC34RSnPKnS+V4flxJFWex2yBcLhkBGgRbR46tcKsAawOvPi0exhzRN/zmqFs75HRNesr3d8byyYccwxPBx9fT8AHLKrnKUEzV8fDBHrcdrdDWm/hBQf5a03Tz6oJpTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074011; c=relaxed/simple;
	bh=Mrjgxa4s7ivgXnID9SQpxnZQ4zuPKRtXCoZCN4NEwto=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XoYJMOUS7tZRuYPc6UcNlegTTzf6MjBUF39HRTccMmVdnI7epsATY572yw61R/ccdD5o5rd7xe1YNqc8VoOVyqh2UsgVmC2gDDgW3DwphEHzxz+5a8bJhweICTqmnDAY8ke1ZZ/LRGPTx8ziYbnnNkTn0aXz/w7WWr0qQb/KAJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rim4htuI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rim4htuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716041F000E9;
	Fri,  3 Jul 2026 10:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783074009;
	bh=VwDPrRij7dU8Pt2h1IkiZmIbd5ofO7MadBXGEuFcW5U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rim4htuIxFyFzkuIgBWqiwI3wxTZ9PMzg+FVlQrnOtR2PDLDmfShdspzk5mcgz+Xn
	 ikwnnpaQlYTfUKfpJH4kMEO4ORxo65wLo6S8Joe3ioebkDRj56B4KZeUHuLZJXY4iz
	 Mqe3gzz8hgsqwRPYPsG3CekHST1kGXxHyH8ZPI3ZTxsaG4ouXQE4+gMwpSgbb//76p
	 lDRAXs6sJEufCtw+JILnDN6whtcSt29WosejRWnMYCcltS/ugFn+U3wqCV45gu2i+R
	 llzWOiZje8J6EkxcaG2KVPko7rizl8G8y6yfV6fnq5poHeAV6Dp8MMPuzNe6SEQs6H
	 G9HUCLz141qIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 09/17] arm64/idreg: Add an override for FEAT_NMI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703100135.2512312-10-ruanjinjie@huawei.com>
References: <20260703100135.2512312-1-ruanjinjie@huawei.com>
 <20260703100135.2512312-10-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:20:08 +0000
Message-Id: <20260703102009.716041F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Missing `isb()` after writing to the `SYS_HCRX_EL2` control system=
 register in the `finalise_el2_state` macro.
- [Medium] The EL2 setup logic for FEAT_NMI unconditionally fails because `=
__check_override` operates on a garbage value instead of the actual `id_aa6=
4pfr1_el1` register.
--

commit e25e512407767afb5fe8ee7e72e600b4c00a8c3a
Author: Mark Brown <broonie@kernel.org>

arm64/hyp-stub: Enable access to ALLINT

This commit updates HCRX_EL2 to ensure that TALLINT is not set when support
for NMIs is detected. This prevents traps from being enabled for NMIs,
allowing them to be used properly.

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

[Severity: Medium]
Could this inadvertently bypass the NMI setup by using __check_override
instead of check_override?

Because __check_override expects the hardware register value to already be
loaded into x1, and it isn't loaded here, x1 contains leftover data from the
preceding SME checks.

As a result, the bitfield extraction will always evaluate to 0,
unconditionally skipping the .Linit_nmi_\@ block and nullifying this
initialization.

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
Is an isb instruction required immediately after writing to the SYS_HCRX_EL2
control register here?

Because the finalise_el2_state macro immediately terminates, the CPU will
execute subsequent instructions without a context synchronization event.
For instance, in arch/arm64/kvm/hyp/nvhe/hyp-init.S:

__kvm_init_el2_state:
    init_el2_state
    finalise_el2_state
    ret

The ret instruction will execute against undefined pipeline state before the
new configuration is synchronized.

> +.Lskip_nmi_\@:
>  .endm
> =20
>  #endif /* __ARM_KVM_INIT_H__ */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703100135.2512=
312-1-ruanjinjie@huawei.com?part=3D9
