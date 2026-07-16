Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2A941C302
	for <kvmarm@lists.linux.dev>; Thu, 16 Jul 2026 14:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212074; cv=none; b=r4e1yTDS6tlNfBwKfIE4obupLTcdXEG8Baki85hoYli4i4cTTAPE8L8MC3dxG3s0A5uuSWDVS4eEEvGaUvYC9SXrJ4A+bDoo3OtStnzGiDeFKUbZ0hxULbSD3wjqmojgAcR/nnolrjsm8MJNInhRdaHBCTKWfGbVXo/b3u9PxGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212074; c=relaxed/simple;
	bh=6VqUZxTx9zaOtQy0slpmIRT8TR+P/UTwN1Nn9CtRuDI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mAaJoti2is/pLmDqF/CfX8lwQQVWbMoa+FI7vCSuQmJXNNh17t45EN/+bTZSs5vDCtCS+8MMymRhAf0nEYanPI6knkFHFoEA4i2kr7ybowCTAd0x2ga0ZwRFZm2nHM9DwK8TUbGEyeqhlfDdHgLi0Rqo0AGBO4d8v9nh9zvBYDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=okTUiuGZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="okTUiuGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899751F000E9;
	Thu, 16 Jul 2026 14:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784212072;
	bh=aXlLW2xSlzq1hIORezA/X6FmXzS1sQncfhpKr01n8b0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=okTUiuGZLJos3dmQZ73sPHWXJOLQyYHqXJkABLYnwBryNAaKJdj5oQ6W0XwZVgpqm
	 QiiJNolGyEnVCTPeN2UyUD/9P7APF1kRGD/a37P8jnj9rBRXUEJzHxR8FDyQRRCzGG
	 JgHYDVekKCkV2wkN36NlhXzJrqeRsKpGLUmXfgtmfzcW0g5oJ52VkjP5xe3IFFsgw3
	 skvzgzbY1WDYnX5pP3f2GPBi+PA1Gv8iOYioTjlgf5mgRcNWy6k2MU57twnzvAx2yv
	 BmDGzNFFEkCY4dPfCWeFv95UJ91Ma8kLvRXbeH6Q4XCnHOge9ejhkr+Tjs5V1f4zVc
	 Hx/XFhWLEElkw==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 5/5] KVM: arm64: Use TTBR1_EL2 for hVHE runtime
 mappings
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QW5lZXNoIEt1bWFyIEsuViAoQXJtKQ==?= <aneesh.kumar@kernel.org>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260716140936.4003182-6-aneesh.kumar@kernel.org>
References: <20260716140936.4003182-1-aneesh.kumar@kernel.org>
 <20260716140936.4003182-6-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 16 Jul 2026 14:27:52 +0000
Message-Id: <20260716142752.899751F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Spectre V3A vector hardening branch synthesis truncates TTBR1 cano=
nical addresses, leading to a fatal EL2 Instruction Abort.
- [High] Writes to control-plane system registers (`SYS_TTBR1_EL2`) are not=
 immediately followed by an `isb()` instruction.
- [Medium] The error-handling branches following `WARN_ON` at EL2 are dead =
code, as `WARN_ON` expands to a fatal `BRK` instruction.
- [Medium] Unvalidated software feature override leads to fatal hVHE layout=
 mismatch on unsupported hardware.
--

--- Patch [5]: [RFC PATCH 5/5] KVM: arm64: Use TTBR1_EL2 for hVHE runtime m=
appings ---
commit c5a5f8a98b4a3d3fc85945a12a0935f8530f85d7
Author: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

KVM: arm64: Use TTBR1_EL2 for hVHE runtime mappings

This patch updates hVHE to place runtime mappings in TTBR1_EL2 and reserves
TTBR0_EL2 for the identity mapping used during MMU transitions. It introduc=
es
support for walking canonical TTBR1 hyp page tables while retaining the
existing TTBR0-only layout for nVHE.

> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kv=
m_mmu.h
> index bcc8e28985f70..30ac5cecaa93b 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -112,13 +113,28 @@ void kvm_compute_layout(void);
>  u32 kvm_hyp_va_bits(void);
>  void kvm_apply_hyp_relocations(void);
> =20
> +static __always_inline bool kvm_hyp_init_uses_ttbr1(void)
> +{
> +	BUILD_BUG_ON(__is_defined(__KVM_NVHE_HYPERVISOR__));
> +
> +	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
> +}

[Severity: Medium]
Will this lead to a fatal hVHE layout mismatch on hardware that does not
support VHE?

If a user specifies the arm64.sw_feature_override=3Dhvhe command-line param=
eter
on an unsupported CPU, early initialization will use the TTBR1 layout based=
 on
