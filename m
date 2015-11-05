From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm: Fix crash in free_hyp_pgds() if timer
 initialization fails
Date: Thu, 5 Nov 2015 16:24:40 +0100
Message-ID: <20151105152440.GF5819@cbox>
References: <1445931608-8824-1-git-send-email-p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445931608-8824-1-git-send-email-p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,

On Tue, Oct 27, 2015 at 10:40:08AM +0300, Pavel Fedin wrote:
> After vGIC initialization succeeded, and timer initialization failed,
> the following crash can be observed on ARM32:
> 
> kvm [1]: interrupt-controller@10484000 IRQ57
> kvm [1]: kvm_arch_timer: can't find DT node
> Unable to handle kernel paging request at virtual address 90484000
> pgd = c0003000
> [90484000] *pgd=80000040006003, *pmd=00000000
> Internal error: Oops: 2a06 [#1] PREEMPT SMP ARM
> ...
> [<c003b790>] (v7_flush_kern_dcache_area) from [<c001d638>] (kvm_flush_dcache_pte+0x48/0x5c)
> [<c001d638>] (kvm_flush_dcache_pte) from [<c001d898>] (unmap_range+0x24c/0x460)
> [<c001d898>] (unmap_range) from [<c001ea4c>] (free_hyp_pgds+0x84/0x160)
> [<c001ea4c>] (free_hyp_pgds) from [<c001c85c>] (kvm_arch_init+0x254/0x41c)
> [<c001c85c>] (kvm_arch_init) from [<c00122b0>] (kvm_init+0x28/0x2b4)
> [<c00122b0>] (kvm_init) from [<c0009988>] (do_one_initcall+0x9c/0x200)
> 
> This happens when unmapping reaches mapped vGIC control registers. The
> problem root seems to be combination of two facts:
> 1. vGIC control region is defined in device trees as having size of
>    0x2000. But the specification defines only registers up to 0x1FC,
>    therefore it is only one page, not two.
> 2. unmap_ptes() is expected to recognize device memory and omit cache
>    flushing. However, it tests only for PAGE_S2_DEVICE, while devices
>    mapped for HYP mode have PAGE_HYP_DEVICE, which is different.
>    Therefore, cache flush is attempted, and it dies when hitting the
>    nonexistent second page.
> 
> This patch fixes the problem by adding missing recognition of
> PAGE_HYP_DEVICE protection value.
> 
> The crash can be observed on Exynos 5410 (and probably on all Exynos5
> family) with stock device trees (using MCT) and CONFIG_KVM enabled.
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> ---
>  arch/arm/kvm/mmu.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 7b42012..839dd970 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -213,7 +213,10 @@ static void unmap_ptes(struct kvm *kvm, pmd_t *pmd,
>  			kvm_tlb_flush_vmid_ipa(kvm, addr);
>  
>  			/* No need to invalidate the cache for device mappings */
> -			if ((pte_val(old_pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
> +			if (((pte_val(old_pte) & PAGE_S2_DEVICE)
> +			     != PAGE_S2_DEVICE) &&
> +			    ((pte_val(old_pte) & PAGE_HYP_DEVICE)
> +			     != PAGE_HYP_DEVICE))
>  				kvm_flush_dcache_pte(old_pte);
>  
>  			put_page(virt_to_page(pte));
> -- 
> 2.4.4
> 

Did you check if PAGE_HYP_DEVICE can mean something sane on a stage-2
page table entry and vice verse?

Also, the commit message and formatting here is horrible, see this
reworked version:

>From e15700dd24419bb0e7ddc79feaa4efdf20304f2c Mon Sep 17 00:00:00 2001
From: Pavel Fedin <p.fedin@samsung.com>
Date: Tue, 27 Oct 2015 10:40:08 +0300
Subject: [PATCH] KVM: arm: Don't try to flush hyp-mode device mappings

The unmap_ptes function is currently called to unmap both Stage-2 and
Hyp mode page table entries.  Since calling clean and invalidate on
device memory may raise exceptions, we currently test against
PAGE_S2_DEVICE and do not flush for such mappings.  However, we should
also be testing against PAGE_HYP_DEVICE.

This fixes an issue observed on some 32-bit platforms, for example the
Exynos 5410.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/mmu.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 6984342..f0c3aef 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -206,18 +206,20 @@ static void unmap_ptes(struct kvm *kvm, pmd_t *pmd,
 
 	start_pte = pte = pte_offset_kernel(pmd, addr);
 	do {
-		if (!pte_none(*pte)) {
-			pte_t old_pte = *pte;
+		if (pte_none(*pte))
+			continue;
 
-			kvm_set_pte(pte, __pte(0));
-			kvm_tlb_flush_vmid_ipa(kvm, addr);
+		pte_t old_pte = *pte;
 
-			/* No need to invalidate the cache for device mappings */
-			if ((pte_val(old_pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
-				kvm_flush_dcache_pte(old_pte);
+		kvm_set_pte(pte, __pte(0));
+		kvm_tlb_flush_vmid_ipa(kvm, addr);
 
-			put_page(virt_to_page(pte));
-		}
+		/* No need to invalidate the cache for device mappings */
+		if ((pte_val(old_pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE &&
+		    (pte_val(old_pte) & PAGE_HYP_DEVICE) != PAGE_HYP_DEVICE)
+			kvm_flush_dcache_pte(old_pte);
+
+		put_page(virt_to_page(pte));
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
 	if (kvm_pte_table_empty(kvm, start_pte))
-- 
2.1.2.330.g565301e.dirty

