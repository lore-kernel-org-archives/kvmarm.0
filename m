Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F387A3C81B6;
	Mon, 29 Jun 2026 11:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782733504; cv=none; b=gtB67tHAEAy8JyNjP4J+wV2P0411i7hA5zlDxnfN+6C1ElKii6mj9suromkTuEzMv2wkBh48DmnVmVUx3r4rmdPqP5tG7KmYnam9RPyQrnNlUojyTqN5YCw6CrQhnhlXLGj+elS8s6iFUiox0Q9+I0GINN5qgmTN1hxW/+biK68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782733504; c=relaxed/simple;
	bh=7+IJ6dBSWemFfIuz3hMKH914mCAS0FZmrkyOBK4JrVQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GwjJZKwWT5dnSD0VM+QXaFweIcHeF/JnKO3QJf2yYjbD+3x89TjEQ5hrLxQG/h/MNyJvH+nUGfPfH8kepA9xxHBGgOdnDkHwNIbiuFAiuLvwbp4cREzSQ7JlL+5Xxitp/ePFgDYwQeHW4c+wklwxiSJD+rOIqbeq2vWe2L/yBIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R+//tuKM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R+//tuKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A801F000E9;
	Mon, 29 Jun 2026 11:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782733502;
	bh=DhtbM2S6jyTOn/aamXyUZ96wES0L6GnMLq/AQgbfOWY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R+//tuKMNG/nZ/8siE38I8ZH5VimDB6XoAlSms9+zsG4TEfrlWvteXiyPuVERvV1H
	 nHBurxhGxtoFKrW/5y5l9CIfaPmSgsjCpDAPTUZFx1QFRtG7Y6VwfxOwNoN8qD8g6p
	 zJkXFGG4Rshpo3F5CPgswWZGDcYNwPbqxyl5H5+Sm9cggbTViS7ctBncpNf67Tv59S
	 RRKh9HZY6PI+fjm36FEvMzvqy+cqNm9FB23wFlCRSZuVWO3Y3O/vMXSVfTYccnvmGx
	 MIJ1YLmMJ4WyWzEGWT3UxlpDjUtdzdx2PBGbFaoxvlEbM6HaJ3c8+3qcwQ7B0ncG/V
	 XQSlEl/1/GVhw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/13] KVM: arm64: Add hardware-accelerated
 dirty-bitmap cleaning routine
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260629111820.1873540-9-leo.bras@arm.com>
References: <20260629111820.1873540-1-leo.bras@arm.com>
 <20260629111820.1873540-9-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 29 Jun 2026 11:45:01 +0000
Message-Id: <20260629114501.A6A801F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 10 potential issue=
(s) to consider:
- [High] Missing `isb()` context synchronization event after writing to the=
 `HCR_EL2` control-plane system register.
- [High] Host kernel directly accesses EL2 system registers, which will cra=
sh nVHE configurations.
- [High] Incorrect indexing of the userspace-provided `bitmap` buffer leads=
 to out-of-bounds memory reads.
- [High] Dropping `kvm->mmu_lock` before pending HACDBS entries are flushed=
 creates a TOCTOU race window that permanently loses guest writes.
- [High] Off-by-one error in calculating `split_end` causes KVM to mistaken=
ly skip huge page splitting for subsequent PMDs, leading to data loss.
- [High] Flawed return value logic in `__kvm_arch_dirty_log_clear()` incorr=
ectly returns `-EAGAIN` on exact-multiple success or a positive integer on =
general success.
- [High] The `wfi()` loop waits indefinitely with `preempt_disable()` and `=
kvm->mmu_lock` held in write mode without masking local interrupts, risking=
 lost wakeups and hard lockups.
- [High] Ignoring the return value of `kvm_mmu_split_huge_pages()` can perm=
anently break dirty logging for huge pages.
- [High] Dereferencing `kvm->arch.mmu.pgt` without checking if it is NULL l=
eads to a kernel panic.
- [Low] A variable declaration immediately follows a `case` label, resultin=
g in a build failure.
--

commit 8c1efc438f0d50c036b9548bfa7efea74d90a446
Author: Leonardo Bras <leo.bras@arm.com>

