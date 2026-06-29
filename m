Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D75B40D581;
	Mon, 29 Jun 2026 11:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782733974; cv=none; b=LbmLGONgsBlJ39c3Rh/kL4XtCHqdasfRDd+ayKYvPoCS6NfxwyGVY38mR+h/MStzTj/GXLbE3CJoGz4Jdk4KMjRl5/ZRDTTYJx6FfmrLJI87kuvtZELl4IEYaA6GDcPYI0e3uPkNLmUcXGPOMvg4crlvkmLjEXYj/mmh6Eje224=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782733974; c=relaxed/simple;
	bh=jBJCyVOfoELRqet1Hchr9zK6UrEcK5Is9iXtfLYz4xU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AaEFmzZJlmGPigqAr2klyGIj3wJYUTB8X5D0ws6jvNKTg/6SrJVTWxCgKRvcTycpdV++jgdXLoPZgW7H/tseVZfb879insOMl8xsbCUZSVf7WiWHC5e1n0fZ6louZ50KdyozMU6jupbrW6oM0w3mk+5JqkimW7wtKyMW8AGjFvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T55iAki1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T55iAki1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6791F000E9;
	Mon, 29 Jun 2026 11:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782733972;
	bh=iBcQquI8ybp86BeMq6C0HtO1zKhePFe/3Op4+sVdI0k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T55iAki1GeuDOEf/ZzNFdMYzmz1rmlw0IvSMWM7s7VCRF4DzHdm+TyWThAbundBtG
	 ZL7+ZYxtE3Ny2Pkkw5lRQL3lwK4Nz/ndrnGEcHol7TRG8kuqSenSjeM91C9smGrfmP
	 NvNNXKZAaZLBq+u3dRjtx751JzBi/cFUc1xtVbrwFng7h6+Z2g0re3eFYKCb8nbUb2
	 7n9sfTtXNWDR+c3fcdJrSrYxlVb0d62Tlj68xnieGFPB36xN/X4qiH8yiC5YEthtau
	 sCjSumMv4M87Qr+7iF17xkc+v30ZpezG0WFHJLIwqo9D+rSHKBUKXgjL70/15PH0B5
	 aFKq0ax274eoQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 13/13] KVM: arm64: Enable KVM_HW_DIRTY_BIT
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leonardo Bras" <leo.bras@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260629111820.1873540-14-leo.bras@arm.com>
References: <20260629111820.1873540-1-leo.bras@arm.com>
 <20260629111820.1873540-14-leo.bras@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 29 Jun 2026 11:52:52 +0000
Message-Id: <20260629115252.9A6791F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Malicious userspace can trigger a host kernel panic by providi=
ng an invalid memslot ID in the dirty ring.
- [High] Unbounded stall in `dirty_bit_clear()` due to a missed wakeup race=
 with `wfi()`.
- [High] Missing `isb()` immediately after writes to control-plane system r=
egisters `HCR_EL2` and `SYS_HACDBSCONS_EL2`.
- [High] Off-by-one error in `split_end` calculation skips huge page splits=
 for subsequent PMD blocks.
- [High] kvm_arch_dirty_clear_enabled() uses this_cpu_read() without preemp=
tion disabled.
--

commit 7b3668eabb9d9e558d0cab4dd205a0b0b5c74a14
Author: Leonardo Bras <leo.bras@arm.com>

KVM: arm64: Enable KVM_HW_DIRTY_BIT

This commit sets the Kconfig flag to enable hardware accelerated
dirty-bitmap and dirty-ring cleaning for arm64 when ACPI is enabled.

> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 449154f9a4852..db8487bf738b7 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -34,6 +34,7 @@ menuconfig KVM
>  	select HAVE_KVM_IRQ_BYPASS
>  	select HAVE_KVM_READONLY_MEM
>  	select HAVE_KVM_VCPU_RUN_PID_CHANGE
> +	select HAVE_KVM_HW_DIRTY_BIT if ACPI
>  	select SCHED_INFO
>  	select GUEST_PERF_EVENTS if PERF_EVENTS
>  	select KVM_GUEST_MEMFD

