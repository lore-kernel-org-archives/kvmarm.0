From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH v2 1/4] KVM: x86: Move mmu_memory_cache functions to common
 code
Date: Thu, 31 Jan 2019 10:52:41 +0100
Message-ID: <20190131095244.7480-2-christoffer.dall@arm.com>
References: <20190131095244.7480-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC2534A2AC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 04:52:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qUH7q7181aeU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Jan 2019 04:52:54 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C3624A37D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 04:52:52 -0500 (EST)
In-Reply-To: <20190131095244.7480-1-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, James Hogan <jhogan@kernel.org>, Joerg Roedel <joro@8bytes.org>, Anshuman Khandual <anshuman.khandual@arm.com>, Sean Christopherson <sean.j.christopherson@intel.com>, Paul Mackerras <paulus@ozlabs.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

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
 arch/x86/include/asm/kvm_types.h     | 12 ++++++
 arch/x86/kvm/mmu.c                   | 59 ---------------------------
 include/linux/kvm_host.h             | 11 +++++
 include/linux/kvm_types.h            | 13 ++++++
 virt/kvm/kvm_main.c                  | 60 ++++++++++++++++++++++++++++
 11 files changed, 122 insertions(+), 70 deletions(-)
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
index 4660ce90de7f..9f97dcd15097 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -179,8 +179,6 @@ enum {
 
 #include <asm/kvm_emulate.h>
 
-#define KVM_NR_MEM_OBJS 40
-
 #define KVM_NR_DB_REGS	4
 
 #define DR6_BD		(1 << 13)
@@ -238,15 +236,6 @@ enum {
 
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
index 000000000000..5260d751940e
--- /dev/null
+++ b/arch/x86/include/asm/kvm_types.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_KVM_TYPES_H
+#define _ASM_X86_KVM_TYPES_H
+
+#define KVM_ARCH_WANT_MMU_MEMORY_CACHE
+
+#define KVM_NR_MEM_OBJS 40
+
+#define KVM_MMU_CACHE_GFP	GFP_KERNEL
+#define KVM_MMU_CACHE_PAGE_GFP	GFP_KERNEL_ACCOUNT
+
+#endif /* _ASM_X86_KVM_TYPES_H */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ce770b446238..a0bc22f153f1 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -951,56 +951,6 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
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
-		obj = kmem_cache_zalloc(base_cache, GFP_KERNEL);
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
@@ -1027,15 +977,6 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
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
index c38cc5eb7e73..911cf2c75afa 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -739,6 +739,17 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
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
index 5ecea812cb6a..e07b26145ef2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -285,6 +285,66 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
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
+		obj = kmem_cache_zalloc(base_cache, GFP_KERNEL);
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
+		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
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
