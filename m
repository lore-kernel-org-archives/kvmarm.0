From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: kvm/arm64: use-after-free in
 kvm_unmap_hva_handler/unmap_stage2_pmds
Date: Thu, 20 Apr 2017 17:40:55 +0100
Message-ID: <20170420164055.GA26877@e107814-lin.cambridge.arm.com>
References: <CAAeHK+yjKm3mO2h9M30t-V_PnMhXEM887_zESCSg6gkbzivPsQ@mail.gmail.com>
 <20f6c994-d83e-7a6f-9f13-f10287211a6c@arm.com>
 <9f473bb9-d0eb-6803-1263-75ffef0301fe@redhat.com>
 <CAAeHK+x8udHKq9xa1zkTO6ax5E8Dk32HYWfaT05FMchL2cr48g@mail.gmail.com>
 <1050c9d8-5813-5df9-29e5-3ab6e61b5de6@arm.com>
 <88715300-ef58-e7bd-81f5-95e0b9c9c533@arm.com>
 <20170413155045.GA8387@e107814-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170413155045.GA8387@e107814-lin.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Andrey Konovalov <andreyknvl@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: rkrcmar@redhat.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, dvyukov@google.com, mark.rutland@arm.com, kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, will.deacon@arm.com, kcc@google.com, syzkaller@googlegroups.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 13, 2017 at 04:50:46PM +0100, Suzuki K. Poulose wrote:
