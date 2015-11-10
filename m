From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 resend] ARM/arm64: KVM: test properly for a PTE's uncachedness
Date: Tue, 10 Nov 2015 15:11:20 +0100
Message-ID: <1447164680-16330-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: p.fedin@samsung.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The open coded tests for checking whether a PTE maps a page as
uncached use a flawed '(pte_val(xxx) & CONST) != CONST' pattern,
which is not guaranteed to work since the type of a mapping is
not a set of mutually exclusive bits

For HYP mappings, the type is an index into the MAIR table (i.e, the
index itself does not contain any information whatsoever about the
type of the mapping), and for stage-2 mappings it is a bit field where
normal memory and device types are defined as follows:

    #define MT_S2_NORMAL            0xf
    #define MT_S2_DEVICE_nGnRE      0x1

I.e., masking *and* comparing with the latter matches on the former,
and we have been getting lucky merely because the S2 device mappings
also have the PTE_UXN bit set, or we would misidentify memory mappings
as device mappings.

Since the unmap_range() code path (which contains one instance of the
flawed test) is used both for HYP mappings and stage-2 mappings, and
considering the difference between the two, it is non-trivial to fix
this by rewriting the tests in place, as it would involve passing
down the type of mapping through all the functions.

However, since HYP mappings and stage-2 mappings both deal with host
physical addresses, we can simply check whether the mapping is backed
by memory that is managed by the host kernel, and only perform the
D-cache maintenance if this is the case.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Pavel Fedin <p.fedin@samsung.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---

Resending since I failed to cc the lists the first time around, only
difference is the added tags.

 arch/arm/kvm/mmu.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 6984342da13d..7dace909d5cf 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -98,6 +98,11 @@ static void kvm_flush_dcache_pud(pud_t pud)
 	__kvm_flush_dcache_pud(pud);
 }
 
+static bool kvm_is_device_pfn(unsigned long pfn)
+{
+	return !pfn_valid(pfn);
+}
+
 /**
  * stage2_dissolve_pmd() - clear and flush huge PMD entry
  * @kvm:	pointer to kvm structure.
@@ -213,7 +218,7 @@ static void unmap_ptes(struct kvm *kvm, pmd_t *pmd,
 			kvm_tlb_flush_vmid_ipa(kvm, addr);
 
 			/* No need to invalidate the cache for device mappings */
-			if ((pte_val(old_pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
+			if (!kvm_is_device_pfn(__phys_to_pfn(addr)))
 				kvm_flush_dcache_pte(old_pte);
 
 			put_page(virt_to_page(pte));
@@ -305,8 +310,7 @@ static void stage2_flush_ptes(struct kvm *kvm, pmd_t *pmd,
 
 	pte = pte_offset_kernel(pmd, addr);
 	do {
-		if (!pte_none(*pte) &&
-		    (pte_val(*pte) & PAGE_S2_DEVICE) != PAGE_S2_DEVICE)
+		if (!pte_none(*pte) && !kvm_is_device_pfn(__phys_to_pfn(addr)))
 			kvm_flush_dcache_pte(*pte);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 }
@@ -1037,11 +1041,6 @@ static bool kvm_is_write_fault(struct kvm_vcpu *vcpu)
 	return kvm_vcpu_dabt_iswrite(vcpu);
 }
 
-static bool kvm_is_device_pfn(unsigned long pfn)
-{
-	return !pfn_valid(pfn);
-}
-
 /**
  * stage2_wp_ptes - write protect PMD range
  * @pmd:	pointer to pmd entry
-- 
1.9.1

