From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [RFC 3/4] KVM: arm/arm64: Refactor Stage2 PMD hugepages support
Date: Wed, 10 Jan 2018 19:07:28 +0000
Message-ID: <20180110190729.18383-4-punit.agrawal@arm.com>
References: <20180110190729.18383-1-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180110190729.18383-1-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: Punit Agrawal <punit.agrawal@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, suzuki.poulose@arm.com, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Refactor the stage2 PMD hugepages support to split out constructing the
PMD into a separate function. A similar pattern of code will be followed
when introducing PUD hugepages at stage 2 where we need to split support
between architecure specific and common code.

There is no functional change with this patch.

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 02eefda5d71e..f02219a91b19 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1282,6 +1282,17 @@ static void kvm_send_hwpoison_signal(unsigned long address,
 	send_sig_info(SIGBUS, &info, current);
 }
 
+static pmd_t stage2_build_pmd(kvm_pfn_t pfn, pgprot_t mem_type, bool writable)
+{
+	pmd_t pmd = pfn_pmd(pfn, mem_type);
+
+	pmd = pmd_mkhuge(pmd);
+	if (writable)
+		pmd = kvm_s2pmd_mkwrite(pmd);
+
+	return pmd;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  unsigned long fault_status)
@@ -1386,12 +1397,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
 
 	if (hugetlb) {
-		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
-		new_pmd = pmd_mkhuge(new_pmd);
-		if (writable) {
-			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
+		pmd_t new_pmd = stage2_build_pmd(pfn, mem_type, writable);
+
+		if (writable)
 			kvm_set_pfn_dirty(pfn);
-		}
+
 		coherent_cache_guest_page(vcpu, pfn, PMD_SIZE);
 		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
 	} else {
-- 
2.15.1
