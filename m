Return-Path: <SRS0=jSi8=UD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B4EC28CC3
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 13:33:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F139324AF5
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 13:33:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F139324AF5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8066A4A4F8;
	Tue,  4 Jun 2019 09:33:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D4cAS32SnBsx; Tue,  4 Jun 2019 09:33:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C52374A50F;
	Tue,  4 Jun 2019 09:33:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20BA24A50A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 09:33:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xq0yGTlfTimU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jun 2019 09:33:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43D424A4A3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 09:33:43 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC0AFA78;
 Tue,  4 Jun 2019 06:33:42 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3CC9D3F690;
 Tue,  4 Jun 2019 06:33:42 -0700 (PDT)
From: Christoffer Dall <christoffer.dall@arm.com>
To: kvm@vger.kernel.org
Subject: [PATCH v3 1/4] KVM: x86: Move mmu_memory_cache functions to common
 code
Date: Tue,  4 Jun 2019 15:33:33 +0200
Message-Id: <20190604133336.22226-2-christoffer.dall@arm.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190604133336.22226-1-christoffer.dall@arm.com>
References: <20190604133336.22226-1-christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, James Hogan <jhogan@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Anshuman Khandual <anshuman.khandual@arm.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

We are currently duplicating the mmu memory cache functionality quite
heavily between the architectures that support KVM.  As a first step,
move the x86 implementation (which seems to have the most recently
maintained version of the mmu memory cache) to common code.

We introduce an arch-specific kvm_types.h which can be used to
define the architecture-specific GFP flags for allocating memory to the
memory cache, and to specify how many objects are required in the memory
cache.  These are the two points where the current implementations
diverge across architectures.  Since kvm_host.h defines structures with
fields of the memcache object, we define the memcache structure in
kvm_types.h, and we include the architecture-specific kvm_types.h to
know the size of object in kvm_host.h.

We only define the functions and data types if
KVM_ARCH_WANT_MMU_MEMORY_CACHE is defined, because not all architectures
require the mmu memory cache.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm/include/asm/kvm_types.h     |  5 +++
 arch/arm64/include/asm/kvm_types.h   |  6 +++
 arch/mips/include/asm/kvm_types.h    |  5 +++
 arch/powerpc/include/asm/kvm_types.h |  5 +++
 arch/s390/include/asm/kvm_types.h    |  5 +++
 arch/x86/include/asm/kvm_host.h      | 11 -----
 arch/x86/include/asm/kvm_types.h     | 11 +++++
 arch/x86/kvm/mmu.c                   | 59 ---------------------------
 include/linux/kvm_host.h             | 11 +++++
 include/linux/kvm_types.h            | 13 ++++++
 virt/kvm/kvm_main.c                  | 60 ++++++++++++++++++++++++++++
 11 files changed, 121 insertions(+), 70 deletions(-)
 create mode 100644 arch/arm/include/asm/kvm_types.h
 create mode 100644 arch/arm64/include/asm/kvm_types.h
 create mode 100644 arch/mips/include/asm/kvm_types.h
 create mode 100644 arch/powerpc/include/asm/kvm_types.h
 create mode 100644 arch/s390/include/asm/kvm_types.h
 create mode 100644 arch/x86/include/asm/kvm_types.h

diff --git a/arch/arm/include/asm/kvm_types.h b/arch/arm/include/asm/kvm_types.h
new file mode 100644
index 000000000000..bc389f82e88d
--- /dev/null
+++ b/arch/arm/include/asm/kvm_types.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARM_KVM_TYPES_H
+#define _ASM_ARM_KVM_TYPES_H
+
+#endif /* _ASM_ARM_KVM_TYPES_H */
diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
new file mode 100644
index 000000000000..d0987007d581
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_types.h
@@ -0,0 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARM64_KVM_TYPES_H
+#define _ASM_ARM64_KVM_TYPES_H
+
+#endif /* _ASM_ARM64_KVM_TYPES_H */
+
diff --git a/arch/mips/include/asm/kvm_types.h b/arch/mips/include/asm/kvm_types.h
new file mode 100644
index 000000000000..5efeb32a5926
--- /dev/null
+++ b/arch/mips/include/asm/kvm_types.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_MIPS_KVM_TYPES_H
+#define _ASM_MIPS_KVM_TYPES_H
+
+#endif /* _ASM_MIPS_KVM_TYPES_H */
diff --git a/arch/powerpc/include/asm/kvm_types.h b/arch/powerpc/include/asm/kvm_types.h
new file mode 100644
index 000000000000..f627eceaa314
--- /dev/null
+++ b/arch/powerpc/include/asm/kvm_types.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_KVM_TYPES_H
+#define _ASM_POWERPC_KVM_TYPES_H
+
+#endif /* _ASM_POWERPC_KVM_TYPES_H */
diff --git a/arch/s390/include/asm/kvm_types.h b/arch/s390/include/asm/kvm_types.h
new file mode 100644
index 000000000000..b66a81f8a354
--- /dev/null
+++ b/arch/s390/include/asm/kvm_types.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_S390_KVM_TYPES_H
+#define _ASM_S390_KVM_TYPES_H
+
+#endif /* _ASM_S390_KVM_TYPES_H */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 450d69a1e6fa..85d54aff72ec 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -180,8 +180,6 @@ enum {
 
 #include <asm/kvm_emulate.h>
 
-#define KVM_NR_MEM_OBJS 40
-
 #define KVM_NR_DB_REGS	4
 
 #define DR6_BD		(1 << 13)
