Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF091A6828;
	Tue, 28 Jul 2026 14:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785247316; cv=none; b=ecY02A30MifyYPXuEFgN5EXsUWv1Wg4qub0bYeKCKO35rKXGt1bljFPusnh8v+z3Qyzd07JIEAtMiF+ywDxWsIcKmn8dw7y+BINz7mc/h/hmNHPvQmou7DuGr98pBWa5Z/CqQYAreofWG1RMzokocGiI4qLaN59XXvoB2RYEm4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785247316; c=relaxed/simple;
	bh=yFHhxgm+7rlqAKIIfhqMs2XpR3HoX9CpSKW2tHq1X24=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=fKRNnFuDp2z+dzKEnBnnk5GgMrkLxRurZbcdU5ab5XNPAlgzY0irjld7TcWXE3i6Tf7VJfE7APGdZkF1K1MPu9agKkYwVzd4QYrPv7zqgNiePM+wm2IaLwu1eE15zByVGUMLm6Zd1tPV4pd7EU9yH6jpsN7yFyr7sQSObSLqdNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TGukzbpW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TGukzbpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946F91F000E9;
	Tue, 28 Jul 2026 14:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785247314;
	bh=7GkRsVHIRsv7Dxo9H5GShx0EyePOGFKEbq2gvHRqXZE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=TGukzbpWiExEialUZjJ9oP69zxUZ4kqm+ajAeDSb1NELytCVv2XeUfgAqydLocR5t
	 OkgdWsarLcS1RQ5TZlflmtRyvMtIhNyPeyZNebZhhtTQvmDz1JOMT16ygb38AmeTqE
	 erxZ3KK42QdjwWsIsafs6letIDpUEynou15BP3nhI1eS5jjBot0+CWd8gNRclTehq3
	 PGqT9Fh22ZgQXWpVfWw3RDc3D+QQWJrqhHcprAMgN5EESiSW8wysCos1yHHtV/YCGd
	 tmY8xFHAZPsrz0GHgH5lmLIc/kfyAlG3orrSRWJe50Jo97aZmFvoHYf5ts2zwYjGnF
	 LyZhhZ60lFzbg==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
To: sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, kvmarm@lists.linux.dev,
	"Oliver Upton" <oupton@kernel.org>,
	"Marc Zyngier" <maz@kernel.org>
Subject: Re: [RFC PATCH 5/5] KVM: arm64: Use TTBR1_EL2 for hVHE runtime
 mappings
