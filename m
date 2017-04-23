From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 16/79] kvm: arm/arm64: Rework gpa callback handlers
Date: Sun, 23 Apr 2017 19:08:26 +0200
Message-ID: <20170423170929.27334-17-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01C4149C6F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1Po4AFUgZlvF for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:07:03 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93C3F49C65
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:07:02 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id r190so50446966wme.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:09:48 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Suzuki K Poulose <suzuki.poulose@arm.com>

In order to perform an operation on a gpa range, we currently iterate
over each page in a user memory slot for the given range. This is
inefficient while dealing with a big range (e.g, a VMA), especially
while unmaping a range. At present, with stage2 unmap on a range with
a hugepage backed region, we clear the PMD when we unmap the first
page in the loop. The remaining iterations simply traverse the page table
down to the PMD level only to see that nothing is in there.

This patch reworks the code to invoke the callback handlers on the
biggest range possible within the memory slot to to reduce the number of
times the handler is called.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arch/arm/kvm/mmu.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 962616f..69554bd 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1512,7 +1512,8 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 			     unsigned long start,
 			     unsigned long end,
 			     int (*handler)(struct kvm *kvm,
-					    gpa_t gpa, void *data),
+					    gpa_t gpa, u64 size,
+					    void *data),
 			     void *data)
 {
 	struct kvm_memslots *slots;
@@ -1524,7 +1525,7 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 	/* we only care about the pages that the guest sees */
 	kvm_for_each_memslot(memslot, slots) {
 		unsigned long hva_start, hva_end;
-		gfn_t gfn, gfn_end;
+		gfn_t gpa;
 
 		hva_start = max(start, memslot->userspace_addr);
 		hva_end = min(end, memslot->userspace_addr +
@@ -1532,25 +1533,16 @@ static int handle_hva_to_gpa(struct kvm *kvm,
 		if (hva_start >= hva_end)
 			continue;
 
-		/*
-		 * {gfn(page) | page intersects with [hva_start, hva_end)} =
-		 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
-		 */
-		gfn = hva_to_gfn_memslot(hva_start, memslot);
-		gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
-
-		for (; gfn < gfn_end; ++gfn) {
-			gpa_t gpa = gfn << PAGE_SHIFT;
-			ret |= handler(kvm, gpa, data);
-		}
+		gpa = hva_to_gfn_memslot(hva_start, memslot) << PAGE_SHIFT;
+		ret |= handler(kvm, gpa, (u64)(hva_end - hva_start), data);
 	}
 
 	return ret;
 }
 
-static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
+static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
-	unmap_stage2_range(kvm, gpa, PAGE_SIZE);
+	unmap_stage2_range(kvm, gpa, size);
 	return 0;
 }
 
@@ -1577,10 +1569,11 @@ int kvm_unmap_hva_range(struct kvm *kvm,
 	return 0;
 }
 
-static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, void *data)
+static int kvm_set_spte_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
 	pte_t *pte = (pte_t *)data;
 
+	WARN_ON(size != PAGE_SIZE);
 	/*
 	 * We can always call stage2_set_pte with KVM_S2PTE_FLAG_LOGGING_ACTIVE
 	 * flag clear because MMU notifiers will have unmapped a huge PMD before
@@ -1606,11 +1599,12 @@ void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &stage2_pte);
 }
 
-static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
+static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
 	pmd_t *pmd;
 	pte_t *pte;
 
+	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE);
 	pmd = stage2_get_pmd(kvm, NULL, gpa);
 	if (!pmd || pmd_none(*pmd))	/* Nothing there */
 		return 0;
@@ -1625,11 +1619,12 @@ static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
 	return stage2_ptep_test_and_clear_young(pte);
 }
 
-static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
+static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
 {
 	pmd_t *pmd;
 	pte_t *pte;
 
+	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE);
 	pmd = stage2_get_pmd(kvm, NULL, gpa);
 	if (!pmd || pmd_none(*pmd))	/* Nothing there */
 		return 0;
-- 
2.9.0
