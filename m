Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793990740;
	b=MaUFvVCTJ3Yrf8z8nDzt1imIuD0clVJgEtQDOu/URpbgLcz+y2kVGfvbcoPjdLHnYTQB
	 pHyv83F8P/mYFT+cToEwzpMcbmZrNX1yxGjMI/FTltZ3xxbefAzyp8thetzMCa71ml71Z
	 QtbPDanf6RvmICc+BW1t4cyIFDCGH5Cdtl1atAXJFpYjaDGNBtuChzQH/MvprviiO2DPK
	 JNl6HhrCZpkJZadJ/Jm0b2+d+RxiyhPpwNHi7lDlBPcxVrYwk9fv08X7+SzwlHn9ud2wl
	 W3zmh6ixKyhdgdsB+whYFaKVbHRx+ouqgyqmAfl0aDA0IAOCy4cypYVKmEGG69bQjxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793990740;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YcVL0KVdIR13xuFxbLtjWlunqJdQQts29PYNVmC5UnA=;
	b=0AUlj48neEo4XBiS8GMfzVZIauLVZVbxaHU1NuG8joiSh5p2j9X8X0/DHD/EuNM+N+l2
	 /yRDr6quWVWlwdTp1kuvEQw+EZj8GXm3oWdku32NlPLnxTBY1gg8od7xKVuRJJZ/ao2nG
	 40QVk9RJ+wIg6FnCzldpH9kSPTWTHaMjJUOxYGTnKCW8otIHuiTa9+nXkJWE98XCTSVDE
	 f0C4zjflOKDdKzoTKO8C5sV6e7X7dsRbL5X16UhmWu46NUgpDREWzKGhzNfBBUep6ZgVK
	 nqzZ/3SbTgebIFt5iEymK6QmqimK0Kv62OOd9+qVC7g6PUVET6AoJmwvDa+2qjoTp8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L8fenafk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E81606A329
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 18:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L8fenafk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921EE1F0089F;
	Fri,  6 Nov 2026 18:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793990739;
	bh=YcVL0KVdIR13xuFxbLtjWlunqJdQQts29PYNVmC5UnA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L8fenafkAsvog9T1ScbsXjBKzog4TOnCyB/E/mrADJ+C46/cgS/3ja1Ug7m4C6hTj
	 d/zwy/M9PH03xKVsBuc3gb24gDd18ImBG8x+sOVSWqjzVZJ5OKAtgzTLoRAh2/l02m
	 ZnZOO1yumvr4C4r3GGhy2sz23abgd/9Atq2Z3VjVuLXCve+p5gwefsdskbfWXt4z6J
	 2PWp1Rf3rSVwDOI3vXAL00l3yYSdTob5IDFD4oT9MUaXAlS4wkLn88UBftx+f5RSkI
	 RJ119LcnxTVio3dIFntDtR2z1pWIwQCPp01VhsxcLRYnC75dB5pYdst4OnFDSGN3Z8
	 Tsz5NTddDXzcA==
Message-ID: <sashiko-outbox-202094@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6/8] KVM: arm64: Add sys_reg_descs for remaining MTE
 CMO instructions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
Cc: "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20261106183154.3590825-7-oupton@kernel.org>
References: <20261106183154.3590825-1-oupton@kernel.org>
 <20261106183154.3590825-7-oupton@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 18:45:39 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] KVM: arm64: possible missing MTE_CMO_INSN entries for DC GVA and
  DC GZVA
--

commit c80fdbddf913183cac8f63dfc60ce6f48445eafa
Author: Oliver Upton <oupton@kernel.org>

KVM: arm64: Add sys_reg_descs for remaining MTE CMO instructions

This commit adds MTE_CMO_INSN descriptors with mte_visibility to
sys_insn_descs[] for MTE cache maintenance instructions trapped by
HCR_EL2.TPCP so that they inject an UNDEFINED exception when MTE is not
enabled for the VM.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index b456354713443..7f7a197a9ad6b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
[ ... ]
> @@ -4394,6 +4403,15 @@ static struct sys_reg_desc sys_insn_descs[] =3D {
>  	SYS_INSN(TLBI_VALE1NXS, handle_tlbi_el1),
>  	SYS_INSN(TLBI_VAALE1NXS, handle_tlbi_el1),
> =20
> +	MTE_CMO_INSN(DC_CGVAC, bad_cmo_trap),
> +	MTE_CMO_INSN(DC_CGDVAC, bad_cmo_trap),
> +	MTE_CMO_INSN(DC_CGVAP, bad_cmo_trap),
> +	MTE_CMO_INSN(DC_CGDVAP, bad_cmo_trap),
> +	MTE_CMO_INSN(DC_CGVADP, bad_cmo_trap),
> +	MTE_CMO_INSN(DC_CGDVADP, bad_cmo_trap),
> +	MTE_CMO_INSN(DC_CIGVAC, bad_cmo_trap),
> +	MTE_CMO_INSN(DC_CIGDVAC, bad_cmo_trap),

[Severity: Low]
This question rests on an architecture detail that could not be confirmed
from the kernel source: can SYS_DC_GVA and SYS_DC_GZVA trap to EL2 via
HCR_EL2.TDZ or HFGITR_EL2.DCZVA when MTE is not enabled for the VM?

If so, encoding_to_cgt[] maps both instructions to CGT_HCR_TDZ and
encoding_to_fgt[] maps them to HFGITR_EL2.DCZVA, which is marked NEVER_FGU
in config.c because the trap bit is shared with SYS_DC_ZVA.  Without
MTE_CMO_INSN entries for SYS_DC_GVA and SYS_DC_GZVA in sys_insn_descs[],
triage_sysreg_trap() has neither an FGU bit nor a visibility() callback to
filter them, and will forward traps from a nested guest to L1 when L1 sets
HCR_EL2.TDZ or HFGITR_EL2.DCZVA instead of injecting an UNDEFINED
exception.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106183154.3590=
825-1-oupton@kernel.org?part=3D6