In-Reply-To: <20260716142752.899751F000E9@smtp.kernel.org>
	(sashiko-bot@kernel.org's message of "Thu, 16 Jul 2026 14:27:52
	+0000")
References: <20260716140936.4003182-1-aneesh.kumar@kernel.org>
	<20260716140936.4003182-6-aneesh.kumar@kernel.org>
	<20260716142752.899751F000E9@smtp.kernel.org>
User-Agent: mu4e 1.14.1; emacs 30.2
Date: Tue, 28 Jul 2026 19:31:42 +0530
Message-ID: <yq5a8q6vjjqx.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 4 potential issue(s) to consider:
> - [High] Spectre V3A vector hardening branch synthesis truncates TTBR1 canonical addresses, leading to a fatal EL2 Instruction Abort.
> - [High] Writes to control-plane system registers (`SYS_TTBR1_EL2`) are not immediately followed by an `isb()` instruction.
> - [Medium] The error-handling branches following `WARN_ON` at EL2 are dead code, as `WARN_ON` expands to a fatal `BRK` instruction.
> - [Medium] Unvalidated software feature override leads to fatal hVHE layout mismatch on unsupported hardware.
> --
>
> --- Patch [5]: [RFC PATCH 5/5] KVM: arm64: Use TTBR1_EL2 for hVHE runtime mappings ---
> commit c5a5f8a98b4a3d3fc85945a12a0935f8530f85d7
> Author: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>
> KVM: arm64: Use TTBR1_EL2 for hVHE runtime mappings
>
> This patch updates hVHE to place runtime mappings in TTBR1_EL2 and reserves
> TTBR0_EL2 for the identity mapping used during MMU transitions. It introduces
> support for walking canonical TTBR1 hyp page tables while retaining the
> existing TTBR0-only layout for nVHE.
>
>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>> index bcc8e28985f70..30ac5cecaa93b 100644
>> --- a/arch/arm64/include/asm/kvm_mmu.h
>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>> @@ -112,13 +113,28 @@ void kvm_compute_layout(void);
>>  u32 kvm_hyp_va_bits(void);
>>  void kvm_apply_hyp_relocations(void);
>>  
>> +static __always_inline bool kvm_hyp_init_uses_ttbr1(void)
>> +{
>> +	BUILD_BUG_ON(__is_defined(__KVM_NVHE_HYPERVISOR__));
>> +
>> +	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
>> +}
>
> [Severity: Medium]
> Will this lead to a fatal hVHE layout mismatch on hardware that does not
> support VHE?
>
> If a user specifies the arm64.sw_feature_override=hvhe command-line parameter
> on an unsupported CPU, early initialization will use the TTBR1 layout based on
> this override. However, the final CPU capabilities check in
> kvm_hyp_uses_ttbr1() evaluates to false, causing a desynchronization between
> early-boot and runtime page table layouts.
>

But match_options(), which ultimately calls hvhe_filter(), is invoked
before we start using kvm_hyp_init_uses_ttbr1()


>
> [ ... ]
>
>> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
>> index 89cb553be1e55..07fc29c34fb36 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
>> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
>> @@ -127,13 +127,22 @@ SYM_CODE_START_LOCAL(___kvm_hyp_init)
>>  	ldr	x1, [x0, #NVHE_INIT_VTCR]
>>  	msr	vtcr_el2, x1
>>  
>> -	ldr	x1, [x0, #NVHE_INIT_PGD_PA]
>> +	ldr	x1, [x0, #NVHE_INIT_TTBR0_PGD_PA]
>>  	phys_to_ttbr x2, x1
>>  alternative_if ARM64_HAS_CNP
>>  	orr	x2, x2, #TTBRx_EL1_CnP
>>  alternative_else_nop_endif
>>  	msr	ttbr0_el2, x2
>>  
>> +	ldr	x1, [x0, #NVHE_INIT_TTBR1_PGD_PA]
>> +	cbz	x1, 2f
>> +	phys_to_ttbr x2, x1
>> +alternative_if ARM64_HAS_CNP
>> +	orr	x2, x2, #TTBRx_EL1_CnP
>> +alternative_else_nop_endif
>> +	msr_s	SYS_TTBR1_EL2, x2
>> +2:
>> +
>>  	ldr	x0, [x0, #NVHE_INIT_TCR_EL2]
>>  	msr	tcr_el2, x0
>
> [Severity: High]
> Does the write to SYS_TTBR1_EL2 require an immediate isb?
>
> Subsystem architectural invariants require every write to a control-plane
> system register to be followed by an isb as the very next instruction. Since
> it is delayed here behind register loads and another msr, intervening
> instructions might execute against an undefined pipeline state.
>

But we can also batch multilple msr?

The full change looks as below. Isn't that safe?

	ldr	x1, [x0, #NVHE_INIT_TTBR0_PGD_PA]
	phys_to_ttbr x2, x1
alternative_if ARM64_HAS_CNP
	orr	x2, x2, #TTBRx_EL1_CnP
alternative_else_nop_endif
	msr	ttbr0_el2, x2

	ldr	x1, [x0, #NVHE_INIT_TTBR1_PGD_PA]
	cbz	x1, 2f
	phys_to_ttbr x2, x1
alternative_if ARM64_HAS_CNP
	orr	x2, x2, #TTBRx_EL1_CnP
alternative_else_nop_endif
	msr_s	SYS_TTBR1_EL2, x2
2:

	ldr	x0, [x0, #NVHE_INIT_TCR_EL2]
	msr	tcr_el2, x0

	isb                          <<<--- this should be enough

	/* Invalidate the stale TLBs from Bootloader */
	tlbi	alle2
	tlbi	alle1
	dsb	sy



>
> [ ... ]
>
>> @@ -284,14 +295,22 @@ alternative_if ARM64_HAS_CNP
>>  alternative_else_nop_endif
>>  	msr	ttbr0_el2, x5
>>  
>> +	cbz	x1, 1f
>> +	phys_to_ttbr x5, x1
>> +alternative_if ARM64_HAS_CNP
>> +	orr	x5, x5, #TTBRx_EL1_CnP
>> +alternative_else_nop_endif
>> +	msr_s	SYS_TTBR1_EL2, x5
>> +1:
>> +
>>  	/* Set the new stack pointer */
>> -	mov	sp, x1
>> +	mov	sp, x2
>>  
>>  	/* And turn the MMU back on! */
>>  	dsb	nsh
>>  	isb
>
> [Severity: High]
> Could the lack of an immediate isb after msr_s SYS_TTBR1_EL2 cause
> unpredictable behavior here as well?
>
> The isb is placed after the stack pointer assignment and dsb, which leaves a
> window where instructions execute against an undefined pipeline state.

isn't isb before turning the mmu back on sufficient?

	isb
	set_sctlr_el2	x3

Related full change looks as below:

	cbz	x1, 1f
	phys_to_ttbr x5, x1
alternative_if ARM64_HAS_CNP
	orr	x5, x5, #TTBRx_EL1_CnP
alternative_else_nop_endif
	msr_s	SYS_TTBR1_EL2, x5
1:

	/* Set the new stack pointer */
	mov	sp, x2

	/* And turn the MMU back on! */
	dsb	nsh
	isb
	set_sctlr_el2	x3
	ret	x6



>
> [ ... ]
>
>> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
>> index 3233a7c70f7ca..c856b2399960c 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
>> @@ -431,6 +432,22 @@ int hyp_create_fixmap(void)
>>  	return create_fixblock();
>>  }
>>  
>> +static int pkvm_map_idmap_text(unsigned long start, unsigned long end)
>> +{
>> +	unsigned long idmap_start, idmap_end;
>> +
>> +	idmap_start = __hyp_symbol_pa(__hyp_idmap_text_start);
>> +	idmap_start = ALIGN_DOWN(idmap_start, PAGE_SIZE);
>> +	idmap_end = __hyp_symbol_pa(__hyp_idmap_text_end);
>> +	idmap_end = ALIGN(idmap_end, PAGE_SIZE);
>> +
>> +	if (WARN_ON(start != idmap_start || end != idmap_end))
>> +		return -EINVAL;
>
> [Severity: Medium]
> Is the error-handling branch following this WARN_ON dead code?
>
> At EL2 in nVHE/pKVM, WARN_ON expands to a fatal BRK instruction which is
> caught by the hypervisor panic handler. The subsystem does not support
> warn-and-return semantics, meaning the return -EINVAL will never execute.
>
> [ ... ]
>
>> diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
>> index 2ef1972cc3ddc..45b8f7213e396 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/setup.c
>> +++ b/arch/arm64/kvm/hyp/nvhe/setup.c
>> @@ -371,8 +394,12 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long *per_cpu_bas
>>  
>>  	/* Jump in the idmap page to switch to the new page-tables */
>>  	params = this_cpu_ptr(&kvm_init_params);
>> +	if (WARN_ON(!pkvm_init_ttbrs_valid(params)))
>> +		return -EINVAL;
>> +
>
> [Severity: Medium]
> Similarly here, is this return -EINVAL unreachable?
>
> The WARN_ON will trigger a hypervisor panic, so the recovery path cannot be
> executed.
>
> [ ... ]
>
>> diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
>> index 75a89ad8fecfe..1e1816995fe4f 100644
>> --- a/arch/arm64/kvm/va_layout.c
>> +++ b/arch/arm64/kvm/va_layout.c
>> @@ -225,7 +247,7 @@ void kvm_patch_vector_branch(struct alt_instr *alt,
>>  	/*
>>  	 * Compute HYP VA by using the same computation as kern_hyp_va()
>>  	 */
>> -	addr = __early_kern_hyp_va((u64)kvm_hyp_kimg_kaddr(__kvm_hyp_vector));
>> +	addr = __early_kern_sym_hyp_va(__kvm_hyp_vector);
>>  
>>  	/* Use PC[10:7] to branch to the same vector in KVM */
>>  	addr |= ((u64)origptr & GENMASK_ULL(10, 7));
>
> [Severity: High]
> Does the Spectre V3A vector hardening branch synthesis truncate TTBR1
> canonical addresses?
>
> The AARCH64_INSN_MOVEWIDE_ZERO instruction generated below clears bits 16-63
> to zero:
>
>     insn = aarch64_insn_gen_movewide(AARCH64_INSN_REG_0,
>                                      (u16)addr,
>                                      0,
>                                      AARCH64_INSN_VARIANT_64BIT,
>                                      AARCH64_INSN_MOVEWIDE_ZERO);
>     *updptr++ = cpu_to_le32(insn);
>
> This branch synthesis relies on a TTBR0 address format. Since a TTBR1 address
> requires bits 48-63 to be set to 1, the address becomes corrupted. When the
> hypervisor exits to the host, this truncated address could lead to a fatal EL2
> Instruction Abort.
>

I need to look at this more closely. It does seem like this could be a problem.

-aneesh
