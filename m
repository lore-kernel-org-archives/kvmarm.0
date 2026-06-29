Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28433BB12A;
	Mon, 29 Jun 2026 11:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782732590; cv=none; b=G1FlGsu4Dw6suxsWWHVS8WLyDr6h/ziVxO8CCTXwEMCjFjjSZult1eC6m6H4sH2u6u7Obc5wVK2pJ4ZYyYQdSXvY8DERnNY/i/CFfYgMp9oC+1I0xZtgHq4fYZp8EpN9xx7iBtaIWPVOR+H2BPAj+KX4t5nVeNFiQ6dItWtmYZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782732590; c=relaxed/simple;
	bh=phKbkr1NrhEGoxRyE0iYnd9z6OZ755BRfUpcX5fJVjY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RUEvfO2YlrDF0j/542aHboj1dOdRV17fIAWVNISDaME0xPEePGfrzqrWs3FJrlwvYGQ0Id5Bm1du1TyGd0I7+SQbcHdZSLp09MNBYCc+wCFnBf3OCZF/58GxWrzt3hYPRiatd5wPFYnPz32CmkUU0Jfr/Vo4Ay8wqBsVVwCafyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Il8mzYMM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Il8mzYMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4D01F00AC4;
	Mon, 29 Jun 2026 11:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782732589;
	bh=Oz2KRsaZ/c3qC5b6J6rWhHj7kgNW6vi+4jACOuEs+ac=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Il8mzYMMVArRYCM4FVfItinAfIUdjSMFNedgIqwZ32loy5UTkpWgWcnGmRRbaoB93
	 XyvDhIak8FGvl21T4ZTOf70D99OSitgF/vdpJA3AGLXuDjYD+KSP/Qd3iCJZhUpz9w
	 sWHgO4PrQqpkx+blTnOTNamwxfQ6+WZUFESq0+wjGdR8NzjjFY5LTAKPlzYFude3+I
	 dzZQxBvO8Oia2GZZgdNMAa0fat8hm+l5HrNzqnGtP4Un25ZIOw9mu0/Z/eNY6sfc4Y
	 eRu4g3ZVxv4ftASByuHhn2gQ0owQOe2zShsxcqf+rRyumyrs+nF1Ss9cQc9EqeFxOo
	 Ftm7yGap4gEcg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/13] KVM: arm64: dirty_bit: Add base FEAT_HACDBS
 cleaning routine
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260629111820.1873540-7-leo.bras@arm.com>
References: <20260629111820.1873540-1-leo.bras@arm.com>
 <20260629111820.1873540-7-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 29 Jun 2026 11:29:48 +0000
Message-Id: <20260629112948.9F4D01F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Missing Context Synchronization Event (ISB) after writes to contro=
l-plane system registers.
- [High] TOCTOU race in wfi() polling loop causes a lost wakeup and indefin=
ite CPU stall.
- [High] Missing memory barrier (dsb) before starting the HACDBS hardware e=
ngine.
- [High] Missing speculative execution barrier (dsb) after disabling an asy=
nchronous hardware engine.
--

commit 47f5964570817fd652e798e082c349d012b3edda
Author: Leonardo Bras <leo.bras@arm.com>

KVM: arm64: dirty_bit: Add base FEAT_HACDBS cleaning routine

Introduce the basic cleaning routine that is going to be used for both
dirty-bitmap and dirty-ring routines. It sets the required registers with
the input buffer, and wait for HACDBSIRQ to happen, which means either
the task is done, or there was some error during processing.

> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> index 789da8712b1b4..e4283828b7807 100644
> --- a/arch/arm64/kvm/dirty_bit.c
> +++ b/arch/arm64/kvm/dirty_bit.c

[ ... ]

