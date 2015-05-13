From: Andrew Jones <drjones@redhat.com>
Subject: [RFC/RFT PATCH v2 2/3] KVM: promote KVM_MEMSLOT_INCOHERENT to uapi
Date: Wed, 13 May 2015 13:31:53 +0200
Message-ID: <1431516714-25816-3-git-send-email-drjones@redhat.com>
References: <1431516714-25816-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CBE9512F8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2015 07:23:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7hVOzjdgvX4H for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 May 2015 07:23:14 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 715A6512F4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 May 2015 07:23:14 -0400 (EDT)
In-Reply-To: <1431516714-25816-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, agraf@suse.de
Cc: catalin.marinas@arm.com, lersek@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Commit 1050dcda30529 introduced KVM_MEMSLOT_INCOHERENT to flag memory
regions that may have coherency issues due to mapping host system RAM
as non-cacheable. This was introduced as a KVM internal flag, but now
give KVM userspace access to it so that it may use it for hinting
likely problematic regions. Also rename to KVM_MEM_UNCACHED.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 Documentation/virtual/kvm/api.txt | 20 ++++++++++++++------
 arch/arm/include/uapi/asm/kvm.h   |  1 +
 arch/arm/kvm/arm.c                |  1 +
 arch/arm/kvm/mmu.c                |  4 ++--
 arch/arm64/include/uapi/asm/kvm.h |  1 +
 include/linux/kvm_host.h          |  1 -
 include/uapi/linux/kvm.h          |  2 ++
 virt/kvm/kvm_main.c               |  7 ++++++-
 8 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 9fa2bf8c3f6f1..04ffd9f5db5f2 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -905,6 +905,7 @@ struct kvm_userspace_memory_region {
 /* for kvm_memory_region::flags */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_UNCACHED	(1UL << 2)
 
 This ioctl allows the user to create or modify a guest physical memory
 slot.  When changing an existing slot, it may be moved in the guest
@@ -920,12 +921,19 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.
 
-The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
-KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
-writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
-use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
-to make a new slot read-only.  In this case, writes to this memory will be
-posted to userspace as KVM_EXIT_MMIO exits.
+The flags field supports the following flags. All flags may be used in
+combination.
+  - KVM_MEM_LOG_DIRTY_PAGES: no capability required
+      Set this to instruct KVM to keep track of writes to memory within
+      the slot. (See the KVM_GET_DIRTY_LOG ioctl)
+  - KVM_MEM_READONLY: depends on capability KVM_CAP_READONLY_MEM
+      Set this to make a new slot read-only. In this case, writes to
+      this memory will be posted to userspace as KVM_EXIT_MMIO exits.
+      EINVAL will be returned if the slot is not new.
+  - KVM_MEM_UNCACHED: depends on capability KVM_CAP_UNCACHED_MEM
+      Set this to make a new slot uncached, i.e. userspace will always
+      directly read/write RAM for this memory region. EINVAL will be
+      returned if the slot is not new.
 
 When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
 the memory region are automatically reflected into the guest.  For example, an
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index df3f60cb1168a..893a331655115 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -26,6 +26,7 @@
 #define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_READONLY_MEM
+#define __KVM_HAVE_UNCACHED_MEM
 
 #define KVM_REG_SIZE(id)						\
 	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index d9631ecddd56e..cbb532de9c8b5 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -182,6 +182,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PSCI_0_2:
 	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_MP_STATE:
+	case KVM_CAP_UNCACHED_MEM:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 1d5accbd3dcf2..bc1665acd73e7 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1307,7 +1307,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (!hugetlb && !force_pte)
 		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
 
-	fault_ipa_uncached = memslot->flags & KVM_MEMSLOT_INCOHERENT;
+	fault_ipa_uncached = memslot->flags & KVM_MEM_UNCACHED;
 
 	if (hugetlb) {
 		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
@@ -1834,7 +1834,7 @@ int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 * regions as incoherent.
 	 */
 	if (slot->flags & KVM_MEM_READONLY)
-		slot->flags |= KVM_MEMSLOT_INCOHERENT;
+		slot->flags |= KVM_MEM_UNCACHED;
 	return 0;
 }
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index d26832022127e..be46855ca01b7 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -38,6 +38,7 @@
 #define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_READONLY_MEM
+#define __KVM_HAVE_UNCACHED_MEM
 
 #define KVM_REG_SIZE(id)						\
 	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ad45054309a0f..74d6a14529f53 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -39,7 +39,6 @@
  * include/linux/kvm_h.
  */
 #define KVM_MEMSLOT_INVALID	(1UL << 16)
-#define KVM_MEMSLOT_INCOHERENT	(1UL << 17)
 
 /* Two fragments for cross MMIO pages. */
 #define KVM_MAX_MMIO_FRAGMENTS	2
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4b60056776d14..ceb6e805e5f77 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -108,6 +108,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_UNCACHED	(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -814,6 +815,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_S390_INJECT_IRQ 113
 #define KVM_CAP_S390_IRQ_STATE 114
 #define KVM_CAP_PPC_HWRNG 115
+#define KVM_CAP_UNCACHED_MEM 116
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 90977418aeb6e..d1d535d80a075 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -719,6 +719,10 @@ static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
 	valid_flags |= KVM_MEM_READONLY;
 #endif
 
+#ifdef __KVM_HAVE_UNCACHED_MEM
+	valid_flags |= KVM_MEM_UNCACHED;
+#endif
+
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
 
@@ -816,7 +820,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		else { /* Modify an existing slot. */
 			if ((mem->userspace_addr != old.userspace_addr) ||
 			    (npages != old.npages) ||
-			    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
+			    ((new.flags ^ old.flags) &
+			     (KVM_MEM_READONLY | KVM_MEM_UNCACHED)))
 				goto out;
 
 			if (base_gfn != old.base_gfn)
-- 
2.1.0
