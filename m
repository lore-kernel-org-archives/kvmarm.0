From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v3] kvm: arm/arm64: Fix locking for kvm_free_stage2_pgd
Date: Mon, 24 Apr 2017 10:42:08 +0100
Message-ID: <20170424094207.GA28207@e107814-lin.cambridge.arm.com>
References: <1491228763-23450-1-git-send-email-suzuki.poulose@arm.com>
 <20170404101316.GF11752@cbox>
 <28bece63-9917-5f00-ccdf-fe663def500f@arm.com>
 <febea966-3767-21ff-3c40-1a76d1399138@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <febea966-3767-21ff-3c40-1a76d1399138@suse.de>
Sender: kvm-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>
Cc: Christoffer Dall <cdall@linaro.org>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, ard.biesheuvel@linaro.org, marc.zyngier@arm.com, andreyknvl@google.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, kcc@google.com, syzkaller@googlegroups.com, dvyukov@google.com, catalin.marinas@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Apr 22, 2017 at 02:28:44AM +0200, Alexander Graf wrote:
> 
> 
> On 04.04.17 12:35, Suzuki K Poulose wrote:
> > Hi Christoffer,
> > 
> > On 04/04/17 11:13, Christoffer Dall wrote:
> > > Hi Suzuki,
> > > 
> > > On Mon, Apr 03, 2017 at 03:12:43PM +0100, Suzuki K Poulose wrote:
> > > > In kvm_free_stage2_pgd() we don't hold the kvm->mmu_lock while calling
> > > > unmap_stage2_range() on the entire memory range for the guest. This
> > > > could
> > > > cause problems with other callers (e.g, munmap on a memslot) trying to
> > > > unmap a range. And since we have to unmap the entire Guest memory range
> > > > holding a spinlock, make sure we yield the lock if necessary, after we
> > > > unmap each PUD range.
> > > > 
> > > > Fixes: commit d5d8184d35c9 ("KVM: ARM: Memory virtualization setup")
> > > > Cc: stable@vger.kernel.org # v3.10+
> > > > Cc: Paolo Bonzini <pbonzin@redhat.com>
> > > > Cc: Marc Zyngier <marc.zyngier@arm.com>
> > > > Cc: Christoffer Dall <christoffer.dall@linaro.org>
> > > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > [ Avoid vCPU starvation and lockup detector warnings ]
> > > > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > 
> > > 
> > > This unfortunately fails to build on 32-bit ARM, and I also think we
> > > intended to check against S2_PGDIR_SIZE, not S2_PUD_SIZE.
> > 
> > Sorry about that, I didn't test the patch with arm32. I am fine the
> > patch below. And I agree that the name change does make things more
> > readable. See below for a hunk that I posted to the kbuild report.
> > 
> > > 
> > > How about adding this to your patch (which includes a rename of
> > > S2_PGD_SIZE which is horribly confusing as it indicates the size of the
> > > first level stage-2 table itself, where S2_PGDIR_SIZE indicates the size
> > > of address space mapped by a single entry in the same table):
> > > 
> > > diff --git a/arch/arm/include/asm/stage2_pgtable.h
> > > b/arch/arm/include/asm/stage2_pgtable.h
> > > index 460d616..c997f2d 100644
> > > --- a/arch/arm/include/asm/stage2_pgtable.h
> > > +++ b/arch/arm/include/asm/stage2_pgtable.h
> > > @@ -35,10 +35,13 @@
> > > 
> > >  #define stage2_pud_huge(pud)            pud_huge(pud)
> > > 
> > > +#define S2_PGDIR_SIZE                PGDIR_SIZE
> > > +#define S2_PGDIR_MASK                PGDIR_MASK
> > > +
> > >  /* Open coded p*d_addr_end that can deal with 64bit addresses */
> > >  static inline phys_addr_t stage2_pgd_addr_end(phys_addr_t addr,
> > > phys_addr_t end)
> > >  {
> > > -    phys_addr_t boundary = (addr + PGDIR_SIZE) & PGDIR_MASK;
> > > +    phys_addr_t boundary = (addr + S2_PGDIR_SIZE) & S2_PGDIR_MASK;
> > > 
> > >      return (boundary - 1 < end - 1) ? boundary : end;
> > >  }
> > > diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> > > index db94f3a..6e79a4c 100644
> > > --- a/arch/arm/kvm/mmu.c
> > > +++ b/arch/arm/kvm/mmu.c
> > > @@ -41,7 +41,7 @@ static unsigned long hyp_idmap_start;
> > >  static unsigned long hyp_idmap_end;
> > >  static phys_addr_t hyp_idmap_vector;
> > > 
> > > -#define S2_PGD_SIZE    (PTRS_PER_S2_PGD * sizeof(pgd_t))
> > > +#define S2_PGD_TABLE_SIZE    (PTRS_PER_S2_PGD * sizeof(pgd_t))
> > >  #define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
> > > 
> > >  #define KVM_S2PTE_FLAG_IS_IOMAP        (1UL << 0)
> > > @@ -299,7 +299,7 @@ static void unmap_stage2_range(struct kvm *kvm,
> > > phys_addr_t start, u64 size)
> > >           * If the range is too large, release the kvm->mmu_lock
> > >           * to prevent starvation and lockup detector warnings.
> > >           */
> > > -        if (size > S2_PUD_SIZE)
> > > +        if (size > S2_PGDIR_SIZE)
> > >              cond_resched_lock(&kvm->mmu_lock);
> > >          next = stage2_pgd_addr_end(addr, end);
> > >          if (!stage2_pgd_none(*pgd))
> > > @@ -747,7 +747,7 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
> > >      }
> > > 
> > >      /* Allocate the HW PGD, making sure that each page gets its own
> > > refcount */
> > > -    pgd = alloc_pages_exact(S2_PGD_SIZE, GFP_KERNEL | __GFP_ZERO);
> > > +    pgd = alloc_pages_exact(S2_PGD_TABLE_SIZE, GFP_KERNEL | __GFP_ZERO);
> > >      if (!pgd)
> > >          return -ENOMEM;
> > > 
> > > @@ -843,7 +843,7 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
> > >      spin_unlock(&kvm->mmu_lock);
> > > 
> > >      /* Free the HW pgd, one page at a time */
> > > -    free_pages_exact(kvm->arch.pgd, S2_PGD_SIZE);
> > > +    free_pages_exact(kvm->arch.pgd, S2_PGD_TABLE_SIZE);
> > >      kvm->arch.pgd = NULL;
> > >  }
> > > 
> > 
> > Btw, I have a different hunk to solve the problem, posted to the kbuild
> > report. I will post it here for the sake of capturing the discussion in
> > one place. The following hunk on top of the patch, changes the lock
> > release after we process one PGDIR entry. As for the first time
> > we enter the loop we haven't done much with the lock held, hence it may
> > make
> > sense to do it after the first round and we have more work to do.
> > 
> > diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> > index db94f3a..582a972 100644
> > --- a/arch/arm/kvm/mmu.c
> > +++ b/arch/arm/kvm/mmu.c
> > @@ -295,15 +295,15 @@ static void unmap_stage2_range(struct kvm *kvm,
> > phys_addr_t start, u64 size)
> >         assert_spin_locked(&kvm->mmu_lock);
> >         pgd = kvm->arch.pgd + stage2_pgd_index(addr);
> >         do {
> > +               next = stage2_pgd_addr_end(addr, end);
> > +               if (!stage2_pgd_none(*pgd))
> 
> Just as heads up, I had this version applied to my tree by accident (commit
> 8b3405e345b5a098101b0c31b264c812bba045d9 from Christoffer's queue) and ran
> into a NULL pointer dereference:
> 
> [223090.242280] Unable to handle kernel NULL pointer dereference at virtual
> address 00000040
> [223090.262330] PC is at unmap_stage2_range+0x8c/0x428
> [223090.262332] LR is at kvm_unmap_hva_handler+0x2c/0x3c
> [223090.262531] Call trace:
> [223090.262533] [<ffff0000080adb78>] unmap_stage2_range+0x8c/0x428
> [223090.262535] [<ffff0000080adf40>] kvm_unmap_hva_handler+0x2c/0x3c
> [223090.262537] [<ffff0000080ace2c>] handle_hva_to_gpa+0xb0/0x104
> [223090.262539] [<ffff0000080af988>] kvm_unmap_hva+0x5c/0xbc
> [223090.262543] [<ffff0000080a2478>]
> kvm_mmu_notifier_invalidate_page+0x50/0x8c
> [223090.262547] [<ffff0000082274f8>]
> __mmu_notifier_invalidate_page+0x5c/0x84
> [223090.262551] [<ffff00000820b700>] try_to_unmap_one+0x1d0/0x4a0
> [223090.262553] [<ffff00000820c5c8>] rmap_walk+0x1cc/0x2e0
> [223090.262555] [<ffff00000820c90c>] try_to_unmap+0x74/0xa4
> [223090.262557] [<ffff000008230ce4>] migrate_pages+0x31c/0x5ac
> [223090.262561] [<ffff0000081f869c>] compact_zone+0x3fc/0x7ac
> [223090.262563] [<ffff0000081f8ae0>] compact_zone_order+0x94/0xb0
> [223090.262564] [<ffff0000081f91c0>] try_to_compact_pages+0x108/0x290
> [223090.262569] [<ffff0000081d5108>] __alloc_pages_direct_compact+0x70/0x1ac
> [223090.262571] [<ffff0000081d64a0>] __alloc_pages_nodemask+0x434/0x9f4
> [223090.262572] [<ffff0000082256f0>] alloc_pages_vma+0x230/0x254
> [223090.262574] [<ffff000008235e5c>] do_huge_pmd_anonymous_page+0x114/0x538
> [223090.262576] [<ffff000008201bec>] handle_mm_fault+0xd40/0x17a4
> [223090.262577] [<ffff0000081fb324>] __get_user_pages+0x12c/0x36c
> [223090.262578] [<ffff0000081fb804>] get_user_pages_unlocked+0xa4/0x1b8
> [223090.262579] [<ffff0000080a3ce8>] __gfn_to_pfn_memslot+0x280/0x31c
> [223090.262580] [<ffff0000080a3dd0>] gfn_to_pfn_prot+0x4c/0x5c
> [223090.262582] [<ffff0000080af3f8>] kvm_handle_guest_abort+0x240/0x774
> [223090.262584] [<ffff0000080b2bac>] handle_exit+0x11c/0x1ac
> [223090.262586] [<ffff0000080ab99c>] kvm_arch_vcpu_ioctl_run+0x31c/0x648
> [223090.262587] [<ffff0000080a1d78>] kvm_vcpu_ioctl+0x378/0x768
> [223090.262590] [<ffff00000825df5c>] do_vfs_ioctl+0x324/0x5a4
> [223090.262591] [<ffff00000825e26c>] SyS_ioctl+0x90/0xa4
> [223090.262595] [<ffff000008085d84>] el0_svc_naked+0x38/0x3c
> 
> 0xffff0000080adb78 is in unmap_stage2_range (../arch/arm/kvm/mmu.c:260).
> 255		pud_t *pud, *start_pud;
> 256
> 257		start_pud = pud = stage2_pud_offset(pgd, addr);
> 258		do {
> 259			next = stage2_pud_addr_end(addr, end);
> 260			if (!stage2_pud_none(*pud)) {
> 261				if (stage2_pud_huge(*pud)) {
> 262					pud_t old_pud = *pud;
> 263
> 264					stage2_pud_clear(pud);
> 
> 
> So please beware that for some reason pud may become invalid after
> rescheduling.

Alex,

Thanks for the report. The patch below should fix this one.

---8>---

kvm: arm/arm64: Fix race in resetting stage2 PGD

In kvm_free_stage2_pgd() we check the stage2 PGD before holding
the lock and proceed to take the lock if it is valid. And we unmap
the page tables, followed by releasing the lock. We reset the PGD
only after dropping this lock, which could cause a race condition
where another thread waiting on the lock could potentially see that
the PGD is still valid and proceed to perform a stage2 operation.

This patch moves the stage2 PGD manipulation under the lock.

Reported-by: Alexander Graf <agraf@suse.de>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm/kvm/mmu.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 582a972..9c4026d 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -835,16 +835,18 @@ void stage2_unmap_vm(struct kvm *kvm)
  */
 void kvm_free_stage2_pgd(struct kvm *kvm)
 {
-	if (kvm->arch.pgd == NULL)
-		return;
+	void *pgd = NULL;
 
 	spin_lock(&kvm->mmu_lock);
-	unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
+	if (kvm->arch.pgd) {
+		unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
+		pgd = kvm->arch.pgd;
+		kvm->arch.pgd = NULL;
+	}
 	spin_unlock(&kvm->mmu_lock);
-
 	/* Free the HW pgd, one page at a time */
-	free_pages_exact(kvm->arch.pgd, S2_PGD_SIZE);
-	kvm->arch.pgd = NULL;
+	if (pgd)
+		free_pages_exact(pgd, S2_PGD_SIZE);
 }
 
 static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
-- 
2.7.4
