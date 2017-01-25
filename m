From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/3] arm/arm64: KVM: Enforce unconditional flush to PoC when
 mapping to stage-2
Date: Wed, 25 Jan 2017 15:36:29 +0000
Message-ID: <1485358591-12278-2-git-send-email-marc.zyngier@arm.com>
References: <1485358591-12278-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61EBB40064
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jan 2017 10:36:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aVm4fswjgg7A for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Jan 2017 10:36:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E3944018B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Jan 2017 10:36:28 -0500 (EST)
In-Reply-To: <1485358591-12278-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

When we fault in a page, we flush it to the PoC (Point of Coherency)
if the faulting vcpu has its own caches off, so that it can observe
the page we just brought it.

But if the vcpu has its caches on, we skip that step. Bad things
happen when *another* vcpu tries to access that page with its own
caches disabled. At that point, there is no garantee that the
data has made it to the PoC, and we access stale data.

The obvious fix is to always flush to PoC when a page is faulted
in, no matter what the state of the vcpu is.

Cc: stable@vger.kernel.org
Fixes: 2d58b733c876 ("arm64: KVM: force cache clean on page fault when caches are off")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_mmu.h   | 9 +--------
 arch/arm64/include/asm/kvm_mmu.h | 3 +--
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 74a44727..a58bbaa 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -150,18 +150,12 @@ static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
 	 * and iterate over the range.
 	 */
 
-	bool need_flush = !vcpu_has_cache_enabled(vcpu) || ipa_uncached;
-
 	VM_BUG_ON(size & ~PAGE_MASK);
 
-	if (!need_flush && !icache_is_pipt())
-		goto vipt_cache;
-
 	while (size) {
 		void *va = kmap_atomic_pfn(pfn);
 
-		if (need_flush)
-			kvm_flush_dcache_to_poc(va, PAGE_SIZE);
+		kvm_flush_dcache_to_poc(va, PAGE_SIZE);
 
 		if (icache_is_pipt())
 			__cpuc_coherent_user_range((unsigned long)va,
@@ -173,7 +167,6 @@ static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
 		kunmap_atomic(va);
 	}
 
-vipt_cache:
 	if (!icache_is_pipt() && !icache_is_vivt_asid_tagged()) {
 		/* any kind of VIPT cache */
 		__flush_icache_all();
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6f72fe8..6d22017 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -241,8 +241,7 @@ static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu,
 {
 	void *va = page_address(pfn_to_page(pfn));
 
-	if (!vcpu_has_cache_enabled(vcpu) || ipa_uncached)
-		kvm_flush_dcache_to_poc(va, size);
+	kvm_flush_dcache_to_poc(va, size);
 
 	if (!icache_is_aliasing()) {		/* PIPT */
 		flush_icache_range((unsigned long)va,
-- 
2.1.4
