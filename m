From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 3/6] KVM: ARM: change __coherent_cache_guest_page interface
Date: Fri,  6 Mar 2015 13:52:30 -0500
Message-ID: <1425667953-3566-4-git-send-email-drjones@redhat.com>
References: <1425667780-3449-1-git-send-email-drjones@redhat.com>
 <1425667953-3566-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E68A847FE9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:46:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VRJIYA-QmKjO for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 13:46:38 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6506C47FCA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:46:37 -0500 (EST)
In-Reply-To: <1425667953-3566-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org
Cc: pbonzini@redhat.com, lersek@redhat.com, catalin.marinas@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Remove the vcpu parameter. We can do this by doing the same
query in the caller of __coherent_cache_guest_page, and then
folding the result into its ipa_uncached parameter, which we
rename to need_flush.

A later patch will add a new caller for __coherent_cache_guest_page
that does not have a vcpu parameter.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/include/asm/kvm_mmu.h   | 7 ++-----
 arch/arm/kvm/mmu.c               | 3 ++-
 arch/arm64/include/asm/kvm_mmu.h | 7 +++----
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 37ca2a4c6f094..fd801e96fdd3c 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -183,9 +183,8 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 	return (vcpu->arch.cp15[c1_SCTLR] & 0b101) == 0b101;
 }
 
-static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu, pfn_t pfn,
-					       unsigned long size,
-					       bool ipa_uncached)
+static inline void __coherent_cache_guest_page(pfn_t pfn, unsigned long size,
+					       bool need_flush)
 {
 	/*
 	 * If we are going to insert an instruction page and the icache is
@@ -205,8 +204,6 @@ static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu, pfn_t pfn,
 	 * and iterate over the range.
 	 */
 
-	bool need_flush = !vcpu_has_cache_enabled(vcpu) || ipa_uncached;
-
 	VM_BUG_ON(size & PAGE_MASK);
 
 	if (!need_flush && !icache_is_pipt())
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index a806e8cecc01b..781afc712871c 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1157,7 +1157,8 @@ void kvm_arch_mmu_write_protect_pt_masked(struct kvm *kvm,
 static void coherent_cache_guest_page(struct kvm_vcpu *vcpu, pfn_t pfn,
 				      unsigned long size, bool uncached)
 {
-	__coherent_cache_guest_page(vcpu, pfn, size, uncached);
+	bool need_flush = uncached || !vcpu_has_cache_enabled(vcpu);
+	__coherent_cache_guest_page(pfn, size, need_flush);
 }
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 6458b53731421..56a976c776bc2 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -264,13 +264,12 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 	return (vcpu_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
 }
 
-static inline void __coherent_cache_guest_page(struct kvm_vcpu *vcpu, pfn_t pfn,
-					       unsigned long size,
-					       bool ipa_uncached)
+static inline void __coherent_cache_guest_page(pfn_t pfn, unsigned long size,
+					       bool need_flush)
 {
 	void *va = page_address(pfn_to_page(pfn));
 
-	if (!vcpu_has_cache_enabled(vcpu) || ipa_uncached)
+	if (need_flush)
 		kvm_flush_dcache_to_poc(va, size);
 
 	if (!icache_is_aliasing()) {		/* PIPT */
-- 
1.8.3.1
