From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH] kvm: Delete the slot only when KVM_MEM_READONLY flag is
 changed
Date: Wed, 16 May 2018 17:18:34 +0800
Message-ID: <1526462314-19720-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A291240196
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 05:10:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VoDJ6ssvgzL1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 May 2018 05:09:59 -0400 (EDT)
Received: from huawei.com (unknown [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C77E400D4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 05:09:57 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel@nongnu.org, pbonzini@redhat.com, guangrong.xiao@gmail.com
Cc: shannon.zhaosl@gmail.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

According to KVM commit 75d61fbc, it needs to delete the slot before
changing the KVM_MEM_READONLY flag. But QEMU commit 235e8982 only check
whether KVM_MEM_READONLY flag is set instead of changing. It doesn't
need to delete the slot if the KVM_MEM_READONLY flag is not changed.

This fixes a issue that migrating a VM at the OVMF startup stage and
VM is executing the codes in rom. Between the deleting and adding the
slot in kvm_set_user_memory_region, there is a chance that guest access
rom and trap to KVM, then KVM can't find the corresponding memslot.
While KVM (on ARM) injects an abort to guest due to the broken hva, then
guest will get stuck.

Signed-off-by: Shannon Zhao <zhaoshenglong@huawei.com>
---
 include/sysemu/kvm_int.h | 1 +
 kvm-all.c                | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 888557a..f838412 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -20,6 +20,7 @@ typedef struct KVMSlot
     void *ram;
     int slot;
     int flags;
+    int old_flags;
 } KVMSlot;
 
 typedef struct KVMMemoryListener {
diff --git a/kvm-all.c b/kvm-all.c
index 2515a23..de8250e 100644
--- a/kvm-all.c
+++ b/kvm-all.c
@@ -252,7 +252,7 @@ static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot)
     mem.userspace_addr = (unsigned long)slot->ram;
     mem.flags = slot->flags;
 
-    if (slot->memory_size && mem.flags & KVM_MEM_READONLY) {
+    if (slot->memory_size && (mem.flags ^ slot->old_flags) & KVM_MEM_READONLY) {
         /* Set the slot size to 0 before setting the slot to the desired
          * value. This is needed based on KVM commit 75d61fbc. */
         mem.memory_size = 0;
@@ -376,11 +376,11 @@ static int kvm_slot_update_flags(KVMMemoryListener *kml, KVMSlot *mem,
 {
     int old_flags;
 
-    old_flags = mem->flags;
+    mem->old_flags = mem->flags;
     mem->flags = kvm_mem_flags(mr);
 
     /* If nothing changed effectively, no need to issue ioctl */
-    if (mem->flags == old_flags) {
+    if (mem->flags == mem->old_flags) {
         return 0;
     }
 
-- 
2.0.4
