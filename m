From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 3/6] kvm-all: put kvm_mem_flags to more work
Date: Fri,  6 Mar 2015 13:53:35 -0500
Message-ID: <1425668018-3649-4-git-send-email-drjones@redhat.com>
References: <1425667780-3449-1-git-send-email-drjones@redhat.com>
 <1425668018-3649-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D02E4801A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:47:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5rQ-CemfPsMg for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Mar 2015 13:47:41 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C8FB24800A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Mar 2015 13:47:41 -0500 (EST)
In-Reply-To: <1425668018-3649-1-git-send-email-drjones@redhat.com>
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

Currently kvm_mem_flags just translates bools to bits, let's
make it also determine the bools first. This avoids its parameter
list growing each time we add a flag.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
Posted this, as it makes sense without this series.
http://lists.gnu.org/archive/html/qemu-devel/2015-03/msg01225.html

 kvm-all.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/kvm-all.c b/kvm-all.c
index 05a79c20e0bba..507fa7204e062 100644
--- a/kvm-all.c
+++ b/kvm-all.c
@@ -294,10 +294,14 @@ err:
  * dirty pages logging control
  */
 
-static int kvm_mem_flags(KVMState *s, bool log_dirty, bool readonly)
+static int kvm_mem_flags(MemoryRegion *mr)
 {
+    bool readonly = mr->readonly || memory_region_is_romd(mr);
     int flags = 0;
-    flags = log_dirty ? KVM_MEM_LOG_DIRTY_PAGES : 0;
+
+    if (memory_region_is_logging(mr)) {
+        flags |= KVM_MEM_LOG_DIRTY_PAGES;
+    }
     if (readonly && kvm_readonly_mem_allowed) {
         flags |= KVM_MEM_READONLY;
     }
@@ -312,7 +316,10 @@ static int kvm_slot_dirty_pages_log_change(KVMSlot *mem, bool log_dirty)
 
     old_flags = mem->flags;
 
-    flags = (mem->flags & ~mask) | kvm_mem_flags(s, log_dirty, false);
+    flags = mem->flags & ~mask;
+    if (log_dirty) {
+        flags |= KVM_MEM_LOG_DIRTY_PAGES;
+    }
     mem->flags = flags;
 
     /* If nothing changed effectively, no need to issue ioctl */
@@ -642,9 +649,7 @@ static void kvm_set_phys_mem(MemoryRegionSection *section, bool add)
     KVMSlot *mem, old;
     int err;
     MemoryRegion *mr = section->mr;
-    bool log_dirty = memory_region_is_logging(mr);
     bool writeable = !mr->readonly && !mr->rom_device;
-    bool readonly_flag = mr->readonly || memory_region_is_romd(mr);
     hwaddr start_addr = section->offset_within_address_space;
     ram_addr_t size = int128_get64(section->size);
     void *ram = NULL;
@@ -688,7 +693,7 @@ static void kvm_set_phys_mem(MemoryRegionSection *section, bool add)
             (ram - start_addr == mem->ram - mem->start_addr)) {
             /* The new slot fits into the existing one and comes with
              * identical parameters - update flags and done. */
-            kvm_slot_dirty_pages_log_change(mem, log_dirty);
+            kvm_slot_dirty_pages_log_change(mem, memory_region_is_logging(mr));
             return;
         }
 
@@ -721,7 +726,7 @@ static void kvm_set_phys_mem(MemoryRegionSection *section, bool add)
             mem->memory_size = old.memory_size;
             mem->start_addr = old.start_addr;
             mem->ram = old.ram;
-            mem->flags = kvm_mem_flags(s, log_dirty, readonly_flag);
+            mem->flags = kvm_mem_flags(mr);
 
             err = kvm_set_user_memory_region(s, mem);
             if (err) {
@@ -742,7 +747,7 @@ static void kvm_set_phys_mem(MemoryRegionSection *section, bool add)
             mem->memory_size = start_addr - old.start_addr;
             mem->start_addr = old.start_addr;
             mem->ram = old.ram;
-            mem->flags =  kvm_mem_flags(s, log_dirty, readonly_flag);
+            mem->flags =  kvm_mem_flags(mr);
 
             err = kvm_set_user_memory_region(s, mem);
             if (err) {
@@ -766,7 +771,7 @@ static void kvm_set_phys_mem(MemoryRegionSection *section, bool add)
             size_delta = mem->start_addr - old.start_addr;
             mem->memory_size = old.memory_size - size_delta;
             mem->ram = old.ram + size_delta;
-            mem->flags = kvm_mem_flags(s, log_dirty, readonly_flag);
+            mem->flags = kvm_mem_flags(mr);
 
             err = kvm_set_user_memory_region(s, mem);
             if (err) {
@@ -788,7 +793,7 @@ static void kvm_set_phys_mem(MemoryRegionSection *section, bool add)
     mem->memory_size = size;
     mem->start_addr = start_addr;
     mem->ram = ram;
-    mem->flags = kvm_mem_flags(s, log_dirty, readonly_flag);
+    mem->flags = kvm_mem_flags(mr);
 
     err = kvm_set_user_memory_region(s, mem);
     if (err) {
-- 
1.8.3.1
