Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C398417BF4
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 13:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784555190; cv=none; b=EpG9WSpn12GrVRUc+foDVvBp5PlZMINgCPWPmos66vrP8hRdbsD0z9YwmE36k3ymtZjTWDR/sPn3GGChfeOFBI3OmAyVMpGThOHWTJG7H5S4BEVWn1Dwks6390H3pEmMC3u1zg+Her9b6wxX/lxcHq3AL9OXLzRnsxGsAbSAWHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784555190; c=relaxed/simple;
	bh=SD2AzjNuKTBHYb+tlxYrvv0KFrXtIkocVzRV70q7GQ0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gA7CeuWq7TefDvhB2MDXPSzljF2/mjkcGSq/efih+eVD1guzDPWjn9isw1s/lq2kk4s3wdbqWwzHhfYbH3xnmbWKSUMo1Dbk9wGn3BNjUM3UwdFzCZCQB2e7dflpSbk1tvPTMHRJNvRQEC3X4nmJgCZ/NYzYtbuYDni2CGqwN+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I6tl0J3L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I6tl0J3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB071F000E9;
	Mon, 20 Jul 2026 13:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784555189;
	bh=maxdV5RBiYNc8z1UZi7COYNzudGCSaXvXdiMl2NJnPI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I6tl0J3Ln+KrOFgfSxXzqKv2WZTD3tuuaw2rxiKyGgr5OmArx0NRm2TkrzRFYqIzM
	 zjKN8UIelMyjqoBIzvSpiPI1wbwFYlWD8yZzJvIznUYipkg3a2A0W/sM1eOYeGOCul
	 wwPTIPzv3Iaf003mz62LV76GC5mUq6N4jUCOBz6m/E7Ju2s2rMl+8PMdQynvuDmpCI
	 dlG4xCYJg11S4K9c5hH2uHKKRwUJkU1BWx+uviCykbWNpnVA70WW8Z+v9YjWyQRM02
	 s3uU6t5Uo+eaym43aXAeSkFbGtWF9OjLzHDibB8LRi0VM/Tjbj8RkLG1CvEtJhhBwg
	 4R9+K+hswiEDw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/5] KVM: arm64: Add a helper providing an inlined
 literal value for ICH_VTR_EL2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260720132220.2143486-3-maz@kernel.org>
References: <20260720132220.2143486-1-maz@kernel.org>
 <20260720132220.2143486-3-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 13:46:28 +0000
Message-Id: <20260720134628.BEB071F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The `kvm_patch_ich_vtr_el2()` helper fails to apply the `vgic_v3_b=
roken_seis()` workaround mask to the `ICH_VTR_EL2` value.
- [High] The `noinstr` function `kvm_patch_ich_vtr_el2()` calls out-of-line=
 instrumentable functions, which violates `.noinstr.text` safety rules.
--

--- Patch [2]: [PATCH 2/5] KVM: arm64: Add a helper providing an inlined li=
teral value for ICH_VTR_EL2 ---
commit aedd950f23aaa5667277a7a495b598168c06eb84
Author: Marc Zyngier <maz@kernel.org>

KVM: arm64: Add a helper providing an inlined literal value for ICH_VTR_EL2

This commit adds an alternative patching callback to provide an inlined
literal value for the ICH_VTR_EL2 system register. It computes the value
at boot time and patches it into the relevant code locations.

> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 9e841e7afd4a7..ef62dd498f5cf 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -876,6 +876,57 @@ void noinstr kvm_compute_ich_hcr_trap_bits(struct al=
t_instr *alt,
>  	*updptr =3D cpu_to_le32(insn);
>  }
> =20
> +void noinstr kvm_patch_ich_vtr_el2(struct alt_instr *alt,
> +				   __le32 *origptr, __le32 *updptr,
> +				   int nr_inst)
> +{
> +	struct arm_smccc_res res =3D {};
> +	u32 insn, oinsn, rd, vtr;
> +
> +	/* No KVM? Nothing to do */
> +	if (!is_hyp_mode_available())
> +		return;
> +
> +	/* No v3 (or v3 compat)? Nothing to do either */
> +	if (!this_cpu_has_cap(ARM64_HAS_GICV5_LEGACY) &&
> +	    !this_cpu_has_cap(ARM64_HAS_GICV3_CPUIF))
> +		return;

[Severity: High]
Is it safe to call out-of-line and instrumentable functions like
this_cpu_has_cap() from a noinstr context?

This violates the .noinstr.text safety rules and might expose the
alternative patching sequence to ftrace, KASAN, and kprobes, potentially
leading to recursive faults.

[ ... ]

> +	if (WARN_ON(res.a0 =3D=3D HVC_STUB_ERR))
> +		return;

[Severity: High]
Could WARN_ON() also expand to out-of-line instrumentable trap or warning
functions, further violating the noinstr constraints of
kvm_patch_ich_vtr_el2()?

> +
> +	vtr =3D res.a1;
> +
> +	/* Compute target register */
> +	oinsn =3D le32_to_cpu(*origptr);

[Severity: High]
Does this sequence miss the workaround mask for broken locally generated
System Error Interrupts (SEI)?

The code reads SYS_ICH_VTR_EL2 and directly bakes it into instructions
without applying the vgic_v3_broken_seis() mask to clear the
ICH_VTR_EL2_SEIS bit. Affected hardware might incorrectly advertise SEI
support as a result.

> +	rd =3D aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD, oinsn);
> +
> +	/* movz rd, #(vtr & 0xffff) */
> +	insn =3D aarch64_insn_gen_movewide(rd,
> +					 (u16)vtr,
> +					 0,
> +					 AARCH64_INSN_VARIANT_64BIT,
> +					 AARCH64_INSN_MOVEWIDE_ZERO);
> +	*updptr++ =3D cpu_to_le32(insn);

[Severity: High]
Like this_cpu_has_cap() above, aarch64_insn_decode_register() and
aarch64_insn_gen_movewide() are out-of-line C functions. Should these
calls be avoided inside a noinstr patching callback to prevent recursive
faulting during instruction patching?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720132220.2143=
486-1-maz@kernel.org?part=3D2
