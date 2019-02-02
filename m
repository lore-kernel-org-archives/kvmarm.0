From: lantianyu1986@gmail.com
Subject: [PATCH V2 7/10] KVM: Add kvm_get_memslot() to get memslot via slot id
Date: Sat,  2 Feb 2019 09:38:23 +0800
Message-ID: <20190202013825.51261-8-Tianyu.Lan@microsoft.com>
References: <20190202013825.51261-1-Tianyu.Lan@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190202013825.51261-1-Tianyu.Lan@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Lan Tianyu <Tianyu.Lan@microsoft.com>, christoffer.dall@arm.com, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, jhogan@kernel.org, ralf@linux-mips.org, paul.burton@mips.com, paulus@ozlabs.org, benh@kernel.crashing.org, mpe@ellerman.id.au, pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, michael.h.kelley@microsoft.com, kys@microsoft.com, vkuznets@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Lan Tianyu <Tianyu.Lan@microsoft.com>

This patch is to add kvm_get_memslot() to get struct kvm_memory_slot
via slot it and remove redundant codes. The function will also be used
in the following changes.

Signed-off-by: Lan Tianyu <Tianyu.Lan@microsoft.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 45 +++++++++++++++++++--------------------------
 2 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c38cc5eb7e73..aaa2b57eeb19 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -758,6 +758,7 @@ int kvm_get_dirty_log_protect(struct kvm *kvm,
 			      struct kvm_dirty_log *log, bool *flush);
 int kvm_clear_dirty_log_protect(struct kvm *kvm,
 				struct kvm_clear_dirty_log *log, bool *flush);
+struct kvm_memory_slot *kvm_get_memslot(struct kvm *kvm, u32 slot);
 
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 					struct kvm_memory_slot *slot,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7ebe36a13045..b2097fa4b618 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1095,22 +1095,30 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 	return kvm_set_memory_region(kvm, mem);
 }
 
+struct kvm_memory_slot *kvm_get_memslot(struct kvm *kvm, u32 slot)
+{
+	struct kvm_memslots *slots;
+	int as_id, id;
+
+	as_id = slot >> 16;
+	id = (u16)slot;
+	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
+		return NULL;
+
+	slots = __kvm_memslots(kvm, as_id);
+	return id_to_memslot(slots, id);
+}
+
 int kvm_get_dirty_log(struct kvm *kvm,
 			struct kvm_dirty_log *log, int *is_dirty)
 {
-	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
-	int i, as_id, id;
 	unsigned long n;
 	unsigned long any = 0;
+	int i;
 
-	as_id = log->slot >> 16;
-	id = (u16)log->slot;
-	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
-		return -EINVAL;
+	memslot = kvm_get_memslot(kvm, log->slot);
 
-	slots = __kvm_memslots(kvm, as_id);
-	memslot = id_to_memslot(slots, id);
 	if (!memslot->dirty_bitmap)
 		return -ENOENT;
 
@@ -1154,20 +1162,13 @@ EXPORT_SYMBOL_GPL(kvm_get_dirty_log);
 int kvm_get_dirty_log_protect(struct kvm *kvm,
 			struct kvm_dirty_log *log, bool *flush)
 {
-	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
-	int i, as_id, id;
 	unsigned long n;
 	unsigned long *dirty_bitmap;
 	unsigned long *dirty_bitmap_buffer;
+	int i;
 
-	as_id = log->slot >> 16;
-	id = (u16)log->slot;
-	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
-		return -EINVAL;
-
-	slots = __kvm_memslots(kvm, as_id);
-	memslot = id_to_memslot(slots, id);
+	memslot = kvm_get_memslot(kvm, log->slot);
 
 	dirty_bitmap = memslot->dirty_bitmap;
 	if (!dirty_bitmap)
@@ -1225,24 +1226,16 @@ EXPORT_SYMBOL_GPL(kvm_get_dirty_log_protect);
 int kvm_clear_dirty_log_protect(struct kvm *kvm,
 				struct kvm_clear_dirty_log *log, bool *flush)
 {
-	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
-	int as_id, id;
 	gfn_t offset;
 	unsigned long i, n;
 	unsigned long *dirty_bitmap;
 	unsigned long *dirty_bitmap_buffer;
 
-	as_id = log->slot >> 16;
-	id = (u16)log->slot;
-	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
-		return -EINVAL;
-
 	if ((log->first_page & 63) || (log->num_pages & 63))
 		return -EINVAL;
 
-	slots = __kvm_memslots(kvm, as_id);
-	memslot = id_to_memslot(slots, id);
+	memslot = kvm_get_memslot(kvm, log->slot);
 
 	dirty_bitmap = memslot->dirty_bitmap;
 	if (!dirty_bitmap)
-- 
2.14.4