@@ -239,15 +237,6 @@ enum {
 
 struct kvm_kernel_irq_routing_entry;
 
-/*
- * We don't want allocation failures within the mmu code, so we preallocate
- * enough memory for a single page fault in a cache.
- */
-struct kvm_mmu_memory_cache {
-	int nobjs;
-	void *objects[KVM_NR_MEM_OBJS];
-};
-
 /*
  * the pages used as guest page table on soft mmu are tracked by
  * kvm_memory_slot.arch.gfn_track which is 16 bits, so the role bits used
diff --git a/arch/x86/include/asm/kvm_types.h b/arch/x86/include/asm/kvm_types.h
new file mode 100644
index 000000000000..ef35a627f69e
--- /dev/null
+++ b/arch/x86/include/asm/kvm_types.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_KVM_TYPES_H
+#define _ASM_X86_KVM_TYPES_H
+
+#define KVM_ARCH_WANT_MMU_MEMORY_CACHE
+
+#define KVM_NR_MEM_OBJS 40
+
+#define KVM_MMU_CACHE_GFP_FLAGS		__GFP_ACCOUNT
+
+#endif /* _ASM_X86_KVM_TYPES_H */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1e9ba81accba..79cf345e5d7c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -971,56 +971,6 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 }
 
-static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
-				  struct kmem_cache *base_cache, int min)
-{
-	void *obj;
-
-	if (cache->nobjs >= min)
-		return 0;
-	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		obj = kmem_cache_zalloc(base_cache, GFP_KERNEL_ACCOUNT);
-		if (!obj)
-			return cache->nobjs >= min ? 0 : -ENOMEM;
-		cache->objects[cache->nobjs++] = obj;
-	}
-	return 0;
-}
-
-static int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *cache)
-{
-	return cache->nobjs;
-}
-
-static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
-				  struct kmem_cache *cache)
-{
-	while (mc->nobjs)
-		kmem_cache_free(cache, mc->objects[--mc->nobjs]);
-}
-
-static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
-				       int min)
-{
-	void *page;
-
-	if (cache->nobjs >= min)
-		return 0;
-	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
-		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
-		if (!page)
-			return cache->nobjs >= min ? 0 : -ENOMEM;
-		cache->objects[cache->nobjs++] = page;
-	}
-	return 0;
-}
-
-static void mmu_free_memory_cache_page(struct kvm_mmu_memory_cache *mc)
-{
-	while (mc->nobjs)
-		free_page((unsigned long)mc->objects[--mc->nobjs]);
-}
-
 static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 {
 	int r;
@@ -1047,15 +997,6 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 				mmu_page_header_cache);
 }
 
-static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
-{
-	void *p;
-
-	BUG_ON(!mc->nobjs);
-	p = mc->objects[--mc->nobjs];
-	return p;
-}
-
 static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
 {
 	return mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 79fa4426509c..819b95e090f6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -790,6 +790,17 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_reload_remote_mmus(struct kvm *kvm);
 
+#ifdef KVM_ARCH_WANT_MMU_MEMORY_CACHE
+int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
+			   struct kmem_cache *base_cache, int min);
+int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *cache);
+void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
+			   struct kmem_cache *cache);
+int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache, int min);
+void mmu_free_memory_cache_page(struct kvm_mmu_memory_cache *mc);
+void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
+#endif
+
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp);
 bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 8bf259dae9f6..6cee379588ee 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -32,6 +32,7 @@ struct kvm_memslots;
 
 enum kvm_mr_change;
 
+#include <asm/kvm_types.h>
 #include <asm/types.h>
 
 /*
@@ -63,4 +64,16 @@ struct gfn_to_hva_cache {
 	struct kvm_memory_slot *memslot;
 };
 
+#ifdef KVM_ARCH_WANT_MMU_MEMORY_CACHE
+/*
+ * We don't want allocation failures within the mmu code, so we preallocate
+ * enough memory for a single page fault in a cache.
+ */
+struct kvm_mmu_memory_cache {
+	int nobjs;
+	void *objects[KVM_NR_MEM_OBJS];
+};
+#endif
+
+
 #endif /* __KVM_TYPES_H__ */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f0d13d9d125d..61cee2052bfd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -290,6 +290,66 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 }
 
+#ifdef KVM_ARCH_WANT_MMU_MEMORY_CACHE
+int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
+			   struct kmem_cache *base_cache, int min)
+{
+	void *obj;
+
+	if (cache->nobjs >= min)
+		return 0;
+	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
+		obj = kmem_cache_zalloc(base_cache, GFP_KERNEL | KVM_MMU_CACHE_GFP_FLAGS);
+		if (!obj)
+			return cache->nobjs >= min ? 0 : -ENOMEM;
+		cache->objects[cache->nobjs++] = obj;
+	}
+	return 0;
+}
+
+int mmu_memory_cache_free_objects(struct kvm_mmu_memory_cache *cache)
+{
+	return cache->nobjs;
+}
+
+void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc,
+			   struct kmem_cache *cache)
+{
+	while (mc->nobjs)
+		kmem_cache_free(cache, mc->objects[--mc->nobjs]);
+}
+
+int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache, int min)
+{
+	void *page;
+
+	if (cache->nobjs >= min)
+		return 0;
+	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
+		page = (void *)__get_free_page(GFP_KERNEL | KVM_MMU_CACHE_GFP_FLAGS);
+		if (!page)
+			return cache->nobjs >= min ? 0 : -ENOMEM;
+		cache->objects[cache->nobjs++] = page;
+	}
+	return 0;
+}
+
+void mmu_free_memory_cache_page(struct kvm_mmu_memory_cache *mc)
+{
+	while (mc->nobjs)
+		free_page((unsigned long)mc->objects[--mc->nobjs]);
+}
+
+void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
+{
+	void *p;
+
+	BUG_ON(!mc->nobjs);
+	p = mc->objects[--mc->nobjs];
+	return p;
+}
+#endif
+
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
 	struct page *page;
-- 
2.18.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
