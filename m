From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [RFC] Question about TLB flush while set Stage-2 huge pages
Date: Thu, 14 Mar 2019 10:55:37 +0000
Message-ID: <20190314105537.GA15323@en101>
References: <5f712cc6-0874-adbe-add6-46f5de24f36f@huawei.com>
 <e2a94937-c324-e2d6-7e61-3f998e6e6e22@arm.com>
 <1c0e07b9-73f0-efa4-c1b7-ad81789b42c5@huawei.com>
 <5188e3b9-5b5a-a6a7-7ef0-09b7b4f06af6@arm.com>
 <348d0b3b-c74b-7b39-ec30-85905c077c38@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <348d0b3b-c74b-7b39-ec30-85905c077c38@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zheng Xiang <zhengxiang9@huawei.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, christoffer.dall@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Wang Haibin <wanghaibin.wang@huawei.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, lious.lilei@hisilicon.com, lishuo1@hisilicon.com, suzuki.poulose@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Zheng,

On Wed, Mar 13, 2019 at 05:45:31PM +0800, Zheng Xiang wrote:
> 
> 
> On 2019/3/13 2:18, Marc Zyngier wrote:
> > Hi Zheng,
> > 
> > On 12/03/2019 15:30, Zheng Xiang wrote:
> >> Hi Marc,
> >>
> >> On 2019/3/12 19:32, Marc Zyngier wrote:
> >>> Hi Zheng,
> >>>
> >>> On 11/03/2019 16:31, Zheng Xiang wrote:
> >>>> Hi all,
> >>>>
> >>>> While a page is merged into a transparent huge page, KVM will invalidate Stage-2 for
> >>>> the base address of the huge page and the whole of Stage-1.
> >>>> However, this just only invalidates the first page within the huge page and the other
> >>>> pages are not invalidated, see bellow:
> >>>>
> >>>>     +---------------+--------------+
> >>>>     |abcde       2MB-Page          |
> >>>>     +---------------+--------------+
> >>>>
> >>>>     TLB before setting new pmd:
> >>>>     +---------------+--------------+
> >>>>     |      VA       |    PAGESIZE  |
> >>>>     +---------------+--------------+
> >>>>     |      a        |      4KB     |
> >>>>     +---------------+--------------+
> >>>>     |      b        |      4KB     |
> >>>>     +---------------+--------------+
> >>>>     |      c        |      4KB     |
> >>>>     +---------------+--------------+
> >>>>     |      d        |      4KB     |
> >>>>     +---------------+--------------+
> >>>>
> >>>>     TLB after setting new pmd:
> >>>>     +---------------+--------------+
> >>>>     |      VA       |    PAGESIZE  |
> >>>>     +---------------+--------------+
> >>>>     |      a        |      2MB     |
> >>>>     +---------------+--------------+
> >>>>     |      b        |      4KB     |
> >>>>     +---------------+--------------+
> >>>>     |      c        |      4KB     |
> >>>>     +---------------+--------------+
> >>>>     |      d        |      4KB     |
> >>>>     +---------------+--------------+
> >>>>
> >>>> When VM access *b* address, it will hit the TLB and result in TLB conflict aborts or other potential exceptions.
> >>>
> >>> That's really bad. I can only imagine two scenarios:
> >>>
> >>> 1) We fail to unmap a,b,c,d (and potentially another 508 PTEs), loosing
> >>> the PTE table in the process, and place the PMD instead. I can't see
> >>> this happening.
> >>>
> >>> 2) We fail to invalidate on unmap, and that slightly less bad (but still
> >>> quite bad).
> >>>
> >>> Which of the two cases are you seeing?
> >>>
> >>>> For example, we need to keep tracking of the VM memory dirty pages when VM is in live migration.
> >>>> KVM will set the memslot READONLY and split the huge pages.
> >>>> After live migration is canceled and abort, the pages will be merged into THP.
> >>>> The later access to these pages which are READONLY will cause level-3 Permission Fault until they are invalidated.
> >>>>
> >>>> So should we invalidate the tlb entries for all relative pages(e.g a,b,c,d), like __flush_tlb_range()?
> >>>> Or we can call __kvm_tlb_flush_vmid() to invalidate all tlb entries.
> >>>
> >>> We should perform an invalidate on each unmap. unmap_stage2_range seems
> >>> to do the right thing. __flush_tlb_range only caters for Stage1
> >>> mappings, and __kvm_tlb_flush_vmid() is too big a hammer, as it nukes
> >>> TLBs for the whole VM.
> >>>
> >>> I'd really like to understand what you're seeing, and how to reproduce
> >>> it. Do you have a minimal example I could run on my own HW?
> >>
> >> When I start the live migration for a VM, qemu then begins to log and count dirty pages.
> >> During the live migration, KVM set the pages READONLY so that we can count how many pages
> >> would be wrote afterwards.
> >>
> >> Anything is OK until I cancel the live migration and qemu stop logging. Later the VM gets hang.
> >> The trace log shows repeatedly level-3 permission fault caused by a write on a same IPA. After
> >> analyzing the source code, I find KVM always return from the bellow *if* statement in
> >> stage2_set_pmd_huge() even if we only have a single VCPU:
> >>
> >>         /*
> >>          * Multiple vcpus faulting on the same PMD entry, can
> >>          * lead to them sequentially updating the PMD with the
> >>          * same value. Following the break-before-make
> >>          * (pmd_clear() followed by tlb_flush()) process can
> >>          * hinder forward progress due to refaults generated
> >>          * on missing translations.
> >>          *
> >>          * Skip updating the page table if the entry is
> >>          * unchanged.
> >>          */
> >>         if (pmd_val(old_pmd) == pmd_val(*new_pmd))
> >>             return 0;
> >>
> >> The PMD has already set the PMD_S2_RDWR bit. I doubt kvm_tlb_flush_vmid_ipa() does not invalidate
> >> Stage-2 for the subpages of the PMD(except the first PTE of this PMD). Finally I add some debug
> >> code to flush tlb for all subpages of the PMD, as shown bellow:
> >>
> >>         /*
> >>          * Mapping in huge pages should only happen through a
> >>          * fault.  If a page is merged into a transparent huge
> >>          * page, the individual subpages of that huge page
> >>          * should be unmapped through MMU notifiers before we
> >>          * get here.
> >>          *
> >>          * Merging of CompoundPages is not supported; they
> >>          * should become splitting first, unmapped, merged,
> >>          * and mapped back in on-demand.
> >>          */
> >>         VM_BUG_ON(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
> >>
> >>         pmd_clear(pmd);
> >>         for (cnt = 0; cnt < 512; cnt++)
> >>             kvm_tlb_flush_vmid_ipa(kvm, addr + cnt*PAGE_SIZE);
> >>
> >> Then the problem no longer reproduce.
> > 
> > This makes very little sense. We shouldn't be able to enter this path
> > for anything else but a permission update, otherwise the VM_BUG_ON
> > should fire.
> 
> Hmm, I think I didn't describe it very clearly.
> Look at the following sequence:
> 
> 1) Set a PMD READONLY and logging_active.
> 
> 2) KVM handles permission fault caused by writing a subpage(assumpt *b*) within this huge PMD.
> 
> 3) KVM dissolves PMD and invalidates TLB for this PMD. Then set a writable PTE.
> 
> 4) Read another 511 PTEs and setup Stage-2 PTE table.
> 
> 5) Now remove logging_active and keep another 511 PTEs READONLY.
> 
> 6) VM continues to write a subpage(assumpt *c*) and cause permission fault.
> 
> 7) KVM handles this new fault and makes a new writable PMD after transparent_hugepage_adjust().
> 
> 8) KVM invalidates TLB for the first page(*a*) of the PMD.
>    Here another 511 RO PTEs entries still stay in TLB, especially *c* which will be wrote later.
> 
> 9) KVM then set this new writable PMD.
>    Step 8-9 is what stage2_set_pmd_huge() does.
> 
> 10) VM continues to write *c*, but this time it hits the RO PTE entry in TLB and causes permission fault again.
>    Sometimes it can also cause TLB conflict aborts.
> 
> 11) KVM repeats step 6 and goes to the following statement and return 0:
> 
>          * Skip updating the page table if the entry is
>          * unchanged.
>          */
>         if (pmd_val(old_pmd) == pmd_val(*new_pmd))
>             return 0;
> 
> 12) Then it will repeat step 10-11 until the PTE entry is invalidated.
> 
> I think there is something abnormal in step 8.
> Should I blame my hardware? Or is it a kernel bug?