this override. However, the final CPU capabilities check in
kvm_hyp_uses_ttbr1() evaluates to false, causing a desynchronization between
early-boot and runtime page table layouts.

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe=
/hyp-init.S
> index 89cb553be1e55..07fc29c34fb36 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> @@ -127,13 +127,22 @@ SYM_CODE_START_LOCAL(___kvm_hyp_init)
>  	ldr	x1, [x0, #NVHE_INIT_VTCR]
>  	msr	vtcr_el2, x1
> =20
> -	ldr	x1, [x0, #NVHE_INIT_PGD_PA]
> +	ldr	x1, [x0, #NVHE_INIT_TTBR0_PGD_PA]
>  	phys_to_ttbr x2, x1
>  alternative_if ARM64_HAS_CNP
>  	orr	x2, x2, #TTBRx_EL1_CnP
>  alternative_else_nop_endif
>  	msr	ttbr0_el2, x2
> =20
> +	ldr	x1, [x0, #NVHE_INIT_TTBR1_PGD_PA]
> +	cbz	x1, 2f
> +	phys_to_ttbr x2, x1
> +alternative_if ARM64_HAS_CNP
> +	orr	x2, x2, #TTBRx_EL1_CnP
> +alternative_else_nop_endif
> +	msr_s	SYS_TTBR1_EL2, x2
> +2:
> +
>  	ldr	x0, [x0, #NVHE_INIT_TCR_EL2]
>  	msr	tcr_el2, x0

[Severity: High]
Does the write to SYS_TTBR1_EL2 require an immediate isb?

Subsystem architectural invariants require every write to a control-plane
system register to be followed by an isb as the very next instruction. Since
it is delayed here behind register loads and another msr, intervening
instructions might execute against an undefined pipeline state.

[ ... ]

> @@ -284,14 +295,22 @@ alternative_if ARM64_HAS_CNP
>  alternative_else_nop_endif
>  	msr	ttbr0_el2, x5
> =20
> +	cbz	x1, 1f
> +	phys_to_ttbr x5, x1
> +alternative_if ARM64_HAS_CNP
> +	orr	x5, x5, #TTBRx_EL1_CnP
> +alternative_else_nop_endif
> +	msr_s	SYS_TTBR1_EL2, x5
> +1:
> +
>  	/* Set the new stack pointer */
> -	mov	sp, x1
> +	mov	sp, x2
> =20
>  	/* And turn the MMU back on! */
>  	dsb	nsh
>  	isb

[Severity: High]
Could the lack of an immediate isb after msr_s SYS_TTBR1_EL2 cause
unpredictable behavior here as well?

The isb is placed after the stack pointer assignment and dsb, which leaves a
window where instructions execute against an undefined pipeline state.

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index 3233a7c70f7ca..c856b2399960c 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -431,6 +432,22 @@ int hyp_create_fixmap(void)
>  	return create_fixblock();
>  }
> =20
> +static int pkvm_map_idmap_text(unsigned long start, unsigned long end)
> +{
> +	unsigned long idmap_start, idmap_end;
> +
> +	idmap_start =3D __hyp_symbol_pa(__hyp_idmap_text_start);
> +	idmap_start =3D ALIGN_DOWN(idmap_start, PAGE_SIZE);
> +	idmap_end =3D __hyp_symbol_pa(__hyp_idmap_text_end);
> +	idmap_end =3D ALIGN(idmap_end, PAGE_SIZE);
> +
> +	if (WARN_ON(start !=3D idmap_start || end !=3D idmap_end))
> +		return -EINVAL;

[Severity: Medium]
Is the error-handling branch following this WARN_ON dead code?

At EL2 in nVHE/pKVM, WARN_ON expands to a fatal BRK instruction which is
caught by the hypervisor panic handler. The subsystem does not support
warn-and-return semantics, meaning the return -EINVAL will never execute.

[ ... ]

> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/se=
tup.c
> index 2ef1972cc3ddc..45b8f7213e396 100644
> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
> @@ -371,8 +394,12 @@ int __pkvm_init(phys_addr_t phys, unsigned long size=
, unsigned long *per_cpu_bas
> =20
>  	/* Jump in the idmap page to switch to the new page-tables */
>  	params =3D this_cpu_ptr(&kvm_init_params);
> +	if (WARN_ON(!pkvm_init_ttbrs_valid(params)))
> +		return -EINVAL;
> +

[Severity: Medium]
Similarly here, is this return -EINVAL unreachable?

The WARN_ON will trigger a hypervisor panic, so the recovery path cannot be
executed.

[ ... ]

> diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
> index 75a89ad8fecfe..1e1816995fe4f 100644
> --- a/arch/arm64/kvm/va_layout.c
> +++ b/arch/arm64/kvm/va_layout.c
> @@ -225,7 +247,7 @@ void kvm_patch_vector_branch(struct alt_instr *alt,
>  	/*
>  	 * Compute HYP VA by using the same computation as kern_hyp_va()
>  	 */
> -	addr =3D __early_kern_hyp_va((u64)kvm_hyp_kimg_kaddr(__kvm_hyp_vector));
> +	addr =3D __early_kern_sym_hyp_va(__kvm_hyp_vector);
> =20
>  	/* Use PC[10:7] to branch to the same vector in KVM */
>  	addr |=3D ((u64)origptr & GENMASK_ULL(10, 7));

[Severity: High]
Does the Spectre V3A vector hardening branch synthesis truncate TTBR1
canonical addresses?

The AARCH64_INSN_MOVEWIDE_ZERO instruction generated below clears bits 16-63
to zero:

    insn =3D aarch64_insn_gen_movewide(AARCH64_INSN_REG_0,
                                     (u16)addr,
                                     0,
                                     AARCH64_INSN_VARIANT_64BIT,
                                     AARCH64_INSN_MOVEWIDE_ZERO);
    *updptr++ =3D cpu_to_le32(insn);

This branch synthesis relies on a TTBR0 address format. Since a TTBR1 addre=
ss
requires bits 48-63 to be set to 1, the address becomes corrupted. When the
hypervisor exits to the host, this truncated address could lead to a fatal =
EL2
Instruction Abort.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260716140936.4003=
182-1-aneesh.kumar@kernel.org?part=3D5
