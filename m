Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931F34499B6;
	Wed, 29 Jul 2026 10:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785322676; cv=none; b=rUxuzKdK8wpEVm9bgtMAH7tXFeod7ZLnjHG/5hUpV7sB7vVhx9MIqUF1Vs8N71B7w2j7gUaBkNLHvmxnw2Qh6yNOO8DAagDJMqui4mxmni5Hfy5xniehHpW4xK6mwM6MBFREIsxNFnC0l2u0a2MkMK9W959rv20S54AVj4LbOUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785322676; c=relaxed/simple;
	bh=2cSlau8piPW7Urm2i4Qif9M+ci7RwPbWHX27xkSf1Eg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cEGeg+Wc+IlPdNWV7JFCCbjC/XdFyKOYLPHEfTu+0oowlIQftRRZ+7mkB68EP6PfURtRbCgYOFOQpWC4UTkmpHpjaxCuHk0HCaLzmyYSuACpYCS4c+k71kZ1ZlLgFyiViozxPaEF73w1VsZhLYU1KUqWSUNxyZ331Hlqb6AGF5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0onnFrs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0onnFrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E6B1F000E9;
	Wed, 29 Jul 2026 10:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785322674;
	bh=YLWCf3VPcZLr0Qq+rn4J2+ur27EFB2i4tMnH8bGiz1U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F0onnFrsceGeWp0YfoKHK5it7kVAn+moJdMMDekpy77e/kaam1wRUgIhAIbZbqIta
	 kS6o7V4JZf+ZRSB4CE5FmCoD+wOM3ZvPfYPO8ajcUD2QZrTfBCq3/Jn0WyrPeRdDSM
	 T3mUcrzSpKsqOyI4uVYHdelfByzO1W01BhqaMDucZZHJdZdU8BPlL2pa4qJvjX2+ke
	 UhoHamv+Qqh3sitxxPPizO9XYLxayzBvWiVd+r2eeGI+pKfWTtQBz3Fdlryl+8/4Io
	 qUMc1n4q9wFIiubuFLat10JHvkwhFNDsutVzpjT6wnBjdRMQ/oIp76xumFivXmx09A
	 07/vWknMD+xFQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 04/11] KVM: arm64: dirty_bit: Add base FEAT_HACDBS
 cleaning routine
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260729104548.3439958-5-leo.bras@arm.com>
References: <20260729104548.3439958-1-leo.bras@arm.com>
 <20260729104548.3439958-5-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 10:57:53 +0000
Message-Id: <20260729105753.B1E6B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:
- [Critical] `hacdbs_sched_in` restores a potentially stale VMID from `save=
.vttbr_el2`, leading to cross-VM memory corruption.
- [High] Direct EL2 system register accesses from host code without a VHE c=
heck causes kernel panics on nVHE systems.
- [High] Writes to control-plane system registers are batched and not immed=
iately followed by an `isb()` barrier.
- [High] Missing synchronization barrier (`DSB`) before changing the transl=
ation context after disabling the HACDBS asynchronous engine.
- [High] The hardware polling loop in `dirty_bit_clear` lacks a timeout or =
signal check, risking an unkillable task hang.
- [Medium] Using `virt_to_phys()` on a dynamic buffer array which could be =
non-contiguous (e.g. allocated with vmalloc).
- [Medium] The commit message explicitly asserts the code runs with preempt=
ion disabled, but the implementation explicitly enables preemption.
- [Low] Left-shift of a negative integer in macro definition.
--

--- Patch [4]: [PATCH v3 04/11] KVM: arm64: dirty_bit: Add base FEAT_HACDBS=
 cleaning routine ---
commit b837f416f1871772a3bac546015e6fcac9c7accb
Author: Leonardo Bras <leo.bras@arm.com>

KVM: arm64: dirty_bit: Add base FEAT_HACDBS cleaning routine

Introduce the basic cleaning routine that is going to be used for both
dirty-bitmap and dirty-ring routines. It sets the required registers with
the input buffer, and wait for HACDBS to finish.

> It is ran with preemption disabled, as a task being scheduled in could
> change the translation registers used by HACDBS and end up corrupting the
> current dirty-bit tracking and the sched-in task's S2 pagetables.

[Severity: Medium]
The commit message asserts that the code runs with preemption disabled, but
looking at dirty_bit_clear(), preemption is explicitly enabled immediately
after registering the notifier:

