From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [RFC] Question about TLB flush while set Stage-2 huge pages
Date: Mon, 18 Mar 2019 17:34:07 +0000
Message-ID: <20190318173405.GA31412@en101>
References: <5f712cc6-0874-adbe-add6-46f5de24f36f@huawei.com>
 <e2a94937-c324-e2d6-7e61-3f998e6e6e22@arm.com>
 <1c0e07b9-73f0-efa4-c1b7-ad81789b42c5@huawei.com>
 <5188e3b9-5b5a-a6a7-7ef0-09b7b4f06af6@arm.com>
 <348d0b3b-c74b-7b39-ec30-85905c077c38@huawei.com>
 <20190314105537.GA15323@en101>
 <368bd218-ac1d-19b2-6e92-960b91afee8b@huawei.com>
 <d322e126-4da2-6dfd-a86d-088dfb3bf0f4@huawei.com>
 <6aea4049-7860-7144-a7be-14f856cdc789@arm.com>
 <f6639daa-cfba-c65a-7320-c9dcc1ef8377@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f6639daa-cfba-c65a-7320-c9dcc1ef8377@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: zhengxiang9@huawei.com, marc.zyngier@arm.com, christoffer.dall@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, wanghaibin.wang@huawei.com, lious.lilei@hisilicon.com, lishuo1@hisilicon.com, suzuki.poulose@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi !
On Sun, Mar 17, 2019 at 09:34:11PM +0800, Zenghui Yu wrote:
> Hi Suzuki,
> 
> On 2019/3/15 22:56, Suzuki K Poulose wrote:
> >Hi Zhengui,
> 
> s/Zhengui/Zheng/
> 
> (I think you must wanted to say "Hi" to Zheng :-) )
> 

Sorry about that.

> 
> I have looked into your patch and the kernel log, and I believe that
> your patch had already addressed this issue. But I think we can do it
> a little better - two more points need to be handled with caution.
> 
> Take PMD hugepage (PMD_SIZE == 2M) for example:
>

...