> On Thu, Apr 13, 2017 at 10:17:54AM +0100, Suzuki K Poulose wrote:
> > On 12/04/17 19:43, Marc Zyngier wrote:
> > > On 12/04/17 17:19, Andrey Konovalov wrote:
> > >
> > > Hi Andrey,
> > >
> > > > Apparently this wasn't fixed, I've got this report again on
> > > > linux-next-c4e7b35a3 (Apr 11), which includes 8b3405e34 "kvm:
> > > > arm/arm64: Fix locking for kvm_free_stage2_pgd".
> > >
> > > This looks like a different bug.
> > >
> > > >
> > > > I now have a way to reproduce it, so I can test proposed patches. I
> > > > don't have a simple C reproducer though.
> > > >
> > > > The bug happens when the following syzkaller program is executed:
> > > >
> > > > mmap(&(0x7f0000000000/0xc000)=nil, (0xc000), 0x3, 0x32, 0xffffffffffffffff, 0x0)
> > > > unshare(0x400)
> > > > perf_event_open(&(0x7f000002f000-0x78)={0x1, 0x78, 0x0, 0x0, 0x0, 0x0,
> > > > 0x0, 0x6, 0x0, 0x0, 0xd34, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
> > > > 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x0, 0xffffffff,
> > > > 0xffffffffffffffff, 0x0)
> > > > r0 = openat$kvm(0xffffffffffffff9c,
> > > > &(0x7f000000c000-0x9)="2f6465762f6b766d00", 0x0, 0x0)
> > > > ioctl$TIOCSBRK(0xffffffffffffffff, 0x5427)
> > > > r1 = ioctl$KVM_CREATE_VM(r0, 0xae01, 0x0)
> > > > syz_kvm_setup_cpu$arm64(r1, 0xffffffffffffffff,
> > > > &(0x7f0000dc6000/0x18000)=nil, &(0x7f000000c000)=[{0x0,
> > > > &(0x7f000000c000)="5ba3c16f533efbed09f8221253c73763327fadce2371813b45dd7f7982f84a873e4ae89a6c2bd1af83a6024c36a1ff518318",
> > > > 0x32}], 0x1, 0x0, &(0x7f000000d000-0x10)=[@featur2={0x1, 0x3}], 0x1)
> > >
> > > Is that the only thing the program does? Or is there anything running in
> > > parallel?
> > >
> > > > ==================================================================
> > > > BUG: KASAN: use-after-free in arch_spin_is_locked
> > > > include/linux/compiler.h:254 [inline]
> > > > BUG: KASAN: use-after-free in unmap_stage2_range+0x990/0x9a8
> > > > arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:295
> > > > Read of size 8 at addr ffff800004476730 by task syz-executor/13106
> > > >
> > > > CPU: 1 PID: 13106 Comm: syz-executor Not tainted
> > > > 4.11.0-rc6-next-20170411-xc2-11025-gc4e7b35a33d4-dirty #5
> > > > Hardware name: Hardkernel ODROID-C2 (DT)
> > > > Call trace:
> > > > [<ffff20000808fd08>] dump_backtrace+0x0/0x440 arch/arm64/kernel/traps.c:505
> > > > [<ffff2000080903c0>] show_stack+0x20/0x30 arch/arm64/kernel/traps.c:228
> > > > [<ffff2000088df030>] __dump_stack lib/dump_stack.c:16 [inline]
> > > > [<ffff2000088df030>] dump_stack+0x110/0x168 lib/dump_stack.c:52
> > > > [<ffff200008406db8>] print_address_description+0x60/0x248 mm/kasan/report.c:252
> > > > [<ffff2000084072c8>] kasan_report_error mm/kasan/report.c:351 [inline]
> > > > [<ffff2000084072c8>] kasan_report+0x218/0x300 mm/kasan/report.c:408
> > > > [<ffff200008407428>] __asan_report_load8_noabort+0x18/0x20 mm/kasan/report.c:429
> > > > [<ffff2000080db1b8>] arch_spin_is_locked include/linux/compiler.h:254 [inline]
> > >
> > > This is the assert on the spinlock, and the memory is gone.
> > >
> > > > [<ffff2000080db1b8>] unmap_stage2_range+0x990/0x9a8
> > > > arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:295
> > > > [<ffff2000080db248>] kvm_free_stage2_pgd.part.16+0x30/0x98
> > > > arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:842
> > > > [<ffff2000080ddfb8>] kvm_free_stage2_pgd
> > > > arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:838 [inline]
> > >
> > > But we've taken than lock here. There's only a handful of instructions
> > > in between, and the memory can only go away if there is something
> > > messing with us in parallel.
> > >
> > > > [<ffff2000080ddfb8>] kvm_arch_flush_shadow_all+0x40/0x58
> > > > arch/arm64/kvm/../../../arch/arm/kvm/mmu.c:1895
> > > > [<ffff2000080c379c>] kvm_mmu_notifier_release+0x154/0x1d0
> > > > arch/arm64/kvm/../../../virt/kvm/kvm_main.c:472
> > > > [<ffff2000083f2b60>] __mmu_notifier_release+0x1c0/0x3e0 mm/mmu_notifier.c:75
> > > > [<ffff2000083a1fb4>] mmu_notifier_release
> > > > include/linux/mmu_notifier.h:235 [inline]
> > > > [<ffff2000083a1fb4>] exit_mmap+0x21c/0x288 mm/mmap.c:2941
> > > > [<ffff20000810ecd4>] __mmput kernel/fork.c:888 [inline]
> > > > [<ffff20000810ecd4>] mmput+0xdc/0x2e0 kernel/fork.c:910
> > > > [<ffff20000811fda8>] exit_mm kernel/exit.c:557 [inline]
> > > > [<ffff20000811fda8>] do_exit+0x648/0x2020 kernel/exit.c:865
> > > > [<ffff2000081218b4>] do_group_exit+0xdc/0x260 kernel/exit.c:982
> > > > [<ffff20000813adf0>] get_signal+0x358/0xf58 kernel/signal.c:2318
> > > > [<ffff20000808de98>] do_signal+0x170/0xc10 arch/arm64/kernel/signal.c:370
> > > > [<ffff20000808edb4>] do_notify_resume+0xe4/0x120 arch/arm64/kernel/signal.c:421
> > > > [<ffff200008083e68>] work_pending+0x8/0x14
> > >
> > > So we're being serviced with a signal. Do you know if this signal is
> > > generated by your syzkaller program? We could be racing between do_exit
> > > triggered by a fatal signal (this trace) and the closing of the two file
> > > descriptors (vcpu and vm).
> > >
> > > Paolo: does this look possible to you? I can't see what locking we have
> > > that could prevent this race.
> >
> > On a quick look, I see two issues:
> >
> > 1) It looks like the mmu_notifier->ops.release could be called twice for a notifier,
> > from mmu_notifier_unregister() and exit_mmap()->mmu_notifier_release(), which is
> > causing the problem as above.
> >
> > This could possibly be avoided by swapping the order of the following operations
> > in themmu_notifier_unregister():
> >
> >  a) Invoke ops->release under src_read_lock()
> >  b) Delete the notifier from the list.
> >
> > which can prevent mmu_notifier_release() calling the ops->release() again, before
> > we reach (b).
> >
> >
> > 2) The core KVM code does an mmgrab()/mmdrop on the current->mm to pin the mm_struct. But
> > this doesn't prevent the "real_address user space" from being destroyed. Since KVM
> > actually depends on the user pages and page tables, it should really/also(?) use
> > mmget()/mmput() (See Documentation/vm/active_mm.txt). I understand that mmget() shouldn't
> > be used for pinning unbounded amount of time. But since we do it from within the same
> > process context (like say threads), we should be safe to do so.
>

Option 2 doesn't work, as it creates a circular dependency with exit_mmap vs kvm_destory_vm
due to the mmap on VCPU (which prevents KVM from getting dropped). After a couple of trials
at resolving this issue, we have something better to resolve it, below.

----8>----

kvm: Fix mmu_notifier release race

The KVM uses mmu_notifier (wherever available) to keep track
of the changes to the mm of the guest. The guest shadow page
tables are released when the VM exits via mmu_notifier->ops.release().
There is a rare chance that the mmu_notifier->release could be
called more than once via two different paths, which could end
up in use-after-free of kvm instance.

e.g:

