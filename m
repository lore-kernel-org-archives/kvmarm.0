From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 4/6] KVM: ARM: extend __coherent_cache_guest_page
Date: Fri,  6 Mar 2015 13:52:31 -0500
Message-ID: <1425667953-3566-5-git-send-email-drjones@redhat.com>
References: <1425667780-3449-1-git-send-email-drjones@redhat.com>
 <1425667953-3566-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 617F347FCF
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:46:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EWNHmjAj1Vzb for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 13:46:39 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E50A547FAC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:46:38 -0500 (EST)
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

Also support only invalidating, rather than always invalidate+clear.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm/include/asm/kvm_mmu.h   | 7 +++++--
 arch/arm/kvm/mmu.c               | 2 +-
 arch/arm64/include/asm/kvm_mmu.h | 7 +++++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index fd801e96fdd3c..a1c7f554f5de8 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -176,7 +176,8 @@ static inline void *kvm_get_hwpgd(struct kvm *kvm)
 
 struct kvm;
 
-#define kvm_flush_dcache_to_poc(a,l)	__cpuc_flush_dcache_area((a), (l))
+#define kvm_flush_dcache_to_poc(a,l)		__cpuc_flush_dcache_area((a), (l))
+#define kvm_invalidate_cache_to_poc(a,l)	dmac_unmap_area((a), (l), 0)
 
 static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 {
@@ -184,7 +185,7 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 }
 
 static inline void __coherent_cache_guest_page(pfn_t pfn, unsigned long size,
-					       bool need_flush)
+					       bool need_flush, bool invalidate)
 {
 	/*
 	 * If we are going to insert an instruction page and the icache is
@@ -214,6 +215,8 @@ static inline void __coherent_cache_guest_page(pfn_t pfn, unsigned long size,
 
 		if (need_flush)
 			kvm_flush_dcache_to_poc(va, PAGE_SIZE);
+		if (invalidate)
+			kvm_invalidate_cache_to_poc(va, PAGE_SIZE);
 
 		if (icache_is_pipt())
 			__cpuc_coherent_user_range((unsigned long)va,
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 781afc712871c..2f3a6581b9200 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1158,7 +1158,7 @@ static void coherent_cache_guest_page(struct kvm_vcpu *vcpu, pfn_t pfn,
 				      unsigned long size, bool uncached)
 {
 	bool need_flush = uncached || !vcpu_has_cache_enabled(vcpu);
-	__coherent_cache_guest_page(pfn, size, need_flush);
+	__coherent_cache_guest_page(pfn, size, need_flush, false);
 }
 
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 56a976c776bc2..e1090ad70133d 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -257,7 +257,8 @@ static inline bool kvm_page_empty(void *ptr)
 
 struct kvm;
 
-#define kvm_flush_dcache_to_poc(a,l)	__flush_dcache_area((a), (l))
+#define kvm_flush_dcache_to_poc(a,l)		__flush_dcache_area((a), (l))
+#define kvm_invalidate_cache_to_poc(a,l)	__dma_unmap_area((a), (l), 0)
 
 static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 {
@@ -265,12 +266,14 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 }
 
 static inline void __coherent_cache_guest_page(pfn_t pfn, unsigned long size,
-					       bool need_flush)
+					       bool need_flush, bool invalidate)
 {
 	void *va = page_address(pfn_to_page(pfn));
 
 	if (need_flush)
 		kvm_flush_dcache_to_poc(va, size);
+	if (invalidate)
+		kvm_invalidate_cache_to_poc(va, size);
 
 	if (!icache_is_aliasing()) {		/* PIPT */
 		flush_icache_range((unsigned long)va,
-- 
1.8.3.1