dirty_bit_clear() {
    preempt_disable();
    preempt_notifier_register(&save.notifier);
    preempt_enable();
}

Is this description accurate, or does the implementation contradict the
commit message's synchronization premise?

> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> index 32fe938d6bf70..33826bbd16d91 100644
> --- a/arch/arm64/kvm/dirty_bit.c
> +++ b/arch/arm64/kvm/dirty_bit.c
> @@ -5,6 +5,7 @@
>   */
> =20
>  #include <asm/kvm_dirty_bit.h>
> +#include <asm/kvm_mmu.h>
> =20
>  /* HDBSS entry field definitions */
>  #define HDBSS_ENTRY_VALID BIT(0)
> @@ -14,3 +15,178 @@
>  	(((x) << HDBSS_ENTRY_TTWL_SHIFT) & HDBSS_ENTRY_TTWL_MASK)
>  #define HDBSS_ENTRY_TTWL_RESV HDBSS_ENTRY_TTWL(-4)

[Severity: Low]
Does this code trigger undefined behavior by left-shifting a negative
signed integer (-4) via the HDBSS_ENTRY_TTWL macro?

[ ... ]

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

[Severity: High]
Can this sequence leave the CPU executing with architecturally undefined
pipeline state?

In hacdbs_start(), the write to the control-plane system register
SYS_HACDBSCONS_EL2 is followed by pointer arithmetic and a dsb() rather
than an isb() as the very next instruction.

> +
> +	br =3D (virt_to_phys(hw_entries) & HACDBSBR_EL2_BADDR_MASK) |
> +	     FIELD_PREP(HACDBSBR_EL2_SZ, ilog2(size_p2) - 12) |
> +	     FIELD_PREP(HACDBSBR_EL2_EN, 1);

[Severity: Medium]
Will this return an invalid physical address if hw_entries is allocated via
vmalloc() or kvmalloc()?

Using virt_to_phys() on a dynamic buffer array assumes it resides in the
physically contiguous linear map, which could lead to hardware DMA targeting
the wrong physical memory pages.

> +
> +	/* All writes to the array have to complete before starting */
> +	dsb(ishst);
> +
> +	write_sysreg_s(br, SYS_HACDBSBR_EL2);

[Severity: High]
Does this code cause a kernel panic on nVHE systems?

In hacdbs_start(), directly writing to the EL2 system register
SYS_HACDBSBR_EL2 from the KVM host kernel executing at EL1 without a
has_vhe() guard will trigger an immediate Undefined Instruction trap.

> +	isb();
> +}

[ ... ]