thread A                                        thread B
-------                                         --------------

 get_signal->                                   kvm_destroy_vm()->
 do_exit->                                        mmu_notifier_unregister->
 exit_mm->                                        kvm_arch_flush_shadow_all()->
 exit_mmap->                                      spin_lock(&kvm->mmu_lock)
 mmu_notifier_release->                           ....
  kvm_arch_flush_shadow_all()->                   .....
  ... spin_lock(&kvm->mmu_lock)                   .....
                                                  spin_unlock(&kvm->mmu_lock)
                                                kvm_arch_free_kvm()
   *** use after free of kvm ***

This patch attempts to solve the problem by holding a reference to the KVM
for the mmu_notifier, which is dropped only from notifier->ops.release().
This will ensure that the KVM struct is available till we reach the
kvm_mmu_notifier_release, and the kvm_destroy_vm is called only from/after
it. So, we can unregister the notifier with no_release option and hence
avoiding the race above. However, we need to make sure that the KVM is
freed only after the mmu_notifier has finished processing the notifier due to
the following possible path of execution :

mmu_notifier_release -> kvm_mmu_notifier_release -> kvm_put_kvm ->
  kvm_destroy_vm -> kvm_arch_free_kvm

Reported-by: andreyknvl@google.com
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paolo Bonzin <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: andreyknvl@google.com
Cc: Marc Zyngier <marc.zyngier@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 59 ++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d025074..561e968 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -424,6 +424,7 @@ struct kvm {
 	struct mmu_notifier mmu_notifier;
 	unsigned long mmu_notifier_seq;
 	long mmu_notifier_count;
+	struct rcu_head mmu_notifier_rcu;
 #endif
 	long tlbs_dirty;
 	struct list_head devices;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 88257b3..2c3fdd4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -471,6 +471,7 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 	idx = srcu_read_lock(&kvm->srcu);
 	kvm_arch_flush_shadow_all(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
+	kvm_put_kvm(kvm);
 }
 
 static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
@@ -486,8 +487,46 @@ static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
 
 static int kvm_init_mmu_notifier(struct kvm *kvm)
 {
+	int rc;
 	kvm->mmu_notifier.ops = &kvm_mmu_notifier_ops;
-	return mmu_notifier_register(&kvm->mmu_notifier, current->mm);
+	rc = mmu_notifier_register(&kvm->mmu_notifier, current->mm);
+	/*
+	 * We hold a reference to KVM here to make sure that the KVM
+	 * doesn't get free'd before ops->release() completes.
+	 */
+	if (!rc)
+		kvm_get_kvm(kvm);
+	return rc;
+}
+
+static void kvm_free_vm_rcu(struct rcu_head *rcu)
+{
+	struct kvm *kvm = container_of(rcu, struct kvm, mmu_notifier_rcu);
+	kvm_arch_free_vm(kvm);
+}
+
+static void kvm_flush_shadow_mmu(struct kvm *kvm)
+{
+	/*
+	 * We hold a reference to kvm instance for mmu_notifier and is
+	 * only released when ops->release() is called via exit_mmap path.
+	 * So, when we reach here ops->release() has been called already, which
+	 * flushes the shadow page tables. Hence there is no need to call the
+	 * release() again when we unregister the notifier. However, we need
+	 * to delay freeing up the kvm until the release() completes, since
+	 * we could reach here via :
+	 *  kvm_mmu_notifier_release() -> kvm_put_kvm() -> kvm_destroy_vm()
+	 */
+	mmu_notifier_unregister_no_release(&kvm->mmu_notifier, kvm->mm);
+}
+
+static void kvm_free_vm(struct kvm *kvm)
+{
+	/*
+	 * Wait until the mmu_notifier has finished the release().
+	 * See comments above in kvm_flush_shadow_mmu.
+	 */
+	mmu_notifier_call_srcu(&kvm->mmu_notifier_rcu, kvm_free_vm_rcu);
 }
 
 #else  /* !(CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER) */
@@ -497,6 +536,16 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
 	return 0;
 }
 
+static void kvm_flush_shadow_mmu(struct kvm *kvm)
+{
+	kvm_arch_flush_shadow_all(kvm);
+}
+
+static void kvm_free_vm(struct kvm *kvm)
+{
+	kvm_arch_free_vm(kvm);
+}
+
 #endif /* CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER */
 
 static struct kvm_memslots *kvm_alloc_memslots(void)
@@ -733,18 +782,14 @@ static void kvm_destroy_vm(struct kvm *kvm)
 		kvm->buses[i] = NULL;
 	}
 	kvm_coalesced_mmio_free(kvm);
-#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
-	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
-#else
-	kvm_arch_flush_shadow_all(kvm);
-#endif
+	kvm_flush_shadow_mmu(kvm);
 	kvm_arch_destroy_vm(kvm);
 	kvm_destroy_devices(kvm);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 		kvm_free_memslots(kvm, kvm->memslots[i]);
 	cleanup_srcu_struct(&kvm->irq_srcu);
 	cleanup_srcu_struct(&kvm->srcu);
-	kvm_arch_free_vm(kvm);
+	kvm_free_vm(kvm);
 	preempt_notifier_dec();
 	hardware_disable_all();
 	mmdrop(mm);
-- 
2.7.4

 