> >Thats bad, we seem to be making upto 4 unbalanced put_page().
> >
> >>>>---
> >>>>   virt/kvm/arm/mmu.c | 51
> >>>>+++++++++++++++++++++++++++++++++++----------------
> >>>>   1 file changed, 35 insertions(+), 16 deletions(-)
> >>>>
> >>>>diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> >>>>index 66e0fbb5..04b0f9b 100644
> >>>>--- a/virt/kvm/arm/mmu.c
> >>>>+++ b/virt/kvm/arm/mmu.c
> >>>>@@ -1076,24 +1076,38 @@ static int stage2_set_pmd_huge(struct kvm
> >>>>*kvm, struct kvm_mmu_memory_cache
> >>>>            * Skip updating the page table if the entry is
> >>>>            * unchanged.
> >>>>            */
> >>>>-        if (pmd_val(old_pmd) == pmd_val(*new_pmd))
> >>>>+        if (pmd_val(old_pmd) == pmd_val(*new_pmd)) {
> >>>>               return 0;
> >>>>-
> >>>>+        } else if (WARN_ON_ONCE(!pmd_thp_or_huge(old_pmd))) {
> >>>>           /*
> >>>>-         * Mapping in huge pages should only happen through a
> >>>>-         * fault.  If a page is merged into a transparent huge
> >>>>-         * page, the individual subpages of that huge page
> >>>>-         * should be unmapped through MMU notifiers before we
> >>>>-         * get here.
> >>>>-         *
> >>>>-         * Merging of CompoundPages is not supported; they
> >>>>-         * should become splitting first, unmapped, merged,
> >>>>-         * and mapped back in on-demand.
> >>>>+         * If we have PTE level mapping for this block,
> >>>>+         * we must unmap it to avoid inconsistent TLB
> >>>>+         * state. We could end up in this situation if
> >>>>+         * the memory slot was marked for dirty logging
> >>>>+         * and was reverted, leaving PTE level mappings
> >>>>+         * for the pages accessed during the period.
> >>>>+         * Normal THP split/merge follows mmu_notifier
> >>>>+         * callbacks and do get handled accordingly.
> >>>>            */
> >>>>-        VM_BUG_ON(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
> >>>>+            unmap_stage2_range(kvm, (addr & S2_PMD_MASK),
> >>>>S2_PMD_SIZE);
> 
> First, using unmap_stage2_range() here is not quite appropriate. Suppose
> we've only accessed one 2M page in HPA [x, x+1]Gib range, with other
> pages unaccessed.  What will happen if unmap_stage2_range(this_2M_page)?
> We'll unexpectedly reach clear_stage2_pud_entry(), and things are going
> to get really bad.  So we'd better use unmap_stage2_ptes() here since we
> only want to unmap a 2M range.

Yes, you're right. If this PMD entry is the only entry in the parent PUD table,
then the PUD table may get free'd and we may install the table in a place which
is not plugged into the table.

> 
> 
> Second, consider below function stack:
> 
>   unmap_stage2_ptes()
>     clear_stage2_pmd_entry()
>       put_page(virt_to_page(pmd))
> 
> It seems that we have one "redundant" put_page() here, (thus comes the
> bad kernel log ... ,) but actually we do not.  By stage2_set_pmd_huge(),
> the PMD table entry will then point to a 2M block (originally pointed
> to a PTE table), the _refcount of this PMD-level table page should _not_
> change after unmap_stage2_ptes().  So what we really should do is adding
> a get_page() after unmapping to keep the _refcount a balance!

Yes we need an additional refcount on the new huge pmd table, if we are
tearing down the PTE level table.

> 
> 
> thoughts ? A simple patch below (based on yours) for details.
> 
> 
> thanks,
> 
> zenghui
> 
> 
> >>
> >>It seems that kvm decreases the _refcount of the page twice in
> >>transparent_hugepage_adjust()
> >>and unmap_stage2_range().
> >
> >But I thought we should be doing that on the head_page already, as this is
> >THP.
> >I will take a look and get back to you on this. Btw, is it possible for you
> >to turn on CONFIG_DEBUG_VM and re-run with the above patch ?
> >
> >Kind regards
> >Suzuki
> >
> 
> ---8<---
> 
> test: kvm: arm: Maybe two more fixes
> 
> Applied based on Suzuki's patch.
> 
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  virt/kvm/arm/mmu.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 05765df..ccd5d5d 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1089,7 +1089,9 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct
> kvm_mmu_memory_cache
>  		 * Normal THP split/merge follows mmu_notifier
>  		 * callbacks and do get handled accordingly.
>  		 */
> -			unmap_stage2_range(kvm, (addr & S2_PMD_MASK), S2_PMD_SIZE);
> +			addr &= S2_PMD_MASK;
> +			unmap_stage2_ptes(kvm, pmd, addr, addr + S2_PMD_SIZE);
> +			get_page(virt_to_page(pmd));
>  		} else {
> 
>  			/*
> @@ -1138,7 +1140,9 @@ static int stage2_set_pud_huge(struct kvm *kvm, struct
> kvm_mmu_memory_cache *cac
>  	if (stage2_pud_present(kvm, old_pud)) {
>  		/* If we have PTE level mapping, unmap the entire range */
>  		if (WARN_ON_ONCE(!stage2_pud_huge(kvm, old_pud))) {
> -			unmap_stage2_range(kvm, addr & S2_PUD_MASK, S2_PUD_SIZE);
> +			addr &= S2_PUD_MASK;
> +			unmap_stage2_pmds(kvm, pudp, addr, addr + S2_PUD_SIZE);
> +			get_page(virt_to_page(pudp));
>  		} else {
>  			stage2_pud_clear(kvm, pudp);
>  			kvm_tlb_flush_vmid_ipa(kvm, addr);

This makes it a bit tricky to follow the code. The other option is to
do something like :


---8>---

kvm: arm: Fix handling of stage2 huge mappings

We rely on the mmu_notifier call backs to handle the split/merging
of huge pages and thus we are guaranteed that while creating a
block mapping, the entire block is unmapped at stage2. However,
we miss a case where the block mapping is split for dirty logging
case and then could later be made block mapping, if we cancel the
dirty logging. This not only creates inconsistent TLB entries for
the pages in the the block, but also leakes the table pages for
PMD level.

Handle these corner cases for the huge mappings at stage2 by
unmapping the PTE level mapping. This could potentially release
the upper level table. So we need to restart the table walk
once we unmap the range.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 virt/kvm/arm/mmu.c | 57 +++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index fce0983..a38a3f1 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1060,25 +1060,41 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 {
 	pmd_t *pmd, old_pmd;
 
+retry:
 	pmd = stage2_get_pmd(kvm, cache, addr);
 	VM_BUG_ON(!pmd);
 
 	old_pmd = *pmd;
+	/*
+	 * Multiple vcpus faulting on the same PMD entry, can
+	 * lead to them sequentially updating the PMD with the
+	 * same value. Following the break-before-make
+	 * (pmd_clear() followed by tlb_flush()) process can
+	 * hinder forward progress due to refaults generated
+	 * on missing translations.
+	 *
+	 * Skip updating the page table if the entry is
+	 * unchanged.
+	 */
+	if (pmd_val(old_pmd) == pmd_val(*new_pmd))
+		return 0;
+
 	if (pmd_present(old_pmd)) {
 		/*
-		 * Multiple vcpus faulting on the same PMD entry, can
-		 * lead to them sequentially updating the PMD with the
-		 * same value. Following the break-before-make
-		 * (pmd_clear() followed by tlb_flush()) process can
-		 * hinder forward progress due to refaults generated
-		 * on missing translations.
-		 *
-		 * Skip updating the page table if the entry is
-		 * unchanged.
+		 * If we already have PTE level mapping for this block,
+		 * we must unmap it to avoid inconsistent TLB
+		 * state. We could end up in this situation if
+		 * the memory slot was marked for dirty logging
+		 * and was reverted, leaving PTE level mappings
+		 * for the pages accessed during the period.
+		 * Normal THP split/merge follows mmu_notifier
+		 * callbacks and do get handled accordingly.
+		 * Unmap the PTE level mapping and retry.
 		 */
-		if (pmd_val(old_pmd) == pmd_val(*new_pmd))
-			return 0;
-
+		if (!pmd_thp_or_huge(old_pmd)) {
+			unmap_stage2_range(kvm, (addr & S2_PMD_MASK), S2_PMD_SIZE);
+			goto retry;
+		}
 		/*
 		 * Mapping in huge pages should only happen through a
 		 * fault.  If a page is merged into a transparent huge
@@ -1090,8 +1106,7 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 		 * should become splitting first, unmapped, merged,
 		 * and mapped back in on-demand.
 		 */
-		VM_BUG_ON(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
-
+		WARN_ON_ONCE(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
 		pmd_clear(pmd);
 		kvm_tlb_flush_vmid_ipa(kvm, addr);
 	} else {
@@ -1107,6 +1122,7 @@ static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cac
 {
 	pud_t *pudp, old_pud;
 
+retry:
 	pudp = stage2_get_pud(kvm, cache, addr);
 	VM_BUG_ON(!pudp);
 
@@ -1122,8 +1138,17 @@ static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cac
 		return 0;
 
 	if (stage2_pud_present(kvm, old_pud)) {
-		stage2_pud_clear(kvm, pudp);
-		kvm_tlb_flush_vmid_ipa(kvm, addr);
+		/*
+		 * If we already have PTE level mapping, unmap the entire
+		 * range and retry.
+		 */
+		if (!stage2_pud_huge(kvm, old_pud)) {
+			unmap_stage2_range(kvm, addr & S2_PUD_MASK, S2_PUD_SIZE);
+			goto retry;
+		} else {
+			stage2_pud_clear(kvm, pudp);
+			kvm_tlb_flush_vmid_ipa(kvm, addr);
+		}
 	} else {
 		get_page(virt_to_page(pudp));
 	}
-- 
2.7.4


> -- 
> 1.8.3.1
> 
> 
> 
> 
> 