Marc and I had a discussion about this and it looks like we may have an
issue here. So with the cancellation of logging, we do not trigger the
mmu_notifiers (as the userspace memory mapping hasn't changed) and thus
have memory leaks while trying to install a huge mapping. Would it be
possible for you to try the patch below ? It will trigger a WARNING
to confirm our theory, but should not cause the hang. As we unmap
the PMD/PUD range of PTE mappings before reinstalling a block map.


---8>---

test: kvm: arm: Fix handling of stage2 huge mappings

We rely on the mmu_notifier call backs to handle the split/merging
of huge pages and thus we are guaranteed that while creating a
block mapping, the entire block is unmapped at stage2. However,
we miss a case where the block mapping is split for dirty logging
case and then could later be made block mapping, if we cancel the
dirty logging. This not only creates inconsistent TLB entries for
the pages in the the block, but also leakes the table pages for
PMD level.

Handle these corner cases for the huge mappings at stage2.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 virt/kvm/arm/mmu.c | 51 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 66e0fbb5..04b0f9b 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1076,24 +1076,38 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 		 * Skip updating the page table if the entry is
 		 * unchanged.
 		 */
-		if (pmd_val(old_pmd) == pmd_val(*new_pmd))
+		if (pmd_val(old_pmd) == pmd_val(*new_pmd)) {
 			return 0;
-
+		} else if (WARN_ON_ONCE(!pmd_thp_or_huge(old_pmd))) {
 		/*
-		 * Mapping in huge pages should only happen through a
-		 * fault.  If a page is merged into a transparent huge
-		 * page, the individual subpages of that huge page
-		 * should be unmapped through MMU notifiers before we
-		 * get here.
-		 *
-		 * Merging of CompoundPages is not supported; they
-		 * should become splitting first, unmapped, merged,
-		 * and mapped back in on-demand.
+		 * If we have PTE level mapping for this block,
+		 * we must unmap it to avoid inconsistent TLB
+		 * state. We could end up in this situation if
+		 * the memory slot was marked for dirty logging
+		 * and was reverted, leaving PTE level mappings
+		 * for the pages accessed during the period.
+		 * Normal THP split/merge follows mmu_notifier
+		 * callbacks and do get handled accordingly.
 		 */
-		VM_BUG_ON(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
+			unmap_stage2_range(kvm, (addr & S2_PMD_MASK), S2_PMD_SIZE);
+		} else {
 
-		pmd_clear(pmd);
-		kvm_tlb_flush_vmid_ipa(kvm, addr);
+			/*
+			 * Mapping in huge pages should only happen through a
+			 * fault.  If a page is merged into a transparent huge
+			 * page, the individual subpages of that huge page
+			 * should be unmapped through MMU notifiers before we
+			 * get here.
+			 *
+			 * Merging of CompoundPages is not supported; they
+			 * should become splitting first, unmapped, merged,
+			 * and mapped back in on-demand.
+			 */
+			WARN_ON_ONCE(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
+
+			pmd_clear(pmd);
+			kvm_tlb_flush_vmid_ipa(kvm, addr);
+		}
 	} else {
 		get_page(virt_to_page(pmd));
 	}
@@ -1122,8 +1136,13 @@ static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cac
 		return 0;
 
 	if (stage2_pud_present(kvm, old_pud)) {
-		stage2_pud_clear(kvm, pudp);
-		kvm_tlb_flush_vmid_ipa(kvm, addr);
+		/* If we have PTE level mapping, unmap the entire range */
+		if (WARN_ON_ONCE(!stage2_pud_huge(kvm, old_pud))) {
+			unmap_stage2_range(kvm, addr & S2_PUD_MASK, S2_PUD_SIZE);
+		} else {
+			stage2_pud_clear(kvm, pudp);
+			kvm_tlb_flush_vmid_ipa(kvm, addr);
+		}
 	} else {
 		get_page(virt_to_page(pudp));
 	}
-- 
2.7.4



> 
> -- 
> 
> Thanks,
> Xiang
> 
> 
