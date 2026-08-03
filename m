Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AEE73B9920;
	Mon,  3 Aug 2026 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785768461; cv=none; b=DS2yuoraFHEGAaeoccqOTlOzrweL/tSqsDKsQlVtJ1i7KbzC/mz7YMrO3wbZ9Az+K8ozgCsar3876p5QOxqnVcWc5XkVS4mQVYiqiCoFEj6iP1aQYOH+DMVEM67zNM7SwfxXc6zae+hwTlfy8Ib90b3JzFn5WvMtjG08/KlLSmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785768461; c=relaxed/simple;
	bh=38cWHigXcc4kq3LUHJEhpk1zbpHG87KHCVunwzlvl8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=WcPo+5t21jPgwMSkOdK0iR80Z1inEAkNuDeZDSlybg6HQC+pbqt0I++alxU+2RXUp2p4wxO6U8z0QwgQkTk5fiUv/xhPF0tpNAF3z7w0lKq/s55zTcZFH0KCjpZm327rKja4Hq1ScWEn93u7sLN0pWgcie0jxA2WiZfq47KQ4K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=XYjPVarq; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="XYjPVarq"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71CE7143D;
	Mon,  3 Aug 2026 07:47:34 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7F28C3F632;
	Mon,  3 Aug 2026 07:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785768458; bh=38cWHigXcc4kq3LUHJEhpk1zbpHG87KHCVunwzlvl8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYjPVarqny0nWZzw1E7KmrYY4oQrQ6COa1NPKF+kAOCPGZouTEIUslF7Ct4ihs8wr
	 UkdZUBycIs76Wm3q0Xbh1/f5w64NS5xlfp/EbGl9ZbT7Qd6L+GcsaokV5c3VLOJHwy
	 eBwK+DaH4kxGStG2VTB9GPIgz3jqqhCbKNmL31u0=
From: Leonardo Bras <leo.bras@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: Leonardo Bras <leo.bras@arm.com>,
	kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 04/11] KVM: arm64: dirty_bit: Add base FEAT_HACDBS cleaning routine
Date: Mon,  3 Aug 2026 15:47:35 +0100
Message-ID: <anCqB-Y7kk_h1qwe@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729105753.B1E6B1F000E9@smtp.kernel.org>
References: <20260729104548.3439958-1-leo.bras@arm.com> <20260729104548.3439958-5-leo.bras@arm.com> <20260729105753.B1E6B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 29, 2026 at 10:57:53AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 8 potential issue(s) to consider:
> - [Critical] `hacdbs_sched_in` restores a potentially stale VMID from `save.vttbr_el2`, leading to cross-VM memory corruption.
> - [High] Direct EL2 system register accesses from host code without a VHE check causes kernel panics on nVHE systems.
> - [High] Writes to control-plane system registers are batched and not immediately followed by an `isb()` barrier.
> - [High] Missing synchronization barrier (`DSB`) before changing the translation context after disabling the HACDBS asynchronous engine.
> - [High] The hardware polling loop in `dirty_bit_clear` lacks a timeout or signal check, risking an unkillable task hang.
> - [Medium] Using `virt_to_phys()` on a dynamic buffer array which could be non-contiguous (e.g. allocated with vmalloc).
> - [Medium] The commit message explicitly asserts the code runs with preemption disabled, but the implementation explicitly enables preemption.
> - [Low] Left-shift of a negative integer in macro definition.
> --
> 
> --- Patch [4]: [PATCH v3 04/11] KVM: arm64: dirty_bit: Add base FEAT_HACDBS cleaning routine ---
> commit b837f416f1871772a3bac546015e6fcac9c7accb
> Author: Leonardo Bras <leo.bras@arm.com>
> 
> KVM: arm64: dirty_bit: Add base FEAT_HACDBS cleaning routine
> 
> Introduce the basic cleaning routine that is going to be used for both
> dirty-bitmap and dirty-ring routines. It sets the required registers with
> the input buffer, and wait for HACDBS to finish.
> 
> > It is ran with preemption disabled, as a task being scheduled in could
> > change the translation registers used by HACDBS and end up corrupting the
> > current dirty-bit tracking and the sched-in task's S2 pagetables.
> 
> [Severity: Medium]
> The commit message asserts that the code runs with preemption disabled, but
> looking at dirty_bit_clear(), preemption is explicitly enabled immediately
> after registering the notifier:
> 
> dirty_bit_clear() {
>     preempt_disable();
>     preempt_notifier_register(&save.notifier);
>     preempt_enable();
> }
> 
> Is this description accurate, or does the implementation contradict the
> commit message's synchronization premise?

