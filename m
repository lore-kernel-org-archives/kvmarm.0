From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 3/4] memory: add uncached flag
Date: Wed, 18 Mar 2015 15:11:47 -0400
Message-ID: <1426705908-2765-4-git-send-email-drjones@redhat.com>
References: <1426705700-2564-1-git-send-email-drjones@redhat.com>
 <1426705908-2765-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 507DE491B8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:05:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ipRJbHFNz5lj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Mar 2015 15:05:19 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6486649191
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:05:19 -0400 (EDT)
In-Reply-To: <1426705908-2765-1-git-send-email-drjones@redhat.com>
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

Add an 'uncached' flag, which will result in the KVM_MEM_UNCACHED
flag getting set on KVM's corresponding memory slot.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 include/exec/memory.h | 25 +++++++++++++++++++++++++
 kvm-all.c             |  9 +++++++++
 memory.c              | 15 +++++++++++++++
 3 files changed, 49 insertions(+)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 06ffa1d185b93..2a0d016f5fe6d 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -158,6 +158,7 @@ struct MemoryRegion {
     bool rom_device;
     bool warning_printed; /* For reservations */
     bool flush_coalesced_mmio;
+    bool uncached;
     MemoryRegion *alias;
     hwaddr alias_offset;
     int32_t priority;
@@ -778,6 +779,30 @@ void memory_region_set_flush_coalesced(MemoryRegion *mr);
 void memory_region_clear_flush_coalesced(MemoryRegion *mr);
 
 /**
+ * memory_region_set_uncached: Flag this memory region (for e.g. kvm) as
+ *                             typically being mapped uncached.
+ *
+ * @mr: the memory region to be updated.
+ */
+void memory_region_set_uncached(MemoryRegion *mr);
+
+/**
+ * memory_region_clear_uncached: Remove the 'uncached' flag.
+ *
+ * @mr: the memory region to be updated.
+ */
+void memory_region_clear_uncached(MemoryRegion *mr);
+
+/**
+ * memory_region_may_map_uncached: Return the 'uncached' flag, which
+ *                                 indicates the region is typically
+ *                                 mapped uncached.
+ *
+ * @mr: the memory region to check.
+ */
+bool memory_region_may_map_uncached(MemoryRegion *mr);
+
+/**
  * memory_region_add_eventfd: Request an eventfd to be triggered when a word
  *                            is written to a location.
  *
diff --git a/kvm-all.c b/kvm-all.c
index a1bc05a8d5c5c..4c826d0eab37b 100644
--- a/kvm-all.c
+++ b/kvm-all.c
@@ -126,6 +126,7 @@ bool kvm_gsi_routing_allowed;
 bool kvm_gsi_direct_mapping;
 bool kvm_allowed;
 bool kvm_readonly_mem_allowed;
+bool kvm_uncached_mem_allowed;
 bool kvm_vm_attributes_allowed;
 
 static const KVMCapabilityInfo kvm_required_capabilites[] = {
@@ -306,6 +307,9 @@ static int kvm_mem_flags(MemoryRegion *mr)
     if (readonly && kvm_readonly_mem_allowed) {
         flags |= KVM_MEM_READONLY;
     }
+    if (memory_region_may_map_uncached(mr) && kvm_uncached_mem_allowed) {
+        flags |= KVM_MEM_UNCACHED;
+    }
     return flags;
 }
 
@@ -1595,6 +1599,11 @@ static int kvm_init(MachineState *ms)
         (kvm_check_extension(s, KVM_CAP_READONLY_MEM) > 0);
 #endif
 
+#ifdef KVM_CAP_UNCACHED_MEM
+    kvm_uncached_mem_allowed =
+        (kvm_check_extension(s, KVM_CAP_UNCACHED_MEM) > 0);
+#endif
+
     kvm_eventfds_allowed =
         (kvm_check_extension(s, KVM_CAP_IOEVENTFD) > 0);
 
diff --git a/memory.c b/memory.c
index ee3f2a8a954ef..495cec1b6650c 100644
--- a/memory.c
+++ b/memory.c
@@ -1549,6 +1549,21 @@ void memory_region_clear_flush_coalesced(MemoryRegion *mr)
     }
 }
 
+void memory_region_set_uncached(MemoryRegion *mr)
+{
+    mr->uncached = true;
+}
+
+void memory_region_clear_uncached(MemoryRegion *mr)
+{
+    mr->uncached = false;
+}
+
+bool memory_region_may_map_uncached(MemoryRegion *mr)
+{
+    return mr->uncached;
+}
+
 void memory_region_add_eventfd(MemoryRegion *mr,
                                hwaddr addr,
                                unsigned size,
-- 
1.8.3.1