I noticed a few preexisting issues in the hardware dirty tracking
implementation enabled by this configuration.

arch/arm64/kvm/dirty_bit.c:dirty_bit_clear() {
    ...
    do {
        wfi();
    } while (this_cpu_read(hacdbs_pcp.status) =3D=3D HACDBS_RUNNING);
    ...
}

[Severity: High]
This isn't a bug introduced by this patch, but can this wfi() sleep
unconditionally without disabling local interrupts first?

If the HACDBS hardware finishes and its interrupt is handled immediately
after hacdbs_start() but before the wfi() instruction, wouldn't the wakeup
event be missed, causing a regression with an unbounded stall?


arch/arm64/kvm/dirty_bit.c:__kvm_arch_dirty_ring_clear() {
    ...
    memslot =3D kvm_dirty_ring_get_memslot(kvm, entry->slot);
    slot =3D entry->slot;
    slot_offset =3D memslot->base_gfn;
    ...
}

[Severity: Critical]
This is a pre-existing issue, but is it safe to blindly dereference memslot
here without checking if kvm_dirty_ring_get_memslot() returned NULL?

If unprivileged userspace provides an invalid or out-of-bounds slot ID in
the dirty ring, kvm_dirty_ring_get_memslot() will return NULL, which would
trigger a panic regression when memslot->base_gfn is accessed.


arch/arm64/kvm/dirty_bit.c:dirty_bit_clear() {
    ...
    write_sysreg(hcr_el2 | HCR_EL2_VM, HCR_EL2);
    __load_stage2(&kvm->arch.mmu);
    ...
}

arch/arm64/kvm/dirty_bit.c:hacdbs_start() {
    ...
    sysreg_clear_set_s(SYS_HACDBSCONS_EL2,
                       HACDBSCONS_EL2_ERR_REASON | HACDBSCONS_EL2_INDEX, 0);

    br =3D (virt_to_phys(hw_entries) & HACDBSBR_EL2_BADDR_MASK) |
    ...
}

[Severity: High]
This isn't a bug introduced by this patch, but do these writes to HCR_EL2
and SYS_HACDBSCONS_EL2 need an immediate isb()?

In dirty_bit_clear(), HCR_EL2 is written and immediately followed by
__load_stage2(). In hacdbs_start(), SYS_HACDBSCONS_EL2 is written without
an immediate isb(). Could this cause a regression where the CPU executes
subsequent instructions with architecturally undefined pipeline state?


arch/arm64/kvm/dirty_bit.c:__kvm_arch_dirty_log_clear() {
    ...
    kvm_mmu_split_huge_pages(kvm, start, end);
    split_end =3D gpa_to_gfn(ALIGN_DOWN(end, PMD_SIZE) + PMD_SIZE - 1);
    ...
}

[Severity: High]
This is a pre-existing issue, but does the calculation for split_end have
an off-by-one error?

If the dirtied range perfectly aligns with a PMD boundary (where end is a
multiple of PMD_SIZE), split_end would advance to cover the entire next
PMD block.

Subsequent iterations would then evaluate offset + BITS_PER_LONG > split_end
as false, which skips the kvm_mmu_split_huge_pages() call for that next
block.


arch/arm64/include/asm/kvm_dirty_bit.h:kvm_arch_dirty_clear_enabled() {
    ...
    static inline bool kvm_arch_dirty_clear_enabled(struct kvm *kvm)
    {
        return this_cpu_read(hacdbs_pcp.status) =3D=3D HACDBS_IDLE &&
    ...
}

[Severity: High]
This isn't a bug introduced by this patch, but does
kvm_arch_dirty_clear_enabled() use this_cpu_read() in a preemptible
context?

This function is called from kvm_arch_dirty_log_clear() and
kvm_arch_dirty_ring_clear(), where preemption is enabled. Could the thread
migrate to another CPU right after the check, leading to a regression where
dirty clearing logic runs on a CPU with the hardware scanner disabled?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260629111820.1873=
540-1-leo.bras@arm.com?part=3D13