> +static void hacdbs_sched_in(struct preempt_notifier *notifier, int cpu)
> +{
> +	struct hacdbs_sched_save *save =3D container_of(notifier,
> +						      struct hacdbs_sched_save,
> +						      notifier);
> +
> +	write_sysreg_s(save->save.vtcr_el2, SYS_VTCR_EL2);
> +	write_sysreg_s(save->save.vttbr_el2, SYS_VTTBR_EL2);

[Severity: High]
Could this direct EL2 register access cause a panic on nVHE systems?

Similar to hacdbs_start(), hacdbs_sched_in() accesses SYS_VTCR_EL2 and
SYS_VTTBR_EL2 from EL1 without a VHE check.

[Severity: High]
Is a synchronization barrier missing here?

In hacdbs_sched_in(), the write to SYS_VTCR_EL2 is immediately followed by a
write to SYS_VTTBR_EL2 rather than an isb(), meaning subsequent instructions
may observe undefined pipeline state.

[Severity: Critical]
Can this restore a stale VMID and cause cross-VM memory corruption?

hacdbs_sched_in() restores the cached save.vttbr_el2 (which contains the
VMID). Since this is a generic host thread, if KVM's VMID allocator rolls
over while the task sleeps, the VMID could be reassigned.

This could cause the HACDBS engine to operate on another VM's memory.

> +	isb();
> +
> +	if (save->save.hcr_vm_set) {
> +		sysreg_clear_set_hcr(0, HCR_EL2_VM);
> +		isb();
> +	}
> +
> +	write_sysreg_s(save->save.hacdbscons_el2, SYS_HACDBSCONS_EL2);
> +	write_sysreg_s(save->save.hacdbsbr_el2, SYS_HACDBSBR_EL2);

[Severity: High]
Does this sequence lack an immediate isb() after writing SYS_HACDBSCONS_EL2,
allowing the CPU to execute the SYS_HACDBSBR_EL2 write with undefined
pipeline state?

> +	isb();
> +}
> +
> +static void hacdbs_sched_out(struct preempt_notifier *notifier,
> +			     struct task_struct *next)
> +{
> +	struct hacdbs_sched_save *save =3D container_of(notifier,
> +						      struct hacdbs_sched_save,
> +						      notifier);
> +
> +	if (read_sysreg_s(SYS_HACDBSBR_EL2) & HACDBSBR_EL2_EN) {
> +		save->save.hacdbsbr_el2 =3D HACDBSBR_EL2_EN;
> +		sysreg_clear_set_s(SYS_HACDBSBR_EL2, HACDBSBR_EL2_EN, 0);
> +		isb();
> +	} else {
> +		save->save.hacdbsbr_el2 =3D 0;
> +	}
> +
> +	save->save.hacdbscons_el2 =3D read_sysreg_s(SYS_HACDBSCONS_EL2);
> +	save->save.hacdbsbr_el2 |=3D read_sysreg_s(SYS_HACDBSBR_EL2);
> +	save->save.vttbr_el2 =3D read_sysreg_s(SYS_VTTBR_EL2);

[Severity: Critical]
Is it safe to cache the VTTBR (including the VMID) into task-local memory
here in hacdbs_sched_out()?

As mentioned for hacdbs_sched_in(), if a VMID rollover occurs while this
task is preempted, the cached VMID becomes stale.

> +	save->save.vtcr_el2 =3D read_sysreg_s(SYS_VTCR_EL2);
> +
> +	if (read_sysreg_s(SYS_HCR_EL2) & HCR_EL2_VM) {
> +		sysreg_clear_set_hcr(HCR_EL2_VM, 0);

[Severity: High]
Does this code change the translation regime (clearing HCR_EL2_VM) without
a preceding dsb()?

The engine was disabled earlier in hacdbs_sched_out() (by clearing
HACDBSBR_EL2_EN), but without a dsb(), the asynchronous engine might not be
definitively halted before the translation context changes.

> +		isb();
> +		save->save.hcr_vm_set =3D true;
> +	} else {
> +		save->save.hcr_vm_set =3D false;
> +	}
> +}

[ ... ]

> +static int dirty_bit_clear(struct kvm *kvm, u64 *hw_entries, int size)
> +{
> +	int ret;
> +	u64 cons;
> +	struct hacdbs_sched_save save;
> +
> +	preempt_notifier_init(&save.notifier, &hacdbs_preempt_ops);
> +	preempt_disable();
> +	preempt_notifier_register(&save.notifier);
> +	preempt_enable();
> +
> +	__load_stage2(&kvm->arch.mmu);
> +	sysreg_clear_set_hcr(0, HCR_EL2_VM);
> +	isb();
> +
> +	hacdbs_start(hw_entries, size);
> +
> +	do {
> +		cons =3D read_sysreg_s(SYS_HACDBSCONS_EL2);
> +		if (FIELD_GET(HACDBSCONS_EL2_ERR_REASON, cons))
> +			break;
> +
> +		if (FIELD_GET(HACDBSCONS_EL2_INDEX, cons) >=3D size)
> +			break;
> +
> +		udelay(1);
> +	} while (true);

[Severity: High]
Could this continuous hardware polling loop hang the CPU permanently?

In dirty_bit_clear(), this loop waits for the hardware engine to finish, but
it lacks a timeout mechanism, bounded retry, or a fatal_signal_pending()
check.

> +
> +	ret =3D hacdbs_stop(size);
> +
> +	sysreg_clear_set_hcr(HCR_EL2_VM, 0);

[Severity: High]
Can this translation regime change lead to speculative execution or out of
context memory accesses?

In dirty_bit_clear(), hacdbs_stop() clears the enable bit, but clearing
HCR_EL2_VM immediately after lacks an intervening dsb() to ensure the
hardware engine is definitively halted.

> +	isb();
> +
> +	/*
> +	 * No DSB is needed here, as kvm_flush_remote_tlbs_memslot() that happe=
ns
> +	 * later in generic dirty-cleaning code already performs a DSB before
> +	 * doing the TLBI.
> +	 */
> +
> +	preempt_disable();
> +	preempt_notifier_unregister(&save.notifier);
> +	preempt_enable();
> +
> +	return ret;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729104548.3439=
958-1-leo.bras@arm.com?part=3D4
