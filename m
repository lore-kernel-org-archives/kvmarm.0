From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 1/3] KVM: promote KVM_MEMSLOT_INCOHERENT to uapi
Date: Wed, 18 Mar 2015 15:10:31 -0400
Message-ID: <1426705833-2679-2-git-send-email-drjones@redhat.com>
References: <1426705700-2564-1-git-send-email-drjones@redhat.com>
 <1426705833-2679-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 330C0491A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:04:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AYDZW+hNCIzc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Mar 2015 15:04:05 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5AD9A49195
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:04:04 -0400 (EDT)
In-Reply-To: <1426705833-2679-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, ard.biesheuvel@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com
Cc: catalin.marinas@arm.com, lersek@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Also rename to KVM_MEM_UNCACHED.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 Documentation/virtual/kvm/api.txt | 16 ++++++++++------
 arch/arm/include/uapi/asm/kvm.h   |  1 +
 arch/arm/kvm/arm.c                |  1 +
 arch/arm/kvm/mmu.c                |  4 ++--
 arch/arm64/include/uapi/asm/kvm.h |  1 +
 include/linux/kvm_host.h          |  1 -
 include/uapi/linux/kvm.h          |  2 ++
 virt/kvm/kvm_main.c               |  7 ++++++-
 8 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 0007fef4ed814..a5a51403a7937 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -902,6 +902,7 @@ struct kvm_userspace_memory_region {
 /* for kvm_memory_region::flags */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_UNCACHED	(1UL << 2)
 
 This ioctl allows the user to create or modify a guest physical memory
 slot.  When changing an existing slot, it may be moved in the guest
@@ -917,12 +918,15 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
 be identical.  This allows large pages in the guest to be backed by large
 pages in the host.
 
-The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
-KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
-writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
-use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
-to make a new slot read-only.  In this case, writes to this memory will be
-posted to userspace as KVM_EXIT_MMIO exits.
+The flags field supports three flags: KVM_MEM_LOG_DIRTY_PAGES,
+KVM_MEM_READONLY, and KVM_MEM_UNCACHED.  The first can be set to instruct
+KVM to keep track of writes to memory within the slot.  See KVM_GET_DIRTY_LOG
+ioctl to know how to use it.  The second can be set, if KVM_CAP_READONLY_MEM
+capability allows it, to make a new slot read-only.  In this case, writes to
+this memory will be posted to userspace as KVM_EXIT_MMIO exits. The third can
+be set, if the KVM_CAP_UNCACHED_MEM capability allows it. This remaps the
+memory as uncached, i.e. userspace will always directly read/write RAM for
+this memory region.
 
 When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
 the memory region are automatically reflected into the guest.  For example, an
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 09ee408c1a676..9d6fc19acf8a2 100644
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
index c9e6ef1f7403a..8d4c08f238cf0 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -180,6 +180,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PSCI:
 	case KVM_CAP_ARM_PSCI_0_2:
 	case KVM_CAP_READONLY_MEM:
+	case KVM_CAP_UNCACHED_MEM:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index bcc1b3ad2adce..719931e83c468 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1260,7 +1260,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (!hugetlb && !force_pte)
 		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
 
-	fault_ipa_uncached = memslot->flags & KVM_MEMSLOT_INCOHERENT;
+	fault_ipa_uncached = memslot->flags & KVM_MEM_UNCACHED;
 
 	if (hugetlb) {
 		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
@@ -1792,7 +1792,7 @@ int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 * regions as incoherent.
 	 */
 	if (slot->flags & KVM_MEM_READONLY)
-		slot->flags |= KVM_MEMSLOT_INCOHERENT;
+		slot->flags |= KVM_MEM_UNCACHED;
 	return 0;
 }
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 8e38878c87c61..5553d112e405b 100644
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
index 3b934cc94cc83..9dfb519c51e5b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -43,7 +43,6 @@
  * include/linux/kvm_h.
  */
 #define KVM_MEMSLOT_INVALID	(1UL << 16)
-#define KVM_MEMSLOT_INCOHERENT	(1UL << 17)
 
 /* Two fragments for cross MMIO pages. */
 #define KVM_MAX_MMIO_FRAGMENTS	2
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a37fd1224f363..4781fc00cd746 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -108,6 +108,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_UNCACHED	(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -753,6 +754,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_PPC_FIXUP_HCALL 103
 #define KVM_CAP_PPC_ENABLE_HCALL 104
 #define KVM_CAP_CHECK_EXTENSION_VM 105
+#define KVM_CAP_UNCACHED_MEM 107
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 59bc56e577b2d..6d63ceb6324d9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -723,6 +723,10 @@ static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
 	valid_flags |= KVM_MEM_READONLY;
 #endif
 
+#ifdef __KVM_HAVE_UNCACHED_MEM
+	valid_flags |= KVM_MEM_UNCACHED;
+#endif
+
 	if (mem->flags & ~valid_flags)
 		return -EINVAL;
 
@@ -820,7 +824,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		else { /* Modify an existing slot. */
 			if ((mem->userspace_addr != old.userspace_addr) ||
 			    (npages != old.npages) ||
-			    ((new.flags ^ old.flags) & KVM_MEM_READONLY))
+			    ((new.flags ^ old.flags) &
+			     (KVM_MEM_READONLY | KVM_MEM_UNCACHED)))
 				goto out;
 
 			if (base_gfn != old.base_gfn)
-- 
1.8.3.1