Argh, forgot to update that message.
Done for next version.

> 
> > diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> > index 32fe938d6bf70..33826bbd16d91 100644
> > --- a/arch/arm64/kvm/dirty_bit.c
> > +++ b/arch/arm64/kvm/dirty_bit.c
> > @@ -5,6 +5,7 @@
> >   */
> >  
> >  #include <asm/kvm_dirty_bit.h>
> > +#include <asm/kvm_mmu.h>
> >  
> >  /* HDBSS entry field definitions */
> >  #define HDBSS_ENTRY_VALID BIT(0)
> > @@ -14,3 +15,178 @@
> >  	(((x) << HDBSS_ENTRY_TTWL_SHIFT) & HDBSS_ENTRY_TTWL_MASK)
> >  #define HDBSS_ENTRY_TTWL_RESV HDBSS_ENTRY_TTWL(-4)
> 
> [Severity: Low]
> Does this code trigger undefined behavior by left-shifting a negative
> signed integer (-4) via the HDBSS_ENTRY_TTWL macro?
> 
> [ ... ]

This should have been notified in the first patch. 
But sure, will tackle this.

> 
> > +static void hacdbs_start(u64 *hw_entries, int size)
> > +{
> > +	u64 br;
> > +	/* Each entry is 8 bytes */
> > +	int size_b = size * sizeof(hw_entries[0]);
> > +	int size_p2 = max(roundup_pow_of_two(size_b), PAGE_SIZE);
> > +
> > +	/* If not using the full size of the array, put a stop entry at the end */
> > +	if (size_b < size_p2)
> > +		hw_entries[size] = HDBSS_ENTRY_VALID | HDBSS_ENTRY_TTWL_RESV;
> > +
> > +	sysreg_clear_set_s(SYS_HACDBSCONS_EL2,
> > +			   HACDBSCONS_EL2_ERR_REASON | HACDBSCONS_EL2_INDEX, 0);
> 
> [Severity: High]
> Can this sequence leave the CPU executing with architecturally undefined
> pipeline state?
> 
> In hacdbs_start(), the write to the control-plane system register
> SYS_HACDBSCONS_EL2 is followed by pointer arithmetic and a dsb() rather
> than an isb() as the very next instruction.
> 

There would be no issue if we reorder writes to HACDBS*_EL2, so no need for 
an isb() between them.

> > +
> > +	br = (virt_to_phys(hw_entries) & HACDBSBR_EL2_BADDR_MASK) |
> > +	     FIELD_PREP(HACDBSBR_EL2_SZ, ilog2(size_p2) - 12) |
> > +	     FIELD_PREP(HACDBSBR_EL2_EN, 1);
> 
> [Severity: Medium]
> Will this return an invalid physical address if hw_entries is allocated via
> vmalloc() or kvmalloc()?
> 
> Using virt_to_phys() on a dynamic buffer array assumes it resides in the
> physically contiguous linear map, which could lead to hardware DMA targeting
> the wrong physical memory pages.
> 

It will not be fed with *vmalloc() allocations, as one can see in the 
next patches. 

> > +
> > +	/* All writes to the array have to complete before starting */
> > +	dsb(ishst);
> > +
> > +	write_sysreg_s(br, SYS_HACDBSBR_EL2);
> 
> [Severity: High]
> Does this code cause a kernel panic on nVHE systems?
> 
> In hacdbs_start(), directly writing to the EL2 system register
> SYS_HACDBSBR_EL2 from the KVM host kernel executing at EL1 without a
> has_vhe() guard will trigger an immediate Undefined Instruction trap.
> 

VHE will be tested in the next patches, before getting in this part.

> > +	isb();
> > +}
> 
> [ ... ]
> 
> > +static void hacdbs_sched_in(struct preempt_notifier *notifier, int cpu)
> > +{
> > +	struct hacdbs_sched_save *save = container_of(notifier,
> > +						      struct hacdbs_sched_save,
> > +						      notifier);
> > +
> > +	write_sysreg_s(save->save.vtcr_el2, SYS_VTCR_EL2);
> > +	write_sysreg_s(save->save.vttbr_el2, SYS_VTTBR_EL2);
> 
> [Severity: High]
> Could this direct EL2 register access cause a panic on nVHE systems?
> 
> Similar to hacdbs_start(), hacdbs_sched_in() accesses SYS_VTCR_EL2 and
> SYS_VTTBR_EL2 from EL1 without a VHE check.
> 

iden above

> [Severity: High]
> Is a synchronization barrier missing here?
> 
> In hacdbs_sched_in(), the write to SYS_VTCR_EL2 is immediately followed by a
> write to SYS_VTTBR_EL2 rather than an isb(), meaning subsequent instructions
> may observe undefined pipeline state.
> 

This should be fine, as __load_stage2() does exactly the same.



> [Severity: Critical]
> Can this restore a stale VMID and cause cross-VM memory corruption?
> 
> hacdbs_sched_in() restores the cached save.vttbr_el2 (which contains the
> VMID). Since this is a generic host thread, if KVM's VMID allocator rolls
> over while the task sleeps, the VMID could be reassigned.
> 
> This could cause the HACDBS engine to operate on another VM's memory.
> 

That would require either that the VMID of the running VM gets assigned to 
a new VM, which would break a lot more stuff. If this threads gets 
preempted, then the vm dies another way, I assume this trhead will be 
removed and have no chance of restoring the values.

> > +	isb();
> > +
> > +	if (save->save.hcr_vm_set) {
> > +		sysreg_clear_set_hcr(0, HCR_EL2_VM);
> > +		isb();
> > +	}
> > +
> > +	write_sysreg_s(save->save.hacdbscons_el2, SYS_HACDBSCONS_EL2);
> > +	write_sysreg_s(save->save.hacdbsbr_el2, SYS_HACDBSBR_EL2);
> 
> [Severity: High]
> Does this sequence lack an immediate isb() after writing SYS_HACDBSCONS_EL2,
> allowing the CPU to execute the SYS_HACDBSBR_EL2 write with undefined
> pipeline state?

It should not be an issue.


> 
> > +	isb();
> > +}
> > +
> > +static void hacdbs_sched_out(struct preempt_notifier *notifier,
> > +			     struct task_struct *next)
> > +{
> > +	struct hacdbs_sched_save *save = container_of(notifier,
> > +						      struct hacdbs_sched_save,
> > +						      notifier);
> > +
> > +	if (read_sysreg_s(SYS_HACDBSBR_EL2) & HACDBSBR_EL2_EN) {
> > +		save->save.hacdbsbr_el2 = HACDBSBR_EL2_EN;
> > +		sysreg_clear_set_s(SYS_HACDBSBR_EL2, HACDBSBR_EL2_EN, 0);
> > +		isb();
> > +	} else {
> > +		save->save.hacdbsbr_el2 = 0;
> > +	}
> > +
> > +	save->save.hacdbscons_el2 = read_sysreg_s(SYS_HACDBSCONS_EL2);
> > +	save->save.hacdbsbr_el2 |= read_sysreg_s(SYS_HACDBSBR_EL2);
> > +	save->save.vttbr_el2 = read_sysreg_s(SYS_VTTBR_EL2);
> 
> [Severity: Critical]
> Is it safe to cache the VTTBR (including the VMID) into task-local memory
> here in hacdbs_sched_out()?
> 
> As mentioned for hacdbs_sched_in(), if a VMID rollover occurs while this
> task is preempted, the cached VMID becomes stale.
> 

Again, will the VMID of a running VM be reassigned to a new VM? 

> > +	save->save.vtcr_el2 = read_sysreg_s(SYS_VTCR_EL2);
> > +
> > +	if (read_sysreg_s(SYS_HCR_EL2) & HCR_EL2_VM) {
> > +		sysreg_clear_set_hcr(HCR_EL2_VM, 0);
> 
> [Severity: High]
> Does this code change the translation regime (clearing HCR_EL2_VM) without
> a preceding dsb()?
> 
> The engine was disabled earlier in hacdbs_sched_out() (by clearing
> HACDBSBR_EL2_EN), but without a dsb(), the asynchronous engine might not be
> definitively halted before the translation context changes.
> 

Above code clears HACDBSBR_EL2.EN, then run a isb(), which should make sure 
HACDBS is not issuing any writes after that. IIUC, any possible pending 
write by the HACDBS engine should already be physically addressed.

> > +		isb();
> > +		save->save.hcr_vm_set = true;
> > +	} else {
> > +		save->save.hcr_vm_set = false;
> > +	}
> > +}
> 
> [ ... ]
> 
> > +static int dirty_bit_clear(struct kvm *kvm, u64 *hw_entries, int size)
> > +{
> > +	int ret;
> > +	u64 cons;
> > +	struct hacdbs_sched_save save;
> > +
> > +	preempt_notifier_init(&save.notifier, &hacdbs_preempt_ops);
> > +	preempt_disable();
> > +	preempt_notifier_register(&save.notifier);
> > +	preempt_enable();
> > +
> > +	__load_stage2(&kvm->arch.mmu);
> > +	sysreg_clear_set_hcr(0, HCR_EL2_VM);
> > +	isb();
> > +
> > +	hacdbs_start(hw_entries, size);
> > +
> > +	do {
> > +		cons = read_sysreg_s(SYS_HACDBSCONS_EL2);
> > +		if (FIELD_GET(HACDBSCONS_EL2_ERR_REASON, cons))
> > +			break;
> > +
> > +		if (FIELD_GET(HACDBSCONS_EL2_INDEX, cons) >= size)
> > +			break;
> > +
> > +		udelay(1);
> > +	} while (true);
> 
> [Severity: High]
> Could this continuous hardware polling loop hang the CPU permanently?
> 
> In dirty_bit_clear(), this loop waits for the hardware engine to finish, but
> it lacks a timeout mechanism, bounded retry, or a fatal_signal_pending()
> check.

If that happens, it's a hardware bug, and it hanging in that loop allows 
better debugging. This code is preemptable, so the hardware bug should not 
cause host crash or keep the cpu busy.

> 
> > +
> > +	ret = hacdbs_stop(size);
> > +
> > +	sysreg_clear_set_hcr(HCR_EL2_VM, 0);
> 
> [Severity: High]
> Can this translation regime change lead to speculative execution or out of
> context memory accesses?
> 
> In dirty_bit_clear(), hacdbs_stop() clears the enable bit, but clearing
> HCR_EL2_VM immediately after lacks an intervening dsb() to ensure the
> hardware engine is definitively halted.
> 

Above code clears HACDBSBR_EL2.EN, then run a isb(), which should make sure 
HACDBS is not issuing any writes after that. IIUC, any possible pending 
write by the HACDBS engine should already be physically addressed.


Leo