KVM: arm64: Add hardware-accelerated dirty-bitmap cleaning routine

This patch implements an arm64-specific kvm_arch_dirty_log_clear() using the
FEAT_HACDBS hardware feature. It converts dirty bitmap entries into HDBSS
structures and feeds them to the hardware to clean the page tables. It also
splits huge pages in chunks if manual protect and init set options are
enabled.

> diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/=
asm/kvm_dirty_bit.h
> --- a/arch/arm64/include/asm/kvm_dirty_bit.h
> +++ b/arch/arm64/include/asm/kvm_dirty_bit.h

[ ... ]

> +static inline bool kvm_arch_dirty_clear_enabled(struct kvm *kvm)
> +{
> +	return this_cpu_read(hacdbs_pcp.status) =3D=3D HACDBS_IDLE &&
> +	       (kvm->arch.mmu.pgt->flags & KVM_PGTABLE_S2_DBM);
> +}

[Severity: High]
Can this cause a kernel panic if invoked before the MMU is fully initialize=
d?
The stage-2 page tables (pgt) are allocated lazily, so if userspace calls
the clear dirty log ioctl before initialization, kvm->arch.mmu.pgt could be
NULL.

> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> --- a/arch/arm64/kvm/dirty_bit.c
> +++ b/arch/arm64/kvm/dirty_bit.c

[ ... ]

> +int __kvm_arch_dirty_log_clear(struct kvm *kvm,
> +			       struct kvm_memory_slot *memslot,
> +			       struct kvm_clear_dirty_log *log,
> +			       unsigned long *bitmap,
> +			       bool *flush)
> +{

[ ... ]

> +	for (unsigned long i =3D start; i < end; i++) {
> +		unsigned long mask;
> +		gfn_t offset;
> +		atomic_long_t *p;
> +
> +		if (log) { /* Clean only what is in the input bitmap */
> +			mask =3D bitmap[i];

[Severity: High]
Does this code read out of bounds of the userspace-provided bitmap?
When a dirty log is provided, the bitmap is sized relative to log->num_page=
s.
Since i is an absolute index into the guest's memory slot (starting at
log->first_page / BITS_PER_LONG), accessing bitmap[i] uses the absolute=20
offset instead of a 0-based relative offset.

> +			if (!mask)
> +				continue;

[ ... ]

> +		offset =3D base_gfn + i * BITS_PER_LONG;
> +
> +		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> +			kvm_mmu_split_huge_pages(kvm,
> +						 gfn_to_gpa(offset + __ffs(mask)),
> +						 gfn_to_gpa(offset + __fls(mask) + 1));

[Severity: High]
Does this create a race condition that loses guest writes?
The software dirty bitmap is cleared at the start of this loop. If
kvm_mmu_split_huge_pages() is called here, it drops and reacquires
kvm->mmu_lock to top up the memory cache. Any guest write that occurs
while the lock is dropped is recorded in the hardware PTE, but because
the software bit was already cleared, the subsequent hardware execution
clears the PTE's dirty bit, erasing the concurrent write.

[Severity: High]
Can this permanently break dirty logging for huge pages if splitting fails?
The return value of kvm_mmu_split_huge_pages() is ignored. If it fails
(e.g., returning -ENOMEM), the block is not split, but the IPAs are
still fed to the hardware. The hardware will then clear the dirty bit on
the 2MB block descriptor, losing dirty tracking for the entire region.

[Severity: High]
Is there an off-by-one error in the split_end calculation?
Looking at the split_end assignment in the full context:

__kvm_arch_dirty_log_clear() {
    ...
    split_end =3D gpa_to_gfn(ALIGN_DOWN(end, PMD_SIZE) + PMD_SIZE - 1);
    ...
}

Since end is an exclusive upper bound, if the dirty region perfectly aligns
with a PMD boundary, this calculates a split_end that spans to the end of
the next PMD. This would cause the next PMD to skip splitting, leading to
data loss when the hardware clears the dirty bit on the unsplit block.

> +		do {
> +			idx =3D mask_to_hdbss(&mask, hw_entries, offset, ttwl, idx, entries_s=
z);
> +			if (idx >=3D entries_sz) {
> +				ret =3D dirty_bit_clear(kvm, hw_entries, idx);

[Severity: High]
Is there a missing context synchronization event in dirty_bit_clear()?
When this calls dirty_bit_clear(), that function writes to the HCR_EL2
control-plane system register and immediately calls __load_stage2():

dirty_bit_clear() {
    ...
    hcr_el2 =3D read_sysreg(HCR_EL2);
    write_sysreg(hcr_el2 | HCR_EL2_VM, HCR_EL2);
    __load_stage2(&kvm->arch.mmu);
    ...
}

The architecture requires an isb() as the very next instruction after
writing a control-plane system register. Without it, the CPU executes
subsequent instructions in an architecturally undefined pipeline state.

[Severity: High]
Does this code access EL2 system registers directly from the host kernel?
In nVHE configurations, the host kernel runs at EL1. The dirty_bit_clear()
function directly reads and writes HCR_EL2. This will trigger an Undefined=
=20
Instruction exception and panic the host kernel on nVHE systems. KVM must=20
use EL2-private hyp code or hypercalls to access EL2 state outside of VHE=20
mode.

[Severity: High]
Does the wait loop in dirty_bit_clear() risk a lost wakeup and hard lockup?
The code disables preemption but fails to disable local interrupts before
calling wfi():

dirty_bit_clear() {
    preempt_disable();
    ...
    do {
        wfi();
    } while (this_cpu_read(hacdbs_pcp.status) =3D=3D HACDBS_RUNNING);
    ...
}

If the hardware interrupt fires and sets the status to idle after the
condition is checked but before the wfi() instruction executes, the CPU
will sleep indefinitely.

> +				*flush =3D *flush || ret > 0;
> +				if (ret !=3D idx) {
> +					/* Save bits not converted back to bitmap */
> +					atomic_long_or(mask, (atomic_long_t *)&dirty_bitmap[i]);
> +					goto out_err;
> +				}
> +				idx =3D 0;
> +			}
> +		} while (mask);
> +	}

[ ... ]

> +out_err:
> +	if (unlikely(ret !=3D idx)) {
> +		/*
> +		 * In case there is an error and not all entries in HACDBS get
> +		 * cleaned, we have to mark the dirty bits back in the bitmap,
> +		 * as that will be used by the software routine.
> +		 *
> +		 * Entries should be in order, since they were extraxed from
> +		 * the dirty-bitmap, so batching the atomic writes is efficient.
> +		 */
> +
> +		if (ret < idx)
> +			hdbss_to_bitmap(hw_entries, ret, idx, dirty_bitmap, memslot->base_gfn=
);
> +
> +		ret =3D -EAGAIN;
> +	}
> +
> +	write_unlock(&kvm->mmu_lock);
> +	kfree(hw_entries);
> +
> +	return ret;
> +}