> @@ -24,6 +25,86 @@ DEFINE_PER_CPU(struct hacdbs, hacdbs_pcp) =3D {
> =20
>  static __ro_after_init int hacdbsirq =3D -1;
> =20
> +static void hacdbs_start(u64 *hw_entries, int size)
> +{
> +	u64 br;
> +	/* Each entry is 8 bytes */
> +	int size_b =3D size * sizeof(hw_entries[0]);
> +	int size_p2 =3D max(roundup_pow_of_two(size_b), PAGE_SIZE);
> +
> +	/* If not using the full size of the array, put a stop entry at the end=
 */
> +	if (size_b < size_p2)
> +		hw_entries[size] =3D HDBSS_ENTRY_VALID | HDBSS_ENTRY_TTWL_RESV;
> +
> +	sysreg_clear_set_s(SYS_HACDBSCONS_EL2,
> +			   HACDBSCONS_EL2_ERR_REASON | HACDBSCONS_EL2_INDEX, 0);
> +

[Severity: High]
Does this code need an immediate isb() after writing the control-plane syst=
em
register SYS_HACDBSCONS_EL2? The ARM64 guidelines indicate that an isb() mu=
st
be the very next instruction after writing a control-plane system register =
to
ensure the pipeline doesn't operate with architecturally undefined state.

[Severity: High]
Additionally, should there be a dsb() between the memory store to
hw_entries[size] and the write to SYS_HACDBSBR_EL2 below? Without an explic=
it
memory barrier, the store buffer might not be globally visible before the
engine begins reading memory, which could cause it to miss the stop marker
and access out-of-bounds memory.

> +	br =3D (virt_to_phys(hw_entries) & HACDBSBR_EL2_BADDR_MASK) |
> +	     FIELD_PREP(HACDBSBR_EL2_SZ, ilog2(size_p2) - 12) |
> +	     FIELD_PREP(HACDBSBR_EL2_EN, 1);
> +
> +	this_cpu_write(hacdbs_pcp.status, HACDBS_RUNNING);
> +	this_cpu_write(hacdbs_pcp.size, size);
> +	write_sysreg_s(br, SYS_HACDBSBR_EL2);
> +	isb();
> +}

[ ... ]

> +/*
> + * Clears dirty-bits for an array of pages (hw_entries) using HACDBS
> + * Returns the number of items cleaned from the array. If returns value =
< size,
> + *	there was an error in the processing.
> + */
> +static int dirty_bit_clear(struct kvm *kvm, u64 *hw_entries, int size)
> +{
> +	u64 hcr_el2;
> +	int ret;
> +
> +	preempt_disable();
> +
> +	hcr_el2 =3D read_sysreg(HCR_EL2);
> +	write_sysreg(hcr_el2 | HCR_EL2_VM, HCR_EL2);
> +	__load_stage2(&kvm->arch.mmu);

[Severity: High]
Is an isb() required immediately after writing HCR_EL2 before proceeding to
__load_stage2()? HCR_EL2 is a control-plane register, and delaying the barr=
ier
can cause the pipeline to operate with architecturally undefined state.

> +
> +	hacdbs_start(hw_entries, size);
> +
> +	do {
> +		wfi();
> +	} while (this_cpu_read(hacdbs_pcp.status) =3D=3D HACDBS_RUNNING);

[Severity: High]
Could this polling loop cause a lost wakeup and indefinite CPU stall? The l=
oop
unconditionally sleeps on the first iteration and checks the condition
non-atomically with respect to interrupts.=20

If the HACDBSIRQ interrupt is delivered and serviced just before the wfi()
instruction executes, the wfi() will wait for a new interrupt that will nev=
er
arrive. Should the check be made atomic with the sleep, for example by mask=
ing
IRQs before the check?

> +
> +	ret =3D hacdbs_stop();
> +
> +	write_sysreg(hcr_el2, HCR_EL2);
> +	isb();

[Severity: High]
Should there be a speculative execution barrier (dsb) after stopping the en=
gine
in hacdbs_stop() and before changing the translation context here?=20

The ARM64 guidelines mandate a speculative execution barrier (dsb + isb) af=
ter
disabling an asynchronous engine to definitively halt out-of-context execut=
ion
before updating the translation regime.

> +
> +	/*
> +	 * No DSB is needed here, as kvm_flush_remote_tlbs_memslot() that happe=
ns
> +	 * later in generic dirty-cleaning code already performs a DSB before
> +	 * doing the TLBI.
> +	 */
> +
> +	preempt_enable();
> +
> +	return ret;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260629111820.1873=
540-1-leo.bras@arm.com?part=3D6
