From: Andrew Jones <drjones@redhat.com>
Subject: [RFC PATCH 1/4] kvm-all: put kvm_mem_flags to more work
Date: Wed, 18 Mar 2015 15:11:45 -0400
Message-ID: <1426705908-2765-2-git-send-email-drjones@redhat.com>
References: <1426705700-2564-1-git-send-email-drjones@redhat.com>
 <1426705908-2765-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A5DC49191
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:05:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5GjL83ewMVha for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Mar 2015 15:05:18 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C8487491B4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 15:05:17 -0400 (EDT)
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

Currently kvm_mem_flags just translates bools to bits, let's
make it also determine the bools first. This avoids its parameter
list growing each time we add a flag.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 kvm-all.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/kvm-all.c b/kvm-all.c
index 55025cc366992..a1bc05a8d5c5c 100644
--- a/kvm-all.c
+++ b/kvm-all.c
@@ -295,10 +295,14 @@ err:
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
@@ -313,7 +317,10 @@ static int kvm_slot_dirty_pages_log_change(KVMSlot *mem, bool log_dirty)
 
     old_flags = mem->flags;
 
-    flags = (mem->flags & ~mask) | kvm_mem_flags(s, log_dirty, false);
+    flags = mem->flags & ~mask;
+    if (log_dirty) {
+        flags |= KVM_MEM_LOG_DIRTY_PAGES;
+    }
     mem->flags = flags;
 
     /* If nothing changed effectively, no need to issue ioctl */
@@ -643,9 +650,7 @@ static void kvm_set_phys_mem(MemoryRegionSection *section, bool add)
     KVMSlot *mem, old;
     int err;
     MemoryRegion *mr = section->mr;
-    bool log_dirty = memory_region_is_logging(mr);
     bool writeable = !mr->readonly && !mr->rom_device;
-    bool readonly_flag = mr->readonly || memory_region_is_romd(mr);
     hwaddr start_addr = section->offset_within_address_space;
     ram_addr_t size = int128_get64(section->size);
     void *ram = NULL;
@@ -689,7 +694,7 @@ static void kvm_set_phys_mem(MemoryRegionSection *section, bool add)
             (ram - start_addr == mem->ram - mem->start_addr)) {
             /* The new slot fits into the existing one and comes with
              * identical parameters - update flags and done. */
-            kvm_slot_dirty_pages_log_change(mem, log_dirty);
+            kvm_slot_dirty_pages_log_change(mem, memory_region_is_logging(mr));
             return;
         }
 
@@ -722,7 +727,7 @@ static void kvm_set_phys_mem(MemoryRegionSection *section, bool add)
             mem->memory_size = old.memory_size;
             mem->start_addr = old.start_addr;
             mem->ram = old.ram;
-            mem->flags = kvm_mem_flags(s, log_dirty, readonly_flag);
+            mem->flags = kvm_mem_flags(mr);
 
             err = kvm_set_user_memory_region(s, mem);
             if (err) {
@@ -743,7 +748,7 @@ static void kvm_set_phys_mem(MemoryRegionSection *section, bool add)
             mem->memory_size = start_addr - old.start_addr;
             mem->start_addr = old.start_addr;
             mem->ram = old.ram;
-            mem->flags =  kvm_mem_flags(s, log_dirty, readonly_flag);
+            mem->flags =  kvm_mem_flags(mr);
 
             err = kvm_set_user_memory_region(s, mem);
             if (err) {
@@ -767,7 +772,7 @@ static void kvm_set_phys_mem(MemoryRegionSection *section, bool add)
             size_delta = mem->start_addr - old.start_addr;
             mem->memory_size = old.memory_size - size_delta;
             mem->ram = old.ram + size_delta;
-            mem->flags = kvm_mem_flags(s, log_dirty, readonly_flag);
+            mem->flags = kvm_mem_flags(mr);
 
             err = kvm_set_user_memory_region(s, mem);
             if (err) {
@@ -789,7 +794,7 @@ static void kvm_set_phys_mem(MemoryRegionSection *section, bool add)
     mem->memory_size = size;
     mem->start_addr = start_addr;
     mem->ram = ram;
-    mem->flags = kvm_mem_flags(s, log_dirty, readonly_flag);
+    mem->flags = kvm_mem_flags(mr);
 
     err = kvm_set_user_memory_region(s, mem);
     if (err) {
-- 
1.8.3.1