[Severity: High]
Does this error handling block incorrectly treat exact-multiple success sta=
tes
as failures?
If the processed entries perfectly divide by entries_sz, the loop resets
idx =3D 0 and sets ret =3D entries_sz. The check if (unlikely(ret !=3D idx))
then evaluates to true, falsely triggering this error path and returning
-EAGAIN.

Additionally, if it is not an exact multiple, the function exits with
ret =3D idx (a positive integer), which the generic KVM ioctl layer treats
as a failure code.

>  static irqreturn_t hacdbsirq_handler(int irq, void *pcpu)
>  {
>  	u64 cons =3D read_sysreg_s(SYS_HACDBSCONS_EL2);

[Severity: High]
Does this handler also directly access an EL2-only register from the host?
Just like dirty_bit_clear(), calling read_sysreg_s(SYS_HACDBSCONS_EL2)
from the host IRQ handler running at EL1 will crash nVHE configurations
with an Undefined Instruction exception.

[Severity: Low]
Is there a syntax error in this IRQ handler's switch statement?
Looking at the rest of hacdbsirq_handler():

hacdbsirq_handler() {
    ...
    case HACDBSCONS_EL2_ERR_REASON_IPAHACF:
        int index =3D ...;
    ...
}

A variable declaration immediately following a case label is a syntax
error in C, which will cause a build failure.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260629111820.1873=
540-1-leo.bras@arm.com?part=3D8
