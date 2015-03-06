From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 2/6] KVM: Introduce incoherent cache maintenance API
Date: Fri,  6 Mar 2015 13:52:29 -0500
Message-ID: <1425667953-3566-3-git-send-email-drjones@redhat.com>
References: <1425667780-3449-1-git-send-email-drjones@redhat.com>
 <1425667953-3566-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E846E47FD9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:46:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uiNwGlxMC31D for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 13:46:37 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F0E7A47F41
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:46:36 -0500 (EST)
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

Add two new memslot functions to the API

  kvm_flush_incoherent_memory_regions
    flush all KVM_MEM_INCOHERENT memslot addresses

  kvm_invalidate_incoherent_memory_regions
    invalidate all KVM_MEM_INCOHERENT memslot addresses

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 include/linux/kvm_host.h | 14 ++++++++++++++
 virt/kvm/kvm_main.c      | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9dfb519c51e5b..2bdbeeb1b2704 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -517,6 +517,8 @@ int kvm_set_memory_region(struct kvm *kvm,
 			  struct kvm_userspace_memory_region *mem);
 int __kvm_set_memory_region(struct kvm *kvm,
 			    struct kvm_userspace_memory_region *mem);
+void kvm_flush_incoherent_memory_regions(struct kvm *kvm);
+void kvm_invalidate_incoherent_memory_regions(struct kvm *kvm);
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 			   struct kvm_memory_slot *dont);
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
@@ -705,6 +707,18 @@ static inline bool kvm_arch_has_noncoherent_dma(struct kvm *kvm)
 }
 #endif
 
+#ifdef __KVM_HAVE_INCOHERENT_MEM
+void kvm_arch_flush_incoherent(struct kvm *kvm, struct kvm_memory_slot *slot);
+void kvm_arch_invalidate_incoherent(struct kvm *kvm, struct kvm_memory_slot *slot);
+#else
+void kvm_arch_flush_incoherent(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+}
+void kvm_arch_invalidate_incoherent(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+}
+#endif
+
 static inline wait_queue_head_t *kvm_arch_vcpu_wq(struct kvm_vcpu *vcpu)
 {
 #ifdef __KVM_HAVE_ARCH_WQP
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 449c1c9ee68b4..96f44c57b8808 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -716,7 +716,7 @@ static void update_memslots(struct kvm_memslots *slots,
 
 static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
 {
-	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
+	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_INCOHERENT;
 
 #ifdef __KVM_HAVE_READONLY_MEM
 	valid_flags |= KVM_MEM_READONLY;
@@ -960,6 +960,49 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 	return kvm_set_memory_region(kvm, mem);
 }
 
+static inline bool memory_region_is_incoherent(struct kvm_memory_slot *slot)
+{
+	return slot && slot->id < KVM_USER_MEM_SLOTS
+		&& !(slot->flags & KVM_MEMSLOT_INVALID)
+		&& slot->flags & KVM_MEM_INCOHERENT;
+}
+
+void kvm_flush_incoherent_memory_regions(struct kvm *kvm)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *slot;
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+
+	kvm_for_each_memslot(slot, slots) {
+		if (!memory_region_is_incoherent(slot))
+			continue;
+		kvm_arch_flush_incoherent(kvm, slot);
+	}
+	srcu_read_unlock(&kvm->srcu, idx);
+}
+EXPORT_SYMBOL_GPL(kvm_flush_incoherent_memory_regions);
+
+void kvm_invalidate_incoherent_memory_regions(struct kvm *kvm)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *slot;
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+
+	kvm_for_each_memslot(slot, slots) {
+		if (slot->flags & KVM_MEM_READONLY)
+			continue;
+		if (!memory_region_is_incoherent(slot))
+			continue;
+		kvm_arch_invalidate_incoherent(kvm, slot);
+	}
+	srcu_read_unlock(&kvm->srcu, idx);
+}
+EXPORT_SYMBOL_GPL(kvm_invalidate_incoherent_memory_regions);
+
 int kvm_get_dirty_log(struct kvm *kvm,
 			struct kvm_dirty_log *log, int *is_dirty)
 {
-- 
1.8.3.1
